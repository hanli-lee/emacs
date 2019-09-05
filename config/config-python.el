(setq sw/python-cmd "python3")

(defun sw/switch-python()
  (interactive)
  (if (string= sw/python-cmd "python3")
      (setq sw/python-cmd "python2")
    (setq sw/python-cmd "python3"))
  (ignore-errors
    (kill-buffer "*Python*")
    (delete-other-windows))
  (setq mode-name sw/python-cmd)
  (message sw/python-cmd))

(use-package python
  :mode ("\\.py" . python-mode)
  :config (progn
            (require 'sphinx-doc)
            (with-executable "pylint")
            (defun sw/python-mode-hook()
              (interactive)
              ;;单词大小写之间用下滑下分隔
              ;;(glasses-mode t)
              (subword-mode t)
              (sphinx-doc-mode t)
              (electric-operator-mode t)
              ;; (electric-pair-local-mode t)
              ;; (semantic-idle-summary-mode 0)
              (local-set-key (kbd "C-c d") 'sphinx-doc)
              (run-python (concat sw/python-cmd " -i") nil nil)
              (setq mode-name sw/python-cmd)
              (setq imenu-create-index-function 'python-imenu-create-flat-index)
              (local-set-key (kbd "<return>") 'newline-and-indent)
              (local-unset-key (kbd "C-c C-p"))
              (local-unset-key (kbd "C-c C-j"))
              (local-set-key (kbd "C-c C-c")
                             (lambda()
                               (interactive)
                               (if (region-active-p)
                                   (call-interactively 'python-shell-send-region)
                                 (call-interactively 'python-shell-send-buffer)))))
            (add-hook 'python-mode-hook 'sw/python-mode-hook)
            (setq gud-pdb-command-name "pdb-clone")

            (defadvice python-shell-send-region (around python-switch-to-buffer activate)
              (let ((buffer (current-buffer)))
                (if current-prefix-arg (ignore-errors
                                         (kill-buffer "*Python*")))
                (save-excursion
                  (python-shell-switch-to-shell)
                  (end-of-buffer)
                  (let
                      ((comint-buffer-maximum-size
                        0))
                    (comint-truncate-buffer)))
                (ad-set-arg 2 t) ad-do-it (other-window 1)))

            (defadvice python-shell-get-or-create-process
                (before python-force-dedicate
                        (&optional
                         cmd
                         dedicated
                         show)
                        activate)
              (ad-set-arg 0 (concat sw/python-cmd " -i ")))

            (defadvice python-info-current-symbol (around python-move-back activate)
              (save-excursion
                (search-backward-regexp "[a-zA-z]+(" (line-beginning-position) t)
                ad-do-it))

            (defalias 'python-shell-get-process-or-error 'python-shell-get-or-create-process)
            (require 'pydoc-info)))

(use-package py-yapf
  :if (and (with-executable "yapf")
          (with-executable "diff"))
  :init (progn
          (add-hook 'python-mode-hook
                    (lambda()
                      (local-set-key (kbd "C-c f") 'py-yapf-buffer)
                      (py-yapf-enable-on-save)))))

(use-package jedi
  :init (progn
          (add-hook 'python-mode-hook
                    (lambda()
                      ;; (local-set-key (kbd "C-h C-h") 'jedi:show-doc)
                      ;; (local-set-key (kbd "M-.") 'jedi:goto-definition)
                      ;; (local-set-key (kbd "M-*") 'jedi:goto-definition-pop-marker)
                      ))
          (add-hook 'python-mode-hook 'jedi:setup))
  :config (progn
            (setq jedi:complete-on-dot t)
            (setq jedi:tooltip-method nil)
            (setq jedi:server-command (list sw/python-cmd jedi:server-script)))
  :commands jedi:setup)

(use-package pylookup
  :init (progn
          (add-hook 'python-mode-hook
                    (lambda()
                      (local-set-key (kbd "C-h C-h") 'pylookup-lookup))))
  :config (progn
            (setq pylookup-program (sw/join-path sw/user-init-d "misc" "pylookup.py"))
            (setq pylookup-db-file (sw/join-path sw/user-init-d "misc" "pylookup.db")))
  :commands (pylookup-lookup))
