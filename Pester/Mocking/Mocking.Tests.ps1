BeforeAll{
    function Build ($version) {
        Write-Host "a build was run for version: $version"
    }

    function Get-Version{
        return 'Version'
    }

    function Get-NextVersion {
        return 'NextVersion'
    }

    function BuildIfChanged {
        $thisVersion = Get-Version
        $nextVersion = Get-NextVersion
        if ($thisVersion -ne $nextVersion) { Build $nextVersion }
        return $nextVersion
    }
}

Describe "BuildIfChanged" {
    Context "When there are Changes" {
        BeforeEach{
            Mock Get-Version {return 1.1}
            Mock Get-NextVersion {return 1.2}
            Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2}

            $result = BuildIfChanged
        }

        It "Builds the next version" {
            Should -InvokeVerifiable
        }

        It "returns the next version number" {
            $result | Should -Be 1.2
        }
    }
    Context "When there are no Changes" {
        BeforeEach{
            Mock Get-Version { return 1.1 }
            Mock Get-NextVersion { return 1.1 }
            Mock Build {}

            $result = BuildIfChanged
        }

        It "Should not build the next version" {
            Should -Invoke -CommandName Build -Times 0 -ParameterFilter {$version -eq 1.1}
        }
    }
}