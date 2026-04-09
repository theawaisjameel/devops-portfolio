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
