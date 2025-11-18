# Puppet task for executing Ansible role: ansible_role_filebeat
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_filebeat"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_filebeat"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_filebeat\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_filebeat"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_filebeat"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_filebeat_version) {
  $ExtraVars['filebeat_version'] = $env:PT_filebeat_version
}
if ($env:PT_filebeat_name) {
  $ExtraVars['filebeat_name'] = $env:PT_filebeat_name
}
if ($env:PT_filebeat_ssl_certs_dir) {
  $ExtraVars['filebeat_ssl_certs_dir'] = $env:PT_filebeat_ssl_certs_dir
}
if ($env:PT_filebeat_ssl_private_dir) {
  $ExtraVars['filebeat_ssl_private_dir'] = $env:PT_filebeat_ssl_private_dir
}
if ($env:PT_filebeat_ssl_insecure) {
  $ExtraVars['filebeat_ssl_insecure'] = $env:PT_filebeat_ssl_insecure
}
if ($env:PT_filebeat_log_level) {
  $ExtraVars['filebeat_log_level'] = $env:PT_filebeat_log_level
}
if ($env:PT_filebeat_log_dir) {
  $ExtraVars['filebeat_log_dir'] = $env:PT_filebeat_log_dir
}
if ($env:PT_filebeat_log_filename) {
  $ExtraVars['filebeat_log_filename'] = $env:PT_filebeat_log_filename
}
if ($env:PT_filebeat_elastic_cloud_id) {
  $ExtraVars['filebeat_elastic_cloud_id'] = $env:PT_filebeat_elastic_cloud_id
}
if ($env:PT_filebeat_elastic_cloud_username) {
  $ExtraVars['filebeat_elastic_cloud_username'] = $env:PT_filebeat_elastic_cloud_username
}
if ($env:PT_filebeat_elastic_cloud_password) {
  $ExtraVars['filebeat_elastic_cloud_password'] = $env:PT_filebeat_elastic_cloud_password
}
if ($env:PT_filebeat_package) {
  $ExtraVars['filebeat_package'] = $env:PT_filebeat_package
}
if ($env:PT_filebeat_package_state) {
  $ExtraVars['filebeat_package_state'] = $env:PT_filebeat_package_state
}
if ($env:PT_filebeat_create_config) {
  $ExtraVars['filebeat_create_config'] = $env:PT_filebeat_create_config
}
if ($env:PT_filebeat_template) {
  $ExtraVars['filebeat_template'] = $env:PT_filebeat_template
}
if ($env:PT_filebeat_inputs) {
  $ExtraVars['filebeat_inputs'] = $env:PT_filebeat_inputs
}
if ($env:PT_filebeat_output_elasticsearch_enabled) {
  $ExtraVars['filebeat_output_elasticsearch_enabled'] = $env:PT_filebeat_output_elasticsearch_enabled
}
if ($env:PT_filebeat_output_elasticsearch_hosts) {
  $ExtraVars['filebeat_output_elasticsearch_hosts'] = $env:PT_filebeat_output_elasticsearch_hosts
}
if ($env:PT_filebeat_output_elasticsearch_auth) {
  $ExtraVars['filebeat_output_elasticsearch_auth'] = $env:PT_filebeat_output_elasticsearch_auth
}
if ($env:PT_filebeat_output_logstash_enabled) {
  $ExtraVars['filebeat_output_logstash_enabled'] = $env:PT_filebeat_output_logstash_enabled
}
if ($env:PT_filebeat_output_logstash_hosts) {
  $ExtraVars['filebeat_output_logstash_hosts'] = $env:PT_filebeat_output_logstash_hosts
}
if ($env:PT_filebeat_enable_logging) {
  $ExtraVars['filebeat_enable_logging'] = $env:PT_filebeat_enable_logging
}
if ($env:PT_filebeat_ssl_ca_file) {
  $ExtraVars['filebeat_ssl_ca_file'] = $env:PT_filebeat_ssl_ca_file
}
if ($env:PT_filebeat_ssl_certificate_file) {
  $ExtraVars['filebeat_ssl_certificate_file'] = $env:PT_filebeat_ssl_certificate_file
}
if ($env:PT_filebeat_ssl_key_file) {
  $ExtraVars['filebeat_ssl_key_file'] = $env:PT_filebeat_ssl_key_file
}
if ($env:PT_filebeat_ssl_copy_files) {
  $ExtraVars['filebeat_ssl_copy_files'] = $env:PT_filebeat_ssl_copy_files
}
if ($env:PT_filebeat_elastic_cloud_enabled) {
  $ExtraVars['filebeat_elastic_cloud_enabled'] = $env:PT_filebeat_elastic_cloud_enabled
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_filebeat"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_filebeat"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
