# 第一个界面主题

## 1. 准备目录

打开 Nota 的 **设置 → 外观 → 风格文件夹…**。创建：

```text
ui-styles/
└── dusk.css
```

文件名去掉 `.css` 后就是主题 id：`dusk`。

## 2. 写最小 CSS

```css
[data-ui-style="dusk"] {
  --radius: 4px;
  --radius-sm: 2px;
  --radius-lg: 8px;
  --control-height: 30px;
}

[data-ui-style="dusk"][data-ui-mode="light"] {
  --bg: #ffffff;
  --bg-subtle: #f4f4f4;
  --bg-raised: #ffffff;
  --fg: #202124;
  --fg-muted: #5f6368;
  --fg-faint: #72777f;
  --border: #d8dadd;
  --border-strong: #bcbfc3;
  --accent: #e95420;
  --accent-fg: #ffffff;
}

[data-ui-style="dusk"][data-ui-mode="dark"] {
  --bg: #242424;
  --bg-subtle: #303030;
  --bg-raised: #3b3b3b;
  --fg: #f1f1f1;
  --fg-muted: #bcbcbc;
  --fg-faint: #a4a4a4;
  --border: #4c4c4c;
  --border-strong: #626262;
  --accent: #f3732e;
  --accent-fg: #24100a;
}
```

## 3. 选择主题

回到 **设置 → 外观**，Nota 会重新读取风格目录。选择 **dusk**。

如果没有出现，请重启 Nota。

## 4. 为什么每个选择器都带 id

界面主题是原样注入的，作用范围就是整个应用。所有规则必须以：

```css
[data-ui-style="dusk"]
```

起头，否则会在其他主题下也生效。

## 5. 不要覆盖行为

主题应改变视觉，不应：

- 隐藏关键操作
- 改变点击区域到难以使用
- 让焦点轮廓完全消失
- 用动画阻塞输入

第一版能换底色、文字、边框和强调色就足够。
