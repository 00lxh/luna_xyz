# ToggleLogs





Enables or disables file logging.

### Syntax

```lua
Logger:SetSaveLocation(path: string?) -> nil
```

{% hint style="warning" %}
Your executor must have **File System** Support.
{% endhint %}

***

### Parameters

| Parameter | Type      | Description                           |
| --------- | --------- | ------------------------------------- |
| `value`   | `boolean` | Whether logs should be saved to files |

***

### Example

```lua
Logger:ToggleLogs(true);
```



