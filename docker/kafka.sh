#/bin/sh

# docker image is from https://hub.docker.com/r/spotify/kafka/

# ----- Doc Start ----

if false; then
Take the same parameters as the spotify/kafka image with some new ones:

CONSUMER_THREADS - the number of threads to consume the source kafka 7 with
TOPICS - whitelist of topics to mirror
ZK_CONNECT - the zookeeper connect string of the source kafka 7
GROUP_ID - the group.id to use when consuming from kafka 7
docker run -p 2181:2181 -p 9092:9092 \
    --env ADVERTISED_HOST=`boot2docker ip` \
    --env ADVERTISED_PORT=9092 \
    --env CONSUMER_THREADS=1 \
    --env TOPICS=my-topic,some-other-topic \
    --env ZK_CONNECT=kafka7zookeeper:2181/root/path \
    --env GROUP_ID=mymirror \
    spotify/kafkaproxy

e.g.
docker run -d --hostname kafka --name kafka \
    -p 2181:2181 -p 9092:9092 \
    --env ADVERTISED_HOST=`docker-machine ip \`docker-machine active\``  \
    --env ADVERTISED_PORT=9092 \
    spotify/kafka

fi
# ----- Doc Finished -----

docker run --hostname kafka --name kafka \
    -p 2181:2181 -p 9092:9092 \
    --env ADVERTISED_HOST=mwl2.com \
    --env ADVERTISED_PORT=9092 \
    spotify/kafka &
