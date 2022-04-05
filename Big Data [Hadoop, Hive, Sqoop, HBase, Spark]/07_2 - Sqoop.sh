###################
#Sqoop - Importação para o Hive e Exportação - BD Employees
###################
docker container exec -ti namenode bash

file=/home/import_emp.txt
#echo '--connect=jdbc:mysql://database/employees?useSSL=false' > $file
#echo '--username=root' >> $file; echo '--password=secret' >> $file
cat $file

#1. Importar a tabela employees.titles do MySQL para o diretório /user/aluno/<nome>/data com 1 mapeador.
sqoop import --table titles --options-file $file -m 1 \
--warehouse-dir /user/aluno/Jon/data/

hdfs dfs -ls -h /user/aluno/Jon/data/titles
#-rw-r--r--   3 root supergroup          0 2021-09-09 22:42 /user/aluno/Jon/data/titles/_SUCCESS
#-rw-r--r--   3 root supergroup     16.9 M 2021-09-09 22:42 /user/aluno/Jon/data/titles/part-m-00000


#2. Importar a tabela employees.titles do MySQL para uma tabela Hive
#   no banco de dados seu nome com 1 mapeador.
sqoop import --table titles --options-file $file -m 1 \
--warehouse-dir /user/hive/warehouse/jon_db.db \
--hive-import --create-hive-table \
--hive-table Jon_db.titles_test

#Se não informar o warehouse-dir, nesse caso, o sqoop importará os dados
#para /user/root/<bancodados> e depois os moverá para /user/hive/warehouse/<bancodados>
sqoop import --table titles --options-file $file -m 1 \
--hive-import --hive-table Jon_db.titles

hdfs dfs -ls -h /user/hive/warehouse/jon_db.db
#drwxrwxr-x   - root supergroup    0 2021-08-31 22:43 /user/hive/warehouse/jon_db.db/pop
#drwxrwxr-x   - root supergroup    0 2021-09-04 16:07 /user/hive/warehouse/jon_db.db/pop_parquet
#drwxrwxr-x   - root supergroup    0 2021-09-04 16:44 /user/hive/warehouse/jon_db.db/pop_parquet_snappy
#drwxrwxr-x   - root supergroup    0 2021-09-09 23:19 /user/hive/warehouse/jon_db.db/titles
#drwxrwxr-x   - root supergroup    0 2021-09-09 23:08 /user/hive/warehouse/jon_db.db/titles_test


#3. Selecionar os 10 primeiros registros da tabela titles no Hive.
docker container exec -ti hive-server bash
beeline -u jdbc:hive2://localhost:10000

use Jon_db;
show tables;
#+---------------------+
#|      tab_name       |
#+---------------------+
#| nascimento          |
#| pop                 |
#| pop_parquet         |
#| pop_parquet_snappy  |
#| titles              |
#| titles_test         |
#+---------------------+

select * from titles limit 10;
#+----------------+------------------+-------------------+-----------------+
#| titles.emp_no  |   titles.title   | titles.from_date  | titles.to_date  |
#+----------------+------------------+-------------------+-----------------+
#| 10001          | Senior Engineer  | 1986-06-26        | 9999-01-01      |
#| 10002          | Staff            | 1996-08-03        | 9999-01-01      |
#| 10003          | Senior Engineer  | 1995-12-03        | 9999-01-01      |
#| 10004          | Engineer         | 1986-12-01        | 1995-12-01      |
#| 10004          | Senior Engineer  | 1995-12-01        | 9999-01-01      |
#| 10005          | Senior Staff     | 1996-09-12        | 9999-01-01      |
#| 10005          | Staff            | 1989-09-12        | 1996-09-12      |
#| 10006          | Senior Engineer  | 1990-08-05        | 9999-01-01      |
#| 10007          | Senior Staff     | 1996-02-11        | 9999-01-01      |
#| 10007          | Staff            | 1989-02-10        | 1996-02-11      |
#+----------------+------------------+-------------------+-----------------+

#Tentar algo do tipo:
#ERRO: java.io.IOException: No manager for connect string
#sqoop eval --connect=jdbc:hive2://localhost:10000/default --query "show databases"
#sqoop list-databases --connect=jdbc:hive2://localhost:10000/default
#sqoop list-databases --connect=jdbc:hive2://hs2host:10000/default;user=hive;password=hive


#4. Deletar os registros da tabela employees.titles do MySQL
#   e verificar se foram apagados, através do Sqoop
#Verificar:
sqoop eval --options-file $file --query "select * from employees.titles limit 4"

#Não é excluir (drop) a tabela, mas apagar seus dados:
sqoop eval --options-file $file --query "truncate table employees.titles"

sqoop eval --options-file $file --query "select * from titles"
#----------------------------------------------------------------
#| emp_no      | title                | from_date  | to_date    | 
#----------------------------------------------------------------
#----------------------------------------------------------------

#5. Exportar os dados do diretório /user/?hive/warehouse?/<nome>.db/data/titles
#   para a tabela do MySQL employees.titles.
sqoop export --options-file $file \
--export-dir /user/aluno/Jon/data/titles \
--table titles

#Erro: Export job failed! (Por quê?!)
#--export-dir /user/hive/warehouse/jon_db.db/titles \
#Usar o nome da tabela direto e não banco.tabela:
#Erro: --table employees.titles

#hdfs dfs -ls -h -R /user/hive/warehouse/jon_db.db/titles
#hdfs dfs -ls -h -R /user/aluno/Jon/data/titles


#6. Selecionar os 10 primeiros registros registros da tabela employees.titles do MySQL.
sqoop eval --options-file $file --query "select * from titles limit 4"
#----------------------------------------------------------------
#| emp_no      | title                | from_date  | to_date    | 
#----------------------------------------------------------------
#| 10001       | Senior Engineer      | 1986-06-26 | 9999-01-01 | 
#| 10002       | Staff                | 1996-08-03 | 9999-01-01 | 
#| 10003       | Senior Engineer      | 1995-12-03 | 9999-01-01 | 
#| 10004       | Engineer             | 1986-12-01 | 1995-12-01 | 
#----------------------------------------------------------------
###################