###################
#Hive - Criação de Tabela Raw
###################
cd docker-bigdata

#0. Iniciar o cluster de Big Data
docker-compose start

#1. Enviar o arquivo local "/input/exercises-data/populacaoLA/populacaoLA.csv"
#   para o diretório no HDFS "/user/aluno/<nome>/data/populacao"
#docker container exec -ti namenode sh   # --> acessa não como root (?)
docker container exec -ti namenode bash

hdfs dfs -ls /user/aluno/Jon/data/
hdfs dfs -mkdir /user/aluno/Jon/data/populacao
hdfs dfs -put /input/exercises-data/populacaoLA/populacaoLA.csv /user/aluno/Jon/data/populacao
hdfs dfs -cat /user/aluno/Jon/data/populacao/populacaoLA.csv | head -n 4
#Ctrl+p+q (sair do container)


#2. Listar os bancos de dados no Hive
docker container exec -ti hive-server bash

beeline -u jdbc:hive2://localhost:10000

show databases;
#+----------------+
#| database_name  |
#+----------------+
#| default        |
#+----------------+


#3. Criar o banco de dados <nome>
create database Jon_db comment "Banco de dados para exercicios";

desc database Jon_db;
#+----------+---------------------------------+----------------------------------------------------+-------------+-------------+-------------+
#| db_name  |             comment             |                      location                      | owner_name  | owner_type  | parameters  |
#+----------+---------------------------------+----------------------------------------------------+-------------+-------------+-------------+
#| jon_db   | Banco de dados para exercicios  | hdfs://namenode:8020/user/hive/warehouse/jon_db.db | root        | USER        |             |
#+----------+---------------------------------+----------------------------------------------------+-------------+-------------+-------------+


#4. Criar a Tabela Hive no BD <nome>
##########
##Tabela interna: pop
##Campos:
##	zip_code - int
##	total_population - int
##	median_age - float
##	total_males - int
##	total_females - int
##	total_households - int
##	average_household_size - float
##Propriedades
##	Delimitadores: Campo ',' | Linha '\n'
##	Sem Partição
##	Tipo do arquivo: Texto
##	tblproperties("skip.header.line.count"="1")
##########

use Jon_db;
#create table Jon_db.pop ( ... )
###Location: hdfs://namenode:8020/user/hive/warehouse/Jon_db/pop
#drop table pop;
###Location: hdfs://namenode:8020/user/hive/warehouse/pop

create table pop (
zip_code int,
total_population int,
median_age float,
total_males int,
total_females int,
total_households int,
average_household_size float
)
row format delimited
fields terminated by ','
lines terminated by '\n'
stored as textfile
tblproperties("skip.header.line.count"="1");

show tables;
#+-----------+
#| tab_name  |
#+-----------+
#| pop       |
#+-----------+


#5. Visualizar a descrição da tabela pop

desc pop;
#+-------------------------+------------+----------+
#|        col_name         | data_type  | comment  |
#+-------------------------+------------+----------+
#| zip_code                | int        |          |
#| total_population        | int        |          |
#| median_age              | float      |          |
#| total_males             | int        |          |
#| total_females           | int        |          |
#| total_households        | int        |          |
#| average_household_size  | float      |          |
#+-------------------------+------------+----------+

desc formatted pop;

###################
#Inserir Dados na Tabela Raw
###################
#1. Visualizar a descrição da tabela pop do banco de dados <nome>
desc Jon_db.pop;

#2. Selecionar os 10 primeiros registros da tabela pop
select * from pop limit 10;
#+---------------+-----------------------+-----------------+------------------+--------------------+-----------------------+-----------------------------+
#| pop.zip_code  | pop.total_population  | pop.median_age  | pop.total_males  | pop.total_females  | pop.total_households  | pop.average_household_size  |
#+---------------+-----------------------+-----------------+------------------+--------------------+-----------------------+-----------------------------+
#+---------------+-----------------------+-----------------+------------------+--------------------+-----------------------+-----------------------------+


#3. Carregar o arquivo do HDFS "/user/aluno/<nome>/data/população/populacaoLA.csv" para a tabela Hive pop
load data inpath "/user/aluno/Jon/data/populacao/populacaoLA.csv" into table pop;


#4. Selecionar os 10 primeiros registros da tabela pop
select * from pop limit 10;
#+--------------+----------------------+----------------+-----------------+-------------------+----------------------+----------------------------+
#| pop.zip_code | pop.total_population | pop.median_age | pop.total_males | pop.total_females | pop.total_households | pop.average_household_size |
#+--------------+----------------------+----------------+-----------------+-------------------+----------------------+----------------------------+
#| 91371        | 1                    | 73.5           | 0               | 1                 | 1                    | 1.0                        |
#| 90001        | 57110                | 26.6           | 28468           | 28642             | 12971                | 4.4                        |
#| 90002        | 51223                | 25.5           | 24876           | 26347             | 11731                | 4.36                       |
#| 90003        | 66266                | 26.3           | 32631           | 33635             | 15642                | 4.22                       |
#| 90004        | 62180                | 34.8           | 31302           | 30878             | 22547                | 2.73                       |
#| 90005        | 37681                | 33.9           | 19299           | 18382             | 15044                | 2.5                        |
#| 90006        | 59185                | 32.4           | 30254           | 28931             | 18617                | 3.13                       |
#| 90007        | 40920                | 24.0           | 20915           | 20005             | 11944                | 3.0                        |
#| 90008        | 32327                | 39.7           | 14477           | 17850             | 13841                | 2.33                       |
#| 90010        | 3800                 | 37.8           | 1874            | 1926              | 2014                 | 1.87                       |
#+--------------+----------------------+----------------+-----------------+-------------------+----------------------+----------------------------+


#5. Contar a quantidade de registros da tabela pop
#--> Warning
#select count(*) from pop;
select count(pop.zip_code) from pop;
#+------+
#| _c0  |
#+------+
#| 319  |
#+------+


docker-compose stop
###################