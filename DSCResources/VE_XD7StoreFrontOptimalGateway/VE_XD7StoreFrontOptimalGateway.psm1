<#
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.157
	 Created on:   	2/8/2019 12:12 PM
	 Created by:   	CERBDM
	 Organization: 	Cerner Corporation
	 Filename:     	VE_VE_XD7StoreFrontOptimalGateway.psm1
	-------------------------------------------------------------------------
	 Module Name: VE_VE_XD7StoreFrontOptimalGateway
	===========================================================================
#>

#	Set-DSOptimalGatewayForFarms 

Import-LocalizedData -BindingVariable localizedData -FileName VE_XD7StoreFrontOptimalGateway.Resources.psd1;

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter()]
		[System.UInt64]
		$SiteId=1,

		[parameter(Mandatory = $true)]
		[System.String]
		$ResourcesVirtualPath,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$Hostnames,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$StaUrls,

		[parameter()]
		[System.Boolean]
		$StasUseLoadBalancing,

		[parameter()]
		[System.String]
		$StasBypassDuration,

		[parameter()]
		[System.Boolean]
		$EnableSessionReliability,

		[parameter()]
		[System.Boolean]
		$UseTwoTickets,

		[parameter()]
		[System.String[]]
		$Farms,

		[parameter()]
		[System.String[]]
		$Zones,

		[parameter()]
		[System.Boolean]
		$EnabledOnDirectAccess,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

		Import-module C:\Program Files\Citrix\Receiver StoreFront\Management\Cmdlets\StoresModule.psm1 -ErrorAction Stop -Verbose:$false;

		try {
			Write-Verbose "Running Get-DSOptimalGatewayForFarms"
			$Gateway = Get-DSOptimalGatewayForFarms -SiteId $SiteId -ResourcesVirtualPath $ResourcesVirtualPath -ErrorAction SilentlyContinue
		}
		catch { }

		$returnValue = @{
			SiteId = [System.UInt64]$Gateway.SiteId
			ResourcesVirtualPath = [System.String]$Gateway.ResourcesVirtualPath
			GatewayName = [System.String]$Gateway.GatewayName
			Hostnames = [System.String[]]$Gateway.Hostnames
			StaUrls = [System.String[]]$Gateway.StaUrls
			StasUseLoadBalancing = [System.Boolean]$Gateway.StasUseLoadBalancing
			StasBypassDuration = [System.String]$Gateway.StasBypassDuration
			EnableSessionReliability = [System.Boolean]$Gateway.EnableSessionReliability
			UseTwoTickets = [System.Boolean]$Gateway.UseTwoTickets
			Farms = [System.String[]]$Gateway.Farms
			Zones = [System.String[]]$Gateway.Zones
			EnabledOnDirectAccess = [System.Boolean]$Gateway.EnabledOnDirectAccess
		}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter()]
		[System.UInt64]
		$SiteId=1,

		[parameter(Mandatory = $true)]
		[System.String]
		$ResourcesVirtualPath,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$Hostnames,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$StaUrls,

		[parameter()]
		[System.Boolean]
		$StasUseLoadBalancing,

		[parameter()]
		[System.String]
		$StasBypassDuration,

		[parameter()]
		[System.Boolean]
		$EnableSessionReliability,

		[parameter()]
		[System.Boolean]
		$UseTwoTickets,

		[parameter()]
		[System.String[]]
		$Farms,

		[parameter()]
		[System.String[]]
		$Zones,

		[parameter()]
		[System.Boolean]
		$EnabledOnDirectAccess,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
)

		Import-module C:\Program Files\Citrix\Receiver StoreFront\Management\Cmdlets\StoresModule.psm1 -ErrorAction Stop -Verbose:$false;
		Write-Verbose "Running Get-DSOptimalGatewayForFarms"
		$Gateway = Get-DSOptimalGatewayForFarms -SiteId $SiteId -ResourcesVirtualPath $ResourcesVirtualPath -ErrorAction SilentlyContinue

		If ($Ensure -eq "Present") {
			#Region Create Params hashtable
			$ChangedParams = @{
				SiteId = $SiteId
				ResourcesVirtualPath = $ResourcesVirtualPath
				GatewayName = $GatewayName
				Hostnames = $Hostnames
				StaUrls = $StaUrls
			}
			$targetResource = Get-TargetResource @PSBoundParameters;
			foreach ($property in $PSBoundParameters.Keys) {
				if ($targetResource.ContainsKey($property)) {
					$expected = $PSBoundParameters[$property];
					$actual = $targetResource[$property];
					if ($PSBoundParameters[$property] -is [System.String[]]) {
						if ($actual) {
							if (Compare-Object -ReferenceObject $expected -DifferenceObject $actual) {
								if (!($ChangedParams.ContainsKey($property))) {
									Write-Verbose "Adding $property to ChangedParams"
									$ChangedParams.Add($property,$PSBoundParameters[$property])
								}
							}
						}
						else {
							Write-Verbose "Adding $property to ChangedParams"
							$ChangedParams.Add($property,$PSBoundParameters[$property])
						}
					}
					elseif ($expected -ne $actual) {
						if (!($ChangedParams.ContainsKey($property))) {
							Write-Verbose "Adding $property to ChangedParams"
							$ChangedParams.Add($property,$PSBoundParameters[$property])
						}
					}
				}
			}
			#endregion

			#Create gateway
			Write-Verbose "Calling Set-DSOptimalGatewayForFarms"
			Set-DSOptimalGatewayForFarms @ChangedParams

		}
		Else {
			#Uninstall
			$Gateway | Remove-DSOptimalGatewayForFarms -confirm:$false
		}


	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter()]
		[System.UInt64]
		$SiteId=1,

		[parameter(Mandatory = $true)]
		[System.String]
		$ResourcesVirtualPath,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$Hostnames,

		[parameter(Mandatory = $true)]
		[System.String[]]
		$StaUrls,

		[parameter()]
		[System.Boolean]
		$StasUseLoadBalancing,

		[parameter()]
		[System.String]
		$StasBypassDuration,

		[parameter()]
		[System.Boolean]
		$EnableSessionReliability,

		[parameter()]
		[System.Boolean]
		$UseTwoTickets,

		[parameter()]
		[System.String[]]
		$Farms,

		[parameter()]
		[System.String[]]
		$Zones,

		[parameter()]
		[System.Boolean]
		$EnabledOnDirectAccess,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

		$targetResource = Get-TargetResource @PSBoundParameters;
		If ($Ensure -eq 'Present') {
			$inCompliance = $true;
			foreach ($property in $PSBoundParameters.Keys) {
				if ($targetResource.ContainsKey($property)) {
					$expected = $PSBoundParameters[$property];
					$actual = $targetResource[$property];
					if ($PSBoundParameters[$property] -is [System.String[]]) {
						if ($actual) {
							if (Compare-Object -ReferenceObject $expected -DifferenceObject $actual) {
								Write-Verbose ($localizedData.ResourcePropertyMismatch -f $property, ($expected -join ','), ($actual -join ','));
								$inCompliance = $false;
							}
						}
						else {
							Write-Verbose ($localizedData.ResourcePropertyMismatch -f $property, ($expected -join ','), ($actual -join ','));
							$inCompliance = $false;
						}
					}
					elseif ($expected -ne $actual) {
						Write-Verbose ($localizedData.ResourcePropertyMismatch -f $property, $expected, $actual);
						$inCompliance = $false;
					}
				}
			}
		}
		Else {
			If ($targetResource.Name -eq $Name) {
				$inCompliance = $false
			}
			Else {
				$inCompliance = $true
			}
		}

		if ($inCompliance) {
			Write-Verbose ($localizedData.ResourceInDesiredState -f $DeliveryGroup);
		}
		else {
			Write-Verbose ($localizedData.ResourceNotInDesiredState -f $DeliveryGroup);
		}

		return $inCompliance;
}


Export-ModuleMember -Function *-TargetResource

