# Security Policy

MonitorPI is a **local kiosk** on a home LAN. It does not run a network server, handle authentication, or store secrets in the repository.

## Reporting

If you find a security issue that could affect others using this project (for example, unsafe defaults in the install docs or scripts), please report it via [GitHub Security Advisories](https://github.com/OWNER/MonitorPI/security/advisories) or open a private issue if advisories are not enabled.

## Local configuration

Do **not** commit:

- `config.env` (your dashboard URL and paths)
- MAC addresses, internal hostnames, or other infrastructure identifiers

Copy `config.example.env` to `config.env` on the Pi and keep it local.

## Supported versions

Security fixes apply to the latest release on the default branch. This is a small personal utility project with no formal LTS policy.
