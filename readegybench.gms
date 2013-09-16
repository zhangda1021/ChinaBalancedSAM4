$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egybench'
$call gdxxrw i=%inputfolder%\coal_bench.xls o=%outputfolder%\coal.gdx par=egybench  rng="sheet1!a1:b20" rdim=1 cdim=1 
$call gdxxrw i=%inputfolder%\oil_bench.xls o=%outputfolder%\oil.gdx par=egybench  rng="sheet1!A1:b20" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\roil_bench.xls o=%outputfolder%\roil.gdx par=egybench  rng="sheet1!A1:b20" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\ng_bench.xls o=%outputfolder%\ng.gdx par=egybench  rng="sheet1!A1:b20" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\eleh_bench.xls o=%outputfolder%\eleh.gdx par=egybench  rng="sheet1!A1:b20" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\othe_bench.xls o=%outputfolder%\othe.gdx par=egybench  rng="sheet1!A1:b20" rdim=1 cdim=1