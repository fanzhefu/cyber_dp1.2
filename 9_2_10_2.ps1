#requires -version 3.0

try { Microsoft.PowerShell.Core\\Set-StrictMode -Off } catch { }

$script:MyModule = $MyInvocation.MyCommand.ScriptBlock.Module

$script:ClassName = 'ROOT\\cimv2\\Win32_PnPEntity'
$script:ClassVersion = '2.0'
$script:ModuleVersion = '1.0'
$script:ObjectModelWrapper = [Microsoft.PowerShell.Cmdletization.Cim.CimCmdletAdapter]

$script:PrivateData = [System.Collections.Generic.Dictionary[string,string]]::new()

Microsoft.PowerShell.Core\\Export-ModuleMember -Function @()
        
$script:PrivateData.Add('ClientSideShouldProcess', '')

function __cmdletization_BindCommonParameters
{
    param(
        $__cmdletization_objectModelWrapper,
        $myPSBoundParameters
    )       
                

        if ($myPSBoundParameters.ContainsKey('CimSession')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['CimSession'].Value = $myPSBoundParameters['CimSession'] 
        }
                    

        if ($myPSBoundParameters.ContainsKey('ThrottleLimit')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['ThrottleLimit'].Value = $myPSBoundParameters['ThrottleLimit'] 
        }
                    

        if ($myPSBoundParameters.ContainsKey('AsJob')) { 
            $__cmdletization_objectModelWrapper.PSObject.Properties['AsJob'].Value = $myPSBoundParameters['AsJob'] 
        }
                    

}
                

