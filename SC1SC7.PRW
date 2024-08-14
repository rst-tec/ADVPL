#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"

/*------------------------------------------------------------------------//
//Programa:	 SC1SC7
//Autor:	 Raphael Silva
//Data:		 13/08/2024
//Descricao: Relação Solicitação de Compra e Pedidos
//------------------------------------------------------------------------*/

User Function SC1SC7()
Private oReport     := NIL
Private oSection1   := NIL 
Private cAlias

//Private cPerg := "SC1SC7"  //

//Exibir perguntas ao abrir o relatorio no protheus

//Pergunte(cPerg,.T.)

ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
oReport := TReport():New("SC1SC7", "Relação Solicitação de Compra e Pedidos", cPerg,{|oReport| PrintReport(oReport)}, "Relação Notas de entrada com natureza")
//oReport :SetLandscape(.T.)

oSection1 := TRsection():New(oReport, "Relação Solicitação de Compra e Pedidos")

//Itens do Relatório 
TRCell():New(oSection1,"C1_FILIAL",    cAlias,"FILIAL")
TRCell():New(oSection1,"C1_NUM",       cAlias,"SOLICITACAO")
TRCell():New(oSection1,"C1_ITEM",      cAlias,"ITEM")
TRCell():New(oSection1,"C1_PRODUTO",   cAlias,"PRODUTO")
TRCell():New(oSection1,"C1_UM",        cAlias,"UM")
TRCell():New(oSection1,"C1_QUANT",     cAlias,"QUANTIDADE")
TRCell():New(oSection1,"C1_EMISSAO",   cAlias,"EMISSAO")
TRCell():New(oSection1,"C1_PEDIDO",    cAlias,"PEDIDO")
TRCell():New(oSection1,"C1_ITEMPED",   cAlias,"ITEMPED")
TRCell():New(oSection1,"C7_QUANT",     cAlias,"QUANTIDADE")
TRCell():New(oSection1,"C7_EMISSAO",   cAlias,"EMISSAO")

Return

Static Function PrintReport(oReport)
cAlias := GetNextAlias()

oSection1:BeginQuery()

    BeginSQL Alias cAlias

    SELECT C1_FILIAL, C1_NUM, C1_ITEM, C1_PRODUTO, C1_UM, C1_QUANT, C1_EMISSAO, C1_PEDIDO, C1_ITEMPED,
    (SELECT C7_QUANT FROM SC7770 WHERE C1_PEDIDO = C7_NUM AND C1_ITEMPED = C7_ITEM AND SC7770.D_E_L_E_T_ = '') AS C7_QUANT,
    (SELECT C7_EMISSAO FROM SC7770 WHERE C1_PEDIDO = C7_NUM AND C1_ITEMPED = C7_ITEM AND SC7770.D_E_L_E_T_ = '') AS C7_EMISSAO
    FROM SC1770
    WHERE SC1770.D_E_L_E_T_ = '' 
    AND C1_EMISSAO >= '20240101'   
    ORDER BY C1_EMISSAO
    
    EndSQL

oSection1:EndQuery()//Fim da Query

oSection1:Print()

//O Alias utiizado para execução da query é fechado
(cAlias)->(DBCloseArea())

Return
