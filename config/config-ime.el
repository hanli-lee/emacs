(defun sw/load-eim()
  (require 'eim-extra)
  (autoload 'eim-use-package "eim" "Another emacs input method")
  (setq eim-use-tooltip nil)
  (setq eim-punc-translate-p nil)         ; use English punctuation
  (defun my-eim-py-activate-function ()
    (add-hook 'eim-active-hook
              (lambda ()
                (let
                    ((map
                      (eim-mode-map)))
                  (define-key eim-mode-map "-" 'eim-previous-page)
                  (define-key eim-mode-map "=" 'eim-next-page)))))
  (register-input-method "eim-wb" "euc-cn" 'eim-use-package "WuBi/" "EIM Chinese Wubi Input Method"
                         "wb.txt" 'my-eim-py-activate-function)
  (set-input-method "eim-wb")           ; use Pinyin input method
  (setq activate-input-method t)        ; active input method
  (toggle-input-method nil)               ; default is turn off
  (eval-after-load 'eim '(global-set-key ";" 'eim-insert-ascii)))

(defun sw/load-fcitx ()
  (global-unset-key (kbd "C-\\"))
  (require 'fcitx)
  (fcitx-aggressive-setup)
  (fcitx-prefix-keys-add "C-x" "C-c" "C-h" "M-s" "M-o" "C-o")
  (fcitx-prefix-keys-turn-on)
  (fcitx-isearch-turn-on)
  (defun sw/fcitx-deactivate ()
    (setq fcitx--prefix-keys-disabled-by-elisp nil)
    (ignore-errors
      (fcitx--deactivate)))
  (defadvice y-or-n-p (after deactivate-fcitx-quit activate)
    (sw/fcitx-deactivate))
  (defadvice keyboard-quit (before deactivate-fcitx-quit activate)
    (sw/fcitx-deactivate)))

(if (and (string= (getenv "LC_ALL") "zh_CN.UTF-8")
        (with-executable "fcitx"))
    (sw/load-fcitx)
  (sw/load-eim))
