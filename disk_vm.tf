# Создание 3 одинаковых дисков через count
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name     = "storage-disk-${count.index + 1}"
  type     = "network-hdd"
  size     = 1
  zone     = var.default_zone
}

# Одиночная ВМ "storage" (без count и for_each)
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  # Подключение дополнительных дисков через dynamic + for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk[*].id
    content {
      disk_id = secondary_disk.value
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