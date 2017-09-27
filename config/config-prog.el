(use-package electric-operator
  :init (progn
          (sw/add-hooks '(c java c++ python js2 rust) 'electric-operator-mode))
  :config (progn
            (electric-operator-add-rules-for-mode 'python-mode
                                                  (cons ">>" " >> ")
                                                  (cons "<<" " << ")
                                                  (cons "|=" " |= ")
                                                  (cons "+=" " += ")
                                                  (cons "-=" " -= ")))
  :commands (electric-operator-mode))

(use-package indent-guide
  :init (sw/add-hooks '(python emacs-lisp c c++ java) 'indent-guide-mode)
  :config (progn
            (setq indent-guide-delay nil)
            (setq indent-guide-threshold -1)
            (defun indent-guide-show ()
              (interactive)
              (unless
                  (or (indent-guide--active-overlays)
                      (active-minibuffer-window))
                (let
                    ((win-start
                      (window-start))
                     (win-end (window-end nil t)) line-col line-start line-end last-col)
                  (save-excursion
                    (indent-guide--beginning-of-level)
                    (setq line-col (current-column) line-start (max (1+ (line-number-at-pos))
                                                                    (line-number-at-pos win-start))))
                  (if (> line-col indent-guide-threshold)
                      (progn
                        (save-excursion
                          (while
                              (and
                               (progn
                                 (back-to-indentation)
                                 (or (< line-col (current-column))
                                     (eolp)))
                               (forward-line 1)
                               (not (eobp))
                               (<= (point) win-end)))
                          (when (>= line-col
                                    (setq last-col (current-column)))
                            (forward-line -1)
                            (while
                                (and (looking-at "[\s\t\n]*$")
                                    (> (point) line-start)
                                    (zerop (forward-line -1)))))
                          (setq line-end (line-number-at-pos)))
                        (if
                            (and (< (- line-end line-start) 20)
                                (not
                                 (or (= line-end (line-number-at-pos win-end))
                                     (= line-start (line-number-at-pos win-start)))))
                            (progn
                              (save-excursion
                                (when (indent-guide--beginning-of-level)
                                  (indent-guide-show))))
                          (setq sw/indent-guide-timer nil)
                          (save-excursion
                            (indent-guide--beginning-of-level)
                            (if (< (point)
                                   (window-start))
                                (progn
                                  (setq sw/indent-guide-current-level-info
                                        (buffer-substring
                                         (line-beginning-position)
                                         (line-end-position)))
                                  (setq header-line-format sw/indent-guide-current-level-info))
                              (setq header-line-format "")))
                          (dotimes (tmp (- (1+ line-end) line-start))
                            (indent-guide--make-overlay (+ line-start tmp) line-col))
                          (remove-overlays (point)
                                           (point) 'category 'indent-guide)))
                    (setq header-line-format ""))))))
  :commands indent-guide-mode)

(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and
       (not current-prefix-arg)
       (member major-mode '(emacs-lisp-mode lisp-mode java-mode nxml-mode clojure-mode scheme-mode
                                            haskell-mode ruby-mode rspec-mode c-mode c++-mode
                                            objc-mode latex-mode plain-tex-mode))
       (let
           ((mark-even-if-inactive
             transient-mark-mode))
         (indent-region (region-beginning)
                        (region-end) nil))))))

