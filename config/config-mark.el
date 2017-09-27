(use-package beacon
  :config (progn
            (setq beacon-push-mark 10)
            (setq xref-after-return-hook nil)
            (beacon-mode t)))

(use-package back-button
  :config (progn
            (defun widen-before-move ()
              (interactive)
              (if (buffer-narrowed-p)
                  (progn
                    (setq header-line-format nil)
                    (widen))))
            (advice-add 'back-button-local-forward
                        :before #'widen-before-move)
            (advice-add 'back-button-local-backward
                        :before #'widen-before-move)
            (advice-add 'back-button-global-forward
                        :before #'widen-before-move)
            (advice-add 'back-button-global-backward
                        :before #'widen-before-move)
            (advice-add 'pop-tag-mark
                        :before #'widen-before-move)
            (advice-add 'etags-select-find-tag
                        :before #'widen-before-move))
  :commands (back-button-local back-button-global)
  :bind (("M-n" . back-button-local-forward)
         ("M-p" . back-button-local-backward)
         ("M-N" . back-button-global-forward)
         ("M-P" . back-button-global-backward)))
