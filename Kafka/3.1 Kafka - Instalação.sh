###################
#Exercícios - Instalação : Instalação Cluster Kafka
###################
#1. Criar a pasta kafka e inserir o arquivo docker-compose.yml;
#2. Instalação do docker e docker-compose;


#3. Inicializar o cluster Kafka através do docker-compose:
docker-compose up -d
#Creating network "kafka_default" with the default driver
#Creating zookeeper ... done
#Creating broker    ... done
#Creating schema-registry ... done
#Creating connect         ... done
#Creating rest-proxy      ... done
#Creating ksqldb-server   ... done
#Creating control-center  ... done
#Creating ksql-datagen    ... done
#Creating ksqldb-cli      ... done


#4. Listas as imagens em execução:
docker-compose images
#   Container                     Repository                       Tag         Image Id       Size  
#---------------------------------------------------------------------------------------------------
#broker            confluentinc/cp-server                      5.5.2         95c0e238b456   1.052 GB
#connect           cnfldemos/cp-server-connect-datagen         0.3.2-5.5.0   8b1a9577099c   1.526 GB
#control-center    confluentinc/cp-enterprise-control-center   5.5.2         4482d015d567   958.4 MB
#ksql-datagen      confluentinc/ksqldb-examples                5.5.2         d739ab13f1da   630.2 MB
#ksqldb-cli        confluentinc/cp-ksqldb-cli                  5.5.2         cd82f01891f7   646.7 MB
#ksqldb-server     confluentinc/cp-ksqldb-server               5.5.2         cb294553b9ec   662.7 MB
#rest-proxy        confluentinc/cp-kafka-rest                  5.5.2         c25996d4f5d8   1.223 GB
#schema-registry   confluentinc/cp-schema-registry             5.5.2         c511d747f9f8   1.263 GB
#zookeeper         confluentinc/cp-zookeeper                   5.5.2         d510b733e82d   666.3 MB


#5. Visualizar o log dos serviços broker e zookeeper:
docker logs broker
docker logs zookeeper


#6. Visualizar a interface do Confluent Control Center:
#   ---> Acesso: http://localhost:9021/

###################
docker exec -ti broker bash

kafka-topics --version
#5.5.2-ce (Commit:417a2e7a085d90a7)

###################