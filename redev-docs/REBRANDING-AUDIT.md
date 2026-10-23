# Pastory 改造前盘点：作者、签名公证、自动更新与设计入口

> 此文为解绑前的历史快照，账号引用和行号用于追溯，不代表当前代码。当前改造状态见 [UNLINKING-CHANGELOG.md](UNLINKING-CHANGELOG.md)。

盘点日期：2026-10-23。范围：当前目录内的源码、脚本、资源、说明文档与 `.swiftpm` 项目元数据。

本次只收集证据和整理改造清单，没有修改应用功能、更新来源、签名、用户数据或原始署名，没有执行构建、签名、公证或发布操作。

文中 `文件:行号` 对应盘点时的本地文件。完整逐行引用见 [rebranding-reference-index.csv](rebranding-reference-index.csv)，包含 40 个文件的 393 处文本引用；24 张图片的检查结果见 [rebranding-image-audit.json](rebranding-image-audit.json)。图片中的 OCR 结果仅是检索辅助，人工确认的作者相关内容另列如下。

最终核验时的目录变化：`Resources/WeChatGroup.png`、`Resources/Coffee.png` 和 `docs/images/wechat-group.png` 在初次检查和图片识别时存在，随后已从目录中消失。本次没有删除或恢复它们。以下保留初次看到的素材信息，并记录它们当前缺失；24 张图中最终仍存在 21 张。README 与打包脚本的相关文本引用尚在。

## 1. 已确认的关键结论

- 按你所说的“CC 账号”梳理，项目实际出现的作者账号字符串是 `nothingbutcici`，应用命名空间含 `cici`；没有找到可确认其真实姓名的资料，也未找到独立的 `CC` 文本账号。
- 原作者 GitHub 仓库为 `nothingbutcici/pastory`，运行时更新源明确指向它。改界面名称并不会改变更新来源。
- 源码没有固定的原作者 Apple 账户、Developer ID 证书名称或 Team ID。签名身份来自打包机器钥匙串；公证使用钥匙串配置别名 `pastory-notary`。
- 当前目录没有 `.git`，不能在这里确认 origin、提交历史、发布者登录身份，也不能直接执行现有发布脚本的 Git 发布步骤。
- 当前目录未发现 `.app` 发布产物、签名证书/私钥文件或公证凭据，因此不能依据这些源码证明原作者实际证书的姓名、Team ID 或某个发布包的公证状态。
- 当前侧栏只有剪贴板与设置，没有“联系我”页面；微信、疑似赞助收款二维码素材在盘点初期存在，最终核验已缺失。打包脚本仍列出它们，文件存在时会复制。文档与自测参数中也有旧的 contact 痕迹。
- 换成独立产品需要同时处理：更新仓库、应用标识、签名配置、数据目录、品牌素材、界面文字和发布脚本。

## 2. 作者账号、联系方式与署名

