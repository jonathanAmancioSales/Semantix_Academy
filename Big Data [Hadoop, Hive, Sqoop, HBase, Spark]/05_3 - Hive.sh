###################
#Hive - Criação de Tabelas Otimizadas
###################
docker container exec -ti hive-server bash
beeline -u jdbc:hive2://localhost:10000

#1. Usar o banco de dados <nome>
use jon_db;


#2. Selecionar os 10 primeiros registros da tabela pop
select * from pop limit 10;


#########################################################
#3. Criar a tabela pop_parquet no formato parquet para ler os dados da tabela pop
create table pop_parquet (
zip_code int,
total_population int,
median_age float,
total_males int,
total_females int,
total_households int,
average_household_size float
)
stored as parquet;

#drop table pop_parquet;

desc formatted pop_parquet;
#| Table Parameters: | NULL                  | NULL                       |
#|                   | COLUMN_STATS_ACCURATE | {\"BASIC_STATS\":\"true\"} |
#|                   | numFiles              | 1                          |
#|                   | numRows               | 319                        |
#|                   | rawDataSize           | 2233                       |
#|                   | totalSize             | 9477                       |
#|                   | transient_lastDdlTime | 1630771658                 |


#4. Inserir os dados da tabela pop na pop_parquet
insert into pop_parquet select * from pop;


#5. Contar os registros da tabela pop_parquet
select count(zip_code) as count from pop_parquet;
#+--------+
#| count  |
#+--------+
#| 319    |
#+--------+

#6. Selecionar os 10 primeiros registros da tabela pop_parquet
select * from pop_parquet limit 10;


#########################################################
#7. Criar a tabela pop_parquet_snappy no formato parquet com compressão Snappy para ler os dados da tabela pop

###SET hive.exec.compress.output=true;
###SET mapred.output.compression.codec='org.apache.hadoop.io.compress.SnappyCodec';
###SET mapred.output.compression.type=BLOCK;
###set parquet.compression=SNAPPY;

create table pop_parquet_snappy
stored as parquet
tblproperties('parquet.compress'='org.apache.hadoop.io.compress.SnappyCodec')
as select * from pop;
#tblproperties('parquet.compress'='SNAPPY')

#drop table pop_parquet_snappy;

desc formatted pop_parquet_snappy;
#| Table Parameters: | NULL                  | NULL                                      |
#|                   | COLUMN_STATS_ACCURATE | {\"BASIC_STATS\":\"true\"}                |
#|                   | numFiles              | 1                                         |
#|                   | numRows               | 319                                       |
#|                   | parquet.compress      | org.apache.hadoop.io.compress.SnappyCodec |
#|                   | rawDataSize           | 2233                                      |
#|                   | totalSize             | 9477                                      |
#|                   | transient_lastDdlTime | 1630773869                                |
#| Location: hdfs://namenode:8020/user/hive/warehouse/jon_db.db/pop_parquet_snappy       |


#8. Inserir os dados da tabela pop na pop_parquet_snappy
#insert into pop_parquet_snappy select * from pop;


#9. Contar os registros da tabela pop_parquet_snappy
select count(zip_code) from pop_parquet_snappy;
#+------+
#| _c0  |
#+------+
#| 319  |
#+------+


#10. Selecionar os 10 primeiros registros da tabela pop_parquet_snappy
select * from pop_parquet_snappy limit 10;


#########################################################
#11. Comparar as tabelas pop, pop_parquet e pop_parquet_snappy no HDFS.
#Tamanho no disco?

docker container exec -ti namenode bash

#hdfs dfs -ls -R -h /user/hive/warehouse/jon_db.db/
hdfs dfs -ls -R /user/hive/warehouse/jon_db.db/
#drwxrwxr-x   - root supergroup          0 2021-08-31 22:43 /user/hive/warehouse/jon_db.db/pop
#-rwxrwxr-x   3 root supergroup      12183 2021-08-31 22:41 /user/hive/warehouse/jon_db.db/pop/populacaoLA.csv
#drwxrwxr-x   - root supergroup          0 2021-09-04 16:07 /user/hive/warehouse/jon_db.db/pop_parquet
#-rwxrwxr-x   3 root supergroup       9477 2021-09-04 16:07 /user/hive/warehouse/jon_db.db/pop_parquet/000000_0
#drwxrwxr-x   - root supergroup          0 2021-09-04 16:44 /user/hive/warehouse/jon_db.db/pop_parquet_snappy
#-rwxrwxr-x   3 root supergroup       9477 2021-09-04 16:44 /user/hive/warehouse/jon_db.db/pop_parquet_snappy/000000_0

hdfs dfs -du -h /user/hive/warehouse/jon_db.db/
#11.9 K  /user/hive/warehouse/jon_db.db/pop
#9.3 K   /user/hive/warehouse/jon_db.db/pop_parquet
#9.3 K   /user/hive/warehouse/jon_db.db/pop_parquet_snappy

###################