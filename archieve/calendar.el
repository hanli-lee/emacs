(use-package async
  :config (progn
            (defun sw/refresh-gcal()
              (async-start
               (lambda ()
                 (message "refresh gcal")
                 (call-process "~/program/script/gcal.sh" nil nil nil))
               (lambda(result)
                 (message "gcal refreshed"))))))

(if-run-as-daemon
 (progn
   (sw/refresh-gcal)
   (run-with-idle-timer 600 t 'sw/refresh-gcal)))
