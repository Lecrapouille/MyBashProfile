# An owl in your bash

![alt tag](https://github.com/Lecrapouille/MyBashPrompt/blob/master/owl.png)

Here is the bash code for my console prompt. Copy/paste this code in your `~/.bashrc` file to have the same than me.

```
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
}

PROMPT_COMMAND=prompt_command

function twtty {
    local NO_COLOUR="\[\033[0m\]"
    local BLUE="\[\033[1;34m\]"
    local YELLOW="\[\033[1;36m\]"

    PS1="
$BLUE ^_^
($YELLOW*.*$BLUE)
(   )
$YELLOW ~ ~ $BLUE-$YELLOW-\${fill}$BLUE-($YELLOW\${newPWD}$BLUE)-$YELLOW-
$BLUE($YELLOW\$(date +%Hh%M)$BLUE::$YELLOW\$(date \"+%a %d %b %y\")$BLUE)
$NO_COLOUR "

    PS2="$BLUE-$YELLOW--$NO_COLOUR "
}

twtty;
```
