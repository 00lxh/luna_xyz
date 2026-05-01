# HookRemote

Intercepts remote calls such as `FireServer` and `InvokeServer`.

### Syntax

```lua
HookService:HookRemote(object: Instance|string, callback: function?) -> function
```

{% hint style="warning" %}
Your executor must have **hookmetamethod**.
{% endhint %}

***

### Parameters

| Parameter  | Type                 | Description                                     |
| ---------- | -------------------- | ----------------------------------------------- |
| `object`   | `Instance \| string` | Target remote instance or its name              |
| `callback` | `function`           | Function to handle intercepted calls (optional) |

{% hint style="warning" %}
If you don't provide a callback the function will block all calls from that event.
{% endhint %}

***

### Example

```lua
local old_hook; old_hook = HookService:HookRemote(RemoteEvent, function(self, ...)
    
    print("Remote called:", self, ...);
    return old_hook(self, ...);
end);
```

