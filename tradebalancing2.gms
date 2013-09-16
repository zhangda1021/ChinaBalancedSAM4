
*-------------------------------------------------------------------
*       CHECK ENERGY TRADE DATA
*-------------------------------------------------------------------
parameter 
	pricemargin_(r_,i_),
	pricemargin(r,i_);

$gdxin '%inputfolder%/pricemargin.gdx'
$load	pricemargin_=pricemargin
$gdxin
pricemargin(r,i_)=sum(mapr(r_,r),pricemargin_(r_,i_));

* Price seen by exporter is different from price seen by importer, the price difference 
* is taken by the transport service provider. 
* This happens when estimating bilateral (domestic) trade flows. 
* For domestic export, value (vxmd, not aggregated export value sam(r,j,"62")) should be divided by expprice.

parameter price(r,i),expprice(r,i);
price(r,"2")=pricemargin(r,"2")+2*pricemargin(r,"4");
price(r,"3")=pricemargin(r,"3")+2*pricemargin(r,"6");
price(r,"4")=pricemargin(r,"30")+2*pricemargin(r,"60");
price(r,"11")=pricemargin(r,"11")+2*pricemargin(r,"22");
price(r,"20")=pricemargin(r,"23")+2*pricemargin(r,"46");
price(r,"21")=pricemargin(r,"24")+2*pricemargin(r,"48");

expprice(r,"2")=pricemargin(r,"2");
expprice(r,"3")=pricemargin(r,"3");
expprice(r,"4")=pricemargin(r,"30");
expprice(r,"11")=pricemargin(r,"11");
expprice(r,"20")=pricemargin(r,"23");
expprice(r,"21")=pricemargin(r,"24");

parameter evx,evi;

evx(i,r)$(price(r,i))=sum(mapij(i,j),sam4(r,j,"63"))*7.5215*10/expprice(r,i);
evi(i,r)$(price(r,i))=sum(mapij(i,j),sam4(r,"63",j))*7.5215*10/expprice(r,i);

parameter totimpc,totimpg,totexpc,totexpg;

totimpc(i)=sum(r,evi(i,r));

totexpc(i)=sum(r,evx(i,r));

display totimpc,totexpc;


parameter evd,eco2;
evd("2",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"28",j)*7.5215/(price(r,"2"))*10;
evd("3",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"29",j)*7.5215/(price(r,"3"))*10;
evd("4",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"30",j)*7.5215/(price(r,"4"))*10;
evd("11",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"37",j)*7.5215/(price(r,"11"))*10;
evd("21",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"47",j)*7.5215/(price(r,"21"))*10;
evd("20",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"46",j)*7.5215/(price(r,"20"))*10;
eco2("2",j,r)=evd("2",j,r)*2.66;
eco2("3",j,r)=evd("3",j,r)*2.02;
eco2("4",j,r)=evd("4",j,r)*1.47;
eco2("11",j,r)=evd("11",j,r)*2.02;
eco2("21",j,r)=evd("21",j,r)*1.47;
eco2("2","11",r)=0;
eco2("2","21",r)=0;
eco2("3","11",r)=0;
eco2("3","21",r)=0;
eco2("4","11",r)=0;
eco2("4","21",r)=0;

parameter 
	totco2(i),
	totco2chnc;
totco2(i)=sum((j,r),eco2(i,j,r));
totco2chnc=sum(i,totco2(i));
display totco2chnc;

*$exit

*-------------------------------------------------------------------
*       Read GTAP data:
*-------------------------------------------------------------------
set tp_(i)/25/;

parameter       vxmd(i,rs,sr)              Trade - bilateral exports at market prices;
parameter       vst_(tp_,rs)		     Exported transportation service;
parameter       vtwr_(tp_,i,rs,sr)	     Trade margin;
parameter       rtms(i,rs,sr)              Import tax rate;
parameter       rtxs(i,rs,sr)              Export tax rate;


$gdxin '%inputfolder%/chinamodel2.gdx'
$load vxmd
$load vst_=vst
$load vtwr_=vtwr
$load rtms
$load rtxs
$gdxin

parameter       vxmdexp(i)              China's export by sector;
vxmdexp(i)=sum(rs,vxmd(i,"CHN",rs));
parameter       vxmdimp(i)              China's import by sector;
vxmdimp(i)=sum(rs,vxmd(i,rs,"CHN"));
display vxmdexp,vxmdimp;




