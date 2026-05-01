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

| Function                         | Description                 | Returns   |
| -------------------------------- | --------------------------- | --------- |
| [`new`](new.md)                  | Creates a new Maid instance | `maid`    |
| [`isMaid`](is-maid.md)           | Checks if a value is a Maid | `boolean` |
| [`GiveTask`](give-task.md)       | Adds a task to the Maid     | `number`  |
| [`GivePromise`](give-promise.md) | Adds a promise for cleanup  | `Promise` |
| [`DoCleaning`](do-cleaning.md)   | Cleans all tasks            | `nil`     |

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env.Maid;
```

