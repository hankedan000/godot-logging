extends Panel

var logger : Logger = null
var my_int = 0

func _ready():
	Logging.init_basic_logging()
	Logging.add_appender(XML_SocketAppender.new())
	logger = Logging.get_logger(self)
	logger.trace("This is a TRACE log")
	logger.debug("This is a DEBUG log")
	logger.info("This is a INFO log")
	logger.warn("This is a WARN log")
	logger.error("This is a ERROR log")
	logger.fatal("This is a FATAL log")

func _on_Timer_timeout():
	logger.info("my_int = %d",[my_int])
	my_int += 1
