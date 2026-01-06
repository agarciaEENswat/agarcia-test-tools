**Diagnostic tools** 

**Pull up history browser of a camera using all Archivers:** 

Put the Classic WebApp in Debug 

Hold CTRL \+ ALT 

Click on History of a camera 

**ESN to int for camera direct** 

python3 \-c 'print(int("", 16))' 

{"cameras":{"10067e52":{"resource":\["event","status\_hex64","image"\],"event": 

\["CPRG","CBWS","CZTS","ANNT","III0","IIA0","IIH0","III1","IIA1","IIH1","III2","IIA2","IIH2","IOI0","IOA0","IO H0","IOI1","IOA1","IOH1","IOI2","IOA2","IOH2"\],"image\_props":{"mbox":1}}}} 

**Status checks** 

Status server \- http://status-server.lon1p1.eencloud.com:5001/api/v2/Status? 

Account\_in=00164224\&Device\_in=100096b1 

Registry check \- https://registry.lon1p1.eencloud.com/api/v2/Search?Include=czts\&Device\_in=100096b1 Dhash check \- https://dproxy.test.eencloud.com/api/v2/dhash/node/v1/com.eencloud.dhash.pod::accounts 

Notifications API link https://api.c022.eagleeyenetworks.com/api/v3.0/accounts/00026236/notifications https://api.c012.eagleeyenetworks.com/api/v3.0/accounts/00028077/notifications? alertId=\&alertType=\&actorId=\&actorType=\&actorAccountId=\&category=\&userId=ca0781a6\&read=\&status= \&groupId=\&timestamp\_\_lte=\&timestamp\_\_gte=\&creatorId=\&serviceRuleId=\&notificationActions\_\_contains \= 

provisioning for an ESN: 

https://dproxy.test.eencloud.com/api/v2/dhash/node/v1/com.eencloud.dhash.esn:100383c0:provisioning c023\~6ea9e40b4a989d7308d3643319db9111 

https://dproxy.test.eencloud.com/api/v2/dhash/node/v1/com.eencloud.dhash.cluster::/auth/ **VMetrics for account vbs logs** 

kubernetes.node\_labels.pod: "lon1p1" AND kubernetes.container\_name:="gateway" AND "00050145"  
kubernetes.pod\_labels.app:alertd 

**Fetcher logs** 

\~ dpandy \[c022-lon1p1\] $ kubectl node-shell a2311 

spawning "nsenter-t1sfcw" on "a2311" 

If you don't see a command prompt, try pressing enter. 

a2311 / \# 

a2311 / \# 

a2311 / \# ls 

bin data etc home lib64 media opt root sbin swapfile tmp  var 

boot dev fetcher lib lost+found mnt proc run srv sys usr a2311 / \# 

a2311 / \# 

a2311 / \# cd fetcher/ 

a2311 /fetcher \# ls 

conf.d eenlogs logs 

a2311 /fetcher \# cd logs 

a2311 /fetcher/logs \# 

a2311 /fetcher/logs \# 

a2311 /fetcher/logs \# cat fetcher.log | grep 1003fbe6 

20250210145518.402:\[INFO\] 

/app/registry/een/dispatch.cpp:40:registry\_proxy\_dispatch no transport for 1003fbe6, failing server proxy (0x7f5664a60b10:TAGFLOW:1003fbe6) 20250210145518.402:\[INFO\] 

/app/registry/een/dispatch.cpp:40:registry\_proxy\_dispatch no transport for 1003fbe6, failing server proxy (0x7f565d522150:TAGFLOW:1003fbe6) 20250210145519.603:\[INFO\] 

/app/registry/een/dispatch.cpp:40:registry\_proxy\_dispatch no transport for 1003fbe6, failing server proxy (0x7f5736608970:TAGFLOW:1003fbe6) 20250210145519.603:\[INFO\] 

/app/registry/een/dispatch.cpp:40:registry\_proxy\_dispatch no transport for 1003fbe6, failing server proxy (0x7f572caa1b30:TAGFLOW:1003fbe6) 20250210145520.407:\[INFO\] 

/app/registry/een/dispatch.cpp:40:registry\_proxy\_dispatch no transport for 1003fbe6, failing server proxy (0x7f5654a9e1c0:TAGFLOW:1003fbe6) 

Ramesh Babu Anaparti: "failed getting ctrans for registry send" \- means fetcher not connected to any archiver at that moment. But, we are not printing any log when it connects back.  
Ramesh Babu Anaparti: "no ctrans for esn \- bailing on it" \- means no valid archiver for the esn and we unregister the esn from fetcher in this case 

Ramesh Babu Anaparti: "stuck in opening" \- this means it was not able to connect to an archiver, it will attempt to connect another archiver 

Ramesh Babu Anaparti: First thing to do is grep the esn over the either logs and see any logs around the time stamp any issue happened. 

**restarting ssh for tunnel connectivity, from exec in EEN Admin** 

/usr/bin/ipccli \--command \--command='/bin/systemctl restart sshd.service' 

**New ESN nmap** 

