#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

//+------------+------------+--------+--------------------------------------------+
//| Fun��o:    | RELFIXA    | Data   | 10/06/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descri��o: | Relat�rio de tecido lavado e ou prefixado                        |
//+------------+------------+--------+--------------------------------------------+

User Function RELFIXA()
oReport:=ReportDef()
oReport:SetTotalInLine(.F.)
oReport:PrintDialog()
Return

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relat�rio. !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSecao1 := oReport:Section(1)

oSecao1:BeginQuery()

BeginSQL Alias cAlias
SELECT Z1_DTINIFB, Z1_FABRICA, Z1_CODPROD, Z1_DESCRIC, Z1_COR, Z1_DCOR, Z1_ESTAMP, Z1_VARIANT, Z1_MTCRU, Z1_PESOCRU, Z1_SETOR, Z1_PREFIXA, Z1_DTPREFI
FROM SZ1010
WHERE SZ1010.D_E_L_E_T_ <> '*'  
AND Z1_DTPREFI BETWEEN '20210501' AND '20210630' // ALTERAR PARA PARAMETROS
ORDER BY Z1_DTPREFI
EndSQL

IF(RAT(".prt", oreport:cfile) > 0)
//alert("Impress�o via .prt")
ELSEIF(RAT(".xml", oreport:cfile) > 0)
//alert("Impress�o via .xml")
ENDIF

oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o da estrutura do relat�rio. !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias, cPerg)
//local cPerg := PadR("PVABERTO",10)
local cTitle := "Relat�rio de tecido lavado e ou prefixado "
local cHelp := "Relat�rio de tecido lavado e ou prefixado "
local oReport
local oSection1
local cAlias := getNextAlias()

oReport := TReport():New('RELFIXA',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//oReport:SetPortrait() //Definindo a orienta��o como retrato
//oReport:SetLandscape()//Definindo a orienta��o como paisagem

//Primeira sess�o
oSection1 := TRSection():New(oReport,"Relat�rio de tecido lavado e ou prefixado",{cAlias})

ocell:= TRCell():New(oSection1,"Z1_DTINIFB", cAlias, "DT inicio")
ocell:= TRCell():New(oSection1,"Z1_FABRICA", cAlias, "DT Fim")
ocell:= TRCell():New(oSection1,"Z1_CODPROD", cAlias, "Artigo")
ocell:= TRCell():New(oSection1,"Z1_DESCRIC", cAlias, "Descri��o")
ocell:= TRCell():New(oSection1,"Z1_COR", cAlias, "Cor")
ocell:= TRCell():New(oSection1,"Z1_DCOR", cAlias, "Descri��o")
ocell:= TRCell():New(oSection1,"Z1_ESTAMP", cAlias, "Estampa")
ocell:= TRCell():New(oSection1,"Z1_VARIANT", cAlias, "Variante")
ocell:= TRCell():New(oSection1,"Z1_MTCRU", cAlias, "Metros")
ocell:= TRCell():New(oSection1,"Z1_PESOCRU", cAlias, "Peso")
ocell:= TRCell():New(oSection1,"Z1_SETOR", cAlias, "Setor")
ocell:= TRCell():New(oSection1,"Z1_PREFIXA", cAlias, "Prefixado")
ocell:= TRCell():New(oSection1,"Z1_DTPREFI", cAlias, "DT Fixa��o")

Return(oReport)
