(require 'dired-x)
(require 'wdired)

(setq dired-listing-switches "-lak")
(setq dired-dwim-target t)
(autoload 'wdired-change-to-wdired-mode "wdired")

(setq dired-omit-extensions '("CVS" "RCS" ".o" "~" ".bin" ".lbin" ".fasl" ".ufsl" ".a" ".ln" ".blg"
                              ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".fmt" ".tfm" ".class"
                              ".fas" ".lib" ".x86f" ".sparcf" ".lo" ".la" ".toc" ".aux" ".cp" ".fn"
                              ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs"
                              ".idx" ".lof" ".lot" ".glo" ".blg" ".bbl" ".cp" ".cps" ".fn" ".fns"
                              ".ky" ".kys" ".pg" ".pgs" ".tp" ".tps" ".vr" ".vrs" ".gv" ".gv.pdf"))
(setq dired-omit-files "^\\.")

(setq dired-recursive-copies 'always
      dired-recursive-deletes 'always)

(defun my-start-process-shell-command (cmd)
  "Don't create a separate output buffer."
  (start-process-shell-command cmd nil cmd))

;; redefine this function to disable output buffer.

(defun dired-run-shell-command (command)
  (let ((handler
	 (find-file-name-handler (directory-file-name default-directory)
				 'shell-command)))
    (if handler (apply handler 'shell-command (list command))
      (my-start-process-shell-command command)))
  ;; Return nil for sake of nconc in dired-bunch-files.
  nil)

(add-hook 'dired-mode-hook
          (lambda ()
            (interactive)
            (make-local-variable  'dired-sort-map)
            (dired-hide-details-mode t)
            (setq dired-sort-map (make-sparse-keymap))
            (define-key dired-mode-map "!" 'dired-do-async-shell-command)
            (define-key dired-mode-map "s" dired-sort-map)
            (define-key dired-sort-map "s"
              '(lambda () "sort by Size"
                 (interactive) (dired-sort-other (concat dired-listing-switches "S"))))
            (define-key dired-sort-map "x"
              '(lambda () "sort by eXtension"
                 (interactive) (dired-sort-other (concat dired-listing-switches "X"))))
            (define-key dired-sort-map "t"
              '(lambda () "sort by Time"
                 (interactive) (dired-sort-other (concat dired-listing-switches "t"))))
            (define-key dired-sort-map "n"
              '(lambda () "sort by Name"
                 (interactive) (dired-sort-other (concat dired-listing-switches ""))))))

(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

(define-key dired-mode-map (kbd "F") 'dired-do-find-marked-files)

(define-key dired-mode-map (kbd "M-<")
  (lambda ()
    (interactive)
    (beginning-of-buffer)
    (dired-hacks-next-file)))

(define-key dired-mode-map (kbd "M->")
  (lambda ()
    (interactive)
    (end-of-buffer)
    (dired-hacks-next-file)))

(setq dired-garbage-files-regexp "\\.\\(?:aux\\|out\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|class\\)\\'")

(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
		 (match-string 1))))))

(define-key dired-mode-map (kbd "?") 'dired-get-size)

(eval-after-load "dired-aux"
     '(require 'dired-async))

(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
(defalias 'dired-attach-file 'gnus-dired-attach)
(define-key dired-mode-map "A" 'gnus-dired-attach)

(require 'dired-hacks-utils)
(require 'dired-filter)
(define-key dired-mode-map (kbd "/") dired-filter-map)
(require 'dired-ranger)

(setq dired-filter-group-saved-groups
      '(("default"
         ("Archives"
          (extension "zip" "rar" "gz" "bz2" "tar"))
         ("Directory"
          (directory))
         ("Media"
          (extension "mp3" "mp4" "avi" "rm" "mkv"))
         ("Image"
          (extension "bmp" "gif" "jpg" "png" "jpeg")))))

(define-key dired-mode-map (kbd "C-n") 'dired-hacks-next-file)
(define-key dired-mode-map (kbd "C-p") 'dired-hacks-previous-file)
(add-hook 'dired-mode-hook
          (lambda ()
            (dired-filter-mode t)
            (dired-filter-group-mode t)))

(require 'dired-rainbow)
(dired-rainbow-define media "#ce5c00" ("mp3" "mp4" "MP3" "MP4" "avi" "mpg" "flv" "ogg"))
(dired-rainbow-define log (:inherit default :italic t) ".*\\.log")

(setq dired-guess-shell-alist-user
      (list
       (list "\\.html\\|xml$" "google-chrome")
       (list "\\.jpg\\|.png" "feh")
       '("\\.docx?$\\|.pptx?$\\|.xls$" "soffice")))
