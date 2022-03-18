###################
curl -O https://repo1.maven.org/maven2/com/twitter/parquet-hadoop-bundle/1.6.0/parquet-hadoop-bundle-1.6.0.jar

docker cp parquet-hadoop-bundle-1.6.0.jar spark:/opt/spark/jars

###################
docker container exec -ti spark bash
ls /opt/spark/jars/parquet*
#/opt/spark/jars/parquet-column-1.10.1.jar
#/opt/spark/jars/parquet-encoding-1.10.1.jar
#/opt/spark/jars/parquet-hadoop-1.10.1.jar
#/opt/spark/jars/parquet-common-1.10.1.jar
#/opt/spark/jars/parquet-format-2.4.0.jar
#/opt/spark/jars/parquet-jackson-1.10.1.jar
#/opt/spark/jars/parquet-hadoop-bundle-1.6.0.jar
###################
###################
#Spark - Exercícios de DataFrame (2021.11.10)
###################

#1. Enviar o diretório local "/input/exercises-data/juros_selic"
#   para o HDFS em "/user/aluno/<nome>/data"
docker container exec -ti namenode bash
hdfs dfs -put /input/exercises-data/juros_selic /user/aluno/Jon/data

hdfs dfs -ls -R -h /user/aluno/Jon/data/juros_selic
#-rw-r--r--  3 root supergroup   7.8 K 2021-09-11 13:12 /user/aluno/Jon/data/juros_selic/juros_selic
#-rw-r--r--  3 root supergroup  14.3 K 2021-09-11 13:12 /user/aluno/Jon/data/juros_selic/juros_selic.json
#-rw-r--r--  3 root supergroup  12.6 K 2021-09-11 13:12 /user/aluno/Jon/data/juros_selic/juros_selic.wsdl


docker container exec -ti spark bash
spark-shell
#2. Criar o DataFrame jurosDF para ler o arquivo no HDFS
#   "/user/aluno/<nome>/data/juros_selic/juros_selic.json"
val jurosDF = spark.read.json("/user/aluno/Jon/data/juros_selic/juros_selic.json")
#jurosDF: org.apache.spark.sql.DataFrame = [data: string, valor: string] 

#3. Visualizar o Schema do jurosDF
jurosDF.printSchema()
#root
# |-- data: string (nullable = true)
# |-- valor: string (nullable = true)


#4. Mostrar os 5 primeiros registros do jurosDF
jurosDF.show(5)
#+----------+-----+
#|      data|valor|
#+----------+-----+
#|01/06/1986| 1.27|
#|01/07/1986| 1.95|
#|01/08/1986| 2.57|
#|01/09/1986| 2.94|
#|01/10/1986| 1.96|
#+----------+-----+

#Não truncar os dados/valores:
jurosDF.show(5,false)

jurosDF.take(5)
#Array[org.apache.spark.sql.Row] = Array([01/06/1986,1.27], [01/07/1986,1.95], [01/08/1986,2.57], [01/09/1986,2.94], [01/10/1986,1.96])


#5. Contar a quantidade de registros do jurosDF
jurosDF.count()
#Long = 393


#6. Criar o DataFrame jurosDF10 para filtrar apenas os registros
#   [do DataFrame jurosDF] com o campo "valor" maior que 10
val jurosDF10 = jurosDF.where("valor>10")
#jurosDF10: org.apache.spark.sql.Dataset[org.apache.spark.sql.Row] = [data: string, valor: string]

jurosDF10.count()
#Long = 78


#7. Salvar o DataFrame jurosDF10 como tabela Hive "<nome>.tab_juros_selic"
#Por padrão, saveAsTable salva em /user/hive/warehouse/
jurosDF10.write.saveAsTable("jon_db.tab_juros_selic")

