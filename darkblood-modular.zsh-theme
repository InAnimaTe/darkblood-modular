###
# darkblood_modular - A new take on an excellent theme. Easy to make functions
# enabling addition of cool features and functionality.
###

##### Prefix, suffix vars
#
# Colors are defined here and hopefully, only here (not the case).
# ...One day.
THEME_PREFIX="%{$fg[red]%}[%{$fg_bold[white]%}"
THEME_SUFFIX="%{$reset_color%}%{$fg[red]%}]"
THEME_CLEAN="%{$reset_color%}"

#####
## The starting statements.

start_firstline_prompt(){
    ## Starts the formatting and makes any starting text white.
    echo -n "%{$fg[red]%}┌"
}

start_secondline_prompt(){
    ## starting the second line of our prompt
    echo -n "%{$fg[red]%}└"
}

final(){
    ## This function should be run to clear up any outstanding gunk, but not to provide spacing!
    echo -n "%{$reset_color%}"
}
#####
## The following functions are our "plugins" if you will. Use base to call them and wrap/color/format them properly.

base(){
    ## A wrapper for each function below that will be its own entity with [] and proper coloring.
    ## Takes in the function to call and an option to not suffix with a space. useful for the pointy arrow/final character.
    echo -n "$THEME_PREFIX"
    $1
    if [[ "$2" == "nospace" ]]; then
        echo -n "$THEME_SUFFIX"
    else
        echo -n "$THEME_SUFFIX "
    fi
    ## probably don't want to use this for the pointy arrow or whatever final character/func is printed.
}

username_and_host(){
    ## Here we define the username@host part. Some color formatting because of @ symbol.
    echo -n "%n%{$reset_color%}%{$fg[red]%}@%{$fg_bold[white]%}%m"
}

git_stuffs(){
    ## Enter our git prompt
    if [[ "$(uname)" != "Darwin" ]]; then
        if [[ $(stat -L --file-system --format=%T .) != "nfs" ]]; then
            echo -n "%{$(git_prompt_info)%}%(?,,%{$fg[red]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[red]%}])"
        fi
    fi
}

directory_loc(){
    ## print out the directory location
    echo -n "%~"
}

pointy_arrow(){
    ## This little guy goes just before prompt ends aka before cursor sits. Generally, this is after directory printing.
    ## I have left the reset color after this little guy since we don't want our text being colored.
    echo -n "%{$fg[red]%}> "
}

cur_date_time(){
    ## Displays the time "on" date
    echo -n "%* on %W"
}

cur_fs(){
    ## Informs us of the filesystem we are on, useful when on nfs shares
    if [[ "$(uname)" != "Darwin" ]]; then
        echo -n "$(stat -L --file-system --format=%T .)"
    fi
}

fs_capacity(){
    ## Get our capacity/usage percentage for current filesystem
    print "$(df -P . | awk 'NR==2 {print $5}')%%"
}

in_screen(){
## tells us if we are currectly in a screen session
        echo -n "$STY"
}

##### LETS BUILD!

build_firstline_prompt(){
    ## This defines the top left line of the prompt
    start_firstline_prompt
    base username_and_host
##    if [[ "$TERM" == "screen" ]]; then ## This is wrong. TERM also gets set if im in a screen and ssh into another box, TERM still equals "screen" Hence this should just check if STY is populated as that seems to be legit (only populated when presently in a screen)
    if [ $STY ]; then
       base in_screen
    fi
    git_stuffs
}

build_secondline_prompt(){
    ## This defines the second line, just below the first (left side)
    start_secondline_prompt
    base directory_loc nospace  ## since this is the second to last printed out function (just before final declaration)
    pointy_arrow
    final
}

build_right_prompt(){
    ## Defining our right justified prompt (top)
    base fs_capacity
    base cur_fs
    base cur_date_time
    final
}

##### And finally, lets define.

PROMPT='$(build_firstline_prompt)
$(build_secondline_prompt)'
### Disabling right prompt for a bit....have a suspicion it might be making my terminal act up
##RPROMPT='$(build_right_prompt)'

#####
### Dont worry about the stuff below...its for git stuff.

ZSH_THEME_GIT_PROMPT_THEME_PREFIX="%{$fg[red]%}[%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_THEME_SUFFIX="%{$reset_color%}%{$fg[red]%}] "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡%{$reset_color%}"
