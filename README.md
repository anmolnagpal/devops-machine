

<h1 align="center">
    DevOps Machine 
</h1>
<p align="center" style="font-size: 1.2rem;"> DevOps machine using docker </p>

<hr />

[![CircleCI](https://circleci.com/gh/anmolnagpal/devops-machine/tree/master.svg?style=svg)](https://circleci.com/gh/anmolnagpal/devops-machine/tree/master)

##### 1.0 - Install Docker

if you have it installed you can skip this step otherwise  run this command:

```
brew install docker docker-compose
```

## 2- Prepare the Workspace:

##### 2.0 - to create the workspace directory run the following command

```
mkdir ~/workspace
```
now lets cd in
```
cd ~/workspace
```
now lets clone the devops-machine repository.
```
git clone https://github.com/anmolnagpal/devops-machine
cd devops-machine
```
Make sure that you are at master branch & have updated code 
```
git checkout master && git pull origin master
```
## 3- Start machine:

##### 3.0 - Now lets bring the devops machine up

```
make up
```

##### 3.1 - Lets do the ssh into the  devops machinea and start automation the things ;)

```
make ssh 
```
## ☑ Tools Added

- [X] PHP
- [X] Packer
- [X] Python
- [X] Ansible
- [X] Terraform
- [X] Helm
- [X] Kubectl

## ☑ TODO

- [ ] Add other devops tools

## 👬 Contribution

- Open pull request with improvements
- Reach out with any feedback [![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/anmol_nagpal.svg?style=social&label=Follow%20anmolnagpal)](https://twitter.com/anmol_nagpal)
