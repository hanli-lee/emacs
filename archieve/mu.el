(defun mu4e-message-body-text (msg &optional prefer-html)
  "Get the body in text form for this message.
This is either :body-txt, or if not available, :body-html converted
to text, using `mu4e-html2text-command' is non-nil, it will use
that. Normally, thiss function prefers the text part, but this can
be changed by setting `mu4e-view-prefer-html'."
  (let* ((txt (mu4e-message-field msg :body-txt))
         (html (mu4e-message-field msg :body-html))
         (body
          (cond
           ;; does it look like some text? ie., if the text part is more than
           ;; mu4e-view-html-plaintext-ratio-heuristic times shorter than the
           ;; html part, it should't be used
           ;; This is an heuristic to guard against 'This messages requires
           ;; html' text bodies.
           ((and (> (* mu4e-view-html-plaintext-ratio-heuristic
                      (length txt)) (length html))
                ;; use html if it's prefered, unless there is no html
                (or (not mu4e-view-prefer-html) (not html)))
            txt)
           ;; otherwise, it there some html?
           (html
            (with-temp-buffer
              (insert html)
              (cond
               ((stringp mu4e-html2text-command)
                (let* ((tmp-file (mu4e-make-temp-file "html"))
                       (coding-system-for-write 'utf-8))
                  (write-region (point-min) (point-max) tmp-file)
                  (erase-buffer)
                  (call-process-shell-command mu4e-html2text-command tmp-file t t)
                  (delete-file tmp-file)))
               ((functionp mu4e-html2text-command)
                (funcall mu4e-html2text-command))
               (t (mu4e-error "Invalid `mu4e-html2text-command'")))
              (buffer-string)))
           (t ;; otherwise, an empty body
            ""))))
    ;; and finally, remove some crap from the remaining string; it seems
    ;; esp. outlook lies about its encoding (ie., it says 'iso-8859-1' but
    ;; really it's 'windows-1252'), thus giving us these funky chars. here, we
    ;; either remove them, or replace with 'what-was-meant' (heuristically)
    (with-temp-buffer
      (insert body)
      (goto-char (point-min))
      (while (re-search-forward "[ ]" nil t)
        (replace-match
         (cond
          ((string= (match-string 0) "") "'")
          (t		                       ""))))
      (buffer-string))))
