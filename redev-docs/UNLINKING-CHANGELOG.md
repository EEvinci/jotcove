# 移除原作者关联与在线更新

日期：2026-10-23。按确认保留 Pastory 产品名称，先完成作者账号和旧更新源解绑。

## 对正常使用、安装与分发的影响

| 盘点项目 | 本次处理 | 使用影响 |
|---|---|---|
| 原作者账号 | 清理运行代码、README、脚本中的账号及原仓库链接；移除带作者个人账号/文字的宣传图和旧二维码引用 | 不影响截图、录屏、剪贴板、便签等核心功能 |
| 原应用身份 | Bundle ID 改为 `local.pastory.app`，其余身份引用统一从 `AppIdentity` 派生 | 系统视为新的应用身份，需要重新授权；旧偏好不自动迁移 |
| 苹果签名与公证 | 保留通用工具能力；默认 ad-hoc 临时签名，取消自动选证书和预设公证配置 | 能本地打包和分发；未经公证的包可能需要手动允许打开，不承诺通过默认 Gatekeeper 检查 |
| 自动更新 | 删除完整实现、定时任务、设置/菜单入口、下载器和相关测试/翻译 | 不再读取原仓库版本、弹更新提示、下载或安装远端版本；以后人工更新 |
| 设计入口 | 保留现有名称、Logo、菜单栏图标和主题实现；删除含个人账号的演示图片 | 现有界面继续使用，下一步可加入自己的设计 |
| 数据目录 | 继续使用 `~/Library/Application Support/Pastory/`，本次没有触碰真实历史 | 保留原有内容；原版与新版不宜同时运行并写同一目录 |

新的偏好设置域不读取原身份下的快捷键、语言、便签位置等偏好，因此需要按需重新配置。当前源码对新设置默认“永不删除”，没有因改 Bundle ID 自动把旧历史按一天保留期清理；用户以后主动设置清理规则仍会正常生效。

## 已删除的更新功能

- `Sources/Pastory/App/Updater.swift`：远端仓库配置、API 请求、版本解析与比较、NSAlert 更新提示、解压验签替换及重启流程。
- `Sources/Pastory/App/UpdateProgressWindow.swift`：下载窗、进度条、URLSession 下载器。
- `AppDelegate` 中的启动更新任务、“检查更新”菜单和动作。
- `SettingsPane` 中的检查按钮、状态与自动检查开关，替换为只显示本地版本的“关于”区域。
- `Preferences` 与 `PrefsMirror` 中的更新开关、检查时间、跳过版本设置接口。
- `SelfTest` 中的 download、updatewin、updater 子命令和原 Release URL 测试样例；自测示例链接改为 `https://example.com`。
- 更新下载、GitHub 连接、安装失败、跳过版本等仅供更新模块使用的中英文文案。

运行时源码中已没有 `URLSession` / `URLRequest`、原仓库地址或更新模块符号。用户主动打开自己剪贴板中的网页链接仍属于正常功能，并未移除。

## 新应用身份

- [Resources/Info.plist](../Resources/Info.plist)：`CFBundleIdentifier=local.pastory.app`。
- [AppIdentity.swift](../Sources/Pastory/App/AppIdentity.swift)：集中读取当前 Bundle ID 和本地版本，命令行无 Bundle 时使用中性标识兜底。
- `CaptureCoordinator.source`：截图来源标识使用当前身份。
- `Theme.cardIcon`：自身来源图标使用当前身份判断。
- `PasteboardWriter.marker`：剪贴板私有类型由当前身份派生。
- `Preferences`：自测设置域由当前身份派生，继续与真实偏好隔离。

版本号暂保留 `1.0.6`，构建号 `7`；本次未引入自己的发布版本策略。

## 构建、签名与分发

- [build.sh](../build.sh)：默认 `SIGN_ID=-`，不再查询并选择钥匙串的第一个证书；正式签名需显式提供自己的身份。
- [dist.sh](../dist.sh)：默认只生成本地 ZIP；仅同时提供正式 `SIGN_ID` 与自己的 `NOTARY_PROFILE` 时才向苹果提交公证，移除旧的默认公证配置别名。
- [release.sh](../release.sh)：改为本地打包及可选说明文件，不创建 Git 标签、不推送、不调用 GitHub CLI。
- `build.sh` 会将原 LICENSE 与已有字体许可一起打包。
- 分发验证发现当前 SwiftPM 后端的多架构输出会共用产品路径，导致 lipo 输入被覆盖；已改为 `.build/universal/arm64`、`.build/universal/x86_64` 两个独立构建目录，并在合并前验证架构。
- README 和分发说明不再声称所有构建均已通过苹果公证；根据本次实际打包状态生成打开说明。

