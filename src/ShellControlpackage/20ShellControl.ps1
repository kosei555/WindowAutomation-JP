class ShellControl{

    static [String] Scan(){
        return Read-Host
    }
    static Print([String]$format,[object[]]$value){
        for($i=0;$i -lt $format.Length;$i=$i+1){
            if($format[$i] -eq '%'){
                switch($format[$i]){
                
                }
            }
            
        }
    }
}