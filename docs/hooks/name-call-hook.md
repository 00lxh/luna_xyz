# NameCallHook

Hooks a specific namecall method on an object.

### Syntax

```lua
HookService:NameCallHook(object: Instance|string, method: string, callback: function?) -> function
```

{% hint style="warning" %}
Your executor must have hookmetamethod.
{% endhint %}

***

### Parameters

| Parameter  | Type                 | Description                  |
| ---------- | -------------------- | ---------------------------- |
| `object`   | `Instance \| string` | Target object                |
| `method`   | `string`             | Namecall method to intercept |
| `callback` | `function`           | Hook function (optional)     |

{% hint style="warning" %}
If you don't provide a callback the function will block all calls from that method.
{% endhint %}

***

### Example

```lua
local old_hook; old_hook = HookService:NameCallHook(game, "GetService", function(self, ...)
    
    print("Namecall called:", self, ...);
    return true;
end);

local players = game:GetService("Players");
```

