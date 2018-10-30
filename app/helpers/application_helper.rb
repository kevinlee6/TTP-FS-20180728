module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def get_quote(ticker)
    begin
      IEX::Resources::Quote.get(ticker)
    rescue Exception => e
      puts e
      nil
    end
  end
end
