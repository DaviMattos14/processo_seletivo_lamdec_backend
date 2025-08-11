import connect_bd as bd
import pandas as pd

user = 'root'
password = '1310223a8'

bd.create_database(r'D:\REPOSITÓRIOS\Desafio-LAMDEC\data_warehouse.sql',user, password)

conn_BD = bd.connect_mysql('cda',user, password)
conn_DW = bd.connect_mysql('dw_cda', user, password)

dim_pessoa = bd.read_query(conn_BD,"SELECT DISTINCT idPessoa, nomePessoa FROM pessoa")
dim_pessoa.to_sql(
    name = "dim_pessoa",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 1/9")

dim_pcpf = bd.read_query(conn_BD,
"""
SELECT DISTINCT idPessoa, cpf
FROM pessoa
WHERE Pessoa_TIPO='FISICA'
"""
)
dim_pcpf.to_sql(
    name = "dim_pessoa_cpf",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 2/9")


dim_pcnpj = bd.read_query(conn_BD,
"""
SELECT DISTINCT idPessoa, cnpj
FROM pessoa
WHERE Pessoa_TIPO='JURIDICA'
    """                          
)
dim_pcnpj.to_sql(
    name = "dim_pessoa_cnpj",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 3/9")

dim_natureza_divida = bd.read_query(conn_BD, """SELECT * FROM natureza_da_divida""")
dim_natureza_divida.to_sql(
    name = "dim_natureza_divida",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 4/9")

dim_situacao = bd.read_query(conn_BD, """ 
SELECT codSituacao, nomeSituacao, codSituacaoFiscal, codExigibilidade, tipo
FROM situacao """)
dim_situacao.to_sql(
    name = "dim_situacao",
    con=conn_DW,
    if_exists='append',
    index=False
)

print("OK 5/9")

fato_cda = bd.read_query(conn_BD,
""" 
SELECT DISTINCT* 
FROM (
    SELECT numCDA, anoInscricao, datCadastramento, idNaturezaDivida, codSituacao
    FROM divida_ativa as d
    WHERE d.numCDA IN (
    SELECT DISTINCT numCDA
    FROM divida_ativa)
) as cda """)
fato_cda.to_sql(
    name = "fato_cda",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 6/9")

dim_situacao_devedor = bd.read_query(conn_BD, "SELECT idPessoa,numCDA FROM situacao_devedor")
dim_situacao_devedor.to_sql(
    name = "dim_pessoa_has_fato_cda",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 7/9")


dim_recuperacao = bd.read_query(conn_BD, """ SELECT numCDA,probabilidade_Recuperacao, status_Recuperacao
FROM divida_ativa
 """)
dim_recuperacao.to_sql(
    name = "dim_recuperacao",
    con=conn_DW,
    if_exists='append',
    index=True
)
print("OK 8/9")

dim_cadastramento = bd.read_query(conn_BD, """ SELECT numCDA, datSituacao,horaSituacao,codFaseCobranca, valSaldo
FROM divida_ativa """)
dim_situacao_devedor.to_sql(
    name = "dim_ca",
    con=conn_DW,
    if_exists='append',
    index=False
)
print("OK 9/9")