#Include 'Protheus.ch'
#include 'TopConn.CH'

// RELATORIO COM 2 SEÇÕES
// CONTEM PERGUNTAS

//Relatório de campanha de vendas
//Desenvolvido por: Raphael Silva
//Data: 19/08/2020

user function RELSD2()

	Local oReport   := Nil
	Local cPerg     := Padr("RELSD2",10)
	
	Pergunte(cPerg,.T.)
    
    oReport := RPTStruc(cPerg)
    oReport:PrintDialog()
	
return

Static Function RPTPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery := "" 
	Local cNumCod :=""	
	
	cQuery := "	SELECT D2_DOC, D2_ITEM, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_COD, B1_DESC, D2_QUANT, D2_NUMLOTE, D2_LOTECTL, D2_PEDIDO, A1_COD, A1_NOME 	"
	cQuery += "	FROM SA1010 SA1, SD2010 SD2, SB1010 SB1 "
	cQuery += "	WHERE SA1.D_E_L_E_T_ = ' ' AND "
	cQuery += "	D2_FILIAL = '01' AND SD2.D_E_L_E_T_ = ' 'AND D2_CLIENTE = A1_COD AND " 
	cQuery += "	B1_FILIAL = '01' AND SB1.D_E_L_E_T_ = ' 'AND B1_COD = D2_COD AND "
	cQuery += "	D2_EMISSAO 	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
	cQuery += "	D2_CLIENTE 	BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQuery += "	D2_DOC 		BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQuery += "	D2_LOTECTL  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	cQuery += "	ORDER BY D2_DOC, D2_ITEM "

//VERIFICA SE A TABELA JÁ ESTA ABERTA

	If Select("TEMP") <> 0
				DbSelectArea("TEMP")
				DbCloseArea()
			EndIf
			
		TCQUERY cQuery NEW ALIAS "TEMP"
			
			DbSelectArea("TEMP")
			TEMP->(dbGoTop())
			
			oReport:SetMeter(TEMP->(LastRec()))
	 	
	 	While !EOF()
	 	 If oReport:Cancel()
	 		Exit
	 	 EndIf
	 	 
          //INICIANDO A PRIMEIRA SEÇÃO

	 	 oSection1:Init()
	 	 oReport:IncMeter()
	 	
	 	 cNumCod := TEMP->A1_COD
	 	 IncProc("Imprimindo Cliente "+ Alltrim(TEMP->A1_COD))	

		 //IMPRIMINDO A PRIMEIRA SEÇÃO

		 oSection1:Cell("A1_COD"):SetValue(TEMP->A1_COD) 	
		 oSection1:Cell("A1_NOME"):SetValue(TEMP->A1_NOME)
		 oSection1:Printline()

		 //IMPRIMINDO A SEGUNDA SEÇÃO 
		 
		 oSection2:Init()	

		//VERIFICA SE O CODIGO DO CLIENTE É O MESMO, SE SIM, IMPRIME OS DADOS DAS NOTAS

			While TEMP->A1_COD ==cNumCod
				oReport:IncMeter()

				IncProc("Imprimindo Notas... "+ Alltrim(TEMP->D2_DOC))

				oSection2:Cell("D2_DOC"):SetValue(TEMP->D2_DOC) 	
				oSection2:Cell("B1_DESC"):SetValue(TEMP->B1_DESC) 
				oSection2:Cell("D2_COD"):SetValue(TEMP->D2_COD) 
				oSection2:Cell("D2_QUANT"):SetValue(TEMP->D2_QUANT) 
				oSection2:Printline()
				
				TEMP->(dbSkip())
			
			EndDo
		 	 	oSection2:Finish()
				oReport:ThinLine()

				oSection1:Finish()
	 	EndDo
return


Static Function RPTStruc(cNome)
    Local oReport   := Nil
	Local oSection1 := Nil
	Local oSection2 := Nil

    oReport := TReport():New(cNome,"Relatorio Itens das Notas",cNome,{|oReport| RPTPrint(oReport)},"Descição do Help")

    oReport:SetPortrait() //DEFININDO A ORIENTAÇÃO COMO RETRATO

    oSection1 := TRSection():New(oReport,"Clientes",{"SA1"},Nil,.F.,.T.)
    
    TRCell():New(oSection1,"A1_COD","TEMP","Codigo", "@!", 40)
    TRCell():New(oSection1,"A1_NOME","TEMP","Nome", "@!", 200)

    oSection2 := TRSection():New(oReport,"Produtos",{"SB1"},Nil,.F.,.T.)
    TRCell():New(oSection2,"D2_DOC","TEMP","Nota Fiscal", "@!", 9)
    TRCell():New(oSection2,"D2_ITEM","TEMP","Item", "@!", 6)
	//TRCell():New(oSection2,"D2_EMISSAO","TEMP","Emissao", "@!", 8)
    TRCell():New(oSection2,"D2_COD","TEMP","Produto", "@!", 15)
	TRCell():New(oSection2,"B1_DESC","TEMP","Descrição", "@!", 20)
    TRCell():New(oSection2,"D2_QUANT","TEMP","Quantidade", "@E 999999.999", 30)
    TRCell():New(oSection2,"D2_NUMLOTE","TEMP","SubLote", "@!", 12)
	TRCell():New(oSection2,"D2_LOTECTL","TEMP","Lote", "@!", 10)
    
    oSection1:SetPageBreak(.F.) //QUEBRA DE SEÇÃO
	

Return(oReport)
