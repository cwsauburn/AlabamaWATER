  ; Clip origional NWM short, medium, and long range land model forecast into ACT, ACF and AL state domain
  ; Select reach routing forecast for ACT basin
  ; Time: 12.11.2018 until now
  ; short range filename    20181210.t16(00-23)z.land.f005(001-018).conus.nc
  ; medium range filename   20181209.t18(00-18)z.land.f123(003-240).conus.nc
  ; long range filename     20181211.t00(00-18)z.land_4.f024(024-720).conus.nc 

  ;------- define time range ------------------------------------------------

  bedate = 20181216 ;Attention! Date range can't exceed one months, for example, 20181130-20181202 is illegal. 
  endate = 20181216 ;Attention! Date range can't exceed one months 

  ;-------- main program --------------------------------------------------------------
  rdate = bedate
  do while(rdate.le.endate)
  
   ;------------ short range forecast -------------------------------------------------
  	do shour = 00,23;23
  	  do sterm = 001,018;018
       
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
         

        ;-------- reach output for ACT basin ---------------------------------------------
          Ifilename = "/***Please use your own route***"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
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
          Ofilename = "/***Please use your own route***"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".ACT.conus.nc"
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
