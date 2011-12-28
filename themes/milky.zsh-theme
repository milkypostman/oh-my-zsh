#!/usr/bin/env zsh

autoload -U colors && colors

autoload -Uz vcs_info

PROMPT_DEFAULT_END=❯
PROMPT_ROOT_END=\#
PROMPT_SUCCESS_COLOR=$FG[011]
PROMPT_FAILURE_COLOR=$FG[124]

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%S' '%u%c %F{green}%b'
    } else {
        zstyle ':vcs_info:*' formats '%S' '%F{red}●%u%c %F{071}%F{green}%b'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%B%F{magenta}${vcs_info_msg_0_%%.}%B%F{magenta}%(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%b%f '
RPROMPT='%F{green}${vcs_info_msg_1_}'

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
