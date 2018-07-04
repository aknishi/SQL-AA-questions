require_relative 'references.rb'

class User
  attr_accessor :fname, :lname
  
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT 
      * 
      FROM 
      users 
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0
    
    User.new(data.first)
  end
  
  def self.find_by_name(name)
    fname, lname = name.split
    
    person = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT 
      * 
      FROM 
      users 
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil unless person.length > 0
    User.new(person.first)
    
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def create
    raise "#{self} already in database" if @id
    QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname,lname)
      VALUES
        (?,?)
    SQL
    @id = QuestionDBConnection.instance.last_insert_row_id
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end
  
  def average_karma
    
  end
  
  
end


SELECT
AVR(*)
