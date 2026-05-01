# Overview

The HookingService provides utilities for intercepting, modifying, and controlling function calls, metamethods, and signal connections within the **luna.xyz runtime**.

***

These functions allow you to:

* Manage cleanup tasks in a centralized structure
* Automatically clean functions, connections, and objects
* Handle nested Maids for complex state management
* Safely clean asynchronous operations like promises
* Prevent memory leaks and leftover connections

The service can be accessed in two different ways, each affecting lifecycle management:

* Using `luna_xyz_env.Maid` will automatically clean up all connections and tasks when the UI or environment is destroyed
* Using `luna_xyz_env:GetService("Maid")` requires manual cleanup, meaning you must call `DoCleaning()` or `Destroy()` to properly remove all connections and tasks

This distinction is important to avoid memory leaks and lingering connections after your system is unloaded.

***

### Available Functions

<table><thead><tr><th>Function</th><th>Description</th><th data-hidden>Returns</th></tr></thead><tbody><tr><td><a href="new.md"><code>new</code></a></td><td>Creates a new Maid instance</td><td><code>boolean</code></td></tr><tr><td><a href="is-maid.md"><code>isMaid</code></a></td><td>Checks if a value is a Maid</td><td><code>boolean</code></td></tr><tr><td><a href="give-task.md"><code>GiveTask</code></a></td><td>Adds a task to the Maid</td><td><code>Instance</code></td></tr><tr><td><a href="give-promise.md"><code>GivePromise</code></a></td><td>Adds a promise for cleanup</td><td><code>Vector2</code></td></tr><tr><td><a href="do-cleaning.md"><code>DoCleaning</code></a></td><td>Cleans all tasks</td><td><code>Ray</code></td></tr></tbody></table>

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env.Maid;
```

