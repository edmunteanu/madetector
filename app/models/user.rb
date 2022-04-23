# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable
end
