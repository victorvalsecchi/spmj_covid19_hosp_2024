clear all
import delimited "E:\OneDrive - unifesp.br\EPM Pesquisa\Epidemio Leandro\sivep_SRAG_2020.csv"

recode nu_idade_n (0/17 = 1 "Ate 18") (18/49 = 2 "18-49") (50/65 = 3 "50-65") (65/122 = 4 "65 ou mais") (else= 5 "ignorado"), gen (cs_idade)
tab cs_idade
drop if cs_idade == 1
tab cs_idade

encode cs_sexo, gen (cs_sexo_n)
recode cs_sexo_n (1 = 2 "Feminino") (3 = 1 "Masculino") (2 = 9 "Ignorado"), gen (cs_sexo_n2)
label variable cs_sexo_n2 "Sexo"
tab cs_sexo_n2

label define cs_raca 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indígena" 9 "Ignorado"
label values cs_raca cs_raca
label variable cs_raca "Raça/Cor"
tab cs_raca

recode cs_raca (1 = 1 "Branco") (2/5 = 2 "Não-Branco") (9 = 9 "Ignorado") (. = 9 "Ignorado"), gen (cs_raca2)
tab cs_raca2

label define hospital 1 "Sim" 2 "Não" 9 "Ignorado"
label values hospital hospital
label variable hospital "Internação?"
tab hospital

label define uti 1 "Sim" 2 "Nao" 9 "Ignorado"
label values uti uti
label variable uti "Foi pra UTI?"
tab uti

label define classi_fin 1 "SRAG-Influenza" 2 "SRAG-OutroVirus" 3 "SRAG-OutroAg" 4 "SRAG-NaoEsp" 5 "Ignorado"
label values classi_fin classi_fin
label variable classi_fin "Definição"
tab classi_fin

recode classi_fin (1/3 = 1 "SRAG - Outro Agente") (4 = 2 "SRAG - CoViD-19") (5 = 3 "SRAG - Causa Não Identificada"), gen (definicao)

recode hospital (1 = 1 "Internado") (2/9 = 2 "Não internado"), gen (internado)
replace internado = . if internado == 2

recode uti (1 = 1 "UTI") (2/9 = 2 "Enfermaria"), gen (uti2)

tab definicao internado
tab definicao uti

gen internacaocovid=.
replace internacaocovid=1 if definicao==2 & hospital==1
label define internacaocovid 1 "COVID Internado"
tab internacaocovid
tab internacaocovid cs_sexo_n2
tab internacaocovid cs_raca2
tab internacaocovid cs_idade

gen internados_todos=.
replace internados_todos=1 if definicao==2 & internado==1
replace internados_todos=1 if definicao==3 & internado==1
label define internados_todos 1 "SRAG Internados"
tab internados_todos
tab internados_todos cs_sexo_n2
tab internados_todos cs_raca2
tab internados_todos cs_idade

