(require 'mu4e)

(defun sw/mu4e-headers-goto-thread-end ()
  (interactive)
  (let*
      ((msg
        (mu4e-message-at-point))
       (last-point (point))
       (thread-id (mu4e~headers-get-thread-info msg 'thread-id)))
    (mu4e-headers-for-each
     (lambda (mymsg)
       (let
           ((my-thread-id
             (mu4e~headers-get-thread-info mymsg 'thread-id)))
         (when (string= thread-id (mu4e~headers-get-thread-info mymsg 'thread-id))
           (when (< last-point (point))
             (setq last-point (point)))))))
    (goto-char last-point)
    (hl-line-mode t)))

(defun sw/mu4e-headers-goto-thread-head ()
  (interactive)
  (let*
      ((msg
        (mu4e-message-at-point))
       (first-point (point))
       (thread-id (mu4e~headers-get-thread-info msg 'thread-id)))
    (mu4e-headers-for-each
     (lambda (mymsg)
       (let
           ((my-thread-id
             (mu4e~headers-get-thread-info mymsg 'thread-id)))
         (when (string= thread-id (mu4e~headers-get-thread-info mymsg 'thread-id))
           (when (> first-point (point))
             (setq first-point (point)))))))
    (message (concat "goto: " (int-to-string first-point)))
    (goto-char first-point)
    (hl-line-mode t)))

(defun sw/mu4e-headers-same-user()
  (interactive)
  (let*
      ((msg
        (mu4e-message-at-point))
       from)
    (setq from (car (car (mu4e-message-field msg :from))))

    (unless from
      (setq from (cdr (car (mu4e-message-field msg :from)))))

    (if (string= from "wei.sun")
        (progn
          (setq from (car (car (mu4e-message-field msg :to))))
          (unless from
            (setq from (cdr (car (mu4e-message-field msg :to)))))
          (unless from
            (setq from "no-name"))
          (setq is-reply t)))

    (if (string-match ".*(\\(.*\\)).*" from)
        (setq from (match-string 1 from)))
    (mu4e-headers-search (concat "f:" from " date:5m..now"))))

(define-key mu4e-headers-mode-map (kbd "=") 'sw/mu4e-headers-goto-thread-head)
(define-key mu4e-headers-mode-map (kbd "\\") 'sw/mu4e-headers-goto-thread-end)
(define-key mu4e-headers-mode-map (kbd "K") 'mu4e-headers-mark-for-read)
(define-key mu4e-headers-mode-map (kbd "p") (lambda()
                                              (interactive)
                                              (mu4e-action-show-thread (mu4e-message-at-point))))
(define-key mu4e-headers-mode-map (kbd "I") 'mu4e-headers-mark-for-flag)
(define-key mu4e-headers-mode-map (kbd "/") 'mu4e-headers-search)
(define-key mu4e-headers-mode-map (kbd "s") 'mu4e-headers-search-bookmark)
(define-key mu4e-headers-mode-map (kbd "f") 'mu4e-headers-mark-all-unread-read)

(define-key mu4e-headers-mode-map (kbd "j") 'next-line)
(define-key mu4e-headers-mode-map (kbd "k") 'previous-line)

(define-key mu4e-headers-mode-map (kbd "C-M-p") 'sw/switch-or-compose-mail)
(define-key mu4e-headers-mode-map (kbd "c") 'sw/switch-or-compose-mail)
(define-key mu4e-headers-mode-map (kbd "C-M-r") 'mu4e-compose-reply)
(define-key mu4e-headers-mode-map (kbd "r") 'mu4e-compose-reply)
(define-key mu4e-headers-mode-map (kbd "C-M-c") 'mu4e-compose-forward)
;; (define-key mu4e-headers-mode-map (kbd "f") 'mu4e-compose-forward)
(define-key mu4e-view-mode-map (kbd "C-M-p") 'sw/switch-or-compose-mail)
(define-key mu4e-view-mode-map (kbd "c") 'sw/switch-or-compose-mail)
(define-key mu4e-view-mode-map (kbd "C-M-r") 'mu4e-compose-reply)
(define-key mu4e-view-mode-map (kbd "r") 'mu4e-compose-reply)
(define-key mu4e-view-mode-map (kbd "C-M-c") 'mu4e-compose-forward)
(define-key mu4e-view-mode-map (kbd "f") 'mu4e-compose-forward)

(define-key mu4e-headers-mode-map (kbd "C-M-u") 'sw/mu4e-headers-same-user)

(define-key mu4e-headers-mode-map (kbd "x")
  (lambda()
    (interactive)
    (mu4e-headers-search "flag:flagged")))

(provide 'mu-bbs-key-binding)
