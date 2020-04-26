require 'oci8'

class ORACLERunner
    USER = 'C##PA'
    PASSWORD = 'PAPASSWORD'

    def initialize()
        @connection = OCI8.new(USER, PASSWORD);
    end

    def querry(sql)
        p sql;
        res = @connection.exec(sql);
        @connection.exec("COMMIT");
        return res
    end

    def connection()
        @connection
    end
    
end