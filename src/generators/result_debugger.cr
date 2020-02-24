require "../result"

class SetlistToPlaylist::Generators::ResultDebugger
  property results : Array(Result)

  def initialize(@results)
  end

  def generate
    results.map { |result| result.inspect }.join("\n")
  end
end
