###################
#Instalação Elastic
###################

#3. Executar os seguintes comandos, para baixar as imagens de Elastic:
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.9.2
docker pull docker.elastic.co/kibana/kibana:7.9.2
docker pull docker.elastic.co/logstash/logstash:7.9.2
#OU:
docker-compose pull


#4. Setar na máquina o vm.max_map_count com no mínimo 262144
#https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144

#sudo echo "" >> /etc/sysctl.conf
#sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf
#bash: /etc/sysctl.conf: Permissão negada
#Nesse caso, adicionar manualmente...

#Verificar configuração:
grep vm.max_map_count /etc/sysctl.conf
#vm.max_map_count = 262144

#Para aplicar a configuração em um sistema ativo:
sudo sysctl -w vm.max_map_count=262144
#vm.max_map_count = 262144


#5. Iniciar o cluster Elastic através do docker-compose
docker-compose up -d


#6. Listas as imagens em execução
docker-compose images
#  Container                     Repository                      Tag      Image Id       Size  
#----------------------------------------------------------------------------------------------
#elasticsearch  docker.elastic.co/elasticsearch/elasticsearch   7.9.2   caa7a21ca06e   762.9 MB
#kibana         docker.elastic.co/kibana/kibana                 7.9.2   ba296c26886a   1.177 GB
#logstash       docker.elastic.co/logstash/logstash             7.9.2   736bccdc74f4   734.7 MB


#7. Verificar os logs dos containers em execução
docker logs elasticsearch
docker logs kibana
docker logs logstash
#OU:
docker-compose logs

#8. Verificar as informações do cluster através do browser: http://localhost:9200/
#{
#  "name" : "node1",
#  "cluster_name" : "my_cluster",
#  "cluster_uuid" : "MnfwaAR-ReGehVmSE1Ra7A",
#  "version" : {
#    "number" : "7.9.2",
#    "build_flavor" : "default",
#    "build_type" : "docker",
#    "build_hash" : "d34da0ea4a966c4e49417f2da2f244e3e97b4e6e",
#    "build_date" : "2020-09-23T00:45:33.626720Z",
#    "build_snapshot" : false,
#    "lucene_version" : "8.6.2",
#    "minimum_wire_compatibility_version" : "6.8.0",
#    "minimum_index_compatibility_version" : "6.0.0-beta1"
#  },
#  "tagline" : "You Know, for Search"
#}

#9. Acessar o Kibana através do browser: http://localhost:5601/
###################