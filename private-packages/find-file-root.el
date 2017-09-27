(defvar find-file-root-prefix "/sudo:root@localhost:")
(defvar find-file-root-history nil)

(defun find-file-root ()
  (interactive)
  (require 'tramp)
  (let* ((file-name-history find-file-root-history)
   	 (name (or buffer-file-name default-directory))
   	 (tramp (and (tramp-tramp-file-p name)
                    (tramp-dissect-file-name name)))
   	 path dir file)
    (when tramp
      (setq path (tramp-file-name-path tramp)
   	    dir (file-name-directory path)))

    (when (setq file (read-file-name "Find file (UID = 0): " dir path))
      (find-file (concat find-file-root-prefix file))
      (setq find-file-root-history file-name-history))))

(provide 'find-file-root)
