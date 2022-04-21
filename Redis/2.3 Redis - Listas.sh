###################
#Exercícios - Listas
###################
docker exec -ti redis bash
redis-cli

##1. Criar a chave "views:ultimo_usuario" e insira nesta ordem os seguintes valores como lista:
#    Final da lista "Joao"
#    Final da lista "Ana"
#    Inicio da lista "Carlos"
#    Final da lista "Carol"

rpush views:ultimo_usuario Joao
#(integer) 1
rpush views:ultimo_usuario "Ana"
#(integer) 2
lpush views:ultimo_usuario Carlos
#(integer) 3
rpush views:ultimo_usuario Carol
#(integer) 4


##2. Visualizar todos os elementos da lista:
lrange views:ultimo_usuario 0 -1
#1) "Carlos"
#2) "Joao"
#3) "Ana"
#4) "Carol"


##3. Visualizar todos os elementos da lista, com exceção do último:
lrange views:ultimo_usuario 0 -2
#1) "Carlos"
#2) "Joao"
#3) "Ana"


##4. Visualizar o tamanho da lista:
llen views:ultimo_usuario
#(integer) 4


##5. Redefinir o tamanho da lista, removendo o primeiro elemento (Sem usar o pop):
ltrim views:ultimo_usuario 1 -1
#OK


##6. Visualizar o tamanho da lista:
llen views:ultimo_usuario
#(integer) 3


##7. Recuperar os elementos da lista da seguinte ordem:
#    Primeiro
#    Último
#    Primeiro com bloqueio de 5 segundos se a lista estiver vazia
#    Primeiro com bloqueio de 5 segundos se a lista estiver vazia

lpop views:ultimo_usuario
#"Joao"
rpop views:ultimo_usuario
#"Carol"

blpop views:ultimo_usuario 5
#1) "views:ultimo_usuario"
#2) "Ana"

blpop views:ultimo_usuario 5
#(nil)
#(5.08s)

###################
## Extra

### Visualizar todas as chaves:
keys *
#(empty array)

lpush views:ultimo_usuario Carlos Joao Ana Carol

keys *
#1) "views:ultimo_usuario"

lrange views:ultimo_usuario 0 -1
#1) "Carol"
#2) "Ana"
#3) "Joao"
#4) "Carlos"
###################