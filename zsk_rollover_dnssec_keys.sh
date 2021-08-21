#!/bin/bash
#TRINV-DNSSEC-Scripts: Settime 4 ZSKs (/zone)
# usage: ./change_time_dnssec_key <list_zone_file>


clear
zone=$1

KEYDIR="/etc/bind/keys/${zone}"
KEYSFILE="/etc/bind/keys/${zone}/K${zone}.+ZSK+current.key"
if [ ! -f  "$KEYSFILE" ]; then
                mkdir -p ${KEYDIR}
                ##########################Create ZSK Current for a Zone##################
##########
                #echo -e "##########################Create ZSK Current for Zone\e[1;31m $
{zone} \e[0m##################################\n"
                #-------------------------------Create ZSK-------------------------------
---
                #echo -e "##########Generate ${zone} ZSK Current.........##########\n"
#               echo `date`
        current_key=`dnssec-keygen -r /dev/urandom -a RSASHA256 -b 1024 -n ZONE \
        -K ${KEYDIR}  \
        ${zone}`

        ln -nsf ${current_key}.key     ${KEYDIR}/K${zone}.+ZSK+current.key
        ln -nsf ${current_key}.private ${KEYDIR}/K${zone}.+ZSK+current.private
        chown -R bind:bind ${KEYDIR}
#       echo -e ${zone} "\e[1;32m ZSK successfully generated!!!\e[0m\n"
#       ls -l ${KEYDIR}|grep "ZSK"

else


##########################Change Key time Current ZSKs for a Zone########################
####
#echo -e "##########################Change Key time Current ZSK##########################
########\n"
#-------------------------------Change Key time ZSK----------------------------------
#echo -e "##########Change Key time \e[1;31m${zone}\e[0m ZSK.........##########\n"
#echo `date`

INADATE=`date -u -d "+2 days" +%Y%m%d%H%M%S`
DELETE=`date -u -d "+1 months" +%Y%m%d%H%M%S`


dnssec-settime -K ${KEYDIR} -I ${INADATE} -D ${DELETE} K${zone}.+ZSK+current
#echo -e "\e[1;32m${zone} ZSK Current successfully changed time!!!\e[0m\n"
#echo -e "#################################################"

#########################Create New ZSK for a Zone############################
#echo -e "##########################Create New ZSK for Zone\e[1;31m ${zone} \e[0m########
##########################\n"
#-------------------------------Create New ZSK----------------------------------
#echo -e "##########Generate ${zone} ZSK.........##########\n"
#echo `date`

PUBDATE_new=`date -u -d "+0 days" +%Y%m%d%H%M%S`
ACTDATE_new=`date -u -d "+2 days" +%Y%m%d%H%M%S`

key_new=`dnssec-keygen -r /dev/urandom -a RSASHA256 -b 1024 -n ZONE \
    -K ${KEYDIR} \
    -P ${PUBDATE_new} \
    -A ${ACTDATE_new} \
    ${zone}`

ln -nsf ${key_new}.key     ${KEYDIR}/K${zone}.+ZSK+current.key
ln -nsf ${key_new}.private ${KEYDIR}/K${zone}.+ZSK+current.private

#echo -e ${zone} "\e[1;32m New ZSK successfully generated!!!\e[0m\n"
#echo -e "#################################################"

fi

