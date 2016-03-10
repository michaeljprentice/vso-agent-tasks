[cmdletbinding()]
param()

# Arrange.
. $PSScriptRoot\..\..\lib\Initialize-Test.ps1
Register-Mock Convert-String { [bool]::Parse($args[0]) }

# Act/Assert.
$splat = @{
    'VSLocation' = ''
    'VSVersion' = 'Some input VS version'
    'MSBuildLocation' = ''
    'MSBuildVersion' = ''
    'MSBuildArchitecture' = 'Some input architecture'
    'MSBuildArgs' = 'Some input arguments' 
    'Solution' = '' 
    'Platform' = 'Some input platform'
    'Configuration' = 'Some input configuration'
    'Clean' = 'True'
    'RestoreNuGetPackages' = 'True'
    'LogProjectEvents' = 'True'
}
Assert-Throws { & $PSScriptRoot\..\..\..\Tasks\VSBuild\LegacyVSBuild.ps1 @splat } -MessagePattern "*solution*"
