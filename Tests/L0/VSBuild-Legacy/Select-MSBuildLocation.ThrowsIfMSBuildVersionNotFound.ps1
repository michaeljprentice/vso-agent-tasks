[cmdletbinding()]
param()

# Arrange.
. $PSScriptRoot\..\..\lib\Initialize-Test.ps1
. $PSScriptRoot\..\..\..\Tasks\VSBuild\LegacyHelpers.ps1
Register-Mock Get-MSBuildLocation
    
# Act/Assert.
Assert-Throws { Select-MSBuildLocation -VSVersion '14.0' -Architecture 'Some architecture' } -MessagePattern "*MSBuild not found*"
