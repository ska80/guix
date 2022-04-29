(use-modules (gnu)
             (gnu packages shells))
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))

 (host-name "guixbox")
 (locale "en_US.utf8")
 (timezone "Asia/Bishkek")
 (keyboard-layout (keyboard-layout "us" #:model "thinkpad"))

 (users
  (cons* (user-account
          (name "kamil")
          (comment "Kamil Shakirov")
          (group "users")
          (home-directory "/home/kamil")
          (supplementary-groups
           '("wheel" "netdev" "audio" "video"))
          (shell (file-append zsh "/bin/zsh")))
         %base-user-accounts))

 (packages
  (append
   (map specification->package
        '("zsh" "mc"
          "htop" "powertop"
          "emacs" "vim"
          "ffmpeg" "mpv"
          "gnupg@2" "nss-certs"))
   %base-packages))

 (services
  (append
   (list (service openssh-service-type
                  (openssh-configuration
                   (port-number 711)
                   (permit-root-login #f)
                   (allow-empty-passwords? #f)))
         (service tor-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout))))
   %desktop-services))

 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (target "/boot/efi")
   (keyboard-layout keyboard-layout)))

 (swap-devices
  (list (uuid "510e1e76-8337-4db0-ad6d-cc90228de721")))

 (mapped-devices
  (list (mapped-device
         (source
          (uuid "17eac23d-3f36-4ea4-aa99-537571620d0a"))
         (target "system-root")
         (type luks-device-mapping))))

 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "F872-B72A" 'fat))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device "/dev/mapper/system-root")
          (type "ext4")
          (dependencies mapped-devices))
         %base-file-systems)))
