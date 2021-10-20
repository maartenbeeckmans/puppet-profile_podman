# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile_podman
class profile_podman (
  Boolean $enable_api_socket,
  Hash    $containers,
  Hash    $images,
  Hash    $pods,
  Hash    $subid,
  Hash    $volumes,
  Array   $rootless_users,
  Boolean $remove_stopped_containers,
) {
  class {'podman':
    podman_docker_pkg        => undef,
    podman_docker_pkg_ensure => 'absent',
    nodocker                 => 'file',
    enable_api_socket        => $enable_api_socket,
    containers               => $containers,
    images                   => $images,
    pods                     => $pods,
    subid                    => $subid,
    volumes                  => $volumes,
    rootless_users           => $rootless_users,
  }

  if $remove_stopped_containers {
    profile_base::systemd_timer { 'remove_stopped_containers':
      on_calendar => 'daily',
      command     => 'podman system prune -f',
    }
  }
}
