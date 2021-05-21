#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

// Exemplo de relatório usando tReport com uma Section

User Function RELCAMP()
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
SELECT C6_NUM, C6_ITEM, C5_EMISSAO, C5_VEND1, A3_NREDUZ, C6_PRODUTO,  B1_DESC, C6_QTDVEN, C6_PRCVEN
FROM SC6010, SC5010, SA3010, SB1010
WHERE SC6010.D_E_L_E_T_ <> '*'  AND SC5010.D_E_L_E_T_<>'*'  AND SA3010.D_E_L_E_T_<>'*'  AND SB1010.D_E_L_E_T_<>'*'  
AND C6_NUM = C5_NUM
AND C5_VEND1 = A3_COD
AND C6_PRODUTO = B1_COD
AND C5_EMISSAO  BETWEEN %Exp:DtoS(MV_PAR01)% AND %Exp:DtoS(MV_PAR02)%
AND C6_CLI      BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND C5_VEND1    BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND C6_PRODUTO  BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
ORDER BY C6_NUM, C6_ITEM
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
local cPerg := PadR("PVABERTO",10)
local cTitle := "Relatório campanha de vendas"
local cHelp := "Permite gerar um relatório de campanha de vendas"
local oReport
local oSection1
local cAlias := getNextAlias()

oReport := TReport():New('RELCAMP',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//Primeira sessão
oSection1 := TRSection():New(oReport,"Relatório campanha de vendas",{cAlias})

ocell:= TRCell():New(oSection1,"C6_NUM",        cAlias, "Pedido")
ocell:= TRCell():New(oSection1,"C6_ITEM",       cAlias, "Item")
ocell:= TRCell():New(oSection1,"C5_EMISSAO",    cAlias, "Emissao")
ocell:= TRCell():New(oSection1,"C5_VEND1",      cAlias, "Vend.")
ocell:= TRCell():New(oSection1,"A3_NREDUZ",     cAlias, "Nome")
ocell:= TRCell():New(oSection1,"C6_PRODUTO",    cAlias, "Produto")
ocell:= TRCell():New(oSection1,"B1_DESC",       cAlias, "Descr.")
ocell:= TRCell():New(oSection1,"C6_QTDVEN",     cAlias, "Quant.")
ocell:= TRCell():New(oSection1,"C6_PRCVEN",     cAlias, "Unit.")

Return(oReport)