| 信息 | 当前值或内容 | 位置 | 改造时如何处理 |
|---|---|---|---|
| 作者 GitHub 账号 | `nothingbutcici` | `LICENSE:3`、`README.md:189`、`README.en.md:184` | 将运行时、推广和发布入口换成自己的；许可证中的上游声明单独保留 |
| 原仓库 | `https://github.com/nothingbutcici/pastory` | `README.md:174`、`README.en.md:169` | 更换项目说明中的克隆地址 |
| 更新仓库 | `nothingbutcici/pastory` | `Sources/Pastory/App/Updater.swift:9` | 实际控制用户向哪个项目检查更新，优先处理 |
| 发布完成提示链接 | 原仓库 `/releases/tag/v$VERSION` | `release.sh:15` | 这是输出文案；实际发布目标还取决于 Git/gh 上下文 |
| 测试 Release 链接 | 原仓库的示例 v1.2 页面与安装包地址 | `Sources/Pastory/App/SelfTest.swift:201`、`:202` | 解析测试样例，非正常启动时的更新请求 |
| 自测剪贴板内容 | 原仓库 URL | `Sources/Pastory/App/SelfTest.swift:468` | 自测生成样本，非正常用户数据初始化 |
| 微信群推广 | `Pastory 小小群`、扫码进群文字；图片最终缺失 | `README.md:40`、`:41`、`docs/images/wechat-group.png` | 替换为自己的社区，或移除推广区域；当前 README 的图片引用已悬空 |
| 图片中的 X/Twitter 账号 | 页面显示名 `cici su`，账号 `@nothingbutcici`，个人简介含 `Marketing engineer` | `docs/images/recording-formats.jpg`、`recording-formats-en.jpg` | 属于嵌入宣传图的历史页面截图；重做图片，不是修改代码中的 URL |
| 图片中的作者示例文字 | `hi, i'm cici` 与 `cici` 浏览器快捷方式名称 | `docs/images/capture-annotations.jpg`、`capture-annotations-en.jpg` | 更换演示内容和宣传图 |
| 应用资源中的微信群二维码 | `Resources/WeChatGroup.png`；最终缺失 | `build.sh:42` | 没有找到界面读取代码，脚本仅在文件存在时复制 |
| 疑似赞助/收款二维码 | `Resources/Coffee.png`，二维码中心有头像及绿色标识；最终缺失 | `build.sh:42` | 文件用途按名称推断；静态图片不能证明收款人身份，不应作为自己的收款素材继续分发 |
| 其他贡献者署名 | `@behindthebeat` | `README.md:187`、`README.en.md:182` | 属于贡献说明，不能误认为 CC 的另一个账号 |

本次文本源码和文档检索未发现作者个人邮箱、手机号、可确认的微信个人号、X/Twitter 主页 URL、支付宝账号或 Apple 账户。不过，宣传图片确实显示了上述 X 账号；显示名不能等同于已验证的真实姓名，也不能证明该账号现在的状态。微信群二维码不等于作者个人微信号；图片中的头像不能用来确认自然人身份。

微信群宣传图 `docs/images/wechat-group.png` 离线解出的二维码内容为：

```text
https://weixin.qq.com/g/AQYAADgI7pExVNNm56VHu05YswhyafUWo2lYMGMTdn2cFzTy6lAGOy-ilAjs6Kha
```

只记录了图片编码的原始内容，没有打开链接，也没有确认群是否仍有效。`Resources/WeChatGroup.png` 与 `Resources/Coffee.png` 本次未成功解码，不能据此认定它们不含有效二维码。

### 联系页面遗留与截图差异

- `Sources/Pastory/Shelf/ShelfView.swift:69`：当前侧栏只有产品字样、剪贴板、设置。
- `docs/DEVELOPMENT.md:71`：仍写有 `--selftest contact` 联系我页截图命令。
- `docs/DEVELOPMENT.md:96`：仍提及联系我页的键盘行为。
- `Sources/Pastory/App/SelfTest.swift:18`：`contact` 仍出现在隔离自测命令集合中，但当前 switch 没有对应页面实现。
- 当前源码中没有找到 `ContactView`、`showContact` 或读取 `WeChatGroup` / `Coffee` 的界面实现。不能因早先更新说明提到“联系我”，就认定当前本地源码含该功能。

## 3. 含 cici 的应用身份：不是 Apple 登录账号

| 标识 | 位置 | 用途 |
|---|---|---|
| `com.cici.snipclip` | `Resources/Info.plist:12` | Bundle ID，操作系统识别应用的主要标识之一 |
| `com.cici.snipclip` | `Sources/Pastory/Capture/CaptureCoordinator.swift:15` | 自己截图入库时的来源应用标识，同时写入来源名 `Pastory` |
| `com.cici.snipclip` | `Sources/Pastory/App/Theme.swift:75` | 判断“本应用来源”，使用自己的 Logo |
| `com.cici.snipclip.marker` | `Sources/Pastory/Capture/PasteboardWriter.swift:6` | 剪贴板私有类型，识别本应用写出的条目，避免重复入库 |
| `com.cici.snipclip.selftest` | `Sources/Pastory/App/Preferences.swift:80`、`:81` | 隔离自测偏好设置域 |
| 同一旧 Bundle ID 的说明 | `docs/DEVELOPMENT.md:26` | 原项目强调保持升级兼容，因此写“不能改” |

