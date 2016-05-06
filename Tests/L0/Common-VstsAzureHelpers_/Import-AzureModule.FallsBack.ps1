[CmdletBinding()]
param()

# Arrange.
. $PSScriptRoot/../../lib/Initialize-Test.ps1
$module = Microsoft.PowerShell.Core\Import-Module $PSScriptRoot/../../../Tasks/AzurePowerShell/ps_modules/VstsAzureHelpers_ -PassThru
$variableSets = @(
    @{
        PreferAzureRM = $true
        RMModulePathResult = $true
        RMSdkPathResult = $null
        ClassicModulePathResult = $null
        ClassicSdkPathResult = $null
    }
    @{
        PreferAzureRM = $true
        RMModulePathResult = $false
        RMSdkPathResult = $true
        ClassicModulePathResult = $null
        ClassicSdkPathResult = $null
    }
    @{
        PreferAzureRM = $true
        RMModulePathResult = $false
        RMSdkPathResult = $false
        ClassicModulePathResult = $true
        ClassicSdkPathResult = $null
    }
    @{
        PreferAzureRM = $true
        RMModulePathResult = $false
        RMSdkPathResult = $false
        ClassicModulePathResult = $false
        ClassicSdkPathResult = $true
    }
    @{
        PreferAzureRM = $false
        ClassicModulePathResult = $true
        ClassicSdkPathResult = $null
        RMModulePathResult = $null
        RMSdkPathResult = $null
    }
    @{
        PreferAzureRM = $false
        ClassicModulePathResult = $false
        ClassicSdkPathResult = $true
        RMModulePathResult = $null
        RMSdkPathResult = $null
    }
    @{
        PreferAzureRM = $false
        ClassicModulePathResult = $false
        ClassicSdkPathResult = $false
        RMModulePathResult = $true
        RMSdkPathResult = $null
    }
    @{
        PreferAzureRM = $false
        ClassicModulePathResult = $false
        ClassicSdkPathResult = $false
        RMModulePathResult = $false
        RMSdkPathResult = $true
    }
)
foreach ($variableSet in $variableSets) {
    Write-Verbose ('-' * 80)
    Unregister-Mock Import-FromModulePath
    Unregister-Mock Import-FromSdkPath
    Register-Mock Import-FromModulePath
    Register-Mock Import-FromSdkPath
    if ($variableSet.RMModulePathResult -ne $null) {
        Register-Mock Import-FromModulePath { $variableSet.RMModulePathResult } -- -Classic: $false
    }

    if ($variableSet.RMSdkPathResult -ne $null) {
        Register-Mock Import-FromSdkPath { $variableSet.RMSdkPathResult } -- -Classic: $false
    }

    if ($variableSet.ClassicModulePathResult -ne $null) {
        Register-Mock Import-FromModulePath { $variableSet.ClassicModulePathResult } -- -Classic: $true
    }

    if ($variableSet.ClassicSdkPathResult -ne $null) {
        Register-Mock Import-FromSdkPath { $variableSet.ClassicSdkPathResult } -- -Classic: $true
    }

    # Act.
    & $module Import-AzureModule -PreferAzureRM:($variableSet.PreferAzureRM)

    # Assert.
    Assert-WasCalled Import-FromModulePath -Times $(if ($variableSet.RMModulePathResult -eq $null) { 0 } else { 1 }) -- -Classic: $false
    Assert-WasCalled Import-FromSdkPath -Times $(if ($variableSet.RMSdkPathResult -eq $null) { 0 } else { 1 }) -- -Classic: $false
    Assert-WasCalled Import-FromModulePath -Times $(if ($variableSet.ClassicModulePathResult -eq $null) { 0 } else { 1 }) -- -Classic: $true
    Assert-WasCalled Import-FromSdkPath -Times $(if ($variableSet.ClassicSdkPathResult -eq $null) { 0 } else { 1 }) -- -Classic: $true
}
