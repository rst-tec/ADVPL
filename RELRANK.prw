#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

//+------------+------------+--------+--------------------------------------------+
//| Função:    | RELRANK    | Data   | 18/08/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Relatório de ranking  de vendas                                  |
//+------------+------------+--------+--------------------------------------------+

User Function RELRANK()
oReport:=ReportDef()
oReport:SetTotalInLine(.F.)
oReport:PrintDialog()
Return

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório. !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSecao1 := oReport:Section(1)

oSecao1:BeginQuery()

BeginSQL Alias cAlias

SELECT D2_EST, D2_CLIENTE, D2_LOJA, 
(SELECT A1_NOME FROM SA1010 WHERE A1_COD  = D2_CLIENTE AND A1_LOJA = D2_LOJA AND D_E_L_E_T_<> '*') AS A1_NOME,
SUM(D2_QUANT) AS D2_QUANT, SUM(D2_TOTAL + D2_VALFRE) AS D2_TOTAL
FROM SD2010, SF2010
WHERE SD2010.D_E_L_E_T_ <> '*' AND SF2010.D_E_L_E_T_ <> '*'
AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE

AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND D2_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND SUBSTR(D2_COD,1,4) BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND F2_VEND1 BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%

AND D2_TES <> '507'
AND D2_CF IN('510  ','511  ','5101 ','5118 ','5922 ','5111 ','5122 ','5124 ','541  ','5501 ','569  ','611  ' ,'6101 ','6118 ','6922 ','6111 ','6122 ','6124 ','6501 ','6109 ','618  ','6107 ','619  ','6108 ','6922 ','711  ','7101 ','7127 ' )

GROUP BY D2_EST, D2_CLIENTE, D2_LOJA
ORDER BY D2_TOTAL DESC

EndSQL

IF(RAT(".prt", oreport:cfile) > 0)
//alert("Impressão via .prt")
ELSEIF(RAT(".xml", oreport:cfile) > 0)
//alert("Impressão via .xml")
ENDIF

oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório. !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias, cPerg)
local cPerg := PadR("RELRANK",10)
local cTitle := "Relatório ranking de vendas"
local cHelp := "Permite gerar um relatório de ranking de vendas"
local oReport
local oSection1
local cAlias := getNextAlias()

oReport := TReport():New('RELRANK',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//oReport:SetPortrait() //Definindo a orientação como retrato
//oReport:SetLandscape()//Definindo a orientação como paisagem

//Primeira sessão
oSection1 := TRSection():New(oReport,"Relatório ranking de vendas",{cAlias})

ocell:= TRCell():New(oSection1,"D2_EST", cAlias, "Estado")
ocell:= TRCell():New(oSection1,"D2_CLIENTE", cAlias, "Cliente")
ocell:= TRCell():New(oSection1,"D2_LOJA", cAlias, "Loja")
ocell:= TRCell():New(oSection1,"A1_NOME", cAlias, "Nome")
ocell:= TRCell():New(oSection1,"D2_QUANT", cAlias, "Kilos")
ocell:= TRCell():New(oSection1,"D2_TOTAL", cAlias, "Valor")

//Totalizador
    
TRFunction():New(oSection1:Cell("D2_QUANT"),"Total Peso","SUM",,,,,.F.,.T.)

TRFunction():New(oSection1:Cell("D2_TOTAL"),"Total Metros","SUM",,,,,.F.,.T.)

Return(oReport)
