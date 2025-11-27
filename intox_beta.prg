Function main()
cls
set color to gr+/r+
set century on
set date british

? "-----------------------------------------------------------------"
? "| intox.exe versao beta - 04/11/2025                            |"
? "| Regional de saude Entorno Sul                                 |"
? "| Sintaxe do executavel: intox.exe [--modo]                     |"
? "| Modos possiveis: --via --circ                                 |"
? "| Exemplo: intox.exe --via                                      |"
? "-----------------------------------------------------------------"
set color to w+/

cModo := HB_ArgV ( 1 )

if empty( cModo ) = .T.
set color to r+/
? "Erro! Falta o argumento 'modo' no executavel."
? "Fim do programa."
wait
quit
endif

? "Modo:" + alltrim( cModo )

if cModo <> "--via" .and. cModo <> "--circ"
set color to r+/
? "Erro! O argumento indicado pelo usuario nao existe."
? "Fim do programa."
wait
quit
endif

if cModo = "--via"
via()
endif

if cModo = "--circ"
circ()
endif

function via()
set color to g+/

? "Copiando arquivos..."
copy file "c:\intox\DBF\iexognet.dbf" to "c:\intox\tmp\iexo_via.dbf"
copy file "c:\intox\model\iexo_via_light.dbf" to "c:\intox\tmp\iexo_via_light.dbf"

? "Filtrando os dados..."
use "c:\intox\tmp\iexo_via.dbf"
do while .not. eof()
replace tp_not with "x" for cs_sexo = "M" .and. ( via_1 = "6" .or. via_1 = "7" )
enddo
close

use "c:\intox\tmp\iexo_via.dbf"
do while .not. eof()
replace tp_not with "x" for cs_sexo = "M" .and. ( via_2 = "6" .or. via_2 = "7" )
enddo
close

use "c:\intox\tmp\iexo_via.dbf"
do while .not. eof()
replace tp_not with "x" for cs_sexo = "M" .and. ( via_3 = "6" .or. via_3 = "7" )
enddo
close

? "Excluindo os registros que nao sao de interesse..."
use "c:\intox\tmp\iexo_via.dbf"
delete for tp_not <> "x"
pack

*campos para o arquivo simplificado (light): nu_notific, tp_not, dt_notific, id_municip, nm_pacient, dt_nasc, cs_sexo, nm_mae_pac, id_mn_resi, via_1, via_2, via_3

? "Transferindo os registros para um arquivo de saida simplificado..."
use "c:\intox\tmp\iexo_via_light.dbf"
append from "c:\intox\tmp\iexo_via.dbf"
close

? "Transferindo o arquivo simplificado para a subpasta apropriada..."
copy file "c:\intox\tmp\iexo_via_light.dbf" to "c:\intox\out\iexo_via_light.dbf"

? "Fim do processo..."

set color to w+/
? "Arquivo final esta em: c:\intox\out\iexo_via_light.dbf"

return

function circ()
set color to g+/

? "Copiando arquivos..."
copy file "c:\intox\DBF\iexognet.dbf" to "c:\intox\tmp\iexo_circunstancia.dbf"
copy file "c:\intox\model\iexo_circ_light.dbf" to "c:\intox\tmp\iexo_circ_light.dbf"

? "Filtrando os dados..."
use "c:\intox\tmp\iexo_circunstancia.dbf"
do while .not. eof()
replace tp_not with "x" for cs_sexo = "M" .and. circunstan = "11"
enddo
close

? "Excluindo os registros que nao sao de interesse..."
use "c:\intox\tmp\iexo_circunstancia.dbf"
delete for tp_not <> "x"
pack

*campos para o arquivo simplificado (light): nu_notific, tp_not, dt_notific, id_municip, nm_pacient, dt_nasc, cs_sexo, nm_mae_pac, id_mn_resi, circunstan

? "Transferindo os registros para um arquivo de saida simplificado..."
use "c:\intox\tmp\iexo_circ_light.dbf"
append from "c:\intox\tmp\iexo_circunstancia.dbf"
close

? "Transferindo o arquivo simplificado para a subpasta apropriada..."
copy file "c:\intox\tmp\iexo_circ_light.dbf" to "c:\intox\out\iexo_circ_light.dbf"

? "Fim do processo..."

set color to w+/
? "Arquivo final esta em: c:\intox\out\iexo_circ_light.dbf"

return

return nil