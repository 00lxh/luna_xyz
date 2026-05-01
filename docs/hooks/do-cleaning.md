# DoCleaning

Restores all hooks and re-enables disabled connections.

### Syntax

```lua
HookService:DoCleaning() -> nil
```

{% hint style="info" %}
Alias HookService:Destroy().
{% endhint %}

{% hint style="warning" %}
Your executor must have **getconnections**, **hookmetamethod**, **isfunctionhooked**, **restorefunction** to restore hooks/connections.
{% endhint %}

***

### Example

```lua
HookingService:DoCleaning();
```

