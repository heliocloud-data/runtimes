# first argument is version
docker build --no-cache --progress=plain -t helio-notebook-py:$1 .
#docker build -t helio-notebook-py:$1 .
docker image ls
