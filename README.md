# CentOS 6.5 Environment

## Overview

This repository contains the source template for the CentOS 6.5
image used in the O'Reilly Learning Chef book.  The image
is published on [VagrantCloud](https://vagrantcloud.com/learningchef/centos65).

To use the training VM, install [Vagrant](http://www.vagrantup.com/downloads.html)
and configure with your favorite virtualization software (like
[VirtualBox](https://www.virtualbox.org/)).  Spin up the training environment
with the following commands:

    vagrant box add learningchef/centos65
    mkdir chef
    cd chef
    vagrant init learningchef/centos65
    vagrant up
    vagrant ssh

## Building the training environment

To build all the training environments, you will need both VirtualBox and
VMware Fusion installed.

A GNU Make `Makefile` drives the process via the following targets:

    make        # Build all the box types (VirtualBox & VMware)
    make test   # Run tests against all the boxes
    make list   # Print out individual targets
    make clean  # Clean up build detritus
    
The tests are written in [Serverspec](http://serverspec.org) and require the
`vagrant-serverspec` plugin to be installed with:

    vagrant plugin install vagrant-serverspec
    
The `Makefile` has individual targets for each box type with the prefix
`test-*` should you wish to run tests individually for each box.

Similarly there are targets with the prefix `ssh-*` for registering a
newly-built box with vagrant and for logging in using just one command to
do exploratory testing.  For example, to do exploratory testing
on the VirtualBox training environmnet, run the following command:

    make ssh-box/virtualbox/centos65
    
Upon logout `make ssh-*` will automatically de-register the box as well.
