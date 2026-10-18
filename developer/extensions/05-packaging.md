# 多文件、测试与打包

## 1. 拆分 Lua 文件

插件目录可以包含多个 Lua 模块：

```text
hello/
├── plugin.toml
├── main.lua
├── panel.lua
└── util/
    └── text.lua
```

在入口中使用：

```lua
local panel = require("panel")
local text = require("util.text")
```

模块只能相对当前插件目录加载，不能读取其他插件或绝对路径。

## 2. 测试纯函数

把计算与格式化拆成不依赖 `nota` 的模块：

```lua
-- util/text.lua
local M = {}

function M.words(text)
  return #text
end

return M
```

普通 Lua 测试可以直接 `require` 这个模块。宿主 API 相关部分再用假 `nota` 表测试。

## 3. 手动验收

每次都实际完成：

1. 启动 Nota
2. 检查拓展加载状态
3. 打开面板
4. 执行每个菜单命令
5. 检查错误路径
6. 重启 Nota
7. 确认设置和数据仍然存在

## 4. 打包

官方插件仓库提供：

```sh
python3 tools/pack-plugin.py plugins/hello
```

输出：

```text
hello-0.1.0.nota-plugin
```

开启签名：

```sh
python3 tools/pack-plugin.py --new-key ~/nota-signing-key.pem
python3 tools/pack-plugin.py plugins/hello --key ~/nota-signing-key.pem
```

私钥不能提交到仓库，也不能打包进拓展。

## 5. 发布检查

- `id`、版本与清单一致
- 所有能力都有实际用途
- 没有把 API 密钥写入源码或测试
- 包内没有无关缓存和私钥
- 从 `.nota-plugin` 实际安装成功
- 重启后可以加载、执行和卸载
- README 说明安装、能力与卸载影响
