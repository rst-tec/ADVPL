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
	private oLiquido
	private oBruto	
	private oVolume
	private oEspecie	
	private oFrete	
	
	private cpedido := space(6)	
	private nLiquido:= space(1)	
	private nBruto 	:= space(1)		
	private nVolume := space(1)		
	private cEspecie:= space(1)	
	private nFrete 	:= space(1)
	Private Baixar

	DEFINE MSDIALOG oDlg TITLE "Alterar peso pedido" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

//DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay1 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oPedido VAR cpedido SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL	Valid U_ALTPESO1() ==.T.

	@ 025, 010 GROUP oGroup1 TO 080, 220 OF oDlg COLOR 0, 16777215 PIXEL
	@ 035, 015 SAY oSay2 PROMPT "Liquido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 038 MSGET oLiquido VAR nLiquido SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 
	
	@ 035, 105 SAY oSay3 PROMPT "Bruto:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 133 MSGET oBruto VAR nBruto SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 

	@ 050, 015 SAY oSay4 PROMPT "Volume:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 038 MSGET oVolume VAR nVolume SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 

	@ 050, 105 SAY oSay5 PROMPT "Especie:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 133 MSGET oEspecie VAR cEspecie SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 

	@ 065, 015 SAY oSay6 PROMPT "Frete:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 038 MSGET oFrete VAR nFrete SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 	

	@ 120, 015 BUTTON Baixar PROMPT "Alterar" SIZE 050, 024 OF oDlg PIXEL Action U_LAVAR2()
	@ 120, 165 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return
//=================================================================================
//
//================================================================================= 
User Function ALTPESO1()

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGoTop()

	if (dbSeek("01"+cpedido))	
		cpedido   := SC5->C5_NUM
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

	/*
   if SC5->Z1_PREFIXA = "S" 
		MsgInfo("Atenção !!! Peça já foi lavada dia " + DtoC(SC5->Z1_DTPREFI)) 
		Return(.F.)
	endif
   */

   if SC5->Z1_LAVADO = "S" 
		MsgInfo("Atenção !!! Peça já foi lavada dia " + DtoC(SC5->Z1_DTLAVAD))
		Return(.F.)
	endif

	

Return (.T.)
//===================================================================================================
// BOTAO BAIXAR
//===================================================================================================
User Function ALTPESO2()

	Local lMsErroAuto := .F.
	Local cMoviint    := {}
	Local cTextAviso  := ""
	Local nRet        := 0
	Local cProduto    := ""
	Local nOpcao	  := 0

	if Empty(cNumPeca)
		MsgInfo("Digite o número da Peça.")
		Return(.F.)
	endif

	if Empty(dData)
		MsgInfo("Digite a data que o tecido foi lavado!")
		Return(.F.)
	endif

	nOpcao := Aviso("Confirmar","Confirma tecido lavado?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SC5")

		Reclock("SC5", .F.)
		//SC5->Z1_PREFIXA	:= "S"     // ALTERAR PARA O CAMPO DE DATA NOVO
		//SC5->Z1_DTPREFI	:= dData   // ALTERAR PARA O CAMPO DE DATA NOVO

      	SC5->Z1_LAVADO	:= "S"     
		SC5->Z1_DTLAVAD	:= dData   
		MsUnlock()

		Msginfo("Informação de tecido lavado, gravada com sucesso!")

	endif

	oDLG:End()

	U_ALTPESO()

Return
