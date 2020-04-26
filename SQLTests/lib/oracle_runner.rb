require 'oci8'

class ORACLERunner
    USER = 'C##PA'
    PASSWORD = 'PAPASSWORD'

    def initialize()
        @connection = OCI8.new(USER, PASSWORD);
    end

    def querry(sql, params = "")
        p sql;
        res = []
        if params.include? 'selectResult'
            @connection.exec(sql) do |r| res << r; end
        else
            @connection.exec(sql)
        end
        @connection.exec("COMMIT") if params.include? 'commit'
        if params.include? 'selectResult'
            return res
        else
            return true
        end
    end

    def connection()
        @connection
    end
    
end