# FormatTime

Formats a duration in seconds into a zero-padded `DD:HH:MM:SS` string, suitable for display in UIs or debug logging.

## Signature

```lua
luna_xyz_env:FormatTime(t: number) → string
```

## Parameters

| Parameter | Type | Description |
|---|---|---|
| `t` | `number` | Duration in seconds (e.g. from `os.clock()` or a `tick()` delta). |

## Format

```
DD:HH:MM:SS
│  │  │  └─ Seconds  (00–59)
│  │  └──── Minutes  (00–59)
│  └─────── Hours    (00–23)
└────────── Days     (00+)
```

## Examples

```lua
luna_xyz_env:FormatTime(3723)
-- → "00:01:02:03"  (0 days, 1 hour, 2 minutes, 3 seconds)

luna_xyz_env:FormatTime(90061)
-- → "01:01:01:01"

luna_xyz_env:FormatTime(59)
-- → "00:00:00:59"

-- Usage in a label
local elapsed = tick() - startTime
label.Text = luna_xyz_env:FormatTime(elapsed)
```
