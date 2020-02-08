# frozen_string_literal: true

class SomethingSequel < Sequel::Model(:somethings)
  many_to_one :user, class: UserSequel
end
