🖥️ 1. 監控機 (Monitor)
負責掃描庫存，當物品不足時發送紅石訊號指令給接收機。

📥 安裝指令 (Install Command)
在監控電腦終端機輸入：

lua
wget run https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Monitor/InstallMonitor.lua
⚙️ 設定方法 (Configuration)
監控機的設定檔位於 Rules/RuleMonitor.lua。
安裝後，請輸入 edit Rules/RuleMonitor.lua 來修改監控清單。

格式範例：

lua
GetRules = {
  {
    Resource = "ftbmaterials:copper_plate", -- 要監控的物品名稱
    Low = 256,                              -- 低於此數量時觸發
    TargetID = 15,                          -- 目標接收機的電腦 ID (必填)
  },
  {
    Resource = "minecraft:coal",
    Low = 128,
    TargetID = 16,
  },
}
修改完後輸入 reboot 重啟生效。

📡 2. 接收機 (Receiver)
負責接收指令並輸出紅石訊號來啟動機器（如壓印機、熔爐）。

📥 安裝指令 (Install Command)
在接收電腦終端機輸入：

lua
-- 語法：wget run .../InstallReceiver.lua <規則檔名>
-- 範例：安裝壓印機1號的規則 (對應 GitHub 上的 Rules/RulePress1.lua)

wget run https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Receiver/InstallReceiver.lua RulePress1
⚠️ 重要： 安裝完成後，螢幕會顯示 ID: XX。請記下這個 ID 並填入監控機的設定檔中。

⚙️ 設定方法 (Configuration)
接收機的動作規則位於 Rules/RulePress1.lua (檔名視安裝時的參數而定)。
若要修改紅石輸出方向，請修改 GitHub 上的對應檔案，或在本地輸入 edit Rules/RulePress1.lua。

格式範例：

lua
PutRules = {
  ["ftbmaterials:copper_plate"] = {    -- 當收到「生產銅板」指令時
    Outputs = { { Side = "back" } }    -- 對「背面」輸出紅石訊號
  },
  ["ftbmaterials:iron_plate"] = {
    Outputs = { { Side = "top" } }     -- 對「上方」輸出紅石訊號
  },
}
修改完後輸入 reboot 重啟生效。

🔄 更新與維護 (Maintenance)
更新規則 (Update Rules)
如果你在 GitHub 上修改了規則，請在對應的電腦上執行：

監控機更新：

lua
delete Rules/RuleMonitor.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RuleMonitor.lua Rules/RuleMonitor.lua
reboot
接收機更新 (範例為 RulePress1)：

lua
delete Rules/RulePress1.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RulePress1.lua Rules/RulePress1.lua
reboot
查詢電腦 ID
lua
Tools/id
重置系統 (Reset)
刪除所有檔案並重新下載工具包 (設定檔會消失，請小心使用)：

lua
Tools/reset
