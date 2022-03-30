###################
#Sqoop - Importação BD Employees
###################
docker container exec -ti namenode bash

#1. Pesquisar os 10 primeiros registros da tabela employees do banco de dados employees
Conn=jdbc:mysql://database/employees?useSSL=false
sqoop eval --connect $Conn --username=root --password=secret \
--query "select * from employees limit 10"

#OU:

Conn=jdbc:mysql://database?useSSL=false
sqoop eval --connect $Conn --username=root --password=secret \
--query "select * from employees.employees limit 10"

#OU:

#########
file=/home/import.txt
echo '--connect=jdbc:mysql://database?useSSL=false' > $file
echo '--username=root' >> $file; echo '--password=secret' >> $file
cat $file
#OU:
#echo '--connect' > $file
#echo 'jdbc:mysql://database?useSSL=false' >> $file
#echo '--username' >> $file
#echo 'root' >> $file
#echo '--password' >> $file
#echo 'secret' >> $file
##########
sqoop eval --options-file $file --query "select * from employees.employees limit 10"

#---------------------------------------------------------------------------------
#| emp_no      | birth_date | first_name     | last_name   | gender | hire_date  | 
#---------------------------------------------------------------------------------
#| 10001       | 1953-09-02 | Georgi         | Facello          | M | 1986-06-26 | 
#| 10002       | 1964-06-02 | Bezalel        | Simmel           | F | 1985-11-21 | 
#| 10003       | 1959-12-03 | Parto          | Bamford          | M | 1986-08-28 | 
#| 10004       | 1954-05-01 | Chirstian      | Koblick          | M | 1986-12-01 | 
#| 10005       | 1955-01-21 | Kyoichi        | Maliniak         | M | 1989-09-12 | 
#| 10006       | 1953-04-20 | Anneke         | Preusig          | F | 1989-06-02 | 
#| 10007       | 1957-05-23 | Tzvetan        | Zielinski        | F | 1989-02-10 | 
#| 10008       | 1958-02-19 | Saniya         | Kalloufi         | M | 1994-09-15 | 
#| 10009       | 1952-04-19 | Sumant         | Peac             | F | 1985-02-18 | 
#| 10010       | 1963-06-01 | Duangkaew      | Piveteau         | F | 1989-08-24 | 
#---------------------------------------------------------------------------------


#2. Realizar as importações referentes a tabela employees
#   e para validar cada questão, é necessário visualizar no HDFS

file_emp=/home/import_emp.txt
echo '--connect=jdbc:mysql://database/employees?useSSL=false' > $file_emp
echo '--username=root' >> $file_emp; echo '--password=secret' >> $file_emp
cat $file_emp

#a) Importar a tabela employees, no warehouse /user/hive/warehouse/db_test_a
#sqoop import --table employees --connect $Conn --username=root --password=secret \
sqoop import --table employees --options-file $file_emp \
--warehouse-dir /user/hive/warehouse/db_test_a/
#OU:
#--target-dir /user/hive/warehouse/db_test_a/employees

hdfs dfs -ls /user/hive/warehouse/
hdfs dfs -ls -R /user/hive/warehouse/db_test_a/
#drwxr-xr-x   - root supergroup          0 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees
#-rw-r--r--   3 root supergroup          0 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees/_SUCCESS
#-rw-r--r--   3 root supergroup    4548041 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees/part-m-00000
#-rw-r--r--   3 root supergroup    2550561 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees/part-m-00001
#-rw-r--r--   3 root supergroup    2086360 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees/part-m-00002
#-rw-r--r--   3 root supergroup    4637031 2021-09-07 13:56 /user/hive/warehouse/db_test_a/employees/part-m-00003

hdfs dfs -cat /user/hive/warehouse/db_test_a/employees/part-m-00003 | head -n 5
#400000,1963-11-29,Mitsuyuki,Reinhart,M,1985-08-27
#400001,1962-06-02,Rosalie,Chinin,M,1986-11-28
#400002,1964-08-16,Quingbo,Birnbaum,F,1986-04-23
#400003,1958-04-30,Jianwen,Sidhu,M,1986-02-01
#400004,1958-04-30,Sedat,Suppi,M,1995-12-18


