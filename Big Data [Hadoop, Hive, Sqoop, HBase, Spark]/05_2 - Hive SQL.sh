###################
#Hive - Seleção de Tabelas
###################
docker container exec -ti hive-server bash
beeline -u jdbc:hive2://localhost:10000
use Jon_db;

###################
#Escolher outro engine faz com que o warning/aviso
#não seja mostrado quando executado o comando count();

#Padrão: #(45.672 seconds na execução do item 3)
SET hive.execution.engine=mr;

#Entretanto, o engine MR tornou a consulta muito lenta:
#(318.801 seconds na execução do item 3)
SET hive.execution.engine=MR;

#Os engines spark e tez apresentaram erro;
###################


#1. Selecionar os 10 primeiros registros da tabela nascimento pelo ano de 2016
select * from nascimento where ano=2016 limit 10;


#2. Contar a quantidade de nomes de crianças nascidas em 2017
select count(nome) from nascimento where ano=2017;
#+--------+
#|  _c0   |
#+--------+
#| 32469  |
#+--------+

## Quantidade de nomes distintos:
select count(distinct nome) from nascimento where ano=2017;
#+--------+
#|  _c0   |
#+--------+
#| 29910  |
#+--------+


#3. Contar a quantidade de crianças nascidas em 2017
#select sum(frequencia) from nascimento where ano=2017;
select sum(frequencia) as qtd from nascimento where ano=2017;
#+----------+
#|   qtd    |
#+----------+
#| 3546301  |
#+----------+


#4. Contar a quantidade de crianças nascidas por sexo no ano de 2015
select sum(frequencia) from nascimento where ano=2015 group by sexo;
#+----------+
#|   _c0    |
#+----------+
#| 1778883  |
#| 1909804  |
#+----------+

select sexo, sum(frequencia) as qtd from nascimento where ano=2015 group by sexo;
#+-------+----------+
#| sexo  |   qtd    |
#+-------+----------+
#| F     | 1778883  |
#| M     | 1909804  |
#+-------+----------+

##. Contar a quantidade de crianças nascidas por sexo e por ano
select ano, sexo, sum(frequencia) as qtd from nascimento group by ano,sexo;
#+-------+-------+----------+
#|  ano  | sexo  |   qtd    |
#+-------+-------+----------+
#| 2015  | F     | 1778883  |
#| 2016  | F     | 1763916  |
#| 2017  | F     | 1711811  |
#| 2015  | M     | 1909804  |
#| 2016  | M     | 1889052  |
#| 2017  | M     | 1834490  |
#+-------+-------+----------+


#5. Mostrar por ordem de ano decrescente a quantidade de crianças nascidas por sexo
select ano, sexo, sum(frequencia) as qtd from nascimento group by ano,sexo order by ano desc;
#+-------+-------+----------+
#|  ano  | sexo  |   qtd    |
#+-------+-------+----------+
#| 2017  | M     | 1834490  |
#| 2017  | F     | 1711811  |
#| 2016  | M     | 1889052  |
#| 2016  | F     | 1763916  |
#| 2015  | M     | 1909804  |
#| 2015  | F     | 1778883  |
#+-------+-------+----------+

select ano, sexo, sum(frequencia) as qtd from nascimento group by ano,sexo order by ano;
#+-------+-------+----------+
#|  ano  | sexo  |   qtd    |
#+-------+-------+----------+
#| 2015  | M     | 1909804  |
#| 2015  | F     | 1778883  |
#| 2016  | M     | 1889052  |
#| 2016  | F     | 1763916  |
#| 2017  | M     | 1834490  |
#| 2017  | F     | 1711811  |
#+-------+-------+----------+


#6. Mostrar por ordem de ano decrescente a quantidade de crianças nascidas por sexo com o nome iniciado com 'A'
select ano, sexo, sum(frequencia) as qtd from nascimento where nome like 'A%' group by ano,sexo order by ano desc;
#+-------+-------+---------+
#|  ano  | sexo  |   qtd   |
#+-------+-------+---------+
#| 2017  | M     | 185566  |
#| 2017  | F     | 308551  |
#| 2016  | M     | 191854  |
#| 2016  | F     | 324185  |
#| 2015  | M     | 194722  |
#| 2015  | F     | 329690  |
#+-------+-------+---------+


