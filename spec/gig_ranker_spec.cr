require "spec"
require "../src/gig_ranker"
require "../src/gig"

module SetlistToPlaylist
  describe GigRanker do
    describe "#ranked_gigs" do
      context "with same gigs, only date differs" do
        gigs = [] of Gig
        gigs << Gig.new(date: Date.new(9.days.ago), track_count: 10)
        gigs << Gig.new(date: Date.new(3.days.ago), track_count: 10)
        gigs << Gig.new(date: Date.new(6.days.ago), track_count: 10)
        gigs << Gig.new(date: Date.new(12.days.ago), track_count: 10)

        ranked = GigRanker.new(gigs).ranked_gigs

        (ranked[0].date).should eq Date.new(3.days.ago)
      end
    end
  end
end
