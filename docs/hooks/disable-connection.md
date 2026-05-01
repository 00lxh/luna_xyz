# DisableConnection

Disables all active connections of a signal.

### Syntax

```lua
HookService:DisableConnection(signal: RBXScriptSignal) -> nil
```

{% hint style="warning" %}
Your executor must have getconnections.
{% endhint %}

***

### Parameters

| Parameter | Type              | Description       |
| --------- | ----------------- | ----------------- |
| `signal`  | `RBXScriptSignal` | Signal to disable |

***

### Example

```lua
HookService:DisableConnection(game.Players.PlayerAdded);
```

