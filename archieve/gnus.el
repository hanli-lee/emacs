(load-file "~/.elisp/dotemacs/mail.el")
(require 'gnus-sum)
(require 'gnus-harvest)
(require 'message-x)
(gnus-harvest-install 'message-x)

(setq mail-user-agent  'gnus-user-agent)
(setq read-mail-command 'gnus)

(setq gnus-use-cache 'passive)
;; (setq gnus-cache-enter-articles  '(ticked dormant unread read))
;; (setq gnus-cache-remove-articles nil)
(setq gnus-large-newsgroup nil)
(setq gnus-check-new-newsgroups nil)

(setq mail-sources '((directory :path "~/.mail" :suffix ".spool")))
;; (add-to-list 'mail-sources '(pop :server "localhost"
;;                                   :user "hl09083253cy@126.com"
;; 				  :password "xxxxx"
;; 				  :port 1110
;; 				  ))

(setq gnus-select-method '(nnml ""))
;; (setq gnus-select-method '(nnimap "QMail"
;;  				  (nnimap-address "imap.qq.com")   ; it could also be imap.googlemail.com if that's your server.
;;  				  (nnimap-server-port 143)
;;  				  (nnimap-stream network)))


(setq gnus-use-nocem t)
;; (add-hook 'mail-citation-hook 'sc-cite-original)
(setq gnus-confirm-mail-reply-to-news t
      message-kill-buffer-on-exit t
      message-elide-ellipsis "[...]\n"
      )

;;排序
(setq gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date)
      gnus-sort-gathered-threads-function 'gnus-thread-sort-by-most-recent-date)

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
;;中文设置
(setq gnus-summary-show-article-charset-alist
      '((1 . cn-gb-2312) (2 . big5) (3 . gbk) (4 . utf-8)))
;; (setq
;;  gnus-default-charset 'cn-gb-2312       
;;  gnus-group-name-charset-group-alist '((".*" . cn-gb-2312))
;;  gnus-newsgroup-ignored-charsets
;;  '(unknown-8bit x-unknown iso-8859-1 ISO-8859-15 x-gbk GB18030 gbk DEFAULT_CHARSET))

(eval-after-load "mm-decode"
  '(progn
     (add-to-list 'mm-discouraged-alternatives "text/html")
     (add-to-list 'mm-discouraged-alternatives "text/richtext")))

(setq gnus-posting-styles
      '((".*"
	 (address "hl09083253cy@126.com")
	 (name "韩立")
	 (organization "Xiaomi")
	 (signature my-fortune-signature)
	 )
	))
(add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)
(setq gnus-group-line-format
      "%M\%S\%p\%P\%5y: %(%-40,40g%) %ud\n")
(defun gnus-user-format-function-d (headers)
  (let ((time (gnus-group-timestamp gnus-tmp-group)))
    (if time
	(format-time-string "%b %d  %H:%M" time)
      "")))

(defadvice message-send (around my-confirm-message-send)
  (if (yes-or-no-p "send it ? ")
      ad-do-it))
(ad-activate 'message-send)

(setq gnus-extract-address-components
      'mail-extract-address-components)

(setq gnus-uu-user-view-rules
      (list
       '("\\\\.\\(doc\\|xsl\\)$" "soffice %s")
       )
      )
;; (setq message-default-mail-headers "Cc: \n")

;; (setq gnus-visible-headers "^From:\\|^Subject:\\|^To:\\|^Cc:\\|^Bcc:")
(setq gnus-visible-headers "^From:\\|^Subject:")
(setq gnus-message-archive-group
      '("nnml:inbox" "nnml:sent"))


;; (setq nnmail-expiry-wait-function
;;       (lambda (group)
;; 	(cond ((string= group "todo")
;; 	       1)
;; 	      ((string= group "archives")
;; 	       1)
;; 	      (t
;; 	       1))))

(add-hook 'gnus-summary-mode-hook 'my-setup-hl-line)
(add-hook 'gnus-summary-prepared-hook 'gnus-summary-hide-all-threads)
(add-hook 'gnus-group-mode-hook 'my-setup-hl-line)
(defun my-setup-hl-line ()
  (hl-line-mode 1)
  )
(gnus-add-configuration '(article (vertical 1.0 (summary .35 point) (article 1.0))))
(setq gnus-check-new-newsgroups nil
      gnus-read-active-file 'some
      gnus-nov-is-evil nil)

(setq gnus-use-adaptive-scoring '(line))
(setq gnus-default-adaptive-score-alist
      '((gnus-unread-mark)
	(gnus-ticked-mark (from 5) (subject 10))
	(gnus-dormant-mark (from 5) (subject 10))
	(gnus-replied-mark (from 2) (subject 4))
	(gnus-forwarded-mark (from 2) (subject 4))
	(gnus-read-mark (from 1) (subject 2))
	
	(gnus-del-mark)
	(gnus-expirable-mark (from -2) (subject -4))
	(gnus-killed-mark (from -1) (subject -2))
	(gnus-kill-file-mark (from -1) (subject -2))
	(gnus-ancient-mark)
	(gnus-low-score-mark)
	(gnus-catchup-mark (from -1) (subject -1))))
(add-hook 'gnus-started-hook '(lambda()
				(gnus-demon-add-handler 'gnus-demon-scan-news 30 1)
				))
(setq gnus-asynchronous t)
(add-hook 'gnus-after-getting-new-news-hook 'sw/gnus-check-mail-1)

(setq my-gnus-new-mail -1)

(defun sw/gnus-check-mail-1 (&rest ignored)
  (interactive)
  (let ((all-unread 0)
	)
    (mapc '(lambda (g)
	     (let* ((group (car g))
		    (unread (gnus-group-unread group)))
	       (when (and (numberp unread) (> unread 0) (string= group "inbox"))
		 (incf all-unread unread)
		 )
	       ))
	  gnus-newsrc-alist)
    (setq my-gnus-new-mail all-unread)
    (unless (= all-unread 0)
      (progn
	(save-window-excursion
	  (save-excursion
	    (when (gnus-alive-p)
	      (set-buffer gnus-group-buffer)
	      (goto-char (point-min))
	      (search-forward-regexp "inbox")
	      (gnus-topic-read-group)
              (gnus-summary-exit)
	      ;; (gnus-group-save-newsrc t)
	      (gnus-summary-save-newsrc t)
	      )))
	(sw/gnus-check-mail-2)
	))))

(defun sw/gnus-check-mail-2 (&rest ignored)
  (interactive)
  (let ((all-unread 0))
    (mapc '(lambda (g)
	     (let* ((group (car g))
		    (unread (gnus-group-unread group)))
	       (when (and (numberp unread) (> unread 0) (string= group "inbox"))
		 (incf all-unread unread)
		 )))
	  gnus-newsrc-alist)
    (setq my-gnus-new-mail all-unread)
    (unless (= all-unread 0)
      (progn
	(alert (format "%d new mail" all-unread))
	))))

(setq default-mode-line-format (sw/insert-after default-mode-line-format 5 '(:eval
									     (cond ((> my-gnus-new-mail 0)
										    (propertize (format " [M:%d]" my-gnus-new-mail) 'face 'bold))
										   ;; ((< my-gnus-new-mail 0)
										   ;;  (propertize " [M:nil]" 'face 'bold))
										   ))))

(define-key gnus-group-mode-map (kbd "m") 'sw/switch-or-compose-mail)
(define-key gnus-group-mode-map (kbd "q") 'bury-buffer)
(define-key gnus-group-mode-map (kbd "C-x k") 'bury-buffer)
(define-key gnus-summary-mode-map (kbd "f") '(lambda()
					       (interactive)
					       (gnus-summary-mail-forward 3)
					       ))
(define-key gnus-article-mode-map (kbd "S-SPC") 'gnus-article-goto-prev-page)
(define-key gnus-article-mode-map (kbd "A") 'gnus-add-appt)
(define-key gnus-summary-mode-map (kbd "A") 'gnus-add-appt)
(define-key gnus-summary-mode-map (kbd "S-SPC") 'gnus-summary-prev-page)
(define-key gnus-summary-mode-map (kbd "C-k") 'gnus-summary-delete-article)
(define-key gnus-summary-mode-map (kbd "o") 'gnus-summary-copy-article)
(define-key gnus-summary-mode-map (kbd "//") 'gnus-summary-pop-limit)
(define-key gnus-summary-mode-map (kbd "C-o") nil)
(define-key gnus-summary-mode-map (kbd "r") '(lambda ()
					       (interactive)
					       (if current-prefix-arg
						   (gnus-summary-reply)
						   (gnus-summary-wide-reply))))
(define-key message-mode-map (kbd "C-c C-i") 'mml-attach-file)
(define-key message-mode-map (kbd "C-c i") 'mml-attach-file)

(copy-face 'font-lock-variable-name-face 'gnus-face-6)
(setq gnus-face-6 'gnus-face-6)
(copy-face 'font-lock-constant-face 'gnus-face-7)
(setq gnus-face-7 'gnus-face-7)
(copy-face 'gnus-face-7 'gnus-summary-normal-unread)
(copy-face 'font-lock-constant-face 'gnus-face-8)
(set-face-foreground 'gnus-face-8 "gray50")
(setq gnus-face-8 'gnus-face-8)
(copy-face 'font-lock-constant-face 'gnus-face-9)
(set-face-foreground 'gnus-face-9 "gray70")
(setq gnus-face-9 'gnus-face-9)
(setq gnus-summary-make-false-root 'adopt)
;; (setq gnus-summary-make-false-root-always nil)
(setq gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-root "■ "
      gnus-sum-thread-tree-false-root "□ "
      gnus-sum-thread-tree-single-indent "▣ "
      gnus-sum-thread-tree-leaf-with-other "├─▶ "
      gnus-sum-thread-tree-vertical "│"
      gnus-sum-thread-tree-single-leaf "└─▶ ")
;; (add-to-list 'load-path "~/.elisp/bbdb")
;; (require 'bbdb)
;; (bbdb-initialize 'gnus 'message)
;; (bbdb-insinuate-gnus)

;; (setq bbdb-complete-name-allow-cycling t)
;; (setq bbdb-mua-pop-up nil)

;; (setq bbdb/news-auto-create-p nil)
;; (setq bbdb/news-auto-create-p 'bbdb-ignore-some-messages-hook)
;; (setq bbdb-ignore-some-messages-alist
;;       '(("From" . "Review")))
;; (setq bbdb/gnus-summary-known-poster-mark " ")

(setq mm-w3m-safe-url-regexp ".*")

(defalias 'mm 'gnus)

(defun sw/switch-or-compose-mail()
    (interactive)
    (if (get-buffer "*unsent mail*")
        (switch-to-buffer "*unsent mail*")
      (progn 
        (unless (get-buffer "*Group*")
         (save-window-excursion
           (gnus)
           )
         )
        (compose-mail))))

(global-set-key (kbd "C-x m") 'sw/switch-or-compose-mail)

(add-hook 'gnus-suspend-gnus-hook '(lambda()
				     (gnus-group-save-newsrc t)
				     ))

(setq mm-text-html-renderer 'w3m)

(defun gnus-user-format-function-S (head)
  "Return pretty-printed version of message size.

Like `gnus-summary-line-message-size' but more verbose.  This function is
intended to be used in `gnus-summary-line-format-alist', with
\(defalias 'gnus-user-format-function-X 'rs-gnus-summary-line-message-size).

See (info \"(gnus)Group Line Specification\")."
  (let ((c (or (mail-header-chars head) -1)))
    (gnus-message 9 "c=%s chars in article %s" c (mail-header-number head))
    (cond ((< c 0) "n/a") ;; chars not available
	  ((< c (* 1000))       (format "%db"  c))
	  ((< c (* 1000 10))    (format "%dk" (/ c 1024.0)))
	  ((< c (* 1000 1000))  (format "%dk" (/ c 1024.0)))
	  ((< c (* 1000 10000)) (format "%dM" (/ c (* 1024.0 1024))))
	  (t (format "%dM" (/ c (* 1024.0 1024)))))))

(defun gnus-user-format-function-A (header)
  "Display @ for message with attachment in summary line.
You need to add `Content-Type' to `nnmail-extra-headers' and
`gnus-extra-headers', see Info node `(gnus)To From Newsgroups'."
  (let ((case-fold-search t)
        (ctype (or (cdr (assq 'Content-Type (mail-header-extra header)))
		  "text/plain"))
        (indicator " "))
    (when (string-match "^multipart/mixed" ctype)
      (setq indicator "@"))
    indicator))

(setq gnus-user-date-format-alist
      '(((gnus-seconds-today) . "%H:%M")
        ((+ 86400 (gnus-seconds-today)) . "Yest, %H:%M")
        (604800 . "%a %H:%M") ;;that's one week
        ((gnus-seconds-month) . "%a %d")
        ((gnus-seconds-year) . "%b %d")
        ((* 30 (gnus-seconds-year)) . "%b %d '%y")
        (t . "")))

(setq nnmail-extra-headers
      '(To Cc Newsgroups Content-Type Thread-Topic Thread-Index))

(add-to-list 'gnus-extra-headers 'Content-Type)
(add-to-list 'gnus-extra-headers 'To)

(setq gnus-face-9  'font-lock-warning-face
      gnus-face-10 'shadow
      gnus-face-11 'vbe:proportional
      gnus-summary-line-format
      (concat
       "%10{%U%R%z%}" " " "%1{%11,11&user-date;%}"
       "%10{│%}"
       "%9{%u&A;%}" "%(%-15,15uC %)"
       "%*"
       "%5k"
       "  " "%10{%B%}"
       "%s\n"
       ))


(defvar my-message-attachment-regexp "\\(attach\\|附件\\)")
;; the function that checks the message
(defun my-message-check-attachment nil
  "Check if there is an attachment in the message if I claim it."
  (save-excursion
    (message-goto-body)
    (when (search-forward-regexp my-message-attachment-regexp nil t nil)
      (message-goto-body)
      (unless (or (search-forward "<#part" nil t nil)
		 (message-y-or-n-p
		  "No attachment. Send the message ?" nil nil))
  	(error "No message sent")))))
(add-hook 'message-send-hook 'my-message-check-attachment)

(setq gnus-gcc-mark-as-read t)

(setq gnus-auto-select-first nil)
(setq gnus-auto-select-subject 'best)
(setq message-wash-forwarded-subjects t)
(setq message-make-forward-subject-function (quote message-forward-subject-fwd))
(add-hook 'message-sent-hook 'gnus-score-followup-thread)

(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "On %a, %b %d %Y, %f wrote:\n")

(setq gnus-fetch-old-headers 'some)

(setq gnus-novice-user nil)

(setq
 nndraft-directory "~/Mail/drafts/"
 gnus-directory "~/Mail/news/"
 gnus-article-save-directory "~/Mail/news"
 gnus-cache-directory "~/Mail/cache"
 gnus-cache-active-file "~/Mail/cache/active"
 gnus-kill-files-direcotry "~/Mail/news"
 gnus-home-score-file "~/Mail/score/SCORE"
 gnus-home-adapt-file "~/Mail/score/ADAPT.SCORE"
 mail-source-delete-incoming t
 )

(setq nnmail-split-methods
      '(("inbox" "")))

;; (setq nnmail-expiry-target "nnfolder+archive:archive")
(defun sw/gnus-expiry-target (group)
  "inbox and sent are archived, the rest is deleted"
  (concat "backup"
	  (format-time-string "-%Y" (sw/gnus-get-article-date))))

(defun sw/gnus-get-article-date ()
  "Extracts the date from the current article and converts it to Emacs time"
  (save-excursion
    (goto-char (point-min))
    (ignore-errors
      (gnus-date-get-time (message-fetch-field "date")))))

(setq nnmail-expiry-target 'sw/gnus-expiry-target)

(defun gnus-user-format-function-C (header)
  (let*  ((from (mail-header-from header))
	  )
    (if (string-match ".*(\\(.*\\)).*" from)
	(format " %s" (match-string 1 from))
      (concat " " from)
      ;; (gnus-user-format-function-B header)
      )))

(setq message-subject-re-regexp
      (concat
       "^[ \t]*"
       "\\("
       "\\("
       "[Ff][Ww][Dd]?\\|"
       "[Rr][Ee]\\|"
       "答复\\|"
       "转发"
       "\\)"
       "\\(\\[[0-9]*\\]\\)"
       "*:[ \t]*"
       "\\)"
       "*[ \t]*"
       ))

(setq mail-source-ignore-errors t)


(defun gnus-add-appt nil
  (interactive)
  (save-excursion
    (with-current-buffer gnus-article-buffer
      (message-goto-body)
      (call-interactively 'org-store-link)
      ;; When: 
      ;; 2015年10月14日, 14:00 (2 hrs), China Time (Beijing, GMT+08:00).
      (let ((y)
            (m)
            (d)
            (time))
        (cond ((search-forward-regexp "^时间: \\([0-9]+\\)年\\([0-9]+\\)月\\([0-9]+\\)日.*? \\(.*?\\)-" nil t nil)
               (setq y (match-string 1))
               (setq m (match-string 2))
               (setq d (match-string 3))
               (setq time (match-string 4))
               )
              ((search-forward-regexp "\\([0-9]+\\)年\\([0-9]+\\)月\\([0-9]+\\)日, \\(.*?\\) \(" nil t nil)
               (setq y (match-string 1))
               (setq m (match-string 2))
               (setq d (match-string 3))
               (setq time (match-string 4))
               )
              (t (setq y nil))
              )
        (if y
            (progn
              (message (concat "year:" y))
              (with-temp-buffer
                (insert "\n")
                (insert (format "* [[%s][%s]] :work:" (car (car org-stored-links)) (s-truncate 40 (cadr (car org-stored-links)))))
                (insert "\n")
                (if (eq (string-width m) 1)
                    (setq m (concat "0" m))
                  )
                (if (eq (string-width d) 1)
                    (setq d (concat "0" d))
                  )
                (insert (format "DEADLINE: <%s-%s-%s %s>" y m d time))
                (append-to-file (point-min) (point-max) "/home/sunway/Dropbox/gtd/appt.org")
                (org-agenda-redo t)
                )))))))

(defun mm-remove-part (handle)
  "Remove the displayed MIME part represented by HANDLE."
  (when (listp handle)
    (let ((object (mm-handle-undisplayer handle)))
      (ignore-errors
	(cond
	 ;; Internally displayed part.
	 ((mm-annotationp object)
          (if (featurep 'xemacs)
              (delete-annotation object)))
	 ((or (functionp object)
	     (and (listp object)
		(eq (car object) 'lambda)))
	  (funcall object))
	 ;; Externally displayed part.
	 ((consp object)
	  (ignore-errors (delete-file (car object)))
	  (ignore-errors (delete-directory (file-name-directory
					    (car object)))))
	 ((bufferp object)
	  (when (buffer-live-p object)
	    (kill-buffer object)))))
      (mm-handle-set-undisplayer handle nil))))

(setq gnus-mail-save-name '(lambda(newsgroup headers &optional ignore)
			     "todo"))

(setq gnus-simplify-ignored-prefixes "\\(Re?\\|RE?\\|回覆?\\|回复?\\|答复?\\): *")
(setq gnus-simplify-subject-functions '(gnus-simplify-subject-re
                                        gnus-simplify-subject-fuzzy
                                        gnus-simplify-whitespace))

(setq are-threads-hidden t)
(defun gnus-summary-toggle-thread-hiding ()
  (interactive)
  (make-local-variable 'are-threads-hidden)
  (if (and (boundp 'are-threads-hidden) are-threads-hidden)
      (progn
	(gnus-summary-show-all-threads)
	(setq are-threads-hidden nil))
    (gnus-summary-hide-all-threads)
    (setq are-threads-hidden t)))

(define-key gnus-summary-mode-map (kbd "M-I") 'gnus-summary-toggle-thread-hiding)

(define-key gnus-summary-mode-map (kbd "h")
  'gnus-article-browse-html-article)
(setq gnus-article-browse-delete-temp t)

;; Attach files in dired
(require 'gnus-dired)
(define-key dired-mode-map (kbd "a") 'gnus-dired-attach)
(add-to-list 'load-path "~/elisp")

(defun gnutls-available-p ()
  "Function redefined in order not to use built-in GnuTLS support"
  nil)
