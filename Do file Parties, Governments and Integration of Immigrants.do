
*Setting of panel structure*
xtset iso3n year

*Creation of employment gap variable*
generate nativeforeignbornemploymentgap= nativebornemploymentrateoecd - foreignbornemploymentrateoecd


*Creation of unemployment gap variable* 
generate foreignnativeunemploymentgap= unemploymentrateforeignborn - unemploymentratenative


*Creating of asylumseekers inflow as share of population variable*
generate asylumseekersinflowsharepop= (inflowasylumseekersoecd/1000)/pop

*Generate foreignborn as share of population*
generate foreignbornsharepop = foreignbornpopulationnumbersoecd / (pop*1000)


*Generate refugees as share of population*
generate refugeesharepop = refugees/ (pop*1000)

*Creating the singepartygovernment dummy*
generate singlepartygov=0
replace singlepartygov=1 if herfgov==1
replace singlepartygov=. if herfgov==.

*Creating the minority goverment dummy*
generate minoritygov=0
replace minoritygov=1 if maj<0.5
replace minoritygov=. if maj==.

*Generate singlepartymajoritygovernment dummy*
generate singlepartymajoritygov=0
replace singlepartymajoritygov=1 if singlepartygov==1 & minoritygov==0 
replace singlepartymajoritygov=. if maj==. 
replace singlepartymajoritygov=. if herfgov==.

*Creation of total seat share of rightist (far right) parties*
generate seatshareright= sright1 + sright2+ sright3+ sright4+ sright5

*Figure 1. Plotting the share of countries*
bysort year : egen year_mean = mean(foreignbornsharepop) 
twoway (line year_mean year, lcolor(black)),graphregion(color(white))legend (off) xtitle(Year) ytitle(Share of population foreign born)  ylabel(, format(%9.2f))  xlabel(1995 2000 2005 2010 2013), if year >= 1995

twoway (line year_mean year, lcolor(black)),graphregion(color(white))legend (off) xtitle(Year) ytitle(Share of population foreign born) title(Share of population foreign born OECD)  ylabel(, format(%9.2f))  xlabel(1995 2000 2005 2010 2013), if year >= 1995

*Some cases*
graph bar nativeforeignbornemploymentgap, over (country) ytitle("Native-foreign born employment gap 2013") yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) graphregion(color(white))legend (off)  , if year==2013 & countryn==36 | countryn==35 | countryn== 33 | countryn==13 | countryn==12

*Figure 2: Vizualization of cases*
graph hbar nativeforeignbornemploymentgap, over (iso, sort(nativeforeignbornemploymentgap) descending) bar(1, color(black)) graphregion(color(white))legend (off) ytitle("Native-foreign born employment gap 2013") , if year==2013 & nativeforeignbornemploymentgap!=.




twoway (line nativeforeignbornemploymentgap year, lcolor(black)),graphregion(color(white))legend (off) xtitle(Year) ytitle(Native-foreign born employment gap)    xlabel( 2000 2005 2010 2013), if year >= 2000 & countryn==1
twoway (line nativeforeignbornemploymentgap year, lcolor(black)),graphregion(color(white))legend (off) xtitle(Year) ytitle(Native-foreign born employment gap)  yline(0, lstyle(grid) lcolor(gs8) lpattern(dash)) xlabel( 2000 2005 2010 2013), if year >= 2000 & countryn==32

*Calculation of average single-party majority government*
bysort country: egen average_singlepartymajgov = mean(singlepartymajoritygov) if inrange(year, 2000,2012)



*Setting of panel structure*
xtset iso3n year






*Table 1:Effect of singleparty majoritygov on employment gap* 
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 unemp gdpgrowthrateoecd   i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd   i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1  outlays unemp gdpgrowthrateoecd refugeesharepop  i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)


* Table 2: Effect of singleparty majoritygov on unemploymentemployment gap* 
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 unemp gdpgrowthrateoecd   i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd   i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1  outlays unemp gdpgrowthrateoecd refugeesharepop   i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)



*Foot note: Alternative measure of welfare generosity 
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 us100 uc1000 unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1  us100 uc1000 unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)

*Footnote : number of countries with variation*
sort country
by country: sum singlepartymajoritygov if nativeforeignbornemploymentgap!=. & effpar_leg!=. 

*Setting of panel structure*
xtset iso3n year


