# Overview

The HookingService provides utilities for intercepting, modifying, and controlling function calls, metamethods, and signal connections within the **luna.xyz runtime**.

***

These functions allow you to:

* Hook and override existing functions
* Intercept remote calls such as `FireServer` and `InvokeServer`
* Hook specific namecall methods dynamically
* Modify or override object properties using metamethod hooks
* Enable or disable signal connections
* Restore all hooks and clean up modified behavior

The service can be accessed in two different ways, each affecting lifecycle management:

* Using `luna_xyz_env.HookService` will automatically clean up all hooks when the UI or environment is destroyed
* Using `luna_xyz_env:GetService("HookService")` requires manual cleanup, meaning you must call `DoCleaning()` or `Destroy()` to properly restore all hooks

This distinction is important to prevent leftover hooks and unintended behavior after your system is unloaded.

***

### Available Functions

| Function                                     | Description                                            | Returns              |
| -------------------------------------------- | ------------------------------------------------------ | -------------------- |
| [`Hook`](hook.md)                            | Hooks a function and overrides its behavior            | `function`           |
| [`HookRemote`](hook-remote.md)               | Intercepts remote calls (`FireServer`, `InvokeServer`) | `function`           |
| [`NameCallHook`](name-call-hook.md)          | Hooks a specific namecall method on an object          | `function`           |
| [`IndexHook`](index-hook.md)                 | Overrides property access and assignment               | `function, function` |
| [`DisableConnection`](disable-connection.md) | Disables all connections of a signal                   | `nil`                |
| [`EnableConnection`](enable-connection.md)   | Re-enables connections of a signal                     | `nil`                |
| [`DoCleaning`](do-cleaning.md)               | Restores all hooks and cleans state                    | `nil`                |

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env.HookService:FunctionName(args);
```
