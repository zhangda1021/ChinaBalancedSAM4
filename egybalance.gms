$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\'

*SAM table
set     e        energy product  /
         coal    Coal,
         oil     Crude oil,
         roil    Refined oil,
         ng      Natural gas,
         eleh    Electricity & heat,
         othe    Other energy/;

set	 ebti0    accounts /
         PROD    Production,
         DX      Domestic outflow,
         X       Export,
         DRC     Domestic inflow,
         RC      Import,
         COALT   Coal converted from other energy product,
         FGT     Fuel gas converted from other energy product,
         OILT    Crude oil converted from other energy product,
         ROILT   Refined oil converted from other energy product,
         NGT     Natural gas converted from other energy productconverted from other energy product,
         ELEHT   Electricity & heat converted from other energy product,
         OTHET   Other energy converted from other energy product,
         AGR     Agriculture,
         IND     Industry,
         CON     Construction,
         TR      Transportation,
         WRHR    Wholesale & retail & hotel & restraurant,
         OTH     Other service industry,
         FU      Final use,
         INV     Inventory change
	 ERR	 Error term/;

set	 ebti	/
         PROD    Production,
         DX      Domestic outflow,
         X       Export,
         DRC     Domestic inflow,
         RC      Import,
         COL     
         CRU	 
         OIL     
         GAS     
         ELE      
         AGR     
         IND     
         CON     
         TRN      
	 SER	
	 HHG	 Household + government	
/;

set      r Chinese provinces       /BJ,TJ,HE,SX,NM,LN,JL,HL,SH,JS,ZJ,AH,FJ,JX,SD,HA,HB,HN,GD,GX,HI,CQ,SC,GZ,YN,SN,GS,QH,NX,XJ/;

parameter egyprov(e,r,ebti0),egybench(e,ebti0,*),egy_prov(e,ebti,r),egy_bench(e,ebti),nh_prov(r),nh;

$gdxin '%inputfolder%\rawegy\egymerged.gdx'
$load egyprov

$gdxin '%inputfolder%\egybench\egybenchmerged.gdx'
$load egybench

egyprov(e,r,"INV") = egyprov(e,r,"INV");
egybench(e,"INV","value") = egybench(e,"INV","value") * (-1);
egybench(e,"ERR","value") = egybench(e,"ERR","value") * (-1);

*display egyprov,egybench;

set     g(*)    Goods plus C and G;
$gdxin '%inputfolder%\6reg.gdx'
$load g

set     s	/CHN,USA,EUR,ODC,ROW/,
	i(g)    Goods;
$load i
	
alias(s,ss);
	
parameter
        evd(i,g,s)              Volume of energy demand (mtoe),
        evt(i,s,ss)              Volume of energy trade (mtoe);

$load evd evt

parameter
	egychnimp(e),
	egychnexp(e);

egychnimp("coal") = sum(s,evt("COL",s,"CHN")) * 1.4286 * 100;
egychnimp("oil") = sum(s,evt("CRU",s,"CHN")) * 1.4286 * 100;
egychnimp("roil") = sum(s,evt("OIL",s,"CHN")) * 1.4286 * 100;
egychnimp("ng") = sum(s,evt("GAS",s,"CHN")) * 1.4286 * 100;
egychnimp("eleh") = sum(s,evt("ELE",s,"CHN")) * 1.4286 * 100;

egychnexp("coal") = sum(s,evt("COL","CHN",s)) * 1.4286 * 100;
egychnexp("oil") = sum(s,evt("CRU","CHN",s)) * 1.4286 * 100;
egychnexp("roil") = sum(s,evt("OIL","CHN",s)) * 1.4286 * 100;
egychnexp("ng") = sum(s,evt("GAS","CHN",s)) * 1.4286 * 100;
egychnexp("eleh") = sum(s,evt("ELE","CHN",s)) * 1.4286 * 100;