nmap \-sT \-sU \-T25 \-p 80,443,773,8081,8082,50000,60000    
(*strings*/*opt*/*een*/*var*/*bridge*/*bridge*/ ∗ 

/*bridgeservicestatus*∣*head* − 1∣*whileread* − *resn*; *dogetenthosts*"$1}'; done) | grep \-ivE '80/u|443/u|773/u|8081/u|8082/t|50000/u|60000/u' 

echo root:@gqZIxBbw\#sG | chpasswd && echo Yes 

esn.a.plumv.com" | awk '{print 

**Which camera IP's are dropping packets in Stream logs** 

grep "dropped: " \<ESN\_archiver\>\_stream.log grep | awk \-F"\[ @\]" '{if ($0 \~ /dropped: \[1-9\]\[0-9\]*/) print $6}' | awk \-F":" '{print $1}' | sort \-u* 

*grep "dropped: " 1001d971.a2611\_bridge.log grep | awk \-F"\[ @\]" '{if ($0 \~ /dropped: \[1-9\]\[0-9\]*/) print $6}' | awk \-F":" '{print $1}' | sort \-u 

**Looking for low Uptime logs in stream logs** 

grep "Uptime :0.0" \<ESN\_archiver\>\_stream.log | awk \-F'@|/' '{print $2}' | sort | uniq grep "Uptime :0.0" 100b447c.a1539\_stream.log | awk \-F'@|/' '{print $2}' | sort | uniq grep \-E "Uptime\\s\*:\[0-9.\]+e-\[0-9\]+" 100fc68c.a2608\_stream.log | grep \-oP '@\\K\[0-9\]+.\[0-9\]+.\[0-9\]+.\[0-9\]+' | sort \-u 

**Gathering IP and GUID info from the low uptime IP's from above** paste \<(cat \<\<EOF 

EOF   
) \<( 

while read ip; do 

guid= 

KaTeX parse error: Expected 'EOF', got '&' at position 33: …bridge/cameras &̲& for i in \*/la… {i%%/last\_address}: "; strings "$i" | grep \-v 169.254 | head \-1; done | awk \-F'/last\_address' '{print $1 KaTeX parse error: Expected 'EOF', got '}' at position 2: 2}̲' | grep \-F " 

ip"); 

*guid*"; *done* \<\< (*cat* \<\< *EOF* \< *iplist* \> *EOF*)) \< (*whilereadguid*; *doif*\[\[−*n*"  
echo " guid" \]\]; then 

esn=$(cd /opt/een/var/bridge/esns;for i in \*/camera\_service\_status; do echo \-n " $i: " ; strings $i | head \-2 | tail \-1; done | awk \-F'\[/:\]' '{ print $1 

KaTeX parse error: Expected 'EOF', got '}' at position 2: 3}̲' | grep \-F " 

guid"); 

echo " 

KaTeX parse error: Expected 'EOF', got '&' at position 94: …bridge/cameras &̲& for i in \*/la… {i%%/last\_address}: "; strings "$i" | grep \-v 169.254 | head \-1; done | awk \-F'/last\_address' '{print $1 $2}') ) 

**checking pod health** 

curl https://c015.eagleeyenetworks.com/g/health/ | jq 

**Checking for push notifications** 

https://api..eagleeyenetworks.com/api/v3.0/accounts//notifications?userId= 

**playing video from the camera** 

ffplay rtsp://:@\<bridge\_ip\_address\>:8554/ 

rtsp://jbutts+test1@een.com:O6gV3Jyc9LmpnzxZ5xklUvsnVd4=@10.100.8.149:8554/ **Checking for failed tasks on an account move** 

Nexus meta\_ID from the move\_account job is needed. 

Go to Mongo 

Enter {meta\_id:"d0b3ce68-b3b3-4c6b-b5e2-a394312dc28a", state: "FAILURE"} 

Find the failures 

Check ESN and archiver that failed(If there are multiples repeat the next few steps) Go to the ESN page in Nexus, and look for the failed archiver   
if it's not there, then check for "push\_esn" job, from there you can click on the task\_id to see if it was an automated process if there's a "plan\_id" 

If ESN has the failed archiver, set the failed archiver to Drained, it will be an automated process to remove it once the workers hit that ESN (The old archiver that failed will be on the old pod) 

Timestamps in History 

export HISTTIMEFORMAT="%F %T " 

echo 'root:REDACTED' | chpasswd && echo Yes 

**resizing tmp file size** 

mount \-o remount,size=4G /opt/een/tmp/ 

**what the bridge thinks the password is** 

cat /opt/een/var/bridge/security/credentials.js 

**Credentials pull for missing credentials.js** 

Password file(s) \['/opt/een/etc/nginx/htpasswd', '/opt/een/etc/nginx/htpasswd\_admin', '/opt/een/var/bridge/security/credentials.js'\] is/are missing. 

SERVER=secure ; if openssl x509 \-noout \-text \-in /etc/pki/tls/certs/server-ca.pem | grep \-q sha256WithRSAEncryption; then SERVER=secure2; echo "---NEW CERTS"; fi; curl \-vLsSfk \-X GET \--key "/etc/pki/tls/private/server-key.pem" \--cert "/etc/pki/tls/certs/server.pem" 

"https://$SERVER.eagleeyenetworks.com/g/bridge\_transfer?file=credentials.js" \-o "/opt/een/var/bridge/security/credentials.js" ; echo "" 

"https://$SERVER.eagleeyenetworks.com/g/bridge\_transfer?file=credentials.js" \-o "/opt/een/var/bridge/security/credentials.js" 

**Installing from epel** 

Install and Enable EPEL Repository: 

For RHEL/CentOS 7: 

bash 

