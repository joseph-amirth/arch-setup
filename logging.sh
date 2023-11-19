#!/bin/bash
# Bash script with helper functions for logging.

source formatting.sh

# Function that executes a command with some logging. It takes the following arguments:
# 1. Message for while the command is executing.
# 2. Message for after the command has successfully executed.
# 3. Message for after the command has aborted with an error.
#
# Usage:
# execute_command \
#   --info "Info about command" \
#   --success "Command completed" \
#   --error "Error" \
#   -- command
function execute_command() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --info)
                INFO_MSG=$2
                shift
                shift
                ;;
            --success)
                SUCCESS_MSG=$2
                shift
                shift
                ;;
            --error)
                ERROR_MSG=$2
                shift
                shift
                ;;
            --abort_if_error)
                ABORT_IF_ERROR=1
                shift
                ;;
            --) 
                shift
                break
                ;;
            *)
                errorln "Invalid argument passed to execute_command."
                exit 1
        esac
    done

    INFO_MSG=${INFO_MSG:-"Executing $@..."}
    SUCCESS_MSG=${SUCCESS_MSG:-"Successfully executed $@."}
    ERROR_MSG=${ERROR_MSG:-"Error while executing $@."}
    ABORT_IF_ERROR=${ABORT_IF_ERROR:-0}

    infoln "$INFO_MSG"

    echo "[COMMAND] $@" >> $LOG_FILE
    $@ &> $LOG_FILE
    EXIT_CODE=$?

    clear_line
    if [[ $EXIT_CODE -eq 0 ]]; then
        successln "$SUCCESS_MSG"
    else
        errorln "$ERROR_MSG"
        if [[ $ABORT_IF_ERROR -eq 1 ]]; then
            exit 1
        fi
    fi
}
