# shardmaster

Allows you to simply manage (semi automatic) sharding of your discord bot running in a docker swarm (across multiple hosts)

## Installation

For the master, you can simply use the docker image (`greenbigfrog/shardmaster`). For the peers add the following to your `shard.yml`:
```yml
dependencies:
  shardmaster:
    github: greenbigfrog/shardmaster
    branch: master
```

## Usage

View `example/README.md` for more info

Run the master in a docker container called `shardmaster` and has mutual network with the peers:
```
docker service create --name shardmaster --network net greenbigfrog/shardmaster /shardmaster 10
```

Get shard:
```cr
require "shardmaster/peer"
shard = Shardmaster::Peer.get_shard
shard_id = shard[:id]
num_shards = shard[:shard_count]
```

Post ping every < 5 minutes to keep the shard from expiring:
```cr
require "shardmaster/peer"
Shardmaster::Peer.post_ping(shard_id)
```

## Development

```
docker build -t greenbigfrog/shardmaster-example -f example/Dockerfile .
```
```
docker build -t greenbigfrog/shardmaster .
```

## Contributing

1. Fork it (<https://github.com/greenbigfrog/shardmaster/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jonathan B.](https://github.com/greenbigfrog) - creator and maintainer
