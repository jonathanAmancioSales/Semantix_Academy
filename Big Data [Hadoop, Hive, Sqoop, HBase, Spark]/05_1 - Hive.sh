###################
#Hive - Criação de Tabela Particionada
###################
cd docker-bigdata

#0. Iniciar o cluster de Big Data
docker-compose start

#1. Criar o diretório "/user/aluno/<nome>/data/nascimento" no HDFS
docker container exec -ti namenode bash
hdfs dfs -mkdir /user/aluno/Jon/data/nascimento
hdfs dfs -ls /user/aluno/Jon/data/

#2. Criar e usar o Banco de dados <nome>
docker container exec -ti hive-server bash
beeline -u jdbc:hive2://localhost:10000

##create database Jon_db;
use Jon_db;

#3. Criar uma tabela externa no Hive com os parâmetros:
##a) Tabela: nascimento
##b) Campos: nome (String), sexo (String) e frequencia (int)
##c) Partição: ano
##d) Delimitadores:
##i)   Campo ','
##ii)  Linha '\n'
##e) Salvar
##i)   Tipo do arquivo: texto
##ii)  HDFS: '/user/aluno/<nome>/data/nascimento'

create external table nascimento (
nome string,
sexo string,
frequencia int
)
partitioned by (ano int)
row format delimited
fields terminated by ','
lines terminated by '\n'
stored as textfile
location '/user/aluno/Jon/data/nascimento';
#OU:
#location 'hdfs://namenode:8020/user/aluno/Jon/data/nascimento';

show tables;
#+-------------+
#|  tab_name   |
#+-------------+
#| nascimento  |
#| pop         |
#+-------------+

desc nascimento;
#+-------------------------+------------+-----------------------+
#|         col_name        | data_type  |        comment        |
#+-------------------------+------------+-----------------------+
#| nome                    | string     |                       |
#| sexo                    | string     |                       |
#| frequencia              | int        |                       |
#| ano                     | string     |                       |
#|                         | NULL       | NULL                  |
#| # Partition Information | NULL       | NULL                  |
#| # col_name              | data_type  | comment               |
#|                         | NULL       | NULL                  |
#| ano                     | string     |                       |
#+-------------------------+------------+-----------------------+


#4.Adicionar partição ano=2015
#7.Repita o processo do 4 ao 6 para os anos de 2016 e 2017.

alter table nascimento add partition(ano='2015');
alter table nascimento add partition(ano=2016);
alter table nascimento add partition(ano='2017');

#Erro: hive nao reconhece esses comando!
#for i in 2015 2016 2017; do
#for ano in $(seq 2016 1 2017); do
#	alter table nascimento add partition(ano="'"$ano"'");
#done

show partitions nascimento;
#+------------+
#| partition  |
#+------------+
#| ano=2015   |
#| ano=2016   |
#| ano=2017   |
#+------------+


#5.Enviar o arquivo local "input/exercises-data/names/yob2015.txt" para o HDFS no diretório /user/aluno/<nome>/data/nascimento/ano=2015
docker container exec -ti namenode bash
hdfs dfs -cat input/exercises-data/names/yob2015.txt | head -3
hdfs dfs -put input/exercises-data/names/yob2015.txt /user/aluno/Jon/data/nascimento/ano=2015

for ano in $(seq 2015 1 2017); do
	hdfs dfs -put 'input/exercises-data/names/yob'$ano'.txt' /user/aluno/Jon/data/nascimento/ano=$ano
done

hdfs dfs -ls -R /user/aluno/Jon/data/nascimento/


#6.Selecionar os 10 primeiros registros da tabela nascimento no Hive
docker container exec -ti hive-server bash
beeline -u jdbc:hive2://localhost:10000

select * from Jon_db.nascimento limit 10;


###################
###################
drop table nascimento;
show tables;

#Como a tabela é externa, os dados permanecem;
hdfs dfs -ls -R /user/aluno/Jon/data/nascimento/

#Criar tabela novamente;

#A tabela vai estar vazia;

#Como os arquivos/dados não foram deletados,
#mas ainda permanecem nos seus respectivos diretórios,
#basta adicionar as partições para que a tabela seja
#automaticamente preenchida;
###################
###################