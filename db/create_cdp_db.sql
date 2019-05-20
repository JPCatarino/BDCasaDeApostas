CREATE DATABASE SGCasaDeApostas;

GO
use SGCasaDeApostas;
EXEC('CREATE SCHEMA cdp;');

GO
CREATE TABLE cdp.casa_de_apostas(
	Nome		VARCHAR(255),
	Email		VARCHAR(255) NOT NULL,
	Telefone	VARCHAR(20),
	Site		VARCHAR(2083) NOT NULL,
	PRIMARY KEY (Nome),
	UNIQUE		(Email, Telefone, Site)
);

CREATE TABLE cdp.apostador(
	ID				INT			IDENTITY(1,1),
	Email			VARCHAR(255) UNIQUE,
	NIF				VARCHAR(9),
	Primeiro_Nome	VARCHAR(20)	NOT NULL,
	Ultimo_Nome		VARCHAR(20)	NOT NULL,
	Telemovel		VARCHAR(9)  NOT NULL,
	Equipa_Favorita	VARCHAR(50),
	PRIMARY KEY(ID,Email, NIF)
);

CREATE TABLE cdp.aposta_normal(
	ID				INT				IDENTITY(1,1),
	Descricao		VARCHAR(50)		NOT NULL,
	Odds			DECIMAL(4,2)	NOT NULL,
	DataHora		DATETIME		NOT NULL,
	PRIMARY KEY(ID)	
);

CREATE TABLE cdp.aposta_multipla(
	ID				INT				IDENTITY(1,1),
	Combinacoes		VARCHAR(100),
	Descricao		VARCHAR(50)		NOT NULL,
	Odds			DECIMAL(4,2)	NOT NULL,
	DataHora		DATETIME		NOT NULL,
	PRIMARY KEY(ID,Combinacoes)	
);

CREATE TABLE cdp.pagamento(
	Referencia		VARCHAR(50),
	Valor			MONEY		 NOT NULL,
	ID_apostador	INT			 NOT NULL,
	Email_apostador	VARCHAR(255) NOT NULL,
	NIF_apostador	VARCHAR(9)	 NOT NULL,
	Metodo			VARCHAR(40)	CHECK (Metodo in ('MBWay', 'Cartão de Crédito', 'PayPal'))	NOT NULL,  -- Deve ser mudado para métodos de pagamento pré definidos.
	PRIMARY KEY(Referencia,NIF_apostador),
	CONSTRAINT FK_DADOS_AP_PAGAMENTO FOREIGN KEY(ID_apostador, Email_apostador, NIF_apostador) REFERENCES cdp.apostador(ID, Email, NIF)
);

CREATE TABLE cdp.desporto(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(255)	NOT NULL,
	PRIMARY KEY(ID),
	UNIQUE(Nome)
);

CREATE TABLE cdp.competicao(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(255)	NOT NULL,	
	Pais			VARCHAR(255)	NOT NULL,
	Data_Inicio		DATE			NOT NULL,
	Data_Fim		DATE			NOT NULL,
	ID_Desporto		INT				NOT NULL,
	PRIMARY KEY(ID),
	CONSTRAINT FK_DESPORTO_COMP FOREIGN KEY(ID_Desporto) REFERENCES cdp.desporto(ID)
);

CREATE TABLE cdp.equipa(
	ID				INT				IDENTITY(1,1),
	Nome			VARCHAR(50)		NOT NULL,
	ID_desporto		INT				NOT NULL,
	PRIMARY KEY(ID),
	CONSTRAINT FK_DESPORTO_PRAT	FOREIGN KEY(ID_desporto) REFERENCES	cdp.desporto(ID)
);

CREATE TABLE cdp.jogador(
	Nome			VARCHAR(20),
	Posicao			VARCHAR(30) CHECK (Posicao in ('Goalkeeper','Defender', 'Midfielder', 'Forward')),
	Equipa_Atual	INT,
	CONSTRAINT FK_JOGADOR_EQUIPA	FOREIGN KEY(Equipa_Atual) REFERENCES cdp.equipa(ID)
);

