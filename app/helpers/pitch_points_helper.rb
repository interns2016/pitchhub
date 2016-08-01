module PitchPointsHelper

  def self.pitch_points_hash
    @pitch_points = [ { :selected => true,
                        :optional => false,
                        :selected_and_emptyable => false,
                        :top_level_commentable => false,
                        :suggestible => true,
			:name => "Idea",
                        :placeholder => " Describe the idea ",
                        :tooltip => "Why is it important, worthwhile or useful?"
                      },
                      { :selected => true,
                        :optional => true,
                        :selected_and_emptyable => true,
                        :top_level_commentable => false,
                        :suggestible => true,
                        :name => "Business Opportunity",
                        :placeholder => "Which business could use that idea ?",
                        :tooltip => "The opportunity to seize"
                      },
                      { :selected => true,
                        :optional => true,
                        :selected_and_emptyable => true,
                        :top_level_commentable => false,
                        :suggestible => true,
                        :name => "Resources",
			:placeholder => "What do we need ?",
                        :tooltip => "The available resources"
                      },
 		      { :selected => true,
                        :optional => true,
                        :selected_and_emptyable => true,
                        :top_level_commentable => false,
                        :suggestible => true,
			:name => "Solutions",
			:placeholder => "How can we solve it ?",
                        :tooltip => "The solution"
                      },
                      { :selected => true,
                        :optional => true,
                        :selected_and_emptyable => true,
                        :top_level_commentable => false,
                        :suggestible => true,
                        :name => "Contacts",
                        :placeholder => "Who can help us ?",
                        :tooltip => "The people we need"
			
                      },
                      #{ :selected => false,
                        #:optional => true,
                        #:selected_and_emptyable => false,
                        #:top_level_commentable => true,
                        #:suggestible => false,
                        #:name => "Facilitation",
                        #:placeholder => " ",
                        #:tooltip => "Need a hand with this?"
                      #},
                      #{ :selected => false,
                        #:optional => true,
                        #:selected_and_emptyable => false,
                        #:top_level_commentable => false,
                        #:suggestible => false,
                        #:voteable => true,
                        #:name => "Voting",
                        #:placeholder => "yes/no survey",
                        #:tooltip => "Yes/No survey"
                      #} 
]
  end

  # @return [Object]
  def pitch_points_hash
    PitchPointsHelper.pitch_points_hash
  end

  def self.pitch_point_max_length
    201
  end

  def pitch_point_max_length
    PitchPointsHelper.pitch_point_max_length
  end

end
