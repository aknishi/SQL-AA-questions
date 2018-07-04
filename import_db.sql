PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  subjectq_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (subjectq_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id) 
);


CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id), 
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname,lname)
VALUES
  ('Rachel','Miller'),
  ('Nicolas','Sparks'),
  ('Tim','Ferris'),
  ('Bill','Hader');
  
INSERT INTO
  questions(title,body,user_id)
VALUES
  ('Why do I smell?','I always smell and never shower.',(SELECT id FROM users WHERE fname = 'Rachel')),
  ('How to get stronger?','I keep going to the gym and cant get bigger.',(SELECT id FROM users WHERE fname = 'Tim'));

INSERT INTO
  question_follows(user_id, question_id)

VALUES  
  ((SELECT id FROM users WHERE fname = 'Rachel'),(SELECT id FROM questions WHERE title = 'Why do I smell?')),
  ((SELECT id FROM users WHERE fname = 'Bill'),(SELECT id FROM questions WHERE title = 'How to get stronger?')),
  ((SELECT id FROM users WHERE fname = 'Tim'),(SELECT id FROM questions WHERE title = 'How to get stronger?')),
  ((SELECT id FROM users WHERE fname = 'Nicolas'),(SELECT id FROM questions WHERE title = 'How to get stronger?'));

INSERT INTO
  replies(body,subjectq_id,parent_id,user_id)
VALUES  
  ('Use deodorant Rachel!!!',(SELECT id FROM questions WHERE title = 'Why do I smell?'),NULL,(SELECT id FROM users WHERE fname = 'Bill'));

INSERT INTO
  question_likes(user_id, question_id)

VALUES  
  ((SELECT id FROM users WHERE fname = 'Nicolas'),(SELECT id FROM questions WHERE title = 'Why do I smell?')),
  ((SELECT id FROM users WHERE fname = 'Nicolas'),(SELECT id FROM questions WHERE title = 'How to get stronger?')),
  ((SELECT id FROM users WHERE fname = 'Bill'),(SELECT id FROM questions WHERE title = 'How to get stronger?'));
