# 颜色与形状

Nota 的主题变量分成形状和颜色两组。

## 形状变量

常见变量：

```css
[data-ui-style="dusk"] {
  --radius: 4px;
  --radius-sm: 2px;
  --radius-lg: 8px;
  --control-height: 30px;
  --spacing: 8px;
  --toolbar-height: 34px;
  --statusbar-height: 26px;
}
```

未知变量会回落到 Nota 的 `:root` 默认值，所以只需声明要改的部分。

## 颜色变量

每一档都应在浅色和深色下分别定义：

```css
[data-ui-style="dusk"][data-ui-mode="light"] {
  --bg: #ffffff;
  --bg-subtle: #f5f5f5;
  --bg-raised: #ffffff;
  --fg: #222222;
  --border: #d8d8d8;
  --accent: #e95420;
  --accent-fg: #ffffff;
}

[data-ui-style="dusk"][data-ui-mode="dark"] {
  --bg: #242424;
  --bg-subtle: #303030;
  --bg-raised: #3b3b3b;
  --fg: #f0f0f0;
  --border: #4c4c4c;
  --accent: #f3732e;
  --accent-fg: #24100a;
}
```

## 文字对比度

正文与背景应至少达到 4.5:1。次要文字也不要低到无法阅读。

强调色上的文字颜色由 `--accent-fg` 指定。橙色、黄色和浅蓝通常需要深色文字；
深蓝和深绿通常需要白色文字。

## 组件规则

变量无法表达的组件规则也可以写，但必须带主题 id：

```css
[data-ui-style="dusk"] .sidebar {
  border-right: 2px solid var(--accent);
}

[data-ui-style="dusk"] .tab-active {
  box-shadow: inset 0 -2px 0 var(--accent);
}
```

保持选择器短而稳定，不要依赖内部 DOM 顺序。

## 3D 按钮

Nota 提供通用斜面变量：

```css
[data-ui-style="dusk"] {
  --bevel: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
  --bevel-sunken: inset 1px 1px 0 #808080, inset -1px -1px 0 #ffffff;
}
```

`--bevel` 用于凸起，`--bevel-sunken` 用于按下或持续开启的按钮。
