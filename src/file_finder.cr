require "pathname"

class S2pRb::FileFinder
  property files : Array(String)

  def initialize(filter = ->{ true })
    @files = Dir.glob("**/*.{mp3,flac}").select &filter
  end
end
