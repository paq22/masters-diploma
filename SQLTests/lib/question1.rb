require './question1_text'

class Question1
  include Question1Text

  QUERRIES = {
    'SELECT' => [['DISTINCT', 'DISTINCT ON(field1)', ''],
                 ['*', 'field1, field2'],
                 ['FROM'], ['table1'], ['WHERE field1 > field2 AND field3 like \'\\%F\\%\'', ''],
                 ['GROUP BY field1, field2, field3',
                   'GROUP BY field1, field2 HAVING count(field3) > 0', ''],
                 ['ORDER BY field1 DESC, field2 ASC, field3 DESC', ''], ['LIMIT 33', '']],
    'UPDATE' => [['table1'],
                 ['SET field1 = 1, field2 = 2'],
                 ['WHERE field1 > field2 AND field3 like \'%F%\'', '']],
    'INSERT' => [['INTO'], ['table1'], ['(field1, field3, field2)', ''],
                 ['VALUES(1, 2, 3)', 'SELECT field1, field2, field3 FROM table2']],
    'DELETE' => [['FROM'], ['table1'], ['WHERE  field1 > field2 AND field3 like \'\\%F\\%\'', '']],
    'CREATE TABLE' => [['table1'],
       ['(field1 integer PRIMARY KEY, field2 integer, field3 integer)']],
    'CREATE VIEW' => [['view1'], ['AS'],
                 ['SELECT * FROM table1']],
    'CREATE FUNCTION' => [['func1'], ['()', '(integer, integer)'],
                 ['RETURNS integer'], ['LANGUAGE \'SQL\''], ['AS \'SELECT 1\'']],
    'CREATE AGGREGATE' => [['aggreg1'], ['('], ['BASETYPE = integer,'],
                           ['SFUNC = func1,'], ['STYPE = integer)']],
    'CREATE TRIGGER' => [['trig1'], ['BEFORE', 'AFTER'],
      ['INSERT', 'UPDATE', 'DELETE', 'INSERT OR UPDATE', 'INSERT OR DELETE',
       'UPDATE OR DELETE', 'INSERT OR UPDATE OR DELETE'],
      ['ON table1'], ['FOR EACH'], ['ROW', 'STATEMENT'],
      ['EXECUTE PROCEDURE func1']],
    'CREATE INDEX' => [['index1'], ['ON table1'],
      ['USING btree', '']],
    'CREATE SCHEMA' => [['schema1']],
    'CREATE USER' => [['user1'], ['WITH PASSWORD \'password1\' NOCREATEUSER NOCREATEDB', '']],
    'CREATE OR REPLACE FUNCTION' => [['func1'], ['()', '(integer, integer)'],
                 ['RETURNS integer'], ['LANGUAGE \'SQL\''], ['AS \'SELECT 1\'']],
    'DROP TABLE' => [['table1']],
    'DROP VIEW' => [['view1']],
    'DROP FUNCTION' => [['func1'], ['()', '(integer, integer)']],
    'DROP AGGREGATE' => [['aggreg1'], ['(integer)']],
    'DROP TRIGGER' => [['trig1'], ['ON table1']],
    'DROP INDEX' => [['index1']],
    'DROP SCHEMA' => [['schema1']],
    'DROP USER' => [['user1']]
#    'ALTER TABLE' => [['']],
#    'ALTER USER' => [['']],
#    'GRANT' => [['']],
#    'REVOKE' => [['']]
  }

  QUERRIES_SIZE = QUERRIES.keys.size

  def initialize(size = 1)
    @size = size
    @variants = []
  end

  def generate()
    num_of_good = 1 + rand(4)
    num_of_bad = 5 - num_of_good
    good_questions = []
    good_answers = []
    bad_questions = []
    bad_answers = []
    used = []

    for i in 0 ... num_of_good
      x = rand(QUERRIES_SIZE)
      x = rand(QUERRIES_SIZE) while used.include?(x)
      used << x
      good_questions << (quest = QUERRIES.keys[x])
      good_answers << QUERRIES[quest].map{ |a| a[rand(a.size)] }.join(' ')

    end

    i = 0
    for i in 0 ... num_of_bad
      x = rand(QUERRIES_SIZE)
      x = rand(QUERRIES_SIZE) while used.include?(x)
      used << x
      bad_questions << (quest = QUERRIES.keys[x])
      x, answer = '', ''
      while answer == ''
        used.pop if x != ''
        x = rand(QUERRIES_SIZE)
        x = rand(QUERRIES_SIZE) while used.include?(x)
        used << x
        answer = QUERRIES[quest].map do |a|
          if rand(2) == 1 and !a.include?('')
            ''
          else
            a[rand(a.size)]
          end
        end.join(' ').strip
      end
      bad_answers << answer
    end

    return check(good_questions, good_answers, bad_questions, bad_answers)
  end

  def check(gq, ga, bq, ba)
    regenerate = false
    gq.each do |q|
      res = QUERRIES[q]
      ans = res[0]
      for i in 1 ... res.size
        ans = ans.map{ |a| res[i].map{ |r| a + ' ' + r } }.flatten
      end
      if ((ans.inject(0){ |sum, i| sum + (ga.include?(i) ? 1 : 0) }) +
                (ans.inject(0){ |sum, i| sum + (ba.include?(i) ? 1 : 0) })) > 1
        regenerate = true
        break
      end
    end
    bq.each do |q|
      res = QUERRIES[q]
      ans = res[0]
      for i in 1 ... res.size
        ans = ans.map{ |a| res[i].map{ |r| a + ' ' + r } }.flatten
      end
      if ((ans.inject(0){ |sum, i| sum + (ga.include?(i) ? 1 : 0) }) +
                (ans.inject(0){ |sum, i| sum + (ba.include?(i) ? 1 : 0) })) > 1
        regenerate = true
        break
      end
    end

    if regenerate == true
      generate()
    else
      return [gq, ga, bq, ba]
    end
  end

  def generate_all
    @size.times do
      @variants << generate
    end
  end
end
