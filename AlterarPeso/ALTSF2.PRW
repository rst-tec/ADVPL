#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | ALTSF2     | Data   | 05/07/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para para alterar peso da nota fiscal                       |
//+------------+------------+--------+--------------------------------------------+

User Function ALTSF2()

	Local oGroup1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local Sair

	Private oDlg
	private oNota
	Private oData
	private oBruto
	private oLiquido
	private oVolume
	private oEspecie
	private oFrete

	private cNota := space(9)
	Private dData 	:= stod("")
	private nBruto 	:= 0
	private nLiquido:= 0
	private nVolume := space(3)
	private cEspecie:= space(10)
	private nFrete 	:= space(1)
	Private Alterar

	DEFINE MSDIALOG oDlg TITLE "Alterar dados da Nota Fiscal" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

//DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay1 PROMPT "Nota:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oNota VAR cNota SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL	Valid U_ALTSF201() ==.T.

	@ 014, 105 SAY oSay3 PROMPT "Emissao:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 133 MSGET oData VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

	@ 025, 010 GROUP oGroup1 TO 080, 220 OF oDlg COLOR 0, 16777215 PIXEL
	@ 035, 015 SAY oSay2 PROMPT "Bruto:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 038 MSGET oBruto VAR nBruto SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '9999.999'

	@ 035, 105 SAY oSay3 PROMPT "Liquido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 031, 133 MSGET oLiquido VAR nLiquido SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '9999.999'

	@ 050, 015 SAY oSay4 PROMPT "Volume:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 038 MSGET oVolume VAR nVolume SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '999.999'

	@ 050, 105 SAY oSay5 PROMPT "Especie:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 046, 133 MSGET oEspecie VAR cEspecie SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 065, 015 SAY oSay6 PROMPT "Frete:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 061, 038 MSGET oFrete VAR nFrete SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 100, 015 BUTTON Alterar PROMPT "Alterar" SIZE 050, 024 OF oDlg PIXEL Action U_ALTSF202()
	@ 100, 165 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return
//=================================================================================
//
//================================================================================= 
User Function ALTSF201()

	if Empty(cNota)
		Return(.T.)
	endif

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbGoTop()

	if (dbSeek("01"+cNota))
		dData	  := SF2->F2_EMISSAO
		nBruto    := SF2->F2_PBRUTO
		nLiquido  := SF2->F2_PLIQUI
		nVolume   := SF2->F2_VOLUME1
		cEspecie  := SF2->F2_ESPECI1
		nFrete    := SF2->F2_TPFRETE
	else
		MsgAlert("Nota Fiscal não encontrado!","Atenção !!!")
		lStatus := .F.
		Return(.F.)
	endif

Return (.T.)
//===================================================================================================
// BOTAO ALTERAR
//===================================================================================================
User Function ALTSF202()

	Local nOpcao	  := 0

	if Empty(cNota)
		MsgInfo("Digite o número da Nota Fiscal.")
		Return(.F.)
	endif

	nOpcao := Aviso("Confirmar","Confirma alterações na nota fiscal?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SF2")

		Reclock("SF2", .F.)
		SF2->F2_PBRUTO  := nBruto
		SF2->F2_PLIQUI	:= nLiquido
		SF2->F2_VOLUME1	:= nVolume
		SF2->F2_ESPECI1	:= cEspecie
		SF2->F2_TPFRETE := nFrete
		
		MsUnlock()

		Msginfo("Alterações, gravada com sucesso!")

	endif

	oDLG:End()

	U_ALTSF2()

Return