Copy code  
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm For RHEL/CentOS 8: 

bash 

Copy code 

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm After adding the EPEL repo, ensure it's enabled: 

bash 

Copy code 

sudo dnf config-manager \--set-enabled epel 

Install nload: 

After enabling the EPEL repository, you can install nload using: 

bash 

Copy code 

sudo yum install nload \# For CentOS 7 

OR 

bash 

Copy code 

sudo dnf install nload \# For CentOS 8 or newer 

**Finding last\_address** 

/opt/een/var/bridge/cameras/\<GUID\>/last\_address 

**Finding duplicates in ARP** 

arp \-n | awk '{print $3}' | sort | uniq \-c 

**Accessing exec from terminal** 

USE: 

\[Note: Replace all double quotes (") with (\\")\] 

Bridge\_ESN="" 

command="" 

(*echo* − *n*"   
base64\_command= {command}" | base64 | tr \-d "\\n") 

*BridgeESN*;*t* \= *execute*; *r* \=  
curl \-s "http://${Bridge\_ESN}.a.plumv.com:28080/camera/command?c=   
*json*; *a* \=  
{base64\_command}" | jq \-r '.body' | sed "s@+@ @g;s@%@\\\\x@g" | xargs \-0 printf "%b" 

unset Bridge\_ESN; unset command; unset base64\_command 

**(\>1 entry)** 

\[root@een-br420-71498 \~\]\# mv /opt/een/var/bridge/bridge/398e1126-8db6-41db-acb7-9694a17d341a/ /opt/een/data/ 

\[root@een-br420-71498 \~\]\# ls 

\[root@een-br420-71498 \~\]\# docker exec \-it bridge\_bridge\_1 supervisorctl restart bridge bridge: stopped 

bridge: started 

\[root@een-br420-71498 \~\]\# su 

(Host OS Login) 

Cams: OnL/Dis/OfL \= 6/0/0 | ESN: 100367e6 

GUID: 57c545d8-41b3-11ec-8ea2-d85ed3592e88 | MeasBW: 105.3Mbit | MiscErrs: OK Monitors: None Connected | NICs: WAN: Up, CLN: Dn | NetStats: CL 0b,W 15.6kb Platform: 2.0.0 | RAID: Modern (\[U\], OK, 9.7TB) | SMART: OK | SataErrs: OK 

Serial: EEN-BR420-71498 | Temps: OK: 30/21C | Version: 3.17.5 

\[root@een-br420-71498 \~\]\# 

\[root@een-br420-71498 \~\]\# findmnt /opt/een/data 

TARGET SOURCE FSTYPE OPTIONS 

/opt/een/data /dev/nvme0n1p4 f2fs 

rw,noatime,lazytime,background\_gc=on,discard,no\_heap,user\_xattr,inline\_xattr,acl,inline\_data,inline\_dentr y,flush\_merge,extent\_cache,mode=adaptive,active\_logs=6,alloc\_mode=default,checkpoint\_merge,fsyn /opt/een/data /dev/md127 ext4 rw,relatime 

\[root@een-br420-71498 \~\]\# mkdir one\_time\_mount 

\[root@een-br420-71498 \~\]\# mount /dev/nvme0n1p4 one\_time\_mount/ 

\[root@een-br420-71498 \~\]\# ls one\_time\_mount/var/bridge/bridge/ 

398e1126-8db6-41db-acb7-9694a17d341a 

\[root@een-br420-71498 \~\]\# rm \-rf one\_time\_mount/var/bridge/bridge/398e1126-8db6-41db-acb7- 9694a17d341a/ 

\[root@een-br420-71498 \~\]\# cp \-r /opt/een/var/bridge/bridge/57c545d8-41b3-11ec-8ea2-d85ed3592e88 one\_time\_mount/var/bridge/bridge/ 

\[root@een-br420-71498 \~\]\# ls one\_time\_mount/var/bridge/bridge/ 

57c545d8-41b3-11ec-8ea2-d85ed3592e88 

**finding attached camera models** 

cd /opt/een/var/bridge/cameras;for i in \*/last\_match; do echo \-n " $i: " ; strings $i | head \-1 ; done | awk \-F '/last\_match' '{ print $1 $2}' | awk \-F ' \+' '{print $3}' |   
sort | uniq \-c | sort \-hr 

**Finding attached GUIDs** 

cd /opt/een/var/bridge/esns;for i in \*/camera\_service\_status; do echo \-n " $i: " ; strings $i | head \-2 | tail \-1; done | awk \-F'\[/:\]' '{ print $1 $3}' 

**Finding IP's of each guid** 

cd /opt/een/var/bridge/cameras && for i in \*/last\_address; do echo \-n " 

KaTeX parse error: Expected '}', got 'EOF' at end of input: …}: "; strings " 

i" | grep \-v 169.254 | head \-1; done | awk \-F'/last\_address' '{print $1 $2}' | grep \-F \-f \<(cat \<\<EOF 

) 

**Running 10 oacket ping to all camlan** 

for ip in $(arp \-an | awk '/10.143./ {print $2}' | tr \-d '()'); do ping \-c 10 $ip; done 

**ffprobe** 

13 cd /opt/een/var/bridge/esns;for i in \*/camera\_service\_status; do echo \-n " $i: " ; strings $i | head \-2 | tail \-1; done | awk \-F'\[/:\]' '{ print $1 $3}' 

