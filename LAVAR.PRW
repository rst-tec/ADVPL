#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | LAVAR      | Data   | 10/06/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para informar tecido  lavado                                |
//+------------+------------+--------+--------------------------------------------+

User Function LAVAR()

	Local oGroup1
//Local OK
	Local oSay1
	Local oSay10
	Local oSay11
	Local oSay12
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local Sair
	Local cGet11 := space(4)

	Private Baixar
	Private oData
	//Private dData := Date() traz a data base
	Private dData := stod("") 
	Private oMetros
	Private nMetros := 0
	Private oCor
	Private cCor
	Private oDescriCor
	Private cDescriCor := space(30)
	Private oNumPeca
	Private cNumPeca := space(7)
	Private oCortePeca
	Private cCortePeca := space(1)
	Private oEstampa
	Private cEstampa := space(4)
	Private oVar
	Private cVar := space(1)
	Private oArtigo
	Private cArtigo := space(4)
	Private oDescri
	Private cDescri := space(30)
	Private oSetor
	Private cSetor := space(1)
	Private oPeso
	Private nPeso := 0
	Private oDlg
	Private nSald

	Private cNumOP		:= space(11)
	Private cHoraIni	:= space(5)
	Private cHoraFim	:= space(5)
	Private cProdutoOP	:= space(9)
	Private cDescrProdOP:= space(20)
	Private nPerda		:= 0

	Private cLotePeca   := ""

	DEFINE MSDIALOG oDlg TITLE "Lavagem de Pano Cru" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

//DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay2 PROMPT "Nº Peça:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oNumPeca VAR cNumPeca SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL //Valid u_DPeca()
	@ 014, 115 SAY oSay3 PROMPT "Corte:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 133 MSGET oCortePeca VAR cCortePeca SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  Valid U_LAVAR1() ==.T.

	@ 025, 010 GROUP oGroup1 TO 080, 220 OF oDlg COLOR 0, 16777215 PIXEL
	@ 035, 015 SAY oSay6 PROMPT "Artigo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 038 MSGET oArtigo VAR cArtigo SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
	@ 035, 105 SAY oSay7 PROMPT "Descrição:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 133 MSGET oDescri VAR cDescri SIZE 081, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 050, 015 SAY oSay8 PROMPT "Setor:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 038 MSGET oSetor VAR cSetor SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 050, 116 SAY oSay9 PROMPT "Peso:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 133 MSGET oPeso VAR nPeso SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.99' WHEN .F.

	@ 065, 015 SAY oSay10 PROMPT "Metros:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 038 MSGET oMetros VAR nMetros SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.99' WHEN .F.

	@ 065, 119 SAY oSay11 PROMPT "Cor:" SIZE 024, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 133 MSGET oCor VAR cCor SIZE 061, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	//ADICIONADO
	@ 090, 021 SAY oSay2 PROMPT "Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 086, 039 MSGET oData VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL 
   //ADICIONADO

	@ 120, 015 BUTTON Baixar PROMPT "Lavar" SIZE 050, 024 OF oDlg PIXEL Action U_LAVAR2()
	@ 120, 165 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return
//=================================================================================
//
//================================================================================= 
User Function LAVAR1()

	dbSelectArea("SZ1")
	dbSetOrder(4)
	dbGoTop()

	if (dbSeek("  "+cNumPeca+cCortePeca))
		cArtigo    := SZ1->Z1_CODPROD
		cDescri    := SZ1->Z1_DESCRIC
		cCor       := SZ1->Z1_COR
		cDescriCor := SZ1->Z1_DCOR
		cEstampa   := SZ1->Z1_ESTAMP
		cVar       := SZ1->Z1_VARIANT
		nMetros    := SZ1->Z1_MTCRU
		nPeso      := SZ1->Z1_PESOCRU
		cSetor	   := SZ1->Z1_SETOR
	else
		MsgAlert("Peça não encontrada!","Atenção !!!")
		lStatus := .F.
		Return(.F.)
	endif

	/*
   if SZ1->Z1_PREFIXA = "S" 
		MsgInfo("Atenção !!! Peça já foi lavada dia " + DtoC(SZ1->Z1_DTPREFI)) 
		Return(.F.)
	endif
   */

   if SZ1->Z1_LAVADO = "S" 
		MsgInfo("Atenção !!! Peça já foi lavada dia " + DtoC(SZ1->Z1_DTLAVAD))
		Return(.F.)
	endif

Return (.T.)
//===================================================================================================
// BOTAO BAIXAR
//===================================================================================================
User Function LAVAR2()

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

	nOpcao := Aviso("Confirmar tecido lavado!","Confirma tecido lavado?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SZ1")

		Reclock("SZ1", .F.)
		//SZ1->Z1_PREFIXA	:= "S"     // ALTERAR PARA O CAMPO DE DATA NOVO
		//SZ1->Z1_DTPREFI	:= dData   // ALTERAR PARA O CAMPO DE DATA NOVO

      	SZ1->Z1_LAVADO	:= "S"     
		SZ1->Z1_DTLAVAD	:= dData   
		MsUnlock()

		Msginfo("Informação de tecido lavado, gravada com sucesso!")

	endif

	oDLG:End()

	U_LAVAR()

Return
