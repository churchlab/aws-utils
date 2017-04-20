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
        
6. Allow user to write to location.

        sudo chown -R ubuntu:ubuntu /data
        
Now you can do `aws s3 sync` etc to the mounted location. Remember to update your code to point to your newly mounted path.

**NOTE**: If you're keeping the attached EBS between boots, you'll have to remount on boot up, or update the `/etc/fstab` file to automatically mount on boot by adding the following line. You should also make a backup of fstab (`cp /etc/fstab /etc/fstab.org`) before you edit it just in case:

        /dev/xvdg /data ext4  defaults,nofail 0 2

## Sync data from s3 to EC2 instance

Use `sync` to get data. This is better than `cp` in all cases I can think of since it makes the `<local_path>` matches `s3://...` without doing redundant copies. This is nice if transfer gets interrupted, or if a collaborator pushes more data to the bucket.

    aws s3 sync s3://<bucket_name>/<path> <local_path>
        
Specific example:

    aws s3 sync s3://mlpe-data/2017_04_08_mlpe_gfp_fix_2_miseq_redo/ /data/2017_04_08_mlpe_gfp_fix_2_miseq_redo/
    
## Sync data from EC2 instance back to s3

Just reverse the target and destination:

    aws s3 sync <local_path> s3://<bucket_name>/<path> 
    
NOTE: **DO NOT USE `--delete`**. This will delete files in the s3 bucket to make it match what's in the local path. You can imagine really screwing things up if you get this wrong. So if you need to delete files, do it manually, please. Or come to talk to Gleb.