CREATE TABLE cdp.jogo(
	ID				INT				IDENTITY(1,1),
	Data			DATETIME		NOT NULL,
	ID_casa			INT				NOT NULL,
	ID_fora			INT				NOT NULL,
	ID_competicao	INT				NOT NULL,
	PRIMARY KEY(ID),
	CONSTRAINT	FK_EQUIPA_CASA FOREIGN KEY(ID_casa) REFERENCES cdp.equipa(ID),
	CONSTRAINT	FK_EQUIPA_FORA FOREIGN KEY(ID_fora) REFERENCES cdp.equipa(ID),
	CONSTRAINT	FK_COMPETICAO  FOREIGN KEY(ID_competicao) REFERENCES cdp.competicao(ID)
);

CREATE TABLE cdp.faz(
	ID_apostador	INT				NOT NULL,
	Email_apostador	VARCHAR(255)	NOT NULL,
	NIF_apostador	VARCHAR(9)		NOT NULL,
	ID_aposta		INT				NOT NULL,
	Combinacoes_amultipla	VARCHAR(100),
	Quantia			MONEY			NOT NULL,
	-- Escolhas		DISCUTIR COMO REPRESENTAR
	DataHora		DATETIME		NOT NULL,
	PRIMARY KEY(ID_apostador, Email_apostador, NIF_apostador, ID_aposta),
	CONSTRAINT	FK_APOSTADOR_FAZ_DADOS	FOREIGN KEY(ID_apostador, Email_apostador, NIF_apostador) REFERENCES cdp.apostador(ID, Email, NIF), 
	CONSTRAINT	FK_FAZ_APOSTA_ID		FOREIGN KEY(ID_aposta)	REFERENCES	cdp.aposta_normal(ID),
	CONSTRAINT	FK_FAZ_APOSTA_IDM		FOREIGN KEY(ID_aposta, Combinacoes_amultipla)	REFERENCES	cdp.aposta_multipla(ID, Combinacoes)
);

CREATE TABLE cdp.aposta_em(
	Nome_CAP	VARCHAR(255),
	ID_APOST	INT,
	NIF_APOST	VARCHAR(9),
	Email_APOST	VARCHAR(255),
	PRIMARY KEY(Nome_CAP, ID_APOST,	NIF_APOST),
	CONSTRAINT	FK_APOSTA_EM_DADOS_APOST	FOREIGN KEY(ID_APOST, Email_APOST, NIF_APOST) REFERENCES cdp.apostador(ID, Email, NIF),
	CONSTRAINT	FK_APOSTA_EM_CAP			FOREIGN KEY(Nome_CAP) REFERENCES cdp.casa_de_apostas(Nome)
);

CREATE TABLE cdp.disponibiliza(
	Nome_CAP	VARCHAR(255),
	ID_APOSTA	INT	NOT NULL,
	Combinacoes_APOSTA	VARCHAR(100),
	PRIMARY KEY(Nome_CAP, ID_APOSTA),
	CONSTRAINT	FK_DISPONIBILIZA_CAP		FOREIGN KEY(Nome_CAP) REFERENCES cdp.casa_de_apostas(Nome),
	CONSTRAINT	FK_DISPONIBILIZA_APN		FOREIGN KEY(ID_APOSTA) REFERENCES cdp.aposta_normal(ID),
	CONSTRAINT	FK_DISPONIBILIZA_APM		FOREIGN KEY(ID_APOSTA, Combinacoes_APOSTA) REFERENCES cdp.aposta_multipla(ID, Combinacoes),
);

CREATE TABLE cdp.relacionada_com(
	ID_Aposta	INT NOT NULL,
	Combinacoes_aposta VARCHAR(100),
	ID_Jogo		INT	NOT NULL,
	PRIMARY KEY(ID_Aposta, ID_Jogo),
	CONSTRAINT	FK_JOGO_APOSTAN		FOREIGN KEY(ID_Aposta) REFERENCES cdp.aposta_normal(ID),
	CONSTRAINT	FK_JOGO_APOSTAM		FOREIGN KEY(ID_Aposta, Combinacoes_aposta) REFERENCES cdp.aposta_multipla(ID, Combinacoes),
	CONSTRAINT	FK_JOGO_JOGO		FOREIGN KEY(ID_Jogo)	REFERENCES	cdp.jogo(ID)
);