这些字符串不包含开发者登录凭据，也不是 Team ID。针对独立新产品，可以选择自己的 Bundle ID，并同步修改所有引用；原文档的“不能改”服务于原产品升级兼容，应在新产品文档中重写。

改 Bundle ID 后需要重新处理系统权限和偏好设置承接，不能承诺自动继承原应用的授权或设置。当前正式偏好设置使用 `.standard`，见 `Sources/Pastory/App/Preferences.swift:79`。

## 4. 苹果签名与公证的全部入口

### 4.1 本地构建签名：build.sh

| 位置 | 实际行为 |
|---|---|
| `build.sh:7` | 构建模式 `CONFIG` 默认 `release` |
| `build.sh:10` | 允许调用者提供 `SIGN_ID` |
| `build.sh:11`、`:12` | 未提供时，查询本机钥匙串的代码签名身份，选择第一个 `Developer ID Application` |
| `build.sh:14`、`:16` | 有证书用该身份；没有证书则使用 `-`，即 ad-hoc 临时签名 |
| `build.sh:36` | 产物路径写死 `build/Pastory.app` |
| `build.sh:39`、`:40` | 拷贝可执行文件与 `Resources/Info.plist` |
| `build.sh:48` | 身份名称匹配 Developer ID 时加入 hardened runtime 与安全时间戳参数 |
| `build.sh:49`、`:50` | 调用 `codesign`；带 entitlements 失败时尝试不带 entitlements 重签 |
| `Resources/Pastory.entitlements:4` | 权益字典为空，没有写死作者的团队标识 |

注意：自动选“第一个证书”可能选中打包机器上别的项目使用的身份。自己的发布流程宜显式配置身份和预期 Team ID。

### 4.2 分发与苹果公证：dist.sh

| 位置 | 实际行为 |
|---|---|
| `dist.sh:10` | 独立查询本机第一个 Developer ID Application 身份，保存为 `DEV_ID` |
| `dist.sh:11` | 公证配置变量 `NOTARY_PROFILE` 默认 `pastory-notary` |
| `dist.sh:13` | 构建 arm64 + x86_64；向 build.sh 传递其选中的 `SIGN_ID` |
| `dist.sh:18` | 将 App 打成 `dist/Pastory-<版本>.zip` |
| `dist.sh:19` | 只有找到 Developer ID 身份才进入公证分支 |
| `dist.sh:21` | `xcrun notarytool submit ... --keychain-profile "$NOTARY_PROFILE" --wait` |
| `dist.sh:22` | `xcrun stapler staple build/Pastory.app`，将公证票据附加到应用 |
| `dist.sh:24` | 将附带票据的 App 重新打包 |
| `dist.sh:25` | `spctl --assess --type execute -vv` 检查系统接受情况 |
| `dist.sh:28` | 生成中英双语首次打开说明 |
| `dist.sh:35`、`:54` | 已公证的首次打开文案 |
| `dist.sh:64` | 未公证时替换成手动允许打开的文案 |

`pastory-notary` 只是打包机器钥匙串中一组凭据的名字，不是苹果账号、Team ID 或公证结果。它需要在打包机器上另行配置，仓库中的同名字符串不会赋予作者的公证权限。

`dist.sh` 会自己选择 `DEV_ID` 再覆盖传给 `build.sh` 的签名身份；不能以为在外层设置 `SIGN_ID` 就一定能控制 `dist.sh` 的选择。有证书但缺少有效公证配置时，现有脚本会报错退出，不会自动转为未经公证的成功发布。

### 4.3 签名与更新器的关联

