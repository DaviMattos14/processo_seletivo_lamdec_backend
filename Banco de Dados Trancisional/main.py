import prep as p
import connect_bd as bd
import pandas as pd


def main():
    user = 'root'
    password = '1310223a8'
    database = 'cda'
    bd.create_database(r'D:\REPOSITÓRIOS\Desafio-LAMDEC\Modelos\Modelo_Fisico.sql',user,password)
    
    conn = bd.connect_mysql(database, user, password)
    print("\nIniciando inserção de novos dados...")
    p.df_TPessoa.to_sql(
        name="pessoa",
        con=conn,
        if_exists="append",
        index=False
    )
    print("\nOK 1/5\n")
    
    p.df_Tsituacao.to_sql(
        name="situacao",
        con=conn,
        if_exists="append",
        index=False
    )
    print("\nOK 2/5\n")
    
    p.df_TnatDivida.to_sql(
        name="natureza_da_divida",
        con=conn,
        if_exists="append",
        index=False
    )  
    print("\nOK 3/5\n")
    
    p.df_Tcda.to_sql(
        name="divida_ativa",
        con=conn,
        if_exists="append",
        index=False
    )
    print("\nOK 4/5\n")
    
    p.df_Tsituacaodevedor.to_sql(
        name="situacao_devedor",
        con=conn,
        if_exists="append",
        index=False
    )
    print("\nOK 5/5\n")

if __name__ == '__main__':
    main()