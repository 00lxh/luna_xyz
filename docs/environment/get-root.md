# GetRoot

Returns the primary movement part of a player's character. Searches in priority order and returns the first part found.

## Signature

```lua
luna_xyz_env:GetRoot(player: Player) → BasePart?
```

## Parameters

| Parameter | Type | Description |
|---|---|---|
| `player` | `Player` | The target `Player` instance. |

## Priority Order

| Priority | Part | Rig |
|---|---|---|
| 1st | `HumanoidRootPart` | R6 and R15 (standard) |
| 2nd | `UpperTorso` | R15 fallback |
| 3rd | `Torso` | R6 fallback |

{% hint style="info" %}
Returns `nil` if none of the three parts are found (e.g. custom rigs). Always nil-check the result.
{% endhint %}

## Examples

```lua
local root = luna_xyz_env:GetRoot(game.Players.LocalPlayer)

if root then
    print("Position:", root.Position)
    print("CFrame:", root.CFrame)
end

-- Teleport example
local root = luna_xyz_env:GetRoot(player)
if root then
    root.CFrame = CFrame.new(0, 50, 0)
end
```
