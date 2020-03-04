require "./gig"

# Given, a list of gigs, rank them by most valuable.
class SetlistToPlaylist::GigRanker
  property gigs : Array(Gig)

  def initialize(@gigs)
  end

  def ranked_gigs
    gigs.sort_by { |gig| gig.date }.reverse
  end
end
