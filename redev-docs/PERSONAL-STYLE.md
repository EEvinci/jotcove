# Evinci 可可手记 · 2026-10-23

修改前已将源码推送到私有仓库 https://github.com/EEvinci/pastory 。
原版提交：`f85a00fc6f95568381be4d2732e8576815c3584b`。
备份标签：`backup/pre-style-2026-10-23`；`main` 保留原版。
改版位于 `style/evinci-warm-paper`。

## 呈现

保留横向卡片、纸张轮廓、快捷键和原有操作。可可棕主色，雾霾蓝选中态，米灰纸卡；雾霾紫、暖黄、浅绿和薄荷绿作为类型圆点与小面积点缀。降低纸纹和阴影强度，改善链接文字对比度。

侧栏展示用户提供的 `3-2.png` 棕衣卡通 IP；欢迎页、空状态与设置页展示 `0-2.png` 头像。原始素材直接复制到 Resources/Identity，不修改用户原图。应用图标与菜单栏图标沿用现有资源。欢迎引导支持两列换行与滚动，底部按钮固定可见。

## 取回原版

先退出运行中的 Pastory。在项目根目录执行：

```bash
git switch main
./build.sh
```

原版应用在 `build/Pastory.app`。返回新版：

```bash
git switch style/evinci-warm-paper
./build.sh
```

如已有后续本地修改，先提交或暂存，再切换分支。取回原始源码的固定入口为 GitHub 备份标签；不要删除标签或强制改写 main。
