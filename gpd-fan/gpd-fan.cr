require "logger"
require "admiral"

class GpdFan < Admiral::Command
  SPEED = {"max" => [1,1], "med" => [0,1], "min" => [1,0 ], "off" => [0,0]}
  @@inputs = Dir.glob("/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input")
  @@gpio = [] of String
  @@logger = Logger.new(STDOUT)
  @@logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << "[#{severity}] "
    io << message
  end

  define_version "1.0.0"
  define_help description: "Temperatures are in Celsius!"
  define_flag min : Int32,
     default: (ENV.keys.includes?("MIN") ? ENV["MIN"].to_i32 : 55_i32),
     description: "Temperature required for minimum fan speed"
  define_flag med : Int32,
     default: (ENV.keys.includes?("MED") ? ENV["MED"].to_i32 : 65_i32),
     description: "Temperature required for med fan speed"
  define_flag max : Int32,
     default: (ENV.keys.includes?("MAX") ? ENV["MAX"].to_i32 : 80_i32),
     description: "Temperature required for maximum fan speed"
  define_flag time : Int32,
     default: (ENV.keys.includes?("TIME") ? ENV["TIME"].to_i32 : 10_i32),
     description: "Temperature polling interval in seconds"
  define_flag turbo : Int32,
     default: (ENV.keys.includes?("TURBO") ? ENV["TURBO"].to_i32 : 85_i32),
     description: "Temperature required to turn off turbo"
  define_flag speed : String,
     short: s,
     long: speed,
     description: "Set fan speed [off, min, med, max] manually and exit"
  define_flag loglevel : String,
     default: (ENV.keys.includes?("LOGLEVEL") ? ENV["LOGLEVEL"] : "info"),
     description: "Values are [debug, info, warn, error, fatal, unknown]"
  define_flag feedback : Bool,
     default: ((ENV.keys.includes?("FEEDBACK") && ENV["FEEDBACK"] == "false") ? false : true),
     description: "Set fan speed to minimum and sleep for 3 seconds on start"

  define_flag daemon : Bool,
     short: d,
     long: daemon,
     description: "false = use with systemd-timer, true = manage the timer ourselves"

  def run
    @@logger.level = Logger::Severity.parse(flags.loglevel.capitalize)
    gpio_init
    flags.daemon ? daemon : (flags.speed ? speed(flags.speed) : regulate)
  end

  def gpio_init
    [397, 398].each do |i|
      pin = "/sys/class/gpio/gpio#{i.to_s}/value"
      ctl = "/sys/class/gpio/export"
      File.write(ctl, i) unless File.writable?(pin)
      @@gpio << pin
      @@logger.debug "Initialized #{pin}"
    end
  end

  def speed(val)
    @@logger.info "#{val} speed" unless val == "off"
    val = SPEED[val]
    File.write(@@gpio[0], val[0])
    File.write(@@gpio[1], val[1])
    @@logger.debug "GPIO [397 => #{val[0]}, 398 => #{val[1]}]"
  end

  def turbo(state)
    File.write("/sys/devices/system/cpu/intel_pstate/no_turbo", (state == 1 ? 0 : 1))
    @@logger.debug "Turbo is #{state}"
  end

  def daemon
    if flags.feedback
      @@logger.info "nozzle check..."
      speed("min")
      sleep(3)
    end
    while true
      regulate
      sleep(flags.time)
    end
  end

  def regulate
    temp = @@inputs.map { |i| File.read(i).to_i32 / 1000 }.max
    @@logger.debug "CPU: #{temp}C"
    case temp
    when .>= flags.max
      speed("max")
    when .>= flags.med
      speed("med")
    when .>= flags.min
      speed("min")
    when .>= flags.turbo
      turbo(0)
      @@logger.info "TURBO off"
    else
      turbo(1)
      speed("off")
    end
  end
end

GpdFan.run
