require "discordcr"
require "../src/peer"

shard = Shardmaster::Peer.get_shard
shard_id = shard[:id]
num_shards = shard[:shard_count]

bot = Discord::Client.new(ENV["TOKEN"], shard: {shard_id: shard_id, num_shards: num_shards})

spawn do
  Discord.every(1.minutes) do
    Shardmaster::Peer.post_ping(shard_id)
  end
end

bot.run
