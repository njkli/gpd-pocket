require "logger"
require "admiral"

class GpdFan < Admiral::Command
  @@inputs = Dir.glob("/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input")
  @@gpio = [] of String
  @@logger = Logger.new(STDOUT)
  @@logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << message
  end

  define_help description: "Temperatures are in Celsius!"
  define_flag min : UInt8,
     default: (ENV.keys.includes?("MIN") ? ENV["MIN"].to_u8 : 55_u8),
     description: "Temperature required for minimum fan speed"
  define_flag med : UInt8,
     default: (ENV.keys.includes?("MED") ? ENV["MED"].to_u8 : 65_u8),
     description: "Temperature required for med fan speed"
  define_flag max : UInt8,
     default: (ENV.keys.includes?("MAX") ? ENV["MAX"].to_u8 : 80_u8),
     description: "Temperature required for maximum fan speed"
  define_flag time : UInt8,
     default: (ENV.keys.includes?("TIME") ? ENV["TIME"].to_u8 : 10_u8),
     description: "Temperature polling interval in seconds"
  define_flag turbo : UInt8,
     default: (ENV.keys.includes?("TURBO") ? ENV["TURBO"].to_u8 : 85_u8),
     description: "Temperature required to turn off turbo"
  define_flag feedback : Bool,
     default: ((ENV.keys.includes?("FEEDBACK") && ENV["FEEDBACK"] == "false") ? false : true),
     description: "Set fan speed to minimum and sleep for 3 seconds on start"
  define_flag loglevel : String,
     default: (ENV.keys.includes?("LOGLEVEL") ? ENV["LOGLEVEL"] : "info"),
     description: "Values are [debug, info, warn, error, fatal, unknown]"

  def run
    @@logger.level = Logger::Severity.parse(flags.loglevel.capitalize)
    @@logger.info "Starting..."
    gpio_init
    if flags.feedback
      set_fan(1,0)
      sleep(3)
    end
    while true
      regulate
      sleep(flags.time)
    end
  end

  def gpio_init
    [397, 398].each do |i|
      pin = "/sys/class/gpio/gpio#{i.to_s}/value"
      ctl = "/sys/class/gpio/export"
      File.write(ctl, i) unless File.writable?(pin)
      @@gpio << pin
      @@logger.debug "Found #{pin}!"
    end
  end

  def temp
    temps = [] of UInt16
    @@inputs.each do |i|
      temps << (File.read(i).to_u16 / 1000)
    end
    @@logger.debug "CPU temp: #{temps.max}C"
    temps.max
  end

  def set_fan(a,b)
    File.write(@@gpio[0], a)
    File.write(@@gpio[1], b)
    @@logger.debug "Wrote [#{a},#{b}] to fan gpio"
  end

  def set_no_turbo(state)
    File.write("/sys/devices/system/cpu/intel_pstate/no_turbo", state)
    @@logger.debug "no_turbo is #{state}"
  end

  def regulate
    case temp
    when .>= flags.max
      set_fan(1,1)
      @@logger.info "Set on MAX"
    when .>= flags.med
      set_fan(0,1)
      @@logger.info "Set on MED"
    when .>= flags.min
      set_fan(1,0)
      @@logger.info "Set on MIN"
    when .>= flags.turbo
      set_no_turbo(1)
      @@logger.info "TURBO off"
    else
      set_no_turbo(0)
      set_fan(0,0)
      @@logger.debug "TURBO on, Fan off"
    end
  end
end

GpdFan.run
