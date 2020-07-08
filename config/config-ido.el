(use-package ido
  :config
  (progn
    (global-set-key (kbd "C-x b") 'ido-switch-buffer)
    (setq ido-auto-merge-delay-time 99999)
    (ido-mode t)
    (ido-everywhere t)
    (setq ido-use-faces nil)
    (setq ido-enable-flex-matching t)
    (setq ido-max-directory-size 100000)
    (setq ido-enable-regexp t)
    (setq ido-enable-flex-matching t)
    (setq ido-ignore-buffers (quote ("\\` \\|\\(^\\*\\)\\|\\(TAGS.*\\)")))

    (add-hook 'ido-setup-hook
              '(lambda ()
                 (interactive)
                 (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
                 (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
                 (define-key ido-completion-map (kbd "SPC") 'self-insert-command)))

    )
  :bind ("C-x b" . ido-switch-buffer))

(use-package ido-filecache)

(use-package ido-vertical-mode
  :config
  (progn
    (ido-vertical-mode t)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)
    (setq ido-vertical-show-count t)))

;;(use-package ido-ubiquitous
(use-package ido-completing-read+
  :config
  (ido-ubiquitous-mode t))

(use-package flx-ido
  :config
  (progn
    (setq flx-ido-use-faces t)
    (flx-ido-mode 1)))
