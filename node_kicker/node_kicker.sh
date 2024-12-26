aws ec2 describe-subnets --subnet-ids $SUBNET_ID --query 'Subnets[*].AvailableIpAddressCount' --region $AWS_REGION --output text

aws ec2 describe-instances --region $AWS_REGION --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddresses[*].{PrivateIpAddress:PrivateIpAddress}' --output text | wc -l




#NODE_NAME=$(curl --silent http://169.254.169.254/latest/meta-data/hostname)
NODE_NAME=$(curl --silent http://169.254.169.254/latest/meta-data/local-hostname|cut -d '.' -f1).ec2.internal

INTERFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/ | head -n1)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/vpc-id)
AvailableIpAddressCount=$(aws ec2 describe-subnets --subnet-ids $SUBNET_ID --query 'Subnets[*].AvailableIpAddressCount' --region $AWS_REGION --output text)
echo "SubnetID: $SUBNET_ID"
echo "AvailableIpAddressCount : $AvailableIpAddressCount"

if [ $AvailableIpAddressCount -lt 20 ];
    then
    ./kubectl taint node $NODE_NAME AvailableIpAddress=false:NoSchedule
    ./kubectl label node $NODE_NAME AvailableIpAddress=false  
    echo "$NODE_NAME: Subnet doesnot have enough IP's available, Tainting Node"
fi 

sleep 60
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
SECONDARY_IPS=$(aws ec2 describe-instances --region $AWS_REGION --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddresses[*].{PrivateIpAddress:PrivateIpAddress}' --output text | wc -l)

echo "$NODE_NAME: SECONDARY_IPS on Node : $SECONDARY_IPS"

if [ $SECONDARY_IPS -lt 6 ]; 
    then
    ./kubectl taint node $NODE_NAME SecondaryIpAddress=false:NoSchedule
    ./kubectl label node $NODE_NAME SecondaryIpAddress=false
else
    echo "$NODE_NAME: Enough secondary IP's available, not Tainting"
fi

sleep 120

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
SECONDARY_IPS=$(aws ec2 describe-instances --region $AWS_REGION --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddresses[*].{PrivateIpAddress:PrivateIpAddress}' --output text | wc -l)
echo "$NODE_NAME: SECONDARY_IPS on Node : $SECONDARY_IPS"

if [ $SECONDARY_IPS -gt 6 ]; 
    then
    ./kubectl taint node $NODE_NAME SecondaryIpAddress=false:NoSchedule-
    ./kubectl label node $NODE_NAME SecondaryIpAddress-
    echo "$NODE_NAME: Enough secondary IP's available,  Untainting"
fi

while true; do sleep 30; done