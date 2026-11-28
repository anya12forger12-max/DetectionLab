# DetectionLab

A ready-made Windows lab for detection engineering: a domain with security tooling and logging already configured.

> **Upstream / attribution:** This repository is a copy of [clong/DetectionLab](https://github.com/clong/DetectionLab) by Chris Long. The upstream project announced that it is **no longer actively maintained as of 2023-01-01**. MIT License © 2017 Chris Long — see [LICENSE](LICENSE). Please direct issues and feature work upstream.

![DetectionLab](./img/DetectionLab.png)

## What it is

DetectionLab builds a small Windows environment for defenders: a domain controller, a Windows Event Forwarding collector, and a logging box. Its purpose is visibility and introspection — a place to see what common activity looks like in Windows logs and security tooling. The lab can be modified or expanded, but it is intentionally not hardened.

### Included tooling

- Microsoft Advanced Threat Analytics on the WEF machine, with the lightweight gateway on the DC
- A Splunk forwarder with pre-created indexes and configured technology add-ons
- A custom auditing GPO adding command-line process auditing and extra OS-level logging
- [Palantir Windows Event Forwarding](https://github.com/palantir/windows-event-forwarding) subscriptions and custom channels
- PowerShell transcript logging to `\\wef\pslogs`
- osquery on each host, pointed at a Fleet server, using [Palantir's osquery configuration](https://github.com/palantir/osquery-configuration)
- Sysmon configured with [Olaf Hartong's `sysmon-modular` configuration](https://github.com/olafhartong/sysmon-modular)
- AutorunsToWinEventLog for autostart items
- Zeek and Suricata for network monitoring
- Apache Guacamole for browser-based access to the hosts

## Safety warning

This lab is deliberately insecure and uses default Vagrant credentials. **Do not bridge or connect it to any network you care about.** Keep it isolated from production and sensitive networks, and never reuse lab credentials elsewhere.

## Getting started

1. Read the upstream [prerequisites](https://www.detectionlab.network/introduction/prerequisites/) and the platform guide for your host: [macOS](https://www.detectionlab.network/deployment/macosvm/), [Windows](https://www.detectionlab.network/deployment/windowsvm/), or [Linux](https://www.detectionlab.network/deployment/linuxvm/).
2. Run `Vagrant/prepare.sh` (or `Vagrant/prepare.ps1` on Windows) to check host prerequisites.
3. Bring up the lab from the `Vagrant/` directory using the included `Vagrantfile` — for example, `cd Vagrant && vagrant up`. Cloud and hypervisor paths are documented for [AWS](https://www.detectionlab.network/deployment/aws/), [Azure](https://www.detectionlab.network/deployment/azure/), [ESXi](https://www.detectionlab.network/deployment/esxi/), [Hyper-V](https://www.detectionlab.network/deployment/hyperv/), and [Proxmox](https://www.detectionlab.network/deployment/proxmox/).
4. Consult the upstream [lab information and credentials](https://www.detectionlab.network/introduction/infoandcreds/) and [troubleshooting guide](https://www.detectionlab.network/deployment/troubleshooting/) if a build fails.

## Repository layout

| Path | Purpose |
| :--- | :--- |
| `Vagrant/` | Local builds: `Vagrantfile`, provisioning scripts, and prepare checks |
| `Packer/` | Image-building definitions |
| `AWS/`, `Azure/`, `ESXi/`, `HyperV/`, `Proxmox/` | Platform-specific deployment material |
| `ci/` | Build/bootstrap and artifact helpers; the active workflow is in `.github/workflows/` |
| `img/` | Documentation screenshots |

## Contributing

Upstream contributions are made on a feature branch of a personal fork against the `master` branch; see [CONTRIBUTING.md](CONTRIBUTING.md). Because this repository is a copy, please direct feature work and bug reports to the upstream project.

## Responsible use

Use an isolated network, authorize any testing you launch from the lab, and never place real credentials or sensitive data in the VMs. The lab ships with known weaknesses on purpose — treat everything inside it as compromised.

## Credits and license

Created by Chris Long. A substantial portion of the code was adapted from Stefan Scherer's [packer-windows](https://github.com/StefanScherer/packer-windows) and [adfs2](https://github.com/StefanScherer/adfs2) projects. The lab also builds on work from Palantir, Olaf Hartong, Microsoft, Splunk, osquery/Fleet, Velociraptor, Red Canary, and many other open-source projects; the upstream README lists the full acknowledgements.

MIT License — Copyright (c) 2017 Chris Long. See [LICENSE](LICENSE).
