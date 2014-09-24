class puppetconf::iis_enable {

  include puppetconf::dotnet_enable

  windowsfeature{'IIS_NET45':
    feature_name => [
      'Web-WebServer',
      'Web-Http-Errors',
      'Web-Http-Logging',
      'Web-Asp-Net45',
      'NET-Framework-45-ASPNET',
    ],
    installmanagementtools => true,
  } ~>

  # Remove default binding by removing default website
  # (so it can be used by something else)
  iis::manage_site {'Default Web Site':
    ensure   => absent,
    site_path => 'any',
    app_pool => 'DefaultAppPool',
  }
}
