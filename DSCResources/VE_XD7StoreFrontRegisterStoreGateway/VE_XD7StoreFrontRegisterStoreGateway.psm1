<#
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.157
	 Created on:   	2/8/2019 12:12 PM
	 Created by:   	CERBDM
	 Organization: 	Cerner Corporation
	 Filename:     	VE_XD7StoreFrontRegisterStoreGateway.psm1
	-------------------------------------------------------------------------
	 Module Name: VE_XD7StoreFrontRegisterStoreGateway
	===========================================================================
	
	.Example
		Configuration XD7StoreFrontRegisterStoreGatewayExample {
			Import-DscResource -ModuleName XenDesktop7
			XD7StoreFrontRegisterStoreGateway XD7StoreFrontRegisterStoreGatewayExample {
				GatewayName = 'Netscaler'
				StoreName = 'mock'
				Ensure = 'Present'
			}
		}

#>



Import-LocalizedData -BindingVariable localizedData -FileName VE_XD7StoreFrontRegisterStoreGateway.Resources.psd1;

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$StoreName,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[ValidateSet("CitrixAGBasic","CitrixAGBasicNoPassword","HttpBasic","Certificate","CitrixFederation","IntegratedWindows","Forms-Saml","ExplicitForms")]
		[System.String[]]
		$AuthenticationProtocol,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	Import-module Citrix.StoreFront -ErrorAction Stop -Verbose:$false;
	Write-Verbose "Calling Get-STFStoreService"
	$StoreService = Get-STFStoreService | Where-object {$_.friendlyname -eq $StoreName};
	If ($StoreService) {
		Write-Verbose "Calling Get-STFAuthenticationService"
		$Auth = Get-STFAuthenticationService -VirtualPath ($StoreService.AuthenticationServiceVirtualPath) -SiteID ($StoreService.SiteId)
		$EnabledProtocols = $auth.authentication.ProtocolChoices | Where-Object {$_.Enabled} | Select-object -ExpandProperty Name
	}

	$returnValue = @{
		StoreName = [System.String]$StoreService.name
		GatewayName = [System.String]$StoreService.gateways.Name
		AuthenticationProtocol = [System.String[]]$EnabledProtocols
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$StoreName,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[ValidateSet("CitrixAGBasic","CitrixAGBasicNoPassword","HttpBasic","Certificate","CitrixFederation","IntegratedWindows","Forms-Saml","ExplicitForms")]
		[System.String[]]
		$AuthenticationProtocol,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	Import-module Citrix.StoreFront -ErrorAction Stop -Verbose:$false;
	Write-Verbose "Calling Get-STFStoreService for store: $StoreName"
	$StoreService = Get-STFStoreService | Where-object {$_.friendlyname -eq $StoreName};
	Write-Verbose "Calling Get-STFRoamingGateway for gateway: $GatewayName"
	$GatewayService = Get-STFRoamingGateway -Name $GatewayName
	Write-Verbose "Calling Get-STFAuthenticationService"
	$Auth = Get-STFAuthenticationService -VirtualPath ($StoreService.AuthenticationServiceVirtualPath) -SiteID ($StoreService.SiteId)

	If ($Ensure -eq "Present") {
		Write-Verbose "Running Register-STFStoreGateway"
		Register-STFStoreGateway -Gateway $GatewayService -StoreService $StoreService -DefaultGateway
		foreach ($Protocol in $Auth.Authentication.ProtocolChoices) {
			If ($AuthenticationProtocol -contains $Protocol.Name) {
				If ($Protocol.Enabled) {
					Write-Verbose "$($Protocol.Name) is already enabled"
				}
				Else {
					Write-Verbose "Enabling $($Protocol.Name)"
					Enable-STFAuthenticationServiceProtocol -Name $Protocol.Name -AuthenticationService $Auth
				}
			}
			Else {
				If ($Protocol.Enabled) {
					Write-Verbose "Disabling $($Protocol.Name)"
					Disable-STFAuthenticationServiceProtocol -Name $Protocol.Name -AuthenticationService $Auth
				}
				Else {
					Write-Verbose "$($Protocol.Name) is already disabled"
				}
			}
		}
		

	}
	Else {
		Write-Verbose "Running UnRegister-STFStoreGateway"
		UnRegister-STFStoreGateway -Gateway $GatewayService -StoreService $StoreService
	}

}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$StoreName,

		[parameter(Mandatory = $true)]
		[System.String]
		$GatewayName,

		[parameter(Mandatory = $true)]
		[ValidateSet("CitrixAGBasic","CitrixAGBasicNoPassword","HttpBasic","Certificate","CitrixFederation","IntegratedWindows","Forms-Saml","ExplicitForms")]
		[System.String[]]
		$AuthenticationProtocol,

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
						if (Compare-Object -ReferenceObject $expected -DifferenceObject $actual) {
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
			If ($targetResource.GatewayName -eq $GatewayName) {
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

