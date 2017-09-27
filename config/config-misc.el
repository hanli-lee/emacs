(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(global-visual-line-mode t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq select-enable-clipboard t)
(setq x-select-enable-clipboard-manager t)
(setq custom-file (concat sw/user-init-d "config/config-custom.el"))
(setq bookmark-default-file (concat sw/user-init-d "misc/emacs.bmk"))
(add-hook 'write-file-hooks 'time-stamp)
(setq comment-style 'extra-line)
(setq-default cursor-type 'box)
(blink-cursor-mode t)
(setq ring-bell-function 'ignore)
(setq visible-bell nil)
(transient-mark-mode t)
(setq backup-inhibited t)
;; (setq tab-always-indent 'complete)
(global-font-lock-mode t)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; (add-hook 'after-init-hook
;;           (lambda()
;;             ;; (server-force-delete)
;;             (ignore-errors
;;               (server-start))))

(setq confirm-kill-emacs 'y-or-n-p)
(setq bookmark-save-flag 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq delete-auto-save-files t)
(setq inhibit-startup-message t)
(setq column-number-mode t)
(setq mouse-yank-at-point t)
(mouse-avoidance-mode 'cat-and-mouse)
(setq fill-column 80)
(setq major-mode 'text-mode)
(show-paren-mode t)
;; (setq show-paren-style 'mixed)
(setq frame-title-format
      '(:eval (concat "%b [" switch-desktop-mode-indicator "] -- Emacs")))
(setq user-mail-address "hl09083253cy@126.com")
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq adaptive-fill-regexp "[ \t]+\\|[ \t]*\\([0-9]+\\.\\|\\*+\\)[ \t]*")
(setq adaptive-fill-first-line-regexp "^\\* *$")
(custom-reset-variables '(mm-inline-override-types nil))

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  (flet
      ((process-list
        ()))
    ad-do-it))

(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(delete-selection-mode nil)
(setq history-length 1024)
(setq gdb-many-windows t)
(setq echo-keystrokes 0.1)
(setq show-trailing-whitespace t)
(modify-syntax-entry ?_ "_")
(setq default-line-spacing 0.2)

(global-unset-key (kbd "<insert>"))
(unify-8859-on-decoding-mode)

(use-package ediff
  :init (progn
          (setq ediff-window-setup-function 'ediff-setup-windows-plain)
          (setq ediff-split-window-function 'split-window-horizontally))
  :commands ediff)

;; (setq enable-recursive-minibuffers t)
;;(setq next-line-add-newlines t)
;; (when (and (locate-library "linum") (facep 'fringe))
;;   (setq linum-format (propertize "%4d " 'face 'fringe)))


(setq sentence-end "\\([¡££¡£¿]\\|¡­¡­\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]
*")

;; (cua-mode t)
(use-package undo-tree
  :config (progn
            (setq undo-tree-history-directory-alist `((".*" . ,(expand-file-name "~/.emacs.d/undo"))))
            (setq undo-tree-auto-save-history nil)
            (global-undo-tree-mode)))

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(require 'unicad)
(require 'midnight)

(use-package boxquote
  :commands boxquote-region)

(unless-run-as-daemon
 (use-package switch-desktop
   :ensure nil
   :config (progn
             (switch-desktop-mode t)
             (bind-key "C-x C-d" 'goto-session-root))))

(use-package saveplace
  :config (progn
            (if (functionp 'save-place-mode)
                (save-place-mode t)
              (setq-default save-place t))))

(define-key occur-mode-map (kbd "r") 'occur-edit-mode)

(use-package browse-kill-ring
  :bind ("M-y" . browse-kill-ring))

(prefer-coding-system 'utf-8-unix)
;; (setq coding-system-for-read 'utf-8-unix)
;; (setq coding-system-for-write 'utf-8-unix)

;; (setq url-proxy-services '(("no_proxy" . "work\\.com")
;;                            ("http" . "127.0.0.1:1080")))

(use-package markdown-mode
  :mode "\\.md")

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(require 'hl-line)
;; (global-hl-line-mode 1)
(setq hl-line-sticky-flag nil)

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :bind ("C-M-o" . er/expand-region))

(use-package ansi-color
  :init (progn
          (defun sw/colorize-compilation-buffer ()
            (when (eq major-mode 'compilation-mode)
              (ansi-color-apply-on-region compilation-filter-start (point-max))))
          (add-hook 'compilation-filter-hook 'sw/colorize-compilation-buffer))
  :commands ansi-color-apply-on-region)

(use-package calc
  :config (bind-key "C-/" 'calc-undo calc-mode-map))

(use-package tintin-mode
  :mode "\\.tin"
  :config (progn
            (add-hook 'tintin-mode-hook
                      (lambda ()
                        (add-hook 'local-write-file-hooks 'delete-trailing-whitespace)
                        (add-hook 'local-write-file-hooks 'check-parens)))))

(use-package pdftools
  :commands print-buffer-to-pdf)

(defalias 'perl-mode 'cperl-mode)
(defalias 'mbm 'menu-bar-mode)

(use-package popup
  :commands popup-tip)

(use-package visual-regexp
  :bind ("M-%" . vr/query-replace))

(use-package hungry-delete
  :config (global-hungry-delete-mode t))

(unless-run-as-daemon
 (use-package workgroups2
   :init (setq wg-prefix-key (kbd "C-o"))
   :config (progn
             (workgroups-mode 1)
             (add-hook 'after-make-frame-functions
                       (lambda (frame)
                         (ignore-errors
                           (select-frame frame)
                           (wg-switch-to-workgroup-at-index-0))))
             (defadvice wg-create-workgroup (after sw/wg-save-session activate)
               (save-session))
             (defadvice wg-kill-workgroup (after sw/wg-save-session activate)
               (save-session))
             (defadvice wg-rename-workgroup (after sw/wg-save-session activate)
               (save-session)))))

(use-package anzu
  :config (progn
            (global-anzu-mode +1)
            (set-face-attribute 'anzu-mode-line nil
                                :foreground "yellow"
                                :weight 'bold)
            (setq anzu-mode-lighter "")
            (setq anzu-deactivate-region t)
            (setq anzu-search-threshold 100)
            (setq anzu-replace-to-string-separator " => ")))

(use-package multiple-cursors
  :init (defun sw/mc-mark-lines()
          (interactive)
          (if (region-active-p)
              (call-interactively 'mc/edit-lines)
            (call-interactively 'mc/mark-next-lines)))
  :config (progn
            (bind-key "M-l" 'mc/vertical-align-with-space mc/keymap))
  :commands (mc/cycle-forward mc/cycle-backward mc/add-cursor-on-click mc/mark-all-dwim
                              mc/mark-next-symbol-like-this set-rectangular-region-anchor
                              mc/edit-lines mc/mark-next-lines)
  :bind (("<C-return>" . sw/mc-mark-lines)
         ("<M-down-mouse-1>" . mc/add-cursor-on-click)))
;; (global-set-key (kbd "<C-return>") 'set-rectangular-region-anchor)

(add-hook 'find-file-hook
          '(lambda()
             (setq minor-mode-alist nil)))

(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message nil)

(setq-default indent-tabs-mode nil)

(define-fringe-bitmap 'tilde [0 0 0 113 219 142 0 0] nil nil 'center)
(setcdr (assq 'empty-line fringe-indicator-alist) 'tilde)
(set-fringe-bitmap-face 'tilde 'font-lock-comment-face)
(setq-default indicate-empty-lines t)

(use-package youdao-dictionary
  :bind ("M-?" . youdao-dictionary-search-from-input))

(use-package avy
  :bind ("M-m" . avy-goto-word-1))

(defface sw/link-face
  '((t
     (:inherit warning
               :underline t)))
  "")

(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(add-hook 'text-mode-hook 'goto-address-mode)

;; (setq garbage-collection-messages nil)
(setq gc-cons-threshold 100000000)
;; (run-with-idle-timer 10 t 'garbage-collect)

(use-package region-state
  :config (region-state-mode))

(use-package alert
  :init (setq alert-default-style 'libnotify)
  :commands alert)

(setq browse-url-browser-function 'browse-url-chrome)
(setq browse-url-generic-args (quote ("-newpage")))
(setq browse-url-generic-program "google-chrome")
(defadvice browse-url-firefox (after browse-url-goto-workspace activate)
  (call-process "i3-msg" nil nil nil "workspace i.browser"))

(use-package smex
  :config (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))

(use-package vimish-fold
  :config (progn
            (vimish-fold-global-mode t)
            (defun vimish-fold--read-only (on beg end)
              )
            (defun sw/vimish-fold-toggle ()
              (interactive)
              (let
                  ((in-overlay
                    nil))
                (mapc
                 '(lambda (overlay)
                    (if (vimish-fold--vimish-overlay-p overlay)
                        (setq in-overlay t)))
                 (overlays-at (point)))
                (if in-overlay (vimish-fold-toggle)
                  (progn
                    (unless (region-active-p)
                      (mark-defun))
                    (vimish-fold (region-beginning)
                                 (region-end))))))
            (bind-key "C-, C-,"
                      (lambda()
                        (interactive)
                        (if current-prefix-arg (vimish-fold-delete)
                          (sw/vimish-fold-toggle))))))

(use-package ibuffer
  :config (progn
            (setq ibuffer-show-empty-filter-groups nil)
            (add-hook 'ibuffer-mode-hook
                      (lambda ()
                        (ibuffer-auto-mode 1)
                        (setq ibuffer-saved-filter-groups '(("home"
                                                             ("java" (mode . java-mode))
                                                             ("c"
                                                              (or (mode . c++-mode)
                                                                  (mode . c-mode)))
                                                             ("dired" (mode . dired-mode))
                                                             ("python" (mode . python-mode))
                                                             ("elisp" (mode . emacs-lisp-mode)))))
                        (ibuffer-switch-to-saved-filter-groups "home")))
            (bind-key "~" 'ibuffer-mark-special-buffers ibuffer-mode-map))
  :commands ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package find-file-root
  :bind ("C-x C-r" . find-file-root))

(use-package calculator
  :config (progn
            (defun calculator-paste ()
              "Paste a value from the `kill-ring'."
              (interactive)
              (calculator-put-value (let ((str (replace-regexp-in-string "^ *\\(.+[^ ]\\) *$" "\\1"
                                                                         (x-get-selection
                                                                          'PRIMARY))))
                                      (and
                                       (not
                                        calculator-input-radix)
                                       calculator-paste-decimals
                                       (string-match "\\([0-9]+\\)\\(\\.[0-9]+\\)?\\(e[0-9]+\\)?"
                                                     str)
                                       (or (match-string 1 str)
                                           (match-string 2 str)
                                           (match-string 3 str))
                                       (setq str (concat
                                                  (or (match-string 1 str)
                                                      "0")
                                                  (or (match-string 2 str)
                                                      ".0")
                                                  (or (match-string 3 str)
                                                      ""))))
                                      (ignore-errors (calculator-string-to-number str)))))
            (define-key calculator-mode-map (kbd "C-k") 'calculator-clear))
  :commands calculator)

(defadvice pwd (after my-pwd activate)
  ""
  (if current-prefix-arg (kill-new (buffer-file-name))))

(use-package narrow-dwim
  :ensure nil
  :bind ("C-x n" . narrow-or-widen-dwim))

(defun sw/file-cache-add-this-file ()
  (and buffer-file-name
      (file-exists-p buffer-file-name)
      (recentf-include-p buffer-file-name)
      (file-cache-add-file buffer-file-name)))
(add-hook 'find-file-hook 'sw/file-cache-add-this-file)
(add-hook 'kill-buffer-hook 'sw/file-cache-add-this-file)

(defalias 'fcc 'file-cache-clear-cache)
(defalias 'fca 'file-cache-add-directory-recursively)

(use-package golden-ratio
  :config (progn
            (add-to-list 'golden-ratio-exclude-modes "ediff-mode")
            (defun sw/ediff-comparison-buffer-p ()
              (and (boundp 'ediff-this-buffer-ediff-sessions)
                 ediff-this-buffer-ediff-sessions))
            (add-to-list 'golden-ratio-inhibit-functions 'sw/ediff-comparison-buffer-p)
            (defun sw/ediff-balance ()
              (ediff-toggle-split)
              (ediff-toggle-split))
            (add-hook 'ediff-startup-hook 'sw/ediff-balance)
            (golden-ratio-mode t)))

(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function
                                        kill-buffer-query-functions))

(global-auto-revert-mode t)

(use-package recentf
  :init (progn
          (recentf-mode t)
          (setq recentf-max-saved-items 6)
          (setq recentf-exclude (append recentf-exclude '("\\.breadcumb" "workgroups" "recentf"
                                                          "emacs.bmk" "diary" "desktop-last-session"
                                                          ".*,DS" ".*,S" ".*\\.pyc")))))

(add-hook 'after-init-hook
          (lambda()
            (when missing-executable
              (alert (concat "Missing exec: " (mapconcat 'identity missing-executable " ")) :title "Emacs\n"))))

(use-package easy-scratch)

(use-package flyspell
  :if (with-executable "aspell")
  :init (progn
          (add-hook 'message-mode-hook 'flyspell-mode)
          (add-hook 'prog-mode-hook 'flyspell-prog-mode))
  :config (progn
            (define-key flyspell-mode-map (kbd "C-,") nil)
            (define-key flyspell-mode-map (kbd "C-M-i") nil)
            (define-key flyspell-mode-map (kbd "C-;") nil)
            ;; (define-key flyspell-mode-map (kbd "C-;") 'flyspell-auto-correct-word)
            (setq ispell-program-name "aspell"
                  ;; ispell-extra-args '("--sug-mode=normal" "--lang=en_US" "--run-together" "--run-together-limit=5" "--run-together-min=2")
                  )
            (setq ispell-personal-dictionary (concat sw/user-init-d "misc/dict"))))

(use-package emojify
  :if (eq window-system 'x)
  :init (add-hook 'after-init-hook 'global-emojify-mode)
  :config (progn
            (bind-key "C-c ;" 'emojify-insert-emoji)
            (setq emojify-emoji-styles '(github))
            (setq emojify-display-style 'image)))

(defun sw/lastpass()
  (interactive)
  (find-file "~/drops/secret/password.org"))

(defun sw/joystick()
  (interactive)
  (find-file "~/drops/secret/joystick.org"))

(use-package graphviz-dot-mode)
