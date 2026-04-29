# GetService

Safely retrieves a Roblox service by name. Returns a cloned reference via `cloneref` to avoid direct access to the underlying service object.

### Syntax

```lua
luna_xyz_env:GetService(serviceName: string) -> Instance
```

### Parameters

| Parameter     | Type     | Description                                 |
| ------------- | -------- | ------------------------------------------- |
| `serviceName` | `string` | The name of the Roblox service to retrieve. |

{% hint style="warning" %}
`serviceName` must be a `string`. Passing any other type will throw a type error.
{% endhint %}

### Special Cases

| Value                    | Behavior                                                             |
| ------------------------ | -------------------------------------------------------------------- |
| `"cache"`                | Returns the internal `luna_cache` folder instead of a Roblox service |
| Any key in `loaded_libs` | Returns the pre-loaded library from `luna_xyz_env.loaded_libs`       |

## Example

```lua
local Players    = luna_xyz_env:GetService("Players");
local RunService = luna_xyz_env:GetService("RunService");
local Tween      = luna_xyz_env:GetService("TweenService");

-- Special: returns luna_cache folder
local cache = luna_xyz_env:GetService("cache");

-- Special: returns notify library
local notify = luna_xyz_env:GetService("Notify");
```
