setopt PROMPT_SUBST
autoload colors
colors

possible_colours=(013 009 010 011 014)

NEWLINE=$'\n'
PROMPT_COLOUR=${possible_colours[$(( $RANDOM % ${#possible_colours[@]} + 1 ))]}
PROMPT='${NEWLINE}%F{$PROMPT_COLOUR}%K{$PROMPT_COLOUR}%F{015}%m %K{015}%F{$PROMPT_COLOUR}%n%k%F{015} %F{$PROMPT_COLOUR}%K{$PROMPT_COLOUR}%F{015}%F{015}%~%k%F{$PROMPT_COLOUR}${NEWLINE}%K{009} %F{015} %k%F{009}%f '
