# Преобразование вопроса в форму, понятную builder-у

module Question4Text
  def text()
    "В БД существует отношение people:\\\\
\\begin{tabular}{|#{Question4::REAL_COLUMNS.map{ |k, v| 'c|' }.join}}\n\\hline\n" +
Question4::REAL_COLUMNS.map{ |k, v| "#{k}:#{v}" }.join(' & ') + "\\\\\n\\hline\n" +
(0...Question4::VALUES.values[0].size).to_a.map do |i|
  Question4::VALUES.values.map{ |e| e[i] }.join(' & ')
end.join("\\\\\n\\hline\n") +
"\\\\\n\\hline\n\\end{tabular}
Для текстовых данных используется кодировка UTF-8. Укажите найденное в 
результате выполнения запроса количество записей и через знак двоеточия 
какими будут последние
3 символова из последней записи результатов выполнения запроса, если
рассматривать значения всех возвращаемых им полей как куски текста, склеенные
в единую строку.\\\\
Пример: 5:rov.\\\\"
  end

  def single_test_question(data_size, data, sql)
    "Q
#{text()}
Запрос:\\\\ {\\tiny #{sql}}

A
#{data_size}:#{data}"
  end

  def all_test_question()
    @variants.map{ |r| single_test_question(*r) }
  end

end
