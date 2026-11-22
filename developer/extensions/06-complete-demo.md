# 完整拓展示例：Field Notes

这一章不再把功能拆成互不相干的代码片段。它给出一个可以复制、加载、测试和打包的完整拓展：

[`field-notes/`](field-notes/README.md)

示例遵循 Nota 0.17.0 Beta 的扩展 API **v2.4**。把它与官方插件
[`Nota-plugins`](https://github.com/Nota-MD/Nota-plugins) 一起阅读，比只看 API 清单更容易形成完整手感。

## 1. 这个拓展做什么

Field Notes 有四个界面入口和一个数据文件：

- 右侧面板显示当前文档标题、字词数、字符数、行数和修订号；
- **Capture snapshot** 把轻量元数据保存到插件自己的数据目录；
- **Insert summary at cursor** 通过编辑器事务插入一段 Markdown 摘要；
- 菜单项是同一组命令的第二个入口；
- 设置页控制历史条数、是否显示路径和插入标题。

它刻意不请求 `network.http`、`fs.read`、`fs.write` 或 `process.*`。完整 demo 不表示应该申请所有能力。

## 2. 文件结构

```text
field-notes/
├── plugin.toml
├── main.lua
├── inspect.lua
├── lang/
│   └── zh-CN.toml
├── tests/
│   └── inspect_test.lua
└── README.md
```

`main.lua` 只处理宿主 API、生命周期和界面组装。`inspect.lua` 是不依赖 `nota` 的纯函数模块，可以在普通 Lua 中测试。

多文件加载只允许当前拓展目录内的相对模块：

```lua
local inspect = require("inspect")
```

绝对路径、`..`、逃出目录的符号链接和 `.so` 都会被宿主拒绝。子模块不要尝试反向 `require("main")`，那会形成循环依赖。

## 3. 清单

完整清单见 [`plugin.toml`](field-notes/plugin.toml)。关键部分：

```toml
[plugin]
id = "nota.example.field-notes"
version = "1.0.0"
api = "v2.4"
entry = "main.lua"
langs = ["en", "zh-CN"]

capabilities = [
  "document.read",
  "document.write",
  "ui.notify",
  "ui.panel",
  "ui.menu",
  "settings.own",
  "data.own",
]
```

三个版本号不是一回事：

| 字段 | 含义 |
|---|---|
| `version = "1.0.0"` | 这个拓展自己的版本 |
| `api = "v2.4"` | 它要求宿主提供的扩展 API |
| `nota.version` | 运行时宿主应用版本 |

宿主接受同一大版本内不高于自身的小版本。要求 `v2.5` 的拓展会在 `v2.4` 宿主上被拒绝；按旧版本写的拓展不会因为宿主升级到 `v2.4` 失效。

## 4. 能力按用途申请

| 能力 | 用途 |
|---|---|
| `document.read` | 标题、路径、脏状态和统计 |
| `document.write` | 在光标处插入摘要 |
| `ui.notify` | 成功或失败反馈 |
| `ui.panel` | 右侧面板、刷新和在编辑区放大 |
| `ui.menu` | 把命令放进“拓展”菜单 |
| `settings.own` | 保存三个用户设置 |
| `data.own` | 保存快照历史 |

没有申请 `document.write` 时，`nota.document.set_text`、`append_text` 和 `insert_at_cursor` 都不存在。没有申请 `data.own` 时，整张 `nota.data` 表不存在。

## 5. 生命周期

入口必须返回一张模块表：

```lua
local M = {}

function M.on_load(nota)
  -- register commands first, then menus that point to them
end

function M.on_unload() end

return M
```

`on_load(nota)` 是唯一拿到当前拓展专属 API 表的时机。不要在模块顶层引用全局 `nota`。

`on_unload` 必须允许同一拓展再次加载。停用会真正卸载 Lua 状态；不要留下依赖旧闭包才能清理的外部资源。

## 6. 命令先于菜单

命令名只在本拓展内唯一。菜单项保存的是命令名，不是 Lua 函数地址：

```lua
nota.command.register("capture", function()
  return capture(nota)
end)

nota.ui.register_menu({
  label = T("Capture snapshot"),
  command = "capture",
  menu = "plugins",
})
```

如果先注册菜单、再注册命令，加载本身可能成功，但点击时才会发现目标不存在。完整示例故意把所有命令放在菜单之前。

## 7. 面板是拉取，不是定时推内容

`render` 每次被请求时执行：

```lua
nota.ui.register_panel({
  id = "field-notes",
  title = T("Field Notes"),
  render = function()
    return panel_content()
  end,
})
```

面板内容由宿主 DSL 绘制，插件只返回声明数据。本示例使用：

- `hero`
- `fields`
- `buttons`
- `separator`
- `heading`
- `list`
- `empty`

没有 `HTML` 字符串，也没有 `dangerouslySetInnerHTML` 一类入口。插件给内容，宿主决定视觉。

面板加 `live = true` 后宿主会每秒重新拉取一次，但不要把它当计时器，也不要在 `render` 中做网络请求或启动子进程。这个示例按需刷新：

```lua
nota.ui.refresh("field-notes")
```

## 8. 文档写入选择正确的事务

这个示例使用：

```lua
nota.document.insert_at_cursor(markdown)
```

它把“插入一段文本”的意图交给当前编辑器，由 ProseMirror 落一笔真实事务，因此撤销、光标和滚动位置都能保留。

不要用 `set_text(full_text)` 实现“在光标处插入”。那会整篇替换文档并打断撤销栈。也不要由插件猜 Markdown 字符偏移；块边界会使偏移和编辑器位置不是同一套坐标。

返回值要检查：

```lua
local ok, inserted = pcall(nota.document.insert_at_cursor, text)
if not ok or inserted ~= true then
  -- show an error
end
```

## 9. 设置

宿主在 **设置 → 拓展** 里自绘这三格：

```toml
[[settings]]
key = "history_limit"
kind = "range"
min = 3
max = 30
default = 8
step = 1

[[settings]]
key = "include_path"
kind = "toggle"
default_on = false

[[settings]]
key = "note_label"
kind = "text"
default_text = "Field note"
```

插件读取时仍要自己夹紧和验证，因为设置文件可能被用户手工修改：

```lua
local limit = inspect.clamp_int(
  nota.settings.get("history_limit"),
  8,
  3,
  30
)
```

设置文件按拓展 id 隔离，值是文本、数字或布尔值。设置不是数据库；需要多条记录时使用 `nota.data`。

## 10. 插件自己的数据

历史记录写入：

```lua
nota.data.read("history.txt")
nota.data.write("history.txt", text)
nota.data.remove("history.txt")
```

示例使用一行一条、制表符分隔的文本格式。写入前会清掉标题和路径里的换行、制表符与 `|`，避免破坏记录边界。数据文件有 1 MiB 上限，因此一个“历史摘要”不应该变成第二个文档仓库。

插件数据目录的删除只影响这个拓展的记忆；Markdown 文档本身不受影响。

## 11. 国际化

源码字符串是英语，中文译文放在 `lang/zh-CN.toml`：

```toml
"Capture snapshot" = "保存快照"
"Snapshot saved." = "快照已保存。"
```

语言文件使用“源码原文就是键”的规则。修改英文原文等于修改键；旧译文会安全退回英文，但会留下失效翻译。发布前运行文档仓库或插件仓库的 i18n 检查。

## 12. 错误处理

环境失败与作者错误要分开：

- 数据文件还不存在：`nota.data.read` 返回 `nil`，是正常状态；
- 文档为空：命令返回 `{ ok = false, reason = "empty-document" }`，同时给出通知；
- 编辑器拒绝插入：把拒绝转成用户可读的通知；
- 设置值被手改成非法值：回落到默认并夹进范围。

`pcall` 用在宿主边界。纯函数模块直接返回可测试的值，不要用 `pcall` 掩盖计算错误。

## 13. 测试

纯函数测试不启动 Nota：

```sh
cd field-notes
lua tests/inspect_test.lua
```

测试覆盖：

- 分隔符清理；
- 历史追加与上限；
- 旧记录淘汰顺序；
- 记录解析；
- 未命名文档与可选路径字段。

宿主 API 还需要人工验收：

1. 复制目录到用户插件目录并重启；
2. 确认插件加载状态和中文名称；
3. 在空文档执行 Capture snapshot；
4. 在普通文档保存三次快照；
5. 修改 `history_limit` 后再保存；
6. 使用 Insert summary at cursor，按一次 Ctrl+Z 检查撤销；
7. 关闭再打开面板，确认数据仍存在；
8. 停用再启用拓展，确认没有重复命令或重复面板错误；
9. 删除 `history.txt` 后确认插件回到空历史而不是加载失败。

## 14. 打包与发布

从 `Nota-plugins` 仓库运行：

```sh
python3 tools/pack-plugin.py /path/to/field-notes
```

输出文件名来自清单：

```text
nota.example.field-notes-1.0.0.nota-plugin
```

发布前确认：

- `version` 已增加；
- `api = "v2.4"` 与目标宿主一致；
- 包内没有测试数据、私钥、缓存或用户文档；
- 从 `.nota-plugin` 实际安装、重启、停用和卸载；
- README 写清能力、数据位置与卸载影响。

## 15. 继续扩展

在保持当前结构的前提下，可以这样加功能：

- 把快照记录拆成 `history.lua` 纯模块；
- 增加“比较两次修订”命令，使用 `nota.diff`；
- 需要工作区文件时再申请 `fs.read`，不要用 `data.own` 假装文件系统；
- 需要表格能力时按 API v2.4 的 `table.*` 能力逐项申请；
- 需要网络时单独申请 `network.http`，并明确主机和失败方式。

完整示例的价值不在“功能越多越好”，而在于每一层为什么存在、权限边界在哪里、失败时用户看到什么、作者如何验证。
