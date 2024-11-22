# Инструкция по запуску скрипта  terraform для запуска httpd.

Требования: 
- установленые minicube, docker, terraform, helm

1. Скопируйте файл main.tf из репозитория в рабочую папку Terraform.
2. В скрипте укажите необходимый [порт] приложения (в скрипте указан 30000 в строке номер 102).
3. Запустите команду `terraform apply`.
4. Узнайтe [IP] командой `minikube ip`.
5. Проверьте отклик приложения командой `curl http://[IP]:[порт]`.


# Instructions for running the Terraform script to deploy httpd.

Requirements:
- Minikube, Docker, Terraform, Helm installed

1. Copy the main.tf file from the repository to your working Terraform folder.
2. In the script, specify the desired [port] for the application (port 30000 is specified in the scriptшт string 102).
3. Run the command `terraform apply`.
4. Find the [IP] by running the command `minikube ip`.
5. Check the application response with the command `curl http://[IP]:[port]`.