14 pwd 

15 cd .. 

16 ls \-l 

17 cd cameras 

18 cd 4d55c000-8c59-11b5-845e-2432ae8b6906 

19 ls \-l 

20 cat stream\_info.json | jq 

21 ffprobe "rtsp://admin:6981024433@10.0.200.98:554/snl/live/1/1" 

user="onvif" 

pass="onvif" 

IP="10.143.32.210" 

streamURL="/profile1" 

*user* : *IP*  
ffprobe \-rtsp\_transport tcp \-loglevel repeat+level+verbose \-v debug "rtsp:// {pass}@ {streamURL}"   
user="onvif" 

pass="onvif" 

IP="10.143.32.210" 

streamURL="/profile1" 

ffprobe \-rtsp\_transport tcp \-loglevel repeat+level+verbose \-v debug 

"rtsp://onvif:onvif@10.143.32.210:9008/profile1" 

**delete unattached GUIDs** 

cd /opt/een/var/bridge/esns 

find / \-type f \-exec grep \-l "1002073b" {} \+\> /rmgtest 

cat /rmgtest 

cd /opt/een/var/bridge/cameras 

shopt \-s extglob 

(*cat*/*rmgtest*∣*tr* − *d* \[:′ *space* :\] ∣*sed s*/.   
′ ′  
rm \-rf \-- \!( //')) 

**Local display Layouts in use** 

Guillermo Tenorio III: @Jake Butts 

layouts are here: /opt/een/var/lib/local\_display/layouts 

In the example ESN you provided, 10022bbe, the files located here are: 

\[root@een-br325-62656 layouts\]\# ls 

0100\_a015a245-c8df-4c88-b760-b8cacdb12c3d.lout 1000\_default.lout layouts\_list.json 0110\_031f4641-1846-4bcb-b4c8-1ccf7d793847.lout last\_focus 

The Layouts in use are file: layouts\_list.json 

{ "layouts": \[ 

{"id":"0100\_a015a245-c8df-4c88-b760-b8cacdb12c3d.lout", "name":"325 test"}, 

{"id":"0110\_031f4641-1846-4bcb-b4c8-1ccf7d793847.lout", "name":"325 rotate"} \]} 

The default all cameras layout is 1000\_default.lout, ehic yuo can see has disabled equal to 1: 1000\_default.lout 

{ "cameras": \[ 

{ "esn": "10005857", "features": 255, "audio": 0, "name": "10005857", "width": 320, "height": 180, "size": 1}, { "esn": "100467cc", "features": 255, "audio": 0, "name": "100467cc", "width": 320, "height": 180, "size": 1}, { "esn": "100bad30", "features": 255, "audio": 0, "name": "100bad30", "width": 320, "height": 180, "size": 1}, { "esn": "100fbe39", "features": 255, "audio": 0, "name": "100fbe39", "width": 320, "height": 180, "size": 1}\],   
"disabled": 1 , 

"layout\_name": "All cameras" 

} 

Not sure what the file last\_foucs is though, so you got me there: 

10005857 

Guillermo Tenorio III: The unit indeed shows that 2 layouts are in use 

Guillermo Tenorio III: I pulled the location of the files from Tech Support Tools and Tricks image.png 

**Filling a hard drive** 

Create fake date on bridge in /opt/een/data 

fallocate \-l 50G file 

fallocate \-l 10T file2 

**Bridge SIGKILL check** 

journalctl \-xS "3 days ago" | grep bridge\_1 | grep \-v reaped | egrep "bridge|waiting|SIGKILL|SIGHUP" journalctl \-S "2023-04-26" | grep systemd | grep een-ipc 

**oshell for reboot** 

oshell \-u {user} \-p '{pass}' {IP\_Address} \-c 'print onvif.device.service.SystemReboot()' **Watch contianer upgrades** 

watch "ipccli \--get\_container \--container=bridge" 

core.bridge.0.cb0b9ea1e0ef429e8625aba6cf265e31.16279.1683051200000000.lz4 **Fix rpmdb: Thread died in Berkeley DB library** 

mkdir /var/lib/rpm/backup 

cp \-a /var/lib/rpm/\_\_db\* /var/lib/rpm/backup/  
rm \-f /var/lib/rpm/\_\_db.\[0-9\]\[0-9\]\* 

rpm \--quiet \-qa 

rpm \--rebuilddb 

yum clean all 

https://www.thegeekdiary.com/how-to-recover-from-a-corrupt-rpm-database-rebuilding-an-rpm-database/ **Yum command check** 

cat /var/log/dnf\* | grep \-E "ipc|upgrader" | grep \-E "will be upgrade|will be an upgrade|Downloading" | sort \-- human-numeric-sort 

**OOM check** 

journalctl \--dmesg \--no-pager | grep \-v iptables 

**Retention setting** 

**Check Video Data Storage Metrics (For when a bridge is purging / purges): Camera retention settings are:** 

for i in /opt/een/var/bridge/esns/\*/settings;do echo $i | awk \-F/ '{print $7}';python \-m json.tool $i | grep \-iE 'bridge|reten' | sort;done 

**Storage space taken by the cameras:** 

cd /opt/een/data/bridge/assets && ls */*/\* 

cd /opt/een/data/bridge/assets; df \-h .; du \-sh $(ls) | sort \--human-numeric-sort 

**What the streams are set to:** 

(*cd*/*opt*/*een*/*var*/*bridge*/*esns*; *foriin* ∗ /*cameraservicestatus*; *doecho* − *n*"  
for i in i: "; strings $i | head \-2 | tail \-1;done | awk \-F'\[/:\]' '{print $1 $3}' | awk \-F ' \+' '{print 

KaTeX parse error: Expected 'EOF', got '}' at position 2: 2}̲');do python \-m… 

i/stream\_info.json | grep \-E "width|height" | tr "\\n" " ";echo;done | sort | uniq \-c 

**ZMQ setting** 

python3 ./getSettings.py \-e 100048ba | grep \-E \-A 3 "retention|target|purge" | jq '.. | objects | select(has("retention") or has("purge") or has("target"))' 

jq 'to\_entries | map(select(.key \== "d" or .key \== "v")) | from\_entries' 

jq '.\[\] | select(has("retention"))'   
10022bbe 

100be4d6 

**Core dumps** 

Get corefile name: cd /cores && ls *PIDNUMBER* 

Enter the bridge container: docker exec \-it bridge\_bridge\_1 /bin/bash 

Change to the cores dir: cd /opt/een/data/cores 

Decompress the core: lz4cat 

core.bridge.0.231ecc57b4484e8dab50afd9903a67ae.1680242.1667148631000000.lz4.old \> core.bridge.0.231ecc57b4484e8dab50afd9903a67ae.1680242.1667148631000000 

Use gdb to get the backtrace: gdb /opt/een/bin/bridge 

core.bridge.0.231ecc57b4484e8dab50afd9903a67ae.1680242.1667148631000000 Use "bt" within gdb to get the backtrace. 

bt full 

frame \# 

print \*mux 

**Checking all cameras resolutions on a bridge** 

(*cd*/*opt*/*een*/*var*/*bridge*/*esns*; *foriin* ∗ /*cameraservicestatus*; *doecho* − *n*"   
for i in i: "; strings $i | head \-2 | tail \-1;done | awk \-F'\[/:\]' '{print $1 $3}' | awk \-F ' \+' '{print 

KaTeX parse error: Expected 'EOF', got '}' at position 2: 2}̲');do python \-m… 

i/stream\_info.json | grep \-E "width|height" | tr "\\n" " ";echo;done | sort | uniq \-c 

**Faster check** 

(*cd*/*opt*/*een*/*var*/*bridge*/*esns*; *foriin* ∗ /*cameraservicestatus*; *doecho* − *n*"  
for i in i: "; strings $i | head \-2 | tail \-1;done | awk \-F'\[/:\]' '{print $1 $3}' | awk \-F ' \+' '{print 

KaTeX parse error: Expected 'EOF', got '}' at position 2: 2}̲');do python \-m… 

i/driver\_script.out | grep \-E "width|height" | tr "\\n" " ";echo;done | sort | uniq \-c 

**Flushing arp tables** 

ip \-s \-s neigh flush all   
**Oversized .prv causing etag failures fix** 

find /opt/een/data/bridge/assets \-type f \-exec ls \-lh {} \+ | awk '{ print $5 " " $NF }' | sort \-hr | head \-n 1 find /opt/een/data/bridge/assets \-type f \-name "*.prv" \-size \+2G* 

*find /opt/een/data/bridge/assets \-type f \-name "*.prv" \-size \+2G \-delete 

**RTSP camera trojan** 

ffprobe \-v debug "rtsp://admin:Mac-84956@10.201.2.66/profile2/media.smp” change root:MK etc with camera credentials and IP/live with the Preview URL 

 "admin", 

 "Mac-84956" 

**Memory usage** 

\#\!/bin/sh 

ps \-eo rss,pid,user,command | sort \-rn | head \-$1 | awk '{ hr\[1024**2\]="GB"; hr\[1024\]="MB"; for (x=1024**3; x\>=1024; x/=1024) { 

if ($1\>=x) { printf ("%-6.2f %s ", $1/x, hr\[x\]); break } 

} } { printf ("%-6s %-10s ", $2, 

KaTeX parse error: Expected 'EOF', got '}' at position 4: 3\) }̲ { for ( x=4 ;… 

x) } print ("\\n") } 

' 

**Checking for purge** 

python \-m json.tool /opt/een/var/log/bridge/purge.json 

**Analytics check in Bridge app** 

ps aux | grep \-e 'analog.\*analytics' | grep \-v grep | wc \-l 

**LocalX count** 

ps \-A | grep xplayer | wc \-l 

**LPR check**  
tail \-f anpr/instance1/ffmpeg.log 

cd opt/een/data/uncanny/ 

Add LPR container 

ipccli \--add\_container \--container=ee-lpr-application-init \--url=c000.bridge.eencloud.com/bridge/ee-lpr application-init:2.0.0 

**Camera credentials on Bridge** 

cat /opt/een/var/bridge/security/credentials.js 

**Journalctl commands** 

journalctl \-xS today | grep wan0 

journalctl \-xS "start\_timestamp" \-U "ending\_timestamp" | grep 

| 

journalctl \-x \-u een-ipc \-u NetworkManager | grep \-vE "Dispatching|Plugin:" | grep \-E 'validate\_network|address' | grep \-E 'bridge|validate\_network' 

journalctl \-x \-u een-ipc \-u NetworkManager | grep \-vE 'Dispatching|Plugin:|Request: {"cmd": "bridge\_status"}|Request: {"cmd": "get\_container"' | grep \-E 'validate\_network|address|configura' \-A2 \-B2 | grep \-E 'bridge NetworkManager|validate\_network|configura' \-A2 \-B2 

Issues with 2N cameras 

You can still add the 2N IP verso to Eagle Eye Networks VMS platform following these instructions: 

Please bear in mind that the 2N IP verso cannot be reached via cloud tunnels (Satellite VPN Icon). Please be on the same subnet as camera and make the following changes to streaming \---\> RTSP on camera menu before adding it to Eagle Eye Networks Cloud Video platform. 

Please make sure: 

H264 video encoding is set to 15 fps and HD1 (720) or HD2 (1080) resolution. 

MJPEG video encoding is set no higher than 6 fps and CIF resolution. 

Please use the following URL's when adding as shown in the picture below. 

Main stream: h264\_stream 

Preview: mjpeg\_stream  
**Network Diagnostic in Host** 

netdiag 

**J1900 check script** 

echo \-n " Serial: "; strings /opt/een/etc/bridge/serial.number;echo \-n " ESN: "; strings /opt/een/var/bridge/bridge/\*/bridge\_service\_status | head \-1;echo \-n " CPU: "; echo grep "model name" /proc/cpuinfo | head \-1 | sed 's/^model name\\s\*:\\s\*//' " (" egrep ^processor /proc/cpuinfo 

| wc \-l " cores)";echo \-n " Uptime: "; uptime | awk '{$1=$1;print}';echo \-n " Number of Reboots in past 3 days: ";journalctl \-x \-S "3 days ago" | grep \-c "-- Reboot \--";echo "Reboot Logs:";journalctl \-x \-S "3 days ago" | grep \-v "List of devices attached" | grep \-B15 \-A5 "-- Reboot \--";last \-x 

**Trojan Horse to switch** 

Trojan Horse 

ssh root@192.40.5.251 \-o UserKnownHostsFile=/dev/null \-p54300 \-L8088:10.143.52.240:80 \-p51084 \= port that docker connects to the bridge. 

\-L8088: \= local port to connect to in your browser 

10.143.120.126:80 \= Local ip of the camera. 

Open browser and type Localhost:8088 

**Fping on all cameras** 

arp \-an | awk \-F'\[()\]' '{print $2}' | head \-100 | grep 10.143 \> /test && cat /test 

fping \-c 100 \-p 500 \-f /test 

**Smokeping conrols** 

smoke on: 

docker exec \-it smokeping\_smokeping\_1 nginx 

smoke off:sec, gotta find ols commands 

docker exec \-it smokeping\_smokeping\_1 nginx \-s quit 

192.168.4.67:33080  
**Finding Drive info on bridges** 

ls \-lF /dev/disk/by-id/ 

**Manual add of Talkdown** 

ipccli \--add\_container \--container=talkdown \--version=1.5.0 \-- 

url=c000.bridge.eencloud.com/bridge/talkdown-client: 

export username="admin" 

export ip\_address="10.143.0.3" 

export port="5060" 

*username*@  
docker exec \-it asterisk-cli asterisk \-rx "channel originate PJSIP/anonymous/sip: ip\_address:$port extension 100" 

**Lease Time** 

cat /etc/dnsmasq.d/camlan0.conf 

**Raid check** 

sysctl \-a | grep raid 

fix 

sysctl \-w dev.raid.speed\_limit\_max=65000 

rm \-f /etc/cron.d/raid-check 

**Inactive Raid** 

cat /sys/block/md127/md/array\_state 

cat /proc/mdstat 

mdadm \--detail /dev/md127 

mdadm \--assemble \--run \--force \--verbose /dev/md127 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj 

You'll add the spares back with one of these 2: 

for i in /dev/sd?; do mdadm \--re-add /dev/md127 $i; done 

for i in /dev/sd?; do mdadm \--add /dev/md127 $i; done 

Then bring it online again with:   
fsck \-y /dev/md127; mkdir /raid;mount /dev/md127 /raid;rsync \-auv /opt/een/data/ /raid/;rsync \-auv /opt/een/data/ /raid/;rsync \-auv /opt/een/data/ /raid;systemctl stop critical-service-health.timer && systemctl stop run-all-containers; sleep 5;mount \--bind /raid/ /opt/een/data/; sleep 5; systemctl start run-all-containers && systemctl start critical-service-health.timer; sleep 5; systemctl restart een-ipc 

**Emergency tunnels, from exec only** 

curl \-O https://mfg.int.eencloud.com/emergency-tunnel.sh \-k 

bash emergency-tunnel.sh \--keep \--noexec 

/setup/emergency-tunnel 

then log into MFG and paste the ssh output from exec 

EXEC \---\> echo 'root:REDACTED' | chpasswd && echo Yes 

yes 

**Upgrade command search in Plat 1** 

grep command /opt/een/var/log/bridge/bridge.log 

**Reading Crash Dumps** 

lz4 \-d {coredump} 

then gdb 

gdb /opt/een/bin/bridge {coredump} 

then bt to get a backtrace 

**Kernel crash logs** 

ls \-l /var/crash 

This will give you the file path, depending on how the bridge became Plat 2, ls \-l the new file path. **Panic:** 

echo c \> /proc/sysrq-trigger 

**THIS WILL CAUSE THE BRIDGE TO CRASH, USE ONLY FOR TESTING IN A CONTROLLED ENVIRONMENT**  
**Watchdog:** 

systemctl stop watchdog-manager 

systemctl stop watchdog 

cat \> /dev/watchdog 

sysctl \-a kernel.panic=30 

**Finding public IP** 

host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}' **Password not fixed** 

'echo "root:" | chpasswd' 

^^ This by itself will fix it until the system reboots or otherwise reapplies the personality. grep root /etc/shadow \-- get the new password hash 

Edit /personality.json and change rootPassword to the new hash. 

personalityctl commit 

**Alternative path** 

grep the MAC through /var/log/messages on the SARA station to get the serial number (tricksy\!) Look it up in eenadmin and get to the exec screen (grabbing the password in the process). grep /etc/shadow to get root's current password salt+hash.   
6   
Pull off the salt part (from the through the last dollar sign) and run: 

*salt*   
echo \-e 'import crypt\\nprint(crypt.crypt('password', ' '))' | python 

...to get what the password hash SHOULD be if the salt+password are right. They were not. 

So then I just ran: 

*salt*  
echo 'root: hash' | chpasswd \-e 

and then logged in. 

**Speed Test on Bridge** 

11 docker exec \-it bridge\_bridge\_1 wget \-O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest cli/master/speedtest.py   
12 docker exec \-it bridge\_bridge\_1 chmod \+x speedtest-cli 13 docker exec \-it bridge\_bridge\_1 python2 speedtest-cli 

**X contianer not available for bridge** yum install \-y upgrader ipc python-diag 

cat /opt/een/etc/bridge/bridge.cluster 

cat /opt/een/data/docker-compose/bridge/docker-compose.yml 

nmap \-p 443    
(*cat*/*opt*/*een*/*etc*/*bridge*/*bridge*.*cluster*).*bridge*.*eencloud*.*comcurl* − *v* − 

*Lhttps* : //  
(cat /opt/een/etc/bridge/bridge.cluster).bridge.eencloud.com:773/bridge/ 

curl \-v \-L 192.40.5.140:443 

curl https://.bridge.eencloud.com/v2/\_catalog 

docker pull .bridge.eencloud.com/bridge/bridge-guest:3.14.4 

**MTR install 2022-03-01 or newer** 

dnf \--enablerepo=baseos install mtr \-y 

**Get hardware version** 

curl http://repo.plumv.com/repo/centos/6/x86\_64/hardware.sh 2\>/dev/null | bash **ARP history is MAC is offline** 

cat /proc/net/arp 

**Verifying a webfilter** 

curl http://repo.plumv.com/repo/een/6/x86\_64/repodata/repomd.xml \-o repomd.xml \-vvv **bandwidth monitor** 

bmon \-b 

You press d for more info.   
**atop** 

**adding Almalinux repos for tools** 

dnf config-manager \--add-repo http://repo.almalinux.org/almalinux/8/BaseOS/x86\_64/os/ && dnf config manager \--add-repo http://repo.almalinux.org/almalinux/8/AppStream/x86\_64/os/ 

sudo yum install epel-release \-y 

yum install \-y atop 

**Nmap to the camera** 

nmap \-sT \-sU \-T25 \-p 80,443,773,8081,8082,50000,60000 10.143.147.174 

**Containers won't start** 

Check ps ax | grep een-ipc 

systemctl status een-ipc ? 

systemctl restart een-ipc 

Check for docker files 

ls \-l /opt/een/data/docker-compose/bridge 

(so no config to even start the bridge container) 

**kernel logs** 

zless /var/log/messages-.gz 

zgrep kernel /var/log/messages\* 

ssh mfg@localhost \-p 33022 

supervisorctl status bridge 

cat /var/log/supervisor/supervisord.log 

zless /var/log/messages-20220225.gz | grep een-ipc  
cd /etc/yum.repos.d/ && sed \-i 's/mirrorlist/\#mirrorlist/g' /etc/yum.repos.d/CentOS-\* && sed \-i 's|\#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-\* && yum install \-y upgrader ipc python-diag 

968c2ad8b20eb2c0bd2e8b8acfcf86d4 

**Sara stations** 

ssh mfg@mfg.int.eencloud.com (use BIOS password) 

ssh saraXX (whatever sara station you got) 

ssh \-p 33022 mfg@ (where the IP is what you discovered ^) 

**LocalX** 

for i in /sys/class/drm/\*/status; do cat $i; done | grep \-wc 'connected' && ps ax | grep awesome && docker exec \-it bridge\_bridge\_1 grep 'initial mode' /var/log/Xorg.0.log && ps ax | grep xplayer && docker exec \-it bridge\_bridge\_1 status localx 

Then DISPLAY=":0" import \-window root /local.png && cd / && ls \-l | grep local.png Check filesize 

for i in /sys/class/drm/\*/status; do echo "$i: " cat $i ; done && ps ax | grep \-E 'awesome|xplayer' && docker exec \-it bridge\_bridge\_1 bash \-c "grep 'initial mode' /var/log/Xorg.0.log ; status localx" 

X running but awesome isn't 

ps ax | grep X 

then kill the PID with something resembling this in it /usr/libexec/Xorg :0 \-nocursor \-configdir /opt/een/etc/X11/xorg.conf.d 

then start localx in bridge container or via docker exec \-it bridge\_bridge\_1 start localx it'll restart X, and Awesome with it 

**Analog troubleshooting** 

In Host OS, on V3, use the following command to install Video4Linux 

yum install \-y v4l-utils  
**checking if the cameras are connected** 

*i* : "; *v*4*l*2 − *ctl* − −*all* − *d*/*dev*/*video*"  
for i in seq 0 15 ; do echo \-n " i"| grep 'Video input'; done; 

**checking if the analog drivers are on the bridge.** 

lspci | grep 6869 && lsmod | grep tw686 && ls 

/lib/modules/5.15.52/kernel/drivers/media/pci/tw686x/tw686x.ko.xz 

cd /opt/een/var/bridge/raw ; ls \* 

\[root@een-br410-64555 \~\]\# cd /opt/een/var/bridge/raw 

\-bash: cd: /opt/een/var/bridge/raw: No such file or directory 

\[root@een-br410-64555 \~\]\# 

to get reboot: 

last reboot | less 

Shows the last shutdowns on the bridge: 

last \-x | less 

This will show more detail about the hardware on the bridge 

bridge-diag \--long 

zgrep kernel /var/log/messages\* 

**Checking for hardware errors** 

\[root@een-br304-28597 \~\]\# zgrep \--binary-files=text 'Machine check' /var/log/messages\* To downgrade the bridge 

upgrader \--downgrade 

once it's downgraded, and you can log back in, you want to remove all previous V3 files rm \-rf /personality.json /opt/een/data/platform2 /opt/een/data/docker /opt/een/data/ipc.sock 

Update to 2.3.8: 

yum update-to bridge-product-2.3.8   
Update to 2.5.6: 

yum update-to bridge-product-2.5.6 

cat /var/log/platform-upgrader.log 

Command for Power Gov change performance to what ever setting needs to be ran at Then you want to confirm the changes by running 

cat /sys/devices/system/cpu/cpu\*/cpufreq/scaling\_governor 

Setting to performance 

for i in /sys/devices/system/cpu/cpu\*/cpufreq/scaling\_governor; do echo "Before: $i" ; cat $i; echo 'performance' \> $i; echo "After: " ; cat $i; done 

Setting to OnDemand 

for i in /sys/devices/system/cpu/cpu\*/cpufreq/scaling\_governor; do echo "Before: $i" ; cat $i; echo 'ondemand' \> $i; echo "After: " ; cat $i; done 

Setting to Powersave 

for i in /sys/devices/system/cpu/cpu\*/cpufreq/scaling\_governor; do echo "Before: $i" ; cat $i; echo 'powersave' \> $i; echo "After: " ; cat $i; done 

**EEPD-11954: "All bridges need to be set to Ondemand with the exception of the 504+d at powersave and with max\_perf\_pct=75"** 

GOVERNOR\_CONFIGURATION \= { 

"default": ("ondemand", None), \# Everything should be intel\_cpu and ondemand but... "501": ("performance", None), 

"504p": ("powersave", "75"), \# 504 and 524 is powersave and max\_perf\_pct \= 75 "524p": ("powersave", "75"), 

"310": ("performance", None), 

"330": ("performance", None), 

"401": ("performance", None), 

"420": ("performance", None), 

"403": ("powersave", None), 

"410": ("performance", None), 

"430": ("performance", None), 

"520": ("performance", None), 

"620": ("performance", None),  
"820": ("performance", None), 

} 

Command to purge the drive 

rm \-rf /opt/een/data/bridge/assets/\* 

\-------------------------------------------------\`\`\` 

**finding camera password in Bridge** 

cat /tmp/camtool\_logs/10038bd9\_bridge.logs | grep b0026f56-cf69-11b2-80e2-54c4158c81cd | less 

1642241491EEN 

**Fixing Raids** 

Since we almost always use ext2/3/4, it's almost always in the form of "e2fsck \-y /dev/whatever". If you want to force a check no matter what (on ext3/4, if the disk was unmounted cleanly, it'll short-circuit and you might not want that), do "e2fsck \-fy /dev/whatever". 

\-y means "answer yes to any non-destructive questions you may have" 

\-f means "force the full check anyway, regardless of the state of the fs". 

There are also things you might mess with occasionally in tune2fs to change things like the name of the filesystem, add/remove a journal, or other adjustments. I've personally never had to use tune2fs on a customer box, but I've used it while profiling new machines in mfg from time to time. 

Yeah, the one exception to that rule is when we're talking about freshly-manufactured p2 boxes with SSDs. We use f2fs on /opt/een/data, so if e2fsck gives you a "holy crap, I can't find an ext\* filesystem" it's either you're using the wrong /dev/whatever or you should be using fsck.f2fs instead. 

(boxes not native to p2 don't have this, obvs). 

At what point, do we use these fsck tools in troubleshooting? 

**BJ's wizardry for bridges losing EEN-IPC, but it's running** General steps performed:  
Down all processes using /opt/een/data, unmount it, and e2fsck \-fy it. 

Remount and remove all of /opt/een/data/docker. 

Upgrade to 2022-01-28, which will force the containers to be reloaded and /opt/een/data/docker to be recreated along with other missing stuff on /opt/een/data. 

After reboot, make sure containers came back up. 

Marvel at the SMART: Poor entry in bridge-diag and start look at smartctl for reasons why. ipccli \--upgrade\_container \--version=3.11.1 && watch "ipccli \--get\_container"