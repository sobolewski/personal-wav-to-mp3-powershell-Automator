﻿   $outputExtension = ".mp3"
   $bitrate = 320
   $channels = 2
   # Enter the path to the file you need to update.  Include a trailing slash.
   $path = "E:\ableton-wav-to-mp3\"
   $WavFiles = get-childitem -Path $path -recurse -Filter *.wav
   foreach($inputFile in $WavFiles)
   { 
     $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile.FullName) + $outputExtension;
     $outputFileName = [System.IO.Path]::Combine($inputFile.DirectoryName, $outputFileName);
     
     #$programFiles = ${env:ProgramFiles(x86)};
     #if($programFiles -eq $null) { $programFiles = $env:ProgramFiles; }
     $programFiles = "C:\Program Files\"
     
     $processName = $programFiles + "\VideoLAN\VLC\vlc.exe"
     $processArgs = "-I dummy -vvv `"$($inputFile.FullName)`" --sout=#transcode{acodec=`"mp3`",ab=`"$bitrate`",`"channels=$channels`"}:standard{access=`"file`",mux=`"wav`",dst=`"$outputFileName`"} vlc://quit"
     
     start-process $processName $processArgs -wait
     Remove-Item $inputFile
   }


 

 
# Load the assembly that will handle the MP3 tagging.
[Reflection.Assembly]::Loadfile("C:\Users\Held\Documents\Projects\wav-to-mp3-and-tag\taglib-sharp.dll")
 
# Get a list of files in your path.  Skip directories.
$Mp3files = Get-ChildItem -Path $path -Filter *.mp3 | Where-Object { (-not $_.PSIsContainer) }
 
# Loop through the files
foreach ($filename in $Mp3files){
# Load up the MP3 file.
$media = [TagLib.File]::Create(($path+$filename))

# Load up the tags we know
#$albumartists = [string]$media.Tag.AlbumArtists
#$title = $media.Tag.Title
#$artists = [string]$media.Tag.Artists
#$extension = $filename.Extension

# A few files had no title.  Lets just save them with an artist name
#if([string]::IsNullOrEmpty($title)){
#$title = “missing title”
#$media.Tag.Title = $title}
# If the artists tag has info in it, use that, then reset albumartists tag to match
#if ($artists){
#$name = $artists+”-“+$title.Trim()+$extension
#$media.Tag.AlbumArtists = $artists}
# If the artists tag is empty, use the albumartists field, and set artists to match
#else
#{$name = $albumartists+”-“+$title.Trim()+$extension
#$media.Tag.Artists = $albumartists}

#mein Code
$media.Tag.Title = $filename
$media.Tag.Artists = "mohre"
$media.Tag.Album = "m"


# Save the tag changes back
$media.Save()

#remove any carriage returns in what will be the new filename
#$name = [string]$name -replace “`t|`n|`r”,””
#remove illegal characters, replace with a hyphen
#[System.IO.Path]::GetInvalidFileNameChars() | % {$name = $name.replace($_,’ ‘)}
# There could be duplicate MP3 files with this name, so check if the new filename already exists
#If (Test-Path $path$name){
#[int]$i = 1
#if the file already exists, re-name it with an incrementing value after it, for example: Artist-Song Title-2.mp3
    #While (Test-Path $path$newname){
        #$newname = $name
        #$justname = [System.IO.Path]::GetFileNameWithoutExtension($path+$newname)
        #$newname = $justname+”-“+$i+$extension
        #$i++
        #}
#$name = $newname
#}
#rename the file per those tags
#Rename-Item  $path$filename $path$name
 
}