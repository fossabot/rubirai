# frozen_string_literal: true

module Rubirai
  class RubiraiAPI
    # Start authentication. Will store the session.
    # @param auth_key [String] the auth key defined in config file
    # @return [String] an authentication key which is stored in RubiraiAPI
    def auth(auth_key)
      v = call :post, '/auth', json: { "authKey": auth_key }
      @session = v['session']
    end

    # Verify and start a session. Also bind the session to a bot with the qq id.
    def verify(qq, session = nil)
      check qq, session

      @session = session if session
      call :post, '/verify', json: { "sessionKey": @session, "qq": qq.to_i }
      nil
    end

    # Release a session.
    def release(qq, session = nil)
      check qq, session

      call :post, '/release', json: { "sessionKey": @session || session, "qq": qq.to_i }
      @session = nil
      nil
    end

    def login(qq, auth_key)
      auth auth_key
      verify qq
    end

    private

    def check(qq, session = nil)
      raise RubiraiError, 'Wrong format for qq' unless qq.to_i.to_s == to_s
      raise RubiraiError, 'No session provided' unless @session || session
    end
  end
end