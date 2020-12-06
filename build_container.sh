docker build -t rails_vanilla .
docker run -d -v `pwd`/myapp:/home/myapp --name rails_practice rails_vanilla tail -f /dev/null