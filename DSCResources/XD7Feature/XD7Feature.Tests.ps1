$here = Split-Path -Parent $MyInvocation.MyCommand.Path;
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".");
. "$here\$sut";

## Dot source XD7Common functions
$moduleParent = Split-Path -Path $here -Parent;
Get-ChildItem -Path "$moduleParent\XD7Common" -Include *.ps1 -Exclude '*.Tests.ps1' -Recurse |
    ForEach-Object { . $_.FullName; }

Describe 'cXD7Feature\ResolveXDServerSetupArguments ' {

    It 'defaults log path to "%TMP%\Citrix\XenDesktop Installer".' {
        $role = 'Controller';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/logpath' | Should Be $true;
        $escapedPathRegex = (Join-Path $env:TMP -ChildPath '\Citrix\XenDesktop Installer').Replace('\', '\\');
        $arguments -match $escapedPathRegex | Should Be $true;
    }

    It 'returns expected Controller install arguments.' {
        $role = 'Controller';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components Controller' | Should Be $true;
        $arguments -match '/configure_firewall' | Should Be $true;
        $arguments -match '/nosql' | Should Be $true;
        
        $arguments -match '/remove' | Should Be $false;
    }

    It 'returns expected Controller uninstall arguments.' {
        $role = 'Controller';
        $arguments = ResolveXDServerSetupArguments  -Role $role -Uninstall;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components Controller' | Should Be $true;
        $arguments -match '/remove' | Should Be $true;

        $arguments -match '/configure_firewall' | Should Be $false;
        $arguments -match '/nosql' | Should Be $false;
    }
    
    It 'returns expected Studio install arguments.' {
        $role = 'Studio';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components DesktopStudio' | Should Be $true;
        $arguments -match '/configure_firewall' | Should Be $true;
        
        $arguments -match '/remove' | Should Be $false;
    }

    It 'returns expected Studio uninstall arguments.' {
        $role = 'Studio';
        $arguments = ResolveXDServerSetupArguments  -Role $role -Uninstall;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components DesktopStudio' | Should Be $true;
        $arguments -match '/remove' | Should Be $true;

        $arguments -match '/configure_firewall' | Should Be $false;      
    }

    It 'returns expected Storefront install arguments.' {
        $role = 'Storefront';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components Storefront' | Should Be $true;
        $arguments -match '/configure_firewall' | Should Be $true;
        
        $arguments -match '/remove' | Should Be $false;
    }

    It 'returns expected Storefront uninstall arguments.' {
        $role = 'Storefront';
        $arguments = ResolveXDServerSetupArguments  -Role $role -Uninstall;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components Storefront' | Should Be $true;
        $arguments -match '/remove' | Should Be $true;

        $arguments -match '/configure_firewall' | Should Be $false;      
    }

    It 'returns expected Licensing install arguments.' {
        $role = 'Licensing';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components LicenseServer' | Should Be $true;
        $arguments -match '/configure_firewall' | Should Be $true;
        
        $arguments -match '/remove' | Should Be $false;
    }

    It 'returns expected Licensing uninstall arguments.' {
        $role = 'Licensing';
        $arguments = ResolveXDServerSetupArguments  -Role $role -Uninstall;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components LicenseServer' | Should Be $true;
        $arguments -match '/remove' | Should Be $true;

        $arguments -match '/configure_firewall' | Should Be $false;      
    }

    It 'returns expected Director install arguments.' {
        $role = 'Director';
        $arguments = ResolveXDServerSetupArguments  -Role $role;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components DesktopDirector' | Should Be $true;
        
        $arguments -match '/configure_firewall' | Should Be $false;
        $arguments -match '/remove' | Should Be $false;
    }

    It 'returns expected Director uninstall arguments.' {
        $role = 'Director';
        $arguments = ResolveXDServerSetupArguments  -Role $role -Uninstall;
        $arguments -match '/quiet' | Should Be $true;
        $arguments -match '/logpath' | Should Be $true;
        $arguments -match '/noreboot' | Should Be $true;
        $arguments -match '/components DesktopDirector' | Should Be $true;
        $arguments -match '/remove' | Should Be $true;

        $arguments -match '/configure_firewall' | Should Be $false;      
    }

} #end describe cXD7Feature\ResolveXDServerSetupArguments

Describe 'cXD7Feature\Get-TargetResource' {
    $testDrivePath = (Get-PSDrive -Name TestDrive).Root;
    
    It 'returns a System.Collections.Hashtable.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Get-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource -is [System.Collections.Hashtable] | Should Be $true;
    }

    It 'returns input role, source path and credentials.' {
        $role = 'Controller';
        $credential = New-Object System.Management.Automation.PSCredential 'Username', (ConvertTo-SecureString -String 'Password' -AsPlainText -Force);
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Get-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present' -Credential $credential;
        $targetResource.Role | Should Be $role;
        $targetResource.SourcePath | Should Be $testDrivePath;
        $targetResource.Credential | Should Be $credential;
    }

    It 'returns Controller role is present.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith {
            return @{ Name = 'Citrx Desktop Delivery Controller'; };
        }
        $targetResource = Get-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource.Ensure | Should Be 'Present';
    }

    It 'returns Controller role is absent.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Get-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource.Ensure | Should Be 'Absent';
    }

    It 'returns Desktop Studio role is present.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Studio' } -MockWith {
            return @{ Name = 'Citrx Studio'; };
        }
        $targetResource = Get-TargetResource -Role 'Studio' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource.Ensure | Should Be 'Present';
    }

    It 'returns Desktop Studio role is absent.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Studio' } -MockWith { }
        $targetResource = Get-TargetResource -Role 'Studio' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource.Ensure | Should Be 'Absent';
    }
} #end describe cXD7Feature\Get-TargetResource

