require "./track"
require "./result"
require "./file_finder"
require "./generators/m3u.cr"

# TODO: too many responsibilities, cut out: file<>track comparison
class SetlistToPlaylist::Setlist
  property tracks : Array(Track)
  property default_artist : String
  property fail_fast = false

  def initialize(setlist_text, @fail_fast = false)
    @tracks = [] of Track
    @default_artist = Dir.current.split('/').last
    setlist_text.each_line do |line|
      add_track(line)
    end
    raise "No tracks found in setlist. [#{setlist_text}]" if tracks.nil? || tracks.empty?
  end

  def generate_playlist(base_path)
    results = [] of Result
    Dir.open(base_path) do
      files = FileFinder.new.files
      tracks.each do |track|
        candidates = [] of String
        files.each do |file|
          if track.matches_file?(file)
            candidates << file
          end
        end
        if candidates.empty?
          results << Result.new(false, track, candidates, nil)
          handle_missing(track)
          next
        end
        chosen_file = determine_best_file(candidates)
        results << Result.new(true, track, candidates, chosen_file)
      end
    end
    results
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
    STDERR.puts "No track found for #{track.track_name}" unless fail_fast
  end
end
