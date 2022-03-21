###################
#Exercícios - Strings
###################
docker exec -ti redis bash
redis-cli

#1. Criar a chave "usuario:nome" e atribua o valor do seu nome
set usuario:nome Jon
#OK

#2. Criar a chave "usuario:sobrenome" e atribua o valor do seu sobrenome
set "usuario:sobrenome" 'Sales'
#OK
get "usuario:sobrenome"
#"Sales"

#3. Busque a chave "usuario:nome"
get usuario:nome
#"Jon"

#4. Verificar o tamanho da chave "usuario:nome"
strlen usuario:nome
#(integer) 3

#5. Verificar o tipo da chave "usuario:sobrenome"
type usuario:sobrenome
#string

#6. Criar a chave "views:qtd" e atribua o valor 100
set views:qtd 100
#OK

#7. Incremente o valor em 10 da chave "views:qtd"
incrby views:qtd 10
#(integer) 110

#8. Busque a chave "views:qtd"
get views:qtd
#"110"

#9. Deletar a chave "usuario:sobrenome"
del usuario:sobrenome
#(integer) 1

#10. Verificar se a chave "usuario:sobrenome" existe
exists usuario:sobrenome
#(integer) 0

#11. Definir um tempo de 3600 segundos para a chave "views:qtd" ser removida
expire views:qtd 3600
#(integer) 1

#12. Verificar quanto tempo falta para a chave "views:qtd" ser removida
ttl views:qtd
#(integer) 3587
pttl views:qtd
#(integer) 3577584

#13. Verificar a persistência da chave "usuario:nome"
ttl usuario:nome
#(integer) -1

#14. Definir para a chave "views:qtd" ter persistência para sempre
persist views:qtd
#(integer) 1
ttl views:qtd
#(integer) -1
###################