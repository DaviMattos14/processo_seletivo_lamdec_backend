-- -----------------------------------------------------
-- Schema dw_cda
-- -----------------------------------------------------
DROP DATABASE IF EXISTS dw_cda;
CREATE DATABASE IF NOT EXISTS dw_cda;
USE dw_cda ;

-- -----------------------------------------------------
-- Table dw_cda.DIM_pessoa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_pessoa (
  idPessoa INTEGER PRIMARY KEY,
  nomePessoa VARCHAR(45)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_pessoa_cpf
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_pessoa_cpf (
  cpf VARCHAR(11),
  idPessoa INTEGER PRIMARY KEY,
  CONSTRAINT fk_DIM_pessoa_cpf_DIM_pessoa
    FOREIGN KEY (idPessoa)
    REFERENCES dw_cda.DIM_pessoa (idPessoa)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_pessoa_cnpj
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_pessoa_cnpj (
  cnpj VARCHAR(14),
  idPessoa INTEGER PRIMARY KEY,
  CONSTRAINT fk_DIM_pessoa_cnpj_DIM_pessoa1
    FOREIGN KEY (idPessoa)
    REFERENCES dw_cda.DIM_pessoa (idPessoa)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_natureza_divida
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_natureza_divida (
  idNaturezaDivida INTEGER PRIMARY KEY,
  nomeNaturezaDivida VARCHAR(255),
  descricao VARCHAR(255)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_situacao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_situacao (
  codSituacao INTEGER PRIMARY KEY,
  nomeSituacao VARCHAR(255) ,
  codSituacaoFiscal INTEGER ,
  codExigibilidade INTEGER ,
  tipo VARCHAR(255) 
);


-- -----------------------------------------------------
-- Table dw_cda.FATO_cda
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.FATO_cda (
  numCDA VARCHAR(16),
  anoInscricao INTEGER,
  datCadastramento DATE,
  idNaturezaDivida INTEGER ,
  codSituacao INTEGER,
  CONSTRAINT PK_FATO_cda PRIMARY KEY (numCDA, datCadastramento)
  CONSTRAINT fk_FATO_cda_DIM_natureza_divida1
    FOREIGN KEY (idNaturezaDivida)
    REFERENCES dw_cda.DIM_natureza_divida (idNaturezaDivida),
  CONSTRAINT fk_FATO_cda_DIM_situacao1
    FOREIGN KEY (codSituacao)
    REFERENCES dw_cda.DIM_situacao (codSituacao)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_recuperacao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_recuperacao (
  idDIM_recuperacao INTEGER ,
  probabilidade_Recuperacao FLOAT ,
  status_Recuperacao INTEGER ,
  FATO_cda_numCDA VARCHAR(16),
  PRIMARY KEY (idDIM_recuperacao),
  INDEX fk_DIM_recuperacao_FATO_cda1_idx (FATO_cda_numCDA ASC) VISIBLE,
  CONSTRAINT fk_DIM_recuperacao_FATO_cda1
    FOREIGN KEY (FATO_cda_numCDA)
    REFERENCES dw_cda.FATO_cda (numCDA)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_cadastramento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_cadastramento (
  datSituacao DATE ,
  horaSituacao TIME ,
  codFaseCobranca INTEGER NULL,
  FATO_cda_numCDA VARCHAR(16),
  valSaldo DECIMAL(18,2),
  PRIMARY KEY (datSituacao, horaSituacao),
  CONSTRAINT fk_DIM_cadastramento_FATO_cda1
    FOREIGN KEY (FATO_cda_numCDA)
    REFERENCES dw_cda.FATO_cda (numCDA)
);


-- -----------------------------------------------------
-- Table dw_cda.DIM_pessoa_has_FATO_cda
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_cda.DIM_pessoa_has_FATO_cda (
  DIM_pessoa_idpessoa INTEGER,
  FATO_cda_numCDA VARCHAR(16),
  PRIMARY KEY (DIM_pessoa_idpessoa, FATO_cda_numCDA),
  CONSTRAINT fk_DIM_pessoa_has_FATO_cda_DIM_pessoa1
    FOREIGN KEY (DIM_pessoa_idpessoa)
    REFERENCES dw_cda.DIM_pessoa (idPessoa),
  CONSTRAINT fk_DIM_pessoa_has_FATO_cda_FATO_cda1
    FOREIGN KEY (FATO_cda_numCDA)
    REFERENCES dw_cda.FATO_cda (numCDA)
);
