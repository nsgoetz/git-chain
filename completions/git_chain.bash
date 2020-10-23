# git_chain.bash

_git_chain_branch() {
  raw_branches=()
  eval "$(git for-each-ref --shell --format='raw_branches+=(%(refname))' refs/heads/)"
  branches=()
  for b in "$(git branch --list --format=%\(refname:short\))"; do 
    branches+=($b)
  done

  local prev_words=("${COMP_WORDS[@]}")

  branches_string="${branches[*]}"
  COMPREPLY=( $(compgen -W "${branches_string}" -- "${word}") )

}

_chain_name_completion() {
  local word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  local prev_words="${COMP_WORDS[@]:2:COMP_CWORD-1}"

  if [ "$prev_word" == "-c" ]; then
    chains="$(git chain list -s)"
    COMPREPLY=( $(compgen -W "${chains}" -- "${word}") )
  elif ! [[ "${prev_words[@]}" =~ '-c' ]]; then
    COMPREPLY+=('-c')
    COMPREPLY=( $(compgen -W "${COMPREPLY[*]}" -- "${word}") ) 
  fi

}

_git_chain_rebase() {
  COMPREPLY=()

  _chain_name_completion
}

_git_chain_setup() {
  local prev_words="${COMP_WORDS[@]::COMP_CWORD}"

  raw_branches=()
  eval "$(git for-each-ref --shell --format='raw_branches+=(%(refname))' refs/heads/)"
  branches=()
  for b in "${raw_branches[@]}"; do
    # ideal impl but it is not working; current impl has a substr problem 
    branch=$(echo "$b" | sed 's/refs\/heads\///')

    already_used=0
    for prev in $prev_words; do
      if [[ $branch == $prev ]]; then
        already_used=1
      fi 
    done

    if [[ ${already_used} -eq 0 ]] ; then
      branches+=($branch)
    fi
  done

  branches_string="${branches[*]}"
  COMPREPLY=( $(compgen -W "${branches_string}" -- "${word}") )

  _chain_name_completion
}

_git_chain_push() {
  COMPREPLY=("-u" "--set-upstream" "-f" "--force")
}

_git_chain_list() {
  COMPREPLY=("-s" "--short")
}

_git_chain_arcdiff() {
  COMPREPLY=()
}

_git_chain() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  local words=("${COMP_WORDS[@]}")
  local commands="branch list push rebase setup arcdiff"


  if [[ "$COMP_CWORD" -eq 2 ]]; then 
  
    COMPREPLY=( $(compgen -W "${commands}" -- "${word}") )
  
  elif [ "$COMP_CWORD" -gt 2 ]; then

    sub_command="${COMP_WORDS[2]}"

    case "${sub_command}" in
      "branch" ) 
        _git_chain_branch
        ;;
      "list" ) 
        _git_chain_list
        ;;
      "push" )
        _git_chain_push
        ;;
      "rebase" ) 
        _git_chain_rebase
        ;;
      "setup" )
        _git_chain_setup
        ;;
      "arcdiff" )
        _git_chain_arcdiff
        ;;
      * ) ;;
    esac


  fi
}

complete -F _git_chain git chain
