
!This routine is not used as I found that Stephane already had a similar interface
!for rotating winds along the grid of a fst file

!still, I keep it here as it may serve as a template for future fortran code
!that I may have to include in domcmc 




!calling this fortran routine from Python:
!-------------------------------------------------------------
!    #make a uniform "wind" field with 0 u-component and 1kts v-component
!    #along the model grid
!    #ctypes and asfortranarray are necessary to use fortran shared object
!    ll_shape = lats.shape
!    u_1d    = np.asfortranarray( np.zeros(ll_shape).flat, dtype=np.float32)
!    v_1d    = np.asfortranarray(  np.ones(ll_shape).flat, dtype=np.float32)
!    lats_1d = np.asfortranarray(lats.flat, dtype=np.float32)
!    lons_1d = np.asfortranarray(lons.flat, dtype=np.float32)
!    npts    = ctypes.c_long(lats.size) 
!    cxlat1  = ctypes.c_float(np.float(xlat1)) 
!    cxlon1  = ctypes.c_float(np.float(xlon1)) 
!    cxlat2  = ctypes.c_float(np.float(xlat2)) 
!    cxlon2  = ctypes.c_float(np.float(xlon2)) 
!
!    #prepare entries for use by fortran routine
!    nd_to_c = np.ctypeslib.ndpointer(dtype=np.float32, ndim=1, flags='F_CONTIGUOUS')
!    long_ptr = ctypes.POINTER(ctypes.c_long)
!    double_ptr = ctypes.POINTER(ctypes.c_float)
!
!    so_file = '/home/dja001/python/packages/domcmc_package/bin/src/wind_rotation.so'
!
!    shared_obj = ctypes.cdll.LoadLibrary(so_file)
!    shared_obj.c_rot_wind.argtypes = [nd_to_c, nd_to_c, nd_to_c, nd_to_c, long_ptr,
!                                      double_ptr, double_ptr, double_ptr, double_ptr]
!    shared_obj.c_rot_wind.restypes = None
!
!    #u_1d and v_1d are changed in place by the call to fortran routine
!    shared_obj.c_rot_wind(u_1d, v_1d, lats_1d, lons_1d, npts, 
!                       cxlat1, cxlon1, cxlat2, cxlon2)
!    rotation only depends on lat/lon of point 
!    the same rotation is applied to all levels
!    make a view that matches shape of UU and VV
!
!    #back to 2D if this is what we had to start with
!    if lats.ndim == 2:
!        rot_angle = rot_angle.reshape(ll_shape)
!
!    #if UU and VV are 3D, stack 2d rotation matrix to match
!    if UU.ndim == 3:
!        rot_angle = np.broadcast_to(rot_angle[...,np.newaxis], UU.shape)

module wind_rotation


    use, intrinsic :: iso_c_binding  

    implicit none

    public sp, dp, hp
    integer, parameter :: sp=kind(0.),   &          ! double precision
                          dp=kind(0.d0), &          ! double precision
                          hp=selected_real_kind(15) ! high precision

    contains
    
    subroutine c_rot_wind(u_1d, v_1d, lats_1d, lons_1d, nbpts, &
                          xlat1, xlon1, xlat2, xlon2 ) bind(c, name='c_rot_wind')

        !-------------------------------------------------------------
        !Transform (rotated) U/V from model grid to E-W/N-S components
        !-------------------------------------------------------------
        ! allocation of memory for inout variables is done on the Python side 

        !adapted to Python script by Dominik 
        !30/10/2020
        !
        !Original code by Monique Tanguay
        !07/02/2019
        !
        !Based on wind_rot2ll by Chamberland and Desgagne GEM337)
        !
        !arguments
        !u_1d/v_1d    i  - UU and VV         -> Wind's x/y components on model grid
        !u_1d/v_1d    o  - Rotated UU and VV -> Wind's W-E/S-N components
        !lon/lat      i  - Lon/Lat (geographical) of UU and VV
        !nbpts        i  - Number of points
        !xlon*/xlat*  i  - Grid descriptors (real) of input file
        !
        !
        !Note
        !the subroutines called below seem to work only with single precision
        !input. I get garbage with double precision but no error... 

        !input variables
        integer(c_long),            intent(in)    :: nbpts
        real(sp), dimension(nbpts), intent(in)    :: lats_1d, lons_1d
        real(sp),                   intent(in)    :: xlat1, xlon1, xlat2, xlon2

        !output variables are inout and get modified in place
        real(sp), dimension(nbpts), intent(inout) :: u_1d,    v_1d

        !internal
        real(sp), dimension(3,3)     :: rr,ri
        real(sp), dimension(3,nbpts) :: xyz,uvcart
        real(sp), dimension(nbpts)   :: uull,vvll,lon_r,lat_r
        
        !!-------------------------------------------------------------------
        !write(*,*) 'before'
        !write(*,*) 'xlat1, xlon1, xlat2, xlon2', xlat1, xlon1, xlat2, xlon2
        !write(*,*) 'nbpts, u_1d               ', nbpts, u_1d
        !write(*,*) 'nbpts, v_1d               ', nbpts, v_1d
        
        !Get Lon/Lat (rotated) from Lon/Lat (geographical)
        !-------------------------------------------------
        call ez_gfxyfll (lons_1d,lats_1d,lon_r,lat_r,nbpts,xlat1,xlon1,xlat2,xlon2)
        
        !Get rotation matrix and its inverse
        !-----------------------------------
        call ez_crot (rr,ri,xlon1,xlat1,xlon2,xlat2)
        
        !Get UV in rotated Cartesian coordinates
        !---------------------------------------
        call ez_uvacart (xyz,u_1d,v_1d,lon_r,lat_r,nbpts,1)
        
        !Get UV in unrotated Cartesian coordinates
        !-----------------------------------------
        call mxm (ri,3,xyz,3,uvcart,nbpts)
        
        !Get UV in unrotated Tangential coordinates
        !------------------------------------------
        call ez_cartauv (uull,vvll,uvcart,lons_1d,lats_1d,nbpts,1)

        !output
        u_1d = uull
        v_1d = vvll

        !write(*,*) 'after'
        !write(*,*) 'nbpts, u_1d               ', nbpts, u_1d
        !write(*,*) 'nbpts, v_1d               ', nbpts, v_1d
        
        return

        
    end subroutine

    !subroutine c_string_ptr_to_f_string(c_string, f_string)

    !    !takes in a c_byte array and return a fortran string
    !    !
    !    !inspired by:
    !    !from https://stackoverflow.com/questions/41247242/fortran77-iso-c-binding-and-c-string


    !    !in the calling script do:
    !    !  character(c_char), dimension(*),     intent(in)    :: c_string
    !    !  call c_string_ptr_to_f_string(c_string, fst_file)

    !    implicit none

    !    character(c_char), dimension(*), intent(in)  :: c_string
    !    character(len=*),                intent(out) :: f_string
    !    integer :: i
    !    do i = 1, len(f_string)
    !        if (c_string(i) == C_NULL_CHAR) exit
    !        f_string(i:i) = c_string(i)
    !    end do
    !    if (i <= len(f_string)) f_string(i:) = ' '
    !end subroutine

end module


