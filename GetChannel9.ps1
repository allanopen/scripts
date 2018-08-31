# Get slides/mp4 from Channel9 for events like build, ignite, connect
# Call it like so GetChannel9.ps1 https://s.ch9.ms/Events/Build/2018/RSS/slides
if ($args.Length) {
    [Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath 
    $a = ([xml](new-object net.webclient).downloadstring($args[0]))
    $a.rss.channel.item | foreach {  
        $url = New-Object System.Uri($_.enclosure.url)

		# using technique from http://www.vistax64.com/powershell/171453-replacing-multiple-characters-string.html
		$fChars = ':', '?', '/', '\', '*', '<', '>', '"', '|'
		$pat = [string]::join('|', ($fChars | % {[regex]::escape($_)}))
    
		$title = $_.title -replace $pat, '_'
		$file = $title + "__" + $url.Segments[-1]  
		$file = $file -replace "`n", ""

		# download file if it doesn't exist
		if (!(test-path $file)) {
			$file 
			(New-Object System.Net.WebClient).DownloadFile($url, $file) 
		}
    }  
}
else {
    Write-Host "Requires an RSS parameter like http://channel9.msdn.com/Events/Build/2017/RSS/slides";
    Write-Host ".\GetChannel9.ps1 https://s.ch9.ms/Events/Build/2018/RSS/slides";
}