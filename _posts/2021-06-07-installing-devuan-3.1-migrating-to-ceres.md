---
layout: post
title: Installing Devuan GNU/Linux 3.1 and Migrating to Ceres
description: Notes I compiled for future reference, in case I need to reinstall. They might help others switching to GNU/Linux, too.
---

## Introduction

I've been using Debian lately, but with a stripped down environment. For the most part I use a text console when logging in, and live mainly in GNU Emacs. When I want to use Firefox, I have a X11 session with Openbox as my window mangler.

This being the case, Debian with its default systemd is overkill. However, Debian has a working console setup that provides UTF-8 support and lets me remap Caps Lock to Compose without using X11, so I want to keep it.

I'm hoping the migrating from Debian to Devuan will let me reproduce my text-mode setup without having to depend on systemd. If this post seems disjointed, it's because I wrote it as notes to myself documenting my installation so I can reproduce it on other machines.

## Getting Devuan


I followed the instructions on Devuan's [download page][1] to get the netinstall ISO image for Devuan 3.1 (Beowulf).

Afterward, I was able to prep a USB drive with the following command.

```
$ sudo dd if=Downloads/devuan_beowulf_3.1.1_amd64_netinstall.iso \
          of=/dev/sdb \
          bs=1M \
          status=progress
```

## Installing Devuan

The image I put on my flash drive supports both BIOS systems and UEFI systems, but I'm old-school so I'm sticking with BIOS. Since I don't dual boot with Windows, I don't need UEFI. I'll be installing on my desktop machine first. It's a Lenovo ThinkCentre M92P that was originally manufactured in 2012. I bought it from a refurbisher in 2017, added a SSD, and maxed out the RAM.

Setting language to English...

Setting country to United States...

Setting keymap to American (US) English...

The installer used DHCP on eth0. I'll want to go back and set a static IP of 192.168.1.100 since that's where my router expects to find this machine.

Setting hostname to kether...

Setting domain name to phoenix.society...

Not gonna write anything about my root password or user setup.

Setting time zone to America/New_York...

Using manual partitioning since I already have partitions and don't want /home to get nuked.

* /dev/sda1 is /: 128GB, ext4, bootable, noatime
* /dev/sda2 is swap: 32GB
* /dev/sda3 is /home: 840.2GB, ext4, noatime

I'm going to use deb.devuan.org as my archive mirror. I don't need a proxy.

Since Devuan asked me to opt into package installation telemetry using popularity-contest instead of making me opt out, I decided to opt in.

For software selection I'm going with the following:

* Console productivity
* print service
* SSH server
* standard system utilities

I've turned off "Devuan desktop environment" because I want a bare-bones graphical environment built from selected packages. As I mentioned earlier, I want to live mainly in the console (and GNU Emacs) with only occasional forays into X11.

I'm going to stick with sysvinit as my init system. It works, and I'm not doing anything fancy so it's good enough.

GRUB is going into the master boot record on /dev/sda.

Installation is complete. Time to reboot and install additional packages...

## First Boot

Though I have an ordinary user, I'm logging in as root first. I need to enable sudo for my ordinary user, and I want to configure my console. I might as well do my package installation while I'm at it.

### Upgrading User Privileges

To upgrade my regular user, I ran the following command.

    # usermod -a -G sudo,audio,video,cdrom [username]

Running visudo on Devuan shows that anybody in group "sudo" will be able to use sudo to escalate privileges as needed. Adding my username to group "cdrom" allows me to rip CDs using abcde.

Yes, I *still* buy CDs because I like to own my music and because most musicians get paid fuck-all on services like Spotify, Deezer, etc.

### Console and Keyboard Setup

To setup the console, I need to enter the following command.

    $ sudo dpkg-reconfigure console-setup

Then I set the following options:

* encoding: UTF-8
* character set: guess optimal
* console font: TerminusBold
* font size: 16x32 (framebuffer only)

Next is keyboard configuration:

    $ sudo dpkg-reconfigure keyboard-configuration

* keyboard model: Generic 105-key PC (intl.)
* keyboard layout: English (US)
* key to function as AltGr: default
* compose key: Caps Lock

