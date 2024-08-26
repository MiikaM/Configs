<#
.SYNOPSIS
Connects to a hyper-v VM

.DESCRIPTION
Uses the Hyper-v module and connects to a defined VM. 
If the VM is in a stopped state then the command starts the VM and connects to it.
If the command is called without the Name/Id parameter then the command will start and connect to all VMs. 

.PARAMETER ComputerName
 Default is current computer

.PARAMETER Name
The VM name to connect to

.PARAMETER Id
Id of the VM

.PARAMETER InputObject
The VM object if piped with Get-Vm

.PARAMETER StartVM
Do we want to start the VM?

.EXAMPLE
Commands to connect
- Connect-VM -VMName DC12 -StartVM
- Get-VM | Connect-VM

.NOTES
General notes
#>
function Connect-Vm {
  [CmdletBinding(DefaultParameterSetName = 'name')]

  param(
    [Parameter(ParameterSetName = 'name')]
    [Alias('cn')]
    [System.String[]]$ComputerName = $env:COMPUTERNAME,

    [Parameter(Position = 0,
      Mandatory, ValueFromPipelineByPropertyName,
      ValueFromPipeline, ParameterSetName = 'name')]
    [Alias('VMName')]
    [System.String]$Name,

    [Parameter(Position = 0,
      Mandatory, ValueFromPipelineByPropertyName,
      ValueFromPipeline, ParameterSetName = 'id')]
    [Alias('VMId', 'Guid')]
    [System.Guid]$Id,

    [Parameter(Position = 0, Mandatory,
      ValueFromPipeline, ParameterSetName = 'inputObject')]
    [Microsoft.HyperV.PowerShell.VirtualMachine]$InputObject,

    [switch]$StartVM
  )

  begin {
    Write-Verbose "Initializing InstanceCount, InstanceCount = 0"
    $InstanceCount = 0
  }

  process {
    try {
      foreach ($computer in $ComputerName) {
        Write-Verbose "ParameterSetName is '$($PSCmdlet.ParameterSetName)'"

        if ($PSCmdlet.ParameterSetName -eq 'name') {
          # Get the VM by Id if Name can convert to a guid
          if ($Name -as [guid]) {
            Write-Verbose "Incoming value can cast to guid"
            $vm = Get-VM -Id $Name -ErrorAction SilentlyContinue
          }
          else {
            $vm = Get-VM -Name $Name -ErrorAction SilentlyContinue
          }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'id') {
          $vm = Get-VM -Id $Id -ErrorAction SilentlyContinue
        }
        else {
          $vm = $InputObject
        }

        if ($vm) {
          Write-Verbose "Executing 'vmconnect.exe $computer $($vm.Name) -G $($vm.Id) -C $InstanceCount'"
          vmconnect.exe $computer $vm.Name -G $vm.Id -C $InstanceCount
        }
        else {
          Write-Verbose "Cannot find vm: '$Name'"
        }

        if ($StartVM -and $vm) {
          if ($vm.State -eq 'off') {
            Write-Verbose "StartVM was specified and VM state is 'off'. Starting VM '$($vm.Name)'"
            Start-VM -VM $vm
          }
          else {
            Write-Verbose "Starting VM '$($vm.Name)'. Skipping, VM is not not in 'off' state."
          }
        }

        $InstanceCount += 1
        Write-Verbose "InstanceCount = $InstanceCount"
      }
    }
    catch {
      Write-Error $_
    }
  }

}














# Exports 

Export-ModuleMember -Function Connect-Vm