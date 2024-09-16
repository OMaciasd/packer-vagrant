packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  iso_url          = "https://releases.ubuntu.com/22.10/ubuntu-22.10-live-server-amd64.iso"
  iso_checksum     = "sha256:874452797430a94ca240c95d8503035aa145bd03ef7d84f9b23b78f3c5099aed"
  output_directory = "output-ubuntu"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  communicator     = "ssh"
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  vm_name          = "ubuntu-vm"
  disk_size        = 10240
  cpus             = 2
  memory           = 4096
  ssh_wait_timeout = "20m"
  headless         = false

  boot_wait            = "10m"
  http_directory       = "http"
  guest_additions_path = "VBoxGuestAdditions.iso"

  boot_command = [
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US<wait>",
    " fb=false<wait>",
    " initrd=/install/initrd.gz<wait>",
    " kbd-chooser/method=us<wait>",
    " keyboard-configuration/layout=USA<wait>",
    " keyboard-configuration/variant=USA<wait>",
    " locale=en_US<wait>",
    " netcfg/get_hostname=ubuntu<wait>",
    " netcfg/get_domain=<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]
}

build {
  sources = [
    "source.virtualbox-iso.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl"
    ]
    environment_vars = ["DEBUG=true"]
  }
}
