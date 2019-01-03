class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails 5.x"
    session[:curso] = "Curso de Ruby on Rails 5.x [SESSION]"
    @meu_nome = params[:nome]
    @curso = params[:curso]
  end
end
