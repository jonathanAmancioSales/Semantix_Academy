###################
#Spark - Exercícios de SQL Queries vs Operações de DataFrame
###################

#Realizar as seguintes consultas usando SQL queries e transformações
#de DataFrame na tabela "tab_alunos" no banco de dados <nome>

spark.catalog.setCurrentDatabase("jon_db")

#1. Visualizar o id e nome dos 5 primeiros registros
spark.sql("select id_discente,nome from tab_alunos limit 5").show()

spark.read.table("tab_alunos").select("id_discente","nome").limit(5).show()

#+-----------+--------------------+
#|id_discente|                nome|
#+-----------+--------------------+
#|      18957|ABELARDO DA SILVA...|
#|        553| ABIEL GODOY MARIANO|
#|      17977|ABIGAIL ANTUNES S...|
#|      16613|ABIGAIL FERNANDA ...|
#|      17398|ABIGAIL JOSIANE R...|
#+-----------+--------------------+


#2. Visualizar o id, nome e ano quando o ano de ingresso for maior ou igual a 2018
spark.sql("select id_discente,nome,ano_ingresso from tab_alunos where ano_ingresso>=2018 limit 4").show()

val DF_2018 = spark.read.table("tab_alunos").select("id_discente","nome","ano_ingresso").where("ano_ingresso>=2018")
#DF_2018: org.apache.spark.sql.Dataset[org.apache.spark.sql.Row] = [id_discente: int, nome: string ... 1 more field]

DF_2018.limit(4).show()

#+-----------+--------------------+------------+                                 
#|id_discente|                nome|ano_ingresso|
#+-----------+--------------------+------------+
#|      26880|ABIMAEL CHRISTOPF...|        2019|
#|      28508|   ABNER NUNES PERES|        2019|
#|      28071|ACSA ROBALO DOS S...|        2019|
#|      21968|AÇUCENA CARVALHO ...|        2018|
#+-----------+--------------------+------------+


#3. Visualizar por ordem alfabética [decrescente] do nome o id, nome e ano quando
#   o ano de ingresso for maior ou igual a 2018
spark.sql("select id_discente,nome,ano_ingresso from tab_alunos where ano_ingresso>=2018 order by nome desc limit 4").show()

DF_2018.sort("nome").limit(4).show()
DF_2018.orderBy("nome").limit(4).show()

DF_2018.orderBy($"nome".desc).limit(4).show()
DF_2018.orderBy(DF_2018("nome").desc).limit(4).show()


#4. Contar a quantidade de registros do item anterior
DF_2018.count()
#Long = 4266

spark.spark.sql("select count(*) as qtd from tab_alunos where ano_ingresso>=2018").show()
#+----+
#| qtd|
#+----+
#|4266|
#+----+


##. Anos distintos:
spark.sql("select distinct ano_ingresso from tab_alunos order by ano_ingresso").show()

spark.read.table("tab_alunos").select("ano_ingresso").distinct.sort("ano_ingresso").show()
#+------------+
#|ano_ingresso|
#+------------+
#|        2008|
#|        2010|
#|        2011|
#|        2012|
#|        2013|
#|        2014|
#|        2015|
#|        2016|
#|        2017|
#|        2018|
#|        2019|
#+------------+


:q
###################