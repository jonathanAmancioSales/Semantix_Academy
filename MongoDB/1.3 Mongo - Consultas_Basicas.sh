###################
#Consulta básica em documentos
###################
docker exec -ti mongo bash
mongo

use Jon
#switched to db Jon

#Renomear collection produtos para produto:
db.produtos.renameCollection('produto')
#{ "ok" : 1 }

show collections
#produto

#1. Mostrar todos os documentos da collection produto
#2. Pesquisar na collection produto, os documentos com os seguintes atributos:
#a) Nome = mouse
db.produto.find({nome:'mouse'})
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }


#b) Quantidade = 20 e apresentar/exibir apenas o campo nome
db.produto.find({qtd:20},{nome:1})
#{ "_id" : 4, "nome" : "hd externo" }


#c) Quantidade <= 20 e apresentar apenas os campos nome e qtd
db.produto.find({qtd:{$lte:20}},{_id:0,nome:1,qtd:1})
#{ "nome" : "memória ram", "qtd" : 10 }
#{ "nome" : "hd externo", "qtd" : 20 }

#d) Quantidade entre 10 e 20
#ERRADO:
db.produto.find({qtd:{$lte:20},qtd:{$gte:10}},{nome:1,qtd:1})
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10 }
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50 }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20 }
#CERTO:
db.produto.find({qtd:{$gte:10},qtd:{$lte:20}},{_id:0,nome:1,qtd:1})
#{ "nome" : "memória ram", "qtd" : 10 }
#{ "nome" : "hd externo",  "qtd" : 20 }


#e) Conexão = USB e não apresentar o campo _id e qtd
db.produto.find({'descricao.conexao':'USB'},{_id:0,qtd:0})
#{ "nome" : "mouse", "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }
#{ "nome" : "hd externo", "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }


#f) SO que contenha “Windows” ou “Windows 10”
db.produto.find({'descricao.so':{$in:['Windows','Windows 10']}})
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }
###################