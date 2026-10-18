# 认识代码结构

## 两个进程边界

```text
React 前端
  ↕ Tauri IPC
Rust 宿主
  ├─ 文档存储
  ├─ 设置
  ├─ 文件监听
  ├─ Lua 插件宿主
  └─ 系统集成
```

前端不能直接读写任意文件。它通过 `src/bridge/ipc.ts` 调用 Rust 命令。

## 主要目录

| 路径 | 职责 |
|---|---|
| `src/bridge/` | 前后端 IPC 契约 |
| `src/editor/` | Milkdown、ProseMirror、源码模式和编辑行为 |
| `src/ui/` | 菜单、侧栏、编辑区、设置和对话框 |
| `src/styles/` | 界面主题、文档主题和组件样式 |
| `src-tauri/src/document/` | 文档模型、保存、标题和状态 |
| `src-tauri/src/settings/` | 设置结构与迁移 |
| `src-tauri/src/plugin/` | 插件发现、安装、加载和签名 |
| `src-tauri/src/lua/` | Lua 沙箱与 `nota.*` API |
| `src-tauri/src/commands/` | Tauri 命令入口 |

## 一次修改从哪里开始

先判断问题属于哪一层：

- 排版和编辑器交互：`src/editor/`
- 界面布局与控件：`src/ui/`、`src/styles/`
- 文件、系统调用和持久化：`src-tauri/src/`
- 插件能力：`src-tauri/src/lua/api/`

不要在前端重新实现宿主已有的路径、权限或文件逻辑。
