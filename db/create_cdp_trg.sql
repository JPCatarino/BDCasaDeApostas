--use SGCasaDEApostas;
--go

use p3g6;
go

-- Trigger para vincular um usuário a uma casa de apostas após este realizar uma aposta, caso ainda não esteja. Insere também o pagamento.
CREATE TRIGGER cdp.addToApostaEmANdPagamento ON cdp.[faz]
AFTER INSERT 
AS
	DECLARE @uCheck INT;
	DECLARE @NomeCAP VARCHAR(255);
	DECLARE @IDApostador INT;
	DECLARE @NIFApostador VARCHAR(9);
	DECLARE @EmailApostador VARCHAR(255);
	DECLARE @IDAposta INT;
	DECLARE @QuantiaAposta MONEY; 

	SELECT @IDApostador = ID_apostador FROM inserted;
	SELECT @NIFApostador = NIF_apostador FROM inserted;
	SELECT @EmailApostador = Email_apostador FROM inserted;
	SELECT @IDAposta = ID_aposta FROM inserted;
	SELECT @NomeCAP = Nome_CAP FROM cdp.disponibiliza WHERE ID_APOSTA = @IDAposta;
	SELECT @uCheck = NIF_apostador FROM cdp.aposta_em JOIN inserted ON NIF_APOST = NIF_apostador AND Nome_CAP = @NomeCAP;
	IF (@uCheck is null)
	BEGIN
		INSERT INTO cdp.aposta_em (Nome_CAP, ID_APOST, NIF_APOST, Email_APOST) VALUES (@NomeCAP, @IDApostador, @NIFApostador, @EmailApostador);
	END;
	SELECT @QuantiaAposta = Quantia FROM inserted; 
	DECLARE @Referencia VARCHAR(50);
	
	SET @Referencia = utils.generateReferencia();
	
	INSERT INTO cdp.pagamento (Referencia, Valor, ID_apostador, Email_apostador, NIF_apostador, pagamento_feito) VALUES (@Referencia, @QuantiaAposta, @IDApostador, @EmailApostador, @NIFApostador, DEFAULT);
GO

-- DROP TRIGGER cdp.addToApostaEmAndPagamento;

--CREATE TRIGGER cdp.deleteGame ON cdp.[jogo]
--AFTER DELETE
--AS
--	DECLARE @DataJogo DATETIME; 

--	SELECT @DataJogo = Data from deleted;
	
--	if GETDATE() < DATEADD(day,30,@DataJogo)
