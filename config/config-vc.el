(when (with-executable "git")
  (use-package magit
    :init (defalias 'mt 'magit-status)
    :config (progn
              (add-hook 'magit-update-uncommitted-buffer-hook 'vc-refresh-state)
              (setq magit-delete-by-moving-to-trash nil)
              (setq magit-auto-revert-mode t)
              (setq magit-ediff-dwim-show-on-hunks t)
              (defadvice magit-status (before sw/vc-refresh-state activate)
                (vc-refresh-state)))
    :bind ("C-x v t" . magit-status))
  (use-package magit-blame
    :bind  ("C-x v b " . magit-blame))

  ;; (setq vc-handled-backends nil)
  ;; (setq vc-handled-backends '(Git))
  (use-package git-messenger
    :config (setq git-messenger:show-detail t)
    :bind ("C-x v m" . git-messenger:popup-message))
  (use-package git-timemachine
    :commands git-timemachine)
  (use-package diff-hl
    :config (progn
              (global-diff-hl-mode)
              (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
              (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
              (defun sw/diff-hl-revert-hunk()
                (interactive)
                (if current-prefix-arg (vc-revert)
                  (diff-hl-revert-hunk)))
              (bind-key "C-x v n" 'diff-hl-next-hunk diff-hl-mode-map)
              (bind-key "C-x v p" 'diff-hl-previous-hunk diff-hl-mode-map)
              (bind-key "C-x v u" 'sw/diff-hl-revert-hunk diff-hl-mode-map)
              (bind-key "C-x v =" 'diff-hl-diff-goto-hunk diff-hl-mode-map)))
  (use-package diff-hl-flydiff
    :config (diff-hl-flydiff-mode))
  (use-package diff-hl-dired
    :commands diff-hl-dired-mode)

  ;; (use-package git-gutter
  ;;   :config
  ;;   (progn
  ;;     (global-git-gutter-mode +1)
  ;;     (setq git-gutter:deleted-sign "~")
  ;;     (setq git-gutter:modified-sign "!")
  ;;     (bind-key "C-x v =" 'git-gutter:popup-hunk)
  ;;     (bind-key "C-x v p" 'git-gutter:previous-hunk)
  ;;     (bind-key "C-x v n" 'git-gutter:next-hunk)
  ;;     (bind-key "C-x v s" 'git-gutter:stage-hunk)
  ;;     (bind-key "C-x v u" 'git-gutter:revert-hunk)
  ;;     (bind-key "C-x v SPC" 'git-gutter:mark-hunk)))
  )

(use-package git-branch-dired)
