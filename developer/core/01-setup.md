# 准备开发环境

## 依赖

- Rust 1.85 或更高版本
- Node.js 22
- npm
- Linux 还需要 WebKitGTK 4.1、GTK 开发包和构建工具

## 获取代码

```sh
git clone https://github.com/Nota-MD/Nota.git
git clone https://github.com/Nota-MD/Nota-plugins.git
cd Nota
npm install
```

两个仓库应当并排放在同一个目录中。开发构建会自动从 `../Nota-plugins/plugins` 加载官方
拓展；也可以用 `NOTA_PLUGINS_DIR` 指向其他插件目录。

## 启动

```sh
npm run app
```

只调试前端时可以运行：

```sh
npm run dev
```

## 第一次检查

```sh
npm run typecheck
npm test
npm run build
cd src-tauri
cargo test --lib
```

如果平台依赖或 WebKitGTK 安装失败，请查阅主仓库
[`docs/06-build-run-test.md`](https://github.com/Nota-MD/Nota/blob/main/docs/06-build-run-test.md)。
