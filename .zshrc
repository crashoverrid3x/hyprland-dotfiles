export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="afowler"

ENABLE_CORRECTION="true"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.local/kitty.app/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin/bat-binary/:$HOME/.local/bin/"
export TERMINAL=kitty

alias up="~/.config/bin/up.sh"
alias jr="cc -Wall -Wextra -Werror"
alias catn="cat"
alias cat="bat"
# Añade esto al final de tu archivo ~/.bashrc
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gp='git push'
alias gpl='git pull'
alias gpom='git push origin main'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glo='git log --oneline'
alias gss='git status -s'
alias grh='git reset HEAD'
alias grhh='git reset --hard HEAD'

# Pronmpt configuration

function dir_icon {
	if [[ "$PWD" == "$HOME" ]]; then
		echo "%B%F{black}%f%b"
	else
		echo "%B%F{cyan}%f%b"
	fi
}

function parse_git_branch {
	local branch
	branch=$(git symbolic-ref --short HEAD 2> /dev/null)
	if [ -n "$branch" ]; then
		echo " [$branch]"
	fi
}

# Custom Aliases
PROMPT='%F{cyan}󰣇 %f %F{magenta}%n%f $(dir_icon) %F{red}%~%f%${vcs_info_msg_0_} %F{yellow}$(parse_git_branch)%f %(?.%B%F{green}.%F{red})%f%b '
USER=jreyes-s
export USER




# cpp-fast-config path start
if [[ -d "$HOME/.cpp-fast-config/bin" ]]; then
  case ":$PATH:" in
    *":$HOME/.cpp-fast-config/bin:"*) ;;
    *) export PATH="$HOME/.cpp-fast-config/bin:$PATH" ;;
  esac

  hash -r 2>/dev/null || true
  rehash 2>/dev/null || true
fi
# cpp-fast-config path end
# cpp-fast-config run start
run() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -x "$dir/.vscode/run" ]]; then
      "$dir/.vscode/run" "$@"
      return $?
    fi
    dir="$(dirname "$dir")"
  done
  echo "No .vscode/run found above current directory." >&2
  return 1
}

cpp() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -x "$dir/.vscode/cpp" ]]; then
      "$dir/.vscode/cpp" "$@"
      return $?
    fi
    dir="$(dirname "$dir")"
  done

  if [[ -x "$HOME/.cpp-fast-config/bin/cpp" ]]; then
    "$HOME/.cpp-fast-config/bin/cpp" "$@"
    return $?
  fi

  echo "No local '.vscode/cpp' or global helper found." >&2
  return 1
}

create_cpp_app() {
  cpp init "$@"
}

alias create-cpp-app='create_cpp_app'
# cpp-fast-config run end
