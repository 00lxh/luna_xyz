# GetServices

Convenience wrapper that calls [`GetService`](get-service.md) for each name in the provided array. Useful for bulk pre-loading services at the top of your script.

## Signature

```lua
luna_xyz_env:GetServices(serviceNames: table) → void
```

## Parameters

| Parameter | Type | Description |
|---|---|---|
| `serviceNames` | `table` | An ordered array of service name strings. |

{% hint style="info" %}
This function does not return anything. Each service is loaded internally via `GetService`.
{% endhint %}

## Examples

```lua
luna_xyz_env:GetServices({
    "Players",
    "RunService",
    "TweenService",
    "UserInputService",
})
```
