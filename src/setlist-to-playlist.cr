require "pathname"

require "clim"

require "./setlist"
require "./generators/m3u"
require "./generators/failed_list"
require "./generators/result_debugger"

# Generators = SetlistToPlaylist::Generators

class SetlistToPlaylist::SetlistToPlaylistCommand < Clim
  main do
    option "-r bool", "--resultinfo=true", type: Bool, desc: "Print all available debug info on result output to STDOUT.", default: false
    option "-f bool", "--failfast=false", type: Bool, desc: "Prints only missing tracks to STDERR", default: false
    run do |opts, args|
      setlist = SetlistToPlaylist::Setlist.new(STDIN.gets_to_end, fail_fast = opts.failfast)
      results = setlist.generate_playlist(Dir.current)
      # refactor into separate object

      if opts.resultinfo
        STDOUT << Generators::ResultDebugger.new(results).generate
      end
      if opts.failfast
        STDOUT << Generators::FailedList.new(results).generate
      else
        STDOUT << Generators::M3U.new(results).generate
      end
      STDOUT << "\n"
    end
  end
end

SetlistToPlaylist::SetlistToPlaylistCommand.start(ARGV)
