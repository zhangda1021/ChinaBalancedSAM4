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
	 OMN
	 EIS
	 MAN
	 WTR
         CON     
         TRN      
	 SER	
	 HHG	 Household + government	
/;

SET     f	Factors /cap,lab,res/,
        g	Goods and final demands/
        AGR     "Crop cultivation,Forestry,Livestock and livestock products and Fishery"
        COL     "Coal mining and processing"
        CRU     "Crude petroleum products"
        GAS     "natural gas products"
        OMN     "Metal minerals mining and Non-metal minerals and other mining"
        OIL     "Petroleum refining, coking and nuclear fuels"
        EIS     "Energy intensive industries"
	MAN	"Other manufacturing industries"
	ELE	"Electricity and heat"
	GDT	"Gas distribution"
	WTR	"Water"
	CON	"Construction"
	TRN	"Transport and Post"
	SER	"Service"
        c       "Private consumption"
        g       "Government"
        i       "Investment"
        /,
        i(g)    "Goods and sectors" /
	AGR
	COL
	CRU
	GAS
	OMN
	OIL
	EIS
	MAN
	ELE
	GDT
	WTR
	CON
	TRN
	SER
        /
	ind(i)/
	OMN,
	EIS,
	MAN,
	WTR/
	egy(i)/
	COL
	CRU
	OIL
	GAS
	ELE/
        ;
alias(i,j);

set      r Chinese provinces       /BJ,TJ,HE,SX,NM,LN,JL,HL,SH,JS,ZJ,AH,FJ,JX,SD,HA,HB,HN,GD,GX,HI,CQ,SC,GZ,YN,SN,GS,QH,NX,XJ/;

* Unit: 100 million tce
parameter egyadjusted(e,ebti,r),nh_prov(r),nh;
$gdxin '%inputfolder%\egyindest.gdx'
$load egyadjusted nh_prov
egyadjusted(e,ebti,r) = egyadjusted(e,ebti,r)/100;
display egyadjusted;

$ontext
parameter egychnadjusted(e,ebti);
egychnadjusted(e,ebti) = sum(r,egyadjusted(e,ebti,r));
egyconsadjusted(e) = sum(r,egyadjusted(e,"PROD",r) + egyadjusted(e,"DRC",r) + egyadjusted(e,"RC",r) -  egyadjusted(e,"DX",r) - egyadjusted(e,"X",r));
display egyconsadjusted;
$offtext


parameter 
	exr		 Exchange rate in 2007;
exr = 7.5215;


PARAMETERS
	vafm(i,g,r),
	vfm(f,i,r),
	vom(g,r),
	rto(i,r),
	vxm(i,r),
	vim(i,r),
	vdxm(i,r),
	vdim(i,r)
;

$gdxin '%inputfolder%\allsam.gdx'
$load vafm,vfm,vom,rto,vxm,vim,vdxm,vdim

*	Unit: 2007 million US dollar
vafm(i,g,r) = vafm(i,g,r) / 100 / exr; 
vfm(f,i,r) = vfm(f,i,r) / 100 / exr;
vom(g,r) = vom(g,r) / 100 / exr;
rto(i,r) = rto(i,r) / 100 / exr;
vxm(i,r) = vxm(i,r) / 100 / exr;
vim(i,r) = vim(i,r) / 100 / exr;
vdxm(i,r) = vdxm(i,r) / 100 / exr;
vdim(i,r) = vdim(i,r) /100 / exr;
display vafm,vfm,vom,rto,vxm,vim,vdxm,vdim;

parameter
	pricemargin(r,*);
$gdxin '%inputfolder%\pricemargin.gdx'
$load pricemargin
display pricemargin;

*	Unit: US dollar/ton
parameter
	pfob(i,r),
	pcif(i,r);
pfob("COL",r) = pricemargin(r,"COAL_PRICE") * 100 / exr;
pfob("CRU",r) = pricemargin(r,"OIL_PRICE") * 100 / exr;
pfob("OIL",r) = pricemargin(r,"ROIL_PRICE") * 100 / exr;
pfob("ELE",r) = pricemargin(r,"ELEH_PRICE") * 100 / exr;
pfob("GAS",r) = pricemargin(r,"NG_PRICE") * 100 / exr;

pcif("COL",r) = pfob("COL",r) + 2 * pricemargin(r,"COAL_MG") * 100 / exr;
pcif("CRU",r) = pfob("CRU",r);
pcif("OIL",r) = pfob("OIL",r);
pcif("GAS",r) = pfob("GAS",r);
pcif("ELE",r) = pfob("ELE",r);
display pfob,pcif;


