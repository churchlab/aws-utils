# aws-utils
Convenient stuff for working with AWS

## Create and attach an EBS volume

1. Create EBS volume.

        $ aws ec2 create-volume --size=100 --volume-type=gp2 --availability-zone=us-east-1a
        
        {
            ...
            "VolumeId": "vol-xxxxx",
            ...
        }
    
2. Get EC2 instance ID to attach volume.

        $ ec2metadata --instance-id
        
        i-xxxxx
        
3. Attach volume to instance.

        $ aws ec2 attach-volume --volume-id=vol-xxxxx --instance-id=i-xxxxx --device=/dev/xvdg
        
4. Create filesystem.

        $ sudo mkfs -t ext4 /dev/xvdg
        
5. Mount disk.

        sudo mkdir /data
        
        sudo mount /dev/xvdg /data
