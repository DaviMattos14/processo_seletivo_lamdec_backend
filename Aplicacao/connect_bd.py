from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import pandas as pd
import os

def connect_mysql(bd_name, user, password):
    """
    Função para conectar ao banco de dados MySQL usando SQLAlchemy.
    """
    engine = None
    try:
        usuario = user
        senha = password
        host = os.getenv("DB_HOST", "localhost")
        porta = '3306'
        banco = bd_name

        # Criação da engine de conexão
        engine = create_engine(f'mysql+pymysql://{usuario}:{senha}@{host}:{porta}/{banco}')
        
        # Testar a conexão abrindo uma conexão real
        with engine.connect() as conn:
            print("Conexão com o MySQL via SQLAlchemy bem-sucedida!")

    except SQLAlchemyError as e:
        print(f"Erro ao conectar com o MySQL via SQLAlchemy: {e}")
    
    return engine

def execute_query(engine, query: str):
    """
    Executa uma query de escrita (INSERT, UPDATE, DELETE, DDL) usando SQLAlchemy.
    """
    try:
        with engine.begin() as conn: 
            conn.execute(text(query))
            print("Query executada com sucesso!")
    except SQLAlchemyError as e:
        print(f"Erro ao executar a query: {e}")

def read_query(engine, query):
    """
    Função para executar uma query SELECT usando SQLAlchemy e retornar um DataFrame.
    """
    try:
        # Lê a query diretamente como DataFrame
        df = pd.read_sql(query, con=engine)
        return df
    except SQLAlchemyError as err:
        print(f"Erro ao executar a query: {err}")
        return None
    
def create_database(filepath, user, password):
    usuario = user
    senha = password
    host = 'localhost'
    porta = '3306'
    engine = create_engine(f'mysql+pymysql://{usuario}:{senha}@{host}:{porta}')
    
    with open(filepath, 'r') as file:
        command = file.read().strip().split(';')
        for linha in command:
            execute_query(engine,linha)
    print("Sucesso")