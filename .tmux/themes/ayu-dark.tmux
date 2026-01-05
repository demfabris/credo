### Ayu Dark theme for tmux (mini.statusline style)
# Palette
# bg        : #0d1017
# fg        : #BFBDB6
# muted     : #636A72
# selection : #1a1f29
# orange    : #E6B450
# cyan      : #95E6CB
# blue      : #59C2FF
# purple    : #D2A6FF
# green     : #AAD94C
# red       : #F07178

# Status bar - balanced minimal
set -g status-style 'bg=#0d1017,fg=#BFBDB6'
set -g status-interval 5
set -g status-justify centre
set -g status-left-length 32
set -g status-right-length 48

# Left: session name (lights up on prefix) + zoom indicator
# - Normal: orange accent
# - Prefix active: cyan highlight
# - Zoomed: shows 󰁌 icon
set -g status-left '#{?client_prefix,#[bg=#59C2FF],#[bg=#E6B450]}#[fg=#0d1017,bold] #S #{?window_zoomed_flag,󰁌 ,}#[bg=default,fg=#636A72] '

# Right: git branch + time + pane
set -g status-right '#[fg=#D2A6FF]#{?#{!=:#(git -C "#{pane_current_path}" branch --show-current 2>/dev/null),}, #(git -C "#{pane_current_path}" branch --show-current 2>/dev/null),} #[fg=#636A72]%H:%M #[fg=#E6B450]󰇙 #[fg=#636A72]#I:#P '

# Windows - inactive muted, active accented
set -g window-status-style 'bg=default,fg=#636A72'
set -g window-status-activity-style 'bg=default,fg=#95E6CB'

# Window formats: icons + name, current highlighted
set -g window-status-format '  #W  '
set -g window-status-current-format '#[bg=#1a1f29,fg=#E6B450,bold]  #W  '

# Panes and messages
set -g pane-border-style 'fg=#636A72'
set -g pane-active-border-style 'fg=#59C2FF'
set -g pane-border-indicators arrows
set -g message-style 'bg=#E6B450,fg=#0d1017,bold'
set -g message-command-style 'bg=#E6B450,fg=#0d1017,bold'
set -g mode-style 'bg=#1a1f29,fg=#BFBDB6'

# Search highlighting (/ in copy-mode)
set -g copy-mode-match-style 'bg=#1a1f29,fg=#BFBDB6'
set -g copy-mode-current-match-style 'bg=#E6B450,fg=#0d1017,bold'

# Clock (prefix + t)
set -g clock-mode-colour '#E6B450'

# Display pane numbers overlay
set -g display-panes-active-colour '#E6B450'
set -g display-panes-colour '#5C6773'