(use-package racket-mode
  :mode "\\.rkt\\$"
  :config (bind-key "C-h C-h" 'racket-describe racket-mode-map))

(use-package eldoc
  :init (progn
          (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
          (add-hook 'python-mode-hook 'eldoc-mode))
  :commands eldoc-mode)

(use-package flycheck
  :init (progn
          (when (with-executable "pylint")
            (add-hook 'python-mode-hook 'flycheck-mode))
          (when (with-executable "jslint")
            (add-hook 'js2-mode-hook 'flycheck-mode))
          (when (with-executable "rustc")
            (add-hook 'rust-mode-hook 'flycheck-mode)))
  :config (progn
            (defun sw/flycheck-display-error (errors)
              (-when-let (messages (-keep #'flycheck-error-message errors))
                (popup-tip (mapconcat 'identity messages "\n"))))
            (setq flycheck-display-errors-function 'sw/flycheck-display-error))
  :commands flycheck-mode)

(use-package comment-edit
  :init (progn
          (setq comment-edit-style "simplest")
          (global-set-key (kbd "M-;")
                          '(lambda()
                             (interactive)
                             (if current-prefix-arg
                                 (progn
                                   (setq current-prefix-arg 0)
                                   (call-interactively 'comment-edit))
                               (call-interactively 'comment-dwim)))))
  :commands comment-edit)

;; (add-hook 'prog-mode-hook 'linum-mode)

(sw/add-hooks '(prog text)
              '(lambda()
                 (font-lock-add-keywords
                  nil
                  '(("\\<\\(FIXME\\|TODO\\)\\>" 1 font-lock-warning-face prepend)))))

;;(use-package prettify-symbols-mode
;;  :init (progn
;;          (sw/add-hooks '(emacs-lisp c c++ java rust python js2)
;;                        (lambda ()
;;                          (setq prettify-symbols-alist '(("lambda" . ?\u03BB)
;;                                                         ("def" . ?\u03BB)
;;                                                         ("fn" . ?\u03BB)
;;                                                         ("function" . ?\u03BB)
;;                                                         ("&&" . ?\u2227)
;;                                                         ("and" . ?\u2227)
;;                                                         ("||" . ?\u2228)
;;                                                         ("or" . ?\u2228)
;;                                                         ("->" . ?\u2192)
;;                                                         ("=>" . ?\u21D2)
;;                                                         ("None" . ?\u2205)
;;                                                         ("NULL" . ?\u2205)
;;                                                         ("nil" . ?\u2205)
;;                                                         ("<=" . ?\u2264)
;;                                                         (">=" . ?\u2265)
;;                                                         ("!=" . ?\u2260)
;;                                                         ("==" . ?\u2A75)
                                                         ;; ("!" . ?\u00AC)
;;                                                         ("not" . ?\u00AC)
;;                                                         ("in" . ?\u2208)
;;                                                         ("not in" . ?\u2209)
;;                                                         ("<<" . ?\u226A)
;;                                                         (">>" . ?\u226B)
;;                                                         ("not in" . ?\u2209)
;;                                                         ("++" . ?\u29FA)
;;                                                         ("return" . ?\u23CE)
;;                                                         ("mut" . ?\u03BC)
;;                                                         ("let" . ?\u2200)
;;                                                         (".." . ?\u21A0)))
;;                          (prettify-symbols-mode t)))))

(setq compilation-exit-message-function
      (lambda (status code msg)
        (when (and (eq status 'exit) (zerop code))
          (run-at-time 1 nil (lambda() (set-window-configuration wcon))))
  	(cons msg code)))

(defadvice compilation-start (before my-compile-save activate)
  (setq wcon (current-window-configuration)))

;; (add-hook 'compilation-finish-functions
;;           (lambda (buf msg)
;;             (popup-tip "compilation finished")))

(setq compilation-scroll-output 'first-error)
(setq compilation-skip-threshold 2)

(add-hook 'compilation-mode-hook
          '(lambda()
             (local-unset-key  (kbd "C-o"))
             (local-set-key  (kbd "q")
                             (lambda()
                               (interactive)
                               (set-window-configuration wcon)))))

(use-package iedit
  :init (progn
          (defadvice iedit-mode (before sw/iedit-limit-to-function activate)
            (ad-set-arg 0 0)))
  :config (progn
            (bind-key "C-n" 'iedit-next-occurrence iedit-mode-keymap)
            (bind-key "C-p" 'iedit-prev-occurrence iedit-mode-keymap)))
;; (use-package auto-highlight-symbol
;;   :init (progn
;;           (add-hook 'prog-mode-hook 'auto-highlight-symbol-mode))
;;   :config (setq ahs-default-range (quote ahs-range-beginning-of-defun))
;;   :commands auto-highlight-symbol-mode)

(which-function-mode 1)
;; (setq which-func-modes '(c-mode c++-mode python-mode java-mode))
(setq which-func-modes t)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(use-package comint
  :init (progn
          (add-hook 'comint-mode-hook
                    (lambda()
                      (interactive)
                      (local-set-key (kbd "C-c C-k") 'comint-interrupt-subjob)))))

;; (semantic-mode t)
;; (global-semantic-idle-summary-mode t)
;; (setq semantic-imenu-bucketize-file nil)

(use-package project
  :ensure nil
  :init (sw/add-hooks '(dired c++ c java rust)
                      (lambda()
                        (local-set-key (kbd "C-c C-c p") 'sw/project-run)
                        (local-set-key (kbd "C-c C-c m") 'sw/project-build)
                        (local-set-key (kbd "C-c C-c i") 'sw/project-stdin))))

(use-package quickrun
  :init (progn
          (setq quickrun-input-file-extension ".stdin"))
  :config (progn
            (quickrun-add-command "rust"
                                  '((:command .
                                              "rustc")
                                    (:exec .
                                           ("%c -A warnings %o -o %e %s" "%e %a"))
                                    (:compile-only .
                                                   "%c -A warnings %o -o %e %s"))
                                  :override t)
            (add-hook 'quickrun-after-run-hook
                      (lambda()
                        (interactive)
                        (message "Compilation finished"))))
  :commands (quickrun quickrun-compile-only))

(use-package zeal-at-point
  :init (progn
          (defun sw/zeal ()
            (interactive)
            (let*
                ((thing
                  (if mark-active
                      (buffer-substring
                       (region-beginning)
                       (region-end))
                    (thing-at-point 'symbol))) search)
              (unless thing
                (setq thing (read-string "Zeal search: ")))
              (zeal-at-point-run-search (zeal-at-point-maybe-add-docset thing))))
          (sw/add-hooks '(rust python)
                        (lambda()
                          (interactive)
                          (local-set-key (kbd "C-h C-h") 'sw/zeal))))
  :config (progn
            (add-to-list 'zeal-at-point-mode-alist '(python-mode . "python"))))
