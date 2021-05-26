#Include 'Protheus.ch'
#include 'TopConn.CH'

/* Este Relatório tem o objetivo de imprimir alguns campos do cadastro de produtos. */

user function RELCAMP02()

	Local oReport	:= Nil
	Local cPerg 	:= "FATRC01"
	
	Pergunte(cPerg,.F.) //SX1
	
	oReport := Struc1(cPerg)
	oReport:PrintDialog()	
	
return

Static Function Struc1(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	
	oReport := TReport():New(cNome,"Relatório campanha de vendas",cNome,{|oRperot| RPTPRINT(oReport)},"Descricao do Help")
	
	oReport:SetPortrait() //Definindo a orientação como retrato
	
	oSection1 := TRSection():New(oReport, "Produtos",{"SB1"}, NIL,.F.,.T.)
	ocell:= TRCell():New(oSection1,"C5_EMISSAO", cAlias, "Emissao")

	TRCell():New(oSection1,"B1_COD"	,"QRYINA","Cod. Produto"  		,"@!" ,200)
	TRCell():New(oSection1,"B1_DESC","QRYINA","Descrição"  		,"@!" ,200)
	TRCell():New(oSection1,"W9_DESC","QRYINA","Cor/Estampa"	,"@!",200)
	TRCell():New(oSection1,"B5_PRODUZI","QRYINA","Produzido"	,"@!",150)
	TRCell():New(oSection1,"B1_COMIS","QRYINA","Comissão"	,"@E 999,999,999.99",200)
	TRCell():New(oSection1,"B1_LINHA","QRYINA","Linha "	,"@!",200)
	TRCell():New(oSection1,"B1_PRECO7","QRYINA","Tabela 7%"	,"@E 999,999,999.99",150)
	TRCell():New(oSection1,"B1_PRECO12","QRYINA","Tabela 12%"	,"@E 999,999,999.99",200)
	TRCell():New(oSection1,"B1_TEMADES","QRYINA","TEMA"	,"@!",200)
	TRCell():New(oSection1,"B1_NOMEIMG","QRYINA","Cod. Imagem"	,"@!",200)
	
	
	oSection1:SetPageBreak(.F.) //Quebra de seção
	

Return (oReport)


Static Function RPTPrint(oReport)


	Local oSection1 := oReport:Section(1)
	Local cQuery := ""

	
	
		cQuery :=	" SELECT SB1.B1_COD, SB1.B1_TEMADES,SB1.B1_NOMEIMG,SB1.B1_DESC, SB5.B5_PRODUZI, SB1.B1_COMIS, SB1.B1_PRECO7, SB1.B1_PRECO12 , SW9.W9_DESC COR,"
		cQuery +=	" (  CASE WHEN SB1.B1_LINHA = 'O' THEN 'Outlet' "
		cQuery +=	" WHEN  SB1.B1_LINHA = 'S'  THEN 'Linha' "
		cQuery +=	" WHEN SB1.B1_LINHA = 'M'   THEN 'Desenvolvimento' "
		cQuery +=	" WHEN SB1.B1_LINHA = 'D'   THEN 'Digital' "
	    cQuery +=	" WHEN SB1.B1_LINHA = 'N'   THEN 'Inativo' "
	    cQuery +=	" WHEN SB1.B1_LINHA = 'E'   THEN 'Exclusivo' "
	    cQuery +=	" WHEN SB1.B1_LINHA = 'X'   THEN 'Exportação' "
	    cQuery +=	" WHEN SB1.B1_LINHA = 'L'   THEN 'Lote' "
	    cQuery +=	" WHEN SB1.B1_LINHA = 'T'   THEN 'Trend' "
	    cQuery +=	" ELSE 'Especial' END ) LINHA "
	    cQuery +=	" FROM SB1010 SB1 "
	    cQuery +=	" LEFT JOIN SW9010 SW9 ON SW9.W9_COD = SUBSTR(SB1.B1_COD,5,4) "
	    cQuery +=	" LEFT JOIN SB5010 SB5 ON TRIM(SB5.B5_COD) = SUBSTR(SB1.B1_COD,1,4) "
	    cQuery +=	" WHERE sb1.d_e_l_e_t_ <> '*' AND sw9.d_e_l_e_t_ <> '*' AND sb5.d_e_l_e_t_ <> '*'  " 
	    cQuery +=	" AND SB1.B1_TIPO = 'PA' AND SB1.B1_LOCPAD = '01'  AND SB1.B1_LINHA = '"+ MV_PAR01+ "' "
	    cQuery +=	" ORDER BY LINHA "
	    TcQuery cQuery New Alias "QRYINA"
		
			
			DbSelectArea("QRYINA")
			
			QRYINA->(dbGoTop())
			
			oReport:SetMeter(QRYINA->(LastRec()))

		While !EOF()
			If oReport:Cancel()
				Exit
			EndIf
			//Iniciando a primeira seção
			oSection1:Init()
			oReport:IncMeter()
					
			//oSection1:Printline()
		
	
		
		//Imprimindo primeira seção:
			oSection1:Cell("B1_COD"):SetValue(QRYINA->B1_COD)
			oSection1:Cell("B1_DESC"):SetValue(QRYINA->B1_DESC)				
			oSection1:Cell("W9_DESC"):SetValue(QRYINA->COR)				
			oSection1:Cell("B5_PRODUZI"):SetValue(QRYINA->B5_PRODUZI)				
			oSection1:Cell("B1_COMIS"):SetValue(QRYINA->B1_COMIS)				
			oSection1:Cell("B1_LINHA"):SetValue(QRYINA->LINHA)				
			oSection1:Cell("B1_PRECO7"):SetValue(QRYINA->B1_PRECO7) 				
			oSection1:Cell("B1_PRECO12"):SetValue(QRYINA->B1_PRECO12)				
			oSection1:Cell("B1_TEMADES"):SetValue(QRYINA->B1_TEMADES)				
			oSection1:Cell("B1_NOMEIMG"):SetValue(QRYINA->B1_NOMEIMG)				
						
			
			oSection1:Printline()
			
			
			QRYINA->(DbSkip())	
			
			
			
	
		EndDo
		oReport:ThinLine()
	 oSection1:Finish()		
	 
QRYINA->(DbCloseArea())

Return
