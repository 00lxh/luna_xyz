# GetMousePosition

Returns the current screen-space mouse position as a `Vector2`, adjusted by the GUI inset. On touch devices, returns the center of the viewport instead of a real cursor position.

### Syntax

```lua
luna_xyz_env:GetMousePosition() -> Vector2
```

***

### Behavior

| Device      | Behavior                                                                       |
| ----------- | ------------------------------------------------------------------------------ |
| **Desktop** | Returns `UserInputService:GetMouseLocation()` minus `GuiService:GetGuiInset()` |
| **Touch**   | Returns `Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)`                  |

{% hint style="info" %}
On touch devices there is no persistent cursor, so the screen center is used as a sensible fallback.
{% endhint %}

***

### Example

```lua
local pos = luna_xyz_env:GetMousePosition();
print(pos.X, pos.Y);

-- Use in a raycast
local unitRay = workspace.CurrentCamera:ScreenPointToRay(pos.X, pos.Y);
```
