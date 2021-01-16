# igniter

Runs https://github.com/weaveworks/ignite with docker-compose

    $ docker-compose up --force-recreate --build
    $ docker-compose exec app bash

    ignite run weaveworks/ignite-ubuntu \
                    --cpus 32 \
                    --memory 2GB \
                    --ssh \
                    --name pata

    ignite ssh pata
