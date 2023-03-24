

Get first matching entry in "standard" file
----------------------------------------------------------

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> p0 = fst_tools.get_data(file_name=fst_file, var_name='P0')
>>>
>>> print(p0.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(p0['values'].shape)
(328, 278)


Get entry at a specific validity date
--------------------------------------

There are two ways to specify the validity date of the entries you are looking for:


 - First with a Python datetime object:

>>> import domcmc.fst_tools as fst_tools
>>> import datetime
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>  
>>> #datetime object
>>> dt = datetime.datetime(2016, 8, 12, 6, 10, 0, tzinfo=datetime.timezone.utc)
>>>
>>> p0 = fst_tools.get_data(file_name=fst_file, var_name='P0', datev=dt)
>>>
>>> print(p0.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(p0['values'].shape)
(328, 278)

 - Second with with a CMC timestamp

>>> p0 = fst_tools.get_data(file_name=fst_file, var_name='P0', datev=412062350)
>>>
>>> print(p0.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(p0['values'].shape)
(328, 278)


Get lat/lon of grid
------------------------------------------

Use the _latlon_ keyword to get latitudes and longitudes of the 2D grid 
associated with a given entry in the standard file. 

In this example, 'lat' and 'lon' are 2D numpy arrays of latitudes and longitudes 
associated with the grid of the P0 entry.

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> p0 = fst_tools.get_data(file_name=fst_file, var_name='P0', latlon=True)
>>>
>>> print(p0['lat'].shape, p0['lon'].shape)
(328, 278) (328, 278)



Get 3D array
------------------------------------------

Reading 3D arrays is automatic.

If entries with the same meta-data but with different IP1's are found, they are
read, ordered and stacked vertically into a 3D array. 

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> uu = fst_tools.get_data(file_name=fst_file, var_name='UU', latlon=True)
>>>
>>> print(uu.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'lat', 'lon'])
>>> print(uu['values'].shape)
(328, 278, 81)

Get only certain vertical levels
---------------------------------------------------------------------

It is possible to specify a list of IP1's using the *ip1* keyword to
read only certain levels of a given variable. 

In all cases, the *ip1_list* entry of the output dictionary contains the list
of IP1 associated with the 3D array being returned. 


>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>> #list of IP1's
>>> ip1_input = [75597472, 95258609, 95237745, 95011105, 94859092, 94831040]
>>>
>>> vv = fst_tools.get_data(file_name=fst_file, var_name='VV', ip1=ip1_input, latlon=True)
>>>
>>> print(vv.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'lat', 'lon'])
>>> # we get a 3D array with 6 vertical levels.
>>> print(vv['values'].shape)
(328, 278, 6)
>>> # those are the IP1's of the returned 3D array
>>> print(vv['ip1_list'])
[75597472, 95258609, 95237745, 95011105, 94859092, 94831040]

Note that even with a list of ip1s, output levels get sorted 
from lowest to highest

>>> # note the 75597472 level at the end
>>> ip1_input = [ 95258609, 94859092, 95011105, 95237745, 94831040, 75597472]
>>> vv = fst_tools.get_data(file_name=fst_file, var_name='VV', ip1=ip1_input, latlon=True)
>>> 
>>> # the 75597472 is the lowest level and appears at the bottom of the returned array.
>>> print(vv['ip1_list'])
[75597472, 95258609, 95237745, 95011105, 94859092, 94831040]


Get pressure 
-----------------------------------------------------------

You can get pressure associated with the different vertical levels using 
the *pres_from_var* keyword. 

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> hu = fst_tools.get_data(file_name=fst_file, var_name='HU', pres_from_var=True)
>>> print(hu.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'pressure'])
>>>
>>> #HU is a 3D field
>>> print(hu['values'].shape)
(328, 278, 81)
>>>
>>> #this is the pressure on the same 3D grid
>>> print(hu['pressure'].shape)
(328, 278, 81)


Interpolate data on pressure levels
----------------------------------------------------------------

