# 多 AI 群聊 · 安卓 APK

这个仓库只有一个目的：让 GitHub 免费把 `index.html` 打包成一个可安装的安卓 APK。
**不需要在电脑上装任何 Android 开发环境。**

## 怎么出新版本

1. 改 `index.html`（这就是整个应用；也可以用本仓库根目录的 `sync-web.ps1` 从手机版同步）。
2. 提交（commit）到 `main` 分支。
3. GitHub 会自动开始构建，约 3–5 分钟。
4. 打开仓库的 **Actions** 标签 → 点最新那次「构建 APK」→ 页面底部 **Artifacts** 里下载
   `multi-ai-chat-apk.zip`，解压得到 `app-debug.apk`。
5. 手机上点开这个 APK 安装（首次需要在系统设置里允许「安装未知来源应用」）。

想手动重新构建：Actions → 构建 APK → 右侧 **Run workflow**。

## 目录

| 路径 | 作用 |
|---|---|
| `index.html` | **应用本体**（单文件，改这个就够了） |
| `.github/workflows/build-apk.yml` | 构建脚本（拉 JDK/SDK/Gradle → 编译 → 上传 APK） |
| `android/` | 壳工程（WebView 外壳，一般不用动） |

## 两个已知的坑

**1. 每次构建的签名都不同 → 第二次安装要先卸载。**
Actions 每次跑都会新生成一个 debug 签名，签名不一致时安卓会拒绝覆盖安装。
- 只是想试试：直接卸载旧的再装新的即可（数据会清空，Key 要重填）。
- 想要能"原地升级"：需要固定签名——把 keystore 存成仓库 Secret（见下）。

**2. Key 要重填一次。**
APK 里的存储和浏览器是隔离的，浏览器里那份 localStorage 带不过去。

## （可选）固定签名，让以后的版本能覆盖安装

1. 本地生成一次 keystore：
   `keytool -genkeypair -v -keystore release.jks -alias app -keyalg RSA -keysize 2048 -validity 10000`
2. 转成 base64：`certutil -encode release.jks release.b64`（或 Linux 的 `base64 -w0 release.jks`）
3. 仓库 Settings → Secrets and variables → Actions 新建：
   - `KEYSTORE_BASE64` = 上面那串 base64
   - `KEYSTORE_PASSWORD` = 你设的密码
   - `KEY_ALIAS` = `app`
   - `KEY_PASSWORD` = 同上
4. 在 `android/app/build.gradle` 里按 base64 还原 keystore 并用于 `release` 构建（需要时我可以补上这段）。

⚠️ **keystore 和密码丢了，就再也没法给已安装的应用升级**，只能卸载重装。请务必留存。
