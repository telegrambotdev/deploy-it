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

class AdminNavigation < BaseNavigation

  def nav_menu
    sidebar_menu do |menu|
      menu.item with_prefix(:users),             label_with_icon(get_model_name_for('User'), 'fa-user'), admin_users_path
      menu.item with_prefix(:groups),            label_with_icon(get_model_name_for('Group'), 'fa-users'), admin_groups_path
      menu.item with_prefix(:roles),             label_with_icon(get_model_name_for('Role'), 'fa-database'), admin_roles_path
      menu.item with_prefix(:application_types), label_with_icon(get_model_name_for('ApplicationType'), 'fa-desktop'), admin_application_types_path
      menu.item with_prefix(:platforms),         label_with_icon(get_model_name_for('Platform'), 'fa-sitemap'), admin_platforms_path
      menu.item with_prefix(:docker_images),     label_with_icon(get_model_name_for('DockerImage'), 'fa-cubes'), admin_docker_images_path
      menu.item with_prefix(:buildpacks),        label_with_icon(get_model_name_for('Buildpack'), 'fa-rocket'), admin_buildpacks_path
      menu.item with_prefix(:addons),            label_with_icon(get_model_name_for('Addon'), 'fa-cube'), admin_addons_path
      menu.item with_prefix(:reserved_names),    label_with_icon(get_model_name_for('ReservedName'), 'fa-shield'), admin_reserved_names_path
      menu.item with_prefix(:applications),      label_with_icon(get_model_name_for('Application'), 'fa-desktop'), admin_applications_path
      menu.item with_prefix(:locks),             label_with_icon(get_model_name_for('Lock'), 'fa-lock'), admin_locks_path
      menu.item with_prefix(:settings),          label_with_icon(t('layouts.sidebar.settings'), 'fa-info-circle'), admin_settings_path
      menu.item with_prefix(:sidekiq),           label_with_icon(t('layouts.sidebar.sidekiq'), 'fa-gears'), sidekiq_web_path
      menu.item with_prefix(:logster),           label_with_icon(t('layouts.sidebar.logster'), 'fa-book'), logster_web_path
    end
  end


  def renderable?
    User.current.admin? && admin_section?
  end

end