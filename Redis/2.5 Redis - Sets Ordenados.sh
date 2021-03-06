###################
#Exercícios - Sets Ordenados
###################
docker exec -ti redis bash
redis-cli


## Deletar a chave "pesquisa:produto":
del pesquisa:produto
#(integer) 1

## Criar a chave "pesquisa:produto" do tipo set ordenado com os seguintes valores:
#  Valor: monitor, Score: 100
#  Valor: HD, Score: 20
#  Valor: mouse, Score: 10
#  Valor: teclado, Score: 50
#  O score representa a quantidade de pesquisas feitas para aquele produto na aplicação;
zadd pesquisa:produto 100 monitor 20 HD 10 mouse 50 teclado
#(integer) 4


##1. Visualizar a quantidade de produtos:
zcard pesquisa:produto
#(integer) 4


##2. Visualizar todos os produtos do mais pesquisado ao menos pesquisado:
zrevrange pesquisa:produto 0 -1
#1) "monitor"
#2) "teclado"
#3) "HD"
#4) "mouse"


##3. Visualizar o rank do produto teclado:
zrank pesquisa:produto teclado
#(integer) 2


##4. Visualizar o score do produto teclado:
zscore pesquisa:produto teclado
#"50"


##5. Remover o valor HD da chave:
zrem pesquisa:produto HD
#(integer) 1


##6. Recuperar e remover do set o produto mais pesquisado
zpopmax pesquisa:produto
#1) "monitor"
#2) "100"


##7. Recuperar e remover do set o produto menos pesquisado
zpopmin pesquisa:produto
#1) "mouse"
#2) "10"


##8. Visualizar todos os produtos
zrange pesquisa:produto 0 -1
#1) "teclado"

###################