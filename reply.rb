require_relative 'references.rb'

class Reply
  
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT 
      * 
      FROM 
        replies
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0 
    
    Question.new(data.first)
  end
  
  def self.find_by_parent_id(parent_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, parent_id)
      SELECT 
      * 
      FROM 
        replies
      WHERE
        parent_id = ?
    SQL
    return nil unless data.length > 0 
    
    Question.new(data.first)
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT 
      * 
      FROM 
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0 
    
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT 
      * 
      FROM 
        replies
      WHERE
        subjectq_id = ?
    SQL
    return nil unless data.length > 0 
    #might change due to children
    #Reply.new(data.first)  
    data.map { |datum| Reply.new(datum) }
 
  end
  
  def initialize(options)
    @id = options['id']
    @body = options['body']
    @subjectq_id = options['subjectq_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end
  
  def create
    raise "#{self} already in database" if @id
    QuestionDBConnection.instance.execute(<<-SQL, @body, @subjectq_id, @parent_id, @user_id)
      INSERT INTO
        replies (body, subjectq_id, parent_id, user_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionDBConnection.instance.last_insert_row_id
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def question
    Question.find_by_id(@subjectq_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    Reply.find_by_parent_id(@id)
  end
end