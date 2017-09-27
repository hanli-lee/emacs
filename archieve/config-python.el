(use-package ein-loaddefs
  :if (with-executable "jupyter-notebook")
  :init (progn
          (defun ein ()
            (interactive)
            (let ((buffer-name "*jupyter*"))
              (unless (get-buffer buffer-name)
                (start-process "jupyter" buffer-name "jupyter-notebook" "--notebook-dir=~/jupyter"
                               "--no-browser")
                (sit-for 3)))
            (ein:notebooklist-open 8888)))
  :commands (ein:notebooklist-open))
