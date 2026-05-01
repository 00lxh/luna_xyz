# Cache

The Cache service provides a secure way to store and manage instances within the **luna.xyz runtime**, keeping them isolated from the main game environment unless explicitly exposed.

### Syntax

```lua
luna_xyz_env:GetService("cache") -> Instance
```

***

### Overview

The Cache system allows you to:

* Store instances in a protected container outside of the main workspace
* Prevent direct access to cached instances from the game world
* Safely manage temporary or sensitive objects
* Control when and how instances become visible or interactable

***

### Behavior

Instances stored in the cache are **not accessible from the Workspace** by default.\
They remain isolated in a secure folder managed by the runtime.

To make a cached instance accessible or visible in-game, you must explicitly set its `Parent` to an object inside the `Workspace`.

***

## Example

```lua
local part = Instance.new("Part");

-- Store in cache (not visible or accessible in Workspace)
part.Parent = cache;

-- Make it visible in the game
part.Parent = workspace;
```
