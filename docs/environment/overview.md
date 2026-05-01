# Overview

The Environment module provides core utility functions for the **luna.xyz runtime**, covering essential systems such as input handling, game validation, character resolution, and time formatting.

***

These functions allow you to:

* Handle and process user input within the runtime
* Validate game state and execution context
* Resolve player characters and related instances
* Format and manage time-based data
* Access common environment utilities used across the framework

***

### Available Functions

| Function                                    | Description                                               | Returns    |
| ------------------------------------------- | --------------------------------------------------------- | ---------- |
| [`ParseBoolean`](parse-boolean.md)          | Converts any raw value to a boolean with optional default | `boolean`  |
| [`IsValidGame`](is-valid-game.md)           | Checks if a game ID is in the supported games list        | `boolean`  |
| [`GetService`](get-service.md)              | Returns a save Roblox service or a loaded library         | `Instance` |
| [`GetMousePosition`](get-mouse-position.md) | Returns screen-space mouse position (center on touch)     | `Vector2`  |
| [`GetMouseLocation`](get-mouse-location.md) | Returns world-space ray from current mouse location       | `Ray`      |
| [`IsString`](is-string.md)                  | Returns true if the value is a non-empty string           | `boolean`  |
| [`IsNumber`](is-number.md)                  | Returns true if the value is a valid (non-NaN) number     | `boolean`  |
| [`FormatTime`](format-time.md)              | Formats seconds into `DD:HH:MM:SS`                        | `string`   |
| [`GetCharacter`](get-character.md)          | Returns the character model, yielding if not yet loaded   | `Model`    |
| [`GetRoot`](get-root.md)                    | Returns HumanoidRootPart or a torso fallback              | `BasePart` |

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env:FunctionName(args);
```
