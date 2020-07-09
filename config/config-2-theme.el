;; --- solarized
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/emacs/theme/solarized/")
;; (add-to-list 'load-path "~/.emacs.d/emacs/theme/solarized/")
;; (require 'solarized)
;; (setq solarized-use-variable-pitch nil)
;; (setq solarized-high-contrast-mode-line nil)
;; (setq solarized-use-less-bold t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'solarized-light t)

;; --- zenburn
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/emacs/theme/zenburn/")
;; (load-theme 'zenburn t)

;; --- drachla
(add-to-list 'custom-theme-load-path (concat sw/user-init-d "theme/dracula"))
(load-theme 'dracula t)

;; |中英文应该能够对齐|
;; |zh en should align|
(unless (string= window-system "x")
  (require 'unicode-fonts)
  (unicode-fonts-setup))

(defun sw/apply-font ()
  ;; (set-frame-font "Monaco-11" nil t)
  ;;  (set-frame-font "Consolas-11" nil t)
  ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
  ;;    (set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1"))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font t charset (font-spec :family "Microsoft Yahei"
                                           :size 18))))
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (select-frame frame)
            (sw/apply-font)
            (if (window-system frame)
                (sw/apply-font))))

(if window-system
    (sw/apply-font))

(setq-default line-spacing 5)
