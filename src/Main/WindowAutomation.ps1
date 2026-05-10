class CommndNodeCommonConfig{
    static [String]$ROOT_CMD_NAME
    static SetConfig(){
        [CommndNodeCommonConfig]::ROOT_CMD_NAME="wa"

    }
}
class CommandNode{
    [hashtable] $m_commandChildren
    [String] $m_commandNodeName
    CommandNode([String]$commandNodeName){
        $this.m_commandChildren=@{}
        $this.m_commandNodeName=$commandNodeName
    }
    #[String]GetChildrenName(){
    #}
    [CommandNode]GetChild([String] $commandNodeName){
        return $this.m_commandChildren[$commandNodeName]
    }
    RegisterCommand([String] $commandNodeName){
        $this.m_commandChildren[$commandNodeName]=[CommandFactory]::Create($commandNodeName)
    }


}
class CommandFactory{
    static [CommandNode] Create ([String]$commandNodeName){
        switch($commandNodeName){
            "open"{
                return [CommandOpen]::new()
            }
            "close"{
                return [CommandClose]::new()
            }
            default{
                return [CommandNode]::new($commandNodeName)
            }
        }
        throw "error in CommandFactory.Create"
    }
}
class CommandOpen : CommandNode{
    CommandOpen() : base ("open"){
    }
    Exec([String]$folderPath){
        $targetFiles=Get-ChildItem -Path $folderPath -File | Where-Object{$_.Name -Like "*.lnk"}
        ForEach ($file In $targetFiles){
            Start-Process $file.FullName
        }

    }
}
class CommandClose : CommandNode{
        CommandClose() : base ("close"){
    }
    Exec([String]$folderName){
        
    }
}

function CommandInit(){#将来的にはJSONファイル読み込ませる
    $cmd = [CommandNode]::new([CommndNodeCommonConfig]::ROOT_CMD_NAME)
    $cmd.RegisterCommand("files")
    $cmd.GetChild("files").RegisterCommand("open")
    return $cmd
}

function GetCommandNode([CommandNode]$cmdRoot,[String]$command){#誤ったコマンド打ち込んだ時の処理を追加する必要性あり
    $queue = New-Object System.Collections.Queue
    $strBuf=""
    $cmdNode=$null
    $ea = [ExecArgs]::new()

    For ($i=0;$i -lt $command.Length;$i=$i+1){
        If($command[$i] -eq " "){
            $queue.Enqueue($strBuf)
            $strBuf=""
        }
        Else {
            $strBuf=$strBuf + $command[$i]
        }
    }
    $queue.Enqueue($strBuf)
    while($queue.Count -gt 0){
        $queContent=$queue.Dequeue()
        if($queContent -eq [CommndNodeCommonConfig]::ROOT_CMD_NAME){
            $cmdNode=$cmdRoot

        }
        else{
            $cmdNode=$cmdNode.GetChild($queContent)
        }
    }
    return $cmdNode
}
[CommndNodeCommonConfig]::SetConfig()
$cmdRoot=CommandInit
$targetNode=GetCommandNode $cmdRoot "wa files open"
$targetNode.Exec("C:\temp")
