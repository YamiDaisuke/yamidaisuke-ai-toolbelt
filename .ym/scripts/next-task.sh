#!/bin/bash
# Prints the first To Do ticket in tasklin
# Format: #<id> <title>

TICKETS_DIR=".todo/tickets"

if [ ! -d "$TICKETS_DIR" ]; then
  echo "Error: .todo/tickets/ not found. Run 'tasklin init' first."
  exit 1
fi

for f in "$TICKETS_DIR"/*.yaml; do
  [ -f "$f" ] || continue
  if grep -q "^status: To Do" "$f"; then
    id=$(grep "^id:" "$f" | awk '{print $2}')
    title=$(grep "^title:" "$f" | sed "s/^title: //; s/^'//; s/'$//")
    echo "#$id $title"
    exit 0
  fi
done

echo "No tickets with status: To Do"
