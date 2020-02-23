require "pathname"

require "clim"

require "clim"
require "./setlist"

class SetlistToPlaylistCommand < Clim
  main do
    run do |opts, args|
      setlist = S2pRb::Setlist.new(STDIN.gets_to_end)
      playlist = setlist.generate_playlist(Dir.current)
      STDOUT << playlist.map { |t| t.file_path }.join("\n")
      STDOUT << "\n"
    end
  end
end

SetlistToPlaylistCommand.start(ARGV)
