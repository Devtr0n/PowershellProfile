# set output window size
$host.UI.RawUI.BufferSize = new-object System.Management.Automation.Host.Size(1000,1000);
########################################################## FUNCTIONS #####################################################
function gotoworkspace{set-location C:\Workspace}
function gotocore{set-location C:\Workspace\MSDF\Ed-Fi-Core}
function gotoapps{set-location C:\Workspace\MSDF\Ed-Fi-Apps}
function gototools{set-location C:\Workspace\MSDF\Ed-Fi-Tools}
function gotomsdf{set-location C:\Workspace\MSDF}
function gotolr{set-location C:\Workspace\LittleRockSD}
function gotolrcore{set-location C:\Workspace\LittleRockSD\Ed-Fi-Core}
function gotolrapps{set-location C:\Workspace\LittleRockSD\Ed-Fi-Apps}

# find explicit text in all Workspace powershell scripts
function findTextInWorkspace ([string] $text)
{
	dir C:\Workspace\* -recurse -filter '*.ps*1' | Get-ChildItem | select-string -pattern $text | Select-Object Path -Unique
}

function findFileInWorkspace ([string] $fileName)
{
	$files = @(Get-ChildItem -Path C:\Workspace\ -Recurse | Where-Object { $_.Name -eq $fileName })
	Write-Host "Matches found: " $files.Count  
	foreach ($file in $files) {
		Write-Host $file.FullName  
	}
}

# find all functions in an explicit directory
function findFunctions ([string] $dir)
{
	$parser = [System.Management.Automation.PsParser]
	$files=(dir $dir -Recurse *.ps*1)

	ForEach($file in $files) {
		$parser::Tokenize((Get-Content $file.FullName), [ref] $null) |
		ForEach {
		
			$PSToken = $_
			
			if($PSToken.Type -eq  'Keyword' -and $PSToken.Content -eq 'Function' ) 
			{
				$functionKeyWordFound = $true
			}

			if($functionKeyWordFound -and $PSToken.Type -eq  'CommandArgument') 
			{
				'' | Select `
				@{
					Name="FunctionName"
					Expression={$PSToken.Content}
				},
				@{
					Name="Line"
					Expression={$PSToken.StartLine}
				},
				@{
					Name="File"
					Expression={$file.FullName}
				}
			  
				$functionKeyWordFound = $false
			}
		}
	}
}

########################################################## ALIASES #####################################################
# load aliases
set-alias npp "C:\Program Files\Notepad++\notepad++.exe"
set-alias rdc "C:\Windows\system32\mstsc.exe"
set-alias key "C:\Program Files\KeePass Password Safe 2\KeePass.exe"
set-alias sql "C:\Program Files\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe"
set-alias chrome "C:\Program Files\Google\Chrome\Application\chrome.exe"
set-alias vlc "C:\Program Files\VideoLAN\VLC\vlc.exe"
set-alias vpn "C:\Program Files\ShrewSoft\VPN Client\ipseca.exe"
set-alias dotnet "C:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
set-alias core gotocore
set-alias apps gotoapps
set-alias lrcore gotolrcore
set-alias lrapps gotolrapps
set-alias lr gotolr
set-alias tools gototools
set-alias msdf gotomsdf
set-alias workspace gotoworkspace
