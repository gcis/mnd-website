#!/usr/bin/env bash

cd $2/src/main/ec2scripts

#!/bin/bash
export EC2_HOME=/var/lib/jenkins/ec2-api-tools-1.6.12.0
export AWS_ELB_HOME=/var/lib/jenkins/ElasticLoadBalancing-1.0.34.0
export PATH=$PATH:$EC2_HOME/bin:$AWS_ELB_HOME/bin

export JAVA_HOME=/usr/bin/java

echo "direttore $1 $2 $3 $4"
export AWS_ACCESS_KEY=$1
export AWS_SECRET_KEY=$2
export EC2_PRIVATE_KEY=$3
export EC2_CERT='/var/lib/jenkins/meteor.pem'

amiid=$4
region=us-west-2b
instancecount=1
key=dino_telecom
group=sg-f235d09b
lbId="mondora-app-balancer"
tagname="mondora-app"

ec2_instance_type="t1.micro"

echo "EC2_INSTANCE_TYPE: $ec2_instance_type"

##############

## build userdatafile
userdatafile="initawsParametrized.sh"
echo "cd /var/www" >> $userdatafile
echo "git clone https://github.com/mondora/mnd-website.git" >> $userdatafile
chmod +x $userdatafile

cat $userdatafile
echo "... STARTING to build EC2 instance..."
echo

rm *out

echo "describe existing Elastic Load Balancers for region $region"
elb-describe-lbs --region $region > LOAD_B_DESC.out
cat LOAD_B_DESC.out

echo "$AWS_ACCESS_KEY $AWS_SECRET_KEY $EC2_PRIVATE_KEY"

echo "launch new EC2 instance from AMI-ID ($amiid) with user data file: $userdatafile"
ec2-run-instances --instance-count $instancecount --user-data-file=$userdatafile --cert="/var/lib/jenkins/meteor.pem" --instance-type=$ec2_instance_type --group=$group --region=$region $amiid > NEW_INSTANCE.out

instanceId=`./getInstanceId.pl NEW_INSTANCE.out`
echo "created new EC2 instance: $instanceId"
cat NEW_INSTANCE.out

#echo "add TAGs to instance: $tagname"
#ec2-create-tags $instanceId --tag="Name=$tagname" --region=$region > EC2_TAGS.out
#cat EC2_TAGS.out

echo "add instance $instanceId to elastic load balancer (after 5 minutes)"
sleep 300

for i in {1..5}
do
   elb-register-instances-with-lb $lbId --instances $instanceId --region=$region > ELB_REG_INST.out
   OUT=$?
   cat ELB_REG_INST.out

   if [ $OUT -eq 0 ];then
      echo "add to Elastic Load Balancer!"
      break
   else
      echo "retry... (10 sec.)"
      sleep 10
   fi
done

echo "wait few minutes to see work the application"
rm -f $userdatafile
echo "Done."
