###################
#Comando Básicos para BD, Collections e Documentos
###################
docker exec -ti mongo bash
mongo

#1. Criar o banco de dados com seu nome.
use Jon
#switched to db Jon


#2. Listar os banco de dados.
show dbs
#admin   0.000GB
#config  0.000GB
#local   0.000GB

#Mostrar banco de dados conectado:
db
#Jon


#3. Criar a collection produto no bd com seu nome.
db.createCollection('produtos')
#{ "ok" : 1 }


#4. Listar os banco de dados.
show dbs
#Jon     0.000GB
#admin   0.000GB
#config  0.000GB
#local   0.000GB


#5. Listar as collections.
show collections
#produtos

#6. Inserir os seguintes documentos na collection produtos:
#_id: 1, "nome": "cpu i5", "qtd": "15"
#_id: 2, nome: "memória ram", qtd: 10, descricao: {armazenamento: "8GB", tipo:"DDR4"}
#_id: 3, nome: "mouse", qtd: 50, descricao: {conexao: "USB", so: ["Windows", "Mac", "Linux"]}
#_id: 4, nome: "hd externo", "qtd": 20, descricao: {conexao: "USB", armazenamento: "500GB", so: ["Windows 10", "Windows 8", "Windows 7"]}

db.produtos.insertOne({_id:1, "nome":"cpu i5", "qtd":"15"})
#{ "acknowledged" : true, "insertedId" : 1 }

db.produtos.insertMany([
{_id:2, nome:'memória ram', qtd:10, descricao:{armazenamento: '8GB', tipo:'DDR4'} },
{_id:3, nome:'mouse',       qtd:50, descricao:{conexao: 'USB', so: ['Windows', 'Mac', 'Linux']} },
{_id:4, nome:'hd externo',  qtd:20, descricao:{conexao: 'USB', armazenamento: '500GB', so: ['Windows 10', 'Windows 8', 'Windows 7']} }
])
#{ "acknowledged" : true, "insertedIds" : [ 2, 3, 4 ] }


#7. Mostrar todos os documentos.
db.produtos.find()
#{ "_id" : 1, "nome" : "cpu i5", "qtd" : "15" }
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }

db.produtos.find().pretty()
#{ "_id" : 1, "nome" : "cpu i5", "qtd" : "15" }
#{
#	"_id" : 2,
#	"nome" : "memória ram",
#	"qtd" : 10,
#	"descricao" : {
#		"armazenamento" : "8GB",
#		"tipo" : "DDR4"
#	}
#}
#{
#	"_id" : 3,
#	"nome" : "mouse",
#	"qtd" : 50,
#	"descricao" : {
#		"conexao" : "USB",
#		"so" : [
#			"Windows",
#			"Mac",
#			"Linux"
#		]
#	}
#}
#{
#	"_id" : 4,
#	"nome" : "hd externo",
#	"qtd" : 20,
#	"descricao" : {
#		"conexao" : "USB",
#		"armazenamento" : "500GB",
#		"so" : [
#			"Windows 10",
#			"Windows 8",
#			"Windows 7"
#		]
#	}
#}
###################