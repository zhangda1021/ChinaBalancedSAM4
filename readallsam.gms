*	READ PROVINCIAL SAM TABLE (UNIT:10,000 yuan)

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\rawsam'

set     r	Chinese provinces       /BJ,TJ,HE,SX,NM,LN,JL,HL,SH,JS,ZJ,AH,FJ,JX,SD,HA,HB,HN,GD,GX,HI,CQ,SC,GZ,YN,SN,GS,QH,NX,XJ/;

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
        ;
alias(i,j);

set     ri   raw data rows indices   /1*49/;
set     rj   raw data columns indices /1*58/;

parameter rawsam(r,ri,rj)  Base year  data
$gdxin '%inputfolder%\merged.gdx'
$load rawsam

*	Sector mapping
set	mapiri(ri,i)/
	1.AGR,
	2.COL,
	3.CRU,
	4.OMN,
	5.OMN,
	6.MAN,
	7.MAN,
	8.MAN,
	9.MAN,
	10.MAN,
	11.OIL,
	12.EIS,
	13.EIS,
	14.EIS,
	15.MAN,
	16.MAN,
	17.MAN,
	18.MAN,
	19.MAN,
	20.MAN,
	21.MAN,
	22.MAN,
	23.ELE,
	24.GDT,
	25.WTR,
	26.CON,
	27.TRN,
	28.TRN,
	29.SER,
	30.SER,
	31.SER,
	32.SER,
	33.SER,
	34.SER,
	35.SER,
	36.SER,
	37.SER,
	38.SER,
	39.SER,
	40.SER,
	41.SER,
	42.SER
/;

SET mapjrj(rj,j)/
	1.AGR,
	2.COL,
	3.CRU,
	4.OMN,
	5.OMN,
	6.MAN,
	7.MAN,
	8.MAN,
	9.MAN,
	10.MAN,
	11.OIL,
	12.EIS,
	13.EIS,
	14.EIS,
	15.MAN,
	16.MAN,
	17.MAN,
	18.MAN,
	19.MAN,
	20.MAN,
	21.MAN,
	22.MAN,
	23.ELE,
	24.GDT,
	25.WTR,
	26.CON,
	27.TRN,
	28.TRN,
	29.SER,
	30.SER,
	31.SER,
	32.SER,
	33.SER,
	34.SER,
	35.SER,
	36.SER,
	37.SER,
	38.SER,
	39.SER,
	40.SER,
	41.SER,
	42.SER
/;


PARAMETERS
	vafm(i,g,r),
	vfm(f,i,r),
	vom(g,r),
	rto(i,r),
	vxm(i,r),
	vim(i,r),
	vdxm(i,r),
	vdim(i,r),
	resid(i,r)
;

vafm(i,j,r) = sum((mapiri(ri,i),mapjrj(rj,j)),rawsam(r,ri,rj));
vafm(i,"c",r) = sum(mapiri(ri,i),rawsam(r,ri,"46"));
vafm(i,"g",r) = sum(mapiri(ri,i),rawsam(r,ri,"47"));
*	Ignore inventory 
vafm(i,"i",r) = sum(mapiri(ri,i),rawsam(r,ri,"49"));

vfm("lab",j,r) = sum(mapjrj(rj,j),rawsam(r,"44",rj));
vfm("cap",j,r) = sum(mapjrj(rj,j),rawsam(r,"46",rj)+rawsam(r,"47",rj));

rto(j,r) = sum(mapjrj(rj,j),rawsam(r,"45",rj));
	
vxm(i,r) = sum(mapiri(ri,i),rawsam(r,ri,"52"));
vim(i,r) = sum(mapiri(ri,i),rawsam(r,ri,"55"));
vdxm(i,r) = sum(mapiri(ri,i),rawsam(r,ri,"53"));
vdim(i,r) = sum(mapiri(ri,i),rawsam(r,ri,"56"));

*	Put inventory in the residual
resid(i,r) = sum(mapiri(ri,i),rawsam(r,ri,"57")+rawsam(r,ri,"50"));

*	If capital input is negative, set it to zero and distribute the negative terms on labor input and tax
vfm("lab",i,r)$(vfm("cap",i,r)<0) = vfm("lab",i,r) + vfm("cap",i,r) * vfm("lab",i,r) / (vfm("lab",i,r) + rto(i,r));
rto(i,r)$(vfm("cap",i,r)<0) = rto(i,r) + vfm("cap",i,r) * rto(i,r) / (vfm("lab",i,r) + rto(i,r));
vfm("cap",i,r)$(vfm("cap",i,r)<0) = 0;

*	Adjust capital input in OIL in Gansu 
vfm("lab","OIL","GS") = 0;
rto("OIL","GS") = 0;

display resid;


$exit