set	s;
$gdxin '%inputfolder%\6reg.gdx'
$load	s=r
alias(s,ss);

*	GTAP unit: 2007 million US dollars
parameter 
	vxmd(i,s,ss)     Trade - bilateral exports at market prices,
        vst(i,s)         Trade - exports for international transportation
        vtwr(i,j,s,ss)   Trade - Margins for international transportation at world prices,
	rtms(i,s,ss)              Import tax rate,
	rtxs(i,s,ss)              Export tax rate;

$load vxmd,vst,vtwr,rtms,rtxs
display vxmd,vst,vtwr,rtms,rtxs;

parameter
        evd(i,g,s)              Volume of energy demand (mtoe),
        evt(i,s,ss)              Volume of energy trade (mtoe);
$load evd evt
evd(i,g,s)  = evd(i,g,s) * 1.4286;
evt(i,s,ss) = evt(i,s,ss) * 1.4286;

*----------------------------------------------------------*
*	Replace original energy related values in SAM      *
*----------------------------------------------------------*
set	mapgebti(g,ebti)/
	COL.COL
	CRU.CRU
	OIL.OIL
	GAS.GAS
	ELE.ELE
	AGR.AGR
	OMN.OMN
	EIS.EIS
	MAN.MAN
	WTR.WTR
	CON.CON
	TRN.TRN
	SER.SER
	c.HHG
/;
set	mapei(e,i)/
	coal.COL
	oil.CRU
	roil.OIL
	ng.GAS
	eleh.ELE
/;

parameter
	vom_egy(i,r),
	inputshr(*,i,r),
	totva(i,r);

*	Intermediate input
vafm(i,g,r)$(egy(i)) = sum((mapgebti(g,ebti),mapei(e,i)),egyadjusted(e,ebti,r)) * pcif(i,r);

*	Distribute value added to capital, labor and tax
totva(i,r) = vfm("cap",i,r) + vfm("lab",i,r) + rto(i,r);

vfm("cap",i,r)$(totva(i,r)<0) = 0;
vfm("lab",i,r)$(totva(i,r)<0) = 0;
rto(i,r)$(totva(i,r)<0) = 0;
totva(i,r)$(totva(i,r)<0) = 0;


inputshr("cap",i,r)$totva(i,r) = vfm("cap",i,r) / totva(i,r);
inputshr("lab",i,r)$totva(i,r) = vfm("lab",i,r) / totva(i,r);
inputshr("tax",i,r)$totva(i,r) = rto(i,r) / totva(i,r);

vom_egy(i,r) = sum(mapei(e,i),egyadjusted(e,"PROD",r)) * pcif(i,r);

*vfm("cap",egy,r) = (vom_egy(egy,r) - sum(j,vafm(j,egy,r))) * inputshr("cap",egy,r);
*vfm("lab",egy,r) = (vom_egy(egy,r) - sum(j,vafm(j,egy,r))) * inputshr("lab",egy,r);
*rto(egy,r) = (vom_egy(egy,r) - sum(j,vafm(j,egy,r))) * inputshr("tax",egy,r);



*	Trade
parameter 
	chnexp(i),
	chnimp(i);

chnexp(i) = sum(s,vxmd(i,"CHN",s)) + vst(i,"CHN");
chnimp(i) = sum(s,(vxmd(i,s,"CHN")*(1-rtxs(i,s,"CHN"))+sum(j,vtwr(j,i,s,"CHN")))*(1+rtms(i,s,"CHN")));


vxm(i,r)$sum(r.local,vxm(i,r)) = vxm(i,r) / sum(r.local,vxm(i,r)) * chnexp(i);
vim(i,r)$sum(r.local,vim(i,r)) = vim(i,r) / sum(r.local,vim(i,r)) * chnimp(i);

vxm(i,r)$(egy(i)) = sum((mapei(e,i)),egyadjusted(e,"X",r)) * pcif(i,r);
vim(i,r)$(egy(i)) = sum((mapei(e,i)),egyadjusted(e,"RC",r)) * pcif(i,r);

vdxm(i,r)$(egy(i)) = sum((mapei(e,i)),egyadjusted(e,"DX",r)) * pcif(i,r);
vdim(i,r)$(egy(i)) = sum((mapei(e,i)),egyadjusted(e,"DRC",r)) * pcif(i,r);	

display vafm,totva,vim,vxm,vdim,vdxm;


parameter negvalue;
negvalue(f,i,r) = yes$(vfm(f,i,r)<0);
display negvalue


*$exit

*----------------------------------------------*
*	Balance inter provincial energy data   *
*----------------------------------------------*

variables
      obj             Objective function;

