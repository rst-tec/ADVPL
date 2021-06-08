#Include 'Protheus.ch'
#include 'TopConn.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | SB1GRUPO   | Autor: | Raphael Silva                              | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Gatilho para preenchimento do campo B1_GRUPO                     |
//+------------+------------------------------------------------------------------+
//| Data:      | 15/09/2020                                                       | 
//+-------------------------------------------------------------------------------+

  user function SB1GRUPO()

    Local cLinha    := AllTrim(M->B1_LINHA)
    Local cEstampa  := AllTrim(M->B1_ESTAMPA)
    Local cGrupo    := AllTrim(M->B1_GRUPO)

    If(cLinha = "M")
        cGrupo := "0016"
        
    elseif(cLinha = "S" .AND. cEstampa = "N")
        cGrupo := "0017"
        
    elseif(cLinha = "S" .AND. cEstampa = "S")
        cGrupo := "0020"
        
    elseif(cLinha = "O" .AND. cEstampa = "N")
        cGrupo := "0018"
        
    elseif(cLinha = "O" .AND. cEstampa = "S")
        cGrupo := "0019"
        
    elseif(cLinha = "L")
        cGrupo := "0021"
        
    elseif(cLinha <> "M, S, O, L")
        cGrupo := " "   
    Endif

return(cGrupo)