*Appendix A: Descriptive statistics* 
xtsum nativeforeignbornemploymentgap foreignnativeunemploymentgap singlepartymajoritygov effpar_leg gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop if nativeforeignbornemploymentgap!=. & effpar_leg!=. 


*Appendix B: Absolute measures of integration*
xtreg foreignbornemploymentrateoecd l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
xtreg unemploymentrateforeignborn  l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)


*Appendix C: One year lag*
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)



*Appendix D : Control for native employment rate*
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 nativebornemploymentrateoecd outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)

* Figure 3 & appendix E: Graphing for effect before and after take-over by single-party majority government: Employment gap*
generate shift=0
replace shift=1 if singlepartymajoritygov==1 & l.singlepartymajoritygov==0
replace shift=. if singlepartymajoritygov==. 

generate distancesinglemaj=0
replace distancesinglemaj=4 if shift==1 
replace distancesinglemaj=1 if f3.shift==1
replace distancesinglemaj= 2 if f2.shift==1 
replace distancesinglemaj= 3 if f.shift==1
replace distancesinglemaj=5 if l.shift==1
replace distancesinglemaj=6 if l2.shift==1
replace distancesinglemaj=7 if l3.shift==1
replace distancesinglemaj=. if shift==. 

xtreg nativeforeignbornemploymentgap i.distancesinglemaj l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
margins distancesinglemaj
marginsplot,  level(90) ytitle(Predicted employment gap) xtitle(Years from single-party majority government takeover)  xlabel(0 "All other years" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "+1" 6 "+2" 7 "+3") yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  legend (off)   scheme(s1mono) plot1opts(lpattern(dot)) 


*Figure 3 & appendix E: Graphing for effect before and after take-over by single-party majority government: Unemployment gap*
xtreg foreignnativeunemploymentgap i.distancesinglemaj l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n)
margins distancesinglemaj
marginsplot,  level(90) ytitle(Predicted unemployment gap) xtitle(Years from single-party majority government takeover)  xlabel(0 "All other years" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "+1" 6 "+2" 7 "+3") ylabel (0 1 2 3 4 5) yline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  legend (off)   scheme(s1mono) plot1opts(lpattern(dot)) 

*Appendix F: Random effects*
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, re cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, re cluster( iso3n)


*Appendix F: Jackknife test employment gap*
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n) vce(jackknife)

*Appendix F: Jackknife test unemployment gap*
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n) vce (jackknife)


*Figure F*
xtline singlepartymajoritygov , t(year) i(country)  ytitle("Single-party majority government")  xtitle("Year") xlabel(1998 2002 2006  2010  2013) graphregion(color(white)) legend(off), if year>1997 & year<2014 & f2.nativeforeignbornemploymentgap!=. | nativeforeignbornemploymentgap!=.



*Appendix F: Removal of both US and UK: 
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=35 &  countryn!=36
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=35 &  countryn!=36


*Appendix F: Control for seat share of rightwing parties* 
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop  refugeesharepop  l2.seatshareright i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright i.year, fe cluster( iso3n)


* Appendix F: Removal of all countries without variation on the independent variable* 
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn==1 | countryn==5 | countryn==14 | countryn==15 | countryn==18 | countryn==28 | countryn==30 | countryn==32 | countryn==35 | countryn==36 
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn==1 | countryn==5 | countryn==14 | countryn==15 | countryn==18 | countryn==28 | countryn==30 | countryn==32 | countryn==35 | countryn==36 


*Appendix F : Manuel jackknife test employment gap*
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=1
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=2
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=3
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=4
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=5
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=6
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=7
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=8
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=9
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=10
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=11
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=12
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=13
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=14
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=15
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=16
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=17
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=18
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=19
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=20
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=21
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n), if countryn!=22
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=23
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n), if countryn!=24
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=25
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=26
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=27
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=28
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=29
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=30
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=31
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=32
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=33
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=34
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=35
xtreg nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=36

*Appendix F : Manuel jackknife unemployment gap*
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=1
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=2
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=3
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=4
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=5
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=6
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=7
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=8
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=9
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=10
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=11
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=12
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=13
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=14
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=15
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=16
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=17
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=18
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=19
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=20
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=21
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=22
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=23
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=24
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=25
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=26
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=27
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=28
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=29
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=30
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=31
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=32
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=33
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=34
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=35
xtreg foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=36

*Appendix F: lagged dependent variables 
tabulate year, gen(year)

xtreg nativeforeignbornemploymentgap l.nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  l2.seatshareright  i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright  i.year, fe cluster( iso3n)



