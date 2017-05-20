#If TARGET="android"
Import "native/log.${TARGET}.${LANG}"

Extern

Function Write:Void(tag:String = "lp2",message:String)="LpLog.Write"
#End