#https://sqljana.wordpress.com/2018/01/10/powershell-export-querytosqltable-export-all-of-glenn-berrys-dmvs-sp_whoisactive-sp_blitz-any-of-your-own-queries-to-sql-server-tables/

[string] $saveToInstance = 'MySQLServer\MyInstanceName'
[string[]] $runOnInstance = @('FinDev\inst01','FinDev\inst02','FinDev\inst03','FinDev\inst04',
                            'FinUsr\inst01','FinUsr\inst02','FinUsr\inst03','FinUsr\inst04',
                            'FinPlt\inst01','FinPlt\inst02','FinPlt\inst03','FinPlt\inst04',
                            'FinLod\inst01','FinLod\inst02','FinLod\inst03','FinLod\inst04',
                            'FinPrd\inst01','FinPrd\inst02','FinPrd\inst03','FinPrd\inst04'
                            )
[string] $saveToDatabase = 'DBAUtil'
[string] $saveToSchema = 'dbo'

[string] $queryFile = '**** PATH LOCATION WHERE YOU SAVED THE SQL ****'
[string] $query = Get-Content $queryFile | Out-String

$query = New-Object -TypeName PSObject
$query | Add-Member -MemberType NoteProperty -Name QueryNr -Value 1
$query | Add-Member -MemberType NoteProperty -Name QueryTitle -Value 'SpaceInfo_File'
$query | Add-Member -MemberType NoteProperty -Name Query -Value ($query -replace "SET @InfoLevel = '*'", "SET @InfoLevel = 'File'")
$query | Add-Member -MemberType NoteProperty -Name Description -Value 'Gets File level space information'
$query | Add-Member -MemberType NoteProperty -Name DBSpecific -Value $false

#Now $queries can be passed into the function call
$output = Export-QueryToSQLTable `
        -Queries @($query) `
        -RunOnInsta$querynces $runOnInstance `
        -RunInclude$queryDBs @() `
        -RunExclude$queryDBs @() `
        -RunExclude$queryAllSystemDBs: $true `
        -RunExclude$queryAllUserDBs: $false `
        -RunOnDBsWithOwner @() `
        -RunOnDBsWithStatus @('Normal') `
        -SaveResultsToInstance $saveToInstance `
        -SaveResultsToDatabase $saveToDatabase `
        -SaveResultsToSchema $saveToSchema `
        -SaveResultsTruncateBeforeSave: $false