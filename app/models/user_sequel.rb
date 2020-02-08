# frozen_string_literal: true

class UserSequel < Sequel::Model(:users)
  one_to_many :somethings, class: SomethingSequel, key: :user_id
end
