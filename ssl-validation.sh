#!/bin/bash
TARGET="rt-staging.trustedshops.com"; 
RECIPIENT="venkateswarlu.kuchipudi@trustedshops.de";
DAYS=7;
echo "checking if $TARGET expires in less than $DAYS days";
EXPIRE_DATE=$(openssl s_client -connect rt-staging.trustedshops.com:443 -servername rt-staging.trustedshops.com 2>&- | openssl x509 -enddate -noout) 
DATE_EXPIRE_SECONDS=$(echo "${EXPIRE_DATE}" | sed 's/^notAfter=//g' | xargs -I{} date -d {} +%s)
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
