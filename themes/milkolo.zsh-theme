autoload -U colors && colors

autoload -Uz vcs_info
PROMPT_SUCCESS_COLOR=%F{011}
PROMPT_FAILURE_COLOR=%F{124}

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%S' '[%b%c%u%B%F{green}]'
    } else {
        zstyle ':vcs_info:*' formats '%S' '[%b%c%u%B%F{red}●%F{green}]'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%B%F{magenta}${vcs_info_msg_0_} %B%F{green}${vcs_info_msg_1_}%B%F{magenta} %(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})%%%b%f '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
