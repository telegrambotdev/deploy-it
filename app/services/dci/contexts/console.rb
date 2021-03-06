# frozen_string_literal: true
# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

module DCI
  module Contexts
    module Console
      extend self
      extend Base


      def render_message(message:, type:, locals: {}, errors: [])
        console_log message unless message.empty?
      end


      private


        def t(*args)
          I18n.t(*args)
        end


        def console_log(errors)
          logger.empty_line

          if errors.is_a?(Array)
            errors.each do |error|
              logger.error error
            end
          else
            logger.error errors
          end

          logger.empty_line
        end

    end
  end
end
