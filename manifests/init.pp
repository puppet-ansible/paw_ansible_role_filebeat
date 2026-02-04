# paw_ansible_role_filebeat
# @summary Manage paw_ansible_role_filebeat configuration
#
# @param filebeat_version
# @param filebeat_name
# @param filebeat_ssl_certs_dir
# @param filebeat_ssl_private_dir
# @param filebeat_ssl_insecure
# @param filebeat_log_level
# @param filebeat_log_dir
# @param filebeat_log_filename
# @param filebeat_elastic_cloud_id
# @param filebeat_elastic_cloud_username
# @param filebeat_elastic_cloud_password
# @param filebeat_package
# @param filebeat_package_state
# @param filebeat_create_config
# @param filebeat_template
# @param filebeat_inputs
# @param filebeat_output_elasticsearch_enabled
# @param filebeat_output_elasticsearch_hosts
# @param filebeat_output_elasticsearch_auth
# @param filebeat_output_logstash_enabled
# @param filebeat_output_logstash_hosts
# @param filebeat_enable_logging
# @param filebeat_ssl_ca_file
# @param filebeat_ssl_certificate_file
# @param filebeat_ssl_key_file
# @param filebeat_ssl_copy_files
# @param filebeat_elastic_cloud_enabled
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_filebeat (
  String $filebeat_version = '7.x',
  Optional[String] $filebeat_name = undef,
  String $filebeat_ssl_certs_dir = '/etc/pki/logstash',
  String $filebeat_ssl_private_dir = '{{ filebeat_ssl_certs_dir }}',
  String $filebeat_ssl_insecure = 'false',
  String $filebeat_log_level = 'warning',
  String $filebeat_log_dir = '/var/log/mybeat',
  String $filebeat_log_filename = 'mybeat.log',
  Optional[String] $filebeat_elastic_cloud_id = undef,
  Optional[String] $filebeat_elastic_cloud_username = undef,
  Optional[String] $filebeat_elastic_cloud_password = undef,
  String $filebeat_package = 'filebeat',
  String $filebeat_package_state = 'present',
  Boolean $filebeat_create_config = true,
  String $filebeat_template = 'filebeat.yml.j2',
  Array $filebeat_inputs = [{'type' => 'log', 'paths' => ['/var/log/*.log']}],
  Boolean $filebeat_output_elasticsearch_enabled = false,
  Array $filebeat_output_elasticsearch_hosts = ['localhost:9200'],
  Hash $filebeat_output_elasticsearch_auth = {},
  Boolean $filebeat_output_logstash_enabled = true,
  Array $filebeat_output_logstash_hosts = ['localhost:5044'],
  Boolean $filebeat_enable_logging = false,
  Optional[String] $filebeat_ssl_ca_file = undef,
  Optional[String] $filebeat_ssl_certificate_file = undef,
  Optional[String] $filebeat_ssl_key_file = undef,
  Boolean $filebeat_ssl_copy_files = true,
  Boolean $filebeat_elastic_cloud_enabled = false,
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
$_par_vardir = $par_vardir ? {
  undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
  default => $par_vardir,
}
$playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_filebeat/playbook.yml"

par { 'paw_ansible_role_filebeat-main':
  ensure        => present,
  playbook      => $playbook_path,
  playbook_vars => {
        'filebeat_version' => $filebeat_version,
        'filebeat_name' => $filebeat_name,
        'filebeat_ssl_certs_dir' => $filebeat_ssl_certs_dir,
        'filebeat_ssl_private_dir' => $filebeat_ssl_private_dir,
        'filebeat_ssl_insecure' => $filebeat_ssl_insecure,
        'filebeat_log_level' => $filebeat_log_level,
        'filebeat_log_dir' => $filebeat_log_dir,
        'filebeat_log_filename' => $filebeat_log_filename,
        'filebeat_elastic_cloud_id' => $filebeat_elastic_cloud_id,
        'filebeat_elastic_cloud_username' => $filebeat_elastic_cloud_username,
        'filebeat_elastic_cloud_password' => $filebeat_elastic_cloud_password,
        'filebeat_package' => $filebeat_package,
        'filebeat_package_state' => $filebeat_package_state,
        'filebeat_create_config' => $filebeat_create_config,
        'filebeat_template' => $filebeat_template,
        'filebeat_inputs' => $filebeat_inputs,
        'filebeat_output_elasticsearch_enabled' => $filebeat_output_elasticsearch_enabled,
        'filebeat_output_elasticsearch_hosts' => $filebeat_output_elasticsearch_hosts,
        'filebeat_output_elasticsearch_auth' => $filebeat_output_elasticsearch_auth,
        'filebeat_output_logstash_enabled' => $filebeat_output_logstash_enabled,
        'filebeat_output_logstash_hosts' => $filebeat_output_logstash_hosts,
        'filebeat_enable_logging' => $filebeat_enable_logging,
        'filebeat_ssl_ca_file' => $filebeat_ssl_ca_file,
        'filebeat_ssl_certificate_file' => $filebeat_ssl_certificate_file,
        'filebeat_ssl_key_file' => $filebeat_ssl_key_file,
        'filebeat_ssl_copy_files' => $filebeat_ssl_copy_files,
        'filebeat_elastic_cloud_enabled' => $filebeat_elastic_cloud_enabled
              },
  tags          => $par_tags,
  skip_tags     => $par_skip_tags,
  start_at_task => $par_start_at_task,
  limit         => $par_limit,
  verbose       => $par_verbose,
  check_mode    => $par_check_mode,
  timeout       => $par_timeout,
  user          => $par_user,
  env_vars      => $par_env_vars,
  logoutput     => $par_logoutput,
  exclusive     => $par_exclusive,
}
}
