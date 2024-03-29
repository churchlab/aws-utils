{
  "variables": {
    "region": "us-east-1",
    "source_ami": "ami-d15a75c7",
    "subnet_id": "subnet-712d181f",
    "vpc_id": "vpc-XXXXX"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "region": "{{user `region`}}",
      "source_ami": "{{user `source_ami`}}",
      "ssh_username": "ubuntu",
      "ami_name": "dl-cluster-node {{isotime \"2006-01-02T15:04:05Z\" | clean_ami_name}}",
      "instance_type": "t2.medium",
      "subnet_id": "{{user `subnet_id`}}",
      "vpc_id": "{{user `vpc_id`}}",
      "enhanced_networking": true,
      "launch_block_device_mappings": [{
        "delete_on_termination": true,
        "device_name": "/dev/sda1",
        "volume_size": 20,
        "volume_type": "gp2"
      }]
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "script": "../scripts/base.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "inline": [
        "sudo apt-get update",
        "sudo apt-get install -y python-apt python-pip",
        "sudo apt-get clean"
      ]
    },
    {
      "type": "shell",
      "inline": [
        "sudo apt-get update",
        "sudo apt-get install -y rpcbind nfs-common nfs-kernel-server rxvt cachefilesd",
        "sudo apt-get clean"
      ]
    },
    {
      "type": "ansible",
      "playbook_file": "playbook.yml",
      "extra_arguments": "-vv"
    },
    {
      "type": "shell",
      "script": "scripts/install_sge.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "script": "scripts/docker_options.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "script": "../scripts/install_ena.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "inline": [
        "sudo docker pull tensorflow/tensorflow:1.1.0-devel-gpu",
        "sudo docker pull tensorflow/tensorflow:1.2.0-devel-gpu",
        "sudo docker pull spotify/docker-gc",
        "echo 'tensorflow/tensorflow:.*\nspotify/docker-gc' | sudo tee /etc/docker-gc-exclude"
      ]
    },
    {
      "type": "file",
      "source": "./usr/local/bin/configure-nvidia.sh",
      "destination": "/tmp/configure-nvidia.sh"
    },
    {
      "type": "file",
      "source": "./etc/systemd/system/nvidia-docker-volume.service",
      "destination": "/tmp/nvidia-docker-volume.service"
    },
    {
      "type": "shell",
      "script": "scripts/install_configure-nvidia.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "script": "scripts/install_mount-s3.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    },
    {
      "type": "shell",
      "script": "../scripts/cleanup.sh",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    }
  ]
}
