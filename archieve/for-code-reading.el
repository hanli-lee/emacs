(use-package eopengrok
  :init (progn
          (defun sw/opengrok()
            (interactive)
            (if (buffer-live-p (get-buffer eopengrok-buffer))
                (with-current-buffer eopengrok-buffer (toggle-read-only)
                                     (erase-buffer)))
            (sw/push-mark)
            (if current-prefix-arg (call-interactively 'eopengrok-find-file)
              (call-interactively 'eopengrok-find-text))
            (sw/kick-grepping-buffer "*eopengrok*"))
          (setq eopengrok-jar (expand-file-name (concat sw/user-init-d
                                                        "misc/opengrok-0.12.1/lib/opengrok.jar")))
          (setq eopengrok-ctags "/sbin/ctags"))
  :bind (:map eopengrok-mode-map
              ("q" . sw/bury-buffer-or-kill-frame))
  :commands (eopengrok-find-text eopengrok-find-file))

(setq beagrep-history nil)
(defun sw/beagrep ()
  (interactive)
  (let ((symbol (thing-at-point 'symbol))
        (for-file "")
        (orig-command compile-command))
    (if current-prefix-arg
        (setq for-file "-f "))
    (setq query (ido-completing-read (format (concat "Beagrep " (if (eq for-file "") "contents "
                                                                  "files " ) "(default " symbol
                                                                  "): ")) find-tag-history nil nil nil
                                                                  'find-tag-history symbol))
    (if (get-buffer "*beagrep*")
        (kill-buffer "*beagrep*"))
    (setq command (concat "beagrep " for-file " -e '" query "'"))
    (with-current-buffer (compilation-start command nil)
      (rename-buffer "*beagrep*")
      (sw/kick-grepping-buffer "*beagrep*")
      (highlight-regexp query compilation-warning-face))
    (switch-to-buffer-other-window "*beagrep*")
    (delete-other-windows)
    (setq compile-command orig-command)))
