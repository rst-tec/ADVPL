#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "protheus.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} WFW004
Localização: Chamada via Schedule

Descrição: Workflow de notificação de Sugestão de Compras

@author Raphael Silva
@since 18/07/2024
@version P12

/*/
User Function RELB2D2()
	//Comente essa linha abaixo para testar o relatorio via menu. Comente também essa outra linha //RESET ENVIRONMENT	
	PREPARE ENVIRONMENT EMPRESA '77' FILIAL '02' FUNNAME "U_RELB2D2" MODULO "EST" 

	Private aAux		:= {} //Array Auxiliar
	Private aCanal      := {}
	Private aDados		:= {}
	Private aDevFatur	:= {}
	Private aFatExp	    := {}
	Private aDevExp	    := {}
	Private cMsgMail  	:= ''
	Private cMailConta	:= ''
	Private cMailServer := ''
	Private cMailSenha  := ''
	Private cMailCtaAut := ''
	Private cDest       := ''
	Private cSubject    := ''
	Private cMHTML       := ''
	Private cCodUser    := ''
	Private cCodArea    := ''
	Private cStatus
	Private cDescCliFoar
	Private aValor	    := Array(3)
	Private aTotCol	    := Array(6)
	Private nPos        := 0
	Private nCount      := 0
	Private lRet        := .F.
	Private lSendOk     := .F.
	Private lOk         := .F.
	Private lAuthOk     := .F.
	Private cMailWF		:= Alltrim(GETMV('M3_RELB2D2',, '')) //"raphael.silva@m3case.com.br"
	Private cBcc		:= "raphael.silva@m3case.com.br"
	Private cStartPath 	:= GetSrvProfString("Startpath","")

	lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
	cMailConta  := GETMV('MV_RELACNT',, '')
	cMailServer := GETMV('MV_RELSERV',, '')
	cMailSenha  := GETMV('MV_RELPSW',, '')
	cMailCtaAut := If(Empty(GETMV("MV_RELACNT",, '')), cMailConta, GETMV("MV_RELACNT",, ''))

	//--Log de Execução
	ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Processo Iniciado")
	ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Workflow - Relação de Estoque - Ultima Saida")

	cAttach := Exporta()

	ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Carregando layout Workflow RELB2D2")

	If cMailWF <> ' '
		// Assunto do E-mail
		cSubject := 'Bioscientific - Workflow - Relação de Estoque - Ultima Saida '

		cMHTML := ''
		cMHTML += '<table width="100%" border="0" cellspacing="1" cellpadding="0">'
		cMHTML += '	<tr>'
		cMHTML += '		<td align="center">
		cMHTML += ' 		<tr>'
		cMHTML += '				<td>&nbsp;</td>'
		cMHTML += ' 		</tr>'
		cMHTML += '			<tr>'
		cMHTML += '				<td><font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#FF0000"><b>Mensagem automatica, favor n&atilde;o responder este e-mail.</b></font></td>'
		cMHTML += '			</tr>'
		cMHTML += '		</td>'
		cMHTML += '	</tr>'
		cMHTML += '</table>


		//--Realiza o envio do e-mail:
		If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha) .And. !Empty(cMailCtaAut)

			//--Conecta ao servidor de e-mails:
			CONNECT SMTP SERVER cMailServer ACCOUNT cMailCtaAut PASSWORD cMailSenha RESULT lOk

			If lOk

				lAuthOk := If(lSmtpAuth, MailAuth(cMailCtaAut,cMailSenha), .T.)

				If lAuthOk

					ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Realizando envio de e-mail")
					ConOut("["+Dtoc(dDataBase)+" "+Time()+"] E-mail: "+cMailWF)

					SEND MAIL FROM cMailConta to cMailWF BCC cBcc SUBJECT cSubject BODY cMHTML ATTACHMENT cAttach RESULT lSendOk

					If lSendOk

						ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Enviado com sucesso")
						lRet := .T.

					Else

						//--Erro no envio do e-mail:
						lRet := .F.
						GET MAIL ERROR cMsgMail
						ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Erro: "+cMsgMail)

					EndIf

				Else
					//--Erro na autenticacao com o servidor SMTP:
					lRet := .F.
					GET MAIL ERROR cMsgMail
					ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Erro: "+cMsgMail)
				EndIf

				//--Desconecta do servidor SMTP:
				DISCONNECT SMTP SERVER

			Else
				//--Erro na conexao com o servidor SMTP:
				lRet := .F.
				GET MAIL ERROR cMsgMail
				ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Erro: "+cMsgMail)
			EndIf
		Else
			lRet := .F.
		EndIf
	Else
		lRet := .F.
		ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Não existe e-mails a serem notificados no parametro M3_RELB2D2")
	Endif
	ConOut("["+Dtoc(dDataBase)+" "+Time()+"] Processo finalizado")

	If File(cAttach)
		FErase(cAttach)
	EndIf
	
	//Comente essa linha abaixo para testar o relatorio via menu
	RESET ENVIRONMENT

Return

/*/{Protheus.doc} Exporta
Descrição: Exporta dados para planilha de Excel

