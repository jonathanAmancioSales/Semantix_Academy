###################
#Exercícios - Instalação
###################

#1. Instalação do docker e docker-compose
#2. Baixar a imagem do redis
docker-compose pull
#OU:
docker pull redis

#3. Iniciar o Redis através do docker-compose
docker-compose up -d

#4. Listas as imagens em execução
docker-compose images
#Container   Repository    Tag       Image Id       Size  
#---------------------------------------------------------
#redis       redis        latest   02c7f2054405   105.4 MB

docker container ls
#CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                       NAMES
#03e84efe2095   redis     "redis-server --appe…"   29 seconds ago   Up 27 seconds   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp   redis


#5. Verificar a versão do Redis
docker exec redis redis-cli --version
#OU:
docker exec -ti redis bash
redis-cli --version
#redis-cli 6.2.6

#6. Acessar o Redis CLI
redis-cli

###################