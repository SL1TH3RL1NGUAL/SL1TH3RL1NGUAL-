
# Ritual Workflows

This file defines the LP event flows and ritual logic used to orchestrate system behavior.

## Workflow: Signal Initialization

1. Trigger signal-core/init.sh
2. Map origin to ENU grid
3. Assign trust radius
4. Register glyph nodes

## Workflow: Codex Update

1. Submit MR referencing codex/rituals.md
2. Validate symbolic integrity
3. Merge with main
4. Trigger codex-loader.sh

## Workflow: Threat Trace

1. Trigger red-eye-jinn.sh
2. Scan LP events
3. Log violations in reserve/policy/
4. Notify guild via watchdog.sh
