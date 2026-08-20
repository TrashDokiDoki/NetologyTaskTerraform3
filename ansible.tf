resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web         # web-ВМ из count
    databases  = values(yandex_compute_instance.db)  # db-ВМ из for_each
    storage    = [yandex_compute_instance.storage]   # storage-ВМ
  })
  filename = "${abspath(path.module)}/hosts.ini"
}