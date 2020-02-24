require "../result"

class SetlistToPlaylist::Generators::FailedList
  property results : Array(Result)

  def initialize(@results)
  end

  def generate
    out = ""
    out += "No results found for:\n"
    out += results.reject(&.successful?).map { |result| result.query.source }.join("\n")
    out
  end
end
