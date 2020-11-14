alias recent-branches="git for-each-ref --sort=-committerdate refs/heads/ --format='%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' | column -ts'|'"
alias recent-all="git for-each-ref --sort=-committerdate refs/heads/ refs/remotes --format='%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' | column -ts'|'"

alias gti="git"


#export GIT_AUTHOR_NAME=$(git config author.name)
#export GIT_AUTHOR_EMAIL=$(git config author.email)


git_branch(){
	if git rev-parse --git-dir >/dev/null 2>&1
	then
			if git diff --quiet 2>/dev/null >&2 
			then
				if git diff --staged --quiet 2>/dev/null >&2 
					then
						green_ps1 "$(parse_git_branch)"
					else
						cyan_ps1 "$(parse_git_branch)"
				fi
			else
					red_ps1 "$(parse_git_branch)"
			fi
	else
			parse_git_branch
	fi
}

branch_color(){
	if git rev-parse --git-dir >/dev/null 2>&1
	then
			if git diff --quiet 2>/dev/null >&2 
			then
				if git diff --staged --quiet 2>/dev/null >&2 
					then
						echo -e "${c_green}";
					else
						echo -e "${c_cyan}";
				fi
			else
					echo -e "${c_red}";
			fi
	fi
}
 
parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
          gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  else
          return 0
  fi
  echo -e "($gitver)"
}

# PS1='\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\][\u@\h \W]$ '

# search for commits by Ctrl-G

bind -x '"\C-g": "_fzf_git_widget"'


__fzf_git_hash__() {
  	local commits commit
	commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
	commit=$(echo "$commits" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"  fzf --tac +s +m --ansi --reverse) &&
	hash=$(echo "$commit" |  sed "s/ .*//") &&
	printf '%q ' "$hash"
	echo
}


_fzf_git_widget() {
	cur=""
	local selected="$(__fzf_git_hash__)"
	READLINE_LINE="${READLINE_LINE:0:($READLINE_POINT-${#cur})}$selected${READLINE_LINE:$READLINE_POINT}"
	READLINE_POINT=$(( READLINE_POINT + ${#selected} - ${#cur}))

}

