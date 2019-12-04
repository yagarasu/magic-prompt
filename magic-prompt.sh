#!/usr/bin/env bash

# Refs: https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
# Refs: https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git

normal=$(tput setaf 7)
dark=$(tput setaf 8)
cyan=$(tput setaf 6)
hcyan=$(tput setaf 14)
white=$(tput setaf 15)
reset=$(tput sgr0)

_prompt_git() {
  local status=''
  local branch=''
  local branchType=''
  local upToDate=0

  # Check if the current directory is in a Git repository.
	git rev-parse --is-inside-work-tree &>/dev/null || return;

  # Check for what branch we’re on.
	# Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
	# tracking remote branch or tag. Otherwise, get the
	# short SHA for the latest commit, or give up.
	branch="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
		git describe --all --exact-match HEAD 2> /dev/null || \
		git rev-parse --short HEAD 2> /dev/null || \
	echo '(unknown)')";

  # Check branch type using the branch name
  case "$branch" in
    *master* ) branchType='👑 ';;
    *develop* ) branchType='☕️ ';;
    *feature/* ) branchType='🛠 ';;
    *bugfix/* ) branchType='🐛 ';;
    *release/* ) branchType='🚀 ';;
    * ) branchType='🧺 ';;
  esac

  # Check for uncommitted changes.
  if ! $(git diff --quiet --ignore-submodules --cached); then
  	status+='*';
  fi;
  # Check for unstaged changes.
  if ! $(git diff-files --quiet --ignore-submodules --); then
  	status+='+';
  fi;
  # Check for untracked files.
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  	status+='?';
  fi;
  # Check for stashed files.
  if $(git rev-parse --verify refs/stash &>/dev/null); then
  	status+='$';
  fi;
  # Check if repo is ahead or behind the remote
  if [ $(git rev-parse @) = $(git rev-parse @{u}) ]; then
    upToDate=1;
  elif [ $(git rev-parse @) = $(git merge-base @ @{u}) ]; then
    status+='⬇';
  elif [ $(git rev-parse @{u}) = $(git merge-base @ @{u}) ]; then
    status+='⬆';
  else
    status+='⬇⬆';
  fi;

  echo -e "${branchType} ${branch} ${status}"
}

_nl_if_git() {
	# Check if the current directory is in a Git repository.
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		echo -e "\n⤇ "
	fi;
}

_warn_if_failed() {
	if [ "$1" != "0" ]; then
		echo " ⚠️ "
	else
		echo ""
	fi;
}

__prompt_command() {
	local LAST_RET="$?"

	PS1="\[${dark}\]\$(_prompt_git)\$(_nl_if_git)" # git prompt
	PS1+="\[${hcyan}\]\u" # username
	PS1+=" \[${normal}\]@" # @
	PS1+=" \[${cyan}\]\h" # host
	PS1+=" \[${white}\]\W" # cwd
	PS1+="\$(_warn_if_failed $LAST_RET)" # ret
	PS1+=" \[${normal}\]\$ \[${reset}\]" # $/#

	export PS1
}

export PROMPT_COMMAND=__prompt_command
