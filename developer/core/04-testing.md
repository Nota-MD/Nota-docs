# 测试与文档

## 最低检查

```sh
bash tools/check-version.sh
npm run typecheck
bash tools/test-frontend.sh
bash tools/i18n-check.sh
bash tools/doc-sync-check.sh
npm run build
cd src-tauri && cargo test --lib
```

## 界面改动

单元测试通过不代表界面可用。需要真实打开窗口并完成：

1. 主路径操作
2. 取消或错误路径
3. 键盘操作
4. 浅色与深色
5. 至少一种非默认界面主题

截图中应包含能证明结果的界面状态，而不只是一张“窗口能打开”的图。

## 文档同步

修改代码前查看 `docs/09-doc-sync-policy.md` 的映射。代码与文档必须在同一提交中更新。

## AI 参与声明

如果使用 AI 辅助，应在 PR 中写明：

- 使用了什么工具或模型
- 参与了代码、测试、文档还是分析
- 哪些部分由人重新检查和修改
- 本人实际执行了哪些测试
