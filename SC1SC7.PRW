#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"

/*------------------------------------------------------------------------//
//Programa:	 SC1SC7
//Autor:	 Raphael Silva
//Data:		 13/08/2024
//Descricao: Relação Solicitação de Compra e Pedido
//------------------------------------------------------------------------*/

User Function SC1SC7()
Private oReport     := NIL
Private oSection1   := NIL 
Private cAlias

Private cPerg := "SC1SC7"  //

//Exibir perguntas ao abrir o relatorio no protheus

Pergunte(cPerg,.T.)

ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
oReport := TReport():New("SC1SC7", "Relação Solicitação de Compra e Pedido", cPerg,{|oReport| PrintReport(oReport)}, "Relação Solicitação de Compra e Pedido")
//oReport :SetLandscape(.T.)

oSection1 := TRsection():New(oReport, "Relação Solicitação de Compra e Pedido")

//Itens do Relatório 
TRCell():New(oSection1,"C1_FILIAL",    cAlias,"FILIAL")
TRCell():New(oSection1,"C1_NUM",       cAlias,"NUM.SC")
TRCell():New(oSection1,"C1_ITEM",      cAlias,"ITEM.SC")
TRCell():New(oSection1,"C1_EMISSAO",   cAlias,"EMISSAO-SC")
TRCell():New(oSection1,"C1_DATPRF",    cAlias,"PREVISAO-SC")
TRCell():New(oSection1,"C1_QUANT",     cAlias,"QUANTIDADE-SC")
TRCell():New(oSection1,"C1_PEDIDO",    cAlias,"NUM.PC")
TRCell():New(oSection1,"C1_ITEMPED",   cAlias,"ITEM.PC")
TRCell():New(oSection1,"C7_EMISSAO",   cAlias,"EMISSAO-PC")
TRCell():New(oSection1,"C7_DATPRF",    cAlias,"PREVISAO-PC")
TRCell():New(oSection1,"C7_FORNECE",   cAlias,"FORNECEDOR")
TRCell():New(oSection1,"C7_LOJA",      cAlias,"LOJA")
TRCell():New(oSection1,"A2_NOME",      cAlias,"NOME")
TRCell():New(oSection1,"A2_TEL",       cAlias,"TELEFONE")
TRCell():New(oSection1,"C1_PRODUTO",   cAlias,"PRODUTO")
TRCell():New(oSection1,"C1_DESCRI",    cAlias,"DESCRIÇÃO")
TRCell():New(oSection1,"C1_UM",        cAlias,"UM")
TRCell():New(oSection1,"C7_PRECO",     cAlias,"PREÇO")
TRCell():New(oSection1,"C7_VLDESC",    cAlias,"VALDESC")
TRCell():New(oSection1,"C7_VALIPI",    cAlias,"VALIPI")
TRCell():New(oSection1,"C7_TOTAL",     cAlias,"TOTAL")
TRCell():New(oSection1,"C7_QUANT",     cAlias,"QUANTIDADE-PC")
TRCell():New(oSection1,"C7_QUJE",      cAlias,"ENTREGUE-PC")
TRCell():New(oSection1,"SALDO",        cAlias,"SALDO-PC")

Return

Static Function PrintReport(oReport)
cAlias := GetNextAlias()

oSection1:BeginQuery()

    BeginSQL Alias cAlias

SELECT 
    SC1770.C1_FILIAL, 
    SC1770.C1_NUM,  
    SC1770.C1_ITEM,
    SC1770.C1_EMISSAO, 
    SC1770.C1_DATPRF, 
    SC1770.C1_QUANT,  
    SC1770.C1_PEDIDO, 
    SC1770.C1_ITEMPED, 
    SC7770.C7_EMISSAO, 
    SC7770.C7_DATPRF,   
    SC7770.C7_FORNECE,
    SC7770.C7_LOJA,
    SA2770.A2_NOME,
    SA2770.A2_TEL,        
    SC1770.C1_PRODUTO,    
    SC1770.C1_DESCRI,   
    SC1770.C1_UM,  
    SC7770.C7_PRECO,
    SC7770.C7_VLDESC,
    SC7770.C7_VALIPI,
    SC7770.C7_TOTAL,
    SC7770.C7_QUANT,
    SC7770.C7_QUJE, 
    (SC7770.C7_QUANT - SC7770.C7_QUJE) AS SALDO
FROM 
    SC1770
LEFT JOIN 
    SC7770 
    ON SC1770.C1_PEDIDO = SC7770.C7_NUM 
    AND SC1770.C1_ITEMPED = SC7770.C7_ITEM 
    AND SC7770.D_E_L_E_T_ = ''
LEFT JOIN
    SA2770
    ON SC7770.C7_FORNECE = SA2770.A2_COD
    AND SC7770.C7_LOJA = SA2770.A2_LOJA
    AND SA2770.D_E_L_E_T_ = '' 
WHERE 
    SC1770.D_E_L_E_T_ = '' 
    AND SC1770.C1_EMISSAO >= '20240101'  
    AND SC1770.C1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY 
    SC1770.C1_EMISSAO

    EndSQL

oSection1:EndQuery()//Fim da Query

oSection1:Print()

//O Alias utiizado para execução da query é fechado
(cAlias)->(DBCloseArea())

Return