set	mapiebti0(ebti,ebti0)/
	PROD.PROD   
	DX.DX   
	X.X   
	DRC.DRC   
	RC.RC   
	COL.COALT   
	CRU.OILT	
	OIL.ROILT 
	GAS.NGT 
	ELE.ELEHT    
	ELE.OTHET
	AGR.AGR    
	IND.IND    
	CON.CON    
	TRN.TR    
	SER.WRHR
	SER.OTH
	HHG.FU
	IND.INV
	PROD.ERR/;

set	mapiebti0_prov(ebti,ebti0)/
	PROD.PROD   
	DX.DX   
	X.X   
	DRC.DRC   
	RC.RC   
	COL.COALT   
	CRU.OILT	
	OIL.ROILT 
	GAS.NGT 
	ELE.ELEHT    
	ELE.OTHET
	AGR.AGR    
	IND.IND    
	CON.CON    
	TRN.TR    
	SER.WRHR
	SER.OTH
	HHG.FU
	IND.INV
	PROD.ERR/;

*	Aggregation of provincial energy data
egy_prov(e,ebti,r) = sum(mapiebti0_prov(ebti,ebti0),egyprov(e,r,ebti0));

egy_prov("coal","PROD",r) = egy_prov("coal","PROD",r) + egy_prov("coal","COL",r);
egy_prov("oil","PROD",r) = egy_prov("oil","PROD",r) + egy_prov("oil","CRU",r);	
egy_prov("roil","PROD",r) = egy_prov("roil","PROD",r) + egy_prov("roil","OIL",r);
egy_prov("ng","PROD",r) = egy_prov("ng","PROD",r) - egy_prov("ng","GAS",r);	
nh_prov(r) = egy_prov("eleh","PROD",r);
egy_prov("eleh","PROD",r) = egy_prov("eleh","PROD",r) + egy_prov("eleh","ELE",r);

egy_prov("coal","COL",r) = 0;
egy_prov("oil","CRU",r)	 = 0;
egy_prov("roil","OIL",r) = 0;
egy_prov("ng","GAS",r)   = 0;
egy_prov("eleh","ELE",r) = 0;
*display egy_prov;
 
parameter testBalance;
testBalance(e,r) = 2* (egy_prov(e,"PROD",r) + egy_prov(e,"DRC",r) + egy_prov(e,"RC",r)) - sum(ebti,egy_prov(e,ebti,r));
testBalance(e,r)$(testBalance(e,r)<1e-4) = 0;
display testBalance;

egy_prov(e,ebti,r)$(abs(egy_prov(e,ebti,r))<1e-2) = 0;

*	Energy consumption data by province
parameter egycons(r,*);
egycons(r,"before") = egy_prov("coal","PROD",r) + egy_prov("coal","DRC",r) + egy_prov("coal","RC",r) -  egy_prov("coal","DX",r) - egy_prov("coal","X",r)
+ egy_prov("ng","PROD",r) + egy_prov("ng","DRC",r) + egy_prov("ng","RC",r) -  egy_prov("ng","DX",r) - egy_prov("ng","X",r)
+ egy_prov("roil","PROD",r) + egy_prov("roil","DRC",r) + egy_prov("roil","RC",r) -  egy_prov("roil","DX",r) - egy_prov("roil","X",r)
* Electricity import
+ (egy_prov("ELEH","DRC",r) + egy_prov("ELEH","RC",r) -  egy_prov("ELEH","DX",r) - egy_prov("ELEH","X",r)) * 0.356/ 0.12
* Hydro and nuclear generation
+ nh_prov(r) * 0.356/ 0.12
* Other energy
* + egy_prov("othe","PROD",r) + egy_prov("othe","DRC",r) + egy_prov("othe","RC",r) -  egy_prov("othe","DX",r) - egy_prov("othe","X",r)
;


*	Aggregation of national benchmark energy data

egy_bench(e,ebti) = sum(mapiebti0(ebti,ebti0),egybench(e,ebti0,"value"));

