#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | ALTPESO    | Data   | 01/07/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para para alterar peso do pedido de venda                   |
//+------------+------------+--------+--------------------------------------------+

User Function ALTPESO()

	
	Local oGroup1
	Local oSay1	
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6	
	Local Sair
	
	Private oDlg
	private oPedido
	Private oData		
	private oBruto
	private oLiquido		
	private oVolume
	private oEspecie	
	private oFrete	
	
	private cpedido := space(6)	
	Private dData 	:= stod("") 
	private nBruto 	:= 0
	private nLiquido:= 0	
	private nVolume := space(3)		
	private cEspecie:= space(10)	
	private nFrete 	:= space(1)
	Private Alterar

	DEFINE MSDIALOG oDlg TITLE "Alterar dados do pedido de venda" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

//DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay1 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oPedido VAR cpedido SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL	Valid U_ALTPESO1() ==.T.

	@ 014, 105 SAY oSay3 PROMPT "Emissao:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 133 MSGET oData VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

	@ 025, 010 GROUP oGroup1 TO 080, 220 OF oDlg COLOR 0, 16777215 PIXEL
	@ 035, 015 SAY oSay2 PROMPT "Bruto:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 038 MSGET oBruto VAR nBruto SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.999'	
	
	@ 035, 105 SAY oSay3 PROMPT "Liquido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 133 MSGET oLiquido VAR nLiquido SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.999'

	@ 050, 015 SAY oSay4 PROMPT "Volume:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 038 MSGET oVolume VAR nVolume SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.999'

	@ 050, 105 SAY oSay5 PROMPT "Especie:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 133 MSGET oEspecie VAR cEspecie SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 

	@ 065, 015 SAY oSay6 PROMPT "Frete:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 038 MSGET oFrete VAR nFrete SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL 	

	@ 100, 015 BUTTON Alterar PROMPT "Alterar" SIZE 050, 024 OF oDlg PIXEL Action U_ALTPESO2()
	@ 100, 165 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return
//=================================================================================
//
//================================================================================= 
User Function ALTPESO1()

	if Empty(cpedido)		
		Return(.T.)
	endif

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGoTop()	

	if (dbSeek("01"+cpedido))	
		dData	  := SC5->C5_EMISSAO
		nBruto    := SC5->C5_PBRUTO
		nLiquido  := SC5->C5_PESOL
		nVolume   := SC5->C5_VOLUME1
		cEspecie  := SC5->C5_ESPECI1
		nFrete    := SC5->C5_TPFRETE				
		else
		MsgAlert("Pedido não encontrado!","Atenção !!!")
		lStatus := .F.
		Return(.F.)
	endif	

Return (.T.)
//===================================================================================================
// BOTAO ALTERAR
//===================================================================================================
User Function ALTPESO2()

	Local nOpcao	  := 0

	if Empty(cpedido)
		MsgInfo("Digite o número da Pedido.")
		Return(.F.)
	endif	

	nOpcao := Aviso("Confirmar","Confirma alterações no pedido de venda?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SC5")

		Reclock("SC5", .F.) 
		SC5->C5_PBRUTO  := nBruto
		SC5->C5_PESOL	:= nLiquido
		SC5->C5_VOLUME1	:= nVolume
		SC5->C5_ESPECI1	:= cEspecie
		SC5->C5_TPFRETE := nFrete
		MsUnlock()

		Msginfo("Alterações, gravada com sucesso!")

	endif

	oDLG:End()

	U_ALTPESO()

Return
