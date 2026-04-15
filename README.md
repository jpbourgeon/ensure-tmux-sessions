# ensure-tmux-session

Minimalisme assumé pour tmux.
Un registre.  
Un script.  
Une ligne dans le shell.  

Ce projet garantit une seule chose :

> les sessions tmux déclarées existent au login

Rien d’autre.

Tmux reste utilisé normalement.

## Principe

Tu déclares une liste de sessions.

Au login SSH :

- les sessions sont créées si absentes
- aucune session n’est détruite
- aucun état n’est modifié
- tu es attaché à `main`

## Installation

1. Copier le script :

```bash
mkdir -p ~/.local/bin
cp ensure_tmux_sessions.sh ~/.local/bin/
chmod +x ~/.local/bin/ensure_tmux_sessions.sh
```

1. Ajouter au `.bash_profile` :

```bash
if [[ -n "${SSH_CONNECTION:-}" ]] && [[ -z "${TMUX:-}" ]]; then
  "$HOME/.local/bin/ensure_tmux_sessions.sh" "$HOME/.config/tmux/session_registry.conf"
  exec tmux attach-session -t main
fi
```

## Registre des sessions

Path recommandé:

```conf
~/.config/tmux/session_registry.conf
```

Format :

```conf
session_name:path
```

- `session_name` : obligatoire  
- `path` : optionnel mais recommandé  

## Exemple

```conf
main:$HOME
project_name:$HOME/repos/project_name/.tmux/session.sh
another_session
```

## Comportement

Pour chaque ligne du registre :

- si la session existe → rien  
- sinon :
  - si `path` est un dossier existant → session créée dans ce répertoire
  - si path est un script shell → il est exécuté pour initialiser la session
  - sinon → session créée sans répertoire spécifique

Aucune session existante n’est modifiée.
