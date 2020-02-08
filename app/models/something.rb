# frozen_string_literal: true

class Something < ApplicationRecord
  extend Enumerize

  belongs_to :user

  enumerize :int, in: { zero: 0, first: 1, second: 2 }
end
