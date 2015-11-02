# set output window size
$host.UI.RawUI.BufferSize = new-object System.Management.Automation.Host.Size(1000,1000);
########################################################## FUNCTIONS ###################################################################################
function Go-To-SCRs	 			{ Invoke-Item ([Environment]::GetFolderPath("MyDocuments")+'\SCRs\') }
function Open-Music	 			{ Invoke-Item 'C:\Users\rhollon\Music\music' }
function Open-Code				{ Invoke-Item 'C:\Code\Solution' }
function Open-Workspace				{ Invoke-Item 'C:\Workspace' }
function Play-Music				{ &'C:\Program Files (x86)\Windows Media Player\wmplayer.exe' 'C:\Users\Public\Music\Playlists\Everything.wpl' }
function Get-News				{ Start-Process chrome 'news.google.com', 'www.kxan.com', 'www.kvue.com' }
function Get-Weather				{ Invoke-RestMethod -Uri 'http://api.openweathermap.org/data/2.5/weather?q=Austin&units=imperial&appid=29e93877808a06ff4ee3973341218b29' }
function Intialize-Dev 				{ vs; npp; sql; ie; kee; track; vm; mail; }
function Alice-In-Wonderland 			{ Open-PDF ('https://www.gutenberg.org/files/11/11-pdf.pdf'); }
function MVC4-In-Action 			{ Open-PDF ('http://www.karlcassar.com/pub/ebooks/Palermo%20J.%20-%20ASP.NET%20MVC%204%20in%20Action%20-%202012.pdf'); }
function Get-Powershell-Version			{ $PSVersionTable.PSVersion }
function Open-Jenkins				{ Start-Process chrome 'http://192.XXX.XXX.XXX:8080/' }

function Open-PDF(
[string]$url
){
	$page = Read-Host 'Enter page number';
	Start-Process chrome ($url+'#page='+$page)
}

function Open-TripleJ	{ 

	$player=(Get-Process wmplayer -ea "silentlycontinue")
	if ($player)
	{ 
		Write-Host 'WM Player is on.'
		Kill $player 
		Write-Host 'WM Player was killed.'
	}

	Start-Process chrome 'http://www.abc.net.au/radio/stations/triplej/live?play=true';
}

function Create-SCR-Directory{

	#1.) Get User Input
	$scrNumber				= Read-Host 'Enter the SCR Number (ex. SCR1308)' 

	if ($scrNumber -notcontains '*SCR*') { 
		$scrNumber 			= 'SCR' + $scrNumber
	}

	$outPath               	= [Environment]::GetFolderPath("MyDocuments")+'\SCRs\'+$scrNumber+'\'

	#2.) Create a directory for SCR Notes
	if((Test-Path $outPath) -eq 0)
	{
		md $outPath #make directory
	} else {
		Write-Host 'Directory already exists.'
	}

	#3.) Create empty text file for SCR Notes
	$fileName				= $outPath + $scrNumber + '-notes.txt'

	if((Test-Path $fileName) -eq 0)
	{
		New-Item			($fileName) -type file	#make file
		Write-Host          ($fileName) ' created!!'
	} else {
		Write-Host 'File already exists.'
	}	
	
	#4. Create the Dev Test Notes template file
	#4A. Open Sharepoint template document via Word Interop
	$templateFileURL		= 'http://XXXSERVERXXX/Templates/Template.DevTesting.Notes.docx'
	$word 					= New-Object -com word.application
	$document 				= $word.Documents.Open($templateFileURL)
	$word.Visible			= $False
	$outFilePath			= ($outPath+$scrNumber+'.DevTesting.Notes.docx')
	
	#4B. Save file to target SCR directory
	$document.SaveAs([ref]$outFilePath) #Save to user's Desktop

	#4C. Close MS-Word and Document references
	$document.Close()
	$word.Quit()	

	#5.) Open SCR notes text-file     
	Invoke-Item ($fileName)
	Invoke-Item ($outPath)
}

function Find-Text-In-Directory(
[string]$pattern,
[string]$directory
){
	$list=	@(dir $directory -recurse | Get-ChildItem | Select-String -pattern $pattern | Select-Object Path -Unique)
	$list+=	@(dir $directory -recurse | Get-ChildItem | Where-Object { $_.Name -like '*' + $pattern + '*' } | Select-Object Fullname) 
	$list.Count
	$list | % { $_.Path;$_.Fullname }
}

function Find-Text-In-Code-Directory (
[string]$pattern
){
	$directory='C:\_Code\'
	$list=	@(dir $directory -recurse | Get-ChildItem | Select-String -pattern $pattern | Select-Object Path -Unique)
	$list+=	@(dir $directory -recurse | Get-ChildItem | Where-Object { $_.Name -like '*' + $pattern + '*' } | Select-Object Fullname) 
	$list.Count
	$list | % { $_.Path;$_.Fullname }
}
						
function Say-This{  
    param(
        [Parameter(Mandatory=$false)][string]$say
    )

	if (!$say){
		$say			= Read-Host 'What would you like to say? ' 
	}

	$voice 				= New-Object -ComObject SAPI.SPVoice
	$voice.Rate 		= -2
	$voice.Speak($say) 
}

function Say-Web-Page{

	$url = 'http://stackoverflow.com/questions/7976646/powershell-store-entire-text-file-contents-in-variable'
	$wc = new-object system.net.WebClient
	$wc.proxy = $proxy
	$webpage = $wc.DownloadData($url)
	$string = [System.Text.Encoding]::ASCII.GetString($webpage)
	say $string
	
	#$content = [IO.File]::ReadAllText('C:\Workspace\_Code\test.txt')
	#say $content  	
}

function Get-Folder-Size (
[string]$directory
){
	$colItems = (Get-ChildItem $directory -recurse | Measure-Object -property length -sum)
	"{0:N2}" -f ($colItems.sum / 1MB) + " MB"
}

function Get-Service-Report {

	$a = "<style>"
	$a = $a + "h2 		{	font-family: Consolas, monaco, monospace; font-size: 50px; font-style: bold; font-variant: normal; font-weight: 400;							}"
	$a = $a + "BODY		{	font-family: Consolas, monaco, monospace; background-color:grey;																				}"
	$a = $a + "TABLE	{	font-family: Consolas, monaco, monospace; border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;					}"
	$a = $a + "TH		{	font-family: Consolas, monaco, monospace; border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle		}"
	$a = $a + "TD		{	font-family: Consolas, monaco, monospace; border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod	}"
	$a = $a + "</style>"

	$file='C:\_Code\old\Test.html'
	Get-Service -ComputerName 'XXXSERVERXXX' | Select-Object Status, Name, DisplayName | 
	#Get-Service | Select-Object Status, Name, DisplayName | 
	#ConvertTo-HTML -head $a -body "<H2>Service Information - $(get-content env:computername)</H2>"  | 
	ConvertTo-HTML -head $a -body "<H2>Service Information - XXXSERVERXXX</H2>"  | 
	foreach {
		$PSItem -replace "<td>Stopped</td>", "<td style='background-color:red'>Stopped</td>" -replace "<td>Running</td>", "<td style='background-color:green'>Running</td>"
	} | 
	Out-File $file

	Invoke-Expression $file
}

function Open-Radio-URL (
[string]$url
){ 
	$player=(Get-Process wmplayer -ea "silentlycontinue")
	if ($player)
	{ 
		Write-Host 'player is on'
		Kill $player 
	}

	Start-Process chrome $url;
}
function Open-TripleJ-Radio {
	Open-Radio-URL 'http://www.abc.net.au/radio/stations/triplej/live?play=true'
}
function Open-KOKEFM-Radio {
	Open-Radio-URL 'http://kokefm.com/player.html' #http://player.listenlive.co/29651/#
}
function Open-GoldFM-Radio {
	Open-Radio-URL 'http://www.iheart.com/live/gold-1043-melbourne-6181/'
}
function Open-SteelyDan-Gaucho-Album {
	Open-Radio-URL 'http://www.youtube.com/watch?v=4BQ76j_LpXg'
}
########################################################## ALIASES #####################################################################################
set-alias npp 			"C:\Program Files (x86)\Notepad++\notepad++.exe"
set-alias rdc 			"C:\Windows\system32\mstsc.exe"
set-alias key 			"C:\Program Files (x86)\KeePass Password Safe 2\KeePass.exe"
set-alias sql 			"C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe"
set-alias chrome 		"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
set-alias vsnet			"C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe"
set-alias skype			"C:\Program Files\Microsoft Office 15\root\office15\lync.exe"
set-alias msword		"C:\Program Files\Microsoft Office 15\root\office15\WINWORD.EXE"
set-alias wireshark 		"C:\Program Files\Wireshark\Wireshark.exe"
set-alias tracker 		"C:\Program Files (x86)\Merant\Tracker\nt\pvcstkn.exe"
set-alias vm			"C:\Program Files (x86)\Serena\vm\win32\bin\pvcsvmnt.exe"
set-alias inetpub		"C:\Windows\System32\inetsrv\InetMgr.exe"
set-alias smartgit  		"C:\Program Files (x86)\SmartGit\bin\smartgit.exe"
set-alias fiddler   		"C:\Program Files (x86)\Fiddler2\Fiddler.exe"
set-alias iexplorer		"C:\Program Files (x86)\Internet Explorer\iexplore.exe"
set-alias adobe			"C:\Program Files (x86)\Adobe\Acrobat 11.0\Acrobat\Acrobat.exe"
set-alias excel			"C:\Program Files\Microsoft Office 15\root\office15\EXCEL.EXE"
set-alias sublime		"C:\Program Files\Sublime Text 3\sublime_text.exe"
set-alias vlc			"C:\Program Files\VideoLAN\VLC\vlc.exe"
set-alias soapui		"C:\Program Files (x86)\SmartBear\SoapUI-5.0.0\bin\SoapUI-5.0.0.exe"
set-alias outlook		"C:\Program Files\Microsoft Office 15\root\office15\OUTLOOK.EXE"
set-alias alice			Alice-In-Wonderland
set-alias csd			Create-SCR-Directory
set-alias cs			Create-SCR-Directory
set-alias findtext  		Find-Text-In-Directory
set-alias codefind  		Find-Text-In-Code-Directory
set-alias getfoldersize 	Get-Folder-Size
set-alias gfs			Get-Folder-Size
set-alias getnews		Get-News
set-alias news			Get-News
set-alias getweather 		Get-Weather
set-alias weather		Get-Weather
set-alias gotoscrs		Go-To-SCRs
set-alias scrs 			Go-To-SCRs
set-alias scr 			Go-To-SCRs
set-alias dev			Intialize-Dev
set-alias environment   	Intialize-Dev
set-alias env			Intialize-Dev
set-alias mvc4			MVC4-In-Action
set-alias mvc			MVC4-In-Action
set-alias mia			MVC4-In-Action
set-alias openmusic		Open-Music
set-alias music			Open-Music
set-alias workspace		Open-Workspace
set-alias playmusic		Play-Music
set-alias play			Play-Music
set-alias jams			Play-Music
set-alias say			Say-This
set-alias speak			Say-This
set-alias talk			Say-This
set-alias ie			iexplorer
set-alias pdf			adobe
set-alias fiddle		fiddler
set-alias fid			fiddler
set-alias iis			inetpub
set-alias shark			wireshark
set-alias track			tracker
set-alias word			msword
set-alias vs			vsnet
set-alias kee			key
set-alias xls			excel
set-alias sub			sublime
set-alias soap			soapui
set-alias mail			outlook
set-alias email			outlook
set-alias triplej		Open-TripleJ-Radio
set-alias kokefm		Open-KOKEFM-Radio
set-alias goldfm		Open-GoldFM-Radio
set-alias gaucho		Open-SteelyDan-Gaucho-Album
set-alias steely		Open-SteelyDan-Gaucho-Album
set-alias koke			kokefm
set-alias gold			goldfm
set-alias psversion		Get-Powershell-Version
set-alias psver			Get-Powershell-Version
set-alias jenkins		Open-Code-Jenkins
##########################################################################################################################################################
