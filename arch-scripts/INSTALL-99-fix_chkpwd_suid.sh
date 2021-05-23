#!/bin/bash
# Set the correct permission bits on unix_chkpwd to work around the bug that occurs with KDE screenlocker
# https://www.reddit.com/r/kde/comments/8w7uqq/screen_wont_unlock/e1tjdu3/
CHKPWD_FILE="/sbin/unix_chkpwd"
CORRECT_SUID="4755"
echo "Checking file $CHKPWD_FILE..."
[[ -f "$CHKPWD_FILE" ]] || { echo "$CHKPWD_FILE doesn't exist! This usually means trouble."; exit; } && echo "The file exists..."
echo "Checking permission bits..."
CURRENT_SUID="$(stat -c '%a' ${CHKPWD_FILE})"
if ! [[ "$CORRECT_SUID" = "$CURRENT_SUID" ]]; then { echo "UID on ${CHKPWD_FILE} is not correct!"; echo "Setting the right UID..."; chmod 4755 "${CHKPWD_FILE}"; }; else echo "The permission bits are okay."; fi
