# 改动记录

本文件记录本仓库相对上游 [uoweme325/AgentPet](https://github.com/uoweme325/AgentPet) v1.4.1 的自有改动。
功能与配置的完整说明见根目录 [README.md](../README.md)。

## 2026-10-30

### 新增

- **低余额提醒**（移植自上游 v1.5.0 的交互）：余额低于 `LowBalanceCnyThreshold`（默认 ¥5）时弹一次气泡，
  边沿触发，回到阈值以上后重新武装；忙碌 / 气泡隐藏 / 正在看面板时顺延，不丢失提醒。
- 运行监控在余额数据里附带数值字段 `amount`，UI 不再从 `"¥43.57"` 里解析金额。

### 修复

- 快捷方式脚本改用环境变量传参（`$env:VBS_PATH`）并以 `[char]34` 生成引号，
  路径含单引号时不再破坏语法；补充启动脚本存在性检查与创建后回读校验。
- 仓库行尾规范化：新增 `.gitattributes`，仓库内统一存 LF，`.bat` / `.cmd` / `.ps1` / `.vbs` 检出为 CRLF。

## 2026-10-29

### 新增

- **DeepSeek 余额看板**：直连官方 `GET /user/balance`，与 Codex 额度共用面板，按当前在跑的 Agent 自动切换。
  - `QuotaProvider` = `auto`（默认）/ `deepseek` / `codex`
  - 今日与累计为本地累计（对比前后余额差额），只统计程序运行期间观察到的消耗
- **第四位角色「小鲸鱼」**：立绘取自 [YunYueSama/codex-deepseek-pet](https://github.com/YunYueSama/codex-deepseek-pet)，
  配套独立主题配色、台词池、托盘图标与菜单项。
- HTTP 错误码映射为可读文案（401 密钥失效 / 402 余额不足 / 403 无权限 / 429 频率限制 / 5xx 服务端错误 / 网络不通）。

### 修复

- **启动位置跑到屏幕外**：窗口显示前 `PresentationSource` 为空，DPI 读到 1.0，
  拿物理像素边界去校验 DIP 坐标必然误判。改用 `SystemParameters.VirtualScreen*`（DIP），
  且判据从「左上角在屏内」改为「整个窗口在屏内」。
- **拖动能把角色拖出屏幕**：原逻辑限制「角色中心在屏内」，改为整个窗口限制在当前显示器工作区内。
- **手改配置被覆盖**：`Save-Config` 写盘前先读磁盘，`DeepSeekApiKey` / `QuotaProvider` 以磁盘值为准。
- **`.bat` 全是 LF 换行**：cmd 解析失败，全部转 CRLF（保持 GBK 编码）。
- **开机自启指向旧路径**：目录调整后同步更新注册表项。

### 整理

- 根目录只保留 4 个启动脚本，程序 / 文档 / 备份分入 `app\`、`docs\`、`backup\`。
- `.gitignore` 排除 `config.json`、运行时状态、日志、PID 与备份，避免密钥入库。

## 未采用的方案

上游 v1.5.0 改为「经本机 DSH 宿主读取余额，不落盘 API Key」，思路更优，但实测 DSH 0.2.1-rc.5
并未提供 `/dsh-pet-7340/*` 接口（404，且整个 `app.asar` 中无相关代码），该功能在公开版 DSH 上不可用。
本仓库因此保留直连 API 的实现；若将来宿主提供该接口，只需替换 `runtime/agent-monitor.mjs` 中的取数逻辑。
