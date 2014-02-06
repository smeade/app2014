class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_timeline_entry

  def set_timeline_entry
  	@entry = Entry.running.first || Entry.new
  end
end
