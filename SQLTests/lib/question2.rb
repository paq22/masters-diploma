# Вопросы на построение запросов вида выберите кто подходит под ответ

require './question2_text'
require './oracle_runner'

class Question2
  include Question2Text

  COLUMNS = {'ID' => 'number(10)',
             'LASTNAME' => 'varchar2(1024 char)', 
             'FIRSTNAME' => 'varchar2(1024 char)', 
             'SECONDNAME' => 'varchar2(1024 char)',
             'AGE' => 'number(10)'}

  REAL_COLUMNS = {'ID' => 'number(10)',
             'LASTNAME' => 'varchar2(1024 char)',
             'FIRSTNAME' => 'varchar2(1024 char)',
             'SECONDNAME' => 'varchar2(1024 char)',
             'AGE' => 'number(10)',
             'OID' => 'number(10)'}

  VALUES = {'ID' => [1, 2, 3, 4, 5],
            'LASTNAME' => ['Owen', 'Nathaniel', 'Wyatt', 'Joshua', 'Daniel'],
            'FIRSTNAME' => ['Nathaniel', 'Sebastian', 'Gabriel', 'Sebastian', 'Matthew'],
            'SECONDNAME' => ['Sanchez', 'GNelson', 'Bennett', 'Bailey', 'Foster'],
            'AGE' => [30, 40, 30, 60, 30],
            'OID' => [1, 2, 3, 4, 5]}

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
                      [' like \'', 1, '\'']]

  HAVING = [' > 0', ' > 1', ' < 1', ' < 100', ' > 100']

  ORDER_BY = ['', ' DESC', ' ASC']

  def initialize(size = 1)
    @size = size
    @variants = []
  end

  def prepare()
    @runner = ORACLERunner.new()
    sql = "CREATE TABLE PEOPLE(\n" +
      REAL_COLUMNS.map{ |k, v| "#{k} #{v}" }.join(",\n") + ')'
    @runner.querry(sql)
    VALUES.values[0].each_index do |i|
      sql = 'INSERT INTO PEOPLE VALUES('
      args = []
      VALUES.values.each do |arr|
        args << arr[i]
      end
      sql += args.inspect.sub("[", "").sub("]","").gsub("\"", "\'") + ")";
      @runner.querry(sql);
    end
  end

  def finish()
    @runner = ORACLERunner.new()
    @runner.querry(%{begin execute immediate 'drop table PEOPLE'; exception when others then null; end;})
  end

  def generate()
    sql, result, fields = nil, nil, []
    stop = true
    while stop
      begin
        sql, fields = generate_select()
        p sql
        stop = false
        result = @runner.select(sql)
        p result
        # stop = false if result.size > 0 and
        #   result.first.to_a.join('').strip != ''
      rescue
      end
    end
    data = result.first.to_a
    goods = [sql]
    bads = []
    for i in 1 .. 4
      stop = true
      new_sql, result = nil, nil
      while stop
        begin
          new_sql, fields = generate_select(fields)
          result = @runner.select(new_sql)
          stop = false if result.size > 0 and new_sql != sql and 
            result.first.to_a.join('').strip != ''
        rescue
        end
      end
      if result.first.to_a == data
        goods << new_sql
      else
        bads << new_sql
      end
    end
    return data, goods, bads
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
    result = 'SELECT * from ('
    result += 'SELECT '
    fields_string, fields, grouped_fields = list_fields(is_group_by, fields)
    result += get_distinct(fields) if is_distinct
    result += fields_string
    result += "\'" if is_distinct
    result += ' FROM people '
    result += 'WHERE ' + get_where(fields) if is_where
    result += get_group_by(grouped_fields, is_having, fields) if is_group_by
    result += get_order_by(is_order_by, fields, is_group_by)
    result += ') WHERE rownum <= 1;'
    return result, fields
  end

  def list_fields(is_group_by, fields = [])
    num = 1 + rand(5)
    fields = COLUMNS.keys.shuffle[0...num] if fields.size == 0
    grouped_fields = []
    string = fields.map do |f|
      result = f
      x = rand(2)
      is_func = (x == 1)
      funcs = FUNCTIONS[COLUMNS[f]]
      if is_func and funcs.keys.size > 0
        func = funcs.keys[rand(funcs.keys.size)]
        result = "#{func}(#{result}" + (2..funcs[func]).to_a.map do |i|
          ", #{rand((i - 1) * 5) + 1}"
        end.join('') + ')'
      end
      x = rand(2)
      is_aggregate = (x == 1)
      if is_group_by and is_aggregate
        funcs = AGGREGATES[COLUMNS[f]]
        func = funcs[rand(funcs.size)]
        result = "#{func[0]}#{result}#{func[1]}"
      elsif is_group_by
        grouped_fields << f
      end
      result
    end.join(', ')
    return string, fields, grouped_fields
  end

  def get_distinct(fields)
    x = rand(2)
    is_on = false
    if is_on
      return 'DISTINCT ON(' +
        fields.shuffle[0..(1 + rand(fields.size - 1))].join(', ') + ') '
    else
      return 'DISTINCT \''
    end
  end

  def get_where(fields)
    ufs = fields.shuffle[0..rand(fields.size)]
    jop = (rand(2) == 1 ? ' OR ' : ' AND ')
    ufs.map do |f|
      op = WHERE[rand(WHERE.size)]
      if COLUMNS[f] == 'text'
        "'#{f}'" + op[0] +
          VALUES[f][0...op[1]].map{ |i| "'" + i + "'" }.join(', ') +
          op[2..-1].join('')
      else
        "'#{f}'" + op[0] +
          VALUES[f][0...op[1]].join(', ') +
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
    funcs = AGGREGATES[COLUMNS[f]]
    func = funcs[rand(funcs.size)]
    "HAVING #{func[0]}#{f}#{func[1]}" + HAVING.shuffle.first + ' '
  end

  def get_order_by(is_order_by, fields, is_group_by)
    return 'ORDER BY \'oid\' ' unless is_order_by
    num = 1 + rand(fields.size)
    fields = fields.shuffle[0...num]
    string = fields.map do |f|
      result = "'#{f}'"
      x = rand(2)
      is_func = (x == 1)
      funcs = FUNCTIONS[COLUMNS[f]]
      if is_func and funcs.keys.size > 0
        func = funcs.keys[rand(funcs.keys.size)]
        result = "#{func}(#{result}" + (2..funcs[func]).to_a.map do |i|
          ", #{rand((i - 1) * 5) + 1}"
        end.join('') + ')'
      end
      x = rand(2)
      is_aggregate = (x == 1)
      if is_group_by and is_aggregate
        funcs = AGGREGATES[COLUMNS[f]]
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
end
