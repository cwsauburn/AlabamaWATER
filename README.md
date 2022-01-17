# National Water Model forecast download and extracted
National Water Model (NWM) forecast assessment in ACT&ACF basin, and part of AL, the paper is published

This repository contains three main scripts, download SMAP data, download NWM channel and land forecast, extracted the NWM forecast.
Before running these scripts, edit the path in the scripts with your own path, set the download date if necessary. 

The steps:
1. Run bash script to download NWM forecast from NOAA https://www.nco.ncep.noaa.gov/pmb/products/nwm/.  The scripts are downloadNWM_*.sh
2. Run bash script trigger_clip_ncl_script.sh to launch clip_saved_NWM_reach_output.ncl and clip_saved_NWM_land_output.ncl 

Note: The short and medium range download scripts should be updated with http path, because ftp path didn't work anymore.
