## Getting Started

### OSX - Homebrew + Tooling

- Install

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

- Use Brew to install Git

```
brew install git
```

- Install brew-cask for binary applications

```
brew update && brew install caskroom/cask/brew-cask
```

- Use brew cask to install VirtualBox

```
brew cask install virtualbox
```

- Use brew to install Vagrant

```
brew cask install vagrant
```

- Install the vagrant oscar plugin

```
vagrant plugin install oscar
```


### Windows - Chocolatey + Tooling

- Install Chocolatey

```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```

- Use Chocolatey to install Git

```
choco install git
```

- Use Chocolatey to install VirtualBox

```
choco install virtualbox
```

- Use Chocolatey to install Vagrant

```
choco install vagrant
```

- Install the Vagrant Oscar plugin

```
vagrant plugin install oscar
```

### Running from this repository

```
git clone https://github.com/Iristyle/puppetconf2014
cd puppetconf2014
vagrant up --provider=virtualbox
```

#### Access the PE console

[PE Console](https://localhost:4443)

```
user: admin@puppetlabs.com
pass: puppetlabs
```

#### SSH to the master

```
vagrant ssh master
```

#### RDP to the Windows agent

```
vagrant rdp win2012-web-agent
```

### Footnotes

#### Building Your Own VMs

* [Joe Fitzgerald's Windows Templates](https://github.com/joefitzgerald/packer-windows)
* [Box-cutter](https://github.com/box-cutter/windows-vm)

#### Modules Used

* [ACL Module](https://forge.puppetlabs.com/puppetlabs/acl)
* [PowerShell Module](https://forge.puppetlabs.com/puppetlabs/powershell)
* [Registry Module](https://forge.puppetlabs.com/puppetlabs/registry)
* [DISM](https://forge.puppetlabs.com/puppetlabs/dism)
* [Nan Staging Module](https://forge.puppetlabs.com/nanliu/staging)
* [OpenTable IIS](https://forge.puppetlabs.com/opentable/iis)
