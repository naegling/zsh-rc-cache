#
# rc-cache: plugin that caches initialization scripts and automatically regenerates as needed.
#

function rc-cache() {

  [[ $# -gt 0 ]] && local cmd=$1 && shift
  local CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-rc-cache"

  case "$cmd" in

    src)
      if [[ $# -gt 0 ]]; then
        local prog=$1; shift
        local CACHE_FILE="$CACHE_HOME/zshrc-$prog-init"
        if [[ ! -f "$CACHE_FILE" ]] || [[ ! "$CACHE_FILE" -nt "${commands[$prog]}" ]]; then
          mkdir -p "$CACHE_HOME"
          $prog "$@" >! "$CACHE_FILE"
        fi
        source "$CACHE_FILE"
      fi
      ;;

    clear)
      rm -rf "$CACHE_HOME"
      ;;

    *) echo "usage:"
        echo "  rc-cache clear"
        echo "  rc-cache src prog [args ...]"
        echo "    where 'prog [args ...]' generates a hook to be sourced in zshrc"
        return 1
      ;;
  esac
}