#7. Qual nome e quantidade das 5 crianças mais nascidas em 2016
##. Quais os 5 nomes mais frequentes, das crianças nascidas em 2016, e suas respectivas quantidades?
select nome, frequencia as qtd from nascimento where ano=2016 order by qtd desc limit 5;
#+---------+--------+
#|  nome   |  qtd   |
#+---------+--------+
#| Emma    | 19471  |
#| Olivia  | 19327  |
#| Noah    | 19082  |
#| Liam    | 18198  |
#| Ava     | 16283  |
#+---------+--------+

## Quais os 5 nomes mais frequentes, das crianças nascidas em 2016, e suas respectivas quantidades,
## levando em conta os nomes repetidos na tabela:
select nome, count(nome) as duplicidade_na_tabela, sum(frequencia) as qtd
from nascimento
where ano=2016
group by nome
order by qtd desc
limit 5;
#+---------+------------------------+--------+
#|  nome   | duplicidade_na_tabela  |  qtd   |
#+---------+------------------------+--------+
#| Emma    | 2                      | 19489  |
#| Olivia  | 2                      | 19342  |
#| Noah    | 2                      | 19216  |
#| Liam    | 2                      | 18217  |
#| Ava     | 2                      | 16293  |
#+---------+------------------------+--------+

select nome, frequencia as qtd, ano from nascimento where ano=2016 and nome='Emma';
#+-------+--------+-------+
#| nome  |  qtd   |  ano  |
#+-------+--------+-------+
#| Emma  | 19471  | 2016  |
#| Emma  | 18     | 2016  |
#+-------+--------+-------+

#8. Qual nome e quantidade das 5 crianças mais nascidas em 2016 do sexo masculino e feminino
## Quais os 5 nomes mais frequentes, das crianças dos sexos masculino e feminino
## nascidas em 2016, e suas respectivas quantidades:
select sexo, nome, frequencia as qtd from nascimento where ano=2016 order by qtd desc limit 10;
#+-------+-----------+--------+
#| sexo  |   nome    |  qtd   |
#+-------+-----------+--------+
#| F     | Emma      | 19471  |
#| F     | Olivia    | 19327  |
#| M     | Noah      | 19082  |
#| M     | Liam      | 18198  |
#| F     | Ava       | 16283  |
#| F     | Sophia    | 16112  |
#| M     | William   | 15739  |
#| M     | Mason     | 15230  |
#| M     | James     | 14842  |
#| F     | Isabella  | 14772  |
#+-------+-----------+--------+

## Quais os 5 nomes mais frequentes, das crianças do sexo feminino
## nascidas em 2016, e suas respectivas quantidades:
select sexo, nome, frequencia as qtd from nascimento where ano=2016 and sexo='F' order by qtd desc limit 5;
#+-------+-----------+--------+
#| sexo  |   nome    |  qtd   |
#+-------+-----------+--------+
#| F     | Emma      | 19471  |
#| F     | Olivia    | 19327  |
#| F     | Ava       | 16283  |
#| F     | Sophia    | 16112  |
#| F     | Isabella  | 14772  |
#+-------+-----------+--------+

## Tentar:
#select sexo, nome, frequencia as qtd from nascimento where ano=2016 and sexo='F' order by qtd desc limit 5
union all
#select sexo, nome, frequencia as qtd from nascimento where ano=2016 and sexo='M' order by qtd desc limit 5;

###################

## Contar a quantidade de nomes registrados por ano:
select ano, count(distinct nome) as qtd from nascimento group by ano;
#+-------+--------+
#|  ano  |  qtd   |
#+-------+--------+
#| 2015  | 30583  |
#| 2016  | 30386  |
#| 2017  | 29910  |
#+-------+--------+


## Contar a quantidade de nomes registrados e a quantidade de crianças nascidas por ano:
#CORRETO, uma vez que há nomes duplicados;
select ano, count(distinct nome) as qtd_nomes, sum(frequencia) as qtd from nascimento group by ano;
#+-------+------------+----------+
#|  ano  | qtd_nomes  |   qtd    |
#+-------+------------+----------+
#| 2015  | 30583      | 3688687  |
#| 2016  | 30386      | 3652968  |
#| 2017  | 29910      | 3546301  |
#+-------+------------+----------+

select ano, count(nome) as qtd_nomes, sum(frequencia) as qtd from nascimento group by ano;
#+-------+------------+----------+
#|  ano  | qtd_nomes  |   qtd    |
#+-------+------------+----------+
#| 2015  | 33098      | 3688687  |
#| 2016  | 32979      | 3652968  |
#| 2017  | 32469      | 3546301  |
#+-------+------------+----------+

###################