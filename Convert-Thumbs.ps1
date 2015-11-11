Param([String] $Path)

function Convert-Thumbs{
################################################################
#.Synopsis
# Convert a directory of jpg images given by Path to thumbnails.
#.Parameter Path
# the path to the images that need to be converted
################################################################
    Param (
        [String] $thumbsPath
    )
    
    $jpgPath = "*.jpg"
    $thumbsPath += $jpgPath

    Get-ChildItem -Path $thumbsPath | foreach {
     $full = [System.Drawing.Image]::FromFile("$(Resolve-Path $_)");
     $thumb = $full.GetThumbnailImage(72, 72, $null, [intptr]::Zero);
     $thumb.Save("$(Resolve-Path $_).thumb.jpg" );
     $full.Dispose();
     $thumb.Dispose();
    }
}

Convert-Thumbs -thumbsPath $Path