egy_bench("coal","PROD") = egy_bench("coal","PROD") + egy_bench("coal","COL");
egy_bench("oil","PROD") = egy_bench("oil","PROD") + egy_bench("oil","CRU");	
egy_bench("roil","PROD") = egy_bench("roil","PROD") + egy_bench("roil","OIL");
egy_bench("ng","PROD") = egy_bench("ng","PROD") + egy_bench("ng","GAS");	
nh = egy_bench("eleh","PROD"); 
egy_bench("eleh","PROD") = egy_bench("eleh","PROD") + egy_bench("eleh","ELE");

egy_bench("coal","COL") = 0;
egy_bench("oil","CRU")  = 0;
egy_bench("roil","OIL") = 0;
egy_bench("ng","GAS")   = 0;
egy_bench("eleh","ELE") = 0;
*display egy_bench;

parameter egyconschn;
egyconschn = 
egy_bench("coal","PROD") + egy_bench("coal","DRC") + egy_bench("coal","RC") -  egy_bench("coal","DX") - egy_bench("coal","X")
+ egy_bench("ng","PROD") + egy_bench("ng","DRC") + egy_bench("ng","RC") -  egy_bench("ng","DX") - egy_bench("ng","X")
+ egy_bench("roil","PROD") + egy_bench("roil","DRC") + egy_bench("roil","RC") -  egy_bench("roil","DX") - egy_bench("roil","X")
* Electricity import
+ (egy_bench("ELEH","DRC") + egy_bench("ELEH","RC") -  egy_bench("ELEH","DX") - egy_bench("ELEH","X")) * 0.356/ 0.12
* Hydro and nuclear generation
+ nh * 0.356/ 0.12
* Other energy
* + egy_bench("othe","PROD") + egy_bench("othe","DRC") + egy_bench("othe","RC") -  egy_bench("othe","DX") - egy_bench("othe","X")
;



parameter testBalanceBench;
testBalanceBench(e) = 2 * (egy_bench(e,"PROD") + egy_bench(e,"DRC") + egy_bench(e,"RC")) - sum(ebti,egy_bench(e,ebti));
testBalanceBench(e)$(testBalanceBench(e)<1e-2) = 0;
display testBalanceBench;

*	Move all negative value to production
egy_prov(e,"PROD",r) = egy_prov(e,"PROD",r) - sum(ebti$(egy_prov(e,ebti,r)<0),egy_prov(e,ebti,r));
egy_prov(e,ebti,r)$(egy_prov(e,ebti,r)<0) = 0;

*	All positive values now for the provincial EBT
parameter negvalue(e,ebti,r);
negvalue(e,ebti,r) = yes$(egy_prov(e,ebti,r)<0);
display negvalue;


parameter scale;
*scale = sum(r,egycons(r,"after")) / egyconschn;
scale = 1.185;


*----------------------------------------------*
*	Balance provincial energy data	       *
*----------------------------------------------*
parameter 	
	egy_provsum(e,ebti)	Pronvincial sum data,
	lamda			Panalty parameter;

egy_provsum(e,ebti) = sum(r,egy_prov(e,ebti,r));
*If provincial sum is equal to zero, set the benchmark value to zero
egy_bench(e,ebti)$(egy_provsum(e,ebti)=0) = 0;

lamda = 0.1;

positive variable
	x(e,ebti,r)	Adjusted provincial EBT	value;

variable
	j		Objective function;

Equation
	obj,
	benchind(e),
	benchimp(e),
	benchexp(e),
	balance(e,r),
	trade(e);

* Scale the bench: provincial sum / national value = 1.185

obj..
	j =e= 0.001* sum(e,sum((r,ebti)$(egy_prov(e,ebti,r)>1e-5), egy_prov(e,ebti,r) * power(x(e,ebti,r)/egy_prov(e,ebti,r)-1,4))) 
+ lamda * sum(e,sum(ebti$((not((sameas(ebti,"DRC") or (sameas(ebti,"DX")) or (sameas(ebti,"IND")) or (sameas(ebti,"RC")) or (sameas(ebti,"X"))))) and (egy_bench(e,ebti)>1e-5)),
(egy_bench(e,ebti)*scale) * power((sum(r,x(e,ebti,r))/(egy_bench(e,ebti)*scale) - 1),4)))

