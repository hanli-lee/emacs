(setq message-signature nil)
(setq mu4e-compose-signature nil)
(setq mu4e-compose-signature-auto-include nil)

(defcustom adaptive-mail-signature-alist '() "nil")

(defun adaptive-mail-signature-default ()
  (insert (concat  "\n-- \n" (user-full-name) "\n")))

(defun adaptive-mail-signature-by-receiver (mail)
  (let ((to (cdr (assoc 'to mail)))
        (cc (cdr (assoc 'cc mail)))
        (bcc (cdr (assoc 'bcc mail)))
        (subject (cdr (assoc 'subject mail)))
        (receiver)
        (func 'adaptive-mail-signature-default))
    (setq receiver (concat to " " cc " " bcc))
    (dolist (x adaptive-mail-signature-alist)
      (progn
        (if (s-match (car x) receiver)
            (setq func (cdr x)))))
    func))

(defcustom adaptive-mail-signature-func
  'adaptive-mail-signature-by-receiver
  "nil")

(defun adaptive-mail-signature-insert()
  (let (to cc bcc receiver mail)
    (setq to (mail-fetch-field "to"))
    (setq cc (mail-fetch-field "cc"))
    (setq bcc (mail-fetch-field "bcc"))
    (setq subject (mail-fetch-field "subject"))
    (add-to-list 'mail (cons 'to to))
    (add-to-list 'mail (cons 'cc cc))
    (add-to-list 'mail (cons 'bcc bcc))
    (add-to-list 'mail (cons 'subject subject))
    (let ((message-signature (funcall adaptive-mail-signature-func mail)))
      (goto-char (point-max))
      (when (re-search-backward message-signature-separator (point-min) t)
        (forward-line -1)
        (while (looking-at "^[ \t]*$")
          (forward-line -1))
        (forward-line 1)
        (delete-region (point) (point-max)))
      (save-excursion
        (message-insert-signature)))))

(add-hook 'message-send-hook
          'adaptive-mail-signature-insert)

(provide 'adaptive-mail-signature)
