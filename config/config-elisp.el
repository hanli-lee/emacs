(defun sw/emacs-lisp-mode-hook()
  (add-hook 'local-write-file-hooks 'delete-trailing-whitespace)
  (add-hook 'local-write-file-hooks 'check-parens))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (sw/emacs-lisp-mode-hook)))

(use-package aggressive-indent
  :init (add-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode)
  :commands aggressive-indent-mode)

(use-package elisp-format
  :init (define-key emacs-lisp-mode-map (kbd "C-c f") 'elisp-format-region)
  :commands elisp-format-region)
