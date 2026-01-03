操作指令集 (複製貼上用)
監控機 (Monitor) 安裝指令

wget run https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Monitor/InstallMonitor.lua
接收機 (Receiver) 安裝指令
(請把 RulePress1 換成你要用的規則名稱)


wget run https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Receiver/InstallReceiver.lua RulePress1
監控機規則更新指令

delete Rules/RuleMonitor.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RuleMonitor.lua Rules/RuleMonitor.lua
reboot
接收機規則更新指令
(請把 RulePress1 換成這台機器的規則名稱)

delete Rules/RulePress1.lua
wget https://raw.githubusercontent.com/aaa226898374-stack/testforCCLUN/main/Rules/RulePress1.lua Rules/RulePress1.lua
reboot
