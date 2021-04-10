extends Panel

var my_int = 0

func _ready():
	Logger.trace(self,"This is a TRACE log")
	Logger.debug(self,"This is a DEBUG log")
	Logger.info(self,"This is a INFO log")
	Logger.warn(self,"This is a WARN log")
	Logger.error(self,"This is a ERROR log")
	Logger.fatal(self,"This is a FATAL log")

func _on_Timer_timeout():
	Logger.info(self,"my_int = %d",[my_int])
	my_int += 1
