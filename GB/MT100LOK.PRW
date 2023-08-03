#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  º Autor ³ Mauricio Mirotti   º Data ³  04/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado na validacao das linhas da nota º±±
±±º          ³ fiscal de Entrada.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT100LOK()

	Local lRet := .T.
	Local cDigLote := GetMv("M3_DIGLOTE") // Paramentro para ativa ou desativar
	Local nLote := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
	Local cLote := AllTrim(Acols[n,nLote])

	IF cDigLote == 'S' //M3_DIGLOTE - Paramentro para ativa ou desativar
		IF (cEmpAnt == '03')//Somente para empresa INDC
			IF !acols[n,Len(aHeader)+1] //Verifica se a linha esta deletada
				IF CA100FOR == "C00375"//Somente para o CLiente Harald
					IF cGeraEst == 'S' //Somente para TES que gera estoque
						DbSelectArea('SB1')
						DbSetOrder(1)
						IF DbSeek(xFilial('SB1')+Trim(aCols[n][nPosProd]),.f.)
							IF SB1->B1_RASTRO == 'L' //Valida se o produto controla Lote
								IF Empty(cLote)
									lRet := .F.
									ALERT("Cliente ou Fornecedor Harald, é necessario informar o Lote! <MT100LOK> ")
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF

Return lRet