xtreg nativeforeignbornemploymentgap l.nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  l2.seatshareright  i.year, re cluster( iso3n)
xtreg foreignnativeunemploymentgap l.foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright  i.year, re cluster( iso3n)


reg nativeforeignbornemploymentgap l.nativeforeignbornemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  l2.seatshareright,   cluster( iso3n)
reg foreignnativeunemploymentgap l.foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright,   cluster( iso3n)

xtreg nativeforeignbornemploymentgap l.nativeforeignbornemploymentgap  l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright i.year, fe cluster( iso3n) vce(jackknife)

xtreg foreignnativeunemploymentgap l.foreignnativeunemploymentgap l2.singlepartymajoritygov l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l2.seatshareright i.year, fe cluster( iso3n) vce (jackknife)


* Figure G1: Plot between immigrant labor market access and single-party majority-government*
twoway (scatter access_mipex l2.average_singlepartymajgov ) (lfit  access_mipex l2.average_singlepartymajgov, lcolor(black) ), graphregion(color(white))legend (off)  ytitle("Immigrant access to national labor market 2014")  xtitle("Average single-party majority government, 2000-2012") xlabel(, format(%9.1f))


*_____________________________Alternative  estimations not in the article__________________________________________________________________________________*

*Using government fragmentation instead*
xtreg nativeforeignbornemploymentgap l2.govfrac l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l2.govfrac l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)

*Coefficients plots with test*
generate laggedsingle= l2.singlepartymajoritygov


xtreg nativeforeignbornemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n)
estimates store employ
xtreg foreignnativeunemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n)
estimates store unemploy

coefplot (employ, label(Effect on employment gap)) (unemploy, label(Effect on unemployment gap)),keep(laggedsingle) xlabel(0 -1 -2 -3 -4 -5 -6) xline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  ylabel(none)  legend(size(small)) title("Effect of single-party majority government on labor market gaps ", size(*.8)) levels( 95 90) graphregion(color(white))



xtreg nativeforeignbornemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
estimates store employ1
xtreg nativeforeignbornemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l.seatshareright i.year, fe cluster( iso3n)
estimates store employ2
xtreg nativeforeignbornemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n), if countryn!=35 &  countryn!=36
estimates store employ3

coefplot (employ1, label(Controlling for immigrant population characteristics)) (employ2, label(Controlling for seat share of far-right parties)) (employ3, label(Removal of UK & US)),keep(laggedsingle)coeflabels( laggedsingle= "Single-party majority government") xlabel(0 -1 -2 -3 -4 -5 -6) xline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  ylabel(none)  legend(size(small)) title("Effect of single-party majority government on employment gap ", size(*.8)) levels( 95 90) graphregion(color(white))



xtreg foreignnativeunemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop i.year, fe cluster( iso3n)
estimates store unemploy1
xtreg foreignnativeunemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop l.seatshareright i.year, fe cluster( iso3n)
estimates store unemploy2
xtreg foreignnativeunemploymentgap laggedsingle l2.effpar_leg l2.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop refugeesharepop  i.year, fe cluster( iso3n), if countryn!=35 &  countryn!=36
estimates store unemploy3

coefplot (unemploy1, label(Controlling for immigrant population characteristics)) (unemploy2, label(Controlling for seat share of far-right parties)) (unemploy3, label(Removal of UK & US)),keep(laggedsingle)coeflabels( laggedsingle= "Single-party majority government") xlabel(0 -1 -2 -3)  xline(0, lstyle(grid) lcolor(gs8) lpattern(dash))  ylabel(none)  legend(size(small)) title("Effect of single-party majority government on unemployment gap ", size(*.8)) levels( 95 90) graphregion(color(white))



*_______________________Alternative specifications________________________*


*Robustness tests for the before and after specification: Control for far-right parties and jack-knife*
xtreg nativeforeignbornemploymentgap i.distancesinglemaj l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop  l.seatshareright i.year, fe cluster( iso3n)

xtreg foreignnativeunemploymentgap i.distancesinglemaj l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop l.seatshareright i.year, fe cluster( iso3n)

xtreg nativeforeignbornemploymentgap i.distancesinglemaj  l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop i.year, fe cluster( iso3n) vce(jackknife)

xtreg foreignnativeunemploymentgap i.distancesinglemaj  l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop i.year, fe cluster( iso3n) vce (jackknife)


