#!/bin/bash -eu
docker build -t rails_vanilla .
docker run -d -v `pwd`:/home/myapp -p 3000:3000 --name rails_practice rails_vanilla tail -f /dev/null