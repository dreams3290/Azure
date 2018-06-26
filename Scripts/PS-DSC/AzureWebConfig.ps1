configuration AzureWebConfig{
    Node WebServer{
        WindowsFeature IIS
        {
            Ensure = 'present'
            Name = 'Web-Server'
            IncludeAllSubFeature = $true
        }
        Group Developers
        {
            Ensure = 'Present'
            GroupName = 'DevGroup'
        }
        File DirectoryCreate{
            Ensure = 'Present'
            Type = "Directory"
            DestinationPath = "C:\users\Public\Documents\MyDemo"           
        }
        Log AfterDirectoryCreate{
            Message = "Directory created using DSC"
            DependsOn = '[File]DirectoryCreate'
        }
    }  
}