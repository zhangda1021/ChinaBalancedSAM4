$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\'
$setlocal outputfolder '%projectfolder%\data\gdx\rawsam'

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\AH.gdx par=rawsam rng="ANH!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\BJ.gdx par=rawsam rng="BEJ!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\CQ.gdx par=rawsam rng="CHQ!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\FJ.gdx par=rawsam rng="FUJ!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\GD.gdx par=rawsam rng="GUD!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\GS.gdx par=rawsam rng="GAN!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\GX.gdx par=rawsam rng="GXI!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\GZ.gdx par=rawsam rng="GZH!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HA.gdx par=rawsam rng="HEN!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HB.gdx par=rawsam rng="HUB!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HE.gdx par=rawsam rng="HEB!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HI.gdx par=rawsam rng="HAI!C5:BI54" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HL.gdx par=rawsam rng="HLJ!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\HN.gdx par=rawsam rng="HUN!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\JL.gdx par=rawsam rng="JIL!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\JS.gdx par=rawsam rng="JSU!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\JX.gdx par=rawsam rng="JXI!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\LN.gdx par=rawsam rng="LIA!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\NM.gdx par=rawsam rng="NMG!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\NX.gdx par=rawsam rng="NXA!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\QH.gdx par=rawsam rng="QIH!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\SC.gdx par=rawsam rng="SIC!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\SD.gdx par=rawsam rng="SHD!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\SH.gdx par=rawsam rng="SHH!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\SN.gdx par=rawsam rng="SHA!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\SX.gdx par=rawsam rng="SHX!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\TJ.gdx par=rawsam rng="TAJ!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\XJ.gdx par=rawsam rng="XIN!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\YN.gdx par=rawsam rng="YUN!C8:BI57" rdim=1 cdim=1

$call gdxxrw i=%inputfolder%\chinaIO.xls o=%outputfolder%\ZJ.gdx par=rawsam rng="ZHJ!C8:BI57" rdim=1 cdim=1

$call gdxmerge i=%outputfolder%\*.gdx o=%outputfolder%\merged.gdx
