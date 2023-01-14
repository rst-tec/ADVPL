#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | ADDHIST    | Data   | 11/01/2023                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para para adicionar historico ao titulo a receber           |
//+------------+------------+--------+--------------------------------------------+

//Para Contornar o problema do HELP: TITPGPIXCART, ao tentar alterar Titulo a receber gerado pelo SIGALOJA 
//https://centraldeatendimento.totvs.com/hc/pt-br/articles/7944057447575-Cross-Segmentos-Backoffice-Linha-Protheus-SIGAFIN-Help-TITPGPIXCART-

User Function ADDHIST()

	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSay11
	Local Sair

	Private oDlg
	Private oTitulo
	Private oParc
	Private oPref
	Private oNome
	Private oData
	Private oVenc
	Private oValor
	Private oSaldo
	Private oTipo
	Private oNatu
	Private oMen1
	Private oMen2

	Private cTitulo := SE1->E1_NUM
	Private cParc   := SE1->E1_PARCELA
	Private cPref   := SE1->E1_PREFIXO
	Private cNome	:= SE1->E1_NOMCLI
	Private nValor  := SE1->E1_VALOR
	Private nSaldo  := SE1->E1_SALDO
	Private dData	:= SE1->E1_EMISSAO
	Private dVenc	:= SE1->E1_VENCTO
	Private cTipo   := SE1->E1_TIPO
	Private cNatu   := SE1->E1_NATUREZ
	Private cMen1	:= SE1->E1_HIST
	Private cMen2	:= SE1->E1_XMEMO
	Private Alterar

	if SE1->E1_SALDO == 0
		MsgInfo("Atenção !!! Título já baixado")
		Return(.F.)
	endif

	DEFINE MSDIALOG oDlg TITLE "Adiciona Histórico" FROM 000, 000  TO 400, 420 COLORS 0, 16777215 PIXEL

	@ 014, 015 SAY oSay1 PROMPT "Título:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 039 MSGET oTitulo VAR cTitulo SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 014, 105 SAY oSay6 PROMPT "Parc.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 120 MSGET oParc VAR cParc SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 014, 145 SAY oSay4 PROMPT "Pref.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 160 MSGET oPref VAR cPref SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 029, 015 SAY oSay8 PROMPT "Cliente:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 039 MSGET oNome VAR cNome SIZE 155, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

	@ 044, 015 SAY oSay2 PROMPT "Valor:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 039 MSGET oValor VAR nValor SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL Picture '9999.99' WHEN .F.

	@ 044, 105 SAY oSay3 PROMPT "Saldo:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040, 133 MSGET oSaldo VAR nSaldo SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  Picture '9999.99' WHEN .F.

	@ 059, 015 SAY oSay3 PROMPT "Emissao:" SIZE 037, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 039 MSGET oData VAR dData SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  WHEN .F.

	@ 059, 105 SAY oSay5 PROMPT "Venc.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 133 MSGET oVenc VAR dVenc SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 074, 015 SAY oSay5 PROMPT "Tipo:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 039 MSGET oTipo VAR cTipo SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 074, 105 SAY oSay7 PROMPT "Natureza.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 070, 133 MSGET oNatu VAR cNatu SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 089, 015 SAY oSay9 PROMPT "Hist.1.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 085, 039 MSGET oMen1 VAR cMen1 SIZE 155, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.

	@ 104, 015 SAY oSay11 PROMPT "Hist.2.:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 100, 039 GET oMen2 VAR cMen2 MEMO SIZE 155, 040 OF oDlg COLORS 0, 16777215 PIXEL

	@ 165, 040 BUTTON Alterar PROMPT "Alterar" SIZE 050, 024 OF oDlg PIXEL Action U_ADDHIST1()
	@ 165, 140 BUTTON Sair PROMPT "Sair" SIZE 050, 026 OF oDlg PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//===================================================================================================
// BOTAO ALTERAR
//===================================================================================================
User Function ADDHIST1()

	Local nOpcao := 0

	if Empty(cTitulo)
		MsgInfo("Digite o número do Título.")
		Return(.F.)
	endif

	nOpcao := Aviso("Confirmar","Confirma alteração?", {"Sim","Nao"}, 1, "")

	if nOpcao = 1

		dbSelectArea("SE1")
		Reclock("SE1", .F.)

		SE1->E1_XMEMO := cMen2

		MsUnlock()

		Msginfo("Alteração, gravada com sucesso!")

	endif

	oDLG:End()

Return
