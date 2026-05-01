# SetSaveLocation





Sets the directory for log files.

### Syntax

```lua
Logger:SetSaveLocation(path: string?) -> nil
```

{% hint style="warning" %}
Your executor must have **File System** Support.
{% endhint %}

***

### Parameters

| Parameter | Type      | Description                                                 |
| --------- | --------- | ----------------------------------------------------------- |
| `path`    | `string?` | Directory path for saving logs (nil to disable custom path) |

***

### Example

```lua
Logger:SetSaveLocation("logs/");
```



