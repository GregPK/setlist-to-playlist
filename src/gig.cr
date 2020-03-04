require "./lib/date"

# A representation of a Gig preview. ie a gig without all the track info
# Should containt sufficient info to make decisions as to which gig to use.
class SetlistToPlaylist::Gig
  property source_url : String
  property venue : String
  property date : Date
  property track_count : Int32

  def initialize(@artist = "", @venue = "", @date = Date.new, @track_count = 0, @source_url = "")
  end
end
