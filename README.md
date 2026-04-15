# ensure-tmux-sessions

Minimalism by design for tmux.  
One registry.  
One script.  
One line in the shell.  

This project guarantees a single thing:

> declared tmux sessions exist at login

Nothing more.

Tmux remains used as usual.

## Principle

You declare a list of sessions.

At SSH login:

- sessions are created if absent
- no session is destroyed
- no state is modified
- you are attached to `main`

## Installation

1. Copy the script:

```bash
mkdir -p ~/.local/bin
cp ensure_tmux_sessions.sh ~/.local/bin/
chmod +x ~/.local/bin/ensure_tmux_sessions.sh
```

1. Add to `.bash_profile`:

```bash
if [[ -n "${SSH_CONNECTION:-}" ]] && [[ -z "${TMUX:-}" ]]; then
  "$HOME/.local/bin/ensure_tmux_sessions.sh" "$HOME/.config/tmux/session_registry.conf"
  exec tmux attach-session -t main
fi
```

## Session registry

Recommended path:

```conf
~/.config/tmux/session_registry.conf
```

Format:

```conf
session_name:path
```

- `session_name`: required  
- `path`: optional but recommended  

## Example

```conf
main
project_name:/home/<user_name>/repos/project_name/.tmux/session.sh
another_session:/home/<user_name>/another_session
```

## Behavior

For each line in the registry:

- if the session exists → nothing  
- otherwise:
  - if `path` is an existing directory → session is created in that directory
  - if `path` is a shell script → it is executed to initialize the session
  - otherwise → session is created without a specific working directory

No existing session is modified.
