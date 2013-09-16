
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\rawegy'

$call gdxxrw i=%inputfolder%\egycons_ind.xls o=%outputfolder%\IND.gdx par=ind rng="IND!A1:G25" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_ind.xls o=%outputfolder%\PROV.gdx par=indprov rng="INDPROV!A1:H31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\COAL.gdx par=egyprov  rng="COAL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\OIL.gdx par=egyprov  rng="OIL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\ROIL.gdx par=egyprov  rng="ROIL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\NG.gdx par=egyprov  rng="NG!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\ELEH.gdx par=egyprov rng="ELEH!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\OTHE.gdx par=egyprov  rng="OTHE!A1:u31" rdim=1 cdim=1

