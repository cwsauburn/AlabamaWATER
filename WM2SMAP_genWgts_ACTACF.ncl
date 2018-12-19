; ESMF_regrid_gen_weights to generate a weight file using a remapping option specified in the command line.
; Interpolate NWM land model output (soil moisture) to SMAP grid           

;---------------- Specify source data, interpolate method ------------------------------------------------

;interp_opt = conserve / bilinear / patch
 interp_opt = getenv("GETENV0")
 
;srcGridName = filename that contains source grid, but in this script, we use NWM_lon.nc and NWM_lat.nc
 srcGridName = getenv("SRCGN0")
 
;dstGridName = filename that contains destination grid
 dstGridName = getenv("DSTGN0")

 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

    wgtFileName = "./NWM_to_SMAP_weight_"+interp_opt+".nc"  ; Defind weight filename. 

    LonName = "lon"
    LatName = "lat"

    src_file = addfile(srcGridName,"r")
    vNames   = getfilevarnames( src_file )
	
   ;----------------------------------------------------------------------
   ; Convert source grid to a SCRIP convention file.
   ;----------------------------------------------------------------------    
    src_lon = addfile("NWM_lon.nc","r")
    src_lat = addfile("NWM_lat.nc","r")
    slon = src_lon->$LonName$
	  slat = src_lat->$LatName$
	
    Opt                = True
    Opt@SrcRegional    = True
    Opt@ForceOverwrite = True
    Opt@PrintTimings   = True
    Opt@Title          = "NWM"

    src_SCRIP_filename     = "src_NWM2SMAP_"+interp_opt+".nc"
    curvilinear_to_SCRIP( src_SCRIP_filename, slat, slon, Opt)
;---Clean up
    delete(Opt)

   ;----------------------------------------------------------------------
   ; Convert destination grid to a SCRIP convention file.
   ;----------------------------------------------------------------------
    dst_file = addfile(dstGridName,"r")
    dst_lat = dst_file->lat
    dst_lon = dst_file->lon	

    Opt                = True
    Opt@DstRegional    = True
    Opt@ForceOverwrite = True
    Opt@PrintTimings   = True
    Opt@Title          = "SMAP"

    dst_SCRIP_filename     = "dst_NWM2SMAP_"+interp_opt+".nc"
    rectilinear_to_SCRIP( dst_SCRIP_filename, dst_lat, dst_lon, Opt)

;---Clean up
    delete(Opt)

   ;----------------------------------------------------------------------
   ; Generate the weights that take you from the source grid to 
   ; destination degree grid.
   ;----------------------------------------------------------------------
    Opt                      = True
    Opt@InterpMethod         = interp_opt
    Opt@DstRegional          = True
    Opt@ForceOverwrite       = True
    Opt@PrintTimings         = True
    Opt@Debug                = True

    ESMF_regrid_gen_weights( src_SCRIP_filename, dst_SCRIP_filename, wgtFileName, Opt)

    delete(Opt)

;----------------------------------------------------------------------
;----------------------------------------------------------------------
end
