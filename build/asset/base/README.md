# History
* docker run -it gcc:12.1.0 bash
* # did run to find the id to export
* docker export 535d693f977e > perlbase.base.dockerimg
* mv perlbase.base.dockerimg gcc:12.1.0.dockerimg
* ln -s gcc\:12.1.0.dockerimg base.dockerimg
* docker import base.dockerimg perlbase:base
