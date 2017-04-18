# aws-utils
Convenient stuff for working with AWS

## Create and attach an EBS volume

1. Create EBS volume.

        $ aws ec2 create-volume --size=100 --volume-type=gp2 --availability-zone=us-east-1a
        
        {
            "VolumeType": "gp2",
            "AvailabilityZone": "us-east-1a",
            "State": "creating",
            "Encrypted": false,
            "Iops": 300,
            "VolumeId": "vol-08bc2e2ee05c8a4b5",
            "SnapshotId": "",
            "Size": 100,
            "CreateTime": "2017-04-18T21:22:46.006Z"
        }
    
2. Get EC2 instance ID to attach volume.

        $ ec2metadata --instance-id
        
        i-0c1ec80818162fbc6
        
3. Attach volume to instance.

        $ aws ec2 attach-volume --volume-id=vol-08bc2e2ee05c8a4b5 --instance-id=i-0c1ec80818162fbc6 --device=/dev/xvdg
        
4. Create filesystem.

        $ sudo mkfs -t ext4 /dev/xvdg
        
5. Mount disk.

        sudo mkdir /data
        
        sudo mount /dev/xvdg /data
