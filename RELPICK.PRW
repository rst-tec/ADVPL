#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"

/*------------------------------------------------------------------------//
//Programa:	BIOESTR9
//Autor:	Raphael Silva
//Data:		15/05/2023
//Descricao: Relatório Picklist
//------------------------------------------------------------------------*/

User Function RELPICK()
Private oReport     := NIL
Private oSection1   := NIL 
Private cAlias

Private cPerg := "RELPICK"

//Exibir perguntas ao abrir o relatorio no protheus
Pergunte(cPerg,.T.)

ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
oReport := TReport():New("RELPICK", "Relatório Picklist", cPerg,{|oReport| PrintReport(oReport)}, "Relatório Picklist")
//oReport :SetLandscape(.T.)

oSection1 := TRsection():New(oReport, "Relatório Picklist")

//Itens do Relatório 
TRCell():New(oSection1,"ZH_PEDIDO",     cAlias,"Pedido")
TRCell():New(oSection1,"ZH_SEQUEN",     cAlias,"Sequencia")
TRCell():New(oSection1,"ZH_PRODUTO",    cAlias,"Produto")
TRCell():New(oSection1,"ZH_QTDPED",     cAlias,"Qtd.Pedido")
TRCell():New(oSection1,"ZH_QTDLIDA",    cAlias,"Qtd.Lida")
TRCell():New(oSection1,"ZH_LOTECTL",    cAlias,"Lote")
TRCell():New(oSection1,"ZH_LOCAL",      cAlias,"Armazem")
TRCell():New(oSection1,"ZH_DATA",       cAlias,"Data")
TRCell():New(oSection1,"ZH_HORA",       cAlias,"Hora")
TRCell():New(oSection1,"ZH_USUARIO",    cAlias,"Usuario")

Return

Static Function PrintReport(oReport)
cAlias := GetNextAlias()

oSection1:BeginQuery()

    BeginSQL Alias cAlias
    SELECT ZH_FILIAL,ZH_PEDIDO,ZH_SEQUEN,ZH_PRODUTO,ZH_QTDPED,ZH_QTDLIDA,ZH_LOTECTL,ZH_LOCAL,ZH_DATA,ZH_HORA,ZH_USUARIO
    FROM %Table:SZH% SZH
    WHERE D_E_L_E_T_<> '*'
    AND ZH_FILIAL = %Exp:xFilial("SZH")%
    AND ZH_PRODUTO <> ' '
    AND ZH_PEDIDO = %Exp:MV_PAR01% 
    ORDER BY ZH_PEDIDO,ZH_SEQUEN
    EndSQL

oSection1:EndQuery()//Fim da Query

oSection1:Print()

//O Alias utiizado para execução da query é fechado
(cAlias)->(DBCloseArea())

Return
