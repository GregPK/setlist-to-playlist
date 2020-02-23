require "pathname"

# TODO: make more of a value object
class SetlistToPlaylist::Result
  property success : Bool
  property query : Track
  property candidates : Array(String)

  property result_data : String?

  def initialize(@success, @query, @candidates, @result_data)
  end

  def successful?
    success
  end
end