*Longer distances in grapching the effect of single-party majority takeover*
generate distancesinglemaj2=0
replace distancesinglemaj2=5 if shift==1 
replace distancesinglemaj2=1 if f4.shift==1
replace distancesinglemaj2=2 if f3.shift==1
replace distancesinglemaj2= 3 if f2.shift==1 
replace distancesinglemaj2= 4 if f.shift==1
replace distancesinglemaj2=6 if l.shift==1
replace distancesinglemaj2=7 if l2.shift==1
replace distancesinglemaj2=8 if l3.shift==1
replace distancesinglemaj2=9 if l4.shift==1
replace distancesinglemaj2=. if shift==. 

xtreg  nativeforeignbornemploymentgap  i.distancesinglemaj2 l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop  i.year, fe cluster( iso3n)
margins distancesinglemaj2
marginsplot,  level(90) ytitle(Predicted employment gap) xtitle(Years from single-party majority government takeover)  xlabel(0 "All other years" 1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "+1" 7 "+2" 8 "+3" 9 "4") legend (off)   scheme(s1mono) 

xtreg foreignnativeunemploymentgap i.distancesinglemaj2 l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop  i.year, fe cluster( iso3n)
margins distancesinglemaj2
marginsplot,  level(90) ytitle(Predicted employment gap) xtitle(Years from single-party majority government takeover)  xlabel(0 "All other years" 1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "+1" 7 "+2" 8 "+3" 9 "4") legend (off)   scheme(s1mono) 


*Use of government Goverment fractionaliztion instead of single-party majority government*
xtreg nativeforeignbornemploymentgap  l.govfrac l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop l.seatshareright i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.govfrac l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop l.seatshareright i.year, fe cluster( iso3n)



*Excluding postcommunist countries*
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop  i.year, fe cluster( iso3n), if iso3n!=196 & iso3n!=233 & iso3n!=348 & iso3n!=616 & iso3n!=703 & iso3n!=705
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg l.gov_left1 outlays unemp gdpgrowthrateoecd  foreignbornsharepop asylumseekersinflowsharepop  i.year, fe cluster( iso3n), if iso3n!=196 & iso3n!=233 & iso3n!=348 & iso3n!=616 & iso3n!=703 & iso3n!=705


* Effect of singleparty majoritygov on employment gap with labor market characteristics (bad controls?) and union density* 

xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd  adjcov l.gov_left1 asylumseekersinflowsharepop foreignbornsharepop i.year, fe cluster( iso3n)

xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg  l.gov_left1 asylumseekersinflowsharepop foreignbornsharepop i.year, fe cluster( iso3n)

xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg  adjcov l.gov_left1 asylumseekersinflowsharepop foreignbornsharepop i.year, fe cluster( iso3n)

xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd ud l.gov_left1 asylumseekersinflowsharepop foreignbornsharepop i.year, fe cluster( iso3n)

generate uniondensitysquared= ud^2
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd ud uniondensitysquared l.gov_left1 asylumseekersinflowsharepop foreignbornsharepop i.year, fe cluster( iso3n)


* Effect of singleparty and majoritygov dummies on employment gap* 
xtreg nativeforeignbornemploymentgap l.singlepartygov l.minoritygov l.effpar_leg unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartygov l.minoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartygov l.minoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartygov l.minoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartygov l.minoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 asylumseekersinflowsharepop i.year, fe cluster( iso3n)


* Effect of singleparty majoritygov on unemployment gap* 
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg foreignnativeunemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 asylumseekersinflowsharepop i.year, fe cluster( iso3n)



* Effect of singleparty majoritygov on employment gap using right seats instead of left seats* 
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg unemp gdpgrowthrateoecd  l.gov_right1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd  l.gov_right1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd adjcov l.gov_right1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_right1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap l.singlepartymajoritygov l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_right1 asylumseekersinflowsharepop i.year, fe cluster( iso3n)



*Pure effect of partisan fragmentation*
xtreg nativeforeignbornemploymentgap  l.effpar_leg unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap  l.effpar_leg outlays unemp gdpgrowthrateoecd  l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap  l.effpar_leg outlays unemp gdpgrowthrateoecd adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap  l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 i.year, fe cluster( iso3n)
xtreg nativeforeignbornemploymentgap  l.effpar_leg outlays unemp gdpgrowthrateoecd emprot_reg adjcov l.gov_left1 asylumseekersinflowsharepop i.year, fe cluster( iso3n)



