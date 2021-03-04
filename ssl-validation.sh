#!/bin/bash
TARGET="rt-staging.trustedshops.com"; 
RECIPIENT="venkateswarlu.kuchipudi@trustedshops.de";
CRITICAL_DAYS=3;
WARNING_DAYS=7;
#-----------
# GET DATE |
#-----------
DATE_ACTUALLY_SECONDS=$(date +"%s")

echo "checking if $TARGET expires in less than $DAYS days";

#------------------
# GET CERTIFICATE |
#------------------

EXPIRE_DATE=$(openssl s_client -connect rt-staging.trustedshops.com:443 -servername rt-staging.trustedshops.com 2>&- | openssl x509 -enddate -noout) 
DATE_EXPIRE_SECONDS=$(echo "${EXPIRE_DATE}" | sed 's/^notAfter=//g' | xargs -I{} date -d {} +%s)

#-------------------
# DATE CALCULATION |
#-------------------

DATE_EXPIRE_FORMAT=$(date -I --date="@${DATE_EXPIRE_SECONDS}")
DATE_DIFFERENCE_SECONDS=$((${DATE_EXPIRE_SECONDS}-${DATE_ACTUALLY_SECONDS}))
DATE_DIFFERENCE_DAYS=$((${DATE_DIFFERENCE_SECONDS}/60/60/24))
#---------
# NOTIFICATION |
#---------

if [[ "${DATE_DIFFERENCE_DAYS}" -le "${CRITICAL_DAYS}" && "${DATE_DIFFERENCE_DAYS}" -ge "0" ]]; then
	echo -e "CRITICAL: Cert will expire on: "${DATE_EXPIRE_FORMAT}"" \
  | mail -s "Certificate expiration warning for $TARGET" $RECIPIENT ;
	exit 2
elif [[ "${DATE_DIFFERENCE_DAYS}" -le "${WARNING_DAYS}" && "${DATE_DIFFERENCE_DAYS}" -ge "0" ]]; then
	echo -e "WARNING: Cert will expire on: "${DATE_EXPIRE_FORMAT}"" \
  | mail -s "Certificate expiration warning for $TARGET" $RECIPIENT ;
	exit 1
elif [[ "${DATE_DIFFERENCE_DAYS}" -lt "0" ]]; then
	echo -e "CRITICAL: Cert expired on: "${DATE_EXPIRE_FORMAT}"" \
  | mail -s "Certificate expiration warning for $TARGET" $RECIPIENT ;
	exit 2
else
	echo -e "OK: Cert will expire on: "${DATE_EXPIRE_FORMAT}"" \
  | mail -s "Certificate expiration warning for $TARGET" $RECIPIENT ;
	exit 0
fi

#2>&- \
#| openssl x509 -text \ | sed 's/^notAfter=//g' \ | xargs -I{} date -d +%s) 
echo $DATE_EXPIRE_SECONDS
in7days=$(($(date +%s) + (86400*$DAYS)));
echo $in7days
#if [[ $in7days -gt $expirationdate ]]; then
#    echo "KO - Certificate for $TARGET expires in less than $DAYS days, on $(date -d @$expirationdate '+%Y-%m-%d')" \
#    | mail -s "Certificate expiration warning for $TARGET" $RECIPIENT ;
#else
#    echo "OK - Certificate expires on $expirationdate";
#fi;