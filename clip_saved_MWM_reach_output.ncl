  ; Clip origional NWM short, medium, and long range reach model forecast into ACT, ACF and AL state domain
  ; Time: 12.11.2018 until now
  ; short range filename    20181210.t16(00-23)z.land.f005(001-018).conus.nc
  ; medium range filename   20181209.t18(00-18)z.land.f123(003-240).conus.nc
  ; long range filename     20181211.t00(00-18)z.land_4.f024(024-720).conus.nc 

  ;------- define time range & reach number in retangle------------------------------------------------
  clipdate = getenv("CLIPDATE")
  bedate = clipdate ;Attention! Date range can't exceed one months, for example, 20181130-20181202 is illegal. 
  endate = clipdate ;Attention! Date range can't exceed one months  
  
  Nreach = 169720 ; The number of reach located in rectangle.
  Positionfile = "/home/yzd0026/NWM/clip/channel_rt_position.nc"
  Lfid = addfile(Positionfile, "r")
  posi = Lfid->position 
  
  ;-------- main program --------------------------------------------------------------
  rdate = bedate
  do while(rdate.le.endate)
  
   ;------------ short range forecast -------------------------------------------------
/;   
   print("Begin of short range forecast clip")
  	do shour = 00,23;23
  	  do sterm = 001,018;018
       
        ;-------- reach output for rectangle basin --------------------------------------------
        Ifilename = "/gpfs01/hosted/fores/NWM/FORECAST/Short_Range/Channel_Routing/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
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
           Ofilename = "/gpfs01/hosted/fores/NWM/clip/ACTACFAL/Short_Range/Channel_Routing/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
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
  	do shour = 00,00,06;18   ;Because forecast at 6 o'clock am contain files which can't be read in. I am not sure the reason.
  	  do sterm = 003,240,003;240

        ;-------- reach output for ACT basin-------------------------------------------- 
        Ifilename = "/gpfs01/hosted/fores/NWM/FORECAST/Medium_Range/Channel_Routing/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
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
           Ofilename = "/gpfs01/hosted/fores/NWM/clip/ACTACFAL/Medium_Range/Channel_Routing/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt.f"+sprinti("%0.3i",sterm)+".conus.nc"
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
;/    
  ;------------ long range forecast -------------------------------------------------
  print("Begin of long range forecast clip")
  	do shour = 00,18,06
  	  do sterm0 = 0,696,024 
        do mem = 1,4
            
          Sflow = new((/Nreach/),"float")
          Sflow_temp = new((/Nreach,4/),"float") 
            
          interc = -1
          do inter = 6,24,6
            sterm=sterm0+inter
            interc=interc+1
 
          ;-------- reach output for ACT basin ---------------------------------------------
            Ifilename = "/home/yzd0026/NWM/FORECAST/Long_Range/Channel_Routing/mem"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
            Ifid = addfile(Ifilename, "r")
            if (.not.(ismissing(Ifid))) then
              O_id = Ifid->feature_id
    
              do Rid = 0, Nreach-1
               if ( posi(0,Rid) .eq. O_id(posi(1,Rid)-1) )
                 Sflow_temp(Rid,interc) = Ifid->streamflow(posi(1,Rid)-1)
               else
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
         
           Sflow@_FillValue = -999900
           Sflow@units = "m3 s-1"
           Ofilename = "/home/yzd0026/NWM/clip/ACTACFAL/Long_Range/Channel_Routing/mem"+mem+"/"+rdate+".t"+sprinti("%0.2i",shour)+"z.channel_rt_"+mem+".f"+sprinti("%0.3i",sterm)+".conus.nc"
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
 
