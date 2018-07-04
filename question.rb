require_relative 'references.rb'

class Question
  
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end
  
  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT 
      * 
      FROM 
        questions
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0 
    
    Question.new(data.first)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end    
  
  def self.find_by_author_id(user_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT 
      * 
      FROM 
        questions
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0 
    
    data.map {|q| Question.new(q)}
    # Question.new(data)   
  end
  
  def initialize(options)
    @user_id= options['user_id']
    @id = options['id']
    @title = options['title']
    @body = options['body']
  end
  
  def create
    raise "#{self} already in database" if @id
    QuestionDBConnection.instance.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO
        questions (title, body, user_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionDBConnection.instance.last_insert_row_id
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
  
end