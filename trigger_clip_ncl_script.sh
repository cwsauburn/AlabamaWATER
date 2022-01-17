 #!/bin/bash
#Define date and launch clip script

  email=`whoami`@youremail.edu
  workdir=/your path/
  cd $workdir
  rm outland
  rm outreach
  
  module load ncl
  
  byesterday=$(date -d "-2 day" +%Y%m%d)
  yesterday=$(date -d "-1 day" +%Y%m%d)
  today=$(date +'%Y%m%d')
  
  #change clip date when necessary
  export CLIPDATE=$byesterday
  deldate=$byesterday

  #export CLIPDATE=20201030
  #deldate=20201030
  
  ncl clipland.ncl>outland
  ncl clipreach.ncl>outreach

  exit 0