@author Raphael Silva
@since 18/07/2024
@version P12

/*/
Static Function Exporta()
	
	Local x as Numeric
	Local y as Numeric

	Local cTable as Character
	Local cPlanilha as Character

	Local aDados as Array
	Local aExcel as Array

	Private cDirDoc  := "\system\"

	aExcel := {}
	aDados := RetSugestao()
	cTable := 'Relacao de Estoque - Ultima Saida'

	aAdd( aExcel, {"Filial",1,1})
	aAdd( aExcel, {"Produto",1,1})
	aAdd( aExcel, {"Descrição",1,1})
	aAdd( aExcel, {"Saldo Atual",1,1})
	aAdd( aExcel, {"Armazem",1,1})
	aAdd( aExcel, {"Tipo",1,1})
	aAdd( aExcel, {"Ultima Saida",1,4})
	aAdd( aExcel, {"Grupo",1,1})	
	
	oExcel 	   := FwMsExcelXlsx():New()
	cPlanilha := "RELB2D2"
	oExcel:AddWorkSheet( cPlanilha )
			oExcel:AddTable( cPlanilha, cTable )
			For y:=1 to len(aExcel)
				oExcel:AddColumn( cPlanilha, cTable , aExcel[y,1] , 1 , aExcel[y,2] )
			Next y
	For x:=1 to len(aDados)		
		oExcel:AddRow( cPlanilha, cTable, { ;
		aDados[x][1],;
		aDados[x][2],;
		aDados[x][3],;
		aDados[x][4],;
		aDados[x][5],;
		aDados[x][6],;
		aDados[x][7],;
		aDados[x][8];	
		})
	Next x

	oExcel:Activate()
	cArq := "Relacao_de_Estoque_Ultima_Saida_"+ DtoS(Date()) + "_" + StrTran(Time(), ":", "-") +".xlsx"
	oExcel:GetXMLFile(cArq)

	cAnexo := cDirDoc+cArq

Return(cAnexo)

/*/{Protheus.doc} RetSugestao
Descrição: Retorna dados da sugestão de compra em um Array

@author Raphael Silva
@since 18/07/2024
@version P12

/*/
Static Function RetSugestao()

Local cAliasQry as Character
Local aRet as Array

aRet 	  := {}
cAliasQry := GetNextAlias()

BeginSql alias cAliasQry

SELECT DISTINCT D2_FILIAL, D2_COD, 
(SELECT B1_DESC FROM SB1770 WHERE D2_COD = B1_COD AND SB1770.D_E_L_E_T_ = ' ') AS B1_DESC, 
B2_QATU, B2_LOCAL, D2_TP,D2_EMISSAO, 
(SELECT B1_GRUPO FROM SB1770 WHERE D2_COD = B1_COD AND SB1770.D_E_L_E_T_ = ' ') AS B1_GRUPO 
FROM SD2770 AS SD2770
INNER JOIN SB2770 ON SD2770.D2_COD = SB2770.B2_COD 
AND SD2770.D2_FILIAL = SB2770.B2_FILIAL 
AND SD2770.D2_LOCAL = SB2770.B2_LOCAL 
WHERE SD2770.D_E_L_E_T_ = ' ' AND SB2770.D_E_L_E_T_ = ' '
AND B2_FILIAL = '02'
AND D2_TP NOT IN ('EB','MP')
AND D2_EMISSAO = 
   ( SELECT MAX(D2_EMISSAO)
  FROM SD2770 AS tmp
  WHERE tmp.D2_COD = SD2770.D2_COD
  AND tmp.D_E_L_E_T_ = ' ')
  ORDER BY D2_EMISSAO DESC
EndSQL

	While (cAliasQry)->(!Eof())
		
		AAdd(aRet,;
			{Alltrim((cAliasQry)->D2_FILIAL),;
			Alltrim((cAliasQry)->D2_COD),;
			Alltrim((cAliasQry)->B1_DESC),;		
			(cAliasQry)->B2_QATU,;
			(cAliasQry)->B2_LOCAL,;
			(cAliasQry)->D2_TP,;					
			(StoD((cAliasQry)->D2_EMISSAO)),; // Convertendo data
			(cAliasQry)->B1_GRUPO;
			})
		(cAliasQry)->(DbSkip()) 
	EndDo

(cAliasQry)->(DbCloseArea())

Return aRet
