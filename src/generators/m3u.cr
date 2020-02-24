require "../result"

class SetlistToPlaylist::Generators::M3U
  property results : Array(Result)

  def initialize(@results)
  end

  def generate
    results.select(&.successful?).map { |result| result.result_data }.join("\n")
  end
end