Here, we get TT field interpolated at 800, 500 and 200 hPa.

Returned 'values' is a 3D array where k=0 indicates the lowest level (here 800 hPa).
The interpolation is done with: pxs2pxt (https://wiki.cmc.ec.gc.ca/wiki/Pxs2pxt) so it 
must be available in environment. 
This will already be the case if you installed domcmc through conda. 

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> # if the fst file is large, you may run out of space in $TMPDIR and 
>>> # get weird errors. 
>>> # In this case use tmp_dir=/path/to/big/temporary/directory/ in your call to get_data
>>> 
>>> tt = fst_tools.get_data(file_name=fst_file, var_name='TT', pres_levels=[800,500,200])
>>>
>>> print(tt.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(tt['values'].shape)
(328, 278, 3)
>>> #lev_list is the list of levels decoded from ip1 values
>>> print(tt['lev_list'])
[800.0, 500.0, 200.0]


Get zonal and meridional wind components from UU and VV
----------------------------------------------------------

UU and VV (knots) are along the model grid and are not very useable
without programs that know what to do with them. Zonal and meridional winds
will be more usefull for plotting with Python or sharing data with the outside
world.

Calling *get_data* with varname="wind_vectors" will read in UU and VV and 
output:
- UUWE the zonal (West-East) component of the wind in meters per seconds
- VVSN the meridional (South-North) component of the wind in meters per seconds
- UV  the modulus (wind speed) of the wind vector in knots
- WD  the meteorological wind direction in degrees

>>> import domcmc.fst_tools as fst_tools
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016081200_006_0001'
>>>
>>> wind_dict = fst_tools.get_data(file_name=fst_file, var_name='wind_vectors')
>>>
>>> # get UU, VV, UUWE, VVSN, UV, WD
>>>  #lat/lon are necessary to the wind rotation and are also outputted
>>> print(wind_dict.keys())
dict_keys(['meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'lat', 'lon', 'uu', 'vv', 'uuwe', 'vvsn', 'uv', 'wd'])
>>>
>>> #all are 3D arrays
>>> print(wind_dict['uuwe'].shape)
(328, 278, 81)
>>>
>>> #You can verify the equivalence between the two vector representation
>>> import numpy as np
>>> uv0   = wind_dict['uv'][0,0,0]
>>> wd0   = wind_dict['wd'][0,0,0]
>>> uuwe0 = wind_dict['uuwe'][0,0,0]
>>> vvsn0 = wind_dict['vvsn'][0,0,0]
>>> # + 180 because wd is the direction where wind is comming from while
>>> # uuwe/vvsn point in the direction the wind is going to
>>> print(np.isclose(wd0, np.rad2deg(np.arctan2(uuwe0, vvsn0))+180.))
True
>>> #uv is in knots while uuwe and vvse are in m/s,
>>> # the multiplication by  0.5144 convert knots to m/s
>>> print(np.isclose(uv0* 0.514444, np.sqrt(uuwe0**2. + vvsn0**2.)))
True



Yin-Yang grid 
--------------------------------------------

The Yin-Yang grid can be represented in different ways in standard files. 


Sometimes, both the Yin and Yang grids are combined and appear as single entries in 
standard files. 
In these cases, the *get_data* method will separate the Yin and Yang grids for you. 
In the following example, look for the "yin" and "yang" entries that appear in the output 
dictionary. Each comes with its own values, meta data and lat/lon. 

For convenience, the "regular" values, meta data and lat/lon are set to those of the Yin grid. 

>>> import domcmc.fst_tools as fst_tools
>>> import datetime
>>> fst_file = '/home/dja001/shared_stuff/files/test_data_for_domcmc/2016122900_yinyang_example.fst'
>>> dt = datetime.datetime(2016, 12, 29, 0, 0, 0, tzinfo=datetime.timezone.utc)
>>>
>>> pr = fst_tools.get_data(file_name=fst_file, var_name='PR', datev=dt, latlon=True)
>>>
>>> # Note the yin and yang entries in this dictionary
>>> print(pr.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'yin', 'yang', 'combined_yy_grid', 'lat', 'lon'])
>>>
>>> # the "values", "lat", "lon" and other entries are those of the Yin grid
>>> print(id(pr['values']) == id(pr['yin']['values']))
True
>>>
>>> #data on the Yin grid
>>> print(pr['yin'].keys())
dict_keys(['meta', 'toctoc', 'ip1_list', 'lev_list', 'grid', 'values', 'lat', 'lon'])
>>>
>>> #data on the Yang grid
>>> print(pr['yang'].keys())
dict_keys(['meta', 'toctoc', 'ip1_list', 'lev_list', 'grid', 'values', 'lat', 'lon'])





Automatic file finding
-------------------------------------------------

It is often the case that a directory will contain many standard files, each containing entries
at different validity times. 

Because of the different naming conventions found at the CMC, it
then becomes cumbersome to figure out which file contains the desired entries at a given validity 
time. To address this problem you can specify only a directory and a validity time. 
All standard files in the directory will be searched for the desired entry. 

>>> import domcmc.fst_tools as fst_tools
>>> import datetime
>>>
>>> #directory and validity time
>>> fst_dir = '/home/dja001/shared_stuff/files/test_data_for_domcmc/'
>>> dt = datetime.datetime(2016, 8, 12, 6, 20, 0, tzinfo=datetime.timezone.utc)
>>> 
>>> pr = fst_tools.get_data(dir_name=fst_dir, var_name='PR', datev=dt)
>>> 
>>> print(pr.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(pr['values'].shape)
(324, 274)

For large directories containing many standard files, use the prefix and/or suffix keywords arguments to 
restrict the search and speedup things. 
In the following example, only files matching 2016081200*0001 will be searched.

>>> pr2 = fst_tools.get_data(dir_name=fst_dir, prefix='2016081200', suffix='0001', var_name='PR', datev=dt)
>>>
>>> print(pr2.keys())
dict_keys(['values', 'meta', 'grid', 'toctoc', 'ip1_list', 'lev_list'])
>>> print(pr2['values'].shape)
(324, 274)


Combining everything
-------------------------------------------------

The different features of *fst_tools* can all be combined together

In this example, we get the zonal and meridional wind components of the wind 
at 500 hPa from a standard file containing yin-yang UU and VV on hybrid levels.
The file is automatically found from a directory and a suffix.

>>> import domcmc.fst_tools as fst_tools
>>> import datetime
>>>
>>> #directory and validity time
>>> fst_dir = '/home/dja001/shared_stuff/files/test_data_for_domcmc/'
>>> dt = datetime.datetime(2017, 1, 12, 15, 0, 0, tzinfo=datetime.timezone.utc)
>>>
>>> wind_500  = fst_tools.get_data(dir_name=fst_dir, datev=dt, var_name='wind_vectors',
...                                 pres_levels = [500], suffix='yygrid_uu_vv.fst')
>>>
>>> print(wind_500.keys())
dict_keys(['meta', 'grid', 'toctoc', 'ip1_list', 'lev_list', 'yin', 'yang', 'combined_yy_grid', 'lat', 'lon', 'uu', 'vv', 'uuwe', 'vvsn', 'uv', 'wd'])
>>> 
>>> #wind on Yin grid
>>> print(wind_500['yin'].keys())
dict_keys(['meta', 'toctoc', 'ip1_list', 'lev_list', 'grid', 'lat', 'lon', 'uu', 'vv', 'uuwe', 'vvsn', 'uv', 'wd'])
>>> print(wind_500['yin']['uv'].shape)
(799, 267)
>>>
>>> #wind on Yang grid
>>> print(wind_500['yang'].keys())
dict_keys(['meta', 'toctoc', 'ip1_list', 'lev_list', 'grid', 'lat', 'lon', 'uu', 'vv', 'uuwe', 'vvsn', 'uv', 'wd'])
>>> print(wind_500['yang']['uv'].shape)
(799, 267)







