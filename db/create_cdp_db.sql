CREATE DATABASE SGCasaDeApostas;

GO
use SGCasaDeApostas;
EXEC('CREATE SCHEMA cdp;');

GO
CREATE TABLE cdp.casa_de_apostas(
	Nome		VARCHAR(20),
	Email		VARCHAR(255) NOT NULL,
	Telefone	VARCHAR(9),
	Site		VARCHAR(2083) NOT NULL,
	PRIMARY KEY (Nome),
	UNIQUE		(Email, Telefone, Site)
);

CREATE TABLE cdp.apostador(
	ID				INT			IDENTITY(1,1),
	Email			VARCHAR(255),
	NIF				VARCHAR(9),
	Primeiro_Nome	VARCHAR(20)	NOT NULL,
	Ultimo_Nome		VARCHAR(20)	NOT NULL,
	Telemovel		VARCHAR(9)  NOT NULL,
	Equipa_Favorita	VARCHAR(50),
	PRIMARY KEY(ID, Email, NIF)
);

CREATE TABLE cdp.pagamento(
	Referencia		VARCHAR(50),
	Valor			MONEY		NOT NULL,
	PRIMARY KEY(Referencia)
);

CREATE TABLE cdp.aposta(
	ID				INT				IDENTITY(1,1),
	Descricao		VARCHAR(50)		NOT NULL,
	Odds			DECIMAL(4,2)	NOT NULL,
	DataHora		DATETIME		NOT NULL,
	PRIMARY KEY(ID)	
);

CREATE TABLE cdp.jogo(
	ID				INT				IDENTITY(1,1),
	Data			DATETIME		NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE cdp.equipa(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(50)		NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE cdp.jogador(
	Nome			VARCHAR(20),
	Posicao			VARCHAR(30) CHECK (Posicao in ('Goalkeeper','Defender', 'Midfielder', 'Forward')),
	Equipa_Atual	VARCHAR(50)		NOT NULL,
);

CREATE TABLE cdp.competicao(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(255)	NOT NULL,	
	Pais			VARCHAR(255)	NOT NULL,
	Data_Inicio		DATETIME		NOT NULL,
	Data_Fim		DATETIME		NOT NULL,
	PRIMARY KEY(ID)	
);

CREATE TABLE cdp.desporto(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(255)	NOT NULL,
	PRIMARY KEY(ID)
);
