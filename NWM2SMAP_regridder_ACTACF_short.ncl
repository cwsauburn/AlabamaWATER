;regrid NWM data into SMAP grid for ACT, ACF & AL state 
;Used for short-term NWM forecast regrid into SMAP L4 soil moisture grid

dstGridName = getenv("DSTGN0")
srcfilename = getenv("SRCFN0")

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/ut_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

  ;---------------------------------------------------------------;
  ; Set source and destination grid filenames.                    ;
  ;---------------------------------------------------------------;
  dirm    = "/***Please use your own route***/"              ; directory where source data resides
  outdir  = "/***Please use your own route***/"      ; directory where regridded NWM data will be placed.
  
  if ( .not.isfilepresent( dstGridName ) ) then
     print( " ... source SMAP grid file not found : "+ dstGridName )
     exit 
  end if

  ;---------------------------------------------------------------;
  ; Weight filenames for generating NWM to SMAP_regridding weights     
  ;---------------------------------------------------------------;
  wgtFileName_patch = "./NWM_to_SMAP_weight_patch.nc"
  wgtFileName_conserve = "./NWM_to_SMAP_weight_conserve.nc"
  wgtFileName_bilinear = "./NWM_to_SMAP_weight_bilinear.nc"

  ;---------------------------------------------------------------;
  ; Read SMAP data, destination grid data   
  ;---------------------------------------------------------------;
  dstfile = addfile( dstGridName ,"r")
  dlat1d=dstfile->lat
  dlon1d=dstfile->lon
  dimslat=dimsizes(dlat1d)
  dimslon=dimsizes(dlon1d)
  varname = "SOILSAT_TOP"
  
  ;----------------------------------------------------------------------
  ; Open source data files to be regridded...
  ;----------------------------------------------------------------------
  system("mkdir "+outdir)
  datfils = systemfunc ("ls "+dirm+srcfilename)    ;list of file names
  num_datfils = dimsizes(datfils)

  do ifil = 0,num_datfils-1,1   ; loop through datafiles one at a time
     suffix = isStrSubset( datfils(ifil), ".nc" ) ; check if the input filename has .nc suffix
     if (suffix) then
         datfile = addfile( datfils(ifil), "r")
     else
         print( suffix)
         datfile = addfile( datfils(ifil)+".nc", "r")
     end if
     print( " ... Open input file : "+ datfils(ifil) )

     ;----------------------------------------------------------------------
     ; Create output file
     ;----------------------------------------------------------------------
      na=stringtochar(datfils(ifil))
      ncfile = outdir + na(63:85) + ".regrid" + na(86:99)
      if ( isfilepresent( ncfile ) ) then
         system ("/bin/rm "+ncfile)
      end if       
      ncdf = addfile(ncfile,"c")
     
      dim_names = (/ "lat", "lon"/)
      dim_sizes = (/ dimslat ,  dimslon /) 
      dimUnlim = (/ False,  False /)
      filedimdef( ncdf, dim_names, dim_sizes, dimUnlim )     
      ncdf->lat = dlat1d   ;output lat	  
      ncdf->lon = dlon1d   ;output lon      
      print( " ... Create output file : "+ ncfile)

     ;----------------------------------------------------------------------
     ;  Processing...no further mods should be required...
     ;----------------------------------------------------------------------
      var2d = datfile->$varname$
      wgtFileName = wgtFileName_conserve
;           wgtFileName = wgtFileName_patch    
;           printVarSummary(var)
     
     ;----------------------------------------------------------------------
     ; Define new array and perform regriddding
     ;----------------------------------------------------------------------
      v4 = new((/dimslat, dimslon/),"double")
      ;---Options to pass to ESMF_regrid--------------------;
      opt                = True
      opt@WgtFileName    = wgtFileName
      opt@CopyVarAtts    = True
      opt@CopyVarCoords  = False
      ;---Debug information
      opt@PrintTimings   = True
      opt@Debug          = True
      exist = isfilepresent( wgtFileName )
      if ( .not.exist ) then
         print( " ... no wgtFile. Run WM2SMAP_genWgts_ACTACF.ncl first."+" "+wgtFileName )
         exit
      end if
      
      v4(:,:) = ESMF_regrid_with_weights( rm_single_dims(var2d(:,:)) , wgtFileName, opt)                          

       ;----------------------------------------------------------------------
       ; Export interpolated data to new clipped NWM file...
       ;----------------------------------------------------------------------
       
       ;--- change dimension names so that ncks command works appropriately ---;
       v4!0 = "south_north"
       v4!1 = "west_east"
       
       ncdf->SOILSAT_TOP = v4
       delete([/v4,var2d/])
   end do   ; end do for file loop
end
