(setq auto-chmod-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
	    "^#!/usr/.*/sh"
	    "^#!/usr/.*/bash"
	    "^#!/bin/sh"
	    "^#!/.*perl"
	    "^#!/.*python"
	    "^#!/.*awk"
	    "^#!/.*sed"
	    "^#!/.*ruby"
	    "^#!/bin/bash"
	    "^#!.*env .*"))

(when (eq system-type 'gnu/linux)
  (add-hook
   'after-save-hook
   (lambda ()
     (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
         (progn
           (message (concat "Wrote " (buffer-file-name)))
           (save-excursion
             (goto-char (point-min))
             (dolist (pattern auto-chmod-shebang-patterns)
               (if (looking-at pattern)
                   (if (= (shell-command
                           (concat "chmod u+x " (buffer-file-name)))
                          0)
                       (message (concat
                                 "Wrote and made executable "
                                 (buffer-file-name))))))))
       (message (concat "Wrote " (buffer-file-name)))))))

(provide 'auto-chmod)
