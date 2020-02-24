require "pathname"
require "clim"

require "./setlist"
require "./generators/m3u"
require "./generators/failed_list"
require "./generators/result_debugger"

class SetlistToPlaylist::SetlistToPlaylistCommand < Clim
  main do
    option "-r", "--result-info=true", type: Bool, desc: "Print all available debug info on result output to STDOUT.", default: false
    # Uncomment after unbugged https://github.com/at-grandpa/clim/issues/54
    # option "-a", "--absolute-paths", type: Bool, desc: "Output absolute paths. Makes playlist files more moveable.", default: true
    option "-f", "--fail-fast=false", type: Bool, desc: "Prints only missing tracks to STDERR", default: false
    run do |opts, args|
      setlist = Setlist.new(STDIN.gets_to_end, fail_fast = opts.fail_fast)
      results = setlist.generate_playlist(Dir.current)

      if opts.result_info
        STDOUT << Generators::ResultDebugger.new(results).generate
      end
      if opts.fail_fast
        STDOUT << Generators::FailedList.new(results).generate
      else
        STDOUT << Generators::M3U.new(results).generate
      end
      STDOUT << "\n"
    end
  end
end

SetlistToPlaylist::SetlistToPlaylistCommand.start(ARGV)
