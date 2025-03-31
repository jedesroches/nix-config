#!/bin/sh

set -eu

usage() { echo "usage: $0 [REVISION]"; exit 1;}
hash jj gh || exit 127
[ $# -ge 2 ] && usage

CHANGEREF=${1:-@}
CHANGEID=$(jj log \
  -T 'self.change_id()' \
  -r "$CHANGEREF" \
  --ignore-working-copy \
  --no-graph \
  --no-pager \
  --color never
)

jj git push \
  -c "$CHANGEID" \
  --ignore-working-copy

BOOKMARK=$(jj bookmark list \
  -r "$CHANGEID" \
  -T 'self.name()' \
  --ignore-working-copy
)


BASE=$(jj bookmark list \
  -r "heads((..$CHANGEID ~ $CHANGEID) & tracked_remote_bookmarks())" \
  -T 'self.name()' \
  --ignore-working-copy
)
  
[ -z "$BASE" ] && { 
cat <<-EOF
  You have hit a corner case this script does not handle:
  you currently do not have any tracked bookmarks that are
  in the requested revision's ancestors: I do not know what
  to use as a base for the pull request !

  Hint: create a main branch or such somewhere in the
  ancestry of $CHANGEID.
EOF
exit 1;
}

gh pr create -f \
  --draft \
  --head "$BOOKMARK" \
  --base "$BASE"
