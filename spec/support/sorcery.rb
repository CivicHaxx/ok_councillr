module Sorcery
  module TestHelpers
    module Rails
      module Integration
        def login_user_post(user, password)
          page.driver.post(user_sessions_url, { email: user, password: password}) 
        end
      end
    end
  end
end
