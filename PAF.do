********************************************************************************
*********************** Calculate PAF/PIF estimates ****************************
********************************************************************************

import excel "E:\OneDrive - unifesp.br\EPM Pesquisa\Epidemio Leandro\banco_cardiometabolica_covid_LR.xlsx", sheet("PAF") firstrow


/* POPULATION IMPACT FRACTIONS 
 This estimate will represent the different counterfactual scenarios created


			∑ Pi RRi - ∑ P'i RRi
	PIF =   ____________________
				
				  ∑ Pi RRi

Where:
- Pi is the proportion of the population at the level i of physical activity;
- P'i is the proportion of the population at the level i of physical activity 
  in the counterfactual scenario;
- RRi is the relative risk at the level i of physical activity

*/


forvalues i = 0/3 {
gen pifa`i' = p`i'*rr`i'
gen pifb`i' = p`i'_sce*rr`i'
}

egen pifa = rowtotal(pifa0 pifa1 pifa2 pifa3)
egen pifb = rowtotal(pifb0 pifb1 pifb2 pifb3)

gen pif = (pifa-pifb)/pifa

drop pifa1-pifb


/* JOINT POTENTIAL IMPACT FRACTIONS


	PIF JOINT = 1- ∏(1- PIFi)

in which PIFi is the PIF for individual risk factors.

*/

// Calculate PIF JOINT ALL EXPOSURES by cancer site
gen step1 = 1-pif
bysort covariate : gen pifjoint = sum(ln(step1))
by covariate : replace pifjoint = exp(pifjoint[_N])
replace pifjoint = 1-pifjoint
drop step1


// in Stata format.
export excel using "E:\OneDrive - unifesp.br\EPM Pesquisa\Epidemio Leandro\paf_results.xls", firstrow(variables) replace

