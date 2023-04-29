#Include "Totvs.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} MT100LOK

Descri��o: Esse ponto de entrada � executado dentro da rotina de lan�amento de codumento de entrada.
Obejetivo: N�o permitir o lan�amento da nota se o item estiver com saldo atual negativo.

@author Raphael Silva
@since 29/04/2023
@version P12
/*/

User Function MT100LOK()
	Local cValSaldo := GetMv("M3_VALSALD") // Paramentro para ativa ou desativar

	Local lRet := .T.

	Local nProduto := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
	Local cProduto := AllTrim(Acols[n,nProduto])

	cSaldoSB2 := Posicione("SB2",1,xFilial("SB2")+ cProduto,"B2_QATU")

	IF cValSaldo == 'S'

		IF cSaldoSB2 < 0
			lRet := .F.
			Alert("N�o est� permitido a entrada de produto com saldo negativo. Produto: " + AllTrim(cValToChar(cProduto)) + " - Saldo: "+ cValToChar(cSaldoSB2) + " <MT100LOK>")
		ENDIF

	ENDIF

Return lRet
