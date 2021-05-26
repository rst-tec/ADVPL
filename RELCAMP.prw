#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

//Relatório de campanha de vendas
//Desenvolvido por: Raphael Silva
//Data: 24/05/2021

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
SELECT SC5.C5_EMISSAO, SC5.C5_NUM, SC5.C5_VEND1,
SC6.C6_NUM, SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_NOTA,

(SELECT COUNT(*) FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF') AS PARCELAS,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND (SE1.E1_PARCELA = ' ' OR SE1.E1_PARCELA = 'A') ) AS PARCELA1,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'B') AS PARCELA2,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'C') AS PARCELA3,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'D') AS PARCELA4,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'E') AS PARCELA5,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'F') AS PARCELA6,

(SELECT SE1.E1_NUM || '-' || SE1.E1_PARCELA || ' Vencto: ' || SE1.E1_VENCREA || CASE WHEN LENGTH(TRIM(SE1.E1_BAIXA)) IS NULL THEN ' EM ABERTO' ELSE ' BAIXADO' END
FROM SE1010 SE1 WHERE SE1.D_E_L_E_T_ <> '*' AND SC6.C6_NOTA = SE1.E1_NUM AND SE1.E1_TIPO = 'NF' AND SE1.E1_PARCELA = 'G') AS PARCELA7

FROM SC6010 SC6
LEFT JOIN SC5010 SC5 ON SC6.C6_NUM = SC5.C5_NUM AND SC5.D_E_L_E_T_ <> '*' 
WHERE SC6.D_E_L_E_T_ <> '*'
AND SC5.C5_TIPO = 'N'
AND SC5.C5_CONDPAG <> '007'
AND SUBSTR(SC6.C6_PRODUTO,1,4)IN('6530','6531','6532','6533','6525','6496','6495','6497','6512','6489','6490','5350','6256')
AND SC5.C5_EMISSAO BETWEEN '20210518' AND '20210531'
AND SC5.C5_NUM = SC6.C6_NUM
ORDER BY SC6.C6_NUM
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
//local cPerg := PadR("PVABERTO",10)
local cTitle := "Relatório campanha de vendas"
local cHelp := "Permite gerar um relatório de campanha de vendas"
local oReport
local oSection1
local cAlias := getNextAlias()

oReport := TReport():New('RELCAMP',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//Primeira sessão
oSection1 := TRSection():New(oReport,"Relatório campanha de vendas",{cAlias})

ocell:= TRCell():New(oSection1,"C5_EMISSAO", cAlias, "Emissao")
ocell:= TRCell():New(oSection1,"C5_NUM", cAlias, "Pedido")
ocell:= TRCell():New(oSection1,"C5_VEND1", cAlias, "Vend.")
ocell:= TRCell():New(oSection1,"C6_PRODUTO", cAlias, "Produto")
ocell:= TRCell():New(oSection1,"C6_QTDVEN", cAlias, "Quant.")
ocell:= TRCell():New(oSection1,"C6_PRCVEN", cAlias, "Unit.")
ocell:= TRCell():New(oSection1,"C6_VALOR", cAlias, "Total")
ocell:= TRCell():New(oSection1,"C6_NOTA", cAlias, "Nota")
ocell:= TRCell():New(oSection1,"PARCELAS", cAlias, "Parcelas")
ocell:= TRCell():New(oSection1,"PARCELA1", cAlias, "Parcela-1")
ocell:= TRCell():New(oSection1,"PARCELA2", cAlias, "Parcela-2")
ocell:= TRCell():New(oSection1,"PARCELA3", cAlias, "Parcela-3")
ocell:= TRCell():New(oSection1,"PARCELA4", cAlias, "Parcela-4")
ocell:= TRCell():New(oSection1,"PARCELA5", cAlias, "Parcela-5")
ocell:= TRCell():New(oSection1,"PARCELA6", cAlias, "Parcela-6")
ocell:= TRCell():New(oSection1,"PARCELA7", cAlias, "Parcela-7")

Return(oReport)
