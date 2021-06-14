#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

//+------------+------------+--------+--------------------------------------------+
//| Fun��o:    | RLAVADO    | Data   | 10/06/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descri��o: | Relat�rio de tecido lavado e ou pr�-fixado                       |
//+------------+------------+--------+--------------------------------------------+

User Function RLAVADO()
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
SELECT Z1_CODPROD, Z1_DESCRIC, Z1_COR, Z1_DCOR, Z1_NOPECA, Z1_MTCRU, Z1_PESOCRU, Z1_SETOR, Z1_PREFIXA, Z1_DTPREFI, Z1_LAVADO, Z1_DTLAVAD
FROM SZ1010
WHERE SZ1010.D_E_L_E_T_ <> '*' 
AND Z1_CODPROD  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND (  Z1_DTPREFI  BETWEEN %Exp:DtoS(MV_PAR03)% AND %Exp:DtoS(MV_PAR04)% 
    OR Z1_DTLAVAD BETWEEN %Exp:DtoS(MV_PAR03)% AND %Exp:DtoS(MV_PAR04)%)
ORDER BY Z1_CODPROD, Z1_DTPREFI
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
local cPerg := PadR("RLAVADO",10)
local cTitle := "Relat�rio de tecido lavado e ou pr�-fixado"
local cHelp := "Relat�rio de tecido lavado e ou pr�-fixado"
local oReport
local oSection1
local cAlias := getNextAlias()

oReport := TReport():New('RLAVADO',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

//oReport:SetPortrait() //Definindo a orienta��o como retrato
//oReport:SetLandscape()//Definindo a orienta��o como paisagem

//Primeira sess�o
oSection1 := TRSection():New(oReport,"Relat�rio de tecido lavado e ou prefixado",{cAlias})

ocell:= TRCell():New(oSection1,"Z1_CODPROD", cAlias, "Artigo")
ocell:= TRCell():New(oSection1,"Z1_DESCRIC", cAlias, "Descri��o")
ocell:= TRCell():New(oSection1,"Z1_COR", cAlias, "Cor")
ocell:= TRCell():New(oSection1,"Z1_DCOR", cAlias, "Descri��o")
ocell:= TRCell():New(oSection1,"Z1_NOPECA", cAlias, "Pe�a")
ocell:= TRCell():New(oSection1,"Z1_MTCRU", cAlias, "Metros")
ocell:= TRCell():New(oSection1,"Z1_PESOCRU", cAlias, "Peso")
ocell:= TRCell():New(oSection1,"Z1_SETOR", cAlias, "Setor")
ocell:= TRCell():New(oSection1,"Z1_PREFIXA", cAlias, "Prefixado")
ocell:= TRCell():New(oSection1,"Z1_DTPREFI", cAlias, "DT Fixa��o")
ocell:= TRCell():New(oSection1,"Z1_LAVADO", cAlias, "Speroto")
ocell:= TRCell():New(oSection1,"Z1_DTLAVAD", cAlias, "DT Speroto")

//Totalizador
    
TRFunction():New(oSection1:Cell("Z1_PESOCRU"),"Total Pr�-Fixado","SUM",,,,,.F.,.T.)

TRFunction():New(oSection1:Cell("Z1_PESOCRU"),"Total Speroto","SUM",,,,,.F.,.T.)

Return(oReport)