For my laptop, the keyboard model is "IBM Thinkpad R60/T60/R61/T61".

Now let's make sure we boot in framebuffer mode by editing `/etc/default/grub` and adding the following.

```
GRUB_GFXMODE=1600x1200x32
GRUB_TERMINAL=gfxterm
GRUB_GFXPAYLOAD_LINUX=keep
```

We'll use these settings for my Thinkpad T60.

```
GRUB_GFXMODE=1680x1050x32
GRUB_TERMINAL=gfxterm
GRUB_GFXPAYLOAD_LINUX=keep
```

And, just for shits and giggles, let's make GRUB play part of the
opening riff to Europe's "The Final Countdown" on boot.

GRUB_INIT_TUNE="480 554 1 494 1 554 4 370 6 10 3 587 1 554 1 587 2 554 2 494 6"

Finally, we'll apply our new settings.

    $ sudo update-grub

### Additional Packages

I'm adding the following to round out my experience.

* task-desktop
* task-console-productivity
* task-ssh-server
* cups
* cups-bsd
* cups-client
* foomatic-db-engine
* hp-ppd
* openprinting-ppds
* printer-driver-all
* build-essential
* git
* emacs
* libvterm-dev
* cmake
* neofetch
* offline-imap
* maildir-utils
* mu4e
* abcde
* mpv
* fonts-noto
* fonts-noto-cjk
* fonts-noto-color-emoji
* fonts-firacode
* openbox
* lxappearance
* comixcursors-righthanded-opaque
* materia-gtk-theme
* papirus-icon-theme
* stalonetray
* redshift-gtk
* quodlibet
* firefox-esr
* xscreensaver-gl
* dict
* dictd
* dict-devil
* dict-elements
* dict-foldoc
* dict-gcide
* dict-jargon
* dict-vera
* dict-wn
* fortune-mod
* fortune-anarchism
* fortunes-bofh-excuses
* fortunes-debian-hints
* fortunes-off
* anarchism
* gawk-doc
* m4-doc
* zangband
* asciinema
* unison
* pandoc
* texlive-full
* fbgrab
* xsltproc
* libreoffice
* gimp
* gimp-data-extras
* gimp-help-en
* firmware-amd-graphics
* firmware-atheros
* xclip
* deluge

I had ended up installing "task-desktop" after all because my wife came up and asked me what I thought would happen if she needed to use this particular computer and XFCE (her preferred environment on GNU/Linux) wasn't available.

Which reminds me; I need to create a user account for her, too.

### Disabling Graphical Login

Installing "task-desktop" also installed slim and enabled graphical login by default. That's not what I wanted, so this is how I fixed it.

```
$ sudo service slim stop
$ sudo update-rc.d slim disable
```

### Setting a Static IP on eth0

Since my desktop doesn't use wifi and doesn't get moved (I missed out on LAN parties, LOL), there's no need for DHCP networking. Let's set up a static IP on the home LAN instead.

First, let's edit `/etc/network/interface` and delete everything after the "allow-hotplug eth0" line. Then add the following to `/etc/network/interface.d/eth0`.

```
iface eth0 inet static
      address 192.168.1.100
      netmask 255.255.255.0
      gateway 192.168.1.1
```

### Migrating to Ceres for the Latest GNU Emacs

eww in GNU Emacs 26.1 can't access websites via HTTPS. Pulling package listings from MELPA is likewise a no go. I don't get paid enough to debug this, and Emacs 26.1 is old and busted anyway, so I might as well just upgrade to unstable.

This entails editing `/etc/apt/sources.list` that it contains the following text:

```
$ cat /etc/apt/sources.list
deb http://deb.devuan.org/merged unstable main contrib non-free
deb-src http://deb.devuan.org/merged unstable main contrib non-free
```

Next, run the following commands and say yes to all questions.

```
$ sudo apt update
$ sudo apt full-upgrade
$ sudo reboot
```

## Notes On Distribution Upgrades

Only run "apt full-upgrade" when changing releases. Otherwise, "apt upgrade" is fine. I rebooted because the migration upgraded my kernel version from 4.19 to 5.10.

[1]: https://www.devuan.org/get-devuan
