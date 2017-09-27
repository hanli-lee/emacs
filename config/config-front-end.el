(use-package web-mode
  :mode ("\\.html" . web-mode)
  :config (progn
            (setq web-mode-markup-indent-offset 4)
            (setq web-mode-script-padding 4)

            (defadvice yas-expand-from-trigger-key (before web-mode-before-yas-expand activate)
              (run-hooks 'web-mode-cur-language-mode-hook))

            (add-hook 'web-mode-cur-language-mode-hook
                      '(lambda ()
                         (let ((web-mode-cur-language
                                (web-mode-language-at-pos)))
                           (if (string= web-mode-cur-language "javascript")
                               (yas-activate-extra-mode 'js-mode)
                             (yas-deactivate-extra-mode 'js-mode))
                           (if (string= web-mode-cur-language "css")
                               (yas-activate-extra-mode 'css-mode)
                             (yas-deactivate-extra-mode 'css-mode)))))

            (add-hook 'web-mode-before-auto-complete-hooks
                      '(lambda ()
                         (let ((web-mode-cur-language
                                (web-mode-language-at-pos)))
                           (if (string= web-mode-cur-language "javascript")
                               (setq ac-sources '(ac-source-tern-completion))
                             (setq ac-sources '()))))))
  :commands web-mode)

(use-package js2-mode
  :mode ("\\.js" . js2-mode)
  :interpreter ("node" . js2-mode))

;; (use-package skewer-mode
;;   :init (progn
;;           (add-hook 'js2-mode-hook 'skewer-mode))
;;   :config (progn
;;             (bind-key "C-c C-z" 'skewer-repl skewer-mode-map)))
;; (use-package skewer-repl
;;   :commands skewer-repl)

(use-package impatient-mode
  :init (progn
          (add-hook 'web-mode-hook 'impatient-mode)
          (defun sw/run-impatient()
            (interactive)
            (httpd-start)
            (browse-url "http://localhost:8080/imp/")))
  :commands impatient-mode)

(use-package emmet-mode
  :init (progn
          (sw/add-hooks '(web sgml css) 'emmet-mode))
  :commands emmet-mode)

(use-package tern
  :if (with-executable "tern")
  :init (progn
          (sw/add-hooks '(js2 web) 'tern-mode))
  :config (progn
            (bind-key "C-c C-c" nil tern-mode-keymap)
            (use-package tern-auto-complete
              :if (with-executable "tern")
              :config (progn
                        (defun sw/ac-tern-setup()
                          (setq ac-sources '(ac-source-tern-completion)))
                        (add-hook 'js2-mode-hook 'sw/ac-tern-setup)
                        (tern-ac-setup))))
  :commands (tern-mode))

(use-package web-beautify
  :if (with-executable "js-beautify")
  :init (progn
          (sw/add-hooks '(js2 web css)
                        (lambda()
                          (local-set-key (kbd "C-c f") 'web-beautify-js))))
  :commands (web-beautify-css web-beautify-html web-beautify-js))

(use-package js-comint
  :if (with-executable "node")
  :init (progn
          (defun sw/js-send-region()
            (interactive)
            (if current-prefix-arg (kill-buffer "*js*"))
            (when (get-buffer "*js*")
              (js-clear))
            (if (region-active-p)
                (call-interactively 'js-send-region)
              (js-send-buffer)))
          (defun sw/switch-to-js()
            (interactive)
            (if current-prefix-arg (kill-buffer "*js*"))
            (unless (get-buffer "*js")
              (run-js inferior-js-program-command t))
            (call-interactively 'switch-to-js))
          (add-hook 'js2-mode-hook
                    (lambda()
                      (local-set-key (kbd "C-c C-z") 'sw/switch-to-js)
                      (local-set-key (kbd "C-c C-c") 'sw/js-send-region))))
  :config (progn
            (setq js-comint-drop-regexp "\\(.*undefined\n\\)\\|\\(^[>\.]+\\) ")
            (defun inferior-js-mode-hook-setup ()
              (add-hook 'comint-output-filter-functions 'js-comint-process-output))
            (add-hook 'inferior-js-mode-hook 'inferior-js-mode-hook-setup t))
  :commands (js-send-buffer js-clear js-send-region run-js))

(use-package restclient
  :commands (restclient-mode))
