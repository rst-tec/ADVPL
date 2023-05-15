#INCLUDE "topconn.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*------------------------------------------------------------------------//
//Programa:	NFCANC02
//Autor:	Raphael Silva
//Data:		21/09/2022
//Descricao: Notas Canceladas
//------------------------------------------------------------------------*/
User Function NFCANC02()
Local cPerg    := PADR("SF2",10)
Local oExcel 	:= NIL
Local cArq 		:= ""
Local cDir 		:= GetSrvProfString("Startpath","")
Local cWorkSheet:= ""
Local cTable 	:= ""
Local cDirTmp 	:= GetTempPath()
Local aExcel	:= {}
Local bQuery 	:= {|| Iif(Select("TRB") > 0, TRB->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.) , dbSelectArea("TRB") }
Local i
Local nCount    := 0
Private bValid := {|| Iif(ApOleClient("MsExcel"),.T.,(MsgInfo("MsExcel não instalado"),.f.)) }


Pergunte(cPerg,.T.)

_cQuery :=" SELECT F3_NFISCAL,F3_CLIEFOR,F3_LOJA,F3_FILIAL,F3_SERIE,F3_ENTRADA, F3_VALCONT,F3_TIPO, F3_DTCANC, F3_USERLGA, F3_OBSERV, F3_DESCRET " 
_cQuery += "FROM "+RetSqlName("SF3")+" SF3"
_cQuery +=" WHERE D_E_L_E_T_ ='' "
_cQuery +=" AND F3_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
_cQuery +=" AND F3_FILIAL  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
_cQuery +=" AND F3_DTCANC <> '' "
_cQuery +=" GROUP BY F3_FILIAL,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_VALCONT,F3_TIPO,F3_DTCANC, F3_USERLGA, F3_OBSERV, F3_DESCRET "

Processa(Eval(bQuery) , "Aguarde...", "Executando consulta ao Banco de Dados...",.F.)
TcSetField("TRB", "F3_ENTRADA", "D")
TcSetField("TRB", "F3_DTCANC", "D")

//Ajusta a regua de processamento
dbSelectArea("TRB") 
TRB->( dbGotop() )
//Processa( TRB->(dbEval({|| nCount++ },, {|| !EOF() })), "Aguarde...", "Calculando processamento dos dados...",.F.)
Processa( dbEval({|| nCount++ },, {|| TRB->(!EOF()) }), "Aguarde...", "Calculando processamento dos dados...",.F.)
TRB->( dbGotop() )
ProcRegua(nCount) //Total de Registros encontrado no arquivo

cTexto := 'Notas Canceladas '

aAdd( aExcel, {"Filial",1}) 
aAdd( aExcel, {"Cliente",1}) 
aAdd( aExcel, {"Loja",1})
aAdd( aExcel, {"Nota Fiscal",1}) 
aAdd( aExcel, {"Serie",1}) 
aAdd( aExcel, {"Emissão",1})  
aAdd( aExcel, {"Cancelamento",1})  
aAdd( aExcel, {"Valor",1})  
aAdd( aExcel, {"Observação",1})  
//aAdd( aExcel, {"Descrição",1})  

cWorkSheet := 'NF. Canceladas'
cTable     := cTexto
oExcel := FWMsExcel():New()
oExcel:AddWorkSheet( cWorkSheet )
oExcel:AddTable( cWorkSheet, cTable )	

For i:=1 to len(aExcel)
	oExcel:AddColumn( cWorkSheet, cTable , aExcel[i,1] , 1 , aExcel[i,2] )
Next i

While !EOF()

//	IncProc()
	oExcel:AddRow( cWorkSheet, cTable, { ;
   	TRB->F3_FILIAL,;
   	TRB->F3_CLIEFOR,;
	TRB->F3_LOJA,; 
	TRB->F3_NFISCAL,;      	
	TRB->F3_SERIE,;  
	DTOC(TRB->F3_ENTRADA),; 	
	DTOC(TRB->F3_DTCANC),; 	
	TRB->F3_VALCONT,;
   	TRB->F3_OBSERV})		
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

oExcel:Activate()
cArq := CriaTrab( NIL, .F. ) + ".xml"
Processa( {|| oExcel:GetXMLFile( cArq ) }, "Gerando o arquivo, aguarde..." )

lRet := ExistDir("c:\Relat")
//lRet := ExistDir("d:\temp")
nRet := 0

If !lRet
	nRet := MakeDir("c:\Relat")
	If nRet != 0
    	MsgInfo ( "Não foi possível criar o diretório - C:\Relat\. Erro: " + cValToChar( FError() ) )
  	EndIf
Endif
If nRet == 0
	If __CopyFile( cArq, "c:\Relat\" + cArq )
		If Eval(bValid)
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( "c:\Relat\" + cArq )
			oExcelApp:SetVisible(.T.)
		Else
			MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretório " + "c:\Relat" )
		Endif
	Else
		MsgInfo( "Arquivo não copiado para a pasta c:\Relat" )
	Endif
Endif	

DbSelectArea("TRB")
DbCloseArea("TRB")

Return NIL
