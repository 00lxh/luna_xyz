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

<table><thead><tr><th>Function</th><th>Description</th><th data-hidden>Returns</th></tr></thead><tbody><tr><td><a href="parse-boolean.md"><code>ParseBoolean</code></a></td><td>Converts any raw value to a boolean with optional default</td><td><code>boolean</code></td></tr><tr><td><a href="is-valid-game.md"><code>IsValidGame</code></a></td><td>Checks if a game ID is in the supported games list</td><td><code>boolean</code></td></tr><tr><td><a href="get-service.md"><code>GetService</code></a></td><td>Returns a save Roblox service or a loaded library</td><td><code>Instance</code></td></tr><tr><td><a href="get-mouse-position.md"><code>GetMousePosition</code></a></td><td>Returns screen-space mouse position (center on touch)</td><td><code>Vector2</code></td></tr><tr><td><a href="get-mouse-location.md"><code>GetMouseLocation</code></a></td><td>Returns world-space ray from current mouse location</td><td><code>Ray</code></td></tr><tr><td><a href="is-string.md"><code>IsString</code></a></td><td>Returns true if the value is a non-empty string</td><td><code>boolean</code></td></tr><tr><td><a href="is-number.md"><code>IsNumber</code></a></td><td>Returns true if the value is a valid (non-NaN) number</td><td><code>boolean</code></td></tr><tr><td><a href="format-time.md"><code>FormatTime</code></a></td><td>Formats seconds into <code>DD:HH:MM:SS</code></td><td><code>string</code></td></tr><tr><td><a href="get-character.md"><code>GetCharacter</code></a></td><td>Returns the character model, yielding if not yet loaded</td><td><code>Model</code></td></tr><tr><td><a href="get-root.md"><code>GetRoot</code></a></td><td>Returns HumanoidRootPart or a torso fallback</td><td><code>BasePart</code></td></tr></tbody></table>

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env:FunctionName(args)
```
