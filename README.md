##1. Installing the tools

#####1.1 - first you need to install Homebrew and Cask, you can do so by running following commands in sequence 

```
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor //this is just to make sure Homebrew installed successfully
 
brew tap caskroom/cask
brew install cask
```
#####1.2 - then you need to install virtualbox, since our docker's setup relies on a virtual machine that is powered by 
virtualbox,

if you have it installed you can skip this step otherwise open up your terminal and run this command:

```
brew cask install virtualbox
```

#####1.3 then install docker and its tools

if you have it installed you can skip this step otherwise  run this command:

```
brew install docker docker-compose docker-machine
```

#####1.4 then install docker credentials helper 
if you have it installed you can skip this step otherwise run this command:

```
brew install docker-credential-helper
```

##2- Prepare the workspace:

