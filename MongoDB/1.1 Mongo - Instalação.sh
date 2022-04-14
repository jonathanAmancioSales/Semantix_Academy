###################
#Exercícios - Instalação
###################

###################
#Erro ao tentar executar a versão mais recente do mongodb:
docker container run mongo
#WARNING: MongoDB 5.0+ requires a CPU with AVX support,
#and your current system does not appear to have that!
# -> Usar versão anterior!
###################

###################
#1. Instalação do docker e docker-compose
#2. Baixar as imagens do mongo e mongo-express
docker-compose pull
#OU:
docker pull mongo:4.4.0
docker pull mongo-express


#3. Iniciar o MongoDB através do docker-compose
docker-compose up -d


#4. Listas as imagens em execução
docker-compose images
#  Container      Repository      Tag       Image Id       Size  
#----------------------------------------------------------------
#mongo           mongo           4.4.0    409c3f937574   493 MB  
#mongo-express   mongo-express   latest   e3505d6fafd0   135.6 MB

docker image ls
#REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
#mongo-express   latest    e3505d6fafd0   2 weeks ago     136MB
#mongo           4.4.0     409c3f937574   13 months ago   493MB


#5. Listar os bancos de dados do MongoDB
docker exec -ti mongo bash
mongo

show dbs
#admin   0.000GB
#config  0.000GB
#local   0.000GB


#6. Visualizar através do Mongo Express os bancos de dados. Acesso: http://localhost:8081/
#Tudo ok, exceto com o Server Status, que mostra o aviso:
#Turn on admin in config.js to view server stats!

#Add "- ME_CONFIG_MONGODB_ENABLE_ADMIN=true" em "environment:" do "docker-compose.yml" não resolveu!
#Inverter a ordem 'mongo','mongo-express' do "docker-compose.yml" também não resolveu!
###################