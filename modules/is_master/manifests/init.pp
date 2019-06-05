#----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

class is_master inherits is_master::params {

  # Create distribution path
  file { [  "${products_dir}",
            "${products_dir}/${product}",
            "${distribution_path}"]:
    ensure => 'directory',
  }

  # Copy binary to distribution path
  file { "binary":
    path   => "${distribution_path}/${product_binary}",
    mode   => '0644',
    source => "puppet:///modules/common/${product_binary}",
  }

  # Install the "unzip" package
  package { 'unzip':
    ensure => installed,
  }

  # Unzip the binary and create setup
  exec { "unzip-binary":
    command     => "unzip ${product_binary}",
    path        => "/usr/bin/",
    cwd         => $distribution_path,
    onlyif      => "/usr/bin/test ! -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
    require     => Package['unzip'],
  }

  # Install the "zip" package
  package { 'zip':
    ensure => installed,
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure that file is available in modules -> is -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/is/some_file",
  # }
}