Describe 'cXD7Feature\Test-TargetResource' {
    $testDrivePath = (Get-PSDrive -Name TestDrive).Root;
    
    It 'returns a System.Boolean type.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Test-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource -is [System.Boolean] | Should Be $true;
    }

    It 'returns Controller role is installed when it should be.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith {
            return @{ Name = 'Citrx Desktop Delivery Controller'; };
        }
        $targetResource = Test-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource | Should Be $true;
    }

    It 'returns Controller role is not installed when it should be.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Test-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Present';
        $targetResource | Should Be $false;
    }

    It 'returns Controller role is not installed when it should not be.' {
        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith { }
        $targetResource = Test-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Absent';
        $targetResource | Should Be $true;
    }

    It 'returns Controller role is installed when it should not be.' {

        Mock -CommandName GetXDInstalledRole -ParameterFilter { $Role -eq 'Controller' } -MockWith {
            return @{ Name = 'Citrx Desktop Delivery Controller'; };
        }
        $targetResource = Test-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Absent';
        $targetResource | Should Be $false;
    }
} #end describe cXD7Feature\Test-TargetResource

Describe 'cXD7Feature\Set-TargetResource' {
    $testDrivePath = (Get-PSDrive -Name TestDrive).Root  
    [ref] $null = New-Item -Path 'TestDrive:\x86\Xen Desktop Setup' -ItemType Directory;
    [ref] $null = New-Item -Path 'TestDrive:\x86\Xen Desktop Setup\XenDesktopServerSetup.exe' -ItemType File;
    [ref] $null = New-Item -Path 'TestDrive:\x86\Xen Desktop Setup\XenDesktopVdaSetup.exe' -ItemType File;
    Mock -CommandName 'ResolveXDSetupMedia' -MockWith { return "$testDrivePath\x86\XenDesktop Setup\XenDesktopServerSetup.exe"; }  

    It 'calls install StartWaitProcess with no reboot required.' {
        [System.Int32] $global:DSCMachineStatus = 0;
        Mock -CommandName 'StartWaitProcess' -Verifiable -MockWith { return 0;}
        Set-TargetResource -Role 'Controller' -SourcePath $testDrivePath;
        [System.Int32] $global:DSCMachineStatus | Should Be 0;
        Assert-VerifiableMocks;
    }
    
    It 'calls install StartWaitProcess with reboot required.' {
        [System.Int32] $global:DSCMachineStatus = 0;
        Mock -CommandName 'StartWaitProcess' -Verifiable -MockWith { return 3010;}
        Set-TargetResource -Role 'Controller' -SourcePath $testDrivePath;
        [System.Int32] $global:DSCMachineStatus | Should Be 1;
        Assert-VerifiableMocks;
    }

    It 'calls uninstall StartWaitProcess with no reboot required.' {
        [System.Int32] $global:DSCMachineStatus = 0;
        Mock -CommandName 'StartWaitProcess' -Verifiable -MockWith { return 0;}
        Set-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Absent';
        [System.Int32] $global:DSCMachineStatus | Should Be 0;
        Assert-VerifiableMocks;
    }
    
    It 'calls uninstall StartWaitProcess with reboot required.' {
        [System.Int32] $global:DSCMachineStatus = 0;
        Mock -CommandName 'StartWaitProcess' -Verifiable -MockWith { return 3010;}
        Set-TargetResource -Role 'Controller' -SourcePath $testDrivePath -Ensure 'Absent';
        [System.Int32] $global:DSCMachineStatus | Should Be 1;
        Assert-VerifiableMocks;
    }

    It 'throws with an invalid directory path.' {
        { Set-TargetResource -Role 'Controller' -SourcePath 'Z:\HopefullyThisPathDoesNotExist' } | Should Throw;
    }

    It 'throws with a valid file path.' {
        [ref] $null = New-Item -Path 'TestDrive:\XenDesktopServerSetup.exe' -ItemType File;
        { Set-TargetResource -Role 'Controller' -SourcePath "$testDrivePath\XenDesktopServerSetup.exe" } | Should Throw;
    }
    
} #end describe cXD7Feature\Set-TargetResource
