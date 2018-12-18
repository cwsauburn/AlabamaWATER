  ; Clip origional NWM short, medium, and long range land model forecast into ACT, ACF and AL state domain
  ; Select reach routing forecast for ACT basin
  ; Time: 12.11.2018 until now
  ; short range filename    20181210.t16(00-23)z.land.f005(001-018).conus.nc
  ; medium range filename   20181209.t18(00-18)z.land.f123(003-240).conus.nc
  ; long range filename     20181211.t00(00-18)z.land_4.f024(024-720).conus.nc 

  ;------- define domain & time range ------------------------------------------------
  x1 = 3039    ;lon1 = -88.71   x1 = 757,859.145  
  x2 = 3643    ;lon2 = -83.143  x2 = 1,289,672.708
  y1 = 826     ;lat2 = 29.351   y2 = -1,088,418.479
  y2 = 1523    ;lat1 = 35.378   y1 = -428,017.158 


  bedate = 20181211 ;Attention! Date range can't exceed one months, for example, 20181130-20181202 is illegal. 
  endate = 20181213 ;Attention! Date range can't exceed one months 

  ;-------- main program --------------------------------------------------------------
  rdate = bedate
  do while(rdate.le.endate)
  
   ;------------ short range forecast -------------------------------------------------
  	do shour = 00,23;23
  	  do sterm = 001,018;018
       
       ;-------- land model output ----------------------------------------------------
  	    Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land.f"+sprinti("%0.3i",sterm)+".conus.nc"
  	    Ifid = addfile(Ifilename, "r")
  	    temp = Ifid->SOILSAT_TOP(:,y1:y2,x1:x2)  ; Origional size is 4608x3840x1, _FillValue = -9999000, long_name = 'fraction of soil saturation, top 2 layers' 
            fsoil = rm_single_dims(temp)
  	    fsoil@_FillValue = -9999000
            fsoil@long_name = "fraction of soil saturation, top 2 layers"
            fsoil@units = "fraction"
            Ofilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land.f"+sprinti("%0.3i",sterm)+".clip.conus.nc"
            Ofid = addfile(Ofilename,"c") 
            Ofid->SOILSAT_TOP = fsoil
            delete(Ifilename)
            delete(Ifid)
            delete(temp)
            delete(fsoil)
            delete(Ofilename)
            delete(Ofid)

            ;-------- reach output for ACT basin --------------------------------------------
            Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
            Ifid = addfile(Ifilename, "r")
            Sflow = new((/15/),"float")        
            Sflow(0) = Ifid->streamflow(682967)
            Sflow(1) = Ifid->streamflow(683947)
            Sflow(2) = Ifid->streamflow(1667478)
            Sflow(3) = Ifid->streamflow(686912)
            Sflow(4) = Ifid->streamflow(1667681)
            Sflow(5) = Ifid->streamflow(1665219)
            Sflow(6) = Ifid->streamflow(2338258)
            Sflow(7) = Ifid->streamflow(1665518)
            Sflow(8) = Ifid->streamflow(2345733)
            Sflow(9) = Ifid->streamflow(2316706)
            Sflow(10) = Ifid->streamflow(2264726)
            Sflow(11) = Ifid->streamflow(2273016)
            Sflow(12) = Ifid->streamflow(2264955)
            Sflow(13) = Ifid->streamflow(2269519)
            Sflow(14) = Ifid->streamflow(1873211)
            Sflow@_FillValue = -999900
            Sflow@units = "m3 s-1"
            Ofilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".ACT.conus.nc"
            Ofid = addfile(Ofilename,"c") 
            Ofid->streamflow = Sflow
            delete(Ifilename)
            delete(Ifid)
            delete(Sflow)
            delete(Ofilename)
            delete(Ofid)
               
          end do
        end do
	 
	;------------ medium range forecast -------------------------------------------------
  	do shour = 00,00,06;18   ;Because forecast at 6 o'clock am contain files which can't be read in. I am not sure the reason.
  	  do sterm = 003,240,003;240

        ;-------- land model output ---------------------------------------------------

            Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land.f"+sprinti("%0.3i",sterm)+".conus.nc"
            Ifid = addfile(Ifilename, "r")
   	    temp = Ifid->SOILSAT_TOP(:,y1:y2,x1:x2)  ; Origional size is 4608x3840x1, _FillValue = -9999000, long_name = 'fraction of soil saturation, top 2 layers' 
            fsoil =  rm_single_dims(temp)     
            fsoil@_FillValue = -9999000
            fsoil@long_name = "fraction of soil saturation, top 2 layers"
            fsoil@units = "fraction"
            delete(temp)
        
            temp = Ifid->SOIL_M(:,y1:y2,:,x1:x2)     ; Origional size is 4608x4x3840x1,_FillValue= -999900, long_name = 'volumetric soil moisture'
            vsoil = rm_single_dims(temp)
            vsoil@_FillValue = -9999000
            vsoil@long_name = "volumetric soil moisture"
            vsoil@units = "m3 m-3"
            Ofilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land.f"+sprinti("%0.3i",sterm)+".clip.conus.nc"
            Ofid = addfile(Ofilename,"c") 
            Ofid->SOILSAT_TOP = fsoil
            Ofid->SOIL_M = vsoil
            delete(temp)
            delete(vsoil)
            delete(Ofilename)
            delete(Ofid)

            ;-------- reach output for ACT basin--------------------------------------------
            Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
            Ifid = addfile(Ifilename, "r")
            Sflow = new((/15/),"float")        
            Sflow(0) = Ifid->streamflow(682967)
            Sflow(1) = Ifid->streamflow(683947)
            Sflow(2) = Ifid->streamflow(1667478)
            Sflow(3) = Ifid->streamflow(686912)
            Sflow(4) = Ifid->streamflow(1667681)
            Sflow(5) = Ifid->streamflow(1665219)
            Sflow(6) = Ifid->streamflow(2338258)
            Sflow(7) = Ifid->streamflow(1665518)
            Sflow(8) = Ifid->streamflow(2345733)
            Sflow(9) = Ifid->streamflow(2316706)
            Sflow(10) = Ifid->streamflow(2264726)
            Sflow(11) = Ifid->streamflow(2273016)
            Sflow(12) = Ifid->streamflow(2264955)
            Sflow(13) = Ifid->streamflow(2269519)
            Sflow(14) = Ifid->streamflow(1873211)
            Sflow@_FillValue = -999900
            Sflow@units = "m3 s-1"
            Ofilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".ACT.conus.nc"
            Ofid = addfile(Ofilename,"c") 
            Ofid->streamflow = Sflow
            delete(Ifilename)
            delete(Ifid)
            delete(Sflow)
            delete(Ofilename)
            delete(Ofid)

          end do
        end do        
  ;------------ long range forecast -------------------------------------------------
  	do shour = 00,18,06;18
  	  do sterm = 024,720,024;720  
            do mem = 1,4;4
         
        ;-------- land model output -------------------------------------------------  
              Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
              Ifid = addfile(Ifilename, "r")
              temp = Ifid->SOILSAT_TOP(:,y1:y2,x1:x2)  ; Origional size is 4608x3840x1, _FillValue = -9999000, long_name = 'fraction of soil saturation, top 2 layers' 
              fsoil =  rm_single_dims(temp)     
  	      fsoil@_FillValue = -9999000
              fsoil@long_name = "fraction of soil saturation, top 2 layers"
              fsoil@units = "fraction"   
              Ofilename = "/gpfs01/hosted/fores/NWM/clip/ACTACFAL/Long_Range/Land_Output/mem"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.land_"+mem+".f"+sprinti("%0.3i",sterm)+".clip.conus.nc"    
              Ofid = addfile(Ofilename,"c") 
              Ofid->SOILSAT_TOP = fsoil 
              delete(Ifilename)
              delete(Ifid)
              delete(temp)
              delete(fsoil)
              delete(Ofilename)
              delete(Ofid)

        ;-------- reach output for ACT basin ---------------------------------------------
              Ifilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
              Ifid = addfile(Ifilename, "r")
              Sflow = new((/15/),"float")        
              Sflow(0) = Ifid->streamflow(682967)
              Sflow(1) = Ifid->streamflow(683947)
              Sflow(2) = Ifid->streamflow(1667478)
              Sflow(3) = Ifid->streamflow(686912)
              Sflow(4) = Ifid->streamflow(1667681)
              Sflow(5) = Ifid->streamflow(1665219)
              Sflow(6) = Ifid->streamflow(2338258)
              Sflow(7) = Ifid->streamflow(1665518)
              Sflow(8) = Ifid->streamflow(2345733)
              Sflow(9) = Ifid->streamflow(2316706)
              Sflow(10) = Ifid->streamflow(2264726)
              Sflow(11) = Ifid->streamflow(2273016)
              Sflow(12) = Ifid->streamflow(2264955)
              Sflow(13) = Ifid->streamflow(2269519)
              Sflow(14) = Ifid->streamflow(1873211)
              Sflow@_FillValue = -999900
              Sflow@units = "m3 s-1"
              Ofilename = "/***Please use your own route***/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".ACT.conus.nc"
              Ofid = addfile(Ofilename,"c") 
              Ofid->streamflow = Sflow
              delete(Ifilename)
              delete(Ifid)
              delete(Sflow)
              delete(Ofilename)
              delete(Ofid)

             end do
           end do
         end do         
   ;------------ The end of extraction -----------------------------------------------                   
	rdate = rdate + 1
  end do
 