*----------------------------------------------------------------------------------
*       DISTRIBUTION OF IMPORT AND EXPORT DATA
*----------------------------------------------------------------------------------
* Find the sector which has positive imp/exp in GTAP, but zero in China data
set	simpi(i),sexpi(i);
parameter	chntotexp(i);
parameter	chntotimp(i);
loop(i,
loop(j$(ord(j)=ord(i)+26),
chntotexp(i)=sum(r,sam4(r,j,"63"));
if((chntotexp(i)=0) and (vxmdexp(i)>0),
sexpi(i)=yes;
);
);
);
loop(i,
loop(j$(ord(j)=ord(i)+26),
chntotimp(i)=sum(r,sam4(r,"63",j));
if((chntotimp(i)=0) and (vxmdimp(i)>0),
simpi(i)=yes;
);
);
);

display chntotexp,chntotimp;
display simpi,sexpi;

* Fix the imp/exp problem
parameter isupply(r);
parameter itotsupply;
loop(i$(simpi(i)),
loop(j$(ord(j)=ord(i)+26),
isupply(r)=sam4(r,i,j);
* Should use consumption data... that is more reasonable
itotsupply=sum(r,isupply(r));
sam4(r,"63",j)=vxmdimp(i)/itotsupply*isupply(r);
);
);


loop(i$(sexpi(i)),
loop(j$(ord(j)=ord(i)+26),
isupply(r)=sam4(r,i,j);
itotsupply=sum(r,isupply(r));
sam4(r,j,"63")=vxmdexp(i)/itotsupply*isupply(r);
);
);



* Calculation of China's import and export by sector from China data
parameter vim_(j,rs);
vim_(j,rs)$((ord(j)>=27) and (ord(j)<=52))=sam4(rs,"63",j);
parameter vxm_(i,rs);
vxm_(j,rs)$((ord(j)>=27) and (ord(j)<=52))=sam4(rs,j,"63");
parameter vim(i,rs);
vim(i,rs)=sum(mapij(i,j),vim_(j,rs));
parameter vxm(i,rs);
vxm(i,rs)=sum(mapij(i,j),vxm_(j,rs));

parameter totvim(i),totvxm(i);
totvim(i)=sum(rs,vim(i,rs));
totvxm(i)=sum(rs,vxm(i,rs));

* Distribute national import and export among provinces
vxmd(i,rs,sr)$(province(rs) and gtapregions(sr))=vxmd(i,"CHN",sr)/sum(rsrsrs,(vxm(i,rsrsrs)))*vxm(i,rs);
vxmd(i,rs,sr)$(province(sr) and gtapregions(rs) and (sum(rsrsrs,(vim(i,rsrsrs)))))=vxmd(i,rs,"CHN")/sum(rsrsrs,(vim(i,rsrsrs)))*vim(i,sr);
*display vxmd;

vxmd(i,"CHN",r)=0;
vxmd(i,r,"CHN")=0;

* Adjustment of SAM table
sam4(r,j,"63")$((ord(j)>=27) and (ord(j)<=52))=sum(mapij(i,j),sum(s,vxmd(i,r,s)));
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sum(mapij(i,j),sum(s,vxmd(i,s,r)*(1-rtxs(i,s,"CHN"))));



*----------------------------------------------------------------------------------
*       DISTRIBUTION OF TRADE MARGIN
*----------------------------------------------------------------------------------
parameter       vtwr(i,rs,sr)         Trade margin;
vtwr(i,rs,sr)=sum(tp_,vtwr_(tp_,i,rs,sr));


vtwr(i,rs,sr)$(province(rs) and gtapregions(sr) and sum(rsrsrs,vxm(i,rsrsrs)))=vtwr(i,"CHN",sr)/sum(rsrsrs,vxm(i,rsrsrs))*vxm(i,rs);
vtwr(i,rs,sr)$(province(sr) and gtapregions(rs) and (sum(rsrsrs,(vim(i,rsrsrs)))))=vtwr(i,rs,"CHN")/sum(rsrsrs,(vim(i,rsrsrs)))*vim(i,sr);

* Add vtwr("CHN","CHN") to vtwr("USA","CHN")
vtwr(i,"USA",r)=vtwr(i,"USA",r)+vtwr(i,"CHN",r);
vtwr(i,"CHN",r)=0;

*Add import trade margin to the imports
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sam4(r,"63",j)+sum(mapij(i,j),sum(sr,vtwr(i,sr,r)));
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sam4(r,"63",j)+sum((mapij(i,j),s),rtms(i,s,"CHN")*vxmd(i,s,r)*(1-rtxs(i,s,"CHN")))
+sum((mapij(i,j),s),vtwr(i,s,r)*rtms(i,s,"CHN"));
display vtwr;


