# docker-perlbase
A self contained buildable image (no internet required) which aims for full standard library layout for maximum compatability
with source based builds.

The user 'perl' configured with local::lib is the default login point, though this can be easily changed.

The purpose of this image is to create a single downloadable for when you simply need a working perl installation that 
has not been corrupted by the Operating System it is installed upon.

It also should be possible to use this image for quickly prototyping in many perl frameworks including but not limited to:
* Dancer2
* Catalyst
* Mojolicious
* POE
* Async
* AI
* Moose
* Moo
* Reflex

## Utilities

* App::plx
* Perl Brew
* cpanm
* dzil

## Modules

The following modules are installed and tested as working (dependancies are not included in this list):

* SSLeay...
