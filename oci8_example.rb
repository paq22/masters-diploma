# библиотека для подключения к Oracle 123
require 'oci8'

# подключение к БД
connection = OCI8.new('C##PA', 'PAPASSWORD')

# пример запроса к БД, который выполняется через Oracle, но не выполняется через Ruby
connection.exec("SELECT * from (SELECT lastname FROM people ORDER BY lastname ASC ) WHERE rownum <= 1") do |responce|
    p responce
end

