(use-package yasnippet
  :config (progn
            (setq yas-snippet-dirs nil)
            (add-to-list 'yas-snippet-dirs (concat sw/user-init-d "misc/snippets"))
            (setq yas-verbosity 1)
            (setq yas-wrap-around-region t)
            (yas-global-mode 1)
            (defun yas/goto-end-of-active-field ()
              (interactive)
              (let* ((snippet (car (yas--snippets-at-point)))
                     (position (yas--field-end (yas--snippet-active-field snippet))))
                (goto-char position)))
            (defun yas/goto-start-of-active-field ()
              (interactive)
              (let* ((snippet (car (yas--snippets-at-point)))
                     (position (yas--field-start (yas--snippet-active-field snippet))))
                (goto-char position)))
            (bind-key "<return>" 'yas-exit-all-snippets yas-keymap)
            (bind-key "C-n" 'yas-next-field yas-keymap)
            (bind-key "C-p" 'yas-prev-field yas-keymap)
            (bind-key "C-a" 'yas/goto-start-of-active-field yas-keymap)
            (bind-key "C-e" 'yas/goto-end-of-active-field yas-keymap)
            (setq yas-prompt-functions '(yas-ido-prompt yas-completing-prompt))
            (setq yas-buffer-local-condition '(if
                                                  (or
                                                   (or (sw/in-comment)
                                                      (not (sw/eol)))
                                                   (not (sw/is-first-word)))
                                                  '(require-snippet-condition . force-in-comment)
                                                t))))

(use-package hippie-exp
  :config
  (progn
    (setq hippie-expand-try-functions-list
          '(
            yas-hippie-try-expand
            try-expand-dabbrev-closest-first
            try-complete-file-name
            try-expand-dabbrev-from-kill
            try-expand-dabbrev-all-buffers
            try-expand-list
            try-expand-list-all-buffers
            try-complete-file-name-partially
            try-complete-lisp-symbol
            try-complete-lisp-symbol-partially))
    (defvar he-search-loc-backward (make-marker))
    (defvar he-search-loc-forward (make-marker))
    (defun try-expand-dabbrev-closest-first (old)
      "Try to expand word \"dynamically\", searching the current buffer.
The argument OLD has to be nil the first call of this function, and t
for subsequent calls (for further possible expansions of the same
string).  It returns t if a new expansion is found, nil otherwise."
      (let (expansion)
        (unless old
          (he-init-string (he-dabbrev-beg) (point))
          (set-marker he-search-loc-backward he-string-beg)
          (set-marker he-search-loc-forward he-string-end))

        (if (not (equal he-search-string ""))
            (save-excursion
              (save-restriction
                (if hippie-expand-no-restriction
                    (widen))

                (let (forward-point
                      backward-point
                      forward-distance
                      backward-distance
                      forward-expansion
                      backward-expansion
                      chosen)

                  ;; search backward
                  (goto-char he-search-loc-backward)
                  (setq expansion (he-dabbrev-search he-search-string t))

                  (when expansion
                    (setq backward-expansion expansion)
                    (setq backward-point (point))
                    (setq backward-distance (- he-string-beg backward-point)))

                  ;; search forward
                  (goto-char he-search-loc-forward)
                  (setq expansion (he-dabbrev-search he-search-string nil))

                  (when expansion
                    (setq forward-expansion expansion)
                    (setq forward-point (point))
                    (setq forward-distance (- forward-point he-string-beg)))

                  ;; choose depending on distance
                  (setq chosen (cond
                                ((and forward-point backward-point)
                                 (if (< forward-distance backward-distance) :forward :backward))

                                (forward-point :forward)
                                (backward-point :backward)))

                  (when (equal chosen :forward)
                    (setq expansion forward-expansion)
                    (set-marker he-search-loc-forward forward-point))

                  (when (equal chosen :backward)
                    (setq expansion backward-expansion)
                    (set-marker he-search-loc-backward backward-point))))))

        (if (not expansion)
            (progn
              (if old (he-reset-string))
              nil)
          (progn
            (he-substitute-string expansion t)
            t))))))

(use-package auto-complete
  :config (progn
            ;; (ac-config-default)
            ;; (setq-default ac-sources '(ac-source-yasnippet))
            (setq-default ac-sources '())
            (setq ac-use-comphist nil)
            (setq ac-auto-show-menu 0.5)
            (setq ac-auto-start t)
            (setq ac-delay 0.2)
            (setq ac-menu-height 20)
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)
            (define-key ac-completing-map (kbd "C-S-n") 'ac-next)
            (define-key ac-menu-map (kbd "<return>") 'ac-expand)
            (define-key ac-menu-map (kbd "<tab>") nil)
            (define-key ac-completing-map (kbd "<tab>") nil)
            (define-key ac-completing-map (kbd "<return>") 'ac-expand)
            (ac-flyspell-workaround))
  :commands (auto-complete-mode))

(use-package company
  :config (progn
            (define-key company-active-map (kbd "C-n") 'company-select-next)
            (define-key company-active-map (kbd "C-p") 'company-select-previous))
  :commands (company-mode))
