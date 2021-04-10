extends Panel

var logger : Logger = null

func _ready():
	Logging.init_basic_logging()
	Logging.add_appender(XML_SocketAppender.new())
	logger = Logging.get_logger(self)
	
func _process(delta):
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
	logger.info("This is a really spammy log!")
