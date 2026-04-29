# IsValidGame

Checks whether the provided game identifier exists in `luna_xyz_env.supported_games`. Passing `"*"` acts as a wildcard and always returns `true`.

## Signature

```lua
luna_xyz_env:IsValidGame(obj: any) → boolean
```

## Parameters

| Parameter | Type | Description |
|---|---|---|
| `obj` | `any` | A game ID (number or string) or `"*"` for wildcard matching. Must not be `nil`. |

{% hint style="warning" %}
This function will **error** if `obj` is `nil` — it asserts `"argument 1 missing or nil"`.
{% endhint %}

## Examples

```lua
-- Check if the current game is supported
if luna_xyz_env:IsValidGame(game.GameId) then
    print("Supported game!")
end

-- Wildcard — always passes
luna_xyz_env:IsValidGame("*") -- → true

-- String game ID
luna_xyz_env:IsValidGame("12345678") -- → true/false depending on supported_games
```
