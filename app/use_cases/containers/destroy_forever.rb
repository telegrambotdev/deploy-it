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

module Containers
  class DestroyForever < ActiveUseCase::Base

    include Containers::Base


    def execute(opts = {})
      execute_if_exists(container.docker_id) do
        container_destroy(opts)
      end
    end


    def container_destroy(opts = {})
      self_destroy = opts.delete(:self_destroy){ true }
      begin
        # Stop it first
        container.docker_proxy.stop
      rescue => e
        log_exception(e)
        error_message(e.message)
      ensure
        begin
          # Remove from Docker
          container.docker_proxy.delete
        rescue => e
          log_exception(e)
          error_message("Erreurs lors de la suppression du contenaire '#{container.short_id}'")
        ensure
          # Remove from database
          container.destroy! if self_destroy
        end
      end
    end

  end
end
