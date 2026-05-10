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
        }
        return [CommandNode]::new()
    }
}
class CommandOpen : CommandNode{
    CommandOpen() : base ("open"){
    }
    Exec([String]$folderPath){
        $targetFiles=Get-ChildItem -Path $folderPath -File | Where-Object{$_.Name -Like "*.lnk"}
        ForEach ($file In $targetFiles){
            start-Proces $file.FullName
        }

    }
}
class CommandClose : CommandNode{
        CommandClose() : base ("close"){
    }
    Exec([String]$folderName){
        
    }
}

function CommandLoad(){#将来的にはJSONファイル読み込ませる
    $cmd = [CommandNode]::new("wa")
    $cmd.RegisterCommand("files")
    $cmd.GetChild("files").RegisterCommand("open")

}