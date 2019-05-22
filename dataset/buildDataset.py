# -*- coding: utf-8 -*-
import pyodbc
import random
import csv 
import os
from faker import Faker

def connect():
    """ Creates a connection to the database """
    cnx = None
    try:
        cnx = pyodbc.connect('DRIVER={SQL Server};SERVER=SURFACEJPC\SQLEXPRESS;DATABASE=SGCasaDeApostas;UID=testUser;PWD=testing')

    except pyodbc.OperationalError:
        print('Unable to make a connection to the mysql database.')

    assert cnx is not None, 'Can\'t open DB connection. Unable to make a connection to the mysql database.'
    
    return cnx

def disconnect(cnx):
    """ Closes connection to the database
    
    Parameters
    cnx: 
        The connection to be closed
    """

    assert cnx is not None, 'Can\'t close DB connection. Connection object is not valid.'

    try:
        cnx.close()
    except:
        print('Something went wrong when closing database connection.')    

def add_Casas_de_Apostas(ammount):
    fake = Faker()
    conn = connect()
    cursor = conn.cursor()
    for x in range(0, ammount):
        name = fake.company()
        email = fake.company_email() 
        telefone = fake.msisdn()
        site = fake.uri()
        query = 'INSERT INTO cdp.casa_de_apostas VALUES (' +"'" + name + "'" + ',' + "'" + email + "'" +  ',' + "'" + telefone + "'" + ','+ "'" + site + "'" +  ');'
        print(query)
        cursor.execute(query)
        cursor.commit()
    disconnect(conn)    

def add_apostadores(ammount):
    fake = Faker()
    conn = connect()
    cursor = conn.cursor()
    for x in range(0, ammount):
        email = fake.company_email() 
        NIF = random.randint(100000000, 999999999)
        Pnome = fake.first_name()
        Unome = fake.last_name()
        telemovel = random.randint(100000000, 999999999)
        EqFav = fake.color_name()
        query = "INSERT INTO cdp.apostador (Email, NIF, Primeiro_Nome, Ultimo_Nome, Telemovel, Equipa_Favorita) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')" % (email, NIF, Pnome, Unome, telemovel, EqFav)
        print(query)
        cursor.execute(query)
        cursor.commit()
    disconnect(conn)     

def add_desportos():
    conn = connect()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO cdp.desporto (Nome) VALUES ('Futebol')")
    cursor.execute("INSERT INTO cdp.desporto (Nome) VALUES ('Basket')")
    cursor.commit()
    disconnect(conn)  

def add_clubes_futebol(path, desporto, limit):
    conn = connect()
    cursor = conn.cursor()
    with open(path) as dataset:
        reader = csv.DictReader(dataset, delimiter=',')
        i = 0
        for row in reader:
            if(cursor.execute("SELECT * FROM cdp.equipa WHERE Nome = '%s'" % (row["home_team"].replace("'", ""))).rowcount == 0):
                cursor.execute("INSERT INTO cdp.equipa (Nome, ID_desporto) VALUES ('%s', %d)" % (row["home_team"].replace("'", ""), desporto))
                cursor.commit()
            
            if(cursor.execute("SELECT * FROM cdp.equipa WHERE Nome = '%s'"  % (row["away_team"].replace("'", ""))).rowcount == 0):
                cursor.execute("INSERT INTO cdp.equipa (Nome, ID_desporto) VALUES ('%s', %d)" % (row["away_team"].replace("'", ''), desporto))
                cursor.commit()

            i = i + 1
            if(i == limit):
                break
    disconnect(conn)

def add_competicao_futebol(path, desporto, limit):
    conn = connect()
    cursor = conn.cursor()
    with open(path) as dataset:
        reader = csv.DictReader(dataset, delimiter=',')    
        i = 0  
        ligas = []
        ligasNomes = []
        for row in reader:
            paisLiga = row["league"].split(": ")
            if(paisLiga[1] not in ligasNomes):
                ligaDic = {}
                ligaDic["nome"] = paisLiga[1]
                ligaDic["pais"] = paisLiga[0]
                ligaDic["datainicio"] = row["match_date"].replace("-", "/")
                ligaDic["datafim"] = row["match_date"].replace("-", "/")
                ligas.append(ligaDic)
                ligasNomes.append(paisLiga[1])
            else:
                for elem in ligas:
                    if(elem["nome"] == paisLiga[1]):
                        elem["datafim"] = row["match_date"].replace("-", "/")
            i = i + 1
            if(i == limit):
                break
        for elem in ligas:
            cursor.execute("INSERT INTO cdp.competicao (Nome, Pais, Data_Inicio, Data_Fim, ID_Desporto) VALUES ('%s', '%s', '%s', '%s', %d)" % (elem["nome"].replace("'", ""), elem["pais"], elem["datainicio"], elem["datafim"], desporto))
            cursor.commit()
    disconnect(conn)      

          

#add_Casas_de_Apostas(3)
#add_apostadores(3)
#add_desportos()
#add_clubes_futebol('data/closing_odds.csv', 1, 8000)
#add_competicao_futebol('data/closing_odds.csv', 1, 8000)
