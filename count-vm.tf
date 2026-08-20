# Data-блок для образа
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

# Создание двух одинаковых ВМ через count
resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"  # web-1, web-2 (не web-0!)
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

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }

  # Зависимость: создаём после ВМ из for_each
  depends_on = [yandex_compute_instance.db]
}