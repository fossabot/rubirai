# frozen_string_literal: true

require 'rubirai/errors'
require 'rubirai/plugin_info'
require 'rubirai/auth'
require 'rubirai/message'

# Rubirai is a library for connecting Mirai http api.
module Rubirai
  require 'http'

  # The class for rubirai bot.
  class Bot
    attr_reader :base_uri, :session, :qq

    def initialize(host, port = nil)
      @base_uri = "http://#{host}#{":#{port}" if port}"
    end

    def gen_uri(path)
      URI.join(base_uri, path)
    end

    private

    def call(method, path, **kwargs)
      return unless %i[get post].include?(method) && HTTP.respond_to?(method)

      resp = HTTP.send method, gen_uri(path), kwargs
      raise(HttpResponseError, resp.code) unless resp.status.success?

      body = JSON.parse(resp.body)
      raise(MiraiError, body['code']) if (body.include? 'code') && (body['code'] != 0)

      body
    end
  end
end
