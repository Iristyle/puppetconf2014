class puppetconf::dotnet_enable {
  windowsfeature{'NET45':
    feature_name => [
    'NET-Framework-45-Features',
    'NET-Framework-45-Core',
    ],
  }
}
