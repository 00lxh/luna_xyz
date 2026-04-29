# Environment

The **Environment** module provides core utility functions for the Luna XYZ runtime, covering everything from input handling and game validation to character resolution and time formatting.

## Available Functions

| Function | Returns | Description |
|---|---|---|
| [`ParseBoolean`](parse-boolean.md) | `boolean` | Converts any raw value to a boolean with optional default |
| [`IsValidGame`](is-valid-game.md) | `boolean` | Checks if a game ID is in the supported games list |
| [`GetService`](get-service.md) | `Instance` | Returns a cloned Roblox service or a loaded library |
| [`GetServices`](get-services.md) | `void` | Bulk-loads a list of services |
| [`GetMousePosition`](get-mouse-position.md) | `Vector2` | Returns screen-space mouse position (center on touch) |
| [`GetMouseLocation`](get-mouse-location.md) | `Ray` | Returns world-space ray from current mouse location |
| [`IsString`](is-string.md) | `boolean` | Returns true if the value is a non-empty string |
| [`IsNumber`](is-number.md) | `boolean` | Returns true if the value is a valid (non-NaN) number |
| [`FormatTime`](format-time.md) | `string` | Formats seconds into `DD:HH:MM:SS` |
| [`GetCharacter`](get-character.md) | `Model` | Returns the character model, yielding if not yet loaded |
| [`GetRoot`](get-root.md) | `BasePart` | Returns HumanoidRootPart or a torso fallback |

## Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env:FunctionName(args)
```
