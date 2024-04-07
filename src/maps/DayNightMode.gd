extends CanvasModulate

signal new_day
signal time_tick(day: int, hour: int, minutes: int)
@export var gradient: GradientTexture1D
@export var INGAME_SPEED = 1.0:
	set(sp):
		INGAME_SPEED = sp
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTES * INITIAL_HOUR * MINUTES_PER_HOUR
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTES = (2 * PI) / MINUTES_PER_DAY
var time: float = 0.0
var past_minute: float = -1.0
var past_day: int = -1

func _ready():
	time = INGAME_TO_REAL_MINUTES * INITIAL_HOUR * MINUTES_PER_HOUR

func _process(delta):
	self.time += delta * INGAME_TO_REAL_MINUTES * INGAME_SPEED
	var value = (sin(time - PI/2) + 1)/2
	self.color = gradient.gradient.sample(value)
	_recalculate_time()

func _recalculate_time():
	var total_minutes = int(time / INGAME_TO_REAL_MINUTES)
	var day = int(total_minutes/MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minutes = int(current_day_minutes % MINUTES_PER_HOUR)
	if not past_minute == minutes:
		past_minute = minutes
		time_tick.emit(day, hour, minutes)
	if not past_day == day:
		past_day = day
		emit_signal("new_day")
