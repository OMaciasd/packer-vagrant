packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
  iso_checksum     = "sha256:YOUR_CHECKSUM_HERE"
  output_directory = "output-ubuntu"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  communicator     = "ssh"
  ssh_username     = "ubuntu"
  ssh_password     = "your_password_here"
  vm_name          = "ubuntu-vm"
  disk_size        = 10240
  cpus             = 2
  memory           = 4096
  boot_command_sequence = [
    "<esc><wait>",
    "install <wait>",
    "<enter>"
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
  }
}
