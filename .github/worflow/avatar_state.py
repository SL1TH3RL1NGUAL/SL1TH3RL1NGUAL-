#!/usr/bin/env python3
"""
avatar_state.py

State engine for SL1TH3RL1NGUAL / BlackCorp.me avatars.

Handles:
    - avatar creation
    - state updates
    - energy/temperature decay
    - operational status evaluation
    - JSON persistence to state/avatars/*.json
"""

import os
import json
import time
from datetime import datetime

# ------------------------------------------------------------
# PATHS
# ------------------------------------------------------------

PROJECT_ROOT = os.path.dirname(os.path.dirname(__file__))
AVATAR_DIR = os.path.join(PROJECT_ROOT, "state", "avatars")

os.makedirs(AVATAR_DIR, exist_ok=True)

# ------------------------------------------------------------
# DEFAULTS
# ------------------------------------------------------------

DEFAULT_AVATAR = {
    "agent_id": "unknown",
    "shape": "sphere",
    "energy": 100.0,
    "temperature": 37.0,
    "status": "OPERATIONAL",
    "topology": {
        "domain": "unassigned"
    },
    "circuit_id": "none",
    "last_update": None
}

# ------------------------------------------------------------
# HELPERS
# ------------------------------------------------------------

def now_ts():
    """Return ISO timestamp."""
    return datetime.utcnow().isoformat() + "Z"


def avatar_path(agent_id: str) -> str:
    """Return full path to avatar JSON file."""
    return os.path.join(AVATAR_DIR, f"{agent_id}.json")


# ------------------------------------------------------------
# CORE FUNCTIONS
# ------------------------------------------------------------

def load_avatar(agent_id: str) -> dict:
    """Load avatar JSON or create a default one."""
    path = avatar_path(agent_id)

    if not os.path.exists(path):
        avatar = DEFAULT_AVATAR.copy()
        avatar["agent_id"] = agent_id
        avatar["last_update"] = now_ts()
        save_avatar(avatar)
        return avatar

    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        # Corrupted file → reset
        avatar = DEFAULT_AVATAR.copy()
        avatar["agent_id"] = agent_id
        avatar["last_update"] = now_ts()
        save_avatar(avatar)
        return avatar


def save_avatar(avatar: dict):
    """Persist avatar JSON."""
    path = avatar_path(avatar["agent_id"])
    with open(path, "w", encoding="utf-8") as f:
        json.dump(avatar, f, indent=4)


# ------------------------------------------------------------
# STATE LOGIC
# ------------------------------------------------------------

def evaluate_status(energy: float, temperature: float) -> str:
    """Determine operational status."""
    if energy > 60 and 30 <= temperature <= 45:
        return "OPERATIONAL"
    if energy > 20:
        return "DEGRADED"
    if energy <= 20:
        return "DORMANT"
    return "UNKNOWN"


def decay(avatar: dict, dt: float):
    """Apply natural decay over time."""
    avatar["energy"] = max(0.0, avatar["energy"] - (0.02 * dt))
    avatar["temperature"] = max(0.0, avatar["temperature"] - (0.005 * dt))


def update_avatar(agent_id: str, **updates):
    """
    Update avatar fields and persist.

    Example:
        update_avatar("alpha01", energy=88, topology={"domain": "north"})
    """
    avatar = load_avatar(agent_id)

    # Apply updates
    for key, value in updates.items():
        if key == "topology" and isinstance(value, dict):
            avatar["topology"].update(value)
        else:
            avatar[key] = value

    # Evaluate status
    avatar["status"] = evaluate_status(
        avatar.get("energy", 0),
        avatar.get("temperature", 0)
    )

    avatar["last_update"] = now_ts()
    save_avatar(avatar)
    return avatar


def tick(agent_id: str):
    """
    Time‑based update.
    Applies decay and recalculates status.
    """
    avatar = load_avatar(agent_id)

    # Compute time delta
    last = avatar.get("last_update")
    if last:
        try:
            last_t = datetime.fromisoformat(last.replace("Z", ""))
            dt = (datetime.utcnow() - last_t).total_seconds()
        except Exception:
            dt = 1.0
    else:
        dt = 1.0

    # Apply decay
    decay(avatar, dt)

    # Recalculate status
    avatar["status"] = evaluate_status(
        avatar["energy"],
        avatar["temperature"]
    )

    avatar["last_update"] = now_ts()
    save_avatar(avatar)
    return avatar


# ------------------------------------------------------------
# CLI USAGE
# ------------------------------------------------------------

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Avatar State Engine")
    parser.add_argument("agent_id", help="Avatar ID")
    parser.add_argument("--tick", action="store_true", help="Apply decay tick")
    parser.add_argument("--set", nargs=2, action="append",
                        help="Set field: --set energy 90")

    args = parser.parse_args()

    if args.tick:
        avatar = tick(args.agent_id)
    elif args.set:
        updates = {}
        for key, val in args.set:
            try:
                val = float(val)
            except Exception:
                pass
            updates[key] = val
        avatar = update_avatar(args.agent_id, **updates)
    else:
        avatar = load_avatar(args.agent_id)

    print(json.dumps(avatar, indent=4))
