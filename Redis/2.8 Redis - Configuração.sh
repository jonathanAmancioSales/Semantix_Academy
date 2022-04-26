###################
#Exercícios - Configuração
###################
docker exec -ti redis bash
redis-cli

#1. Visualizar todos os parâmetros de configuração
config get *
#  1) "rdbchecksum"
#  2) "yes"
#...
#335) "oom-score-adj-values"
#336) "0 200 800"


#2. Verificar o parâmetro "appendonly"
config get appendonly
#1) "appendonly"
#2) "yes"


#3. Remover a persistência dos dados, alterando o parâmetro "appendonly" para "no"
config set appendonly no
#OK
config get appendonly
#1) "appendonly"
#2) "no"


#4. Verificar o parâmetro "save"
config get save
#1) "save"
#2) "3600 1 300 100 60 10000"


#5. Adicionar a persistência dos dados, para a cada 2 minutos
#   (120 segundos) se pelo menos 500 chaves forem alteradas,
#   adicionando o parâmetro "save" para "120 500"
config set save '120 500'
#OK
config get save
#1) "save"
#2) "120 500"


#6. Verificar os parâmetros "maxmemory*"
config get maxmemory*
#1) "maxmemory-policy"
#2) "noeviction"
#3) "maxmemory-samples"
#4) "5"
#5) "maxmemory-eviction-tenacity"
#6) "10"
#7) "maxmemory"
#8) "0"


#7. Permitir que o Redis remova automaticamente os dados antigos
#   à medida que você adiciona novos dados, com uso da politica
#   "allkeys-lru", quando chegar a 1mb de memória.
config set maxmemory-policy allkeys-lru
#OK
config set maxmemory 1mb
#OK

config get maxmemory-po*
#1) "maxmemory-policy"
#2) "allkeys-lru"
config get maxmemory
#1) "maxmemory"
#2) "1048576"
###################