

### Fix for creative USB Sound Blaster HD working as USB full-speed device (USB 1.1)

This little Ruby script switches Creative USB Sound Blaster HD
(`vid: 0x041e pid: 0x3232)` from USB full-speed mode to USB high-speed mode
so it's possible to use it with higher bitrate/bit depth combinations under linux


### How to setup

1. Install ruby
2. Install bundler gem (http://bundler.io/) or simply `sudo gem install bundler --no-ri --no-rdoc`
3. Install app dependencies (just run `bundler` from checkout directory)


### How to call it

You need to run it as `root` to be able to detach kernel drivers etc.

Script doesn't expect parameters so following should be enough:
```
$ sudo ./fix-creative-usb-fullspeed.rb -m hispeed
```

If you want to go back to `fullspeed` just pass it instead of `hispeed`
to script:
```
$ sudo ./fix-creative-usb-fullspeed.rb -m fullspeed
```


### How to check whether it did something

#### Check USB tree before calling script
`$ sudo lsusb -t`:
```
[...]
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/16p, 480M
    |__ Port 1: Dev 41, If 5, Class=Human Interface Device, Driver=usbhid, 12M
    |__ Port 1: Dev 41, If 3, Class=Audio, Driver=snd-usb-audio, 12M
    |__ Port 1: Dev 41, If 1, Class=Audio, Driver=snd-usb-audio, 12M
    |__ Port 1: Dev 41, If 4, Class=Audio, Driver=snd-usb-audio, 12M
    |__ Port 1: Dev 41, If 2, Class=Audio, Driver=snd-usb-audio, 12M
    |__ Port 1: Dev 41, If 0, Class=Audio, Driver=snd-usb-audio, 12M
[...]
```

 
#### Check USB tree after calling script

`$ sudo lsusb -t`:
```
[...]
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/16p, 480M
    |__ Port 1: Dev 42, If 5, Class=Human Interface Device, Driver=usbhid, 480M
    |__ Port 1: Dev 42, If 3, Class=Audio, Driver=snd-usb-audio, 480M
    |__ Port 1: Dev 42, If 1, Class=Audio, Driver=snd-usb-audio, 480M
    |__ Port 1: Dev 42, If 4, Class=Audio, Driver=snd-usb-audio, 480M
    |__ Port 1: Dev 42, If 2, Class=Audio, Driver=snd-usb-audio, 480M
    |__ Port 1: Dev 42, If 0, Class=Audio, Driver=snd-usb-audio, 480M
[...]
```

You should notice that USB now reports 480M (USB high-speed) instead of
12M (aka USB full-speed). Yay!
