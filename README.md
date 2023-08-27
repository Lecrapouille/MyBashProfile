# An owl in your bash

![alt tag](https://github.com/Lecrapouille/MyBashPrompt/blob/master/owl.png)

Here is the bash code for my console prompt. Copy/paste this code in your `~/.bashrc` file to have the same than me.

```
########################################
#               GIT                    #
########################################

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(LANG=en_GB git status 2> /dev/null)"
  branch_pattern="^On branch ([^${IFS}]*)"
  remote_pattern=" Your branch is (.*) of"
  diverge_pattern=" Your branch and (.*) have diverged"
  untrack_pattern="Untracked files"
  notstaged_pattern="Changes not staged for commit"
  uptodate_pattern="is up to date with"

  if [[ ! ${git_status} =~ ${uptodate_pattern} ]]; then
    state="${RED}🗘"
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${LIGHT_BLUE}⧖"${BLUE}::
  elif [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${LIGHT_BLUE}△"${BLUE}::
    else
      remote="${LIGHT_BLUE}▽"${BLUE}::
    fi
  fi
  if [[ ${git_status} =~ ${untrack_pattern} ]]; then
    dirty="${RED}⚡"
  elif [[ ${git_status} =~ ${notstaged_pattern} ]]; then
    dirty="${RED}⚡"
  fi
  if [ "${state}${dirty}" == "" ]; then
    ok="${GREEN}✅"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${LIGHT_BLUE}${BASH_REMATCH[1]}${BLUE}::
    sha1=${LIGHT_BLUE}$(git rev-parse --short HEAD)${BLUE}::
    echo "${BLUE}(${state}${branch}${sha1}${remote}${dirty}${ok}${BLUE})"
  fi
}

########################################
#              PROMPT                  #
########################################

function twtty {
    PS1="
${BLUE} ^_^
(${LIGHT_BLUE}*.*${BLUE})
(   )
${LIGHT_BLUE} ~ ~ ${BLUE}-${LIGHT_BLUE}-\${fill}${BLUE}-(${LIGHT_BLUE}\${newPWD}${BLUE})-${LIGHT_BLUE}-
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
```
