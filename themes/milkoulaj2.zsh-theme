#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Prompt for the Zsh shell:
#   * One line.
#   * VCS info on the right prompt.
#   * Only shows the path on the left prompt by default.
#   * Crops the path to a defined length and only shows the path relative to
#     the current VCS repository root.
#   * Wears a different color wether the last command succeeded/failed.
#   * Shows user@hostname if connected through SSH.
#   * Shows if logged in as root or not.
# ------------------------------------------------------------------------------

# Customizable parameters.
PROMPT_PATH_MAX_LENGTH=30
PROMPT_DEFAULT_END=❯
PROMPT_ROOT_END=❯❯❯
PROMPT_SUCCESS_COLOR=$FG[011]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]

# Set required options.
setopt promptsubst

# Load required modules.
autoload -U add-zsh-hook
autoload -Uz vcs_info

# Add hook for calling vcs_info before each command.
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*:*' formats "%S" "%r/%b" "%u%c"
    } else {
        zstyle ':vcs_info:*:*' formats "%S" "%r/%b" "%u%c%F{red}✭%f"
    }

    vcs_info
}

add-zsh-hook precmd theme_precmd

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr '%F{yellow}✹%f'
zstyle ':vcs_info:*:*' stagedstr '%F{green}✚%f'
zstyle ':vcs_info:*:*' actionformats "%S" "%r/%s/%b %u%c (%a)"
# zstyle ':vcs_info:*:*' formats "%S" "%r/%s/%b %u%c"
zstyle ':vcs_info:*:*' nvcsformats "%~" ""

# Define prompts.
PROMPT="%(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})${SSH_TTY:+[%n@%m]}%{$FX[bold]%}%$PROMPT_PATH_MAX_LENGTH<..<"'${vcs_info_msg_0_%%.}'"%<<%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%{$FX[no-bold]%}%{$FX[reset]%} "
RPROMPT='${PROMPT_VCS_INFO_COLOR}${vcs_info_msg_1_}${vcs_info_msg_2_}'
