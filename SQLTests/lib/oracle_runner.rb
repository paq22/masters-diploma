require 'oci8'

class ORACLERunner
    USER = 'C##PA'
    PASSWORD = 'PAPASSWORD'

    def initialize()
        @connection = OCI8.new(USER, PASSWORD);
    end

    def querry(sql, params = "")
        # p sql;
        @connection.exec(sql)
        @connection.exec("COMMIT") if params.include? 'commit'
    end

    def select(sql)
        # p sql;
        res = []
        @connection.exec(sql) do |r| res << r; end
        # p res
        return res
    end

    def connection()
        @connection
    end
    
end