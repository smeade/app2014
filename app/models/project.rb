class Project < ActiveRecord::Base
  belongs_to :client

  # Public: sets client based on either a client_id or client name
  #
  # client_id_or_name - The String value of either an id or name of a Client
  # 
  # Examples
  #
  #   project.client_id_or_name=("New Client")
  #   project.client_id_or_name=("123")
  #
  # Returns the Client
  def client_id_or_name=(client_id_or_name)
    if client_id_or_name.to_i == 0
      self.client_id = Client.find_or_create_by(name: client_id_or_name).id
    else
      self.client_id = Client.find_or_create_by(client_id_or_name).id
    end
  end

  def client_id_or_name
    self.id
  end
end
