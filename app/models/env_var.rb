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

class EnvVar < ActiveRecord::Base

  ENVVAR_STEPS = [
    ['receive', 'receive'],
    ['build',   'build'],
    ['deploy',  'deploy']
  ]

  ## Relations
  belongs_to :application

  ## Basic Validations
  validates :application_id, presence: true
  validates :key,            presence: true, uniqueness: { case_sensitive: false, scope: [ :application_id, :step ] }
  validates :value,          presence: true
  validates :step,           presence: true, inclusion: { in: ['receive', 'build', 'deploy'] }

  ## Callbacks
  before_validation { self.key = key.upcase if !key.nil? }

  ## Scopes
  scope :on_receive, -> { where(step: 'receive') }
  scope :on_build,   -> { where(step: 'build') }
  scope :on_deploy,  -> { where(step: 'deploy') }

end
