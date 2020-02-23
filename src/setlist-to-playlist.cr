require "pathname"

require "clim"

require "clim"
require "./setlist"

class SetlistToPlaylistCommand < Clim
  main do
    option "-r bool", "--resultinfo=true", type: Bool, desc: "Print all available debug info on result output to STDOUT.", default: false
    run do |opts, args|
      setlist = S2pRb::Setlist.new(STDIN.gets_to_end)
      playlist = setlist.generate_playlist(Dir.current)
      # refactor into separate object
      if opts.resultinfo
        STDOUT << playlist.map { |result| result.inspect }.join("\n")
      else
        STDOUT << playlist.select(&.successful?).map { |result| result.result_data }.join("\n")
      end
      STDOUT << "\n"
    end
  end
end

SetlistToPlaylistCommand.start(ARGV)
