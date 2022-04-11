###################
#Exercícios - Kafka por Linha de Comando
###################

docker exec -ti broker bash

#1. Criar o tópico msg-cli com 2 partições e 1 réplica:
kafka-topics --bootstrap-server localhost:9092 --create \
             --topic msg-cli --partitions 2 --replication-factor 1
#Created topic msg-cli.

# Listar tópicos:
kafka-topics --bootstrap-server localhost:9092 -list
#ou:
kafka-topics --bootstrap-server broker:9092 -list
#__consumer_offsets
#__transaction_state
#_confluent-command
# [...]
#_confluent-monitoring
#_schemas
#default_ksql_processing_log
#docker-connect-configs
#docker-connect-offsets
#docker-connect-status
#msg-cli


#2. Descrever o tópico msg-cli:
kafka-topics --bootstrap-server localhost:9092 --topic msg-cli --describe
#Topic: msg-cli	PartitionCount: 2	ReplicationFactor: 1	Configs: 
#	Topic: msg-cli	Partition: 0	Leader: 1	Replicas: 1	Isr: 1	Offline: 
#	Topic: msg-cli	Partition: 1	Leader: 1	Replicas: 1	Isr: 1	Offline: 


#3. Criar o consumidor do grupo app-cli [em outro terminal]:
kafka-console-consumer --bootstrap-server localhost:9092 --topic msg-cli --group app-cli


#4. Enviar as seguintes mensagens do produtor [em outro terminal]:
#   Msg 1
#   Msg 2
kafka-console-producer --broker-list localhost:9092 --topic msg-cli


#5. Criar outro consumidor do grupo app-cli [em outro terminal]:
kafka-console-consumer --bootstrap-server localhost:9092 --topic msg-cli --group app-cli


#6. Enviar as seguintes mensagens do produtor
#   Msg 4
#   Msg 5
#   Msg 6
#   Msg 7
# [As mensagens são distribuídas de modo intercalado entre os
#  consumidores do mesmo grupo: uma mensagem para cada consumidor]


#7. Criar outro consumidor do grupo app2-cli [em outro terminal]:
kafka-console-consumer --bootstrap-server localhost:9092 --topic msg-cli --group app2-cli


#8. Enviar as seguintes mensagens do produtor
#   Msg 8
#   Msg 9
#   Msg 10
#   Msg 11
# [As mensagens são distribuídas entre os consumidores: 
#  uma mensagem para cada consumidor do mesmo grupo,
#  e todas as mensagens para o consumidor do outro grupo]


#9. Parar o app-cli; [Ctrl+c]
#Processed a total of 8 messages
#Processed a total of 6 messages


#10. Definir o deslocamento para -2 offsets do app-cli:
kafka-consumer-groups --bootstrap-server localhost:9092 \
                      --group app-cli --reset-offsets \
                      --shift-by -2 --execute --topic msg-cli
#GROUP      TOPIC      PARTITION  NEW-OFFSET
#app-cli    msg-cli    0          5
#app-cli    msg-cli    1          5


#11. Descrever grupo:
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group app-cli
#Consumer group 'app-cli' has no active members.
#GROUP    TOPIC    PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG  CONSUMER-ID  HOST  CLIENT-ID
#app-cli  msg-cli  0          5               7               2    -            -     -
#app-cli  msg-cli  1          5               7               2    -            -     -


#12. Iniciar o app-cli:
kafka-console-consumer --bootstrap-server localhost:9092 --topic msg-cli --group app-cli
#Msg 11
#Msg 13
#Msg 12
#Msg 14


#13. Redefinir todo o deslocamento do app-cli:
kafka-consumer-groups --bootstrap-server localhost:9092 \
                      --group app-cli --reset-offsets \
                      --to-earliest --execute --topic msg-cli
#GROUP      TOPIC      PARTITION  NEW-OFFSET
#app-cli    msg-cli    0          0
#app-cli    msg-cli    1          0

# Descrever grupo:
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group app-cli
#Consumer group 'app-cli' has no active members.
#GROUP    TOPIC    PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG  CONSUMER-ID  HOST  CLIENT-ID
#app-cli  msg-cli  0          0               7               7    -            -     -
#app-cli  msg-cli  1          0               7               7    -            -     -


#14. Iniciar o app-cli:
kafka-console-consumer --bootstrap-server localhost:9092 --topic msg-cli --group app-cli
# ...mostra todas as mensagens


#15. Listar grupos:
kafka-consumer-groups -bootstrap-server localhost:9092 --list
#app2-cli
#_confluent-controlcenter-5-5-2-1
#_confluent-controlcenter-5-5-2-1-command
#app-cli

###################