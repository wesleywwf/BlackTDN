function ConvertTo-Jpeg {
    param(
    [Parameter(ValueFromPipeline=$true)]    
    $image,
    
    [ValidateRange(1,100)]
    [int]$quality = 100
    )
    process {
        if (-not $image.Loadfile -and 
            -not $image.Fullname) { return }
        $realItem = Get-Item -ErrorAction SilentlyContinue $image.FullName
        if (-not $realItem) { return }
        if (".jpg",".jpeg" -notcontains $realItem.Extension) {
            $noExtension = $realItem.FullName.Substring(0, 
                $realItem.FullName.Length - $realItem.Extension.Length)
            $process = New-Object -ComObject Wia.ImageProcess
            $convertFilter = $process.FilterInfos.Item("Convert").FilterId
            $process.Filters.Add($convertFilter)
            $process.Filters.Item(1).Properties.Item("Quality") = $quality
            $process.Filters.Item(1).Properties.Item("FormatID") = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
            $newImg = $process.Apply($image.PSObject.BaseObject)
            $newImg.SaveFile("$noExtension.jpg")
        }
    
    }
}