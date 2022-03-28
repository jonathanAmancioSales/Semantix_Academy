###################
#Spark - Exercícios da API Catalog
###################
docker container exec -ti spark bash

spark-shell

#1. Visualizar todos os banco de dados
spark.catalog.listDatabases.show(false)
#+-------+------------------------------+--------------------------------------------------+
#|name   |description                   |locationUri                                       |
#+-------+------------------------------+--------------------------------------------------+
#|default|Default Hive database         |hdfs://namenode:8020/user/hive/warehouse          |
#|jon_db |Banco de dados para exercicios|hdfs://namenode:8020/user/hive/warehouse/jon_db.db|
#+-------+------------------------------+--------------------------------------------------+


#2. Definir o banco de dados "seu-nome" como principal
spark.catalog.setCurrentDatabase("jon_db")


#3. Visualizar todas as tabelas do banco de dados "seu-nome"
spark.catalog.listTables.show()
#+------------------+--------+--------------------+---------+-----------+
#|              name|database|         description|tableType|isTemporary|
#+------------------+--------+--------------------+---------+-----------+
#|        nascimento|  jon_db|                null| EXTERNAL|      false|
#|               pop|  jon_db|                null|  MANAGED|      false|
#|       pop_parquet|  jon_db|                null|  MANAGED|      false|
#|pop_parquet_snappy|  jon_db|                null|  MANAGED|      false|
#|        tab_alunos|  jon_db|                null|  MANAGED|      false|
#|  tab_juros_selic2|  jon_db|                null|  MANAGED|      false|
#|            titles|  jon_db|Imported by sqoop...|  MANAGED|      false|
#|       titles_test|  jon_db|Imported by sqoop...|  MANAGED|      false|
#+------------------+--------+--------------------+---------+-----------+


#4. Visualizar as colunas da tabela tab_alunos
spark.catalog.listColumns("tab_alunos").show()
#+-----------------+-----------+--------+--------+-----------+--------+
#|             name|description|dataType|nullable|isPartition|isBucket|
#+-----------------+-----------+--------+--------+-----------+--------+
#|      id_discente|       null|     int|    true|      false|   false|
#|             nome|       null|  string|    true|      false|   false|
#|     ano_ingresso|       null|     int|    true|      false|   false|
#| periodo_ingresso|       null|     int|    true|      false|   false|
#|            nivel|       null|  string|    true|      false|   false|
#|id_forma_ingresso|       null|     int|    true|      false|   false|
#|         id_curso|       null|     int|    true|      false|   false|
#+-----------------+-----------+--------+--------+-----------+--------+


#5. Visualizar os 10 primeiros registos da tabela "tab_alunos" com uso do spark.sql
spark.sql("select * from tab_alunos").show(10)
#OU:
spark.sql("select * from tab_alunos limit 10").show()

spark.sql("select * from jon_db.tab_alunos limit 10").show()


:q
###################