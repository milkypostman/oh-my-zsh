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
PROMPT_SUCCESS_COLOR=%F{yellow}
PROMPT_FAILURE_COLOR=%F{124}
PROMPT_VCS_INFO_COLOR=%F{242}
PROMPT_VCS_BASE_COLOR=%F{242}
PROMPT_VCS_PATH_COLOR=%F{blue}

# Set required options.
setopt promptsubst

# Load required modules.
autoload -U add-zsh-hook
autoload -Uz vcs_info

# Add hook for calling vcs_info before each command.
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*:*' actionformats "%R" "/%S" "%b %u%c (%a)"
        zstyle ':vcs_info:*:*' formats "%R" "/%S" "%b %u%c"
    } else {
        zstyle ':vcs_info:*:*' actionformats "%R" "/%S" "%b %u%c* (%a)"
        zstyle ':vcs_info:*:*' formats "%R" "/%S" "%b %u%c*"
    }

    vcs_info
}

add-zsh-hook precmd theme_precmd

# Set vcs_info parameters.
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' nvcsformats "%~" ""

# Define prompts.
PROMPT='%B${SSH_TTY:+[%n@%m]}$PROMPT_VCS_BASE_COLOR${vcs_info_msg_0_/#$HOME/~}$PROMPT_VCS_PATH_COLOR${vcs_info_msg_1_%%/.} %(0?.%{$PROMPT_SUCCESS_COLOR%}.%{$PROMPT_FAILURE_COLOR%})%(!.$PROMPT_ROOT_END.$PROMPT_DEFAULT_END)%b%f '
RPROMPT='%(?..%{$PROMPT_FAILURE_COLOR%}%? %f)$PROMPT_VCS_INFO_COLOR$vcs_info_msg_2_%f'
