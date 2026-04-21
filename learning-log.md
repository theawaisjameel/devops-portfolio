# Learning Log

## Day 1 — April 8, 2026
**Completed:**
- WSL2 + Ubuntu 22.04 installed and configured
- VS Code + Remote-WSL working
- GitHub SSH authentication set up
- Linux filesystem hierarchy understood
- Portfolio repo created and pushed live

**Commands I learned today:**\
`ls -al` · `find` · `df -h` · `free -h` · `ssh-keygen` · `git config` · `git add` · `git commit` · `git push`

**Struggled with:**
- Difference between `&&` and `||` in Linux  
- GitHub SSH authentication steps  
- Why commit requires staged files

**Tomorrow:**
- Linux permissions (`chmod`, `chown`)  
- Process management (`ps`, `top`, `kill`)

---
---

## Day 2 — April 9, 2026
**Completed:**
- Understood Linux file permissions (r, w, x) and how to read permission strings
- Practiced `chmod` using both symbolic and octal methods
- Learned `chown` and how ownership affects file access
- Understood `umask` and how default permissions are calculated
- Learned process management using `ps`, `top`, `kill`, `pkill`
- Practiced background and foreground jobs (`&`, `jobs`, `fg`, `bg`)
- Simulated real-world permission issue and fixed it
- Simulated CPU hog process and handled it like a real incident

**Commands I learned today:**\
`chmod` · `chown` · `umask` · `ps aux` · `top` · `kill` · `pkill` · `jobs` · `fg` · `bg`

**Struggled with:**
- Understanding ownership vs permissions at first  
- When ownership affects execution even if permissions look correct  
- systemd practice in WSL2 (limited support)

**Key Learnings:**
- Permissions alone are not enough, ownership also matters
- `chmod 000` removes all access and causes permission denied
- `755`, `644`, `600` are commonly used in real systems
- `umask` controls default permissions for new files and directories
- `top` is used for live monitoring, `ps` is used for snapshot
- Always use `kill -15` first, `kill -9` only as last resort
- Never kill processes blindly, always investigate first
- High CPU usage is a symptom, not always the root problem

**Tomorrow:**
- Continue deeper Linux or move to next DevOps topic (depending on roadmap)

---
---


## Day 3 — April 14, 2026

**Completed:**
- Learned Linux user and group management (`useradd`, `usermod`, `groupadd`, `passwd`)
- Practiced creating users and assigning them to groups
- Understood how groups help in managing permissions easily
- Learned about `sudo` and how to give limited access using `/etc/sudoers`
- Understood principle of least privilege with real examples
- Practiced giving restricted sudo access instead of full access

- Learned networking basics (IP, ports, DNS)
- Practiced commands: `ip`, `ping`, `curl`, `ss`, `netstat`, `dig`, `nslookup`
- Understood what “listening on a port” means
- Used `ss -tlnp` to check running services and ports
- Compared `ss` vs `netstat` (modern vs older tool)

- Learned DNS resolution and how `/etc/hosts` works
- Practiced local DNS override using `/etc/hosts`
- Understood difference between DNS issue and service issue

- Completed real-world lab:
  - Created a new user (`jdev`) and assigned proper group
  - Gave limited sudo access (only restart nginx)
  - Verified permissions using `sudo -l`

- Completed service debugging scenario:
  - Diagnosed why port 8080 was not working
  - Checked service using `ss`
  - Tested using `curl`
  - Fixed issue by starting service
  - Understood different errors:
    - connection refused → service not running
    - could not resolve host → DNS issue

---

**Commands I learned today:**  
`useradd` · `usermod` · `groupadd` · `passwd` · `id` · `groups` · `sudo -l` · `ip a` · `ping` · `curl` · `ss -tlnp` · `netstat -tlnp` · `dig` · `nslookup`

---

**Struggled with:**
- Differentiating DNS issue vs service/port issue at first  
- Confusion when `/etc/hosts` was correct but service was not running  
- Understanding WSL behavior with `/etc/hosts`  
- Remembering full debugging flow step-by-step  

---

**Key Learnings:**
- Always follow least privilege, never give full sudo without need  
- Forgetting `-a` in `usermod` can remove user from all groups (dangerous)  
- If port is not visible in `ss`, service is not running  
- `0.0.0.0` means accessible from anywhere, `127.0.0.1` means local only  
- `curl` is used to test services and endpoints  
- DNS only resolves name to IP, it does not guarantee service is running  
- Different curl errors mean different problems (DNS vs service vs network)  
- Correct debugging flow:
  service → port → local access → DNS → network  

---

**Tomorrow:**
- Continue DevOps roadmap and move to next topic

---
---


## Day 4 — April 21, 2026

**Completed:**
- Learned Bash scripting basics and script structure
- Understood shebang (`#!/usr/bin/env bash`) and how scripts execute
- Learned `set -euo pipefail` and why it is important to prevent silent failures

- Practiced variables:
  - Regular, readonly, and environment variables
  - Command substitution using `$(...)`
  - Special variables: `$0`, `$1`, `$@`, `$#`, `$?`, `$$`

- Learned conditionals:
  - `if / elif / else` statements
  - Numeric and string comparisons
  - File and directory checks (`-f`, `-d`, `-e`)
  - Checking command availability using `command -v`

- Practiced loops:
  - `for`, `while`, and `until`
  - Looping over arrays and files
  - Retry pattern using `while`
  - Used `break` and `continue`

- Learned functions:
  - Defined and called functions
  - Passed arguments to functions
  - Used `local` variables to avoid global conflicts
  - Understood `return` vs `exit`
  - Created logging functions for better output

- Learned input handling:
  - Validated arguments using `$#`
  - Assigned positional arguments
  - Validated environment input
  - Used `read` for confirmation prompts

- Completed real-world lab:
  - Built `pre-deploy-check.sh`
  - Validated environment, commands, disk space, files, and network
  - Implemented production safety confirmation
  - Used pass/fail counters and exit codes for final decision

---

**Commands I learned today:**  
`chmod` · `read` · `df` · `awk` · `ss` · `grep` · `command -v` · `whoami` · `date`

---

**Struggled with:**
- Understanding `set -euo pipefail` behavior in different cases  
- Difference between `exit` and `return`  
- Tracking `$?` after commands  
- Handling input validation logic  

---

**Key Learnings:**
- Always validate inputs before running scripts  
- Use `local` in functions to prevent bugs  
- Exit codes control script flow and CI/CD behavior  
- Retry logic is important in real deployments  
- Logging makes scripts easier to debug and understand  
- Scripts should fail safely and clearly  

---

**Tomorrow:**
- Learn advanced argument handling and error trapping  
- Explore cron jobs and automation  
- Build system health monitoring script
