###################
#Exercícios - Pub/Sub
###################
docker exec -ti redis bash
redis-cli

#1. Criar um assinante para receber as mensagens do canal noticias:sp
subscribe noticias:sp
#Reading messages... (press Ctrl-C to quit)
#1) "subscribe"
#2) "noticias:sp"
#3) (integer) 1


#2. Criar um editor para enviar as seguintes mensagens no canal noticias:sp
#Msg 1
#Msg 2
#Msg 3
publish noticias:sp 'Msg 1'
publish noticias:sp 'Msg 2'
publish noticias:sp 'Msg 3'


#3. Cancelar o assinante do canal noticias:sp
unsubscribe noticias:sp


#4. Criar um assinante para receber as mensagens dos canais com o padrão noticias:*
psubscribe noticias:*
#Reading messages... (press Ctrl-C to quit)
#1) "psubscribe"
#2) "noticias:*"
#3) (integer) 1
####Depois do item 5:####
#1) "pmessage"
#2) "noticias:*"
#3) "noticias:rj"
#4) "Msg 4"
#1) "pmessage"
#2) "noticias:*"
#3) "noticias:sp"
#4) "bye"


#5. Criar um editor para enviar as seguintes mensagens no canal noticias:rj
#Msg 4
#Msg 5
publish noticias:rj 'Msg 4'
publish noticias:sp 'bye'
###################