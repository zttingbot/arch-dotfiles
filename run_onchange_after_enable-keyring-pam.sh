#!/bin/sh
# PAM setup for the login keyring.
#
# Run by `chezmoi apply` after it writes the configs, and again whenever this
# file changes. The package script runs before it, so the PAM module is
# installed by then. Each line is added only when missing, so a rerun changes
# nothing, and each file is copied to <file>.pre-keyring before its first
# change. Every line is optional: if the module fails, login still works.
# Full reference: https://wiki.archlinux.org/title/GNOME/Keyring
#
# Kept in sync with run_onchange_before_install-packages.sh
#   - gnome-keyring there provides the PAM module these lines load.

set -eu

# Set to 1 when a rule needs review. The script then fails, so the apply shows
# it, and chezmoi reruns the script on every apply until the rule is fixed.
status=0

# Prints how FILE's TYPE rules load the module: "none", "ok" when a rule has
# every option in OPTIONS, or "incomplete". Reads PAM's fields instead of
# matching text, so a module named in a comment doesn't count.
rule_state() {
  awk -v type="$2" -v options="$3" '
    BEGIN { state = "none" }
    {
      sub(/#.*/, "")
      t = $1
      sub(/^-/, "", t)
      if (t != type) next
      # A bracketed control such as [success=1 default=ignore] spans fields.
      i = 2
      if ($i ~ /^\[/) while (i < NF && $i !~ /\]$/) i++
      if ($(i + 1) !~ /(^|\/)pam_gnome_keyring\.so$/) next
      args = " "
      for (j = i + 2; j <= NF; j++) args = args $j " "
      n = split(options, want, " ")
      for (k = 1; k <= n; k++) if (!index(args, " " want[k] " ")) break
      if (k > n) state = "ok"
      else if (state == "none") state = "incomplete"
    }
    END { print state }
  ' "$1"
}

# Adds LINE to FILE when no TYPE rule loads the module. A rule that loads it
# without OPTIONS isn't this script's, so it is reported instead of rewritten.
add_pam_line() {
  case $(rule_state "$1" "$2" "$3") in
    ok) ;;
    none)
      [ -e "$1.pre-keyring" ] || sudo cp -p "$1" "$1.pre-keyring"
      # Without a final newline, LINE would join the last rule and break it.
      [ -z "$(tail -c 1 "$1")" ] || printf '\n' | sudo tee -a "$1" >/dev/null
      printf '%s\n' "$4" | sudo tee -a "$1" >/dev/null
      ;;
    incomplete)
      echo "$1: the $2 rule for pam_gnome_keyring.so lacks $3; review it." >&2
      status=1
      ;;
    # awk has already said why it couldn't read FILE.
    *) exit 1 ;;
  esac
}

# =============================================================================
# Console login
# =============================================================================

# startx sessions begin at a console login, the one step that sees the
# password. auth keeps it, and session unlocks the login keyring with it,
# creating the keyring on the first login.
add_pam_line /etc/pam.d/login auth '' \
  'auth       optional     pam_gnome_keyring.so'
add_pam_line /etc/pam.d/login session auto_start \
  'session    optional     pam_gnome_keyring.so auto_start'

# =============================================================================
# Password change
# =============================================================================

# Re-encrypts the keyring when passwd changes the login password. Without it
# the two passwords drift apart and unlocking at login stops working.
add_pam_line /etc/pam.d/passwd password '' \
  'password	optional	pam_gnome_keyring.so'

exit "$status"
