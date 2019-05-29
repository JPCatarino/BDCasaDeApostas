# -*- coding: utf-8 -*-
import pyodbc
from random import random
from random import randint 
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
# Bug with unicode chars
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

# Has bug with none type
def add_jogos(path, limit):
    conn = connect()
    cursor = conn.cursor()
    with open(path) as dataset:
        reader = csv.DictReader(dataset, delimiter = ',')
        i = 0
        for row in reader:
            cursor.execute("SELECT ID FROM cdp.equipa WHERE Nome = '%s'" % (row["home_team"].replace("'", "")))
            home_team = cursor.fetchone().ID
            cursor.execute("SELECT ID FROM cdp.equipa WHERE Nome = '%s'" % (row["away_team"].replace("'", "")))
            away_team = cursor.fetchone().ID
            liga = row["league"].split(": ")
            cursor.execute("SELECT ID FROM cdp.competicao WHERE Nome = '%s'" % liga[1].replace("'", ""))
            liga = cursor.fetchone().ID
            cursor.execute("INSERT INTO cdp.jogo (Data, ID_casa, ID_fora, ID_competicao) VALUES ('%s', %d, %d, %d)" % (row["match_date"].replace("-", "/"), home_team, away_team, liga))
            cursor.commit()
            i = i + 1
            if(i == limit):
                break
    disconnect(conn)

def generate_odds():
    return (random() * (7 - 0))

def add_apostas():
    conn = connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM cdp.jogo")
    for row in cursor.fetchall():
        cursor.execute("INSERT INTO cdp.aposta_normal (Descricao, Odds, DataHora) VALUES ('%s', %.4f, '%s')" % ("HOME WIN", generate_odds(), row.Data))
        cursor.execute("INSERT INTO cdp.aposta_normal (Descricao, Odds, DataHora) VALUES ('%s', %.4f, '%s')" % ("DRAW", generate_odds(), row.Data))
        cursor.execute("INSERT INTO cdp.aposta_normal (Descricao, Odds, DataHora) VALUES ('%s', %.4f, '%s')" % ("AWAY WIN", generate_odds(), row.Data))
    cursor.commit()
    #cursor.execute("SELECT aposta_normal.ID AS ID_Aposta, jogo.ID AS ID_Jogo FROM cdp.aposta_normal FULL OUTER JOIN cdp.jogo ON DataHora = Data")
    cursor.execute("SELECT ID from cdp.aposta_normal")
    e = 1
    rowCount = 1
    for row in cursor.fetchall():
        cursor.execute("INSERT INTO cdp.relacionada_com (ID_Aposta, ID_Jogo) VALUES (%d, %d)" % (row.ID, e))
        cursor.commit()
        rowCount = rowCount + 1
        if ((rowCount-1) % 3 == 0):
            e = e + 1
    disconnect(conn)    
          
def associate_apostas_with_casas():
    conn = connect()
    cursor = conn.cursor()
    cursor.execute("SELECT Nome from cdp.casa_de_apostas")
    cdplist = []
    for row in cursor.fetchall():
        cdplist.append(row.Nome)
    print(cdplist)
    cursor.execute("SELECT ID_Aposta from cdp.relacionada_com")
    insertCDP = cdplist[randint(0,2)]
    e = 1
    for row in cursor.fetchall():
        print(insertCDP)
        cursor.execute("INSERT INTO cdp.disponibiliza (Nome_CAP, ID_APOSTA) VALUES ('%s', %d)" % (insertCDP, row.ID_Aposta))
        cursor.commit()
        e = e + 1
        if ((e-1) % 3 == 0):
            insertCDP = cdplist[randint(0,2)]
    disconnect(conn)

        
    

#add_Casas_de_Apostas(3)
#add_apostadores(3)
#add_desportos()
#add_clubes_futebol('data/closing_odds.csv', 1, 8000)
#add_competicao_futebol('data/closing_odds.csv', 1, 8000)
#add_jogos('data/closing_odds.csv', 8000)
#add_apostas()
associate_apostas_with_casas()