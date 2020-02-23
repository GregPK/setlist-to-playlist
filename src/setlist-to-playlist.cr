require "pathname"

require "clim"

require "clim"
require "./setlist"

class SetlistToPlaylistCommand < Clim
  main do
    option "-r bool", "--resultinfo=true", type: Bool, desc: "Print all available debug info on result output to STDOUT.", default: false
    option "-f bool", "--failfast=false", type: Bool, desc: "Prints only missing tracks to STDERR", default: false
    run do |opts, args|
      setlist = SetlistToPlaylist::Setlist.new(STDIN.gets_to_end, fail_fast = opts.failfast)
      playlist = setlist.generate_playlist(Dir.current)
      # refactor into separate object

      if opts.resultinfo
        STDOUT << playlist.map { |result| result.inspect }.join("\n")
      end
      if opts.failfast
        STDOUT << "No results found for:\n"
        STDOUT << playlist.reject(&.successful?).map { |result| result.query.source }.join("\n")
      else
        STDOUT << playlist.select(&.successful?).map { |result| result.result_data }.join("\n")
      end
      STDOUT << "\n"
    end
  end
end

SetlistToPlaylistCommand.start(ARGV)
