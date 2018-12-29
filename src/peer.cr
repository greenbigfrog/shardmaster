require "json"

module Shardmaster
  module Peer
    BASE = "http://shardmaster:8080/"

    def self.get_shard
      res = HTTP::Client.get(BASE + "available_shard")
      raise "Error getting an available_shard ID" unless res.success?
      json = JSON.parse(res.body)
      {id: json["shard"].as_i, shard_count: json["shard_count"].as_i}
    end

    def self.post_ping(id : Int32)
      HTTP::Client.post(BASE + "ping", body: {id: id, status: true}.to_json)
    end

    def self.get_ping
      res = HTTP::Client.get(BASE + "ping")
      raise "Error getting ping from shard master" unless res.success?
      JSON.parse(res.body).as_h
    end
  end
end
