# Show-CRLF.ps1 powershell script for showing carriage-return, line-feed
# Josh Rhoads April 2015

Param([String] $Path)

function Get-FileHex {
################################################################
#.Synopsis
# Display the hex dump of a file.
#.Parameter Path
# path to the file 
#.Parameter Width
# number of bytes shown per line.
#.Parameter Count
# number of bytes to process (defaults to all)
#.Parameter NoOffset
# suppresses file offset lines.
#.Parameter NoText
# suppresses ascii text translation.
################################################################
Param (
 $Path,
 [Int] $Width = 16,
 [Int] $Count = -1,
 [Switch] $NoOffset,
 [Switch] $NoText
)

 $lineNum = 0 # Offset from beginning of file in hex.
 $nonChar = "." # What to print when byte is not a letter or digit. 

 #Write-Host "Path : " $path
 Get-Content $Path -encoding byte -ReadCount $width -TotalCount $count |

 foreach-object {

    $paddedHex = $asciiText = $null

    # [Byte] objects, $width length
    $bytes = $_ 

    foreach($byte in $bytes) {

        # convert the byte value to hex and use PadLeft to make it two digits
        $byteInHex = [String]::Format("{0:X}", $byte) 
        $paddedHex += $byteInHex.PadLeft(2,"0") + " " 
    }

    # there are extra space characters so the string needs to be $width * 3.
    if ($paddedHex.length -lt $width * 3){ $paddedHex = $paddedHex.PadRight($width * 3," ") }

    foreach ($byte in $bytes) {

        if ( [Char]::IsLetterOrDigit($byte) -or
             [Char]::IsPunctuation($byte) -or
             [Char]::IsSymbol($byte) ){ $asciiText += [Char] $byte }
        else{ $asciiText += $nonChar }

    }

    $offsetText = [String]::Format("{0:X}", $lineNum) # lineNum in hex too.
    $offsetText = $offsetText.PadLeft(8,"0") + "h:" # Pad lineNum with left zeros.
    $lineNum += $width # Increment lineNum, each line representing $width bytes.


    if (-not $NoOffset) { $paddedhex = "$offsettext $paddedhex" }
    if (-not $NoText) { $paddedhex = $paddedhex + $asciitext }
    
    $paddedhex
 }
}

function Highlight-Data{
################################################################
#.Synopsis
# Display a line of data with a chosen line of data highlighted.
#.Parameter Text
# the input text to be highlighted
#.Parameter Highlight
# the part of he text to highlight
################################################################
[CmdletBinding()] Param (
 $Text,
 [String] $Hightlight
)
 $lines = $Text.split('\n')
 foreach($line in $lines){
    
    # check to see if value to highlight is in line
    if($line.Contains($Hightlight)){
        # find the character position of CRLF
        $parts = @()
        $index = $line.IndexOf($Hightlight)
        $parts += @($line.Substring(0,($index - 1)))
        $begin = $index + $Hightlight.Length
        while( ($index -ne $line.LastIndexOf($Hightlight)) -and
               ($line.Substring($begin).IndexOf($Hightlight) > 0) ){

             $index = $line.Substring($begin).IndexOf($Hightlight)
             $parts += @($line.Substring($begin,($index - 1)))
             $begin = $index + $Hightlight.Length
        
        }
    
        $lastPart = $line.Substring(($line.LastIndexOf($Hightlight) + $Hightlight.Length))

        foreach($part in $parts){
            Write-Host "$part " -NoNewline; Write-Host -ForegroundColor Cyan $Hightlight -NoNewline;
        }

        Write-Host $lastPart
    }
    else{ Write-Host $line }
 }
}

# script code
# get the hex values that have "0D 0A" for CR-LF
$hexVals = Get-FileHex -Path $Path -Width 10 | 
           Where-Object {$_ -match "0D 0A"}

# highlight the text with "0D 0A"
Highlight-Data -Text $hexVals -Hightlight "0D 0A"