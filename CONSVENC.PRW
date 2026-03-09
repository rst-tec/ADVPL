/*------------------------------------------------------------------------//
//Programa:	 CONSVENC
//Autor:	 Raphael Silva
//Data:		 06/03/2026
//Descricao: Consulta para verificar vencimento de lotes, utilizando a data de validade do SB8 e SD4
//------------------------------------------------------------------------*/
User Function VENCB8()
    Local dDtValid  := SB8->B8_DTVALID
    Local dHoje     := Date()
    Local nDias     := dDtValid - dHoje
    Local cMensagem := ""

    If nDias == 1
        cMensagem := "VENCIMENTO PRÓXIMO EM 1 DIA"
    ElseIf nDias > 1 .AND. nDias < 30
        cMensagem := "VENCIMENTO PRÓXIMO EM " + AllTrim(Str(nDias)) + " DIAS"
    ElseIf nDias < 0
        If Abs(nDias) == 1
            cMensagem := "VENCIDO HÁ 1 DIA"
        Else
            cMensagem := "VENCIDO HÁ " + AllTrim(Str(Abs(nDias))) + " DIAS"
        EndIf
    Else
        cMensagem := ""
    EndIf    

Return cMensagem
User Function VENCD4()
    Local dDtValid  := SD4->D4_DTVALID
    Local dHoje     := Date()
    Local nDias     := dDtValid - dHoje
    Local cMensagem := ""

    If nDias == 1
        cMensagem := "VENCIMENTO PRÓXIMO EM 1 DIA"
    ElseIf nDias > 1 .AND. nDias < 30
        cMensagem := "VENCIMENTO PRÓXIMO EM " + AllTrim(Str(nDias)) + " DIAS"
    ElseIf nDias < 0
        If Abs(nDias) == 1
            cMensagem := "VENCIDO HÁ 1 DIA"
        Else
            cMensagem := "VENCIDO HÁ " + AllTrim(Str(Abs(nDias))) + " DIAS"
        EndIf
    Else
        cMensagem := ""
    EndIf    

Return cMensagem

/*
//TESTANDO NA ROTINA DE FORMULAS
//
User Function CONFORM()
    Local cCodigo  := SM4->M4_CODIGO
    Local dHoje     := Date()    
    Local cMensagem := ""

    If cCodigo =='001'
        cMensagem := "Exibido Codigo: " + AllTrim(cCodigo)"
    ElseIf cCodigo =='002'
        cMensagem := "Exibido Data: " + AllTrim(DTOC(dHoje))"
    Else
        cMensagem := "Sem Validação"
    EndIf    

Return cMensagem
*/



