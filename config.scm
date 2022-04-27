;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Asia/Bishkek")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guixbox")
  (users (cons* (user-account
                  (name "kamil")
                  (comment "Kamil Shakirov")
                  (group "users")
                  (home-directory "/home/kamil")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package
              "emacs-desktop-environment")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
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
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "17eac23d-3f36-4ea4-aa99-537571620d0a"))
            (target "system-root")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/system-root")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
