DROP DATABASE cda;
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

CREATE TABLE Divida_Ativa (
    numCDA VARCHAR(16),
    anoInscricao INTEGER,
    valSaldo DECIMAL(18, 2),
    datCadastramento DATE,
    idNaturezaDivida INTEGER,
    codSituacao INTEGER,
    datSituacao DATE,
    horaSituacao TIME,
    codFaseCobranca INTEGER,
    probabilidade_Recuperacao FLOAT,
    status_Recuperacao INTEGER,
    CONSTRAINT PK_Divida_Ativa PRIMARY KEY (numCDA, datSituacao, horaSituacao),
    CONSTRAINT FK_Divida_Natureza FOREIGN KEY (idNaturezaDivida)
        REFERENCES Natureza_da_Divida (idNaturezaDivida)
        ON DELETE RESTRICT,
    CONSTRAINT FK_Divida_Situacao FOREIGN KEY (codSituacao)
        REFERENCES Situacao (codSituacao)
        ON DELETE RESTRICT
);

CREATE TABLE Pessoa (
    idPessoa INTEGER PRIMARY KEY,
    nomePessoa VARCHAR(255),
    cnpj VARCHAR(14), 
    cpf VARCHAR(11) UNIQUE,  
    Pessoa_TIPO VARCHAR(255)  
);


CREATE TABLE Situacao_Devedor (
    idPessoa INTEGER,
    numCDA VARCHAR(16),
    descSituacaoDevedor VARCHAR(255),
    CONSTRAINT PK_Situacao_Devedor PRIMARY KEY (numCDA, descSituacaoDevedor, idPessoa), 
    CONSTRAINT FK_Situacao_Pessoa FOREIGN KEY (idPessoa)
        REFERENCES Pessoa (idPessoa)
        ON DELETE CASCADE,
    CONSTRAINT FK_Situacao_Divida FOREIGN KEY (numCDA)
        REFERENCES Divida_Ativa (numCDA)
        ON DELETE CASCADE
);

INSERT INTO Pessoa (idpessoa, nomePessoa, Pessoa_TIPO)
VALUES (-1, 'Pessoa Nao Identificada', 'DESCONHECIDO');