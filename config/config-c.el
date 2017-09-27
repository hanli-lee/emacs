(use-package dtrt-indent
  :commands (dtrt-indent-adapt dtrt-indent-mode))

(setq global-mode-string '('display-time-string))

(defun sw/astyle-this-buffer ()
  (interactive)
  (let (pmin pmax)
    (if (region-active-p)
        (progn
          (setq pmin (region-beginning))
          (setq pmax (region-end)))
      (progn
        (setq pmin (point-min))
        (setq pmax (point-max))))
    (if (with-executable "astyle")
        (shell-command-on-region pmin pmax "astyle" ;; add options here...
                                 (current-buffer) t nil t))))

(defun sw/c-common-hook()
  (interactive)
  (make-variable-buffer-local 'hippie-expand-try-functions-list)
  (c-set-style "k&r")
  (c-toggle-auto-state -1)
  (c-toggle-hungry-state t)
  (c-toggle-electric-state t)
  ;; (electric-pair-local-mode t)
  ;; (electric-operator-mode t)
  (setq ac-sources '(ac-source-semantic-raw))
  (local-set-key (kbd "C-c ?") 'semantic-ia-show-doc)
  (local-set-key (kbd "C-h C-h") 'man)
  (setq c-basic-offset 4)
  (subword-mode t)
  (glasses-mode t)
  (let ((inhibit-message t))
    (dtrt-indent-mode t)
    (dtrt-indent-adapt))
  (c-set-offset 'case-label 4)
  (hide-ifdef-mode t)
  (auto-fill-mode 1)
  ;; (flyspell-prog-mode)
  (local-unset-key  (kbd "C-c C-u"))
  (local-unset-key  (kbd "C-c C-p"))
  (local-unset-key  (kbd "C-c C-n"))
  (local-set-key "\M-." 'sw/ctags)
  (local-set-key (kbd "C-c f") 'sw/astyle-this-buffer)
  (local-set-key (kbd "C-c d") 'doxygen-insert-function-comment)
  (setq c-hanging-braces-alist '((brace-list-open after)
                                 (brace-list-close)
                                 (brace-entry-open)
                                 (statement-cont)
                                 (substatement-open after)
                                 (block-close . c-snug-do-while)
                                 (extern-lang-open after)
                                 (namespace-open after)
                                 (module-open after)
                                 (defun-open after)
                                 (class-open after)
                                 (class-close)
                                 (composition-open after)
                                 (inexpr-class-open after)
                                 (inexpr-class-close before)))
  (setq c-cleanup-list '(
                         ;; space-before-funcall
                         ;; compact-empty-funcall
                         brace-else-brace brace-elseif-brace brace-catch-brace one-liner-defun
                                          defun-close-semi comment-close-slash scope-operator)))

(sw/add-hooks '(c++ c java) 'sw/c-common-hook)

(use-package ajc-java-complete
  :init (progn
          (defun sw/ajc-import()
            (interactive)
            (ajc-reload-tag-buffer-maybe)
            (ajc-import-class-under-point))
          (add-hook 'java-mode-hook
                    '(lambda()
                       (local-set-key (kbd "C-c i") 'sw/ajc-import))))
  :commands ajc-reload-tag-buffer-maybe)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(use-package doxygen
  :commands doxygen-insert-function-comment)
