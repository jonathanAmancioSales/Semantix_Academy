###################
#Outras Opções com Consultas
###################
docker exec -ti mongo bash
mongo

use Jon
#switched to db Jon

#1. Mostrar todos os documentos da collection produto
db.produto.find()


#2. Realizar as seguintes pesquisas na collection produto:
#a) Mostrar os documentos ordenados pelo nome em ordem alfabética.
db.produto.find().sort({'nome':1})
#{ "_id" : 1, "nome" : "cpu i5", "qtd" : "15" }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }


#b) Mostrar os 3 primeiros documentos ordenados por nome e quantidade.
db.produto.find().sort({'nome':1,'qtd':1}).limit(3)
#{ "_id" : 1, "nome" : "cpu i5", "qtd" : "15" }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
##Note que qtd em _id=1 e' uma string;

db.produto.find().sort({'qtd':1}).limit(3)
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }


#c) Mostrar apenas 1 documento que tenha o atributo Conexão = USB.
db.produto.findOne({'descricao.conexao':'USB'})
#ou
db.produto.find({'descricao.conexao':'USB'}).limit(1)
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }


#d) Mostrar os documentos que tenham o atributo conexão = USB E quantidade menor que 25.
db.produto.find({'descricao.conexao':'USB','qtd':{$lt:25}})
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }


#e) Mostrar os documentos que tenham o atributo conexão = USB OU quantidade menor que 25.
db.produto.find({$or:[{'descricao.conexao':'USB'},{'qtd':{$lt:25}}]})
db.produto.find({$or:[{'qtd':{$lt:25}},{'descricao.conexao':'USB'}]})
#{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
#{ "_id" : 3, "nome" : "mouse", "qtd" : 50, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }
#{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }


#f) Mostrar apenas os id dos documentos de tenham o atributo conexão = USB ou quantidade menor que 25.
db.produto.find({$or:[{'descricao.conexao':'USB'},{'qtd':{$lt:25}}]},{_id:1})
#{ "_id" : 2 }
#{ "_id" : 3 }
#{ "_id" : 4 }

###################