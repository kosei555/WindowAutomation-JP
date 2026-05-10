
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
Import-Module ".\module.psm1" -Force
[CommndNodeCommonConfig]::SetConfig()
$cmdRoot=CommandInit
$targetNode=GetCommandNode $cmdRoot "wa files open"
$targetNode.Exec("C:\temp")