require 'sqlite3'
require 'singleton'
require_relative 'references.rb'

class QuestionDBConnection < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

if $PROGRAM_NAME == __FILE__
  # p QuestionFollow.followers_for_question_id(1)
  # p QuestionFollow.followed_questions_for_user_id(1)
  # user1 = User.all.first
  # p user1.followed_questions
  # q1 = Question.all.first
  # p q1.followers
  # p Question.most_followed(1)
  p QuestionLikes.num_likes_for_question_id(2)
end







