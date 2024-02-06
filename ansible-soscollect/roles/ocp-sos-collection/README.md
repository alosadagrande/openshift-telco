Ansible Role: ocp-sos-collection
=========

This Ansible role is designed to perform the following tasks on a management machine:

- Display the distribution of the host OS.
- Ensure that the sos utility is installed on the server (applicable to RedHat and Fedora distributions).
- Create an SOS report on the management machine of all the OCP nodes parsed as `servers`.

Requirements
------------

This role has the following requirements:

- Ansible installed on the management machine.
- SSH access to the target server(s).
- Appropriate privileges to install packages (sudo or root access) for installing `sos`.

Role Variables
--------------

This role uses the following variables:

- `sosreport_args` (default: []): List of arguments to pass to the sos-collector command.
- `servers` : Comma-separated list of target OCP nodes for the SOS report.
- `sosreport_case` (default: None): Optional case ID to associate with the SOS report.

Dependencies
------------

This role does not have any external dependencies.

Example Playbook
----------------

Here's an example playbook that uses this role:

    ---
    - name: SOS log collection of OpenShift Cluster Nodes Playbook
      hosts: localhost
      gather_facts: true
      become: yes # To perform package installation
      roles:
        - role: ocp-sos-collection

The command to run the playbook against 'my_servers' and related to a case '01234567' would be:
      
```bash
$ ansible-playbook playbook_sos_collection.yml -e servers=my_servers -e sosreport_case=01234567
```

Once the playbook its finishing its log collection a `tar.xz` file will be created under the `/var/tmp/` with the following content:

```bash
sos-collector-2023-09-27-zzumt
├── sos_logs
│   ├── sos.log
│   └── ui.log
├── sos_reports
│   └── manifest.json
├── sosreport-someone-test-ctlplane-0-2023-09-27-hubyuit.tar.xz
├── sosreport-someone-test-ctlplane-1-2023-09-27-fskhpqh.tar.xz
├── sosreport-someone-test-ctlplane-2-2023-09-27-jglhruy.tar.xz
├── sosreport-someone-test-worker-0-2023-09-27-uvpujpi.tar.xz
├── sosreport-someone-test-worker-1-2023-09-27-yrsvggt.tar.xz
└── sosreport-someone-test-worker-2-2023-09-27-hyjubpr.tar.xz

2 directories, 9 files
```

License
-------

Apache License 2.0

Author Information
------------------

midu16
