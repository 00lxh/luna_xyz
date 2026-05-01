# EnableConnection

Disables all active connections of a signal.

### Syntax

```lua
HookService:EnableConnection(signal: RBXScriptSignal) -> nil
```

{% hint style="warning" %}
Your executor must have getconnections.
{% endhint %}

***

### Parameters

| Parameter | Type              | Description      |
| --------- | ----------------- | ---------------- |
| `signal`  | `RBXScriptSignal` | Signal to enable |

***

### Example

```lua
HookService:EnableConnection(game.Players.PlayerAdded);
```

