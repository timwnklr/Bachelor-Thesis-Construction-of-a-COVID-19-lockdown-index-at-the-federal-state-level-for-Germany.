clear
cd "/Users/timwnklr/Desktop/BA/BA_Tim_Winkler/Stata"
import excel using df_panel_BA_Tim.xlsx, firstrow

//create panel
encode fed, generate(fed_n)
xtset fed_n date



//Fixed-effects (within) regression
xtreg mobility Stringency infections_log temp i.weekday i.summer_holi, fe
estimate store fe5

//FE Hausman test
xtreg mobility Stringency infections_log temp i.weekday i.summer_holi, re
estimate store re5
hausman fe5 re5



//drop Berlin
drop if fed == "Berlin"

//Random-effects GLS regression
xtreg mobility Stringency infections_log i.weekday temp i.summer_holi WFH i.West Poverty_2020 Income, re 
estimate store re6

//RE Hausman test
xtreg mobility Stringency infections_log i.weekday temp i.summer_holi  WFH i.West Poverty_2020 Income, fe 
estimate store fe6

hausman fe6 re6



//Breusch and Pagan Lagrangian multiplier test for random effects
xtreg mobility Stringency infections_log i.weekday temp i.summer_holi WFH i.West Poverty_2020 Income, re 
xttest0

//robustness check for mulicollinearity
reg mobility Stringency infections_log temp i.weekday i.summer_holi i.fed_n, robust 
estat vif
reg mobility Stringency infections_log i.fed_n, robust 
estat vif



