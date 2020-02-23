require "pathname"

class SetlistToPlaylist::FileFinder
  property files : Array(String)

  def initialize(filter = ->{ true })
    @files = Dir.glob("**/*.{mp3,flac}").select &filter
  end
end
