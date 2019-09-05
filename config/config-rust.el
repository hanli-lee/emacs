(use-package rust-mode
  :init (progn
          (add-hook 'rust-mode-hook 'racer-mode)
          ;;单词大小写之间用下滑下分隔
          (add-hook 'rust-mode-hook 'glasses-mode)
          )
  :config (progn
            (defadvice rust-mode-indent-line (around sw/rust-ignore-indent-error activate)
              (ignore-errors
                ad-do-it))
            (define-key rust-mode-map (kbd "C-c f")
              '(lambda()
                 (interactive)
                 (delete-trailing-whitespace)
                 (rust-format-buffer)))
            (define-key rust-mode-map (kbd "C-h C-h") 'racer-describe)))

(use-package racer
  :init (progn
          (add-hook 'rust-mode-hook 'company-mode)
          (add-hook 'racer-mode-hook 'eldoc-mode))
  :commands (racer-mode))
