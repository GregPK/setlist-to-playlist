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
    # p [filepath.dirname.to_s, filepath.basename.to_s]
    filepath.dirname.to_s.match(/#{artist}/i) && filepath.basename.to_s.match(/#{track_name}/i)
  end

  def parse_line(line,default_artist)
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


class S2pRb::Setlist
    property tracks : Array(Track)
    property default_artist : String

    def initialize(setlist_text)
        @tracks = [] of Track
        @default_artist = ""
    setlist_text.each_line do |line|
        add_track(line)
    end
    raise "No tracks found in setlist. [#{setlist_text}]" if tracks.nil? || tracks.empty?
    end

    def generate_playlist(base_path)
    Dir.open(base_path) do
        files = Dir.glob("**/*.{mp3,flac}")
        tracks.each do |track|
        candidates = [] of String
        files.each do |file|
            if track.matches_file?(file)
            candidates << file
            end
        end
        chosen_file = determine_best_file(candidates)
        track.file_path = chosen_file
        end
    end
    tracks
    end

    def determine_best_file(candidates)
    return candidates.first if candidates.size < 2
    candidates.sort_by do |candidate_file|
        candidate_file.size
    end.first
    end

    def add_track(track_line)
    track = Track.new(track_line, default_artist)
    self.tracks << track
    end
end

setlist = S2pRb::Setlist.new(STDIN.gets_to_end)
playlist = setlist.generate_playlist(Dir.current)
STDOUT << playlist.map{|t| t.file_path}.join("\n")
STDOUT << "\n"