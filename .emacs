(setq gc-cons-threshold 100000000)

(unless (boundp 'sw/user-init-d)
  (setq sw/user-init-d (file-name-directory (file-truename user-init-file))))
(add-to-list 'load-path (concat sw/user-init-d "packages"))
(add-to-list 'load-path (concat sw/user-init-d "private-packages/"))

(setq byte-compile-warnings nil)
(require 'cl)
(mapc
 (lambda(d) (add-to-list 'load-path d))
 (remove-if
  (lambda(d) (not (file-directory-p d)))
  (directory-files (concat sw/user-init-d "packages") t "^[^.]")))
(load (concat sw/user-init-d "packages/packages.el"))

(require 'use-package)
(mapc
 (lambda(d) (load d))
 (directory-files (concat sw/user-init-d "config/") t "config-"))

(autoload 'edit-at-point "edit-at-point" "edit at point" t)
(autoload 'idle-highlight-mode "idle-highlight-mode" "highlight the word the point is on" t)
(add-hook 'find-file-hook 'idle-highlight-mode)
;;(set-frame-font "-DAMA-Ubuntu-light-normal-normal-*-18-*-*-*-*-0-iso10646-1")
(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1")
