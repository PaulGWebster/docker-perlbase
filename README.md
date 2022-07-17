# Docker perlbase

A self contained buildable image (no internet required) which aims for full 
standard library layout for maximum compatabilitywith source based builds.

## Purpose

First of all, this is not an all-inclusive image, it simply is a collection of 
some of the more common and or more awkward to get working ones.

The purpose of this image is to create a single downloadable source buildable 
image for when you simply need a working perl installation that has not been 
corrupted by the Operating System it is installed upon.


# Usage

## Fast answer
```docker run -it paulgwebster/perlbase:release```

## Longer answer
Beware that unlike most images, this one is a single large layer, this is done 
to allow additional layers to be added with as much flexibility as possible, it 
also allows for the image to be exported from docker and placed on a USB pen 
drive easily.

Expected size: 4Gb~

This will log you into a bash shell as the user 'perl', fully ready to run 
whatever perl code you may wise.


# Building

## Fast answer
```cd build && ./buildall.sh```

## Longer answer

You really should not have to build the final docker image yourself, however if 
you wish so it may be done by reading the README.md within build/

## Modules

The following modules are installed and tested as working, though this list is 
not exhaustive it simply is the more common of the installed!

### Utilities

* App::plx
* Perl Brew
* cpanm
* dzil

### Database

#### Drivers

* DBD::mysql
* DBD::Pg
* DBD::Sqlite
* DBD::Redis

### Frameworks

#### Web

* Mojolicious
* Catalyst
* Dancer2
* CGI

### Testing

### Misc

* SSLeay...