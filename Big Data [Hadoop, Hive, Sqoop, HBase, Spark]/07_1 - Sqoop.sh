###################
#Sqoop - Importação BD Sakila – Carga Incremental
###################

#Realizar com uso do MySQL
docker exec -it database bash
mysql -psecret
use sakila;

show tables;
#+----------------------------+
#| Tables_in_sakila           |
#+----------------------------+
#| actor                      |
#| actor_info                 |
#| address                    |
#| category                   |
#| city                       |
#| country                    |
#| customer                   |
#| customer_list              |
#| film                       |
#| film_actor                 |
#| film_category              |
#| film_list                  |
#| film_text                  |
#| inventory                  |
#| language                   |
#| nicer_but_slower_film_list |
#| payment                    |
#| rental                     |
#| sales_by_film_category     |
#| sales_by_store             |
#| staff                      |
#| staff_list                 |
#| store                      |
#+----------------------------+

#1. Criar a tabela cp_rental_append, contendo a cópia da tabela rental (do db sakila)
#   com os campos rental_id e rental_date

desc rental;
#+--------------+-----------------------+------+-----+-------------------+-----------------------------+
#| Field        | Type                  | Null | Key | Default           | Extra                       |
#+--------------+-----------------------+------+-----+-------------------+-----------------------------+
#| rental_id    | int(11)               | NO   | PRI | NULL              | auto_increment              |
#| rental_date  | datetime              | NO   | MUL | NULL              |                             |
#| inventory_id | mediumint(8) unsigned | NO   | MUL | NULL              |                             |
#| customer_id  | smallint(5) unsigned  | NO   | MUL | NULL              |                             |
#| return_date  | datetime              | YES  |     | NULL              |                             |
#| staff_id     | tinyint(3) unsigned   | NO   | MUL | NULL              |                             |
#| last_update  | timestamp             | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
#+--------------+-----------------------+------+-----+-------------------+-----------------------------+

create table cp_rental_append select rental_id,rental_date from rental;


#2. Criar a tabela cp_rental_id e cp_rental_date, contendo a cópia da tabela cp_rental_append
create table cp_rental_id select * from cp_rental_append;
create table cp_rental_date select * from cp_rental_append;

show tables;

select * from cp_rental_append limit 3;
#+-----------+---------------------+
#| rental_id | rental_date         |
#+-----------+---------------------+
#|         1 | 2005-05-24 22:53:30 |
#|         2 | 2005-05-24 22:54:33 |
#|         3 | 2005-05-24 23:03:39 |
#+-----------+---------------------+

exit

###################
#Realizar com uso do Sqoop - Importações no warehouse /user/hive/warehouse/db_test3 e visualizar no HDFS
docker container exec -ti namenode bash

file=/home/import_sak.txt
echo '--connect=jdbc:mysql://database/sakila?useSSL=false' > $file
echo '--username=root' >> $file; echo '--password=secret' >> $file
cat $file

#3. Importar as tabelas cp_rental_append, cp_rental_id e cp_rental_date com 1 mapeador
sqoop import --table cp_rental_append --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/

sqoop import --table cp_rental_id --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/

sqoop import --table cp_rental_date --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/

hdfs dfs -ls -R -h /user/hive/warehouse/db_test3/
#drwxr-xr-x   - root supergroup          0 2021-09-09 00:46 /user/hive/warehouse/db_test3/cp_rental_append
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:46 /user/hive/warehouse/db_test3/cp_rental_append/_SUCCESS
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 00:46 /user/hive/warehouse/db_test3/cp_rental_append/part-m-00000
#drwxr-xr-x   - root supergroup          0 2021-09-09 00:54 /user/hive/warehouse/db_test3/cp_rental_date
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:54 /user/hive/warehouse/db_test3/cp_rental_date/_SUCCESS
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 00:54 /user/hive/warehouse/db_test3/cp_rental_date/part-m-00000
#drwxr-xr-x   - root supergroup          0 2021-09-09 00:50 /user/hive/warehouse/db_test3/cp_rental_id
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:50 /user/hive/warehouse/db_test3/cp_rental_id/_SUCCESS
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 00:50 /user/hive/warehouse/db_test3/cp_rental_id/part-m-00000


