CREATE DATABASE cda;
USE cda;

CREATE TABLE Natureza_da_Divida (
    idNaturezaDivida INTEGER PRIMARY KEY,
    nomeNaturezaDivida VARCHAR(255),
    descricao VARCHAR(255)
);

CREATE TABLE Situacao (
    codSituacao INTEGER PRIMARY KEY,
    nomeSituacao VARCHAR(255),
    codSituacaoFiscal INTEGER,
    codExigibilidade INTEGER,
    tipo VARCHAR(255)
);

CREATE TABLE Pessoa_Fisica (
    cpf VARCHAR(255),
    fk_Pessoa_idPessoa INTEGER,
    PRIMARY KEY (cpf, fk_Pessoa_idPessoa)
);

CREATE TABLE Pessoa_Juridica (
    cnpj VARCHAR(255),
    fk_Pessoa_idPessoa INTEGER,
    PRIMARY KEY (cnpj, fk_Pessoa_idPessoa)
);

CREATE TABLE Pessoa (
    idPessoa INTEGER PRIMARY KEY,
    nomePessoa VARCHAR(255)
);

CREATE TABLE Recuperacao_Divida_Ativa (
    probabilidade FLOAT,
    status INTEGER,
    numCDA INTEGER PRIMARY KEY,
    anoInscricao INTEGER,
    valSaldo DECIMAL(10,2),
    datCadastramento DATE,
    fk_Pessoa_idPessoa INTEGER,
    descSituacaoDevedor INTEGER,
    fk_Natureza_da_Divida_idNaturezaDivida INTEGER,
    fk_Situacao_codSituacao INTEGER,
    codFaseCobranca INTEGER,
    datSituacao DATE,
    horaSituacao TIME
);
 
ALTER TABLE Pessoa_Fisica ADD CONSTRAINT FK_Pessoa_Fisica_2
    FOREIGN KEY (fk_Pessoa_idPessoa)
    REFERENCES Pessoa (idPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE Pessoa_Juridica ADD CONSTRAINT FK_Pessoa_Juridica_2
    FOREIGN KEY (fk_Pessoa_idPessoa)
    REFERENCES Pessoa (idPessoa)
    ON DELETE CASCADE;
 
ALTER TABLE Recuperacao_Divida_Ativa ADD CONSTRAINT FK_Recuperacao_Divida_Ativa_2
    FOREIGN KEY (fk_Pessoa_idPessoa)
    REFERENCES Pessoa (idPessoa);
 
ALTER TABLE Recuperacao_Divida_Ativa ADD CONSTRAINT FK_Recuperacao_Divida_Ativa_3
    FOREIGN KEY (fk_Natureza_da_Divida_idNaturezaDivida)
    REFERENCES Natureza_da_Divida (idNaturezaDivida);
 
ALTER TABLE Recuperacao_Divida_Ativa ADD CONSTRAINT FK_Recuperacao_Divida_Ativa_4
    FOREIGN KEY (fk_Situacao_codSituacao)
    REFERENCES Situacao (codSituacao);