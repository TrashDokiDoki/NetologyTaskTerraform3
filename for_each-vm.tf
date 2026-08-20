# Преобразуем список в map для for_each
locals {
  db_vms = {
    for vm in var.each_vm : vm.vm_name => vm
  }
}

# Создание ВМ БД через for_each
resource "yandex_compute_instance" "db" {
  for_each = local.db_vms

  name        = "db-${each.value.vm_name}"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}