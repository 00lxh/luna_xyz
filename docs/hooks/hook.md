# Hook

Hooks a function and overrides its execution with a custom callback.

### Syntax

```lua
HookService:Hook(callback: function, hookFn: function) -> function
```

{% hint style="warning" %}
Your executor must have hookfunction.
{% endhint %}

***

### Parameters

| Parameter  | Type       | Description                               |
| ---------- | ---------- | ----------------------------------------- |
| `callback` | `function` | The original function to hook             |
| `hookFn`   | `function` | The function that will override execution |

***

### Example

```lua
local old_hook; old_hook = HookService:Hook(print, function(...)
    return warn("Hooked:", ...);
end);
```

