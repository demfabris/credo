### Ayu Dark theme for tmux
# Palette
# bg        : #0A0E14
# fg        : #B3B1AD
# muted     : #5C6773
# selection : #273747
# orange    : #E6B450
# cyan      : #95E6CB
# blue      : #5CCFE6
# purple    : #D4BFFF
# red       : #F07178

# Status bar
set -g status-style 'bg=default,fg=#B3B1AD'
set -g status-justify centre
set -g status-left-length 32
set -g status-right-length 90

# Left: session name (accent) + pane index (muted)
set -g status-left '#[bg=#E6B450,fg=#0A0E14,bold] #S #[bg=default,fg=#5C6773] | #I:#P '

# Right: date (muted) • time (fg) • user (accent)
set -g status-right '#[fg=#5C6773]%Y-%m-%d #[fg=#5C6773]• #[fg=#B3B1AD]%H:%M #[fg=#5C6773]• #[fg=#E6B450,bold]#(whoami)'

# Windows
set -g window-status-style 'bg=default,fg=#5C6773'
set -g window-status-activity-style 'bg=default,fg=#95E6CB'

# Window formats: emphasise current with accent
set -g window-status-format ' #[fg=#5C6773]#I:#W#{?window_flags, #[fg=#F07178]#F,} '
set -g window-status-current-format '#[bg=#E6B450,fg=#0A0E14,bold] #I:#W #{?window_flags,#F,} '

# Panes and messages
set -g pane-border-style 'fg=#273747'
set -g pane-active-border-style 'fg=#E6B450'
set -g message-style 'bg=#E6B450,fg=#0A0E14,bold'
set -g message-command-style 'bg=#E6B450,fg=#0A0E14,bold'
set -g mode-style 'bg=#273747,fg=#B3B1AD'

# Search highlighting (/ in copy-mode)
set -g copy-mode-match-style 'bg=#273747,fg=#B3B1AD'
set -g copy-mode-current-match-style 'bg=#E6B450,fg=#0A0E14,bold'

# Clock (prefix + t)
set -g clock-mode-colour '#E6B450'

# Display pane numbers overlay
set -g display-panes-active-colour '#E6B450'
set -g display-panes-colour '#5C6773'
