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

require 'uri'

module HtmlHelpers
  module LinksHelper

    def link_to_repository(url)
      link_to label_with_icon(shorten_url(url), repository_icon(url), fixed: true), url, target: '_blank', title: url
    end


    def link_to_icon(icon_name, url, link_opts = {}, icon_opts = {})
      label     = link_opts.delete(:label) { nil }
      hide_icon = icon_opts.delete(:hide_icon) { false }

      link_to(url, link_opts) do
        if label && hide_icon
          label
        elsif label
          label_with_icon(label, icon_name, icon_opts)
        else
          icon(icon_name, { aligned: false }.merge(icon_opts))
        end
      end
    end


    def shorten_url(url)
      return '' if url.empty?
      uri = URI(url)
      case uri.host
        when 'github.com'
          uri.path[1..-1]
        else
          uri.path.split('/').last(2).join('/')
      end
    end


    def link_to_external(domain)
      link_to domain, "http://#{domain}", target: '_blank'
    end

  end
end
