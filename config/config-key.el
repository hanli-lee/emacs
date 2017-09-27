(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-g") 'goto-line)

(require 'edit-at-point)
(global-set-key (kbd "M-q") 'edit-at-point-symbol-copy)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-l") 'recenter)
(global-set-key (kbd "C-M-/") 'hippie-expand)
(global-set-key (kbd "C-M-\\")
                '(lambda()
                   (interactive)
                   (save-excursion
                     (unless (region-active-p)
                       (mark-defun))
                     (call-interactively 'indent-region))))
(global-set-key (kbd "C-x C-k") 'ido-kill-buffer)
(global-set-key (kbd "C-x k")
                '(lambda()
                   (interactive)
                   (kill-buffer (current-buffer))))

;; (global-unset-key (kbd "<mouse-2>"))
(global-unset-key (kbd "<C-wheel-up>"))
(global-unset-key (kbd "<C-wheel-down>"))

(global-set-key (kbd "M-T") 'sw/transporse-region)
(global-set-key (kbd "M-^")
                '(lambda()
                   (interactive)
                   (if current-prefix-arg (call-interactively 'sw/split-line)
                     (call-interactively 'sw/join-line))))

(define-key isearch-mode-map "\C-y" 'isearch-yank-kill)

(global-set-key (kbd "C-x C-x")
                '(lambda()
                   (interactive)
                   (if (region-active-p)
                       (call-interactively 'exchange-point-and-mark)
                     (sw/switch-to-query))))

(global-set-key (kbd "C-x C-p") 'mark-whole-buffer)

(global-set-key (kbd "<M-up>")
                '(lambda()
                   (interactive)
                   (sw/move-line -1)))

(global-set-key (kbd "<M-down>")
                '(lambda()
                   (interactive)
                   (sw/move-line 1)))

(global-set-key (kbd "C-x C-w") 'sw/write-file-or-region)

(global-set-key (kbd "C-c C-n") 'sw/indent-next-level)
(global-set-key (kbd "C-c C-p") 'sw/indent-prev-level)
(global-set-key (kbd "C-c C-u") 'sw/indent-up-level)

(global-set-key (kbd "C-c C-o") 'org-open-at-point-global)
(global-set-key (kbd "<double-down-mouse-1>") 'org-open-at-point-global)

(global-set-key (kbd "<f2>") 'bc-set)
(global-set-key (kbd "C-x r l") 'bc-list)

(global-set-key (kbd "C-x 2") 'split-window-horizontally)
(global-set-key (kbd "C-x 3") 'split-window-below)
(global-set-key (kbd "C-x O") '(lambda()
                                 (interactive)
                                 (call-interactively 'sw/transpose-windows)
                                 (golden-ratio)))

(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super)
