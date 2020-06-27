#!/usr/bin/env bash

test_string=$(certbot certificates);

echo $test_string;

echo '------------------------------------------'

if [[ $test_string == *"No certs found."* ]];
then
    echo "NO CERTIFICATES FOUND IN OUR TOOL, CREATING CERTIFICATES";
    
    #this command will automatically create ssl certificates, you should edit it for your needs
    certbot --nginx -d domain.com \
    -d www.domain.com \
    --email you@email.com \
    --agree-tos
    
else
    echo "CERTIFICATES FOUND, NOT RECREATING";

    #this script assumes there is only one certificate on the system. If there is more than one you may hit problems
    #I use two grep statements because I couldn't get lookahead working properly
    #also note this is set up for urls with only one . a .co.uk domain will not work here. That might be something to add later
    #if its something people want/need
    cert_name=$(echo $test_string | grep -Eo '(Certificate Name: )([A-Za-z0-9])+(\.)([A-Za-z0-9])+' | grep -Eo '([A-Za-z0-9])+(\.)([A-Za-z0-9])+')

    #print the name of the certificate so we know what's going on
    echo '+++++++++++++++'
    echo 'Using certificate:' $cert_name
    echo '+++++++++++++++'

    #here we want to modify the nginx server to use the exisiting certificates
    certbot --nginx -n -d domain.com \
    -d www.domain.com \
    --cert-name $cert_name \
    install

fi;

#set up a monthy attempt at renewal


#check if this has already been set up
cron_test=$(crontab -l)

if [[ $cron_test == *"certbot -1 renew"* ]];
then 
    echo "FOUND THE REQUIRED RENEWAL IS WORKING, WILL NOT REPEAT"

else
    echo "CREATING CRON JOB"
    #create a cron job to run once a month on the first at midnight
    crontab -l | { cat; echo "0 0 1 * * certbot -q renew"; } | crontab -

fi;
