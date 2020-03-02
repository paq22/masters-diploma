# Преобразование вопроса в форму, понятную builder-у

module Question2Text
  def text()
    "В БД существует отношение people:\\\\
\\begin{tabular}{|#{Question2::REAL_COLUMNS.map{ |k, v| 'c|' }.join}}\n\\hline\n" +
Question2::REAL_COLUMNS.map{ |k, v| "#{k}:#{v}" }.join(' & ') + "\\\\\n\\hline\n" +
(0...Question2::VALUES.values[0].size).to_a.map do |i|
  Question2::VALUES.values.map{ |e| e[i] }.join(' & ')
end.join("\\\\\n\\hline\n") +
"\\\\\n\\hline\n\\end{tabular}
Для текстовых данных используется кодировка UTF-8. Какие
из предложенных ниже SQL запросов к таблице people вернут в результате
следующие данные:"
  end

  def single_test_question(result, goods, bads)
    "Q
#{text()}
\\begin{tabular}{|#{(0...(result.size)).to_a.map{ |i| 'c|' }.join}}
\\hline
#{result.join(' & ')}\\\\
\\hline
\\end{tabular}

T
" + goods.join("\n\nT\n") + (bads.size > 0 ? "

F
" + bads.join("\n\nF\n") : "")
  end

  def all_test_question()
    @variants.map{ |r| single_test_question(*r) }
  end

end
