class LoginController < ApplicationController
  def index
    # render input form
  end

  def handle_login
    puts "Handle login with #{params}!"
  end
end
