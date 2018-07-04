require_relative 'references.rb'

class QuestionFollow
  def self.followers_for_question_id(qid)
    followers = QuestionDBConnection.instance.execute(<<-SQL, qid)
      SELECT 
        *
      FROM 
        users AS u
      JOIN question_follows AS q
      ON (? = q.question_id) AND q.user_id = u.id

    SQL
    return nil unless followers.length > 0 
    
    followers.map { |elHash| User.new(elHash) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM 
        questions AS q1
      JOIN question_follows AS q2
      ON (? = q2.user_id) AND q1.id = q2.question_id

    SQL
    return nil unless questions.length > 0 
    
    
    questions.map { |el| Question.new(el) }
  end
  
  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
    q.*
    FROM
    questions as q
    JOIN
    question_follows as q2
      ON q.id = q2.question_id
      GROUP BY
      q.id
      ORDER BY
      COUNT(*) DESC
      LIMIT ?
    SQL
    
    return nil unless questions.length > 0 
    questions.map { |option| Question.new(option) }
  end
  
  def initialize (options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  
end
