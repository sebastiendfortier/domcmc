"""
Get West-East and North-South winds from UU and VV
==========================================================

  For this example we read a standard file with UU=0 and VV=10kts everywhere.

  These wind components along the model grid get rotated by fst_tools
  such that West-East and South-North components are outputted 
  The wind modulus and direction are also outputted.

  In this example, it is demonstrated that the East-West and South-North wind wind 
  vectors align perfectly well with the model grid indicating no problem with the 
  rotation of wind vectors. 
   
"""
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import cartopy.crs as ccrs
import cartopy.feature as cfeature

# load domcmc
import domcmc.fst_tools as fst_tools

# load my other tools
import domutils.geo_tools as geo_tools




def main():

    fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016070600_000_uu_vv_hrdps_grid_constant_wind.fst'
    tmp_dir = '/space/hall3/sitestore/eccc/mrd/rpndat/dja001/tmpdir'

    #var_name="wind_vectors" reads in UU and VV and rotates the vectors to get
    #wind in the West-East and South-North dirtection are outputted
    #as well as modulus and direction
    wind_dict = fst_tools.get_data(file_name=fst_file, var_name='wind_vectors', 
                                   tmp_dir=tmp_dir)

    longitudes       = wind_dict['lon' ] #2D longitudes [deg]
    latitudes        = wind_dict['lat' ] #2D latitudes  [deg]
    wind_we          = wind_dict['uuwe'] #West-East wind component (m/s)
    wind_sn          = wind_dict['vvsn'] #South-North wind component(m/s)
    wind_modulus     = wind_dict['uv'  ] #wind speed (kts)
    wind_direction   = wind_dict['wd'  ] #South-North wind component(m/s)

    #you can verify that
    #wind_direction = np.rad2deg(np.arctan2(wind_we, wind_sn)+180.)

    #
    #resample data for a less crowded figure
    dxy = 200  
    data_longitudes =     longitudes[::dxy,::dxy]
    data_latitudes  =      latitudes[::dxy,::dxy]
    wind_we         =        wind_we[::dxy,::dxy] * 1.94384 * 0. + 10.#conversion from m/s to kts for wind barbs
    wind_sn         =        wind_sn[::dxy,::dxy] * 1.94384 * 0. + 10.#conversion from m/s to kts for wind barbs
    wind_modulus    =   wind_modulus[::dxy,::dxy] 
    wind_direction  = wind_direction[::dxy,::dxy] 

    #
    #PlateCarree for handling lat/lon data
    crs_platecarree   = ccrs.PlateCarree()

    # Full HRDPS grid
    ratio = 0.7
    pole_latitude=35.7
    pole_longitude=65.5
    lat_0 = 48.8
    delta_lat = 10.
    lon_0 = 266.00
    delta_lon = 40.
    map_extent=[lon_0-delta_lon, lon_0+delta_lon, lat_0-delta_lat, lat_0+delta_lat]  
    crs_rotatedpole = ccrs.RotatedPole(pole_latitude=pole_latitude, pole_longitude=pole_longitude)

    #get x/y coords in geoaxes coordinates
    xy_crs = crs_rotatedpole.transform_points(crs_platecarree, data_longitudes, data_latitudes)
    xx_crs = xy_crs[...,0]
    yy_crs = xy_crs[...,1]

    #instantiate figure
    fig = plt.figure(figsize=(8.5,6.5))

    #axes for this figure
    ax = fig.add_axes((.01, .01, .98, .65), projection=crs_rotatedpole)


    # 
    #plot blue lines along y-axis of the data grid 
    #those serve as reference for the expected direction of the wind
    color = 'cornflowerblue'
    lw = .9
    for ii in np.arange(0, xx_crs.shape[0]):
        ax.plot(xx_crs[ii,:], yy_crs[ii,:],  linewidth=lw, c=color, transform=crs_rotatedpole, zorder=10 )
    #proxy artist for legend
    grid_lines = mlines.Line2D([], [], linewidth=lw, color=color, label='Data Grid')


    #
    #red longitudinal lines 
    color = 'deeppink'
    lw = .4
    gl = ax.gridlines(crs=crs_platecarree, draw_labels=False,
                      linewidth=lw, color=color, linestyle='--', zorder=10)
    gl.ylines        = False
    #proxy artist for legend
    lon_lines = mlines.Line2D([], [], linewidth=lw, color=color, linestyle='--', label='Longitudes')


    #
    #add features
    lw = .4
    ax.add_feature(cfeature.STATES.with_scale('50m'),    linewidth=lw, edgecolor=np.array([202.,202.,202.])/255.,zorder=1)
    ax.add_feature(cfeature.BORDERS.with_scale('50m'),   linewidth=lw, edgecolor=np.array([202.,202.,202.])/255.,zorder=1)
    ax.add_feature(cfeature.COASTLINE.with_scale('50m'), linewidth=lw, edgecolor=np.array([202.,202.,202.])/255.,zorder=1)


    #In principle you would use matplotlib wind barbs routine 
    #but as of cartopy 0.18 there is a bug affecting the direction of wind barbs 
    ##
    #plot wind barbs
    #ax.barbs(data_longitudes, data_latitudes, wind_we, wind_sn, length=6.0,
    #         sizes=dict(emptybarb=0.25, spacing=0.0, height=0.4),
    #         linewidth=0.5, transform=crs_platecarree, color = 'black', zorder=10000)



    #
    #plot my own wind direction for verification, this one works without problem
    #first compute destination of wind vectors (end point of arrows)
    circle_radius = np.full_like(data_latitudes, 300.)  #arrow length in km
    dest_lons, dest_lats = geo_tools.lat_lon_range_az(lon1_in   =   data_longitudes, 
                                                      lat1_in   =   data_latitudes,
                                                      range_in  =   circle_radius,
                                                      azimuth_in=   wind_direction+180.)    #+180 to get direction wind is going to
    #get x/y coords in geoaxes coordinates
    xy_crs = crs_rotatedpole.transform_points(crs_platecarree, dest_lons, dest_lats)
    xx_dest_crs = xy_crs[...,0]
    yy_dest_crs = xy_crs[...,1]

    #plot arrows, the [1:-1] is to avoidovercrowding the figure
    for xx_src, yy_src, xx_dst, yy_dst in zip(xx_crs[:,1:-1].flat, 
                                              yy_crs[:,1:-1].flat, 
                                              xx_dest_crs[:,1:-1].flat, 
                                              yy_dest_crs[:,1:-1].flat):

        color = 'darkorange'
        lw = 1.5
        ax.annotate("",
                    xy=(xx_src, yy_src),       xycoords='data',
                    xytext=(xx_dst, yy_dst), textcoords='data',
                    arrowprops=dict(arrowstyle="<-", color=color, linewidth=lw,
                    connectionstyle="arc3"), zorder=20 )

    #line for legend
    verif_lines = mlines.Line2D([], [], linewidth=lw, color=color, label='Wind direction')

    #legend
    ax.legend(handles=[grid_lines, lon_lines, verif_lines], prop={'size': 18}, 
              loc='lower left', bbox_to_anchor=(0.1, 1.1))

    
    
    #uncomment to save figure
    #plt.savefig('plot_cst_winds.svg')

if __name__ == '__main__':
    main()

