module RCB
  def create_db_and_user(db, db_name, username, pw)
    db_info = nil
    case db
      when "mysql"
        mysql_info = get_settings_by_role("mysql-master", "mysql")
        connection_info = {:host => mysql_info["bind_address"], :username => "root", :password => mysql_info["server_root_password"]}    
        
        # create database
        mysql_database "create #{db_name} database" do
          connection connection_info
          database_name db_name
          action :create
        end
        
        # create user
        mysql_database_user username do
          connection connection_info
          password pw
          action :create
        end
        
        # grant privs to user
        mysql_database_user username do
          connection connection_info
          password pw
          database_name db_name
          host '%'
          privileges [:all]
          action :grant
        end
        db_info = mysql_info 
    end  
    db_info
  end
end
