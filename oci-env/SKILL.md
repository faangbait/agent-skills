---
name: oci-env
description "Use before running shell commands or editing `.devcontainer/**` in a VS Code/container workspace. First check `printenv oci-env`; when it succeeds, apply this environment’s runtime guidance. Also use when browser automation fails or PATH/tool availability is unexpected."
---

**CONTRACT: If `printenv oci-env` exits `0`, THIS SKILL CAN HELP YOU.**

This skill documents irregularities in `oci-env`. It does not prescribe workflow / tools. It offers alternatives.

## Runtime Context

If `printenv oci-env` exits 0, the following is true:
- You are in a **rootless Docker container** running a **minimal bootstrap** of RHEL 10.
- You are on an integrated terminal **inside VSCode**.
- You have the following preferred executables on `PATH`: `microdnf`, `git`, `curl`, `wget`, `ssh`, `rsync`, `gpg`, `ps`, `lsof`, `netstat`, `ncat`, `top`, `rg`, `unzip`, `tar`, `gzip`, `xz`, `sed`, `awk`, `jq`, `yq`, `node`, `npm`, `npx`, and `python`. List is not exhaustive.

## How to: Open a non-headless browser

This handoff can open a URI outside the container:

```bash
"$BROWSER" "https://example.com"
```

This function automatically establishes a port forwarding tunnel from the local machine to remote target and returns a local uri to the tunnel. The lifetime of the port forwarding tunnel is managed by the handoff utility and the tunnel can be closed by the user.

Make no assumptions about the resulting uri and do not alter it in any way. Rather, you can e.g. use this uri in an authentication flow, by adding the uri as callback query.

## How to: Install missing utilities

If common utility missing, do not attempt complicated workaround. Simply install utility.

- **Preferred method:** `npm install -g <binary>`

- **Alternative method:** find x86_64 compatible binary, give user shell command to add to `/usr/local/bin`.

Outside `oci-env`, "global package installation" big security risk, but fine inside. Nothing persistent in `oci-env` except for `mounts` defined in `.devcontainer/devcontainer.json`. Make big mistake, need undo? Ask user to rebuild container without cache, problem solved.

Paradoxically, almost nothing persistent in `oci-env`, so don't assume "I've installed this package globally; now I can write tooling that uses it." The lifetime of the installed utility is managed by the environment and can be reset by the user.