- `Updater.swift:158` 的 `canSelfInstall` 读取当前 App 的 Team ID，并检查是否处于 App Translocation 路径、父目录是否可写。
- `Updater.swift:164` 的 `teamIdentifier(of:)` 通过 `codesign -dv --verbose=2` 读取运行时身份，没有写死 CC 的 Team ID。
- `Updater.swift:199` 开始验证下载包的签名、苹果信任链要求及新旧包 Team ID 一致性。
- 代码注释提到“signed, notarized”，但 `canSelfInstall` 本身没有显式查询公证票据；安装验证也不能等同于一次独立的 `stapler validate` 或 `spctl --assess` 公证检查。
- 现有安装检查没有额外明确比对新旧 Bundle ID；改造为自己的产品时应把包身份校验纳入更新方案。

### 4.4 现有材料能证明与不能证明的事情

能证明：项目实现了 Developer ID 签名、公证、附加票据和校验的流程；README 声称作者发布包已公证。

不能证明：具体哪个 Apple 账户完成过公证、证书持有人姓名、实际 Team ID、会员是否有效、GitHub 上某个安装包是否真的通过公证。本次未访问个人钥匙串、未登录作者账号，也没有下载和运行远端包。

相关文档：`README.md:51`、`README.en.md:46`、`docs/DEVELOPMENT.md:36`。

## 5. 自动更新的完整位置与行为

原主文件：`Sources/Pastory/App/Updater.swift`（本次后续解绑中已删除）。没有独立的“功能公告服务”；弹窗中的功能说明来自 GitHub Release 正文。

| 功能 | 位置 | 当前行为 |
|---|---|---|
| 启动注册 | `App/AppDelegate.swift:36` | 启动时调用 `Updater.shared.schedule()` |
| 目标仓库 | `App/Updater.swift:9` | `nothingbutcici/pastory` |
| 默认下载页面 | `App/Updater.swift:10` | `https://github.com/nothingbutcici/pastory/releases/latest` |
| 本地版本 | `App/Updater.swift:25` | 读取 `CFBundleShortVersionString`，失败时返回 `0` |
| 定时调度 | `App/Updater.swift:28` | 启动 30 秒后首次检查，之后运行中每 24 小时检查 |
| 自动检查限流 | `App/Updater.swift:43` | 尊重开关；距离上次检查不到 20 小时跳过；`busy` 防止重入 |
| 跳过版本 | `App/Updater.swift:58` | 自动检查尊重跳过记录，手动检查可再次提示 |
| 远端请求 | `App/Updater.swift:69` | GitHub latest Release API，15 秒超时；没有 Authorization 头 |
| 请求标识 | `App/Updater.swift:72` | User-Agent 为 `Pastory/<当前版本>`，没有用户唯一标识 |
| 解析 Release | `App/Updater.swift:81` | `tag_name` 取版本并去掉 v；`body` 取更新说明；`html_url` 取页面 |
| 安装包选择 | `App/Updater.swift:85` | 选第一个名字以 `.zip` 结尾的资产，未按架构或产品名进一步匹配 |
| 下载域名限制 | `App/Updater.swift:87` | 资产 URL 要求 HTTPS 和指定 GitHub 域名；非任意自托管地址 |
| 更新说明排版 | `App/Updater.swift:97` | 按 `\n---\n` 区分中英文，去掉 Markdown 样式，最长 900 字符 |
| 版本比较 | `App/Updater.swift:117` | 按点分数字比较，非数字段按 0，不是完整的预发布版本语义比较 |
| 版本提醒弹窗 | `App/Updater.swift:128` | NSAlert，显示说明和安装/下载页、稍后、跳过版本按钮 |
| 自动安装条件 | `App/Updater.swift:158` | Team ID、位置、可写性，以及 Release 有 ZIP |
| 安装入口 | `App/Updater.swift:180` | 下载、解压、验签、替换应用并重启 |
| 新包名称 | `App/Updater.swift:197` | 解压后查找 `Pastory.app`，改产品名必须同步这里 |
| 验签 | `App/Updater.swift:202` | codesign verify + 团队匹配要求 |
| 原地替换 | `App/Updater.swift:208` | `replaceItemAt` 替换当前 Bundle |
| 重启 | `App/Updater.swift:210` | 启动新 App，成功后退出旧实例 |
| 错误与重试 | `App/Updater.swift:215` | 重试、打开发布页、取消 |
| 下载进度窗 | `App/UpdateProgressWindow.swift:13` | 标题、进度、取消；开始安装后隐藏取消 |
| 下载器 | `App/UpdateProgressWindow.swift:98` | URLSession 下载，30 秒请求超时、900 秒总资源超时 |

