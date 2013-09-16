$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx'

$call gdxxrw i=%inputfolder%\pricemargin.xls o=%outputfolder%\pricemargin.gdx par=pricemargin rng="sheet1!A1:K31" rdim=1 cdim=1
