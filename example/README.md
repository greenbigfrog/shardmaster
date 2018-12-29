# Example
We'll be setting up both a master, that handles the shards, as well as 10 peers (bot shards)

1. Make sure to have docker in swarm mode, and a docker network you connect the master and peers (bots) to (`docker network create net`)
2. Start up the master: `docker service create --name shardmaster --network net greenbigfrog/shardmaster /shardmaster 10`
3. Set env var for Discord Token: `export TOKEN='Bot MzkzNDk3...5YcJCAKFJItZywUcE'`
4. Start up bot shards: `docker service create --name bot --network net -e TOKEN --replicas 10 greenbigfrog/shardmaster-example`
5. Verify that the shards are running in the different replicas using `docker service logs bot`. This might take a bit depending on the shard_num you chose, since one can only identify every 5 seconds