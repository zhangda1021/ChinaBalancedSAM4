@echo off

: Da Zhang (zhangda1021@gmail.com)
: Sep 2013

title Read all the provincial sam data from excel files to gdx file.
:call gams readrawsam  

title Read all the provincial sam data from gdx file. 
:call gams readallsam gdx=data\gdx\allsam

title Read provincial energy data from egycons_ind.xls and egycons_prov.xls
:call gams readegydata  o=listings\readegydata.lst 
:call gdxmerge data\gdx\rawegy\coal.gdx data\gdx\rawegy\oil.gdx data\gdx\rawegy\roil.gdx data\gdx\rawegy\ng.gdx data\gdx\rawegy\eleh.gdx data\gdx\rawegy\othe.gdx o=data\gdx\rawegy\egymerged.gdx

title Read national energy data from ***_bench.xls
:call gams readegybench o=listings\readegybench.lst 
:call gdxmerge data\gdx\egybench\coal.gdx data\gdx\egybench\oil.gdx data\gdx\egybench\roil.gdx data\gdx\egybench\ng.gdx data\gdx\egybench\eleh.gdx data\gdx\egybench\othe.gdx o=data\gdx\egybench\egybenchmerged.gdx

title Balance energy use and trade data by energy type
call gams egybalance gdx=data\gdx\egybalance

title Estimate energy use by industry by province
call gams egyindest gdx=data\gdx\egyindest

title Read estimated price and trade margin by energy type
call gams readpricemargin o=listings\readpricemargin.lst


pause

title Balance SAM using EBT for each province
del data\gdx\finalbalancing2\*.gdx
call finalbalancing2 BEJ TAJ HEB SHX NMG LIA JIL HLJ SHH JSU ZHJ ANH FUJ JXI SHD HEN HUB HUN GUD GXI HAI CHQ SIC GZH YUN SHA GAN NXA QIH XIN
call gams sam4merge o=listings\ebt4merge.lst 

pause