positive variables
      totva_(i,r)        Calibrated value of value-added,
      vafm_(i,g,r)	 Calibrated value of vafm,
      vim_(i,r),
      vxm_(i,r),
      vdim_(i,r),
      vdxm_(i,r);

equations       objbal, totimp, totexp, dtrdbalance, 
 noplat,
mktclr;

scalar   penalty /1e2/,penalty2 /1e6/;


objbal..        obj =e= (sum((r,i),

      sum(g, (vafm(i,g,r) * sqr(vafm_(i,g,r)/vafm(i,g,r)-1))$vafm(i,g,r)) +
      totva(i,r) * sqr(totva_(i,r)/totva(i,r)-1)$(totva(i,r)) +
      vim(i,r) * sqr(vim_(i,r)/vim(i,r)-1)$(vim(i,r)) +
      vxm(i,r) * sqr(vxm_(i,r)/vxm(i,r)-1)$(vxm(i,r)) +
      vdim(i,r) * sqr(vdim_(i,r)/vdim(i,r)-1)$(vdim(i,r)) +
      vdxm(i,r) * sqr(vdxm_(i,r)/vdxm(i,r)-1)$(vdxm(i,r)) 
) +

*       Use linear penalty term on energy related values:

      penalty * sum((r,i)$egy(i),	
      sum(g, (vafm(i,g,r) * sqr(vafm_(i,g,r)/vafm(i,g,r)-1))$vafm(i,g,r)) +
      totva(i,r) * sqr(totva_(i,r)/totva(i,r)-1)$(totva(i,r)) +
      vim(i,r) * sqr(vim_(i,r)/vim(i,r)-1)$(vim(i,r)) +
      vxm(i,r) * sqr(vxm_(i,r)/vxm(i,r)-1)$(vxm(i,r)) +
      vdim(i,r) * sqr(vdim_(i,r)/vdim(i,r)-1)$(vdim(i,r)) +
      vdxm(i,r) * sqr(vdxm_(i,r)/vdxm(i,r)-1)$(vdxm(i,r)) 
) +

*       Use linear penalty term to impose sparsity:

      penalty2 * sum((r,i),
     sum(g, vafm(i,g,r)) +
      totva(i,r)  +
      vim(i,r)  +
      vxm(i,r)  +
      vdim(i,r) +
      vdxm(i,r) 
)	

) / 100000;


mktclr(i,r).. 
	sum(g, vafm_(i,g,r)) + vxm_(i,r) + vdxm_(i,r) =e=
	sum(j, vafm_(j,i,r)) + totva_(i,r) + vim_(i,r) + vdim_(i,r);

noplat(i,r)..
	sum(j, vafm_(j,i,r)) + totva_(i,r) =g= vxm_(i,r) + vdxm_(i,r);


totimp(i)..
	sum(r,vim_(i,r)) =e= sum(r,vim(i,r));

totexp(i)..
	sum(r,vxm_(i,r)) =e= sum(r,vxm(i,r));

dtrdbalance(i)..
	sum(r,vdim_(i,r)) =e= sum(r,vdxm_(i,r));


model calib /all/;

totva_.l(i,r)    = totva(i,r);
vafm_.l(i,g,r) = vafm(i,g,r);
vim_.l(i,r) = vim(i,r);
vxm_.l(i,r) = vxm(i,r);
vdim_.l(i,r) = vdim(i,r);
vdxm_.l(i,r) = vdxm(i,r);

*totva_.fx(i,r)$(totva_.l(i,r)=0)    = 0;
*vafm_.fx(i,g,r)$(vafm_.l(i,g,r)=0) =0; 
vim_.fx(i,r)$(vim_.l(i,r)=0) = 0;
vxm_.fx(i,r)$(vxm_.l(i,r)=0) = 0;
vdim_.fx(i,r)$(vdim_.l(i,r)=0) = 0;
vdxm_.fx(i,r)$(vdxm_.l(i,r)=0) = 0;


calib.solprint = no;
solve calib using nlp minimizing obj;


*$exit

parameter egycons;
egycons(r,"after") =
sum(g,vafm_.l("COL",g,r))/pcif("COL",r) + 
sum(g,vafm_.l("GAS",g,r))/pcif("GAS",r) + 
sum(g,vafm_.l("OIL",g,r))/pcif("OIL",r) + 
sum(g,vim_.l("ELE",r) + vdim_.l("ELE",r) - vxm_.l("ELE",r) - vdxm_.l("ELE",r))
/pcif("ELE",r) * 0.356/ 0.12 + 
nh_prov(r) * 0.356/ 0.12
;

display egycons;

execute_unload "b.gdx",egycons;

$call gdxxrw b.gdx par=egycons o=b.xls

$exit















$exit

