RED="\[\033[0;31m\]"
YELLOW="\[\033[1;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_BLUE="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(LANG=en_GB git status 2> /dev/null)"
  branch_pattern="^On branch ([^${IFS}]*)"
  detached_pattern="HEAD detached"

  # Check if we're in detached HEAD state
  if [[ ${git_status} =~ ${detached_pattern} ]]; then
    branch=${RED}detached
    sha1=${BLUE}::${LIGHT_BLUE}$(git rev-parse --short HEAD)
  elif [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${LIGHT_BLUE}${BASH_REMATCH[1]}
    sha1=${BLUE}::${LIGHT_BLUE}$(git rev-parse --short HEAD)
  else
    return
  fi

  uptodate_pattern="is up to date with"
  ahead_pattern="Your branch is ahead .* by ([[:digit:]]+) commit"
  behind_pattern="Your branch is behind .* by ([[:digit:]]+) commit"
  untrack_pattern="Untracked files"
  staged_pattern="Changes to be committed"
  notstaged_pattern="Changes not staged for commit"
  conflict_pattern="Unmerged paths"

  # Repository clean
  if [[ ${git_status} =~ ${uptodate_pattern} ]]; then
    state="${GREEN}✔ "
  else
    # ahead of remote by n commits
    if [[ ${git_status} =~ ${ahead_pattern} ]]; then
      state="${state}${YELLOW}▲${BASH_REMATCH[1]} "
    fi
    # behind remote by n commits
    if [[ ${git_status} =~ ${behind_pattern} ]]; then
      state="${state}${RED}▼${BASH_REMATCH[1]} "
    fi
  fi

  # Untracked files
  if [[ ${git_status} =~ ${untrack_pattern} ]]; then
    remote="${LIGHT_BLUE}…"$(git ls-files --others --exclude-standard | wc -l)
  fi
  # Staged files
  if [[ ${git_status} =~ ${staged_pattern} ]]; then
    remote="${remote}${GREEN}✚"$(git diff --name-only --cached | wc -l)
  fi
  # Files with merge conflicts
  if [[ ${git_status} =~ ${conflict_pattern} ]]; then
    remote="${remote}${RED}✖"$(git diff --name-only --diff-filter=U --relative | wc -l)
  fi
  # Modified files
  if [[ ${git_status} =~ ${notstaged_pattern} ]]; then
    remote="${remote}${YELLOW}●"$(git diff --name-status | wc -l)
  fi

  if [ "${remote}" != "" ]; then
    remote="(${BLUE}${remote}${BLUE})"
  fi

  echo "${BLUE}(${state}${branch}${sha1}${BLUE})${remote}"
}

########################################
#              PROMPT                  #
########################################

function twtty {
    PS1="
${BLUE} ,___,
 (${LIGHT_BLUE}o${YELLOW},${LIGHT_BLUE}O${BLUE})
/(   )
${BLUE}-${YELLOW} ~ ~ ${BLUE}-\${fill}${BLUE}-(${LIGHT_BLUE}\${newPWD}${BLUE})-
${BLUE}(${LIGHT_BLUE}\$(date +%Hh%M)${BLUE}::${LIGHT_BLUE}\$(date \"+%a %d %b %y\")${BLUE})$(parse_git_branch)
${COLOR_NONE} "

    PS2="${BLUE}-${LIGHT_BLUE}--${COLOR_NONE} "
}

function prompt_command {
    TERMWIDTH=${COLUMNS}
    fill=""
    newPWD="${PWD}"
    let promptsize=$(echo -n "${PWD}++++++++++++" | wc -c | tr -d " ")
    let fillsize=${TERMWIDTH}-${promptsize}
    while [ "$fillsize" -gt "0" ]
    do
        fill="${fill}-";
        let fillsize=${fillsize}-1;
    done

    if [ "$fillsize" -lt "0" ]
    then
        let cut=3-${fillsize};
        newPWD="...$(echo -n $PWD | sed -e "s/\(^.\{$cut\}\)\(.*\)/\2/")";
    fi
    twtty
}

PROMPT_COMMAND=prompt_command