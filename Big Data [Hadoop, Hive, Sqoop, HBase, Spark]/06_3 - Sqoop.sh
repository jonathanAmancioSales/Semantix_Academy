###################
#Sqoop - Importação BD Employees- Otimização
###################

## Realizar com uso do MySQL

#Acessar o contêiner database:
docker exec -it database bash

mysql -psecret

#1. Criar a tabela cp_titles_date, contendo a cópia da tabela titles
#   (do bd employees) com os campos title e to_date
use employees;

desc titles;
#+-----------+-------------+------+-----+---------+-------+
#| Field     | Type        | Null | Key | Default | Extra |
#+-----------+-------------+------+-----+---------+-------+
#| emp_no    | int(11)     | NO   | PRI | NULL    |       |
#| title     | varchar(50) | NO   | PRI | NULL    |       |
#| from_date | date        | NO   | PRI | NULL    |       |
#| to_date   | date        | YES  |     | NULL    |       |
#+-----------+-------------+------+-----+---------+-------+

select * from titles limit 4;
#+--------+-----------------+------------+------------+
#| emp_no | title           | from_date  | to_date    |
#+--------+-----------------+------------+------------+
#|  10001 | Senior Engineer | 1986-06-26 | 9999-01-01 |
#|  10002 | Staff           | 1996-08-03 | 9999-01-01 |
#|  10003 | Senior Engineer | 1995-12-03 | 9999-01-01 |
#|  10004 | Engineer        | 1986-12-01 | 1995-12-01 |
#+--------+-----------------+------------+------------+

create table cp_titles_date select title,to_date from titles;

show tables;
#+----------------------+
#| Tables_in_employees  |
#+----------------------+
#| benefits             |
#| cp_titles_date       |
#| current_dept_emp     |
#| departments          |
#| dept_emp             |
#| dept_emp_latest_date |
#| dept_manager         |
#| employees            |
#| employees_2          |
#| titles               |
#+----------------------+


#2. Pesquisar os 15 primeiros registros da tabela cp_titles_date
select * from cp_titles_date limit 4;
#+-----------------+------------+
#| title           | to_date    |
#+-----------------+------------+
#| Senior Engineer | 9999-01-01 |
#| Staff           | 9999-01-01 |
#| Senior Engineer | 9999-01-01 |
#| Engineer        | 1995-12-01 |
#+-----------------+------------+


#3. Alterar os registros do campo to_date para null da tabela cp_titles_date, quando o título for igual a Staff
update cp_titles_date set to_date=NULL where title='Staff';

select * from cp_titles_date limit 4;
#+-----------------+------------+
#| title           | to_date    |
#+-----------------+------------+
#| Senior Engineer | 9999-01-01 |
#| Staff           | NULL       |
#| Senior Engineer | 9999-01-01 |
#| Engineer        | 1995-12-01 |
#+-----------------+------------+

exit

## Realizar com uso do Sqoop
## Importações no warehouse /user/hive/warehouse/db_test_<numero_questao> e visualizar no HDFS

docker container exec -ti namenode bash

file_emp=/home/import_emp.txt
#echo '--connect=jdbc:mysql://database/employees?useSSL=false' > $file_emp
#echo '--username=root' >> $file_emp; echo '--password=secret' >> $file_emp
cat $file_emp

#4. Importar a tabela titles com 8 mapeadores no formato parquet
sqoop import --table titles --options-file $file_emp \
--warehouse-dir /user/hive/warehouse/db_test_4/ \
--as-parquetfile -num-mappers 8

hdfs dfs -ls -R -h /user/hive/warehouse/db_test_4/
#drwxr-xr-x   - root supergroup          0 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles
#drwxr-xr-x   - root supergroup          0 2021-09-07 19:47 /user/hive/warehouse/db_test_4/titles/.metadata
#-rw-r--r--   3 root supergroup        178 2021-09-07 19:47 /user/hive/warehouse/db_test_4/titles/.metadata/descriptor.properties
#-rw-r--r--   3 root supergroup        669 2021-09-07 19:47 /user/hive/warehouse/db_test_4/titles/.metadata/schema.avsc
#drwxr-xr-x   - root supergroup          0 2021-09-07 19:47 /user/hive/warehouse/db_test_4/titles/.metadata/schemas
#-rw-r--r--   3 root supergroup        669 2021-09-07 19:47 /user/hive/warehouse/db_test_4/titles/.metadata/schemas/1.avsc
#drwxr-xr-x   - root supergroup          0 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/.signals
#-rw-r--r--   3 root supergroup          0 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/.signals/unbounded
#-rw-r--r--   3 root supergroup    491.0 K 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/1d0f82b0-c9f5-4ca2-96c3-2c44b53484b2.parquet
#-rw-r--r--   3 root supergroup    581.7 K 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/77afc171-c321-4a76-8090-4c057c3f8199.parquet
#-rw-r--r--   3 root supergroup    640.9 K 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/811be171-a737-46a4-b012-384c5a99dd69.parquet
#-rw-r--r--   3 root supergroup    429.3 K 2021-09-07 19:50 /user/hive/warehouse/db_test_4/titles/b7948a4a-dbae-477c-80cc-2c09dbfb9457.parquet
#-rw-r--r--   3 root supergroup    642.2 K 2021-09-07 19:49 /user/hive/warehouse/db_test_4/titles/e1709957-0310-41a8-8d7a-882bc99b4642.parquet
#-rw-r--r--   3 root supergroup    433.1 K 2021-09-07 19:49 /user/hive/warehouse/db_test_4/titles/ea957068-9ce9-49f0-9b52-d5b66e25d4e5.parquet

