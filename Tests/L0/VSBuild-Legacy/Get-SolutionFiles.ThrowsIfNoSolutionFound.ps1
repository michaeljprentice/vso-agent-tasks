[cmdletbinding()]
param()

# Arrange.
. $PSScriptRoot\..\..\lib\Initialize-Test.ps1
. $PSScriptRoot\..\..\..\Tasks\VSBuild\LegacyHelpers.ps1
Register-Mock Find-Files { } -- -SearchPattern 'Some * solution'

# Act/Assert.
Assert-Throws { Get-SolutionFiles -Solution 'Some * solution' } -MessagePattern '*Some `* solution*'
