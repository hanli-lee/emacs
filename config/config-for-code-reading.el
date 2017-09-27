(use-package wgrep
  :config (progn
            (use-package wgrep-ack)
            (setq wgrep-enable-key "r")
            (setq wgrep-auto-save-buffer t)
            (setq wgrep-change-readonly-file t)
            (bind-key "r" 'wgrep-change-to-wgrep-mode ack-mode-map))
  :commands wgrep-change-to-wgrep-mode)

(use-package ack
  :if (with-executable "ack")
  :init (defun sw/ack()
          (interactive)
          (if current-prefix-arg (call-interactively 'sw/find-dired)
            (call-interactively 'ack))
          (sw/kick-grepping-buffer "*ack*"))
  :commands ack
  :bind ("M-," . sw/ack)
  :bind (:map ack-mode-map
              ("q" . sw/bury-buffer-or-kill-frame)
              ("n" . compilation-next-file)
              ("p" . compilation-previous-file)
              ("r" . wgrep-change-to-wgrep-mode)))

(defun csearch-dir ()
  (interactive)
  (let
   ((dir
     (read-directory-name "Run csearch in directory: " nil nil t)))
    (sw/csearch dir)
  )
 )

(defun sw/csearch (dir)
  (interactive)
  (with-executable "csearch")

  (if (get-buffer "*csearch*")
      (kill-buffer "*csearch*"))

  (let ((symbol (thing-at-point 'symbol))
        (orig-command compile-command)
        (compilation-environment `(,(concat "CSEARCHINDEX=" dir "/.csearchindex"))))

    (setq query (ido-completing-read (format (concat "csearch " "(default " symbol "): "))
                                     find-tag-history nil nil nil
                                     'find-tag-history symbol))

    ;; (setq command (concat "csearch -n -f " (get-session-root) " '" query "'"))
    (setq command (concat "csearch -n '" query "' ; exit 1"))
    (with-current-buffer (compilation-start command nil)
      (setq scf-enabled t)
      (rename-buffer "*csearch*")
      (sw/kick-grepping-buffer "*csearch*")
      (highlight-regexp query compilation-warning-face))
    (switch-to-buffer-other-window "*csearch*")
    (delete-other-windows)
    (setq compile-command orig-command)))

(use-package scf-mode
  :init (progn
          (setq scf-enabled nil)
          (make-variable-buffer-local 'scf-enabled)
          (add-hook 'compilation-finish-functions
                    (lambda (buf msg)
                      (when scf-enabled
                        (set-buffer buf)
                        (setq scf-enabled nil)
                        (run-at-time 0.1 nil
                                     (lambda()
                                       (scf-mode 1)))))))
  :commands (scf-mode))

(global-set-key [(M /)] '(lambda()
                           (interactive)
                           (if current-prefix-arg
                               (sw/locate)
                             (sw/csearch session-root-directory))))

;; (setq beagrep-history nil)
;; (defun sw/beagrep ()
;;   (interactive)
;;   (let ((symbol (thing-at-point 'symbol))
;;         (for-file "")
;;         (orig-command compile-command))
;;     (if current-prefix-arg
;;         (setq for-file "-f "))
;;     (setq query (ido-completing-read (format (concat "Beagrep " (if (eq for-file "") "contents "
;;                                                                   "files " ) "(default " symbol
;;                                                                   "): ")) find-tag-history nil nil nil
;;                                                                   'find-tag-history symbol))
;;     (if (get-buffer "*beagrep*")
;;         (kill-buffer "*beagrep*"))
;;     (setq command (concat "beagrep " for-file " -e '" query "'"))
;;     (with-current-buffer (compilation-start command nil)
;;       (rename-buffer "*beagrep*")
;;       (sw/kick-grepping-buffer "*beagrep*")
;;       (highlight-regexp query compilation-warning-face))
;;     (switch-to-buffer-other-window "*beagrep*")
;;     (delete-other-windows)
;;     (setq compile-command orig-command)))

;; (global-set-key [(M /)] 'sw/beagrep)

(defun sw/kick-grepping-buffer (buffer)
  (setq sw/grepping-buffers (remove buffer sw/grepping-buffers))
  (add-to-list 'sw/grepping-buffers buffer))

(setq sw/grepping-buffers '("*csearch** *eopengrok*" "*beagrep*" "*ack*" "*Find*" "*Moccur*" "*etags-select*"))
(defun sw/switch-to-query ()
  (interactive)
  (setq search_candidates (sw/buffers-live-p sw/grepping-buffers))
  (when search_candidates
    (if
        (not (cdr search_candidates))
        (setq select_name (car search_candidates))
      (setq select_name (ido-completing-read "Switch to query: " search_candidates)))
    (sw/kick-grepping-buffer select_name)
    (switch-to-buffer select_name)))

(defadvice compile-goto-error (after delete-windows-advice activate)
  (delete-other-windows))

(use-package etags-select
  :if (with-executable "ctags")
  :init (progn
          (defun sw/ctags()
            (interactive)
            (unless tags-file-name
              (message "%s %s" "Loading:" (concat (get-session-root) "TAGS"))
              (sw/set-tags-table (concat (get-session-root) "TAGS")))
            (call-interactively 'etags-select-find-tag)
            (sw/kick-grepping-buffer "*etags-select*")))
  :config  (setq etags-select-highlight-tag-after-jump nil)
  :bind (("M-." . sw/ctags)
         ("M-*" . pop-tag-mark))
  :commands etags-select-find-tag)

(use-package dumb-jump
  :init (sw/add-hooks '(emacs-lisp python)
                      '(lambda()
                         (local-set-key (kbd "M-.") 'dumb-jump-go)))
  :commands dumb-jump-go)

(use-package imenu
  :config (progn
            (setq imenu-sort-function 'imenu--sort-by-name)
            (defun sw/imenu-rescan ()
              (interactive)
              (imenu--menubar-select imenu--rescan-item)
              (call-interactively 'imenu))
            (global-set-key (kbd "C-c C-j") 'sw/imenu-rescan)))

(use-package locate
  :if (with-executable "locate")
  :init (progn
          ;; (setq locate-make-command-line
          ;;       (lambda (arg)
          ;;         (list "locate" "-i" "--database=" (concat (get-session-root) "locate.db") arg)))
          (defun sw/locate()
            (interactive)
            (let (query symbol)
              (setq symbol (thing-at-point 'symbol))
              (setq query (ido-completing-read (format (concat "locate " "(default " symbol "): "))
                                               find-tag-history nil nil nil 'find-tag-history symbol))
              (locate-in-alternate-database query (concat (get-session-root) "locate.db"))
              ;; (locate query)
              (switch-to-buffer "*Locate*")
              (delete-other-windows)
              (highlight-regexp query compilation-warning-face))))
  :commands (locate-in-alternate-database locate))
