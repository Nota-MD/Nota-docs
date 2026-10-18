# 第一个 Hello World

## 1. 创建目录

在 Nota 用户插件目录中创建：

```text
hello/
├── plugin.toml
└── main.lua
```

Linux 默认目录是：

```text
~/.local/share/nota/plugins/
```

## 2. 编写清单

`plugin.toml`：

```toml
[plugin]
id = "example.hello"
name = "Hello Nota"
version = "0.1.0"
api = 2
description = "A minimal Nota extension."
license = "BSD-2-Clause"
authors = ["Your Name"]
entry = "main.lua"

capabilities = []
```

字段含义：

| 字段 | 作用 |
|---|---|
| `id` | 拓展唯一标识，安装、设置和数据目录都使用它 |
| `api` | 宿主 API 版本；当前为 `2` |
| `entry` | 入口 Lua 文件 |
| `capabilities` | 明确申请的能力 |

## 3. 编写入口

`main.lua`：

```lua
local M = {}

function M.on_load(nota)
  nota.log.info("Hello from Nota")
end

return M
```

拓展不能访问全局 `nota`。宿主在 `on_load` 时把当前拓展专属的 API 表传进来，所以应当把它
保存在模块里：

```lua
local M = {}
local nota_api

function M.on_load(nota)
  nota_api = nota
end
```

## 4. 加载拓展

重新启动 Nota。日志默认不显示；开发时可以设置：

```sh
NOTA_DEBUG=1 npm run app
```

如果拓展加载失败，**设置 → 拓展** 会显示原因。

## 5. 常见错误

### `api` 不匹配

当前宿主只接受 `api = 2`。

### `entry` 指向不存在

入口必须位于插件目录内，不能包含 `..` 或绝对路径。

### 顶层直接使用 `nota`

`nota` 只在 `on_load(nota)` 中存在。模块顶层执行时还没有这张 API 表。
