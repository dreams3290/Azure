configuration InstallIis{
    Node WebServer{
        WindowsFeature IIS
        {
            Ensure = 'present'
            Name = 'Web-Server'
            IncludeAllSubFeature = $true
        }
        }
        }