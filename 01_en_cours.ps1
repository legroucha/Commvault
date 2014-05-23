#SERVICE MANAGES - Copyright SOTRDATA 2014
#Script de Collecte d'infos Commvault
# $version : V1.0 
# $initiate : 01/01/2014
# $author : Firminhac Florian  (florian.firminhac@stordata.fr)


# on declare le repertoire ou les fichiers generés seront mis 
$sources="sources"

# on verifie que le repertoire existe si non on le créé si oui on continue
If (-not (Test-Path $sources)) { New-Item -ItemType Directory -Name $sources }

# on recupere le repertoire courant pour y enregistrer les fichiers 
$rep = (Get-Location).path

# on verifie si le fichier destination exite si oui on le supprime sinon on continue
if(test-path $sources\01_en_cours.xlsx) {remove-item $sources\01_en_cours.xlsx}

# on parse le fichier *details.xls généré par Commvault et on  ne recupere que les lignes qui ont active dans la colonne status
$processes = Import-Csv BackupJobSummaryReport*details.xls -delimiter "`t" | where {$_.status -eq "active"}

# on utilise les fonctions Excel pour powershell
$Excel = New-Object -ComObject excel.application 
$workbook = $Excel.workbooks.add() 


# on specifie le fichier de sortie
$xlout = "$($rep)\$sources\01_en_cours.xlsx"
$i = 1 
# on boucle sur chaque ligne avec le status active
# on ecrit un tableau avec les colonnes qui nous interesse 
foreach($process in $processes) 
{ 
 $excel.cells.item($i,1) = $process.client
 $excel.cells.item($i,2) = $process.Agent
 $excel.cells.item($i,3) = $process.Subclient
 $excel.cells.item($i,4) = $process."Start Time"
 $excel.cells.item($i,5) = $process.status
 $i++ 
} 

# on cache la fenetre Excel 
$Excel.visible = $false

# on enregistre le fichier 
$Workbook.SaveAs($xlout, 51)
$excel.Quit()

