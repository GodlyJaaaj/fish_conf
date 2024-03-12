## cds command that runs cds . . and if --update is passed, it will update the current project
#add description to cds
function cds --description 'Run coding-style.sh in the current project, see --help for more info'

  set -l CDS_BIN_PATH "/home/jaaaj/apps/coding-style-checker/coding-style.sh"
  set -l CDS_PATH (dirname $CDS_BIN_PATH)

  argparse 'u/update' 'h/help' -- $argv
  or return

  if set -ql _flag_help
    set_color yellow
    echo "Usage: cds [options]"
    echo ""
    echo "Options:"
    echo "  -u, --update  Update the coding-style-checker to the latest version"
    echo "  -h, --help    Show this help message"
    set_color normal
    return 0
  end

  if set -ql _flag_update
    set_color yellow
    echo "Pulling the latest version of the coding-style-checker"
    set_color normal
    docker pull ghcr.io/epitech/coding-style-checker:latest > /dev/null && docker image prune -f > /dev/null
    if test $status -ne 0
      set_color red
      echo "Failed to pull the latest version of the coding-style-checker"
      set_color normal
      return 1
    end
    if test $status -eq 0
      set_color green
      echo "Successfully pulled the latest version of the coding-style-checker"
      set_color normal
    end
  else
    set_color yellow
    echo "Cleaning the current project"
    set_color normal
    make fclean &> /dev/null
    $CDS_BIN_PATH . . &> /dev/null
    if test -s "coding-style-reports.log"
      set_color red
      cat coding-style-reports.log
      set_color normal
    else
      echo (set_color green) "No coding-style-reports.log file found, everything is fine"
    end
    rm -f coding-style-reports.log
  end
end
