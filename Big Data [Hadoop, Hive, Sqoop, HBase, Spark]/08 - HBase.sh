###################
#HBase - Exercícios
###################
docker container exec -ti hbase-master bash

hbase shell

status
#1 active master, 0 backup masters, 1 servers, 1 dead, 2.0000 average load

version
#1.2.6, rUnknown, Mon May 29 02:25:32 CDT 2017


#1. Criar a tabela 'controle' com os dados:
	#Chave: id
	#Família de Coluna: produto e fornecedor

create 'controle',{NAME=>'produto'},{NAME=>'fornecedor'}
#OU:
create 'controle','produto','fornecedor'

put 'controle','1','produto:nome','ram'
put 'controle','1','produto:qtd',100
put 'controle','1','fornecedor:nome','TI Comp'
put 'controle','1','fornecedor:estado','SP'

put 'controle','2','produto:nome','hd'
put 'controle','2','produto:qtd',50
put 'controle','2','fornecedor:nome','Peças PC'
put 'controle','2','fornecedor:estado','MG'

put 'controle','3','produto:nome','mouse'
put 'controle','3','produto:qtd',150
put 'controle','3','fornecedor:nome','Inf Tec'
put 'controle','3','fornecedor:estado','SP'


#2. Listar as tabelas e verificar a estrutura da tabela 'controle'
list
#=> ["controle"]

describe 'controle'
#Table controle is ENABLED
#controle
#COLUMN FAMILIES DESCRIPTION
#{NAME => 'fornecedor', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', COMPR
#ESSION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}
#{NAME => 'produto', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', COMPRESS
#ION => 'NONE', MIN_VERSIONS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}


#3. Contar o número de registros da tabela 'controle'
count 'controle'
#=> 3

#4. Alterar a família de coluna produto para 3 versões
alter 'controle',{NAME=>'produto', VERSIONS=>3}
#Updating all regions with the new schema...
#0/1 regions updated.
#0/1 regions updated.
#1/1 regions updated.
#Done

#5. Alterar a quantidade para 200 do id 2
put 'controle','2','produto:qtd',200


#6. Pesquisar as versões do id 2 da coluna quantidade
get 'controle','2',{COLUMN => 'produto:qtd', VERSIONS => 2}
#OU
get 'controle','2',{COLUMN => ['produto:qtd'], VERSIONS => 3}
#COLUMN               CELL
# produto:qtd         timestamp=1631314191832, value=200
# produto:qtd         timestamp=1631313676814, value=50


#7. Excluir os id (todo o registro/chave) do estado de SP

#Exibir coluna 'estado':
scan 'controle',{COLUMN => 'fornecedor:estado'}
#ROW           COLUMN+CELL
# 1            column=fornecedor:estado, timestamp=1631313676704, value=SP
# 2            column=fornecedor:estado, timestamp=1631313676933, value=MG
# 3            column=fornecedor:estado, timestamp=1631313678673, value=SP

scan 'controle',{COLUMN => 'fornecedor:estado', LIMIT => 2}
#ROW           COLUMN+CELL
# 1            column=fornecedor:estado, timestamp=1631313676704, value=SP
# 2            column=fornecedor:estado, timestamp=1631313676933, value=MG

#FILTRAR
scan 'controle',{COLUMN => 'fornecedor:estado', FILTER => "ValueFilter(=, 'binary:SP')"}
#ROW           COLUMN+CELL
# 1            column=fornecedor:estado, timestamp=1631313676704, value=SP
# 3            column=fornecedor:estado, timestamp=1631313678673, value=SP

scan 'controle',{COLUMN => 'fornecedor:estado', FILTER => "ValueFilter(!=, 'binary:SP')"}
#ROW           COLUMN+CELL
# 2            column=fornecedor:estado, timestamp=1631313676933, value=MG

#Para deletar toda as chaves cujo 'estado' é 'SP':
#delete 'controle','1'
#delete 'controle','3'

#8. Deletar a coluna estado da chave 2
delete 'controle','2','fornecedor:estado'


#9. Pesquisar toda a tabela controle
scan 'controle'
#ROW       COLUMN+CELL
# 1        column=fornecedor:estado, timestamp=1631313676704, value=SP
# 1        column=fornecedor:nome, timestamp=1631313676598, value=TI Comp
# 1        column=produto:nome, timestamp=1631313564401, value=ram
# 1        column=produto:qtd, timestamp=1631313658504, value=100
# 2        column=fornecedor:nome, timestamp=1631313676854, value=Pe\xC3\xA7as PC
# 2        column=produto:nome, timestamp=1631313676771, value=hd
# 2        column=produto:qtd, timestamp=1631314191832, value=200
# 3        column=fornecedor:estado, timestamp=1631313678673, value=SP
# 3        column=fornecedor:nome, timestamp=1631313677093, value=Inf Tec
# 3        column=produto:nome, timestamp=1631313676976, value=mouse
# 3        column=produto:qtd, timestamp=1631313677026, value=150
###################