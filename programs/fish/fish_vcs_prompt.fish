# Add other VCS prompts to the list. Executed in order,
# prints the first that returns a zero exit code.
fish_jj_prompt $argv
or fish_git_prompt $argv
