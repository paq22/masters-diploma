# Преобразование вопроса в форму, понятную builder-у

module Question3Text
  def text()
    "В БД существует отношение people:\\\\
\\begin{tabular}{|#{Question3::REAL_COLUMNS.map{ |k, v| 'c|' }.join}}\n\\hline\n" +
Question3::REAL_COLUMNS.map{ |k, v| "#{k}:#{v}" }.join(' & ') + "\\\\\n\\hline\n" +
(0...Question3::VALUES.values[0].size).to_a.map do |i|
  Question3::VALUES.values.map{ |e| e[i] }.join(' & ')
end.join("\\\\\n\\hline\n") +
"\\\\\n\\hline\n\\end{tabular}
Для текстовых данных используется кодировка UTF-8. Какими будут первые 
5 символов из результатов выполнения запроса, если рассматривать
значения всех возвращаемых им полей как куски текста,
склеенные в единую строку."
  end

  def single_test_question(data, sql)
    "Q
#{text()}
Запрос:\\\\ {\\tiny #{sql}}

A
#{data}"
  end

  def all_test_question()
    @variants.map{ |r| single_test_question(*r) }
  end

end
