import connect_bd as bd
import pandas as pd
from IPython.display import display


'''
TABELAS DE PESSOAS, FISICAS E JURIDICAS
'''
pFisica = r"data\006.csv"
pJuridica = r"data\007.csv"
df_PFisica = pd.read_csv(pFisica, sep=',')
df_PJuridica = pd.read_csv(pJuridica, sep=',')

df_PFisica['Pessoa_TIPO'] = 'FISICA'
df_PJuridica['Pessoa_TIPO'] = "JURIDICA"

df_TPessoa = pd.concat([df_PFisica,df_PJuridica]).drop_duplicates(keep='first')
df_TPessoa.rename(columns={"idpessoa":"idPessoa","descNome": "nomePessoa", "numcpf":"cpf","numCNPJ":"cnpj"}, inplace=True)

"""
 TABELA DE SITUAÇÃO
"""
situacao = r'data\003.csv'

df_Tsituacao = pd.read_csv(situacao, sep=',')

df_Tsituacao.rename(columns={"codSituacaoCDA":"codSituacao", "nomSituacaoCDA":"nomeSituacao", "codSituacaoFiscal":"codSituacaoFiscal", "codFaseCobranca":"codFaseCobranca", "tipoSituacao":"tipo"}, inplace=True)
df_Tsituacao = df_Tsituacao.drop(columns=['codFaseCobranca'])

"""
TABELA NATUREZA DA DIVIDA
"""
naturezaDivida = r'data\002.csv'

df_TnatDivida = pd.read_csv(naturezaDivida, sep=',').drop_duplicates(subset=['nomnaturezadivida'], keep='first')
df_TnatDivida.rename(columns={"idNaturezadivida":"idNaturezaDivida", "nomnaturezadivida":"nomeNaturezaDivida", "descnaturezadivida":"descricao"}, inplace=True)


"""
TABELA CDA
"""
recuperacao = r'data\004.csv'
df_recp = pd.read_csv(recuperacao,sep=',')

cda = r'data\001.csv'
df_cda = pd.read_csv(cda,sep=',')

df_cda['DatSituacao'] = pd.to_datetime(df_cda['DatSituacao'])
df_cda['datSituacao'] = df_cda['DatSituacao'].dt.date
df_cda['horaSituacao'] = df_cda['DatSituacao'].dt.time
df_cda['datCadastramento'] = pd.to_datetime(df_cda['datCadastramento']).dt.date

df_cda = df_cda.sort_values(by=['numCDA', 'ValSaldo'], ascending=[True, False])
df_recp = df_recp.sort_values(by=['numCDA', 'probRecuperacao'], ascending=[True, True])

df_cda['rank'] = df_cda.groupby('numCDA').cumcount()
df_recp['rank'] = df_recp.groupby('numCDA').cumcount()

df_Tcda = pd.merge(
    df_cda,
    df_recp,
    on=['numCDA', 'rank'],
    how='outer'
)

df_Tcda.drop(columns=['rank','DatSituacao'], inplace=True)
df_Tcda.rename(columns={
    "codSituacaoCDA":"codSituacao",
    "ValSaldo":"valSaldo",
    "probRecuperacao": "probabilidade_Recuperacao",
    "stsRecuperacao": "status_Recuperacao",
}, inplace=True)



df_Tcda['idNaturezaDivida'] = df_Tcda['idNaturezaDivida'].replace({
    3: 1,
    5: 1,
    8: 1,
    4: 2,
    6: 2,
    9: 2,
    64: 62,
    65: 62,
    66: 62,
    69: 62,
})


"""
TABELA SITUAÇÃO DEVEDOR
"""

situacaoDevedor = r'data\005.csv'
df_situDev = pd.read_csv(situacaoDevedor,sep=',')
print(df_Tcda[df_Tcda.duplicated(subset=['numCDA'])])

df_situDev.rename(columns={
    "descsituacaodevedor": "descSituacaoDevedor"
}, inplace=True)

df_Tsituacaodevedor = df_situDev.copy()
ids_validos_pessoa = df_TPessoa['idPessoa'].unique()
df_Tsituacaodevedor.loc[~df_Tsituacaodevedor['idPessoa'].isin(ids_validos_pessoa), 'idPessoa'] = -1
df_Tsituacaodevedor = df_Tsituacaodevedor.drop_duplicates(keep='first')

