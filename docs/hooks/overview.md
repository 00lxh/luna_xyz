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

<table><thead><tr><th>Function</th><th>Description</th><th data-hidden>Returns</th></tr></thead><tbody><tr><td><a href="hook.md"><code>Hook</code></a></td><td>Hooks a function and overrides its behavior</td><td><code>boolean</code></td></tr><tr><td><a href="hook-remote.md"><code>HookRemote</code></a></td><td>Intercepts remote calls (<code>FireServer</code>, <code>InvokeServer</code>)</td><td><code>boolean</code></td></tr><tr><td><a href="name-call-hook.md"><code>NameCallHook</code></a></td><td>Hooks a specific namecall method on an object</td><td><code>Instance</code></td></tr><tr><td><a href="index-hook.md"><code>IndexHook</code></a></td><td>Overrides property access and assignment</td><td><code>Vector2</code></td></tr><tr><td><a href="disable-connection.md"><code>DisableConnection</code></a></td><td>Disables all connections of a signal</td><td><code>Ray</code></td></tr><tr><td><a href="enable-connection.md"><code>EnableConnection</code></a></td><td>Re-enables connections of a signal</td><td><code>boolean</code></td></tr><tr><td><a href="do-cleaning.md"><code>DoCleaning</code></a></td><td>Restores all hooks and cleans state</td><td></td></tr></tbody></table>

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env.HookService:FunctionName(args);
```
