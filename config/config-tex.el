(with-executable "xelatex"
                 (progn
                   (load "auctex.el" nil t t)
                   (add-to-list 'auto-mode-alist '("\\.bmer\\'" . latex-mode))
                   ;; (load "preview-latex.el" nil t t)
                   (setq TeX-auto-save t)
                   (setq TeX-parse-self t)
                   (setq-default TeX-master t)
                   (add-hook 'LaTeX-mode-hook
                             '(lambda ()
                                (tex-pdf-mode)
                                (turn-on-reftex)
                                (outline-minor-mode)
                                (turn-on-auto-fill)
                                ;;(flyspell-mode nil)
                                ;;(hide-sublevels 2)
                                (set-buffer-file-coding-system 'utf-8)
                                (LaTeX-item-indent 0)))))
