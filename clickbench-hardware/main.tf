data "nirvana_compute_vm_os_images" "vm_os_images" {}

resource "nirvana_networking_vpc" "vpc" {
  region = var.region

  name        = var.name
  subnet_name = var.name

  tags = var.tags
}

resource "nirvana_networking_firewall_rule" "vpc_firewall_rule_ssh" {
  name                = "ssh"
  vpc_id              = nirvana_networking_vpc.vpc.id
  protocol            = "tcp"
  source_address      = var.my_ip
  destination_address = nirvana_networking_vpc.vpc.subnet.cidr
  destination_ports   = ["22"]

  tags = var.tags
}

resource "nirvana_compute_vm" "vm" {
  region = var.region

  name          = var.name
  os_image_name = data.nirvana_compute_vm_os_images.vm_os_images.items[0].name
  ssh_key = {
    public_key = var.ssh_public_key
  }
  cpu_config = {
    vcpu = var.cpu
  }
  memory_config = {
    size = var.memory
  }
  boot_volume = {
    size = var.boot_disk_size
    type = local.volume_type
  }
  data_volumes = [
    {
      name = "data"
      size = var.data_disk_size
      type = local.volume_type
    }
  ]

  subnet_id         = nirvana_networking_vpc.vpc.subnet.id
  public_ip_enabled = true

  tags = var.tags
}

resource "null_resource" "run_benchmark" {
  connection {
    host        = nirvana_compute_vm.vm.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh_private_key)
    timeout     = var.provisioner_timeout
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/vdb",
      "sudo mkdir /data",
      "sudo mount /dev/vdb /data",
      "sudo chown $USER:$USER /data",
      "echo '/dev/vdb /data ext4 defaults 0 2' | sudo tee -a /etc/fstab",
      "cd /data",
      "wget https://raw.githubusercontent.com/ClickHouse/ClickBench/main/hardware/hardware.sh",
      "chmod a+x ./hardware.sh",
      "./hardware.sh > /tmp/benchmark.log 2>&1 && echo 'Benchmark completed successfully' || echo 'Benchmark failed'"
    ]
  }

  depends_on = [nirvana_compute_vm.vm]
}
