###################
#Sqoop -  Pesquisa e Criação de Tabelas
###################
docker container exec -ti namenode bash

sqoop version
#Sqoop 1.4.7

#1. Mostrar todos os databases
sqoop list-databases --connect jdbc:mysql://database --username root --password secret
sqoop list-databases --connect jdbc:mysql://database?useSSL=false --username root --password secret
#information_schema
#employees
#hue
#mysql
#performance_schema
#sakila
#sys

Conn=jdbc:mysql://database?useSSL=false
sqoop eval --connect $Conn --username=root --password=secret --query "show databases"
#------------------------
#| Database             |
#------------------------
#| information_schema   |
#| employees            |
#| hue                  |
#| mysql                |
#| performance_schema   |
#| sakila               |
#| sys                  |
#------------------------

#2. Mostrar todas as tabelas do bd employees
Conn=jdbc:mysql://database/employees?useSSL=false

sqoop list-tables --connect $Conn --username=root --password=secret
#current_dept_emp
#departments
#dept_emp
#dept_emp_latest_date
#dept_manager
#employees
#employees_2
#titles

sqoop eval --connect $Conn --username=root --password=secret \
--query "show tables"
#------------------------
#| Tables_in_employees  |
#------------------------
#| current_dept_emp     |
#| departments          |
#| dept_emp             |
#| dept_emp_latest_date |
#| dept_manager         |
#| employees            |
#| employees_2          |
#| titles               |
#------------------------


#3. Inserir os valores ('d010', 'BI') na tabela departments do bd employees
#4. Pesquisar todos os registros da tabela departments

Conn=jdbc:mysql://database/employees?useSSL=false
sqoop eval --connect $Conn --username=root --password=secret \
--query "SELECT * FROM departments"
#--------------------------------
#| dept_no | dept_name          |
#--------------------------------
#| d009    | Customer Service   |
#| d005    | Development        |
#| d002    | Finance            |
#| d003    | Human Resources    |
#| d001    | Marketing          |
#| d004    | Production         |
#| d006    | Quality Management |
#| d008    | Research           |
#| d007    | Sales              |
#--------------------------------

sqoop eval --connect $Conn --username=root --password=secret \
--query "insert into departments values(1,'vendas')"

sqoop eval --connect $Conn --username=root --password=secret \
--query "DELETE FROM departments WHERE dept_name='vendas'"


sqoop eval --connect $Conn --username=root --password=secret \
--query "insert into departments values('d010','BI')"

sqoop eval --connect $Conn --username=root --password=secret \
--query "select * from departments order by dept_no"
#-------------------------------
#| dept_no | dept_name         |
#-------------------------------
#| d001 | Marketing            |
#| d002 | Finance              |
#| d003 | Human Resources      |
#| d004 | Production           |
#| d005 | Development          |
#| d006 | Quality Management   |
#| d007 | Sales                |
#| d008 | Research             |
#| d009 | Customer Service     |
#| d010 | BI                   |
#-------------------------------


#5. Criar a tabela benefits(cod int(2) AUTO_INCREMENT PRIMARY KEY, name varchar(30)) no bd employees
sqoop eval --connect $Conn --username=root --password=secret \
--query "create table benefits(cod int(2) AUTO_INCREMENT PRIMARY KEY, name varchar(30))"


#6. Inserir os valores (null,'food vale') na tabela benefits
sqoop eval --connect $Conn --username=root --password=secret \
--query "insert into benefits values(null,'food vale')"


#7. Pesquisar todos os registros da tabela benefits
sqoop eval --connect $Conn --username=root --password=secret \
--query "select * from benefits"
#-----------------------------
#| cod | name                |
#-----------------------------
#| 1   | food vale           |
#-----------------------------

sqoop eval --connect $Conn --username=root --password=secret \
--query "describe benefits"
#---------------------------------------------------------------
#| Field | Type        | Null | Key | Default | Extra          |
#---------------------------------------------------------------
#| cod   | int(2)      | NO  | PRI | (null)   | auto_increment |
#| name  | varchar(30) | YES |     | (null)   |                |
#---------------------------------------------------------------
###################