#!/usr/bin/ruby

require "bundler/setup"
require "libusb"
require "optparse"

class CreativeUSBModeFixer

  attr_reader :run

  VENDOR=0x041e
  PRODUCT=0x3232

  CONTROL_REQUEST_PARAMS = {
    hispeed: {
        bmRequestType: 0x43,
        bRequest: 0x29,
        wValue: 1,
        wIndex: 2000
    },
    fullspeed: {
        bmRequestType: 0x43,
        bRequest: 0x29,
        wValue: 0,
        wIndex: 2000
    }
  }

  INTERFACE_ID = 0

  def initialize
    @usb = LIBUSB::Context.new
    @device = @usb.devices( idVendor: VENDOR, idProduct: PRODUCT).first

    parse_opts

  end

  def parse_opts
    OptionParser.new do |opts|
      opts.on("-m","--mode USB_MODE",[:fullspeed,:hispeed]) do |mode|
        @mode = mode
      end
    end.parse!

  end

  def disconnect_drivers
    @device.open do |handle|
      handle.detach_kernel_driver(INTERFACE_ID)
    end
  end

  def switch_usb_mode(mode)
    @device.open_interface(INTERFACE_ID) do |handle|
      handle.control_transfer(CONTROL_REQUEST_PARAMS[mode])
    end
  end

  def switch_to_usb_hispeed
    switch_usb_mode(:hispeed)
  end

  def switch_to_usb_fullspeed
    switch_usb_mode(:fullspeed)
  end

  def get_current_mode
    if @device.device_speed == :SPEED_FULL
      return :fullspeed
    elsif @device.device_speed == :SPEED_HIGH
      return :hispeed
    end
  end

  def run
    if @mode.nil?
      puts "no mode selected!"
    end

    if get_current_mode == @mode
      puts "device is already in mode #{@mode}"
      return true
    end

    puts "switching device to mode #{@mode}"

    if @device.nil?
      STDERR.puts "Unable to find device VID=0x0%04x/PID=0x%04x" % [VENDOR,PRODUCT]
      return false
    end

    begin
      disconnect_drivers
    rescue => e
      STDERR.puts "Failed to disconnect kernel modules from device! (exception: #{e})"
    end

    begin
      switch_usb_mode(@mode)
    rescue => e
      STDERR.puts "Failed to switch device to HiSpeed mode! (exception: #{e})"
    end
  end

end

CreativeUSBModeFixer.new.run
