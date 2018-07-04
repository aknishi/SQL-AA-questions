require_relative 'references.rb'

class QuestionLikes
  
  def self.likers_for_question_id(question_id)
    likers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    
    SELECT
      u.*
    FROM
      users AS u
    JOIN
      question_likes AS ql
      ON ql.user_id = u.id
      WHERE ql.question_id = ?
  SQL
  
  return nil unless likers.length > 0 
  
  likers.map { |liker| User.new(liker) }
  end
  
  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(*) as 'total_likes'
    FROM
      users AS u
    JOIN
      question_likes AS ql
      ON ql.user_id = u.id
      WHERE ql.question_id = ?
    SQL
    
    return nil unless num_likes.length > 0 
    
    num_likes.first["total_likes"]
    #User.new(num_likes.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id =options['question_id']
  end
  
end

  
  