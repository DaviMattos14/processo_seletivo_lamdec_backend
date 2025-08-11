## Pré-requisitos

Antes de começar, garanta que você tenha os seguintes softwares instalados em sua máquina:
* [Docker](https://www.docker.com/get-started)
* [Docker Compose](https://docs.docker.com/compose/install/) (geralmente já vem incluído com o Docker Desktop).

## Estrutura do Projeto

O projeto está organizado da seguinte forma:

```
Aplicacao
├── data/
│   ├── 001.csv
│   ├── 002.csv
│   ├── 003.csv
│   ├── 004.csv
│   ├── 005.csv
│   ├── 006.csv
│   └── 007.csv
├── connect_bd.py
├── data_warehouse.sql
├── docker-compose.yml
├── Dockerfile
├── dw.py
├── main.py
├── Modelo_Fisico.sql
├── prep.py
└── requirements.txt
```

* **`data/`**: Diretório que deve conter os arquivos CSV com os dados brutos.
* **`Dockerfile`**: Define a imagem Docker para a aplicação Python, instalando todas as dependências necessárias.
* **`docker-compose.yml`**: Orquestra a inicialização e a comunicação entre o contêiner da aplicação e o contêiner do banco de dados MySQL.
* **`main.py`**: Script principal que executa a carga inicial dos dados no banco de dados operacional (`cda`).
* **`dw.py`**: Script que realiza o processo de ETL, migrando e transformando os dados do banco operacional para o Data Warehouse (`dw_cda`).
* **`prep.py`**: Módulo de preparação e transformação dos dados lidos dos arquivos CSV.
* **`connect_bd.py`**: Utilitário para gerenciar a conexão com o banco de dados.
* **`*.sql`**: Arquivos com a estrutura (DDL) do banco de dados operacional e do Data Warehouse.
* **`requirements.txt`**: Lista as bibliotecas Python necessárias para o projeto.

## Como Executar a Aplicação

Siga os passos abaixo para construir e executar o projeto.

### 1. Clone o Repositório

```bash
git clone <url-do-seu-repositorio>
cd <nome-do-repositorio>
```

### 2. Suba os Contêineres

Com o Docker em execução na sua máquina, execute o seguinte comando no terminal, a partir da raiz do projeto:

```bash
docker-compose up --build
```

Você verá os logs de ambos os scripts no terminal, indicando o progresso da criação dos bancos e da inserção dos dados. Ao final, o contêiner da aplicação (`python_dw`) irá parar, mas o do banco de dados (`mysql_dw`) continuará em execução.

### 3. Banco de Dados 

Você pode se conectar ao banco de dados para verificar se as tabelas foram criadas e populadas corretamente.

Use o cliente MySQL de sua preferência com as seguintes credenciais:
* **Host**: `localhost`
* **Porta**: `3306`
* **Usuário**: `root`
* **Senha**: `root`

Você verá dois bancos de dados: `cda` (operacional) e `dw_cda` (Data Warehouse).

### 4. Parando e Removendo os Contêineres

Para parar o contêiner do banco de dados e remover a rede criada pelo Compose, pressione `Ctrl + C` no terminal onde o `docker-compose up` está rodando e depois execute:

```bash
docker-compose down
```

Se desejar remover também o volume de dados do MySQL (para uma execução totalmente limpa da próxima vez), utilize o comando:

```bash
docker-compose down -v
```

## Fluxo de Execução Detalhado

1.  **`docker-compose up`** inicia os serviços definidos em `docker-compose.yml`.
2.  O serviço `mysql` é iniciado primeiro.
3.  O serviço `app` é iniciado e executa o comando `python main.py && python dw.py`.
4.  **`main.py`**:
    * Executa o script `Modelo_Fisico.sql` para criar o schema `cda` e suas tabelas.
    * Usa o `prep.py` para ler, limpar e transformar os dados dos arquivos `.csv`.
    * Insere os dados tratados nas tabelas do banco `cda`.
5.  **`dw.py`**:
    * Executa o script `data_warehouse.sql` para criar o schema `dw_cda` e suas tabelas (Dimensões e Fatos).
    * Conecta-se a ambos os bancos de dados (`cda` e `dw_cda`).
    * Executa queries de extração no `cda` e carrega os dados nas tabelas do `dw_cda`, finalizando o processo de ETL.