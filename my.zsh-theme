setopt PROMPT_SUBST
autoload colors
colors

NEWLINE=$'\n'
PROMPT='${NEWLINE}%F{013}%K{013}%F{015}%m %K{015}%F{013}%n%k%F{015} %F{013}%K{013}%F{015}%F{015}%~%k%F{013}${NEWLINE}%K{009} %F{015} %k%F{009}%f '
