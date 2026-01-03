AI寫來自己玩的
CC:Tweaked 工廠自動化控制系統
由 Monitor (監控端) 與多個 Receiver (接收端) 組成。監控端負責掃描庫存，當物品不足時，發送訊號給指定 ID 的接收端來啟動機器。

📂 檔案結構
Monitor/ - 監控端程式與安裝檔

Receiver/ - 接收端程式與安裝檔

Rules/ - 所有的設定檔都在這裡 (包含監控清單與機器動作)

Tools/ - 工具組 (reset, id, scan)

🛠️ 新增一台機器 (Receiver) 的流程
1. GitHub 端：建立新規則
在 Rules/ 資料夾中新增一個檔案，例如 RulePress2.lua（壓印機2號）：

lua
return {
  PutRules = {
    -- 當收到 "生產鐵板" 指令時，對 "back" 發出紅石訊號
    ["ftbmaterials:iron_plate"] = {
      Outputs = { { Side = "back" } }
    },
  }
}
2. Minecraft 端：安裝接收機
在新的電腦上輸入安裝指令（注意最後的參數要對應剛剛的檔名）：

lua
wget run https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Receiver/InstallReceiver.lua RulePress2
⚠️ 重要： 安裝完成後，螢幕會顯示 ID: XX (例如 18)，請記下這個數字！

3. GitHub 端：更新監控清單
編輯 Rules/RuleMonitor.lua，加入新機器的監控項目：

lua
{
  Resource = "ftbmaterials:iron_plate",
  Low = 64,       -- 低於 64 個就生產
  TargetID = 18,  -- 填入剛剛記下的 ID
},
4. Minecraft 端：更新監控機
回到監控電腦，更新它的規則檔（見下方指令）。

🔄 更新規則 (Update Rules)
當你在 GitHub 上修改了規則後，需要在遊戲內更新才會生效。

更新監控機 (Monitor)
在監控電腦上執行：

lua
delete Rules/RuleMonitor.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RuleMonitor.lua Rules/RuleMonitor.lua
reboot
更新接收機 (Receiver)
假設這台是 RulePress1，在接收電腦上執行：

lua
-- 把 RulePress1 換成這台機器的規則名
delete Rules/RulePress1.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RulePress1.lua Rules/RulePress1.lua
reboot
⚠️ 故障排除與工具
萬用重置 (Reset)
如果你把設定搞亂了，或程式出錯修不好，執行這個指令會刪除所有檔案並重新下載最新版工具（除了 Tools 資料夾）：

lua
Tools/reset
(執行後需重新跑 wget run .../Install... 安裝指令)

查詢 ID
忘記這台電腦 ID 是多少？

lua
Tools/id
掃描庫存 (Scan)
監控機抓不到物品？用這個檢查週邊名稱與內容：

lua
Tools/scan <週邊名稱>
-- 範例：
Tools/scan functionalstorage:oak_1_0
