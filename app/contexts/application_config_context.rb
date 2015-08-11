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

class ApplicationConfigContext < SimpleDelegator

  include ApplicationCommon


  def initialize(context)
    super(context)
  end


  def update_settings(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
      application.update_lb_route! if application.domain_name_has_changed? || application.use_credentials_has_changed?
    end
  end


  def update_repository(application, params = {})
    repository = application.distant_repo
    if repository.update(params)
      # Destroy Application repository if url has changed.
      # It will be recloned by service object.
      repository.destroy_dir! if repository.url_has_changed? || repository.branch_has_changed?

      # Call service objects to perform other actions
      !repository.exists? ? repository.run_async!('clone!') : repository.run_async!('resync!')
      render_success(locals: { application: application })
    else
      render_failed(locals: { application: application })
    end
  end


  def update_domain_names(application, params = {})
    update_application(application, params) do |application|
      application.update_lb_route!
    end
  end


  def update_credentials(application, params = {})
    update_application(application, params) do |application|
      application.update_lb_route! if application.use_credentials?
    end
  end


  def update_env_vars(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def update_mount_points(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def ssl_certificate(application, params = {})
    return render_failed(locals: { application: application }, message: t('.already_exist')) unless application.ssl_certificate.nil?
    certificate = application.build_ssl_certificate(params)
    certificate.save ? render_success(locals: { application: application }) : render_failed(locals: { application: application })
  end


  def update_database(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('create_physical_database!')
    end
  end


  def synchronize_repository(application, params = {})
    repository = application.distant_repo
    # Call service objects to perform other actions
    event_options = RefreshViewEvent.create(app_id: application.id, triggers: [repositories_application_path(application)])
    repository.run_async!('resync!', event_options: event_options)
    render_success(locals: { application: application })
  end


  def restore_env_vars(application, params = {})
    execute_action(application, params) do |application|
      application.restore_env_vars!
    end
  end


  def restore_mount_points(application, params = {})
    execute_action(application, params) do |application|
      application.restore_mount_points!
    end
  end


  def reset_ssl_certificate(application, params = {})
    application.ssl_certificate = nil
    render_success(locals: { application: application })
  end

end