###################
#Realizar com uso do MySQL
docker exec -it database bash
#4. Executar o sql /db-sql/sakila/insert_rental.sql no container do database

cd /db-sql/sakila

mysql -psecret < insert_rental.sql


###################
#Realizar com uso do Sqoop - Importações no warehouse /user/hive/warehouse/db_test3 e visualizar no HDFS
docker container exec -ti namenode bash

#5. Atualizar a tabela cp_rental_append no HDFS anexando os novos arquivos
sqoop import --table cp_rental_append --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/ --append


#6. Atualizar a tabela cp_rental_id no HDFS de acordo com o último registro
#   de rental_id, adicionando apenas os novos dados.
sqoop eval --options-file $file \
--query "select * from cp_rental_append ORDER By rental_id DESC limit 2"
#-------------------------------------
#| rental_id | rental_date           |
#-------------------------------------
#| 16049     | 2005-08-23 22:50:12.0 |
#| 16048     | 2005-08-23 22:43:07.0 |
#-------------------------------------

sqoop import --table cp_rental_id --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/ --incremental append \
--check-column rental_id \
--last-value 16049

#7. Atualizar a tabela cp_rental_date no HDFS de acordo com o último registro
#   de rental_date, atualizando os registros a partir desta data.
sqoop eval --options-file $file \
--query "select * from cp_rental_append ORDER By rental_date DESC limit 2"
#-------------------------------------
#| rental_id | rental_date           |
#-------------------------------------
#| 11739     | 2006-02-14 15:16:03.0 |
#| 13421     | 2006-02-14 15:16:03.0 |
#-------------------------------------

#Ref. ao id 16049 (?!):
sqoop import --table cp_rental_date --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/db_test3/ --incremental lastmodified \
--merge-key rental_id \
--check-column rental_date \
--last-value '2005-08-23 22:50:12.0'


hdfs dfs -ls -R -h /user/hive/warehouse/db_test3/
#drwxr-xr-x   - root supergroup          0 2021-09-09 01:14 /user/hive/warehouse/db_test3/cp_rental_append
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:46 /user/hive/warehouse/db_test3/cp_rental_append/_SUCCESS
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 00:46 /user/hive/warehouse/db_test3/cp_rental_append/part-m-00000
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 01:05 /user/hive/warehouse/db_test3/cp_rental_append/part-m-00001
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 01:13 /user/hive/warehouse/db_test3/cp_rental_append/part-m-00002  #?!
#drwxr-xr-x   - root supergroup          0 2021-09-09 01:41 /user/hive/warehouse/db_test3/cp_rental_date
#-rw-r--r--   3 root supergroup          0 2021-09-09 01:41 /user/hive/warehouse/db_test3/cp_rental_date/_SUCCESS
#-rw-r--r--   3 root supergroup    428.0 K 2021-09-09 01:41 /user/hive/warehouse/db_test3/cp_rental_date/part-r-00000
#drwxr-xr-x   - root supergroup          0 2021-09-09 01:32 /user/hive/warehouse/db_test3/cp_rental_id
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:50 /user/hive/warehouse/db_test3/cp_rental_id/_SUCCESS
#-rw-r--r--   3 root supergroup    427.9 K 2021-09-09 00:50 /user/hive/warehouse/db_test3/cp_rental_id/part-m-00000
#-rw-r--r--   3 root supergroup        168 2021-09-09 01:31 /user/hive/warehouse/db_test3/cp_rental_id/part-m-00001

hdfs dfs -cat /user/hive/warehouse/db_test3/cp_rental_id/part-m-00001
#16050,2005-08-23 22:52:50.0
#16051,2005-08-23 22:54:30.0
#16052,2005-08-23 22:55:20.0
#16054,2005-08-23 22:57:40.0
#16053,2005-08-23 22:56:10.0
#16055,2005-08-23 22:59:20.0
###################