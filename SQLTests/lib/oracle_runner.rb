require 'oci8'

class ORACLERunner
    USER = 'C##PA'
    PASSWORD = 'PAPASSWORD'

    def initialize()
        @connection = OCI8.new(USER, PASSWORD);
    end

    def querry(sql)
        return @connection.exec(sql);
    end

    def connection()
        @connection
    end
    
end