#root@namenode:/# hdfs dfs -du -h /user/hive/warehouse/jon_db.db/tab_juros_selic
#0      /user/hive/warehouse/jon_db.db/tab_juros_selic/_SUCCESS
#1.4 K  /user/hive/warehouse/jon_db.db/tab_juros_selic/part-00000-385bfe5d-a90d-4eb9-8183-fc2494bba90e-c000.snappy.parquet

#8. Criar o DataFrame jurosHiveDF para ler a tabela "<nome>.tab_juros_selic"
#Apresentará erro se não tiver baixado o jar citado no início!
#Erro: val jurosHiveDF = spark.read.table("jon_db.tab_juros_selic")
#Erro: spark.read.table("jon_db.tab_juros_selic").show()

val jurosHiveDF = spark.read.parquet("/user/hive/warehouse/jon_db.db/tab_juros_selic")
#jurosHiveDF: org.apache.spark.sql.DataFrame = [data: string, valor: string]

#=============
#Funcionou depois de baixar e mover o jar para o spark!
#Note que foi necessário salvar novamente como tabela hive ("jon_db.tab_juros_selic2").
#A leitura 'read.table' da primeira tabela ("jon_db.tab_juros_selic") continua não funcionando!
val jurosDF10 = spark.read.json("/user/aluno/Jon/data/juros_selic/juros_selic.json").where("valor>10")
jurosDF10.write.saveAsTable("jon_db.tab_juros_selic2")
spark.read.table("jon_db.tab_juros_selic2").show()
#+----------+-----+
#|      data|valor|
#+----------+-----+
#|01/01/1987|11.00|
#|01/02/1987|19.61|
#+----------+-----+
#=============


#9. Visualizar o Schema do jurosHiveDF
jurosHiveDF.printSchema()
#root
# |-- data: string (nullable = true)
# |-- valor: string (nullable = true)


#10. Mostrar os 5 primeiros registros do jurosHiveDF
jurosHiveDF.show(5)
#+----------+-----+
#|      data|valor|
#+----------+-----+
#|01/01/1987|11.00|
#|01/02/1987|19.61|
#|01/03/1987|11.95|
#|01/04/1987|15.30|
#|01/05/1987|24.63|
#+----------+-----+

jurosHiveDF.count
#Long = 78


#11. Salvar o DataFrame jurosHiveDF no HDFS no diretório
#    "/user/aluno/nome/data/save_juros" no formato parquet
jurosHiveDF.write.save("/user/aluno/Jon/data/save_juros")


#12. Visualizar o save_juros no HDFS
root@namenode:/# hdfs dfs -du -h /user/aluno/Jon/data/save_juros
#0      /user/aluno/Jon/data/save_juros/_SUCCESS
#1.4 K  /user/aluno/Jon/data/save_juros/part-00000-6271c59f-c655-4b11-8a43-d6d27627b39c-c000.snappy.parquet

#root@namenode:/# hdfs dfs -cat /user/aluno/Jon/data/save_juros/part-00000-*.snappy.parquet | head -1


#13. Criar o DataFrame jurosHDFS para ler o diretório do "save_juros" da questão [11!!]
val jurosHDFS = spark.read.load("hdfs://namenode:8020/user/aluno/Jon/data/save_juros")
#OU:
val jurosHDFS = spark.read.parquet("/user/aluno/Jon/data/save_juros")
#jurosHDFS: org.apache.spark.sql.DataFrame = [data: string, valor: string]


#14. Visualizar o Schema do jurosHDFS
jurosHDFS.printSchema()
#root
# |-- data: string (nullable = true)
# |-- valor: string (nullable = true)

#15. Mostrar os 5 primeiros registros do jurosHDFS
jurosHDFS.show(5)
#+----------+-----+
#|      data|valor|
#+----------+-----+
#|01/01/1987|11.00|
#|01/02/1987|19.61|
#|01/03/1987|11.95|
#|01/04/1987|15.30|
#|01/05/1987|24.63|
#+----------+-----+

:q
###################