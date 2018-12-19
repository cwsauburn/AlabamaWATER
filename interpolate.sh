#!/bin/sh
# interpolate soil moisture into SMAP grid
module load ncl

# Attention!This date can't step over one month. For example, Nov30-Dec02
startdate=20181215 
enddate=20181215

#Generate weight file, it should be generated once for this scripts if origional and destinal grid are not changed.
 export GETENV0="conserve" 
 export SRCGN0="20181210.t01z.land.f001.clip.conus.nc"
 export DSTGN0="20150402T103000_Vv4030_001_HEGOUT.nc"
 ncl WM2SMAP_genWgts_ACTACF.ncl

until [ "$startdate" -gt "$enddate" ]
do  
      filedate=""$startdate"*"
      export SRCFN0=$filedate
      export DSTGN0="20150402T103000_Vv4030_001_HEGOUT.nc"
      
      #For short range soil moisture forecast interpolation
      ncl NWM2SMAP_regridder_ACTACF_short.ncl  
      
      #For medium range soil moisture forecast interpolation
      ncl NWM2SMAP_regridder_ACTACF_medi.ncl  
      
      #For long range soil moisture forecast interpolation
      ncl NWM2SMAP_regridder_ACTACF_long.ncl  

     startdate=$(($startdate+1))
done
