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
         IND     
	 OMN
	 EIS
	 MAN
	 WTR
         CON     
         TRN      
	 SER	
	 HHG
/;

SET     f	Factors /cap,lab/,
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
        ;
alias(i,j);

set      r Chinese provinces       /BJ,TJ,HE,SX,NM,LN,JL,HL,SH,JS,ZJ,AH,FJ,JX,SD,HA,HB,HN,GD,GX,HI,CQ,SC,GZ,YN,SN,GS,QH,NX,XJ/;

parameter egyadjusted(e,ebti,r),nh_prov(r),nh;
$gdxin '%inputfolder%\egybalance.gdx'
$load egyadjusted

PARAMETERS
	vafm(i,g,r)
;

$gdxin '%inputfolder%\allsam.gdx'
$load vafm

*	Estimate disaggregated energy use
PARAMETERS indshr(e,ind,r);

indshr("coal",ind,r) = vafm("COL",ind,r) / sum(ind.local,vafm("COL",ind,r));
indshr("oil",ind,r)$(sum(ind.local,vafm("CRU",ind,r))) = vafm("CRU",ind,r) / sum(ind.local,vafm("CRU",ind,r));
indshr("ng",ind,r)$(sum(ind.local,vafm("CRU",ind,r))) = vafm("CRU",ind,r) / sum(ind.local,vafm("CRU",ind,r));
indshr("roil",ind,r) = vafm("OIL",ind,r) / sum(ind.local,vafm("OIL",ind,r));
indshr("eleh",ind,r) = vafm("ELE",ind,r) / sum(ind.local,vafm("ELE",ind,r));
indshr("othe",ind,r) = vafm("ELE",ind,r) / sum(ind.local,vafm("ELE",ind,r));

indshr(e,ind,r)$(indshr(e,ind,r)<0.001) = 0;

egyadjusted(e,"OMN",r) =  egyadjusted(e,"IND",r) * indshr(e,"OMN",r);
egyadjusted(e,"EIS",r) =  egyadjusted(e,"IND",r) * indshr(e,"EIS",r);
egyadjusted(e,"MAN",r) =  egyadjusted(e,"IND",r) * indshr(e,"MAN",r);
egyadjusted(e,"WTR",r) =  egyadjusted(e,"IND",r) * indshr(e,"WTR",r); 

egyadjusted(e,"IND",r) = 0;

PARAMETERS indcons(ebti);
indcons(ebti) = sum(r,egyadjusted("COAL",ebti,r) + egyadjusted("ROIL",ebti,r) + egyadjusted("NG",ebti,r) +egyadjusted("ELEH",ebti,r)+ egyadjusted("OTHE",ebti,r));
display indcons;

*	Estimate hh and gov energy use (No government energy use)


$EXIT


