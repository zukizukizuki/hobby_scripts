!/bin/bash
echo "Enter the Start time of Downtime as below format"
echo "Wed Mar 20 13:49:20 JST 2022"
read from;
fromtime=`date -d "$from" +%s`
echo "Enter the End time of Downtime as below format"
echo "Wed Mar 20 13:49:20 JST 2022"
read to;
totime=`date -d "$to" +%s`
echo "Enter your User ID"
read user;
echo "Enter Comments for downtime"
read comment
while read host
do
`echo -e "[%lu] SCHEDULE_HOST_DOWNTIME;$host;$fromtime;$totime;1;0;;$user;$comment" > /var/spool/nagios/cmd/nagios.cmd`
