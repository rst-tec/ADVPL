#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//+------------+------------+--------+--------------------------------------------+
//| Função:    | MYTELA     | Data   | 02/07/2021                                 | 
//+------------+------------+--------+--------------------------------------------+
//| Autor:     | Raphael Silva                                                    | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Tela para testar meus programas                                  |
//+------------+------------+--------+--------------------------------------------+

User Function MYTELA

	SetPrvt("oDlg1","oGrp1","oSay1","oBtn1","oGrp2","oSay2","oBtn2","oGrp3","oSay3","oBtn3","oGrp4","oSay4")
	SetPrvt("oGrp5","oSay5","oBtn5","oGrp6","oSay6","oBtn6","oGrp7","oSay7","oBtn7","oGrp8","oSay8","oBtn8")

	oDlg1      := MSDialog():New( 128,256,725,898,"MyTela",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 008,012,036,304,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 020,064,{||"Programa para alterar dados do pedido de venda"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn1      := TButton():New( 016,020,"Executar",oGrp1,{||U_ALTPESO()},037,012,,,,.T.,,"",,,,.F. )

	oGrp2      := TGroup():New( 041,013,069,305,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 053,065,{||"Programa para informar data de lavagem de tecido na Speroto"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn2      := TButton():New( 049,021,"Executar",oGrp2,{||U_lavar()},037,012,,,,.T.,,"",,,,.F. )

	oGrp3      := TGroup():New( 077,013,105,305,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay3      := TSay():New( 089,065,{||"Programa para executar fonte em Desenvolvimento "},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn3      := TButton():New( 085,021,"Executar",oGrp3,{||U_xFormula()},037,012,,,,.T.,,"",,,,.F. )

	oGrp4      := TGroup():New( 109,013,137,305,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay4      := TSay():New( 121,065,{||"Programa para alterar dados da Nota fiscal"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn4      := TButton():New( 117,021,"Executar",oGrp4,{||U_ALTSF2()},037,012,,,,.T.,,"",,,,.F. )

	oGrp5      := TGroup():New( 145,013,173,305,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay5      := TSay():New( 157,065,{||"Informe aqui os dados do seu programa - 5"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn5      := TButton():New( 153,021,"Executar",oGrp5,{||alert("Botão 05")},037,012,,,,.T.,,"",,,,.F. )

	oGrp6      := TGroup():New( 178,014,206,306,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay6      := TSay():New( 190,066,{||"Informe aqui os dados do seu programa - 6"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn6      := TButton():New( 186,022,"Executar",oGrp6,{||alert("Botão 06")},037,012,,,,.T.,,"",,,,.F. )

	oGrp7      := TGroup():New( 214,014,242,306,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay7      := TSay():New( 226,066,{||"Informe aqui os dados do seu programa - 7"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn7      := TButton():New( 222,022,"Executar",oGrp7,{||alert("Botão 07")},037,012,,,,.T.,,"",,,,.F. )

	oGrp8      := TGroup():New( 246,014,274,306,,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay8      := TSay():New( 258,066,{||"Informe aqui os dados do seu programa - 8"},oGrp8,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oBtn8      := TButton():New( 254,022,"Executar",oGrp8,{||alert("Botão 08")},037,012,,,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)

Return

