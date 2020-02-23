require "pathname"

class S2pRb::Track
  property artist : String
  property track_name : String
  property file_path : String

  def initialize(line, default_artist)
    @artist = ""
    @track_name = ""
    @file_path = ""
    parse_line(line, default_artist)
  end

  def matches_file?(filepath)
    filepath = Pathname.new(filepath)
    track_matched = filepath.basename.to_s.match(/#{track_name}/i)
    # p [track_name, filepath.dirname.to_s, filepath.basename.to_s] if track_matched
    return track_matched
    # track_matched && filepath.dirname.to_s.match(/#{artist}/i)
  end

  def parse_line(line, default_artist)
    tokens = line.split('-')
    if tokens.size == 2
      self.artist = tokens[0].strip
      self.track_name = tokens[1].strip
    else
      self.artist = default_artist
      self.track_name = tokens[0].strip
    end
  end
end
