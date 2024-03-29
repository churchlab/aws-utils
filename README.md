# aws-utils
Church Lab AWS policies and helpful commands

*Contact person: Gleb Kuznetsov (gleb.kuznetsov@gmail.com)*

## Introduction

AWS is great for compute because of the ability to create VMs in the cloud with full permissions (e.g. sudo), etc. So far, we have been fortunate to have receive credits from Amazon to support specific projects.

Please become very familiar with AWS pricing, especially for [EC2](https://aws.amazon.com/ec2/pricing/on-demand/), [EBS](https://aws.amazon.com/ebs/pricing/), and [S3](https://aws.amazon.com/s3/pricing/). We run all our machines in US East (N. Virginia).

When possible, please do your work and store data on Orchestra, etc. That said, there are cases where AWS is appropriate, such as for installing custom software, etc.

If you will be scaling up your usage beyond $50/mo., please talk to me about putting together your own AWS credits request.

## General culture

Please be efficient, careful, and clean with everything. When in doubt, please talk to Gleb. It's easy for lots of cruft to accumulate so everyone's help with this is appreciated. Please stop machines when you are not using them. Please terminate unused instances. Please move data to Orchestra when possible.

## Rules of thumb

* Do everything in US-East (N. Virgina) region and us-east-1a zone. This makes it easy to track and attach EBS etc.

## Naming

Please name any machines, AMIs, etc. that you create with the following format:

        initials_date_purpose
        
For example:

        GK_2017_04_20_sequence_all_the_things
        
Any machine without a name will be renamed "DELETE_ME" and will be deleted 24 hours later.

No need to name your EBS volumes if they are attached to a machine, but unattached volumes without a name will also be marked for deletion.

## Church Lab AWS Efficiency Policy

The following are strategies for getting the most bang for our AWS dollars. These are evolving and suggestions are welcome. As always, come talk to Gleb for help or clarification.

Until recently most of us were doing the *simple* strategy of creating EC2 instances backed by a single large EBS. The problem here is that EBS is charged independent of whether the machine is on at $0.10/GB, so a 1000 Gb EBS is going at $100/month or $1200/year. Bad. The problem is that most of us only use a fraction of the allocated EBS and then there are long periods between use as per the nature of research.

Instead, the policy moving forward for 99% of cases is to create EC2 instances backed by EBS w/ maximum size 30Gb. This should be plenty of space for the OS and any software you install. Any data you need to persist should be synced to S3, since S3 charges per-use and is cheaper ($0.023 per GB-month).

Some Marketplace (pre-configured) AMIs have a minimum size so go ahead and do the minimum required there as long it's not over 100 Gb. If it is, talk to me please.

So the flow should look like:

1. Turn on machine.
2. Allocate temporary storage (mount ephemeral or attach EBS, see below).
3. Sync data you need to work with from s3.
4. Do computations.
5. Sync updated data back up to s3.
6. Unmount / delete attached EBS.

For (2) allocating temporary storage, you have two options:

1. Mount ephemeral [Instance Store](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html). This is only available for some instance types. See the [EC2 pricing guide](https://aws.amazon.com/ec2/pricing/on-demand/). Note this gets wiped on reboot.

2. Create and attach external EBS (see instructions below). This is nice and flexible because you can create the EBS volume size you need, use it, then get sync data back to s3, and delete the EBS.

## Create and attach an EBS volume

Similar to the [AWS EBS Docs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html):

1. Create EBS volume. This can be done from the [EC2 concosle](https://console.aws.amazon.com/ec2/v2/home) by clicking on Volumes and then the Create Volume button.
    
2. Attach the new volume to the desired EC2 instance by selecting the checkbox next to it and pressing the Actions button and Attach Volume.
    
3. Ssh into the EC2 instance and check that the volume is attached:

        $ lsblk
        
4. Create filesystem on the new volume (assuming it wasn't created before). Make sure to use correct attach point. In this example we use `/dev/xvdf`.

        $ sudo mkfs -t ext4 /dev/xvdf
        
5. Mount the disk to be accessible for writing.

        sudo mkdir /data
        
        sudo mount /dev/xvdf /data
        
6. Allow user to write to location.

        sudo chown -R ubuntu:ubuntu /data
        
Now you can do `aws s3 sync` etc to the mounted location. Remember to update your code to point to your newly mounted path.

**NOTE**: If you're keeping the attached EBS between boots, you'll have to remount on boot up, or update the `/etc/fstab` file to automatically mount on boot by adding the following line. You should also make a backup of fstab (`cp /etc/fstab /etc/fstab.org`) before you edit it just in case:

        /dev/xvdf /data ext4  defaults,nofail 0 2

## Sync data from s3 to EC2 instance

Use `sync` to get data. This is better than `cp` in all cases I can think of since it makes the `<local_path>` matches `s3://...` without doing redundant copies. This is nice if transfer gets interrupted, or if a collaborator pushes more data to the bucket.

    aws s3 sync s3://<bucket_name>/<path> <local_path>
        
Specific example:

    aws s3 sync s3://mlpe-data/2017_04_08_mlpe_gfp_fix_2_miseq_redo/ /data/2017_04_08_mlpe_gfp_fix_2_miseq_redo/
    
## Sync data from EC2 instance back to s3

Just reverse the target and destination:

    aws s3 sync <local_path> s3://<bucket_name>/<path> 
    
NOTE: **DO NOT USE `--delete`**. This will delete files in the s3 bucket to make it match what's in the local path. You can imagine really screwing things up if you get this wrong. So if you need to delete files, do it manually, please. Or come to talk to Gleb.