上表中 `App/…` 路径均位于 `Sources/Pastory/` 下。

设置及菜单入口：

- `Sources/Pastory/Shelf/SettingsPane.swift:49`：版本更新区域、当前版本、手动检查、自动检查开关。
- `Sources/Pastory/App/AppDelegate.swift:96`：菜单“检查更新…”。
- `Sources/Pastory/App/AppDelegate.swift:149`：手动检查动作。
- `Sources/Pastory/App/Preferences.swift:160`：`checkForUpdates` 默认 true。
- `Sources/Pastory/App/Preferences.swift:161`：`lastUpdateCheck`。
- `Sources/Pastory/App/Preferences.swift:162`：`skippedVersion`。
- `Sources/Pastory/App/SettingsWindow.swift:28`：设置镜像层转发更新开关。
- `Sources/Pastory/App/Localization.swift:36`、`:106`：更新进度、错误、按钮、版本提醒的中英文本。
- `Sources/Pastory/App/SelfTest.swift:199`：更新器解析、版本比较、说明格式及临时签名场景的自测。

当前版本信息在 `Resources/Info.plist:20` 与 `:22`：展示版本 `1.0.6`，构建号 `7`。只修改源码中的名字不会改变这两个值。

### 原作者仍能影响哪些内容

只要 `repo` 仍指向原仓库，新版提醒中的版本号、更新说明、下载页面和资产地址就仍取自原项目。临时签名构建即使不能自动安装，也仍可能出现原作者更新说明并打开原作者发布页。

用自己的 Developer ID 签名不会自动切换更新源；因团队不匹配拒绝安装，也不意味着仓库关联已经移除。

关闭自动检查开关只影响自动检查；菜单和设置中的手动检查仍可请求原仓库。要完全脱离，需要修改/停用更新模块及其手动入口，而不仅是关默认开关。

## 6. GitHub 发布脚本与更新协议

`release.sh` 的步骤：

1. 第 7 行从 Info.plist 读版本号。
2. 第 8、9 行要求传入更新说明文件。
3. 第 10 行执行 dist.sh 构建、公证、打包。
4. 第 11、12 行检查并创建 `v<版本>` 标签。
5. 第 13 行把标签推到 Git `origin`。
6. 第 14 行使用 `gh release create`，上传 ZIP、指定标题、用 `--notes-file` 写入更新说明。
7. 第 15 行打印原作者仓库链接。

重要区分：第 15 行链接是硬编码输出；第 14 行没有 `--repo`，发布目的地取决于 GitHub CLI 所解析的仓库上下文及配置，不能仅凭最后的提示地址认定它一定发布到作者仓库。改造时应明确自己的 origin 和 gh 目标仓库，并核对运行时更新源一致。

当前脚本先构建再检查标签是否存在，且目录没有 Git 元数据。本次没有运行 release.sh，也没有创建标签或发布任何内容。

当前更新器依赖的约定：标签 `v<数字版本>`、ZIP 资产、解压顶层 `Pastory.app`、双架构发布包、Release 正文中的中英分隔。改名字、改托管服务、拆分 CPU 架构都要相应调整这些约定。

## 7. 产品名称、数据与本地身份：改名不能只替换 Logo

