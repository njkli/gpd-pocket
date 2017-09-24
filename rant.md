# Pros:
* Size! 7 inches is a convenient form factor.
* Outward build quality - It's slick and doesn't have many protruding parts, reminiscent of apple.
* the fact that it's x86_64 with 64bit EFI - bootctl and efibootvars with systemd-boot work just great!
* A tentative hope that linux support would improve by 4.15? - No thanks to GPD, a bunch of cool people are making progress on actually having a usable (Not on paper) linux system on this device.

# Cons:
* Active cooling is a bad idea on a mobile device!
The fan on this device is such a noisy one and is totally unnecessary! Considering that throttling kicks in at around 85C, there's no point in having a fan, it won't help performance, but it sure as hell is annoying!
* Again, active cooling allows for dust ingress and there's no filter present on device.
* Instead of specified 1600Mhz DRAM speed, we only get 1066Mhz, can't switch it - false advertising!
This should actually be investigated by opening the device and looking at part numbers on DRAM.
* CPU is locked at 1.6Ghz, no way to go beyond that - again, false advertising! We were promised up to 2.5Ghz bursts!
* BIOS or rather uEFI - total jumble of stuff from different OEMs, kinda variations on AMI firmware.
Feels like it's a huge kludge of code, without any CI/QA or any kind of testing at all, aside from the stamp of approval by less savvy engineers, who tried and failed miserably at playing a role of regular users.
* Keyboard Size!
2cm is missing in length to accommodate a proper keyboard. Nobody thought it through, what a pity!
* Very weird placement of key keys (yes, pun intended, but it makes perfect sense).
* Most used keys are located at most inconvenient locations, ie '[TAB]', '|', '[DEL]', 'BACKSPACE', '~', '-', '=', '[{', '}]'
* Some of us actually type more then an occasional password on keyboards, don't make us relinquish decades of muscle memory.
* Most annoying is the '<>/', ',./' keys size (a dot, a slash and shell redirects...) __Have any of those designers ever used a keyboard at all?__
* USB-C support is lacking - HDMI, ethernet, sound, none of those work. the type C loses all of it's appeal and serves only as a charging port!

# Uber-cons (Rant):
Disclosure: I've been an IT engineer for 25+ years (never ran redmond beyond MS-DOS and don't intend to start), it took me a few hours to get going with whatever I deigned it acceptable to run on this device.

#### The decidedly silly epitome of enchanting asininity, the 'crème de la crème' of imbecilic absurdity, the indubitably nearsighted lunacy of a nonsense (drum roll please!):
* OEM completely missing the brief with this product!
There are literally hundreds of redmond devices of every make and model, in any price range, the market never needed another one of those, everybody was sold on a promise of awesome Linux support from the get-go. The indiegogo campaign got so lucky only because of that - the form factor and a promise of linux support!
* The pain - there's only a single dude (afaik) working on mainlining patches into the kernel.
This awesome human being is doing it pro-bono, an enthusiast that has done more to have Linux run properly on gpd devices, than the OEM itself.
* Linux support overall feels like an afterthought on part of gpd.
At least there are enough enthusiasts to help alleviate all the pain of having it run on the device.
* The level of linux support is exactly the same as with all other Cherrytrail devices that don't officially support it!
I spent the same amount of time having Chuwi, Teclast, Onda and others run whatever I wanted to run, as with Gpd pocket.
Yet again, no reason to have marketed it as a linux device!
* Same kind of hoops to jump through!
Get an rc kernel, reconcile configs with my own, compile, create systemd units and udev rules, work around hardware quirks, tweak pulseaudio, ucm profile, discover gpios, write a bunch of scripts to tie everything together, reboot a couple of times, scrounge out firmware binary blobs from weird places, adjust xorg.conf, adjust touchscreen calibration, the list goes on...

# Conclusions:
* This is a collectible item!
* A nice example of what 'classical' computing was being imagined to be like in 2017.
Over the years there have been many attempts at this or comparable form factor PC-style units, remember Toshiba libretto (I used to own both incarnations) and Thinkpad 701 (the quality and usability of a keyboard on this one was exceptional, I loved every minute spent working on it).
* Today, the only excuse to own a Gpd pocket:

The fact that at 8Gigs RAM and VTx support this little bastard runs a bunch of coreos kubernetes nodes on kvm and still allows to have emacs and a browser opened.

If you're fine with adjusting your typing habits a fare amount and are prepared to suffer from poor bluetooth audio support and substantially subspec Wifi network speeds (at least until 4.13 comes out or perhaps indefinitely or at least until someone decides to grow a pair and mainline a proper driver)

* Use cases / the unit would be a fine companion for:
* datacenter trips
* short coding sessions
* remote support
* perhaps even outings to a customer site once in a while.
* The only advantage over any other mobile device is the ability to run fresh kvm/docker on bleeding edge kernels 'in-place', at your fingertips with d-trace and whatnot.
* Did I already mention that emacs runs fine on this device? For those who are suffering from self-imposed penance of using vi, your  runs great ;-)
* Am I going to return this purchase for a refund?

__Decidedly NOT!__ (unless it has some hardware defect or exhibits symptoms of such during the next few weeks.)

## Looking forward to:
* In time, probably (more likely then not, that is) better support for wifi/bluetooth.
* Nice attempts at power management and fan control already got better (again, no thanks to Gpd, at least afaik), the gentle folk on github deserve another round of applause, you know who you are and all the rest of us lazy-ass whining '-- original expletive replaced with \females of canine species\ --' are eternally thankful to you!
* Gpd stepping up and starting to give a damn about things beyond sales figures and marketing pitches - Man up and own your product!

### I doubt anyone from Gpd will ever read this diatribe, but just in-case:
* Please think of usability next time you decide to make a product. Even when using a mishmash of half-compatible components, the simple presence of familiar keyboard layout goes a very long way towards alleviating the rest of inevitable annoyances.
* Active cooling is a 'no! no!' on mobile devices! 2 reasons - Dust and Noise!

#### To all the redmond lovers I send my warmest regards and sincere wishes to get well and finally run an OS instead of gigabytes of malware on their compute units!
