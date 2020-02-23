require "./track"

# TODO: too many responsibilities, cut out: generation, file<>track comparison
class S2pRb::Setlist
  property tracks : Array(Track)
  property default_artist : String

  def initialize(setlist_text)
    @tracks = [] of Track
    @default_artist = Dir.current.split('/').last
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
        if candidates.empty?
          handle_missing(track)
          next
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

  def handle_missing(track)
    STDERR.puts "No track found for #{track.track_name}"
  end
end