| 范围 | 入口 | 说明 |
|---|---|---|
| 系统显示名称、可执行文件、Bundle ID | `Resources/Info.plist:5` | 名称为 Pastory，`LSUIElement=true` 使其以菜单栏应用形式工作 |
| Swift 包与 target | `Package.swift:5`、`:9`、`:10` | 包名、target 名、源码路径都含 Pastory |
| 打包与安装路径 | `build.sh:26`、`:36`、`:39`，`dist.sh`，`release.sh`，`Updater.swift:197` | 必须协调改名，避免编译成功但打包或自动安装找不到文件 |
| 本地数据根目录 | `Sources/Pastory/Clipboard/ClipStore.swift:30` | 固定为 `~/Library/Application Support/Pastory/`，与 Bundle ID 无关 |
| 数据库文件名 | `Sources/Pastory/Clipboard/ClipStore.swift:25` | `pastory.sqlite` |
| 本地偏好设置 | `Sources/Pastory/App/Preferences.swift:79` | 使用标准 UserDefaults；改 Bundle ID 要考虑旧设置迁移 |
| 首次欢迎及教程 | `Sources/Pastory/Shelf/WelcomeCard.swift:22`、`:28`，`HowToCard.swift:7` | 页面文字和一次性种子卡片中含原产品名 |
| 菜单与权限提示 | `AppDelegate.swift`、`Permissions.swift:70`、`Localization.swift` | 退出、授权、重启、错误和中英文翻译等文字 |
| 内部标识 | `Preferences.swift:189`、`:191`，其他 `pastory` 临时名、自测环境变量 | 不一定直接显示给用户，可集中改造时一并规范 |
| Xcode 用户元数据 | `.swiftpm/xcode/xcuserdata/evinci.xcuserdatad/` | 当前工作机个人界面数据，不属于 CC 账号绑定 |

如果希望原版和自己的软件并存，应分开 Bundle ID 与数据根目录。仅改 Bundle ID 仍会读取/写入同一个 Pastory 数据目录；若要继承原有历史，应设计显式迁移，而不是直接搬动或清空。

## 8. 加入自己设计元素的入口

### 主要视觉资源

| 文件 | 当前尺寸/类型 | 用途 |
|---|---|---|
| `Resources/AppIcon.icns` | macOS 图标包 | Finder / 应用图标 |
| `Resources/Logo.png` | 512 × 512 | 产品 Logo、自身来源卡片图标 |
| `Resources/MenuIcon.png` | 18 × 18 | 菜单栏图标 1x |
| `Resources/MenuIcon@2x.png` | 36 × 36 | 菜单栏图标 2x |
| `Resources/Pushpin.png` | 298 × 435 | 卡片上的图钉视觉 |
| `Resources/WeChatGroup.png` | 894 × 861；最终缺失 | 初次检查的遗留微信群二维码 |
| `Resources/Coffee.png` | 426 × 409；最终缺失 | 初次检查的遗留疑似赞助二维码 |
| `docs/images/wechat-group.png` | 877 × 1040；最终缺失 | 初次检查的 README 微信群推广图 |
| `docs/images/` 其余 PNG/JPG | 中英宣传与界面截图 | README 展示，重设计后需要重新制作，不能只替换源码名称 |
| `Resources/Fonts/Caveat.ttf` | 字体 | 拉丁手写字体 |
| `Resources/Fonts/YsabeauOffice.ttf` | 字体 | 包含在资源中的原品牌字体 |

`Theme.swift:120` 将菜单栏图标按 20 × 20 的逻辑尺寸组装，并设为 template，由系统着色。制作新图标时应同时考虑轮廓、透明背景和高分辨率版本。

### 颜色、字体与组件

