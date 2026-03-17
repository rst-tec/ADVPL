#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | ALTDT      | Data   | 23/07/2024                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para alterar data de entrega pedido - C5_SUGENT e C6_ENTREG |
//+------------+------------+--------+--------------------------------------------+

User Function ALTDT()

	Local oGroup1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSay10
	Local Sair

	Private oDlg
	private oPedido
	Private oData
	private oNome
	private oDtEnt

	private cPedido := SC5->C5_NUM
	Private dData 	:= SC5->C5_EMISSAO
	private cNome	:= SC5->C5_XNOMCLI
	Private dDtEnt 	:= SC5->C5_SUGENT
	Private cnota   := SC5->C5_NOTA

	Private Alterar

	if !Empty(cnota)
		MsgAlert("Pedido já tem nota gerada não pode ser alterado","Atenção !!!")
		lStatus := .F.
		Return(.F.)
	endif

	DEFINE MSDIALOG oDlg TITLE "Alterar data de entrega do pedido de venda" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay1 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oPedido VAR cPedido SIZE 060, 010 F3 "SC5" OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.	Valid U_ALTDT1() ==.T.

	@ 014, 105 SAY oSay3 PROMPT "Emissao:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 133 MSGET oData VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

	@ 029, 015 SAY oSay8 PROMPT "Cliente:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 039 MSGET oNome VAR cNome SIZE 155, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

//	@ 025, 010 GROUP oGroup1 TO 110, 220 OF oDlg COLOR 0, 16777215 PIXEL

	@ 044, 015 SAY oSay2 PROMPT "Entrega:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 039 MSGET oDtEnt VAR dDtEnt SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	/*
	@ 044, 105 SAY oSay3 PROMPT "Bruto:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 133 MSGET oLiquido VAR nBruto SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '9999.999'

	@ 059, 015 SAY oSay4 PROMPT "Volume:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 039 MSGET oVolume VAR nVolume SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.999'

	@ 059, 105 SAY oSay5 PROMPT "Especie:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 133 MSGET oEspecie VAR cEspecie SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 074, 015 SAY oSay6 PROMPT "Frete:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 039 MSGET oFrete VAR nFrete SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 074, 105 SAY oSay7 PROMPT "Transp.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 133 MSGET oTransp VAR cTransp SIZE 060, 010 F3 "SA4"  OF oDlg COLORS 0, 16777215 PIXEL	

	@ 089, 015 SAY oSay9 PROMPT "Mens.1:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 085, 039 MSGET oMen1 VAR cMen1 SIZE 155, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 104, 015 SAY oSay10 PROMPT "Mens.2:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 100, 039 MSGET oMen2 VAR cMen2 SIZE 155, 010 OF oDlg COLORS 0, 16777215 PIXEL
	*/

	@ 120, 015 BUTTON Alterar PROMPT "Alterar" SIZE 050, 024 OF oDlg PIXEL Action U_ALTDT2()
	@ 120, 165 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return
//=================================================================================
//
//================================================================================= 
User Function ALTDT1()

	if Empty(cPedido)
		Return(.T.)
	endif

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGoTop()

	if (dbSeek(xFilial("SC5")+cPedido))
		dData	  := SC5->C5_EMISSAO
		cNome	  := SC5->C5_XNOMCLI
		dDtEnt    := SC5->C5_SUGENT
		cnota     := SC5->C5_NOTA
	else
		MsgAlert("Pedido não encontrado!","Atenção !!!")
		lStatus := .F.
		Return(.F.)
	endif

Return (.T.)
//===================================================================================================
// BOTAO ALTERAR
//===================================================================================================
User Function ALTDT2()

	Local nOpcao	  := 0

	if Empty(cPedido)
		MsgInfo("Digite o número da Pedido.")
		Return(.F.)
	endif

	nOpcao := Aviso("Confirmar","Confirma alteração da data de entrega?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SC5")
		Reclock("SC5", .F.)

		U_PrcMail() // Disarando e-mail

		SC5->C5_SUGENT := dDtEnt
		SC5->(MsUnlock())

		// Alterar a data de entrega na tabela SC6 para todos os itens do pedido
		SC6->(dbSeek(xFilial("SC6")+cPedido))
		While SC6->C6_NUM=cPedido .and. !SC6->(Eof())
			SC6->(Reclock("SC6",.F.))
			SC6->C6_ENTREG := dDtEnt
			SC6->(MsUnlock())
			SC6->(dbSkip())
		End

		Msginfo("Alterações gravadas com sucesso!")

	endif

	oDLG:End()

Return

// Função disparo de e-mail
User Function PrcMail
	Local nVal 		:= 0
	Local cNomCli 	:= ""
	Local xmCorpo	:= ""
	Local cEmails   := " "

	DbselectArea("SC6")
	Dbsetorder(1)
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

	While SC6->(!EOF()) .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM

		nVal += SC6->C6_VALOR
		SC6->(DbSkip())

	EndDo

	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE))

	//If MSGYESNO( "Deseja enviar email dessa alteração?", "Envio de Email" )

	cNomCli:= Alltrim(SA1->A1_NOME)

	xMail    := UsrRetMail(RetCodUsr())

	xmTitulo := " Alteração Pedido - " + Alltrim(SC5->C5_NUM)
	xmCorpo  := " Pedido: " + Alltrim(SC5->C5_NUM) + Chr(13) + Chr(10)
	If !Empty(cNomCli)
		xmCorpo  += " Cliente: " + Alltrim(cNomCli) + Chr(13) + Chr(10)
	Endif
	xmCorpo += ' Valor Total: ' + Transform( nVal, "@E 999,999,999.99" ) + Chr(13) + Chr(10)
	xmCorpo += " Data de Entrega Anterior: " + DtoC(SC5->C5_SUGENT) + Chr(13) + Chr(10)
	xmCorpo	+= " Data de Entrega Atual: " + DtoC(dDtEnt) + Chr(13) + Chr(10)
	xmCorpo	+=   Chr(13) + Chr(10)
	xmCorpo	:= strtran(xmCorpo,chr(13)+chr(10),"<br>")
	xmCorpo += '<p>&nbsp;</p>'
	xmCorpo += '<p>'+ Alltrim(SM0->M0_NOMECOM)+'<br>'
	xmCorpo += Alltrim(SM0->M0_ENDCOB)+ ' ' + Alltrim(SM0->M0_CIDCOB)+ ' ' + Alltrim(SM0->M0_ESTCOB) + ' - ' +  Transform( SM0->M0_CGC, "@R 99.999.999/9999-99") +'</p>'
	xmCorpo += '<p>&nbsp;</p>'
	xmCc    := ""
	xmCco   := ""
	xmAtt   := ""

	DbSelectArea("SA3")
	DbSetOrder(1)
	SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))

	cEmails   := SA3->A3_EMAIL + ";" + SA1->A1_EMAIL

	U_Envemail({cEmails,xmTitulo,xmCorpo,xmCc,xmCco,xmAtt,xMail})	
	//U_Envemail({"rst.raphael@gmail.com",xmTitulo,xmCorpo,xmCc,xmCco,xmAtt,xMail})

	//Endif

Return




