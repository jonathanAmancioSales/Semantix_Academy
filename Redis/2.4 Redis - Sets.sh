###################
#Exercícios - Sets
###################
docker exec -ti redis bash
redis-cli


##1. Deletar a chave "pesquisa:produto":
del pesquisa:produto
#(integer) 0


##2. Criar a chave "pesquisa:produto" do tipo set com os seguintes valores: monitor, mouse e teclado:
sadd pesquisa:produto monitor mouse teclado
#(integer) 3


##3. Visualizar a quantidade de valores da chave:
scard pesquisa:produto
#(integer) 3


##4. Retornar todos os elementos da chave:
smembers pesquisa:produto
#1) "teclado"
#2) "monitor"
#3) "mouse"


##5. Verificar se existe o valor monitor:
sismember pesquisa:produto monitor
#(integer) 1


##6. Remover o valor monitor:
srem pesquisa:produto monitor
#(integer) 1

sismember pesquisa:produto monitor
#(integer) 0


##7. Recuperar um elemento e remove-lo do set:
spop pesquisa:produto
#"mouse"


##8. Criar a chave "pesquisa:desconto" do tipo set com os seguintes valores: memória RAM, monitor, teclado, HD:
sadd pesquisa:desconto "memoria RAM" monitor teclado HD
#(integer) 4

smembers pesquisa:desconto
#1) "teclado"
#2) "monitor"
#3) "HD"
#4) "memoria RAM"


##9. Próximas questões fazem uso dos sets pesquisa:produto e pesquisa:desconto;
###a- Visualizar a interseção entre os 2 sets:
sinter pesquisa:produto pesquisa:desconto
#1) "teclado"

###b- Visualizar a diferença entre os 2 sets:
sdiff pesquisa:produto pesquisa:desconto
#(empty array)

###c- Criar o set "pesquisa:produto_desconto" com a união entre os 2 sets:
sunionstore union:produto_desconto pesquisa:produto pesquisa:desconto
#(integer) 4

smembers union:produto_desconto
#1) "monitor"
#2) "teclado"
#3) "HD"
#4) "memoria RAM"

###################