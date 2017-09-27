(add-hook 'org-src-mode-hook 'sw/set-header-line)
(defun sw/set-header-line()
  (if (or (buffer-narrowed-p) (org-src-edit-buffer-p))
      (setq header-line-format
            (propertize (concat "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬" (make-string 200 ?\s)) 'face 'warning))))

(defun narrow-or-widen-dwim (p)
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (progn
                                             (setq header-line-format nil)
                                             (widen)
                                             (recenter)))
        ((region-active-p)
         (progn
           (narrow-to-region (region-beginning) (region-end))))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing command.
         ;; Remove this first conditional if you don't want it.
         (cond ((ignore-errors (org-edit-src-code))
                (delete-other-windows))
               ((org-at-block-p)
                (org-narrow-to-block))
               (t (org-narrow-to-subtree))))
        (t (progn
             (narrow-to-defun))))
  (sw/set-header-line))

(eval-after-load 'org-src
  '(define-key org-src-mode-map
     "\C-xn" #'org-edit-src-exit))

(provide 'narrow-dwim)
