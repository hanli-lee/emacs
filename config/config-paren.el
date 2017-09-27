(use-package smartparens-config
  :init (sw/add-hooks '(prog)
                      (lambda()
                        (smartparens-mode t)
                        (show-smartparens-mode t)
                        (smartparens-strict-mode t)))
  :config (progn
            (setq sp-use-subword t)
            ;; (show-smartparens-global-mode t)
            ;; (smartparens-global-mode t)
            ;; (smartparens-global-strict-mode t)
            (sp-with-modes
                'c-mode
              (sp-local-pair "/\*\*" "\*\*/")
              (sp-local-pair "/\*" "\*/"))
            (sp-with-modes
                'c++-mode
              (sp-local-pair "/\*\*" "\*\*/")
              (sp-local-pair "/\*" "\*/"))
            (sp-with-modes
                'java-mode
              (sp-local-pair "/\*\*" "\*\*/")
              (sp-local-pair "/\*" "\*/"))
            (setq sp-paredit-bindings '(
                                        ;; ("C-M-a" . sp-beginning-of-sexp)
                                        ;; ("C-M-e" . sp-end-of-sexp)
                                        ("C-M-f" . sp-forward-sexp) ;; navigation
                                        ("C-M-b" . sp-backward-sexp)
                                        ("C-M-u" . sp-backward-up-sexp)
                                        ("C-M-k" . sp-kill-sexp)
                                        ("C-M-d" . sp-down-sexp)
                                        ("C-M-p" . sp-backward-down-sexp)
                                        ("C-M-n" . sp-up-sexp)
                                        ("M-s" . sp-splice-sexp) ;; depth-changing commands
                                        ("C-M-<up>" . sp-splice-sexp-killing-backward)
                                        ("C-M-<down>" . sp-splice-sexp-killing-forward)
                                        ("C-<right>" . sp-forward-slurp-sexp)
                                        ("C-<left>" . sp-forward-barf-sexp)
                                        ("C-M-<left>" . sp-backward-slurp-sexp)
                                        ("C-M-<right>" . sp-backward-barf-sexp)
                                        ("M-S" . sp-split-sexp)))
            (sp-use-paredit-bindings)))

(use-package paren-face
  :config (progn
            (setq paren-face-regexp "[][(){},]")
            (add-to-list 'paren-face-modes 'python-mode)
            (add-to-list 'paren-face-modes 'java-mode)
            (add-to-list 'paren-face-modes 'c-mode)
            (add-to-list 'paren-face-modes 'c++-mode)
            (global-paren-face-mode)))
