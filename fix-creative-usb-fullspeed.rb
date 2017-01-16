#!/usr/bin/env ruby

require 'bundler/setup'
require "libusb"

VENDOR=0x041e
PRODUCT=0x3232

@usb = LIBUSB::Context.new
@device = @usb.devices( idVendor: VENDOR, idProduct: PRODUCT).first


def disconnect
  @device.open do |handle|
    handle.detach_kernel_driver(0)
  end
end


def send_vendor_command
  @device.open_interface(0) do |handle|
    handle.control_transfer(
       bmRequestType: 0x43,
       bRequest: 0x29,
       wValue: 1,
       wIndex: 2000
    )
  end
end

disconnect
send_vendor_command
