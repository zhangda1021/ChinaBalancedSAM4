
*If quantity is not zero, value is not zero
*Assuming trade margin is distributed equally between exporter and importer (wrong)
*We should put all the trade margin to the importer as GTAP

loop(r$(sameas(r,'%prov%')),
loop(i$((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)),
loop(j$(ord(j)=ord(i)+30),

loop(pmg$(ord(pmg)=ord(i)),
* Margin is stored with the double index of price
loop(pmg2$(ord(pmg2)=ord(i)*2),

* No trade margin on export
sam31(r,j,"70")=(pricemargin(r,pmg))*ebt21(i,r,"1");
*finalsam.fx(r,j,"70")=sam31(r,j,"70");

sam31(r,j,"71")=(pricemargin(r,pmg))*ebt21(i,r,"2");
finalsam.fx(r,j,"71")=sam31(r,j,"71");

* No margin here in domestic import
sam31(r,"70",j)=pricemargin(r,pmg)*ebt21(i,r,"3");
sam31(r,"74",i)=2*pricemargin(r,pmg2)*ebt21(i,r,"3");
*finalsam.fx(r,"70",j)=sam31(r,"70",j);

sam31(r,"71",j)=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"4");
finalsam.fx(r,"71",j)=sam31(r,"71",j);

if((sam31(r,j,"63")+sam31(r,j,"65"))>0,
sam31(r,j,"63")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31(r,j,"63")+sam31(r,j,"65"))*sam31(r,j,"63");
sam31(r,j,"65")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")-sam31(r,j,"63");
else
sam31(r,j,"63")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31csum(r,"63")+sam31csum(r,"65"))*sam31csum(r,"63");
sam31(r,j,"65")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31csum(r,"63")+sam31csum(r,"65"))*sam31csum(r,"65");
);

*inventory
sam31(r,j,"73")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"36");

*production
sam31(r,i,j)=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"37");
* finalsam.fx(r,i,j)=sam31(r,i,j);

*intermediate use
loop(ebti$((ord(ebti)>=5) and (ord(ebti)<=34)),
loop(ii$(ord(ii)=ord(ebti)-4),
sam31(r,j,ii)=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,ebti);
finalsam.fx(r,j,ii)=sam31(r,j,ii);
);
);
););

*end of j
);

*finalsam.fx(r,"74",i)=sam31(r,"74",i);

*Balance trade margin
sam31(r,"57","74")=sam31(r,"57","74")+sam31(r,"74",i);
*end of i
);

*finalsam.fx(r,"57","74")= sam31(r,"57","74");
*Adjust transportation production
sam31(r,"27","57")=sam31(r,"27","57")+sam31(r,"57","74");

);



* Adjust labor and capital in electricity input to meet the nuc, hyd and wind share in benchmark
set nhw	/nuc,hyd,wind/;
parameter shrnhw(r,*,nhw); 
table shrnhw_(r,nhw)
	hyd		nuc		wind
ANH	0.0230		
BEJ	0.0176
CHQ	0.2104		
FUJ	0.3003				0.0038
GAN	0.3048				0.0050
GUD	0.0861		0.1121		0.0014
GXI	0.4730		
GZH	0.2592
HAI	0.1053				0.0008
HEB	0.0077				0.0043
HEN	0.0488		
HLJ	0.0117				0.0052
HUB	0.6055		
HUN	0.3513		
JIL	0.1118				0.0128	
JSU	0.0011		0.0354		0.0007
JXI	0.1478		
LIA	0.0091				0.0030
NMG	0.0077				0.0079
NXA	0.0375				0.0011
QIH	0.6788			
SHA	0.0806		
SHD	0.0008				0.0010
SHH					0.0005
SHX	0.0148
SIC	0.6321
TAJ	0.0003
XIN	0.1667				0.0119
YUN	0.4762
ZHJ	0.0625		0.1091		0.0002
;

shrnhw(r,"output",nhw)=shrnhw_(r,nhw);
*Input share of hyd
shrnhw(r,"cap","hyd")=0.55;
shrnhw(r,"lab","hyd")=0.1;
shrnhw(r,"res","hyd")=0.3;
shrnhw(r,"COL","hyd")=0.02;
shrnhw(r,"OTH","hyd")=0.03;


*Input share of nuc

shrnhw(r,"cap","nuc")=0.55;
shrnhw(r,"lab","nuc")=0.25;
shrnhw(r,"res","nuc")=0.15;

shrnhw(r,"COL","nuc")=0.02;
shrnhw(r,"OTH","nuc")=0.03;


*Input share of wind
shrnhw(r,"cap","wind")=0.6;
shrnhw(r,"lab","wind")=0.1;
shrnhw(r,"res","wind")=0.3;



loop(r$(sameas(r,'%prov%')),
*Labor
sam31(r,"61","23")=sum(nhw,sam31(r,"23","53")*shrnhw(r,"output",nhw)*shrnhw(r,"lab",nhw))
+sam31(r,"61","23")*(1-sum(nhw,shrnhw(r,"output",nhw)));
*Capital
sam31(r,"62","23")=sum(nhw,sam31(r,"23","53")*shrnhw(r,"output",nhw)*(shrnhw(r,"cap",nhw)
+shrnhw(r,"res",nhw)))+sam31(r,"62","23")*(1-sum(nhw,shrnhw(r,"output",nhw)));
*Coal
*sam31(r,"32","23")=sum(nhw,sam31(r,"23","53")*shrnhw(r,"output",nhw)*shrnhw(r,"col",nhw))
*+sam31(r,"32","23")*(1-sum(nhw,shrnhw(r,"output",nhw)));
*Other
*sam31(r,"59","23")=sum(nhw,sam31(r,"23","53")*shrnhw(r,"output",nhw)*shrnhw(r,"oth",nhw))
*+sam31(r,"59","23")*(1-sum(nhw,shrnhw(r,"output",nhw)));
);




loop(r$(sameas(r,'%prov%')),
loop(i,
loop(j,
finalsam.l(r,i,j)=sam31(r,i,j);
);););



*Fix sparcity
loop(r$(sameas(r,'%prov%')),
finalsam.fx(r,i,j)$(not nonzero(r,i,j))=0;


* Fix cap and lab in ele
finalsam.fx(r,"61","23")=sam31(r,"61","23");
finalsam.fx(r,"62","23")=sam31(r,"62","23");

);


gua.iterlim=100000;
Solve gua minimizing jj using nlp;
display finalsam.l;