function Get-PnpDevice
{
    [CmdletBinding(DefaultParameterSetName='ByInstanceId', PositionalBinding=$false)]
    
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
[OutputType('Microsoft.Management.Infrastructure.CimInstance#ROOT\\cimv2\\Win32_PnPEntity')]

    param(
    
    [Parameter(ParameterSetName='ByFriendlyName', ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${FriendlyName},

    [Parameter(ParameterSetName='ByInstanceId', Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('DeviceId')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${InstanceId},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByClass')]
    [Parameter(ParameterSetName='ByPresence')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${Class},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByClass')]
    [Parameter(ParameterSetName='ByPresence')]
    [ValidateNotNull()]
    [switch]
    ${PresentOnly},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByStatus')]
    [Parameter(ParameterSetName='ByPresence')]
    [ValidateSet('OK','ERROR','DEGRADED','UNKNOWN')]
    [ValidateNotNull()]
    [string[]]
    ${Status},

    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByClass')]
    [Parameter(ParameterSetName='ByPresence')]
    [Parameter(ParameterSetName='ByStatus')]
    [Alias('Session')]
    [ValidateNotNullOrEmpty()]
    [CimSession[]]
    ${CimSession},

    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByClass')]
    [Parameter(ParameterSetName='ByPresence')]
    [Parameter(ParameterSetName='ByStatus')]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='ByFriendlyName')]
    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='ByClass')]
    [Parameter(ParameterSetName='ByPresence')]
    [Parameter(ParameterSetName='ByStatus')]
    [switch]
    ${AsJob})

    DynamicParam {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper = $script:ObjectModelWrapper::new()
                $__cmdletization_objectModelWrapper.Initialize($PSCmdlet, $script:ClassName, $script:ClassVersion, $script:ModuleVersion, $script:PrivateData)

                if ($__cmdletization_objectModelWrapper -is [System.Management.Automation.IDynamicParameters])
                {
                    ([System.Management.Automation.IDynamicParameters]$__cmdletization_objectModelWrapper).GetDynamicParameters()
                }
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }

    Begin {
        $__cmdletization_exceptionHasBeenThrown = $false
        try 
        {
            __cmdletization_BindCommonParameters $__cmdletization_objectModelWrapper $PSBoundParameters
            $__cmdletization_objectModelWrapper.BeginProcessing()
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    Process {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
    $__cmdletization_queryBuilder = $__cmdletization_objectModelWrapper.GetQueryBuilder()
    if ($PSBoundParameters.ContainsKey('FriendlyName') -and (@('ByFriendlyName') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${FriendlyName})
        $__cmdletization_queryBuilder.FilterByProperty('Name', $__cmdletization_values, $true, 'Default')
    }
    if ($PSBoundParameters.ContainsKey('InstanceId') -and (@('ByInstanceId') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${InstanceId})
        $__cmdletization_queryBuilder.FilterByProperty('DeviceId', $__cmdletization_values, $true, 'Default')
    }
    if ($PSBoundParameters.ContainsKey('Class') -and (@('ByInstanceId', 'ByFriendlyName', 'ByClass', 'ByPresence') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${Class})
        $__cmdletization_queryBuilder.FilterByProperty('PNPClass', $__cmdletization_values, $false, 'Default')
    }
    if ($PSBoundParameters.ContainsKey('PresentOnly') -and (@('ByInstanceId', 'ByFriendlyName', 'ByClass', 'ByPresence') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${PresentOnly})
        $__cmdletization_queryBuilder.FilterByProperty('Present', $__cmdletization_values, $false, 'Default')
    }
    if ($PSBoundParameters.ContainsKey('Status') -and (@('ByInstanceId', 'ByFriendlyName', 'ByStatus', 'ByPresence') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${Status})
        $__cmdletization_queryBuilder.FilterByProperty('Status', $__cmdletization_values, $false, 'Default')
    }


    $__cmdletization_objectModelWrapper.ProcessRecord($__cmdletization_queryBuilder)
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    End {
        try
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper.EndProcessing()
            }
        }
        catch
        {
            throw
        }
    }

    # .EXTERNALHELP PnpDevice.cdxml-Help.xml
}
Microsoft.PowerShell.Core\\Export-ModuleMember -Function 'Get-PnpDevice' -Alias '*'
        

function Enable-PnpDevice
{
    [CmdletBinding(DefaultParameterSetName='ByInstanceId', SupportsShouldProcess=$true, ConfirmImpact='High', PositionalBinding=$false)]
    
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
[OutputType('Microsoft.Management.Infrastructure.CimInstance#ROOT\\cimv2\\Win32_PnPEntity')]

    param(
    
    [Parameter(ParameterSetName='ByInstanceId', Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('DeviceId')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${InstanceId},

    [Parameter(ParameterSetName='InputObject (cdxml)', Mandatory=$true, ValueFromPipeline=$true)]
    [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#Win32_PnPEntity')]
    [ValidateNotNull()]
    [ciminstance[]]
    ${InputObject},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [Alias('Session')]
    [ValidateNotNullOrEmpty()]
    [CimSession[]]
    ${CimSession},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [switch]
    ${AsJob},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [switch]
    ${PassThru})

    DynamicParam {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper = $script:ObjectModelWrapper::new()
                $__cmdletization_objectModelWrapper.Initialize($PSCmdlet, $script:ClassName, $script:ClassVersion, $script:ModuleVersion, $script:PrivateData)

                if ($__cmdletization_objectModelWrapper -is [System.Management.Automation.IDynamicParameters])
                {
                    ([System.Management.Automation.IDynamicParameters]$__cmdletization_objectModelWrapper).GetDynamicParameters()
                }
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }

    Begin {
        $__cmdletization_exceptionHasBeenThrown = $false
        try 
        {
            __cmdletization_BindCommonParameters $__cmdletization_objectModelWrapper $PSBoundParameters
            $__cmdletization_objectModelWrapper.BeginProcessing()
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    Process {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
    $__cmdletization_queryBuilder = $__cmdletization_objectModelWrapper.GetQueryBuilder()
    if ($PSBoundParameters.ContainsKey('InstanceId') -and (@('ByInstanceId') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${InstanceId})
        $__cmdletization_queryBuilder.FilterByProperty('DeviceID', $__cmdletization_values, $false, 'Default')
    }


    $__cmdletization_methodParameters = [System.Collections.Generic.List[Microsoft.PowerShell.Cmdletization.MethodParameter]]::new()
    switch -exact ($PSCmdlet.ParameterSetName) { 
        { @('ByInstanceId', 'InputObject (cdxml)') -contains $_ } {
      $__cmdletization_returnValue = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{ Name = 'ReturnValue'; ParameterType = 'System.Int32'; Bindings = 'Error'; Value = $null; IsValuePresent = $false }
      $__cmdletization_methodInvocationInfo = [Microsoft.PowerShell.Cmdletization.MethodInvocationInfo]::new('Enable', $__cmdletization_methodParameters, $__cmdletization_returnValue)
      $__cmdletization_passThru = $PSBoundParameters.ContainsKey('PassThru') -and $PassThru
            if ($PSBoundParameters.ContainsKey('InputObject')) {
                foreach ($x in $InputObject) { $__cmdletization_objectModelWrapper.ProcessRecord($x, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru) }
            } else {
                $__cmdletization_objectModelWrapper.ProcessRecord($__cmdletization_queryBuilder, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru)
            }
        }
    }

            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    End {
        try
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper.EndProcessing()
            }
        }
        catch
        {
            throw
        }
    }

    # .EXTERNALHELP PnpDevice.cdxml-Help.xml
}
Microsoft.PowerShell.Core\\Export-ModuleMember -Function 'Enable-PnpDevice' -Alias '*'
        

function Disable-PnpDevice
{
    [CmdletBinding(DefaultParameterSetName='ByInstanceId', SupportsShouldProcess=$true, ConfirmImpact='High', PositionalBinding=$false)]
    
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
[OutputType('Microsoft.Management.Infrastructure.CimInstance#ROOT\\cimv2\\Win32_PnPEntity')]

    param(
    
    [Parameter(ParameterSetName='ByInstanceId', Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('DeviceId')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${InstanceId},

    [Parameter(ParameterSetName='InputObject (cdxml)', Mandatory=$true, ValueFromPipeline=$true)]
    [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#Win32_PnPEntity')]
    [ValidateNotNull()]
    [ciminstance[]]
    ${InputObject},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [Alias('Session')]
    [ValidateNotNullOrEmpty()]
    [CimSession[]]
    ${CimSession},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [switch]
    ${AsJob},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [switch]
    ${PassThru})

    DynamicParam {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper = $script:ObjectModelWrapper::new()
                $__cmdletization_objectModelWrapper.Initialize($PSCmdlet, $script:ClassName, $script:ClassVersion, $script:ModuleVersion, $script:PrivateData)

                if ($__cmdletization_objectModelWrapper -is [System.Management.Automation.IDynamicParameters])
                {
                    ([System.Management.Automation.IDynamicParameters]$__cmdletization_objectModelWrapper).GetDynamicParameters()
                }
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }

    Begin {
        $__cmdletization_exceptionHasBeenThrown = $false
        try 
        {
            __cmdletization_BindCommonParameters $__cmdletization_objectModelWrapper $PSBoundParameters
            $__cmdletization_objectModelWrapper.BeginProcessing()
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    Process {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
    $__cmdletization_queryBuilder = $__cmdletization_objectModelWrapper.GetQueryBuilder()
    if ($PSBoundParameters.ContainsKey('InstanceId') -and (@('ByInstanceId') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${InstanceId})
        $__cmdletization_queryBuilder.FilterByProperty('DeviceID', $__cmdletization_values, $false, 'Default')
    }


    $__cmdletization_methodParameters = [System.Collections.Generic.List[Microsoft.PowerShell.Cmdletization.MethodParameter]]::new()
    switch -exact ($PSCmdlet.ParameterSetName) { 
        { @('ByInstanceId', 'InputObject (cdxml)') -contains $_ } {
      $__cmdletization_returnValue = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{ Name = 'ReturnValue'; ParameterType = 'System.Int32'; Bindings = 'Error'; Value = $null; IsValuePresent = $false }
      $__cmdletization_methodInvocationInfo = [Microsoft.PowerShell.Cmdletization.MethodInvocationInfo]::new('Disable', $__cmdletization_methodParameters, $__cmdletization_returnValue)
      $__cmdletization_passThru = $PSBoundParameters.ContainsKey('PassThru') -and $PassThru
            if ($PSBoundParameters.ContainsKey('InputObject')) {
                foreach ($x in $InputObject) { $__cmdletization_objectModelWrapper.ProcessRecord($x, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru) }
            } else {
                $__cmdletization_objectModelWrapper.ProcessRecord($__cmdletization_queryBuilder, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru)
            }
        }
    }

            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    End {
        try
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper.EndProcessing()
            }
        }
        catch
        {
            throw
        }
    }

    # .EXTERNALHELP PnpDevice.cdxml-Help.xml
}
Microsoft.PowerShell.Core\\Export-ModuleMember -Function 'Disable-PnpDevice' -Alias '*'
        

function Get-PnpDeviceProperty
{
    [CmdletBinding(DefaultParameterSetName='ByInstanceId', SupportsShouldProcess=$true, ConfirmImpact='Low', PositionalBinding=$false)]
    
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    param(
    
    [Parameter(ParameterSetName='ByInstanceId', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('DeviceId')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [string[]]
    ${InstanceId},

    [Parameter(ParameterSetName='InputObject (cdxml)', Mandatory=$true, ValueFromPipeline=$true)]
    [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#Win32_PnPEntity')]
    [ValidateNotNull()]
    [ciminstance[]]
    ${InputObject},

    [Parameter(ParameterSetName='ByInstanceId', Position=0, ValueFromPipelineByPropertyName=$true)]
    [Parameter(ParameterSetName='InputObject (cdxml)', Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('Key')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string[]]
    ${KeyName},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [Alias('Session')]
    [ValidateNotNullOrEmpty()]
    [CimSession[]]
    ${CimSession},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='ByInstanceId')]
    [Parameter(ParameterSetName='InputObject (cdxml)')]
    [switch]
    ${AsJob})

    DynamicParam {
      #","ScriptBlockId":"76bcf994-b7d0-4ee0-99de-8d549f2a40e0","Path":""}}}
	    try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper = $script:ObjectModelWrapper::new()
                $__cmdletization_objectModelWrapper.Initialize($PSCmdlet, $script:ClassName, $script:ClassVersion, $script:ModuleVersion, $script:PrivateData)

                if ($__cmdletization_objectModelWrapper -is [System.Management.Automation.IDynamicParameters])
                {
                    ([System.Management.Automation.IDynamicParameters]$__cmdletization_objectModelWrapper).GetDynamicParameters()
                }
            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }

    Begin {
        $__cmdletization_exceptionHasBeenThrown = $false
        try 
        {
            __cmdletization_BindCommonParameters $__cmdletization_objectModelWrapper $PSBoundParameters
            $__cmdletization_objectModelWrapper.BeginProcessing()
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    Process {
        try 
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
    $__cmdletization_queryBuilder = $__cmdletization_objectModelWrapper.GetQueryBuilder()
    if ($PSBoundParameters.ContainsKey('InstanceId') -and (@('ByInstanceId') -contains $PSCmdlet.ParameterSetName )) {
        $__cmdletization_values = @(${InstanceId})
        $__cmdletization_queryBuilder.FilterByProperty('DeviceID', $__cmdletization_values, $false, 'Default')
    }


    $__cmdletization_methodParameters = [System.Collections.Generic.List[Microsoft.PowerShell.Cmdletization.MethodParameter]]::new()
    switch -exact ($PSCmdlet.ParameterSetName) { 
        { @('ByInstanceId', 'InputObject (cdxml)') -contains $_ } {
          [object]$__cmdletization_defaultValue = $null
          [object]$__cmdletization_defaultValueIsPresent = $false
          if ($PSBoundParameters.ContainsKey('KeyName')) {
            [object]$__cmdletization_value = ${KeyName}
            $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'devicePropertyKeys'; ParameterType = 'System.String[]'; Bindings = 'In'; Value = $__cmdletization_value; IsValuePresent = $true}
          } else {
            $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'devicePropertyKeys'; ParameterType = 'System.String[]'; Bindings = 'In'; Value = $__cmdletization_defaultValue; IsValuePresent = $__cmdletization_defaultValueIsPresent}
          }
          $__cmdletization_methodParameters.Add($__cmdletization_methodParameter)

          [object]$__cmdletization_defaultValue = $null
          [object]$__cmdletization_defaultValueIsPresent = $false
            $__cmdletization_methodParameter = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{Name = 'deviceProperties'; ParameterType = 'Microsoft.Management.Infrastructure.CimInstance[]'; Bindings = 'Out'; Value = $__cmdletization_defaultValue; IsValuePresent = $__cmdletization_defaultValueIsPresent}
          $__cmdletization_methodParameters.Add($__cmdletization_methodParameter)

      $__cmdletization_returnValue = [Microsoft.PowerShell.Cmdletization.MethodParameter]@{ Name = 'ReturnValue'; ParameterType = 'System.Int32'; Bindings = 'Error'; Value = $null; IsValuePresent = $false }
      $__cmdletization_methodInvocationInfo = [Microsoft.PowerShell.Cmdletization.MethodInvocationInfo]::new('GetDeviceProperties', $__cmdletization_methodParameters, $__cmdletization_returnValue)
      $__cmdletization_passThru = $false
            if ($PSBoundParameters.ContainsKey('InputObject')) {
                foreach ($x in $InputObject) { $__cmdletization_objectModelWrapper.ProcessRecord($x, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru) }
            } else {
                $__cmdletization_objectModelWrapper.ProcessRecord($__cmdletization_queryBuilder, $__cmdletization_methodInvocationInfo, $__cmdletization_PassThru)
            }
        }
    }

            }
        }
        catch
        {
            $__cmdletization_exceptionHasBeenThrown = $true
            throw
        }
    }
        

    End {
        try
        {
            if (-not $__cmdletization_exceptionHasBeenThrown)
            {
                $__cmdletization_objectModelWrapper.EndProcessing()
            }
        }
        catch
        {
            throw
        }
    }

    # .EXTERNALHELP PnpDevice.cdxml-Help.xml
}
Microsoft.PowerShell.Core\\Export-ModuleMember -Function 'Get-PnpDeviceProperty' -Alias '*'
        
#","ScriptBlockId":"76bcf994-b7d0-4ee0-99de-8d549f2a40e0","Path":""}}}