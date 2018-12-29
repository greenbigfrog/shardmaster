require "kemal"
require "json"

module Shardmaster
  class Shards
    alias Entries = Hash(Int32, Time?)
    getter shards : Entries = Entries.new

    def initialize(size)
      size.times { |x| @shards[x] = nil }
    end

    def time_out(timeout : Time::Span)
      @shards.each do |id, time|
        next unless time
        @shards[id] = nil if time < Time.utc_now - timeout
      end
    end

    def get_unavailable
      res = @shards.map do |id, time|
        id unless time
      end
      res.compact
    end

    def get_all
      @shards.compact
    end

    def update_time(id, time : Time? = nil)
      @shards[id] = time ? time : Time.utc_now
    end
  end

  class Server
    @mutex : Mutex = Mutex.new
    @last_shard_time : Time = Time.utc_now

    def initialize(@shard_count : Int32)
      # @server_count = 0
      # @user_count = 0
      @shards = Shards.new(@shard_count)
    end

    def run
      # get "/stats" do
      #   {server_count: @server_count, user_count: @user_count}
      # end

      get "/ping" do
        get_all.to_json
      end

      post "/ping" do |env|
        id = env.params.json["id"]?
        halt env, 405 unless id.is_a?(Int32)
        @shards.update_time(id)
      end

      get "/available_shard" do |env|
        id = nil
        @mutex.synchronize do
          time = Time.utc_now - @last_shard_time
          sleep (5.seconds - time) if time < 5.seconds

          id = get_unavailable_shards[0]?
          # ttl : Give a shard 10 minutes to send a ping
          ttl = Time.utc_now + 10.minutes
          set_checkout_time(id, ttl) if id
        end
        halt env, 405 unless id

        @last_shard_time = Time.utc_now

        {shard: id, shard_count: @shard_count}.to_json
      end

      Kemal.run do |conf|
        conf.env = "production"
        conf.port = 8080
      end
    end

    private def get_all
      time_out
      @shards.get_all
    end

    private def get_unavailable_shards
      time_out
      @shards.get_unavailable
    end

    private def set_checkout_time(id : Int32, time : Time? = nil)
      @shards.update_time(id, time)
    end

    private def time_out
      @shards.time_out(5.minutes)
    end
  end
end
