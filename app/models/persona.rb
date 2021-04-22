# frozen_string_literal: true

class Persona < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  # MAS COSAS AQUI DEBAJO
  
end