*----------------------------------------------------------------------------------
*        DISTRIBUTION OF EXPORT TRANSPORTATION SERVICE
*----------------------------------------------------------------------------------
parameter       vst(rs);
vst(rs)=sum(tp_,vst_(tp_,rs));
parameter       trpsupply(rs);
trpsupply(r)=sam4(r,"25","51");
parameter       tottrpsupply;
tottrpsupply=sum(rs,trpsupply(rs));
vst(rs)$(province(rs))=vst("CHN")/tottrpsupply*trpsupply(rs);

sam4(rs,"51","63")$(province(rs))=sam4(rs,"51","63")+vst(rs);
sam4(rs,"25","51")$(province(rs))=sam4(rs,"25","51")+vst(rs);
*display vst;




*----------------------------------------------------------------------------------
*        FINAL BALANCING
*----------------------------------------------------------------------------------
positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
variable jj

Equations
        rsum
        csum
        sumbalance
        drcsum
        dxsum
        tradebalance
	fixtrdmrgshr
        expleprd
	notbigexp
	notbigimp
        obj
;

rsum(r,i)..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

csum(r,i)..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

sumbalance(r,i)..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticinsum(i)=e=sum(r,finalsam(r,"62",i));

* The share of trade margin should be fixed
fixtrdmrgshr(r,i)$((ord(i)>=27) and (ord(i)<=52) and (sam4(r,"62",i)))..
finalsam(r,"66",i)=e=sam4(r,"66",i)/sam4(r,"62",i)*finalsam(r,"62",i);

dxsum(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"62"));

tradebalance(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticinsum(i)=e=domesticoutsum(i);

*Export is less than or equal to production
expleprd(r,i,j)$(((ord(i)>=27) and (ord(i)<=52)) and (ord(j)=ord(i)-26))..
finalsam(r,j,i)=g=finalsam(r,i,"63")+finalsam(r,i,"62");

notbigexp(r,i)$(ord(i)=44)..
finalsam(r,i,"62")=l=sum(rr$(not sameas(r,rr)),finalsam(rr,"62",i));

notbigimp(r,i)$(ord(i)=44)..
finalsam(r,"62",i)=l=sum(rr$(not sameas(r,rr)),finalsam(rr,i,"62"));

obj..
*jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))));
jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))))+
10000*sum(r,sum(i$((ord(i)=28) or (ord(i)=29) or (ord(i)=30) or (ord(i)=37) or (ord(i)=46) or (ord(i)=47) or (ord(i)=62) or (ord(i)=63)),
sum(j$((ord(j)=2) or (ord(j)=3) or (ord(j)=4) or (ord(j)=11) or (ord(j)=20) or (ord(j)=21) or (ord(j)=62) or (ord(j)=63)),
sqr(finalsam(r,i,j)-sam4(r,i,j)))));





Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam4(r,i,j);
);););
*$ontext
* Make the foreign trade balancing term flexible to change
loop(r,
if(finalsam.l(r,"55","63")=0,finalsam.l(r,"55","63")=1e-6);
if(finalsam.l(r,"63","55")=0,finalsam.l(r,"63","55")=1e-6);
);
*$offtext

loop(r,
loop(i,
loop(j,
if (finalsam.l(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);

* Fix international trade flow and its tax
finalsam.fx(r,i,"63")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"63");
finalsam.fx(r,"63",i)$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,"63",i);
finalsam.fx(r,i,"59")=finalsam.l(r,i,"59");
finalsam.fx(r,"59",i)=finalsam.l(r,"59",i);

* Fix private and government consumption as well as investment
finalsam.fx(r,i,"55")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"55");
finalsam.fx(r,i,"57")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"57");
finalsam.fx(r,i,"64")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"64");

display finalsam.l;

* Fix cap, lab, coal and other input in electricity production
finalsam.fx(r,"53","20")=finalsam.l(r,"53","20");
finalsam.fx(r,"54","20")=finalsam.l(r,"54","20");
finalsam.fx(r,"28","20")=finalsam.l(r,"28","20");
finalsam.fx(r,"52","20")=finalsam.l(r,"52","20");

* Fix private electricity consumption
* finalsam.fx("hai","46","55")=finalsam.l("hai","46","55");


gua.iterlim=100000;
gua.reslim=100000000000;
gua.optfile=1;

option nlp=CONOPT;
Solve gua minimizing jj using nlp;
display finalsam.l;
