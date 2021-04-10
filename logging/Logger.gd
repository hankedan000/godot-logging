extends Node

var connection : StreamPeerTCP = null

enum LEVEL {
	TRACE,DEBUG,INFO,WARN,ERROR,FATAL
}

var global_threshold = LEVEL.INFO

# The maximum number of logs to buffer while host connection is down
const MAX_BUFFERED_LOGS = 1024

# Logs that are being temporarily buffered until the connection to the logger
# host is restored. If this list ever reached the MAX_BUFFERED_LOGS, then the
# oldest entry will be dropped.
var _buffered_logs = LinkedList.new()

# Number of logs that were dropped since the last time the Logger had a valid
# connection with the host
var _dropped_logs_since_last_connection = 0

func _ready():
	connection = StreamPeerTCP.new()
	
	var err = connection.connect_to_host("10.0.0.10", 4448)
	if err == OK:
		print("Connected to chainsaw!")
	
func _reconnect():
	# notify if any logs were dropped since previous connection
	if _dropped_logs_since_last_connection > 0:
		warn(self,
			"Logger connection was lost and %d logs were dropped",
			[_dropped_logs_since_last_connection])
		_dropped_logs_since_last_connection = 0

	# resend logs that were buffered while connection was down
	while _buffered_logs.size() > 0:
		var logdata = _buffered_logs.pop_front()
		var err = connection.put_data(logdata)
		if err != OK and not connection.is_connected_to_host():
			# host connection lost again... put log back into queue
			_buffered_logs.push_front(logdata)
		elif err != OK:
			print("Failed to write logging but connection to host is fine." +
				" Log is being dropped!" +
				" error code = %d" % err)
					
func trace(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.TRACE,msg_fmt,sub_strs)
	
func debug(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.DEBUG,msg_fmt,sub_strs)

func info(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.INFO,msg_fmt,sub_strs)

func warn(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.WARN,msg_fmt,sub_strs)

func error(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.ERROR,msg_fmt,sub_strs)

func fatal(node,msg_fmt,sub_strs = []):
	append(node,LEVEL.FATAL,msg_fmt,sub_strs)

func append(node,level,msg_fmt,sub_strs):
	if level < global_threshold:
		return
		
	# build user log message
	var msg = msg_fmt
	if len(sub_strs) > 0:
		msg = msg_fmt % sub_strs
	
	var logger = 'UnknownLogger'
	if node is Node:
		var path = node.get_path()
		logger = str(path)
		if path.is_absolute():
			if logger.find("/root",0) == 0:
				logger = logger.substr(6)
			elif logger.find("/global",0) == 0:
				logger = logger.substr(8)
		logger = logger.replace("/",".")
	elif node is String:
		logger = logger
	
	var level_str = LEVEL.keys()[level]
	var logxml = "<log4j:event logger=\"" + logger + "\""
	logxml += " timestamp=\"" + str(OS.get_system_time_msecs()) + "\""
	logxml += " level=\"" + level_str + "\""
	logxml += " thread=\"0x0\">"
	logxml += "<log4j:message><![CDATA[" + msg + "]]></log4j:message>"
	logxml += "</log4j:event>"
	
	var logdata = logxml.to_utf8()
	if connection.is_connected_to_host():
		var err = connection.put_data(logdata)
		if err != OK:
			_buffer_logdata(logdata)
	else:
		_buffer_logdata(logdata)

func _buffer_logdata(logdata):
	_buffered_logs.push_back(logdata)
	if _buffered_logs.size() > MAX_BUFFERED_LOGS:
		_dropped_logs_since_last_connection += 1
		_buffered_logs.pop_front()
