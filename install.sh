cd /root/
[ -e bityuan ] && cd bityuan && ./bityuan-cli net info && exit 0
apt-get update
apt-get install wget -y
apt-get install supervisor -y
wget https://raw.githubusercontent.com/asinen/3571/master/bityuan_ubuntu.tgz
tar zxf bityuan_ubuntu.tgz
cd bityuan
cp bty.conf /etc/supervisor/conf.d/bty.conf
supervisorctl reload
supervisorctl start bty
sleep 15
./bityuan-cli net info

cd ~/bityuan
./bityuan-cli seed generate -l 0  > ~/mySeed.txt
echo "bty123456" > ~/myPass
cat ~/mySeed.txt | xargs -I{} ./bityuan-cli seed save -p bty123456 -s "{}"
./bityuan-cli  wallet unlock  -p bty123456 -s wallet -t 0
sleep 15
./bityuan-cli account  list  | grep "airdropaddr" -B 2 | grep addr  -w | cut -d '"' -f 4 > ~/myAirdropAddr
cat ~/myAirdropAddr | xargs -I{} ./bityuan-cli  account dump_key -a {} > ~/myAirdropPriv
cat ~/myAirdropPriv | grep data| cut -d '"' -f 4 | xargs  -I{} echo "account import_key -l vul000 -k {} "