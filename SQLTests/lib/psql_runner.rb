require 'rubygems'
# require 'dbi'

class PSQLRunner
  PORT = 9999
  DBNAME = 'psql_tests'
  HOST = 'localhost'
  USER = 'test'
  PASSWORD = 'test'

  def initialize()
    # @connection = DBI.connect("dbi:Pg:dbname=#{DBNAME};host=#{HOST};port=#{PORT}",
      # USER, PASSWORD, 'AutoCommit' => true, 'pg_client_encoding' => 'UTF-8')
  end

  def select(sql)
    # @connection.select_all(sql)
  end

  def querry(sql)
    p sql
    # @connection.do(sql)
  end

  def connection()
    @connection
  end

  def destroy()
    @connection.disconnect()
  end
end
