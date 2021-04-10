extends Panel

var logger : Logger = null

onready var fps_line_edit = $FPS/LineEdit
onready var vis_log_dur_line_edit = $VisibleLogDur/LineEdit
onready var hidden_log_dur_line_edit = $HiddenLogDur/LineEdit
onready var formatted_log_dur_line_edit = $FormattedLogDur/LineEdit

func _ready():
#	Logging.init_basic_logging()
	Logging.add_appender(XML_SocketAppender.new())
	logger = Logging.get_logger(self)
	
func _process(delta):
	fps_line_edit.text = str(Engine.get_frames_per_second())

func _on_Timer_timeout():
	var NUM_ITERATIONS = 1000
	
	var start_time = OS.get_system_time_msecs()
	for i in range(NUM_ITERATIONS):
		logger.info("This is a really spammy log!")
	var delta_time = OS.get_system_time_msecs() - start_time
	vis_log_dur_line_edit.text = "%dms total (%dus/log)" % [delta_time,delta_time*1000.0/NUM_ITERATIONS]
	
	start_time = OS.get_system_time_msecs()
	for i in range(NUM_ITERATIONS):
		logger.debug("This is a really spammy log!")
	delta_time = OS.get_system_time_msecs() - start_time
	hidden_log_dur_line_edit.text = "%dms total (%dus/log)" % [delta_time,delta_time*1000.0/NUM_ITERATIONS]
	
	start_time = OS.get_system_time_msecs()
	for i in range(NUM_ITERATIONS):
		logger.info("This is a really %s log!",["spammy"])
	delta_time = OS.get_system_time_msecs() - start_time
	formatted_log_dur_line_edit.text = "%dms total (%dus/log)" % [delta_time,delta_time*1000.0/NUM_ITERATIONS]