- `Sources/Pastory/App/Theme.swift:7`：主色、纸张色、浅蓝强调色、文字色。
- `Theme.swift:26`：正文宋体配置；`:32`：手写字体；`:105`：字体注册；`:117`：品牌字。
- `Theme.swift:42`、`:59`：纹理噪点与预烘焙纸张/桌面纹理。
- `Theme.swift:97`、`:99`、`:120`：Logo、图钉、菜单栏图标读取。
- `Theme.swift:138`、`:152`、`:165`、`:188`、`:195`、`:207`：圆角、纸张、桌面、背景、面板与按钮画法。
- `Sources/Pastory/Shelf/ShelfView.swift:4`：SwiftUI 颜色与字体桥接；`:69`：侧栏、产品字；`:111`：头部筛选与搜索；`:167`：卡片排列。
- `Sources/Pastory/Shelf/ClipCardView.swift`：历史条目卡片。
- `Sources/Pastory/Shelf/DesktopNoteView.swift`：桌面便签。
- `Sources/Pastory/Shelf/WelcomeCard.swift`：欢迎体验。
- `Sources/Pastory/Shelf/SettingsPane.swift`：设置页面。
- `Sources/Pastory/Annotate/Annotation.swift:182` 附近：标注调色盘。
- `Sources/Pastory/Annotate/AnnotateToolbar.swift`：标注工具栏。
- `Sources/Pastory/App/UpdateProgressWindow.swift`：自绘下载进度窗。
- `Sources/Pastory/App/Updater.swift:128`：更新提醒当前为系统 NSAlert，如需强定制外观，要另行设计窗口。

`docs/DEVELOPMENT.md:110` 写“logo 与图标……不在仓库”，但当前目录实际包含以上图像文件。盘点以实际文件和读取代码为准；这句文档已不能完整描述当前资源状态。

## 9. 许可证和第三方声明的保留位置

- `LICENSE:3` 是原作者版权声明；`:12`、`:13` 原文要求在软件副本或实质部分中包含该版权声明与许可声明。
- 运行时产品名、自己的官网/社区和自己的更新源可以按新产品设计修改；保留的上游许可声明不等于应用仍关联原作者账号。
- 字体许可在 `Resources/Fonts/OFL-Caveat.txt` 与 `Resources/Fonts/OFL.txt`。若继续分发字体，原许可文件也应随资源保留。
- 不要把字体项目链接、第三方贡献者和普通“微信截图”兼容性说明，当作 CC 账号引用批量删掉。

## 10. 推荐实施顺序与待定配置

| 顺序 | 工作 | 需要确定的值 |
|---|---|---|
| 1 | 建立独立产品身份和配置入口 | 新名称、Bundle ID、数据目录；是否迁移原版历史 |
| 2 | 脱离原更新源 | 自己的 GitHub owner/repo，或开发阶段禁用更新；同时处理手动检查入口 |
| 3 | 替换宣传与联系方式 | Logo、菜单栏图标、自己的社区/反馈入口、是否保留赞助功能 |
| 4 | 完成视觉设计 | 配色、字体、纹理、卡片、设置和欢迎页 |
| 5 | 明确签名和公证策略 | 先 ad-hoc 分发，或使用自己的 Developer ID、预期 Team ID、公证配置别名 |
| 6 | 统一构建、分发和更新协议 | App 文件名、ZIP 名称、版本号、架构、Git/gh 发布仓库 |
| 7 | 检查新旧产品并存与升级 | 数据隔离、权限提示、自动更新包身份、语言与新品牌文字 |
| 8 | 更新 README、截图和分发说明 | 自己的产品介绍、安装说明、源码地址与保留的许可证 |

建议后续将名称、Bundle ID、更新仓库、反馈 URL 等集中配置，减少分散的硬编码。新名称、账号和视觉方向尚未确定，因此本次没有代填这些值，也没有开始替换原项目。

## 11. 范围与验证记录

- 已逐行搜索当前项目文本中的 `nothingbutcici`、`cici`、独立 `CC`、网络地址、联系/赞助、签名/公证、更新相关标识及品牌名称。
- 已核查构建、分发、发布三份脚本；更新器、下载器、菜单和设置入口；版本字段、Bundle ID、数据目录及设计资源。
- 已对 24 张 PNG/JPG 资源离线执行文字和二维码识别；人工查看三份二维码及两张含作者账号的宣传图。图片结果见 `rebranding-image-audit.json`。二维码目标未打开，未发生加群、付款或联系作者操作。
- 未执行原应用、自测、构建或发布，不读取真实剪贴板历史，不修改系统权限与钥匙串。
- 当前没有 Git 元数据与发布 App，源码/文档结论不能替代对真实发布包签名和公证状态的验证。