#5. Importar a tabela titles com 8 mapeadores no formato parquet e compressão snappy
sqoop import --table titles --options-file $file_emp \
--warehouse-dir /user/hive/warehouse/db_test_5/ \
--as-parquetfile -m 8 \
--compress --compression-codec 'Snappy'

#ERRO:--compress --compression-codec org.apache.hadoop.io.compress.SnappyCode
#ERROR tool.ImportTool: Import failed: com.cloudera.sqoop.io.UnsupportedCodecException: org.apache.hadoop.io.compress.SnappyCode

hdfs dfs -ls -R -h /user/hive/warehouse/db_test_5/
#drwxr-xr-x   - root supergroup          0 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles
#drwxr-xr-x   - root supergroup          0 2021-09-07 20:07 /user/hive/warehouse/db_test_5/titles/.metadata
#-rw-r--r--   3 root supergroup        178 2021-09-07 20:08 /user/hive/warehouse/db_test_5/titles/.metadata/descriptor.properties
#-rw-r--r--   3 root supergroup        669 2021-09-07 20:07 /user/hive/warehouse/db_test_5/titles/.metadata/schema.avsc
#drwxr-xr-x   - root supergroup          0 2021-09-07 20:07 /user/hive/warehouse/db_test_5/titles/.metadata/schemas
#-rw-r--r--   3 root supergroup        669 2021-09-07 20:07 /user/hive/warehouse/db_test_5/titles/.metadata/schemas/1.avsc
#drwxr-xr-x   - root supergroup          0 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/.signals
#-rw-r--r--   3 root supergroup          0 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/.signals/unbounded
#-rw-r--r--   3 root supergroup    491.0 K 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/014a7e5b-f980-4c93-b559-dcd2d508c9e8.parquet
#-rw-r--r--   3 root supergroup    581.7 K 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/235c90eb-748e-4ae1-b634-30244fe87810.parquet
#-rw-r--r--   3 root supergroup   1007.0 K 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/c524c3e3-8e7b-4aab-a837-499d6082c4c4.parquet
#-rw-r--r--   3 root supergroup   1003.6 K 2021-09-07 20:10 /user/hive/warehouse/db_test_5/titles/e3308c15-48f3-4010-bdc8-913de4c35bee.parquet


#6. Importar a tabela cp_titles_date com 4 mapeadores (erro)
sqoop import --table cp_titles_date --options-file $file_emp \
--warehouse-dir /user/hive/warehouse/db_test_6/ -m 4
#ERROR tool.ImportTool: Import failed: No primary key could be found for table cp_titles_date.
#Please specify one with --split-by or perform a sequential import with '-m 1'.


#a) Importar a tabela cp_titles_date com 4 mapeadores divididos pelo campo
#   título no warehouse /user/hive/warehouse/db_test2_title
sqoop import -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
--table cp_titles_date --options-file $file_emp -m 4 \
--warehouse-dir /user/hive/warehouse/db_test_2_title/ --split-by title


#b) Importar a tabela cp_titles_date com 4 mapeadores divididos
#   pelo campo data no warehouse /user/hive/warehouse/db_test2_date
sqoop import --table cp_titles_date --options-file $file_emp \
--warehouse-dir /user/hive/warehouse/db_test_2_date/ -m 4 \
--split-by to_date


#c) Qual a diferença dos registros nulos entre as duas importações?

hdfs dfs -count -h /user/hive/warehouse/db_test_2_date/
#    2    5        7.7 M /user/hive/warehouse/db_test_2_date
hdfs dfs -ls -R -h /user/hive/warehouse/db_test_2_date/
#drwxr-xr-x   - root supergroup          0 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date
#-rw-r--r--   3 root supergroup          0 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date/_SUCCESS
#-rw-r--r--   3 root supergroup      2.6 M 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date/part-m-00000
#-rw-r--r--   3 root supergroup          0 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date/part-m-00001
#-rw-r--r--   3 root supergroup          0 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date/part-m-00002
#-rw-r--r--   3 root supergroup      5.1 M 2021-09-07 20:19 /user/hive/warehouse/db_test_2_date/cp_titles_date/part-m-00003

hdfs dfs -count -h /user/hive/warehouse/db_test_2_title/
#    2    7         8.8 M /user/hive/warehouse/db_test_2_title
hdfs dfs -ls -R -h /user/hive/warehouse/db_test_2_title/
#drwxr-xr-x   - root supergroup          0 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/_SUCCESS
#-rw-r--r--   3 root supergroup          0 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00000
#-rw-r--r--   3 root supergroup    443.2 K 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00001
#-rw-r--r--   3 root supergroup      2.2 M 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00002
#-rw-r--r--   3 root supergroup        456 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00003
#-rw-r--r--   3 root supergroup      5.8 M 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00004
#-rw-r--r--   3 root supergroup    414.5 K 2021-09-09 00:10 /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00005

hdfs dfs -cat /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00001 | head -2
#Assistant Engineer,2000-07-31
#Assistant Engineer,1990-02-18
hdfs dfs -cat /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00002 | head -2
#Engineer,1995-12-01
#Engineer,1995-02-18
hdfs dfs -cat /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00003 | head -2
#Manager,1991-10-01
#Manager,9999-01-01
hdfs dfs -cat /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00004 | head -3
#Senior Engineer,9999-01-01
#Staff,null
#Senior Engineer,9999-01-01
hdfs dfs -cat /user/hive/warehouse/db_test_2_title/cp_titles_date/part-m-00005 | head -2
#Technique Leader,2002-07-15
#Technique Leader,1997-10-15
###################