#b) Importar todos os funcionários do gênero masculino, no warehouse /user/hive/warehouse/db_test_b
sqoop import --table employees --options-file $file_emp \
--where "gender='M'" \
--target-dir /user/hive/warehouse/db_test_b/employees

hdfs dfs -cat /user/hive/warehouse/db_test_b/employees/part-m-00002 | head -n 5
#255001,1957-03-07,Akhilish,Panangaden,M,1987-07-24
#255002,1960-04-02,Gil,Morrey,M,1990-09-07
#255007,1954-08-14,Vesna,Radhakrishnan,M,1986-05-15
#255008,1959-09-25,Alois,Zongker,M,1988-10-23
#255009,1964-01-17,Bernice,Shinomoto,M,1994-06-15


#c) Importar o primeiro e o último nome dos funcionários com os campos separados por tabulação,
#   no warehouse /user/hive/warehouse/db_test_c
sqoop import --table employees --options-file $file_emp \
--columns "first_name,last_name" \
--fields-terminated-by '\t' \
--warehouse-dir /user/hive/warehouse/db_test_c

hdfs dfs -ls -R /user/hive/warehouse/db_test_c/
#drwxr-xr-x   - root supergroup          0 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees
#-rw-r--r--   3 root supergroup          0 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/_SUCCESS
#-rw-r--r--   3 root supergroup    1537296 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00000
#-rw-r--r--   3 root supergroup     845530 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00001
#-rw-r--r--   3 root supergroup     691391 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00002
#-rw-r--r--   3 root supergroup    1537031 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00003

hdfs dfs -cat /user/hive/warehouse/db_test_c/employees/part-m-00001 | head -5
#Selwyn	Koshiba
#Bedrich	Markovitch
#Pascal	Benzmuller
#Arvind	Dechter
#Masaru	Rusmann


#d) Importar o primeiro e o último nome dos funcionários
#   com as linhas separadas por " : " e salvar no mesmo diretório da questão 2.c
sqoop import --table employees --options-file $file_emp \
--columns "first_name,last_name" \
--lines-terminated-by ":" \
--warehouse-dir /user/hive/warehouse/db_test_c -delete-target-dir
#--warehouse-dir /user/hive/warehouse/db_test_c -append

hdfs dfs -ls -R /user/hive/warehouse/db_test_c/
#drwxr-xr-x   - root supergroup          0 2021-09-07 14:21 /user/hive/warehouse/db_test_c/employees
#-rw-r--r--   3 root supergroup          0 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/_SUCCESS
#-rw-r--r--   3 root supergroup    1537296 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00000
#-rw-r--r--   3 root supergroup     845530 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00001
#-rw-r--r--   3 root supergroup     691391 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00002
#-rw-r--r--   3 root supergroup    1537031 2021-09-07 14:13 /user/hive/warehouse/db_test_c/employees/part-m-00003
#-rw-r--r--   3 root supergroup    1537296 2021-09-07 14:20 /user/hive/warehouse/db_test_c/employees/part-m-00004
#-rw-r--r--   3 root supergroup     845530 2021-09-07 14:20 /user/hive/warehouse/db_test_c/employees/part-m-00005
#-rw-r--r--   3 root supergroup     691391 2021-09-07 14:20 /user/hive/warehouse/db_test_c/employees/part-m-00006
#-rw-r--r--   3 root supergroup    1537031 2021-09-07 14:20 /user/hive/warehouse/db_test_c/employees/part-m-00007

hdfs dfs -cat /user/hive/warehouse/db_test_c/employees/part-m-00005 | tail -1
#... :Anwar,Schneeberger:Luisa,Bach:Erzsebet,Yurov:Dannz,Gide:Jamaludin,Chartres:
###################