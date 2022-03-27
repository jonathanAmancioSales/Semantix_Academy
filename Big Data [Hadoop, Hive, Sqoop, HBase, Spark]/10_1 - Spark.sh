###################
#Spark - Exercícios de Esquema e Join
###################
docker container exec -ti spark bash

spark-shell

#1. Criar o DataFrame alunosDF para ler o arquivo no hdfs
#   "/user/aluno/<nome>/data/escola/alunos.csv" sem usar as "option"
val alunosDF = spark.read.csv("/user/aluno/Jon/data/escola/alunos.csv")
#alunosDF: org.apache.spark.sql.DataFrame = [_c0: string, _c1: string ... 5 more fields]

#2. Visualizar o esquema do alunosDF
alunosDF.printSchema()
#root
# |-- _c0: string (nullable = true)
# |-- _c1: string (nullable = true)
# |-- _c2: string (nullable = true)
# |-- _c3: string (nullable = true)
# |-- _c4: string (nullable = true)
# |-- _c5: string (nullable = true)
# |-- _c6: string (nullable = true)


#3. Criar o DataFrame alunosDF para ler o arquivo
#   "/user/aluno/<nome>/data/escola/alunos.csv" com a opção de Incluir o cabeçalho
val alunosDF = spark.read.option("header","true").csv("/user/aluno/Jon/data/escola/alunos.csv")
#alunosDF: org.apache.spark.sql.DataFrame = [id_discente: string, nome: string ... 5 more fields]

#4. Visualizar o esquema do alunosDF
alunosDF.printSchema()
#root
# |-- id_discente: string (nullable = true)
# |-- nome: string (nullable = true)
# |-- ano_ingresso: string (nullable = true)
# |-- periodo_ingresso: string (nullable = true)
# |-- nivel: string (nullable = true)
# |-- id_forma_ingresso: string (nullable = true)
# |-- id_curso: string (nullable = true)


#5. Criar o DataFrame alunosDF para ler o arquivo "/user/aluno/<nome>/data/escola/alunos.csv"
#   com a opção de Incluir o cabeçalho e inferir o esquema
val alunosDF = spark.read.option("header","true").option("inferSchema","true").csv("/user/aluno/Jon/data/escola/alunos.csv")
#alunosDF: org.apache.spark.sql.DataFrame = [id_discente: int, nome: string ... 5 more fields]		   

#6. Visualizar o esquema do alunosDF
alunosDF.printSchema()
#root
# |-- id_discente: integer (nullable = true)
# |-- nome: string (nullable = true)
# |-- ano_ingresso: integer (nullable = true)
# |-- periodo_ingresso: integer (nullable = true)
# |-- nivel: string (nullable = true)
# |-- id_forma_ingresso: integer (nullable = true)
# |-- id_curso: integer (nullable = true)

alunosDF.count()
#Long = 10000 

#7. Salvar o DaraFrame alunosDF como tabela Hive "tab_alunos" no banco de dados <nome>
alunosDF.write.saveAsTable("jon_db.tab_alunos")

#root@namenode:/# hdfs dfs -du -h /user/hive/warehouse/jon_db.db/tab_alunos
#0        /user/hive/warehouse/jon_db.db/tab_alunos/_SUCCESS
#209.3 K  /user/hive/warehouse/jon_db.db/tab_alunos/part-00000-a762e571-5da1-493b-9dce-d23fa4707d85-c000.snappy.parquet

#root@namenode:/# hdfs dfs -du -h /user/aluno/Jon/data/escola/alunos.csv
#533.5 K  /user/aluno/Jon/data/escola/alunos.csv

#Teste - Ler tabela Hive:
spark.read.table("jon_db.tab_alunos").show()
#+-----------+--------------------+------------+----------------+-----+-----------------+--------+
#|id_discente|                nome|ano_ingresso|periodo_ingresso|nivel|id_forma_ingresso|id_curso|
#+-----------+--------------------+------------+----------------+-----+-----------------+--------+
#|      18957|ABELARDO DA SILVA...|        2017|               1|    G|            62151|   76995|
#|        553| ABIEL GODOY MARIANO|        2015|            null|    M|          2081113|    3402|
#+-----------+--------------------+------------+----------------+-----+-----------------+--------+

#8. Criar o DataFrame cursosDF para ler o arquivo
#   "/user/aluno/<nome>/data/escola/cursos.csv" com
#   a opção de Incluir o cabeçalho e inferir o esquema
val cursosDF = spark.read.option("header","true").option("inferSchema","true").csv("/user/aluno/Jon/data/escola/cursos.csv")
#cursosDF: org.apache.spark.sql.DataFrame = [id_curso: int, id_unidade: int ... 10 more fields]	   

cursosDF.count()
#Long = 231

cursosDF.printSchema()
#root
# |-- id_curso: integer (nullable = true)
# |-- id_unidade: integer (nullable = true)
# |-- codigo: string (nullable = true)
# |-- nome: string (nullable = true)
# |-- nivel: string (nullable = true)
# |-- id_modalidade_educacao: integer (nullable = true)
# |-- id_municipio: integer (nullable = true)
# |-- id_tipo_oferta_curso: integer (nullable = true)
# |-- id_area_curso: integer (nullable = true)
# |-- id_grau_academico: integer (nullable = true)
# |-- id_eixo_conhecimento: integer (nullable = true)
# |-- ativo: integer (nullable = true)


#9. Criar o DataFrame alunos_cursosDF com o inner join do alunosDF
#   e cursosDF quando o id_curso dos 2 forem o mesmo
val alunos_cursosDF = alunosDF.join(cursosDF, "id_curso")
#alunos_cursosDF: org.apache.spark.sql.DataFrame = [id_curso: int, id_discente: int ... 16 more fields]

#=============
#OU:
val alunos_cursosDF = alunosDF.join(cursosDF, alunosDF("id_curso") === cursosDF("id_curso"), "inner")
val alunos_cursosDF = alunosDF.join(cursosDF, alunosDF("id_curso") === cursosDF("id_curso"))
#alunos_cursosDF: org.apache.spark.sql.DataFrame = [id_discente: int, nome: string ... 17 more fields]
alunos_cursosDF.printSchema()
#root
# |...
# |-- id_curso: integer (nullable = true)
# |-- id_curso: integer (nullable = true)
# |...
#=============

#10. Visualizar os dados, o esquema e a quantidade de registros do alunos_cursosDF
alunos_cursosDF.show(2)

alunos_cursosDF.printSchema()
#root
# |-- id_curso: integer (nullable = true)
# |-- id_discente: integer (nullable = true)
# |-- nome: string (nullable = true)
# |-- ano_ingresso: integer (nullable = true)
# |-- periodo_ingresso: integer (nullable = true)
# |-- nivel: string (nullable = true)
# |-- id_forma_ingresso: integer (nullable = true)
# |-- id_unidade: integer (nullable = true)
# |-- codigo: string (nullable = true)
# |-- nome: string (nullable = true)
# |-- nivel: string (nullable = true)
# |-- id_modalidade_educacao: integer (nullable = true)
# |-- id_municipio: integer (nullable = true)
# |-- id_tipo_oferta_curso: integer (nullable = true)
# |-- id_area_curso: integer (nullable = true)
# |-- id_grau_academico: integer (nullable = true)
# |-- id_eixo_conhecimento: integer (nullable = true)
# |-- ativo: integer (nullable = true)

alunos_cursosDF.count()
#Long = 9954

:quit
###################