(setq sw/git-branch-name "")
(make-variable-buffer-local 'sw/git-branch-name)

(defun sw/git-modeline ()
  (interactive)
  (let ((root (sw/find-git-repo "./")))
    (if (file-directory-p (concat root ".git"))
        (setq sw/git-branch-name (concat "Git:" (sw/git-current-branch root)))
      (setq sw/git-branch-name "")))
  (force-mode-line-update t))

(setq sw/git-branch-modeline '(:eval (propertize sw/git-branch-name)))

(add-hook 'dired-mode-hook
          (lambda()
            (unless (member sw/git-branch-modeline mode-line-format)
              (set-default 'mode-line-format (sw/insert-after mode-line-format 11
                                                              sw/git-branch-modeline)))))
(add-hook 'dired-after-readin-hook 'sw/git-modeline)

(provide 'git-branch-dired)
