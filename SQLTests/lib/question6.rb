# Вопросы на построение запросов вида выберите кто подходит под ответ

require 'question6_text'
require 'psql_runner'

class Question6
  include Question6Text

  COLUMNS = {'id' => 'integer',
             'lastname' => 'text', 
             'firstname' => 'text', 
             'secondname' => 'text',
             'parentid' => 'integer',
             'childid' => 'integer'}

  REAL_COLUMNS = {'id' => 'integer',
             'lastname' => 'text',
             'firstname' => 'text',
             'secondname' => 'text',
             'parentid' => 'integer',
             'childid' => 'integer',
             'oid' => 'integer'}

  VALUES = {'id' => [1, 2, 3, 4, 5],
            'lastname' => ['Ivanov', 'Petrov', 'Sidorov',
                            'Vasilev', 'Mihailov'],
            'firstname' => ['Ivan', 'Petr', 'Sidor', 'Petr', 'Mihail'],
            'secondname' => ['Ivanovich', 'Petrovich', 'Sidorovich',
                              'Vasilevich', 'Ivanovich'],
            'parentid' => [nil, 1, 2, nil, 4],
            'childid' => [2, 3, nil, 5, nil],
            'oid' => [1, 2, 3, 4, 5]}

  FUNCTIONS = {'integer' => {},
               'text' => {'bit\\_length' => 1,
                          'char\\_length' => 1,
                          'lower' => 1,
                          'substring' => 3,
                          'trim' => 1,
                          'upper' => 1}}
  AGGREGATES = {'integer' => [['count(', ')'], ['cast(avg(', ') as integer)'],
                              ['max(', ')'], ['min(', ')'], ['sum(', ')']],
                'text' => [['count(', ')']]}

  WHERE = [[' = ', 1], [' in (', 2, ')'],
                      [' like ', 1, '']]

  HAVING = [' > 0', ' > 1', ' < 1', ' < 100', ' > 100']

  ORDER_BY = ['', ' DESC', ' ASC']

  JOINS = { 'LEFT OUTER JOIN' => true, 'RIGHT OUTER JOIN' => true,
    'FULL OUTER JOIN' => true, 'INNER JOIN' => true,
    'NATURAL JOIN' => false }

  def initialize(size = 1)
    @size = size
    @variants = []
  end

  def prepare()
    @runner = PSQLRunner.new()
    sql = "CREATE TABLE people(\n" +
      REAL_COLUMNS.map{ |k, v| "#{k} #{v}" }.join(",\n") + ')'
    @runner.querry(sql)
    VALUES.values[0].each_index do |i|
      sql = 'INSERT INTO people VALUES(' +
        ('?, ' * (REAL_COLUMNS.keys.size - 1)) + '?)'
      @runner.connection.do(sql, *(VALUES.values.map{ |e| e[i] }))
    end
  end

  def finish()
    sql = 'DROP TABLE people'
    @runner.querry(sql)
    @runner.destroy()
  end

  def generate()
    sql, result, fields = nil, nil, []
    stop = true
    while stop
      begin
        sql, fields = generate_select()
        result = @runner.select(sql)
        stop = false if result.size > 0 and result.first.to_a.join('').size > 4
      rescue
      end
    end
    data = result.first.to_a.join('')[0..4]
    return data, sql
  end

  def generate_select(fields = [])
    is_distinct = false
    is_group_by = false
    x = rand(3)
    is_distinct = (x == 1)
    is_group_by = (x == 2)
    x = rand(2)
    is_having = (is_group_by and x == 1)
    x = rand(2)
    is_order_by = ((x == 1) or is_group_by)
    x = rand(2)
    is_where = (x == 1)
    result = 'SELECT '
    fields_string, fields, grouped_fields = list_fields(is_group_by, fields)
    result += get_distinct(fields) if is_distinct
    result += fields_string
    result += get_joins([['parentid', 'id'], ['id', 'parentid'],
                         ['id', 'childid'], ['childid', 'id']])
    result += 'WHERE ' + get_where(fields) if is_where
    result += get_group_by(grouped_fields, is_having, fields) if is_group_by
    result += get_order_by(is_order_by, fields, is_group_by)
    result += 'LIMIT 1'
    return result, fields
  end

  def get_joins(join_fields)
    tables = {'people t1' => 't1', 'people t2' => 't2',
      'people t3' => 't3'}
    full_tables = tables.keys.shuffle
    result = 'FROM ' + full_tables[0]
    for i in 1..2
      op = JOINS.keys.shuffle.first
      fields_pair = join_fields.shuffle.first
      if JOINS[op]
        result += " #{op} #{full_tables[i]}
                    ON(#{tables[full_tables[i - 1]]}.#{fields_pair[0]} =
                       #{tables[full_tables[i]]}.#{fields_pair[1]}) "
      else
        result += " #{op} #{tables[i]}
                    USING(#{fields_pair[0]})"
      end
    end
    return result
  end

  def list_fields(is_group_by, fields = [])
    num = 1 + rand(5)
    if fields.size == 0
      fields = COLUMNS.keys.map do |k|
        ['t1.' + k, 't2.' + k, 't3.' + k] 
      end.flatten.shuffle[0...num]
    end
    grouped_fields = []
    string = fields.map do |f|
      rf = real_field(f)
      result = f
      x = rand(2)
      is_func = (x == 1)
      funcs = FUNCTIONS[COLUMNS[rf]]
      if is_func and funcs.keys.size > 0
        func = funcs.keys[rand(funcs.keys.size)]
        result = "#{func}(#{result}" + (2..funcs[func]).to_a.map do |i|
          ", #{rand((i - 1) * 5) + 1}"
        end.join('') + ')'
      end
      x = rand(2)
      is_aggregate = (x == 1)
      if is_group_by and is_aggregate
        funcs = AGGREGATES[COLUMNS[rf]]
        func = funcs[rand(funcs.size)]
        result = "#{func[0]}#{result}#{func[1]}"
      elsif is_group_by
        grouped_fields << f
      end
      result
    end.join(', ')
    return string + ' ', fields, grouped_fields
  end

  def get_distinct(fields)
    x = rand(2)
    is_on = (x == 1)
    if is_on
      return 'DISTINCT ON(' +
        fields.shuffle[0..(1 + rand(fields.size - 1))].join(', ') + ') '
    else
      return 'DISTINCT '
    end
  end

  def get_where(fields)
    ufs = fields.shuffle[0..rand(fields.size)]
    jop = (rand(2) == 1 ? ' OR ' : ' AND ')
    ufs.map do |f|
      rf = real_field(f)
      op = WHERE[rand(WHERE.size)]
      if COLUMNS[rf] == 'text'
        f + op[0] +
          VALUES[rf][0...op[1]].map{ |i| "'" + i + "'" }.join(', ') +
          op[2..-1].join('')
      else
        f + op[0] +
          VALUES[rf][0...op[1]].join(', ') +
          op[2..-1].join('')
      end
    end.join(jop) + ' '
  end

  def get_group_by(grouped_fields, is_having, fields)
    return '' if grouped_fields.size == 0
    result = 'GROUP BY ' + grouped_fields.join(', ') + ' '
    result += get_having(fields - grouped_fields) if is_having
    return result
  end

  def get_having(ungrouped_fields)
    return '' if ungrouped_fields.size == 0
    f = ungrouped_fields.shuffle.first
    rf = real_field(f)
    funcs = AGGREGATES[COLUMNS[rf]]
    func = funcs[rand(funcs.size)]
    "HAVING #{func[0]}#{f}#{func[1]}" + HAVING.shuffle.first + ' '
  end

  def get_order_by(is_order_by, fields, is_group_by)
    return 'ORDER BY oid ' unless is_order_by
    num = 1 + rand(fields.size)
    fields = fields.shuffle[0...num]
    string = fields.map do |f|
      rf = real_field(f)
      result = f
      x = rand(2)
      is_func = (x == 1)
      funcs = FUNCTIONS[COLUMNS[rf]]
      if is_func and funcs.keys.size > 0
        func = funcs.keys[rand(funcs.keys.size)]
        result = "#{func}(#{result}" + (2..funcs[func]).to_a.map do |i|
          ", #{rand((i - 1) * 5) + 1}"
        end.join('') + ')'
      end
      x = rand(2)
      is_aggregate = (x == 1)
      if is_group_by and is_aggregate
        funcs = AGGREGATES[COLUMNS[rf]]
        func = funcs[rand(funcs.size)]
        if func[0] != 'count('
          result = "#{func[0]}#{result}#{func[1]}"
        else
          result
        end
      end
      result
    end.map{ |i| i + ORDER_BY[rand(ORDER_BY.size)] }.join(', ')
    return 'ORDER BY ' + string + ' '
  end

  def generate_all
    prepare()
    @size.times do
      @variants << generate
    end
    finish()
  end

private

  def real_field(f)
    f.gsub(/^.*\./, '')
  end
end
