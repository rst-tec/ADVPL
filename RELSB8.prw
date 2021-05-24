#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELSB8    บRAPHAEL SILVA               บ Data ณ  14/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE MATERIAIS PRONTO EM ESTOQUE GERAL             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELSB8


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat๓rio de Produto Acabado de Terceiros"
Local cPict          := ""
Local titulo       := "Relat๓rio de Produto Acabado de Terceiros"
Local nLin         := 80         
                               //1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
                  //   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "Pedido Item Cliente Loja Nome                 Produto         Descri็ใo                 Norma                 Ped.Cli    Cod.Prod            Saldo        Lote       End  Prazo     Produzido  Dias  Status"
Local Cabec2       	 := ""                                                                                                                                                                                          
Local imprime      	 := .T.
Local aOrd 			 := {}         
Local cperg 		 :="RELSB8"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "RELSB82" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELSB8" // Coloque aqui o nome do arquivo usado para impressao em disco
Private Cquery 

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)
Private cString := "SB8"
dbSelectArea("SB8")

//dbSetOrder(1)  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  13/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem 
Local nDias
Local nStatus
arqtmp()

Cquery:= " SELECT DISTINCT C6.C6_NUM, C6.C6_ITEM, D1.D1_X_CLIOR, D1.D1_X_LOJOR, A1.A1_NREDUZ, B8.B8_PRODUTO, B1.B1_DESC, C6.C6_NORMA, C6.C6_PEDCLI, C6.C6_CODPROD, B8.B8_SALDO, B8.B8_LOTECTL,B8_LOCALIZ, B8.B8_DATA, C6.C6_ENTREG,B8.B8_OBS  "
Cquery+= " FROM "+RETSQLNAME("SD3")+" AS D3,"+RETSQLNAME("SB8")+" AS B8, "+RETSQLNAME("SC6")+" AS C6, "+RETSQLNAME("SD1")+" AS D1, SA1020 AS A1, SB1020 AS B1, "+RETSQLNAME("SD4")+" AS D4 "
Cquery+= " WHERE D3.D_E_L_E_T_<> '*' AND B8.D_E_L_E_T_<> '*' AND C6.D_E_L_E_T_<> '*' AND D1.D_E_L_E_T_<> '*' AND A1.D_E_L_E_T_<> '*' AND  B1.D_E_L_E_T_<> '*' AND D3.D_E_L_E_T_<> '*' AND "
Cquery+= " D3.D3_FILIAL = '"+xfilial("SD3")+ "' AND B8.B8_FILIAL = '"+xfilial("SB8")+ "' AND C6.C6_FILIAL = '"+xfilial("SC6")+ "' AND D1.D1_FILIAL = '"+xfilial("SD1")+ "' AND D4.D4_FILIAL = '"+xfilial("SD4")+ "' AND"

Cquery+= " D3_LOTECTL = B8_LOTECTL AND "
Cquery+= " D3_COD = B8_PRODUTO AND "      
Cquery+= " D3_COD = B1_COD AND "
Cquery+= " D3_OP = D4_OP AND " 
Cquery+= " D4_LOTECTL = D1_LOTECTL AND "
Cquery+= " SUBSTRING (D3_OP,1,6) = C6_NUM AND " 
Cquery+= " SUBSTRING (D3_OP,7,2) = C6_ITEM AND "
Cquery+= " D1_X_CLIOR = A1_COD AND D1_X_LOJOR = A1_LOJA AND "
Cquery+= " D3_TM = '001' AND D3_ESTORNO = ' '  AND B1_TIPO <> 'MP' AND B8_SALDO <> 0 "


IF !EMPTY (MV_PAR01)
Cquery+= " AND D1.D1_X_CLIOR BETWEEN 	'"+MV_PAR01+"' AND '"+MV_PAR02+"' "
ENDIF
IF !EMPTY (MV_PAR03)
Cquery+= " AND B8.B8_PRODUTO BETWEEN 	'"+MV_PAR03+"' AND '"+MV_PAR04+"' "
ENDIF
IF !EMPTY (MV_PAR05)
Cquery+= " AND B8_LOTECTL BETWEEN		'"+MV_PAR05+"' AND '"+MV_PAR06+"' "
ENDIF

Cquery+= "  ORDER BY B8_LOTECTL "

TCQUERY cQuery NEW ALIAS "QSC6"
                    
dbSelectArea("QSC6") 

//dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()
While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
      @nLin,00  PSAY QSC6->C6_NUM 
      @nLin,07  PSAY QSC6->C6_ITEM 
      @nLin,12  PSAY QSC6->D1_X_CLIOR 
      @nLin,20  PSAY QSC6->D1_X_LOJOR  
      @nLin,25  PSAY QSC6->A1_NREDUZ 
      @nLin,46  PSAY QSC6->B8_PRODUTO
      @nLin,62  PSAY QSC6->B1_DESC 
      @nLin,89  PSAY QSC6->C6_NORMA 
      @nLin,111 PSAY QSC6->C6_PEDCLI
      @nLin,122 PSAY QSC6->C6_CODPROD
      @nLin,142 PSAY QSC6->B8_SALDO   PICTURE "@R 99.999"
      @nLin,155 PSAY QSC6->B8_LOTECTL
      @nLin,166 PSAY substr(QSC6->B8_LOCALIZ,1,3)
      @nLin,171 PSAY STOD(QSC6->C6_ENTREG)
      @nLin,182 PSAY STOD(QSC6->B8_DATA) 
      if (STOD(QSC6->C6_ENTREG) < dDatabase ) .and. ( STOD(QSC6->C6_ENTREG)-STOD(QSC6->B8_DATA) >= 0 )
        @nLin,194 PSAY ( STOD(QSC6->C6_ENTREG) - dDataBase)
        nDias :=( STOD(QSC6->C6_ENTREG) - dDataBase)
      else      
        @nLin,194 PSAY STOD(QSC6->C6_ENTREG)-STOD(QSC6->B8_DATA)
        nDias :=STOD(QSC6->C6_ENTREG)-STOD(QSC6->B8_DATA)
      endif  
      if STOD(QSC6->C6_ENTREG) >= dDatabase
	      if  STOD(QSC6->C6_ENTREG)-STOD(QSC6->B8_DATA) >= 0 
    	    @nLin,199 PSAY "DENTRO PRAZO"
    	    nStatus :="DENTRO PRAZO"
    	  else  
       	    @nLin,199 PSAY QSC6->B8_OBS
       	    nStatus :=QSC6->B8_OBS
	      endif  
      else
      	    @nLin,199 PSAY QSC6->B8_OBS
      	     nStatus :=QSC6->B8_OBS
      endif
      
      addreg1(QSC6->C6_NUM, QSC6->B1_DESC ,QSC6->C6_PEDCLI,QSC6->C6_CODPROD,QSC6->B8_SALDO,QSC6->B8_LOTECTL,STOD(QSC6->C6_ENTREG), STOD(QSC6->B8_DATA) ,ndias,nstatus)
   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo  
  
If MsgYesNo("Deseja exportar base para Excel?") 
TRB->(dbGoTop())
 U_ProcExcel("TRB")   
Endif   
QSC6->(dbCloseArea())
TRB->(dbCloseArea())
 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 
Static Function AjustaSX1(cPerg)

PutSX1(cPerg,"01","Do Cliente"	 	  		,"Do Cliente"     			,"Do Cliente"    		 	,"mv_ch5","C",6  ,0,0,"G","" 		,"SA1"     ,"","S"	,"mv_par01","","","","","","","","",""	,"","","","","","","",,,)
PutSX1(cPerg,"02","At้ Cliente"  			,"At้ Cliente" 				,"At้ Cliente" 				,"mv_ch6","C",6  ,0,0,"G",""		,"SA1"	   ,"","S"	,"mv_par02","","","","","","","","",""	,"","","","","","","",,,)
PutSX1(cPerg,"03","Do Produto"	 	  		,"Do Produto"     			,"Do Produto"    		 	,"mv_ch3","C",15 ,0,0,"G","" 		,"SB1"     ,"","S"	,"mv_par03","","","","","","","","",""	,"","","","","","","",,,)
PutSX1(cPerg,"04","At้ Produto"	 	  		,"At้ Produto"     			,"At้ Produto"    		 	,"mv_ch4","C",15 ,0,0,"G","" 		,"SB1"     ,"","S"	,"mv_par04","","","","","","","","",""	,"","","","","","","",,,)
PutSX1(cPerg,"05","Do Lote:"	 	  		,"Do Lote:"     			,"Do Lote:"     		 	,"mv_ch5","C",10 ,0,0,"G","" 		,""        ,"","S"	,"mv_par05","","","","","","","","",""	,"","","","","","","",,,)
PutSX1(cPerg,"06","At้ Lote:"	 	  		,"At้ Lote:"     			,"At้ Lote:"     		 	,"mv_ch6","C",10 ,0,0,"G","" 		,""        ,"","S"	,"mv_par06","","","","","","","","",""	,"","","","","","","",,,)
Return

Static function arqtmp()
Private _cArqEmp   := ""                                                      //Arquivo temporario com as empresas a serem escolhidas
Private _aStruTrb  := {}

// prepara arquivo temporario
aadd(_aStruTrb,{"OP"       ,"C",6,0})
aadd(_aStruTrb,{"PRODUTO"  ,"C",30,0})
aadd(_aStruTrb,{"PED_CLI"  ,"C",10,0})
aadd(_aStruTrb,{"PROD_CLI" ,"C",10,0})
aadd(_aStruTrb,{"PESO"     ,"N",15,3})
aadd(_aStruTrb,{"LOTE"     ,"C",15,0})
aadd(_aStruTrb,{"DT_PROG"  ,"D",8,0})
aadd(_aStruTrb,{"DT_PROD"  ,"D",8,0})
aadd(_aStruTrb,{"DIAS"     ,"N",8,0})
aadd(_aStruTrb,{"SITUACAO" ,"C",20,0})


_cArqEmp := CriaTrab(_aStruTrb)
dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")
Index on OP To &_cArqEmp
Return
       
Static Function AddReg1(OP,PRODUTO,PED_CLI,PROD_CLI,PESO,LOTE,DT_PROG,DT_PROD,;
                     DIAS,SITUACAO )
Local nAlias:=GetArea()
 dbselectarea("TRB")
  Begin Transaction                    
	Reclock("TRB",.T.)


        TRB->OP          := OP
        TRB->PRODUTO     := PRODUTO
        TRB->PED_CLI     := PED_CLI
        TRB->PROD_CLI    := PROD_CLI
        TRB->PESO        := PESO
        TRB->LOTE        := LOTE
        TRB->DT_PROG     := DT_PROG
        TRB->DT_PROD     := DT_PROD
        TRB->DIAS        := DIAS
        TRB->SITUACAO    := SITUACAO

       	Msunlock()
    End Transaction  
RestArea(nAlias)     	 
Return
