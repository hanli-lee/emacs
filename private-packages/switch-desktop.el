;; Installation:
;; (require 'switch-desktop)
;; (switch-desktop-mode t)
;;
;; Usage:
;; M-x switch-session
;; M-x remove-session
;;
;; note:
;; you should turn `desktop-save-mode` off before tunring on switch-desktop-mode
;;
;; Acknowledgement:
;; http://stackoverflow.com/questions/847962/what-alternate-session-managers-are-available-for-emacs
;;

(require 'desktop)
(require 'breadcrumb)

(defvar switch-desktop-session-dir
  (concat (getenv "HOME") "/.emacs.d/desktop-sessions/")
  "*Directory to save desktop sessions in")

(defvar switch-desktop-last-session-file
  (concat (getenv "HOME") "/.emacs.d/desktop-last-session")
  "*Directory to save desktop sessions in")

(defvar switch-desktop-session-name-hist nil
  "Desktop session name history")

(defun switch-desktop-save (&optional name)
  "Save desktop by name."
  (interactive)
  (if desktop-lazy-timer
      (message "skip desktop-save when lazy loading desktop")
    (progn
      (unless name
        (setq name (switch-desktop-ask-session-name "Save session" t)))
      (when name
        (make-directory (concat switch-desktop-session-dir name) t)
        (desktop-save (concat switch-desktop-session-dir name) t)
        (ignore-errors
          (wg-save-session)
          (bc-bookmarks-save))))))

(defun goto-session-root()
  (interactive)
  (find-file (get-session-root)))

(defun get-session-root()
  (if (and (boundp 'session-root-directory) session-root-directory)
      session-root-directory
    (set-session-root)
    (get-session-root)))

(defun set-session-root ()
  (interactive)
  (setq session-root-directory (read-directory-name "set session root directory: " default-directory
                                                    default-directory t)))
(defun switch-desktop-read (&optional name)
  "Read desktop by name."
  (interactive)
  (unless name
    (setq name (switch-desktop-ask-session-name (concat "Load session ("
                                                        (switch-desktop-get-current-name) ")"))))
  (when (and name (not (string= name "")))
    (unless (file-accessible-directory-p (concat switch-desktop-session-dir name))
      (if (string= name "tmp")
          (setq session-root-directory (expand-file-name "~"))
        (setq session-root-directory nil)
        (setq session-root-directory (read-directory-name "set session root directory: "
                                                          default-directory default-directory t))))
    (make-directory (concat switch-desktop-session-dir name) t)
    (ignore-errors
      (desktop-clear))
    (setq recentf-list nil)
    (setq file-cache-alist nil)
    (setq tags-file-name nil)
    (setq tags-table-list nil)
    ;; indicator
    (setq switch-desktop-mode-indicator name)
    (desktop-read (concat switch-desktop-session-dir name))
    (setq wg-session-file (concat switch-desktop-session-dir name "/workgroups"))
    (ignore-errors
      (wg-reload-session)
      (bc-bookmarks-restore))
    (force-mode-line-update)))

(defun rename-session ()
  (interactive)
  (let (
        (name (read-string "Rename session to: "))
        (current (switch-desktop-get-current-name)))
    (if (file-exists-p (concat switch-desktop-session-dir name))
        (message (concat name " already exist"))
      (progn
        (copy-directory (concat switch-desktop-session-dir current) (concat switch-desktop-session-dir name))
        (delete-directory (concat switch-desktop-session-dir current) t)
        (switch-desktop-read name)))))

(defun remove-session ()
  (interactive)
  (setq name (switch-desktop-ask-session-name (concat "Remove session (" (switch-desktop-get-current-name) ")")))
  (setq current (switch-desktop-get-current-name))
  (if (and name (or (not current) (not (string= name current))))
      (unless (or (string= name "") (string= name "tmp"))
	(delete-directory (concat switch-desktop-session-dir name) t)
	(message (concat name " removed")))
    (message "Can't remove desktop")))

(defun dup-session ()
  (interactive)
  (let ((name (switch-desktop-get-current-name))
	(new_name (read-string "dup to:" (concat (switch-desktop-get-current-name) "-" (format-time-string "%m-%d-%T")))))
    (copy-directory (concat switch-desktop-session-dir name) (concat switch-desktop-session-dir new_name))
    (message new_name)))

(defun save-session ()
  (interactive)
  (let ((name (switch-desktop-get-current-name))
        (inhibit-message t))
    (when name
      (switch-desktop-save name)
      (save-last-session)
      (message "session saved"))))

(setq switch-desktop-confirm-save nil)

(defun switch-session ()
  (interactive)
  (let ((name (switch-desktop-get-current-name))
        (inhibit-message t))
    (if (and switch-desktop-confirm-save name)
        (if (y-or-n-p "Save current session? ")
            (switch-desktop-save name))
      (switch-desktop-save name))
    (call-interactively 'switch-desktop-read)
    (save-session)))

(defun switch-desktop-get-current-name ()
  (when desktop-dirname
    (let ((dirname (substring desktop-dirname 0 -1)))
      (file-name-nondirectory dirname))))

(defun switch-desktop-ask-session-name (prompt &optional use-default)
  (let* ((default (and use-default (switch-desktop-get-current-name)))
         (full-prompt (concat prompt (if default
                                         (concat " (default " default "): ")
                                       ": "))))
    (ido-completing-read full-prompt (and (file-exists-p switch-desktop-session-dir)
                                         (remove (switch-desktop-get-current-name) (cdr (cdr (directory-files switch-desktop-session-dir)))))
			 nil nil nil switch-desktop-session-name-hist default)))

(defun save-last-session()
  (interactive)
  (let ((buf (find-file-noselect switch-desktop-last-session-file))
        (current (switch-desktop-get-current-name)))
    (with-current-buffer buf (kill-region (point-min)
                                          (point-max))
                         (if current (insert current)
                           (insert "tmp"))
                         (write-file switch-desktop-last-session-file))))

(defun switch-desktop-kill-emacs-hook ()
  (let ((current (switch-desktop-get-current-name)))
    (if current
	(switch-desktop-save current)
      (progn
	(when (file-exists-p (concat switch-desktop-session-dir "tmp"))
	  (setq desktop-file-modtime
		(nth 5 (file-attributes (desktop-full-file-name (concat switch-desktop-session-dir "tmp"))))))
	(switch-desktop-save "tmp")))
    (save-last-session)))

(defun reload-last-session ()
  (let ((buf (find-file-noselect switch-desktop-last-session-file)))
    (setq last-session (with-current-buffer buf
			 (buffer-substring (point-min) (point-max))))
    (if last-session
	(progn
	  (setq last-session (replace-regexp-in-string "\n" "" last-session))
	  (if (string-match last-session " +")
	      (setq last-session "tmp")))
      (setq last-session "tmp"))
    (switch-desktop-read last-session)))

(add-to-list 'desktop-globals-to-save 'kill-ring)
(add-to-list 'desktop-globals-to-save 'recentf-list)
(add-to-list 'desktop-globals-to-save 'search-ring)
(add-to-list 'desktop-globals-to-save 'extended-command-history)
(add-to-list 'desktop-globals-to-save 'command-history)
(add-to-list 'desktop-globals-to-save 'beagrep-history)
(add-to-list 'desktop-globals-to-save 'find-tag-history)
(add-to-list 'desktop-globals-to-save 'minibuffer-history)
(add-to-list 'desktop-globals-to-save 'register-alist)
(add-to-list 'desktop-globals-to-save 'file-cache-alist)
(add-to-list 'desktop-globals-to-save 'compile-command)
(add-to-list 'desktop-globals-to-save 'tags-file-name)
(add-to-list 'desktop-globals-to-save 'tags-table-list)
(add-to-list 'desktop-globals-to-save 'session-root-directory)
(add-to-list 'desktop-locals-to-save 'default-directory)

(add-to-list 'desktop-globals-to-clear '*bc-bookmarks*)
(add-to-list 'desktop-globals-to-clear 'recentf-list)
(add-to-list 'desktop-globals-to-clear 'command-history)
(add-to-list 'desktop-globals-to-clear 'beagrep-history)
(add-to-list 'desktop-globals-to-clear 'find-tag-history)
(add-to-list 'desktop-globals-to-clear 'minibuffer-history)
(add-to-list 'desktop-globals-to-clear 'register-alist)
(add-to-list 'desktop-globals-to-clear 'file-cache-alist)
(add-to-list 'desktop-globals-to-clear 'compile-command)
(add-to-list 'desktop-globals-to-clear 'tags-file-name)
(add-to-list 'desktop-globals-to-clear 'tags-table-list)

(defvar switch-desktop-mode-indicator "")

(add-hook
 'after-init-hook
 (lambda ()
   (when switch-desktop-mode
     (reload-last-session))))

(define-minor-mode switch-desktop-mode
  ""
  :global t
  :group 'switch-desktop-mode
  (if switch-desktop-mode
      (progn
	(add-hook 'kill-emacs-hook 'switch-desktop-kill-emacs-hook)

        (setq sw/switch-desktop-modeline '(:eval (propertize (concat " [" switch-desktop-mode-indicator "] ") 'face 'warning)))
        (unless (member sw/switch-desktop-modeline mode-line-format)
          (set-default 'mode-line-format
                       (sw/insert-after mode-line-format 6 sw/switch-desktop-modeline)))
	(setq save-timer (run-with-timer 600 600 'save-session)))
    (remove-hook 'kill-emacs-hook 'switch-desktop-kill-emacs-hook)
    (set-default 'mode-line-format (remove '(:eval (concat "[" switch-desktop-mode-indicator "] ")) mode-line-format))
    (cancel-timer save-timer)))

(add-to-list 'desktop-modes-not-to-save 'dired-mode)

(defun switch-desktop-update-indicator ()
  (if desktop-buffer-args-list
      (setq switch-desktop-mode-indicator (concat  (switch-desktop-get-current-name) "/" (int-to-string (length desktop-buffer-args-list))))
    (setq switch-desktop-mode-indicator (switch-desktop-get-current-name))))

(defadvice desktop-lazy-create-buffer (after desktop-lazy-create-buffer-advice activate)
  (switch-desktop-update-indicator))

(add-hook 'desktop-after-read-hook 'switch-desktop-update-indicator)

(defalias 'ss 'switch-session)

(setq desktop-lazy-idle-delay 1)
(setq desktop-lazy-verbose nil)
(setq desktop-load-locked-desktop t)
(setq desktop-restore-eager 10)

;; (setq desktop-buffers-not-to-save "\\(^\\*\\|^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\)$")
(setq desktop-buffers-not-to-save ".*")
(setq desktop-files-not-to-save ".*")

(provide 'switch-desktop)
