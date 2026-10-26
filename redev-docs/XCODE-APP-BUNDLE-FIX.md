# Xcode 运行方式与 main bundle identifier 修正

日期：2026-10-23。此记录针对本次 Xcode 控制台中的 bundle、Intents/linkd 和激活日志。

## 发现的问题

用户提供的日志包含：

```text
Cannot index window tabs due to missing main bundle identifier
LNProcessInstanceRegistryClientErrorDomain Code=4
connection to service named com.apple.linkd.autoShortcut
AppleEvent activation suspension timed out
```

检查时实际运行进程的路径是 `DerivedData/Pastory-…/Build/Products/Debug/Pastory`，不在 `.app/Contents/MacOS/` 内。当前 `Package.swift` 定义的是 SwiftPM 可执行 target，直接以它为入口按 Run 不会自动执行项目的 `build.sh` 来组装 App。

项目的 `Resources/Info.plist` 虽有 Bundle ID，但“源码目录存在 plist”不等于运行程序已经获得 bundle 元数据。`AppIdentity.bundleIdentifier` 的中性兜底值也只供项目自身代码使用，无法给 macOS 系统框架填补真实的 `Bundle.main.bundleIdentifier`。

因此，当前缺失 main bundle identifier 有明确的构建/运行容器原因；它不表示必须购买 Developer ID、恢复原作者账号或重新连接原更新仓库。

## 本次修正

- 新增 [Pastory.xcodeproj](../Pastory.xcodeproj)：原生 macOS App target，产物是完整的 `Pastory.app`。
- 新增共享 `Pastory` scheme，Run 使用 Debug App，Profile/Archive 使用 Release 配置。
- 原生工程与 SwiftPM 共用 `Sources/Pastory`，没有复制另一套业务代码；同步源码文件夹自动纳入新增 Swift 文件。
- 原生工程使用现有 `Resources/Info.plist`，应用标识为 `local.pastory.app`，保留当前版本和 Evinci 版权文字。
- Copy Bundle Resources 包含当前图标、Logo、图钉、字体、Identity 人物素材、LICENSE 与第三方说明。
- 本地默认 ad-hoc 签名，无开发团队、付费账号或公证凭据要求；未启用额外沙箱限制。
- 原 `Package.swift`、`build.sh`、`dist.sh` 继续用于命令行构建及分发，没有恢复在线更新。
- 新增 `--selftest bundle`：检查 Foundation 真正读取到的 bundle 路径、标识、版本及资源，不使用身份兜底值蒙混通过。
- 更新中英 README、本地开发指南和开发约定，明确 Xcode 的日常入口。

## 在 Xcode 中怎么运行

1. 先停止当前从 SwiftPM 可执行 target 启动的调试进程。
2. 打开项目根目录的 `Pastory.xcodeproj`，而不是继续打开 `Package.swift` 作为运行入口。
3. 选择 `Pastory` scheme、`My Mac`。
4. 按 ⌘R。现在构建和运行的是 `.app`，包含真正的 bundle 信息与资源。

运行截图/录屏和自动粘贴时，仍按系统提示为实际运行的 App 授予相应隐私权限；构建目录变化后的授权不应当假设自动继承。

## 各条日志如何理解

| 日志 | 能得出的结论 |
|---|---|
| missing main bundle identifier | 系统读不到主 bundle 标识；本次已确认原运行方式没有完整 App 容器 |
| `com.apple.linkd.autoShortcut` 连接失败 | 苹果系统服务连接没有成功；不是 GitHub，也不是项目已删除的在线更新模块 |
| Process Instance Registry asynchronous | 系统 Intents 注册过程中的诊断；项目没有自定义 AppIntents 注册代码，不应照日志文字添加私有框架调用 |
| AppleEvent activation suspension timed out | 一次应用激活事件等待超时；单凭此行不能确定是焦点、调试暂停、主线程等待还是其他原因 |

不能把所有日志都认定为同一个原因。本次修正解决了真实缺失 bundle 身份的问题；如果正确 App 在其他操作场景仍出现 linkd 日志，要结合是否实际失去响应或功能失败再定位，不能承诺消除 macOS 所有诊断输出。

## 验证

- `plutil -lint Pastory.xcodeproj/project.pbxproj` 通过。
- `xcodebuild -list -json -project Pastory.xcodeproj` 正常列出原生 App target 和共享 scheme。
- `xcodebuild -project Pastory.xcodeproj -scheme Pastory -configuration Debug -derivedDataPath build/Xcode build` 成功。
- 原生 App 的 `--selftest bundle` 通过：真实标识 `local.pastory.app`，版本 `1.0.6`，字体、Identity 人物图片和其他核心资源均在包内。
- 原生 App 的 `--selftest l10n` 通过，219 个翻译键，无重复。
- 本次隔离的原生 App 自测中没有出现用户贴出的上述日志；自测不等同于复现所有普通操作和 Xcode 调试场景。
- `codesign --verify --deep --strict` 验证原生 App 通过。
- 将同一原生可执行文件及其配套调试库复制到 App 容器外再运行，检查准确报告 bundle 标识和版本缺失、资源不可用；容器内运行则全部通过。这验证了真实 bundle 元数据与代码兜底值的区别。

本次未停止用户正在运行的旧进程，未启动新 App 的正常剪贴板监听流程；自测使用临时存储，不读取真实剪贴板历史，也没有修改系统权限、开发者账号或更新配置。

## 参考

- [Apple：创建 App 的 Xcode 工程](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app)
- [Apple：在 bundle 中放置内容](https://developer.apple.com/documentation/bundleresources/placing-content-in-a-bundle)
