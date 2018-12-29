require "./server"

master = Shardmaster::Server.new(ARGV[0].to_i32)
master.run
