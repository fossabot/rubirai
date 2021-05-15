# frozen_string_literal: true

module Rubirai
  class Bot
    # Get Mirai API plugin information
    def about
      v = call :get, '/about'
      v['data']
    end
  end
end
