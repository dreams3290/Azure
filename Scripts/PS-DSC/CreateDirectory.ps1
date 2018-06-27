Configuration CreateDirectory
{
    File CreateDirectory{
        Ensure = "present"
        Type = "Directory"
        DestinationPath = "C:\inetpub\wwwroot\MyDemo2"
    }
}