+ 0.1 * sum(r,egycons(r,"before") * power(
(x("coal","PROD",r) + x("coal","DRC",r) + x("coal","RC",r) -  x("coal","DX",r) - x("coal","X",r)
+ x("ng","PROD",r) + x("ng","DRC",r) + x("ng","RC",r) -  x("ng","DX",r) - x("ng","X",r)
+ x("roil","PROD",r) + x("roil","DRC",r) + x("roil","RC",r) -  x("roil","DX",r) - x("roil","X",r)
+ (x("ELEH","DRC",r) + x("ELEH","RC",r) -  x("ELEH","DX",r) - x("ELEH","X",r)) * 0.356/ 0.12)/egycons(r,"before")-1,4));


benchind(e)..
	sum(r,x(e,"IND",r)) =e= egy_bench(e,"IND") * scale;

benchimp(e)..
	sum(r,x(e,"RC",r)) =e= egychnimp(e) * scale;

benchexp(e)..
	sum(r,x(e,"X",r)) =e= egychnexp(e) * scale;

balance(e,r)..
	2*((x(e,"PROD",r) + x(e,"DRC",r) + x(e,"RC",r))) =e= sum(ebti,x(e,ebti,r));

trade(e)..
	sum(r,x(e,"DX",r)) =e= sum(r,x(e,"DRC",r));
	
x.l(e,ebti,r) = egy_prov(e,ebti,r);
*x.l(e,ebti,r)$(not((sameas(ebti,"DRC") or (sameas(ebti,"DX")))))= egy_prov(e,ebti,r)/egy_provsum(e,ebti)*egy_bench(e,ebti);
x.fx(e,ebti,r)$(x.l(e,ebti,r)=0) = 0;
* Fix energy use in transportation and final use
x.fx(e,"TRN",r)=x.l(e,"TRN",r);
x.fx(e,"HHG",r)=x.l(e,"HHG",r);


Model	gua /all/;
gua.iterlim=1000;
Solve gua minimizing j using nlp;

egycons(r,"after") = 
 x.l("coal","PROD",r) + x.l("coal","DRC",r) + x.l("coal","RC",r) -  x.l("coal","DX",r) - x.l("coal","X",r)
+ x.l("ng","PROD",r) + x.l("ng","DRC",r) + x.l("ng","RC",r) -  x.l("ng","DX",r) - x.l("ng","X",r)
+ x.l("roil","PROD",r) + x.l("roil","DRC",r) + x.l("roil","RC",r) -  x.l("roil","DX",r) - x.l("roil","X",r)
* Electricity import
+ (x.l("ELEH","DRC",r) + x.l("ELEH","RC",r) -  x.l("ELEH","DX",r) - x.l("ELEH","X",r)) * 0.356/ 0.12
* Hydro and nuclear generation
+ nh_prov(r) * 0.356/ 0.12
* Other energy
* + x.l("othe","PROD",r) + x.l("othe","DRC",r) + x.l("othe","RC",r) -  x.l("othe","DX",r) - x.l("othe","X",r)
;

display egycons;


parameter egyadjusted(e,ebti,r);
egyadjusted(e,ebti,r)=x.l(e,ebti,r)/scale;

egycons(r,"after") = egycons(r,"after") /scale;
parameter egychnadjusted(e,ebti);
egychnadjusted(e,ebti) = sum(r,egyadjusted(e,ebti,r));
display egychnadjusted;


parameter egyconsadjusted(e);
egyconsadjusted(e) = sum(r,egyadjusted(e,"PROD",r) + egyadjusted(e,"DRC",r) + egyadjusted(e,"RC",r) -  egyadjusted(e,"DX",r) - egyadjusted(e,"X",r));
display egyconsadjusted,egychnimp,egychnexp;

*$exit

execute_unload "a.gdx",egycons;

$call gdxxrw a.gdx par=egycons o=a.xls

$exit
