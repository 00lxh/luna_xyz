# Overview

The Logger system provides a structured and customizable way to create, manage, and display logs within the **luna.xyz runtime**, including console output, file saving, and rich DevConsole visualization.

***

These functions allow you to:

* Create categorized logs (event, warn, error, success, etc.)
* Display logs with icons and colors in the DevConsole
* Optionally print logs to the console
* Save logs to files for persistence
* Create dynamic loading/progress logs
* Customize logging behavior (icons, saving, console output)

The Logger is globally accessible via `Logger` and automatically integrates with the DevConsole UI.

***

### Available Functions

<table><thead><tr><th>Function</th><th>Description</th><th data-hidden>Returns</th></tr></thead><tbody><tr><td><a href="../maid/new.md"><code>new</code></a></td><td>Creates a new Maid instance</td><td><code>boolean</code></td></tr><tr><td><a href="../maid/is-maid.md"><code>isMaid</code></a></td><td>Checks if a value is a Maid</td><td><code>boolean</code></td></tr><tr><td><a href="../maid/give-task.md"><code>GiveTask</code></a></td><td>Adds a task to the Maid</td><td><code>Instance</code></td></tr><tr><td><a href="../maid/give-promise.md"><code>GivePromise</code></a></td><td>Adds a promise for cleanup</td><td><code>Vector2</code></td></tr><tr><td><a href="../maid/do-cleaning.md"><code>DoCleaning</code></a></td><td>Cleans all tasks</td><td><code>Ray</code></td></tr></tbody></table>

***

### Usage

All functions are called with colon syntax on `luna_xyz_env`:

```lua
luna_xyz_env.Maid;
```



