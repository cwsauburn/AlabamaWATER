  ; Clip origional NWM short, medium, and long range reach model forecast into ACT, ACF basin and AL state domain

  ; short range filename sample    20181210.t16(00-23)z.land.f005(001-018).conus.nc
  ; medium range filename sample   20181209.t18(00-18)z.land.f123(003-240).conus.nc
  ; long range filename sample     20181211.t00(00-18)z.land_4.f024(024-720).conus.nc 

  ;------- define time range & reach number in retangle------------------------------------------------
  clipdate = getenv("CLIPDATE")
  bedate = clipdate ;Attention! Date range can't exceed one months, for example, 20181130-20181202 is illegal. 
  endate = clipdate ;Attention! Date range can't exceed one months  
  
  Nreach = 169720 ; The number of reach located in rectangle.
  
  ; This is the file contains reach ID of reaches located in research region
  ; The ReachID is 2*9720, it contains ID and ID sequence number in NWM reach file
  Positionfile = "/your path/channel_rt_position.nc" 
  Lfid = addfile(Positionfile, "r")
  posi = Lfid->position 
  
  ;-------- main program --------------------------------------------------------------
  rdate = bedate
  do while(rdate.le.endate)
  
   ;------------ short range forecast -------------------------------------------------
    print("Begin of short range forecast clip")
  	do shour = 00,23
  	  do sterm = 001,018
       
        ;-------- reach output for rectangle basin --------------------------------------------
        Ifilename = "/your path/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
        Ifid = addfile(Ifilename, "r")
        if (.not.(ismissing(Ifid))) then 
           O_id = Ifid->feature_id
   
           Sflow = new((/Nreach/),"float") 
           do Rid = 0, Nreach-1
              if ( posi(0,Rid) .eq. O_id(posi(1,Rid)-1) )
                  Sflow(Rid) = Ifid->streamflow(posi(1,Rid)-1)
              else
                  print("The feature ID position in origional file (not clipped) is changed, please check")
                  print(Rid)  
                  print(posi(0,Rid))
                  print(O_id(posi(1,Rid)-1))
                  print(posi(1,Rid)-1)
                  
              end if
           end do
                      
           Sflow@_FillValue = -999900
           Sflow@units = "m3 s-1"
           Ofilename = "/your path/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
           if ( isfilepresent( Ofilename ) ) then
             system ("/bin/rm "+Ofilename)
           end if
		   
           Ofid = addfile(Ofilename,"c") 
           Ofid->streamflow = Sflow
           delete(Ifilename)
           delete(Ifid)
           delete(O_id)
           delete(Sflow)
           delete(Ofilename)
           delete(Ofid)
        end if       
      end do
    end do
	 
	;------------ medium range forecast -------------------------------------------------
    print("Begin of medium range forecast clip")
  	do shour = 00,18,06   ;Sometimes, the forecast at 6 o'clock am contain files which can't be read in.
  	  do sterm = 003,240,003
        do mem = 1, 7
        ;-------- reach output -------------------------------------------- 
        Ifilename = "/your path/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
        Ifid = addfile(Ifilename, "r")
        if (.not.(ismissing(Ifid))) then 
           O_id = Ifid->feature_id
   
           Sflow = new((/Nreach/),"float") 
           do Rid = 0, Nreach-1
              if ( posi(0,Rid) .eq. O_id(posi(1,Rid)-1) )
                  Sflow(Rid) = Ifid->streamflow(posi(1,Rid)-1)
              else
                  print("The feature ID position in origional file (not clipped) is changed, please check")
                  print(Rid)  
                  print(posi(0,Rid))
                  print(O_id(posi(1,Rid)-1))
                  print(posi(1,Rid)-1)
              end if
           end do
                      
           Sflow@_FillValue = -999900
           Sflow@units = "m3 s-1"
           Ofilename = "/your path/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
           if ( isfilepresent( Ofilename ) ) then
             system ("/bin/rm "+Ofilename)
           end if
		   
           Ofid = addfile(Ofilename,"c") 
           Ofid->streamflow = Sflow
		   
           delete(Ifilename)
           delete(Ifid)
           delete(O_id)
           delete(Sflow)
           delete(Ofilename)
           delete(Ofid)
        end if  
		end do
      end do
    end do
	
  ;------------ long range forecast -------------------------------------------------
  print("Begin of long range forecast clip")
  ; The 00 hour 0 lead forecast does not exist, the 720+6/12/18 also does not exist, they will be shown as missing file script output
  	do shour = 00,18,06
  	  do sterm0 = 0,720,024 
        do mem = 1,4
            
           Sflow = new((/Nreach/),"float")
           Sflow_temp = new((/Nreach,4/),"float") 
            
           interc = -1
            do inter = 0,18,6
              sterm=sterm0+inter
              interc=interc+1
 
            ;-------- reach output for ACT basin ---------------------------------------------
              Ifilename = "/your path/mem"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
              Ifid = addfile(Ifilename, "r")
              if (.not.(ismissing(Ifid))) then
                O_id = Ifid->feature_id
    
                do Rid = 0, Nreach-1
                  if ( posi(0,Rid) .eq. O_id(posi(1,Rid)-1) )
                    Sflow_temp(Rid,interc) = Ifid->streamflow(posi(1,Rid)-1)
                  else
				   ; the reach file maybe updated, so the reach ID sequence number would be different
                   print("The feature ID position in origional file (not clipped) is changed, please check")
                   print(Rid)  
                   print(posi(0,Rid))
                   print(O_id(posi(1,Rid)-1))
                   print(posi(1,Rid)-1)               
                  end if
                end do
               end if 
           end do
    
           Sflow=dim_avg_n(Sflow_temp,1)
           Sflow=Sflow*0.01               
           sterm1=sterm+6  
         
           Sflow@_FillValue = -999900
           Sflow@units = "m3 s-1"
           Ofilename = "/your path/mem"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm1)+".conus.nc"
           if ( isfilepresent( Ofilename ) ) then
             system ("/bin/rm "+Ofilename)
           end if
           Ofid = addfile(Ofilename,"c") 
           Ofid->streamflow = Sflow
           delete(Ifilename)
           delete(Ifid)
           delete(O_id)
           delete(Sflow)
           delete(Sflow_temp)
           delete(Ofilename)
           delete(Ofid)
       
        end do
      end do
    end do         
   ;------------ The end of extraction -----------------------------------------------                   
	rdate = rdate + 1
  end do  
 
