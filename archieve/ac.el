(add-to-list 'load-path "~/.elisp/fuzzy")
(add-to-list 'load-path "~/.elisp/auto-complete")
(add-to-list 'load-path "~/.elisp/ac-emoji/")
(require 'ac-emoji)
(set-fontset-font
 t 'symbol
 (font-spec :family "Symbola") nil 'prepend)

(require 'auto-complete-config)
(defun ac-cc-mode-setup ()
  nil)
(defun auto-complete-mode-maybe ()
  "No maybe for you. Only AC!"
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))
(ac-config-default)

(setq-default ac-sources '(ac-source-dictionary ac-source-words-in-buffer ac-source-yasnippet))
(defun my-ac-common-setup ()
  (ac-emoji-setup)
  )
(add-hook 'auto-complete-mode-hook 'my-ac-common-setup)

(setq ac-auto-show-menu 0.5)
(setq ac-auto-start t)

(setq ac-delay 0.2)
(setq ac-menu-height 20)

(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "C-S-n") 'ac-next)
(define-key ac-completing-map (kbd "<tab>") nil)
(define-key ac-completing-map (kbd "C-S-p") 'ac-previous)
(ac-flyspell-workaround)

;; (add-to-list 'ac-user-dictionary-files "~/.elisp/ac-dict-1000-words")
(add-to-list 'ac-user-dictionary-files "~/.elisp/ac-dict-5000-words")

(require 'auto-complete-clang)
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
/usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../../include/c++/5.2.0
/usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../../include/c++/5.2.0/x86_64-unknown-linux-gnu
/usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/../../../../include/c++/5.2.0/backward
/usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/include
/usr/local/include
/usr/lib/gcc/x86_64-unknown-linux-gnu/5.2.0/include-fixed
/usr/include
"
               )))

(require 'racket-mode)
(ac-define-source racket
                  '((depends slime)
                    (candidates . (racket--complete-prefix ac-prefix))
                    (symbol . "s")
                    (cache)))
