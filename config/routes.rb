# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'csv#index'
  get :rust, to: 'csv#rust'
  get :ruby, to: 'csv#ruby'
end