本次仅进行本地临时签名，没有使用开发者账号、读取公证凭据、提交苹果公证或上传任何发布平台。

## 宣传与说明清理

- 中英 README 移除原作者仓库克隆地址、latest Release 链接、社区二维码入口及页尾个人账号。
- 删除 `capture-annotations.jpg` / `capture-annotations-en.jpg` 中带作者名字的演示图。
- 删除 `recording-formats.jpg` / `recording-formats-en.jpg` 中嵌入个人 X 页面和账号的演示图。
- `WeChatGroup.png`、`Coffee.png`、README 群二维码图片此前已经不存在；本次清理剩余引用和打包列表，没有重新引入这些素材。
- 更新 `docs/DEVELOPMENT.md`，删除失效的更新模块、自测和联系页说明。
- 原版界面截图中仍可能显示旧版设置布局，它们不控制应用行为；后续视觉改造应统一重做宣传图。

## 明确保留的内容

`LICENSE` 中的上游版权和许可声明，以及字体 OFL 声明继续保留，并随分发包提供。它们用于记录软件来源与许可，不包含联网或更新逻辑。第三方贡献者致谢不属于原作者账号绑定。

按之前的收集要求，`redev-docs` 的原始盘点、CSV 和图片识别记录保留为历史证据，因此其中仍含旧账号文字和历史文件位置。原始盘点已标记为历史快照；它们不被 `build.sh` 打包，也不被 App 执行。

本次不修改真实剪贴板内容、旧偏好文件或系统中已经安装的旧 App。历史条目里原先保存的来源元数据也不会被批量重写。

## 验证记录

- 本机架构 debug 构建和 App 临时签名验证通过；签名标识为新 Bundle ID，TeamIdentifier 未设置。
- 中英设置页离屏渲染通过，并已人工查看：只显示“关于 / 当前版本”，不再显示更新按钮或开关。
- `--selftest l10n` 通过：217 项，无重复键。
- `--selftest ingest` 通过：位图+临时路径、Finder 文件、临时图片文件、纯文本、位图五种入库场景正常。
- 自测均在系统临时目录使用隔离存储，没有读写真实剪贴板历史或系统通用剪贴板。
- 三个 shell 脚本语法检查通过；缺失发布说明文件、仅提供公证配置但未提供正式身份时会在构建/联网前报错退出。
- 源码与本机可执行文件检查通过：没有旧账号、旧命名空间、更新 API 或 latest Release 地址；生成包中包含 LICENSE、不含旧联系资源。
- 中英 README 的剩余图片链接均存在。
- `CONFIG=debug SIGN_ID=- NOTARY_PROFILE= ./release.sh` 本地打包通过，产物为 `dist/Pastory-1.0.6.zip`，约 6.7 MiB；同时包含 x86_64 与 arm64。
- 将 ZIP 解压到独立临时目录后，App 的严格签名校验、Bundle ID、菜单栏属性、许可证和资源检查均通过；解压后的通用 App 也能运行隔离的 l10n 自测。
- 首次打开说明检查通过：明确说明本次未公证，没有误报已公证或保留每日更新的文案。

已有源码的并发隔离、weak 捕获和未使用变量等编译警告仍存在，本次构建未因此失败。本次没有用真实屏幕录制/辅助功能授权进行交互式录屏验证，也没有在另一台 Mac 上验证 Gatekeeper 首次打开体验。

## 使用本次构建

验证产物使用 debug 配置，适合当前本地功能检查；正式对外发布时可按默认 release 配置重新打包。新包仍使用临时签名，尚未经过苹果公证。

本机 App：[build/Pastory.app](../build/Pastory.app)。双架构分发包：[dist/Pastory-1.0.6.zip](../dist/Pastory-1.0.6.zip)。这些是可重新生成的本地产物。

修改只对新构建生效；如果系统里仍在运行旧版，需要先退出旧版，再使用本次构建的 App。不会通过源码改动自动改变已经安装或正在运行的旧进程。
