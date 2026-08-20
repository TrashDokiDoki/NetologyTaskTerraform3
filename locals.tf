locals {
  # Чтение публичного SSH-ключа с помощью функции file
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
}