(require 'ido)
(setq ido-use-virtual-buffers t)
;; (defface ido-filecache'((t :inherit font-lock-builtin-face))
;;   "Face used by Ido for matching virtual buffer names."
;;   :version "24.1"
;;   :group 'ido)

(defface ido-filecache'((t (:foreground "dark gray")))
  "Face used by Ido for matching virtual buffer names."
  :version "24.1"
  :group 'ido)

(defadvice ido-add-virtual-buffers-to-list (after ido-add-filecache activate)
  ;; (setq ido-virtual-buffers nil)
  (let (basename)
    (dolist (head file-cache-alist)
      (setq basename (car head))
      (if (= (length (cdr head)) 1)
          (push (cons basename (concat (car (cdr head)) "/" basename)) ido-virtual-buffers)
        (dolist (dir (cdr head))
          (push (cons (concat basename "@" (file-name-nondirectory
                                            (directory-file-name (file-name-directory dir))))
                      (concat dir "/" basename)) ido-virtual-buffers)))))
  (when ido-virtual-buffers
    (if ido-use-faces
	(dolist (comp ido-virtual-buffers)
	  (put-text-property 0 (length (car comp))
			     'face 'ido-filecache
			     (car comp))))
    (setq ido-temp-list
          (nconc ido-temp-list
                 (nreverse (mapcar #'car ido-virtual-buffers))))))

(defadvice ido-kill-buffer-at-head (after ido-kill-filecache activate)
  (let ((buf (ido-name (car ido-matches))))
    (if (assoc buf ido-virtual-buffers)
        (progn
          (setq file-cache-alist (remove-if (lambda(l) (string= (car l) buf)) file-cache-alist))))))

(provide 'ido-filecache)
