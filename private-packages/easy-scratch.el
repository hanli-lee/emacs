(defun switch-to-scratch ()
  (interactive)
  (let ((scratch-buffer-name (get-buffer-create "*scratch*")))
    (if (equal (current-buffer) scratch-buffer-name)
        (switch-to-buffer (other-buffer))
      (switch-to-buffer scratch-buffer-name))))
(global-set-key (kbd "s-SPC") 'switch-to-scratch)

(setq persistent-scratch-filename "~/.emacs.d/persistent-scratch")

(defun save-persistent-scratch ()
  (let ((buffer (get-buffer "*scratch*")))
    (when buffer
      (with-current-buffer buffer
        (write-region (point-min)
                      (point-max) persistent-scratch-filename)))))

(defun load-persistent-scratch ()
  (if (file-exists-p persistent-scratch-filename)
      (with-current-buffer (get-buffer "*scratch*")
        (delete-region (point-min) (point-max))
        (insert-file-contents persistent-scratch-filename))))

(add-hook 'after-init-hook 'load-persistent-scratch)
(add-hook 'kill-emacs-hook 'save-persistent-scratch)

(provide 'easy-scratch)
