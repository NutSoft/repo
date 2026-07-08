BeforeAll {
    function Get-InstallPath($path, $key) {
        Get-ItemProperty -Path $path -Name $key | Select-Object -ExpandProperty $key
    }
}

Describe "Get-InstallPath" {
    BeforeAll {
        New-Item -Path TestRegistry:\ -Name TestLocation
        New-ItemProperty -Path "TestRegistry:\TestLocation" -Name "InstallPath" -Value "C:\Program Files\MyApplication"
    }

    It 'reads the install path from the registry' {
        Get-InstallPath -Path "TestRegistry:\TestLocation" -Key "InstallPath" | Should -Be "C:\Program Files\MyApplication"
    }
}