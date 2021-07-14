class PersonaRole < ApplicationRecord
  belongs_to :role
  belongs_to :persona
end
