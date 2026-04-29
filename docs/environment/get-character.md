# GetCharacter

Returns the character `Model` for a given player. If the character is not yet available, the function **yields** until `CharacterAdded` fires.

### Syntax

```lua
luna_xyz_env:GetCharacter(player: Player) -> Model
```

### Parameters

| Parameter | Type     | Description                                        |
| --------- | -------- | -------------------------------------------------- |
| `player`  | `Player` | The `Player` instance whose character to retrieve. |

{% hint style="warning" %}
**This function may yield.** If the character has not spawned yet, the current thread will pause until it does. Avoid calling this in non-async contexts.
{% endhint %}

### Example

```lua
local char = luna_xyz_env:GetCharacter(game.Players.LocalPlayer);
print(char.Name); -- e.g. "YourUsername"

-- Works safely even before character loads
task.spawn(function()
    local char = luna_xyz_env:GetCharacter(player);
    -- char is guaranteed to exist here
end);
```
