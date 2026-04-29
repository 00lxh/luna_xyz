# Luna XYZ Docs

Welcome to the **Luna XYZ** documentation. This library provides a set of core environment utilities used throughout the Luna XYZ runtime.

## What is luna\_xyz\_env?

`luna_xyz_env` is the main environment table that exposes utility functions for:

- Parsing and validating values
- Retrieving Roblox services safely
- Handling mouse input across desktop and touch devices
- Character and root part resolution
- Time formatting and type checking

## Quick Start

All methods are called using **colon syntax** on the `luna_xyz_env` table:

```lua
local Players = luna_xyz_env:GetService("Players")
local root = luna_xyz_env:GetRoot(game.Players.LocalPlayer)
local time = luna_xyz_env:FormatTime(3723) -- "00:01:02:03"
```

## Internals

The module sets up these globals at load time:

| Variable | Type | Purpose |
|---|---|---|
| `CurrentCamera` | `Camera` | Cached reference to `workspace.CurrentCamera` |
| `floor` | `function` | Local alias for `math.floor` |
| `cloneref` | `function` | Clones an instance reference safely |
| `luna_cache` | `Folder` | Persistent cache folder under `gethui()` |

---

Navigate the sections on the left to explore each function in detail.
