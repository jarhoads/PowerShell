Param([String] $Path, [Int] $Width = 72, [Int] $Height = 72)

function Convert-Thumb{
################################################################
#.Synopsis
# Convert a directory of jpg images given by Path to thumbnails.
#.Parameter Path
# the path to the images that need to be converted
################################################################
    Param (
        [String] $thumbsPath,
        [Int] $thumbWidth = 72,
        [Int] $thumbHeight = 72
    )
    
    $jpgPath = "*.jpg"
    $thumbsPath += $jpgPath

    Get-ChildItem -Path $thumbsPath | ForEach-Object {
     $full = [System.Drawing.Image]::FromFile("$(Resolve-Path $_)");
     $thumb = $full.GetThumbnailImage($thumbWidth, $thumbHeight, $null, [intptr]::Zero);
     $thumb.Save("$(Resolve-Path $_).thumb.jpg" );
     $full.Dispose();
     $thumb.Dispose();
    }
}

Convert-Thumb -thumbsPath $Path -thumbWidth $Width -thumbHeight $Height