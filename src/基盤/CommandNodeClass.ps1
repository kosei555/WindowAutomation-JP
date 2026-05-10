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

