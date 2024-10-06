clear
set more off
set type double
drop _all

use "E:\OneDrive - unifesp.br\EPM Pesquisa\Epidemio Leandro\Stata 17\pns2019.dta"

*Comando para considerar amostragem complexa
svyset UPA_PNS [pweight=V0029], strata(V0024) poststrata(V00293) postweight(V00292) singleunit(centered)

*considerar apenas adultos (18 anos ou mais)
drop if C008 <= 17

*Categorizar IMCautof (peso e altura autoreferido - Final)
	*considerar apenas valores não ignorados
replace P00402 = . if P00402 == 2
replace P00102 = . if P00402 == 2
replace P00404= . if P00402  == 999
gen IMCautof = (P00104/((P00404)/100)^2)
*Ajustando newIMCauto para padrões definidos no Estudo JAHA
recode IMCautof (min/24.99999 = 0 "peso ok") (24.999999/29.99999 = 1 "sobrepeso") (30/39.99999 = 2 "obesidade") (40/max = 3 "obesidade severa"), gen (novoIMCautof)
label var novoIMCautof "IMC autoreferido"
tab novoIMCautof
svy: prop novoIMCautof

* Diabetes
gen diabetes = Q03001
label define simnao 1 "sim" 2 "não"
label var diabetes "diabetes"
label val diabetes simnao
tab diabetes

* Hipertensão
gen hipertensão = Q00201
label var hipertensão "hipertensão"
label val hipertensão simnao
tab hipertensão

*Insuficiência Cardíaca
gen insufcar = Q06306
label var insufcar "Insuficiência Cardíaca"
label val insufcar simnao
tab insufcar

*Doença Cardíaca incluindo Insuficiência Cardíaca
gen doencar = Q06309
label var doencar "Doença Cardíaca"
label val doencar simnao
tab doencar

*Categorizar covariates
*Sexo = C006
tab C006
svy: prop C006

*idade C008
sum C008, d

recode C008 (18/49 = 0 "18-49 anos") (50/64 = 1 "50-64 anos") (65/107 = 2 "65+ anos"), gen (faixeta)
tab faixeta
svy: prop faixeta

* Raça/cor da pele (recodificar)
recode C009 (1 = 1 "Branco") (2/5 = 2 "Não Branco"), gen (raca)
drop if raca == 6
label var raca "Raça/cor"
tab (raca)
svy: prop (raca)

*Loop entre exposições e Covariates
foreach exposure of varlist diabetes hipertensão doencar insufcar  {
	*Criação da lista de variáveis "covariates"
	foreach covariates of varlist faixeta raca C006  {
		svy: prop `exposure', over(`covariates')
} 
	
}
*Rodar análises para verificar proporção de Sim/Não para cada exposição, com IC95
foreach exposure of varlist diabetes hipertensão doencar insufcar  {
	svy: prop `exposure'
}
	
*Análises para IMC, excluindo grávidas
foreach IMC of varlist novoIMCautof   {
	foreach covariates of varlist faixeta raca C006  {
	svy: prop `IMC' if P005 != 1, over (`covariates')
}
}
	*Rodar análises para verificar proporção de Sim/Não para cada exposição, com IC95
	foreach IMC of varlist novoIMCautof  {
		svy: prop `IMC'
	}
	
