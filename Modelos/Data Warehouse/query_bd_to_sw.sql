SELECT DISTINCT `idPessoa`, `nomePessoa`
FROM pessoa

SELECT DISTINCT `idPessoa`, cpf
FROM pessoa
WHERE `Pessoa_TIPO`='FISICA'

SELECT DISTINCT `idPessoa`, cnpj
FROM pessoa
WHERE `Pessoa_TIPO`='JURIDICA'

SELECT `idPessoa`,`numCDA`
FROM situacao_devedor

SELECT `numCDA`,`probabilidade_Recuperacao`, `status_Recuperacao`
FROM divida_ativa

SELECT `numCDA`, `datSituacao`,`horaSituacao`,`codFaseCobranca`, `valSaldo`
FROM divida_ativa

SELECT `codSituacao`, `nomeSituacao`, `codSituacaoFiscal`, `codExigibilidade`, tipo
FROM situacao

SELECT *
FROM natureza_da_divida

SELECT DISTINCT* 
FROM (
    SELECT `numCDA`, `anoInscricao`, `datCadastramento`, `idNaturezaDivida`, `codSituacao`
    FROM divida_ativa as d
    WHERE d.`numCDA` IN (
    SELECT DISTINCT `numCDA`
    FROM divida_ativa)
) as cda
WHERE cda.numCDA = '60010101533500'