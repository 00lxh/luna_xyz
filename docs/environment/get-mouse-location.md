# GetMouseLocation

Converts the result of [`GetMousePosition`](get-mouse-position.md) into a world-space `Ray` using the current camera. Handles both desktop and touch devices automatically.

### Syntax

```lua
luna_xyz_env:GetMouseLocation() -> Ray
```

### Behavior

| Device      | Method Used                       |
| ----------- | --------------------------------- |
| **Touch**   | `Camera:ViewportPointToRay(x, y)` |
| **Desktop** | `Camera:ScreenPointToRay(x, y)`   |

### Example

```lua
local ray = luna_xyz_env:GetMouseLocation();
print("Origin:", ray.Origin);
print("Direction:", ray.Direction);

-- Use with raycasting
local result = workspace:Raycast(ray.Origin, ray.Direction * 500);
if result then
    print("Hit:", result.Instance.Name);
end;
```
