require "logger"
require "admiral"

class GpdFan < Admiral::Command
  @@logger = Logger.new(STDOUT)
  @@logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << message
  end
  @@inputs = Dir.glob("/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input")
  @@gpio = [] of String

  define_help description: "Temperatures are in Celsius!"
  define_flag min : UInt8,
     default: 55_u8,
     description: "Temperature required for minimum fan speed"
  define_flag med : UInt8,
     default: 65_u8,
     description: "Temperature required for med fan speed"
  define_flag max : UInt8,
     default: 80_u8,
     description: "Temperature required for maximum fan speed"
  define_flag time : UInt8,
     default: 10_u8,
     description: "Temperature polling interval in seconds"
  define_flag turbo : UInt8,
     default: 85_u8,
     description: "Temperature required to turn off turbo"
  define_flag feedback : Bool,
     default: true,
     description: "Set fan speed to minimum and sleep for 3 seconds on start"

  def run
    gpio_init
    if flags.feedback
      set_fan(1,0)
      sleep(3)
    end
    @@logger.info("regulating...")
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
    end
  end

  def temp
    temps = [] of UInt16
    @@inputs.each do |i|
      temps << (File.read(i).to_u16 / 1000)
    end
    temps.max
  end

  def set_fan(a,b)
    File.write(@@gpio[0], a)
    File.write(@@gpio[1], b)
  end

  def set_no_turbo(state)
    File.write("/sys/devices/system/cpu/intel_pstate/no_turbo", state)
  end

  def regulate
    case temp
    when .>= flags.max
      set_fan(1,1)
    when .>= flags.med
      set_fan(0,1)
    when .>= flags.min
      set_fan(1,0)
    when .>= flags.turbo
      set_no_turbo(1)
    else
      set_no_turbo(0)
      set_fan(0,0)
    end
  end
end

GpdFan.run
