#Check Zimbra queues and if has more than 100 email move to HOLD and send email with subject "Mail account has been hacked!". After that stop MTA Service. You can check your mailbox account but can't send email while system #administrator fix it.

#Make this script executable and add at Crontab end execute on every 5 minutes.
# chmod +x /root/autoCheckZimbraQueues.sh
# */5 * * * * /root/autoCheckZimbraQueues.sh

#!/bin/bash
saveGrepInVariable=$(/opt/zimbra/libexec/zmqstat | grep active | grep -P '\d{1}')
echo "Return Grep Command: ${saveGrepInVariable}"

if [[ -n "${saveGrepInVariable}" ]] ; then
     awk 'BEGIN{print "Subject:Mail account has been hacked!\nFrom:Martin Slavov <m.slavov@linux-sys-adm.com>"}{printf("%s\011\n", $0)}' /home/mslavov/emailTemplate.html | sendmail -t m.slavov@linux-sys-adm.com
     /opt/zimbra/bin/zmmtactl stop
	### Hold All Messages
     /opt/zimbra/postfix/sbin/postsuper -h ALL
	### Delete All Messages
    #/opt/zimbra/postfix/sbin/postsuper -d ALL
	### Requeue All Messages
    #/opt/zimbra/postfix/sbin/postsuper -r ALL
else
    echo "Mail Queues less than 100 !"
fi
