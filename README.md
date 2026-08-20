# NetologyTaskTerraform3

# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

# Задание 1

1. Изучите проект.
2. Инициализируйте проект, выполните код. 


Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud .

------

# Решение

1. Изучил проект

2. Инициализировал проект

<img width="2556" height="1275" alt="Снимок экрана 2026-08-12 195016" src="https://github.com/user-attachments/assets/8e16d8b7-6f50-4d37-aea9-16ea5c18013b" />

# Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  
При желании внесите в переменную все возможные параметры.
3. ВМ, описанные в файле count-vm.tf, должны создаваться после ВМ, описанных в файле for_each-vm.tf.
4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
5. Инициализируйте проект, выполните код.

------

# Решение

1. Создал файл `count-vm.tf`

<img width="777" height="871" alt="Снимок экрана 2026-08-12 201708" src="https://github.com/user-attachments/assets/6d91537e-18f3-4bd4-b70a-93d940fa900e" />

2. Создал файл `for_each-vm.tf`

<img width="794" height="828" alt="Снимок экрана 2026-08-12 201749" src="https://github.com/user-attachments/assets/3d4e5357-16d9-49ae-8d08-ccc78de5b05f" />

3. Создал файл `locals.tf` для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata

<img width="758" height="133" alt="Снимок экрана 2026-08-12 201848" src="https://github.com/user-attachments/assets/da59a942-b2cd-4d2d-b13c-ad9283a5743b" />

4. Инициализировал проект

<img width="1919" height="1079" alt="Снимок экрана 2026-08-12 201935" src="https://github.com/user-attachments/assets/72f69767-983d-4a5e-ab4b-ccb79e9ec516" />

<img width="2437" height="508" alt="Снимок экрана 2026-08-12 202542" src="https://github.com/user-attachments/assets/777deca2-2648-4bc8-9f80-12413e99d776" />

<img width="2559" height="1164" alt="Снимок экрана 2026-08-12 202652" src="https://github.com/user-attachments/assets/4f8497c7-c8b8-4128-8b3a-020f45e25ed0" />

# Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

------

1. Создал файл `disk_vm.tf`

<img width="1919" height="1079" alt="Снимок экрана 2026-08-12 203233" src="https://github.com/user-attachments/assets/1700ddcc-d2d0-454e-9da4-4a1f6bb30388" />

2. Проверка в Yandex Cloud
<img width="2558" height="767" alt="Снимок экрана 2026-08-12 203312" src="https://github.com/user-attachments/assets/a5e931a4-bba7-4ee4-a5a8-227a4cffaf14" />

<img width="2556" height="655" alt="Снимок экрана 2026-08-12 203411" src="https://github.com/user-attachments/assets/8b94b41a-31e8-4d60-89ab-d1e9ac603adf" />

# Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания переменной hostname(не путать с переменной name)); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае отсутвия перменной hostname - автоматическая генерация имени,  зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

# Решение

1. Создал inventory-файл для ansible с названием `ansible.tf`

<img width="798" height="235" alt="Снимок экрана 2026-08-18 180953" src="https://github.com/user-attachments/assets/b3c0ca23-0bbb-492b-afba-56706d017406" />

2. Так же был создал файл `hosts.tftpl`

<img width="852" height="335" alt="Снимок экрана 2026-08-18 181136" src="https://github.com/user-attachments/assets/156ab7ca-f6b6-4489-878a-58c662f2fc86" />

3. После выполнения кода получил `hosts.ini`

<img width="881" height="162" alt="Снимок экрана 2026-08-18 181239" src="https://github.com/user-attachments/assets/dc2b099b-40aa-4635-a4af-a4176b7426e1" />
