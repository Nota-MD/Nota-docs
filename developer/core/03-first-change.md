# 完成第一个改动

第一个改动建议从明确的小问题开始，例如修正一条界面文案。

## 1. 找到界面字符串

界面字符串使用 `t("English source")`。中文译文位于：

```text
src/i18n/zh-ui.ts
src/i18n/zh-settings.ts
src/i18n/zh-runtime.ts
```

## 2. 修改原文与译文

假设把 `Close` 改成更明确的 `Close dialog`：

```tsx
<button aria-label={t("Close dialog")}>…</button>
```

同时在中文表更新对应键：

```ts
"Close dialog": "关闭对话框",
```

不要只改中文译文而留下旧的英文键；否则这段译文不会生效。

## 3. 更新测试

如果测试固定了旧文案，应同步更新。更稳妥的做法是测试行为或键名，而不是重复整段文案。

## 4. 手动验证

运行 `npm run app`，实际打开包含该文案的界面，确认：

- 中文正常显示
- 英文界面正常显示
- 关闭、取消和焦点行为没有变化

## 5. 检查差异

```sh
git diff --check
git diff
```

提交中只应包含这个改动及其必要测试、文档。
