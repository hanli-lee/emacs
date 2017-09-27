(defun sw/ascii-table-show ()
  "Print the ascii table"
  (interactive)
  (switch-to-buffer "*ASCII table*")
  (erase-buffer)
  (let
      ((i
        0)
       (tmp 0))
    (insert (propertize "                                [ASCII table]\n\n" 'face
                        font-lock-comment-face))
    (while (< i 32)
      (dolist (tmp (list i (+ 32 i)
                         (+ 64 i)
                         (+ 96 i)))
        (insert (concat
                 (propertize (format "%3s   " (single-key-description tmp)) 'face
                             font-lock-string-face)
                 (propertize (format "%3d   " tmp) 'face font-lock-function-name-face)
                 (propertize (format "0x%2x" tmp) 'face font-lock-constant-face) "  "

                 (unless (= tmp (+ 96 i))
                   (propertize "   |   " 'face font-lock-variable-name-face)))))
      (newline)
      (setq i (+ i 1)))
    (beginning-of-buffer))
  (toggle-read-only 1))

(defun sw/count-ce-word (beg end)
  "Count Chinese and English words in marked region."
  (interactive "r")
  (let*
      ((cn-word
        0)
       (en-word 0)
       (total-word 0)
       (total-byte 0))
    (setq cn-word (count-matches "\\cc" beg end) en-word (count-matches "\\w+\\W" beg end)
          total-word (+ cn-word en-word) total-byte (+ cn-word (abs (- beg end))))
    (message (format "字数: %d (汉字: %d, 英文: %d) , %d 字节." total-word cn-word en-word
                     total-byte))))

(defun sw/move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (let
      ((col
        (current-column)) start end)
    (beginning-of-line)
    (setq start (point))
    (end-of-line)
    (forward-char)
    (setq end (point))
    (let
        ((line-text
          (delete-and-extract-region start end)))
      (forward-line n)
      (insert line-text)
      ;; restore point to original column in moved line
      (forward-line -1)
      (forward-char col))))

(defun sw/transporse-region
    (&optional
     separator)
  (interactive "P")
  (let ((beg (point))
        (sentence)
        (separator))
    (when current-prefix-arg
      (setq separator (read-string "Separator: ")))
    (kill-region beg (mark))
    (setq sentence (nth 0 kill-ring))
    (setq sentence (split-string sentence (if separator separator)))
    (setq sentence (reverse sentence))
    (setq sentence (mapconcat
                    (lambda (x)
                      x)
                    sentence (if separator separator " ")))
    (insert sentence)))

(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
(defun my-goto-match-beginning ()
  (when isearch-forward
    (goto-char isearch-other-end)))

(defadvice isearch-exit (after my-goto-match-beginning activate)
  "Go to beginning of match."
  (when isearch-forward
    (goto-char isearch-other-end)))

(defun sw/isearch-yank-sexp ()
  (interactive)
  (isearch-yank-internal
   (lambda ()
     (sp-forward-sexp 1)
     (point))))
(define-key isearch-mode-map "\C-w" 'sw/isearch-yank-sexp)

(defun sw/isearch-yank-word ()
  (interactive)
  (isearch-yank-internal
   (lambda ()
     (forward-word 1)
     (point))))
(define-key isearch-mode-map "\M-f" 'sw/isearch-yank-word)

(defun sw/unicode-table ()
  (interactive)
  (switch-to-buffer "*Unicode Table*")
  (erase-buffer)
  (insert (format "Unicode characters:\n"))
  (setq code-points (append (number-sequence  ?\x0000  ?\xffff)
                            (number-sequence ?\x10000 ?\x1ffff)
                            (number-sequence ?\x20000 ?\x2ffff)
                            (number-sequence ?\xe0000 ?\xeffff)))

  ;; Iterate code points
  (dolist (code-point code-points)
    ;; Get description from emacs internals
    (let
        ((description
          (get-char-code-property code-point 'name)))
      ;; Insert code-point, character and description
      (insert (format "%4d 0x%02X %c %s\n" code-point code-point code-point description))))
  ;; Jump to beginning of buffer
  (beginning-of-buffer))

(defun sw/clean-buffer ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; 判断多个空行
    (while (re-search-forward "^[ \t]*\n[ \t]*$" nil t)
      (delete-blank-lines)
      (forward-line))
    (delete-trailing-whitespace)))

(defun sw/dos2unix ()
  "Automate M-% C-q C-m RET RET"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m)  nil t)
      (replace-match "" nil t))))

(defun sw/unix2dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t)
    (replace-match "\r\n")))

;; pip install python-gist
(defun sw/gist ()
  (interactive)
  (let (start end command)
    (if (get-buffer "*gist*")
        (kill-buffer "*gist*"))
    (if (region-active-p)
        (progn
          (setq start (region-beginning))
          (setq end (region-end)))
      (progn
        (setq start (point-min))
        (setq end (point-max))))
    (write-region start end (concat "/tmp/" (file-name-nondirectory (buffer-file-name))))
    (setq command (concat "gist create " (buffer-file-name) " --public " (concat "/tmp/" (file-name-nondirectory (buffer-file-name))) " ; exit 1"))
    (with-current-buffer (compilation-start command nil)
      (rename-buffer "*gist*")))
  (pop-to-buffer "*gist*"))

(defun sw/buffers-live-p (l)
  (let ((buffer (car l)))
    (if buffer
        (progn
          (if (get-buffer buffer)
              (cons buffer (sw/buffers-live-p (cdr l)))
            (sw/buffers-live-p (cdr l)))))))

(defun sw/insert-after (lst index newelt)
  (push newelt (cdr (nthcdr index lst)))
  lst)

(setq sw/web-search-history nil)
(defun bing ()
  (interactive)
  (let (q)
    (setq q (ido-completing-read "bing: " sw/web-search-history nil nil (thing-at-point 'word)
                                 'sw/web-search-history))
    (browse-url (concat "http://www.bing.com/search?q=" q))))

(defun google ()
  (interactive)
  (setq q (ido-completing-read "google: " sw/web-search-history nil nil (thing-at-point 'word)
                               'sw/web-search-history))
  (browse-url (concat "http://www.google.com.tw/search?newwindow=1&site=&source=hp&q=" q)))

(defun wiki ()
  (interactive)
  (setq q (ido-completing-read "wiki: " sw/web-search-history nil nil (thing-at-point 'word)
                               'sw/web-search-history))
  (browse-url (concat "https://en.wikipedia.org/wiki/" q)))

(defun sw/ansi-color-region (beg end)
  "interactive version of func"
  (interactive "r")
  (ansi-color-apply-on-region beg end))

(defun sw/calc-region (arg beg end)
  "Calculate the region and display the result in the echo area.
With prefix ARG non-nil, insert the result at the end of region."
  (interactive "P\nr")
  (let*
      ((expr
        (buffer-substring-no-properties
         beg
         end))
       (result (calc-eval expr)))
    (message "%s = %s" expr result)
    (goto-char end)
    (insert (concat " = " result))))

(defun sw/join-line(beg end)
  (interactive "r")
  (setq foo (read-from-minibuffer (format "join with: ") nil nil nil nil))
  (replace-regexp "[ \t]*\\(.*?\\)[ \t]*\n" (concat "\\1" foo) nil beg end))

(defun sw/split-line(beg end)
  (interactive "r")
  (setq foo (read-from-minibuffer (format "split with: ") nil nil nil nil))
  (replace-regexp foo (concat foo "\n") nil beg end)
  (indent-region beg end))

(defun sw/write-file-or-region ()
  "interactive version of func"
  (interactive)
  (if (region-active-p)
      (call-interactively 'write-region)
    (call-interactively 'write-file)))

(defun sw/errno-show ()
  "Print the errno table"
  (interactive)
  (switch-to-buffer "*errno table*")
  (erase-buffer)
  (let ()
    (insert "#1           EPERM                  /* Operation not permitted */
#2           ENOENT                 /* No such file or directory*/
#3           ESRCH                  /* No such process */
#4           EINTR                  /* Interrupted system call */
#5           EIO                    /* I/O error */
#6           ENXIO                  /* No such device or address*/
#7           E2BIG                  /* Argument list too long */
#8           ENOEXEC                /* Exec format error */
#9           EBADF                  /* Bad file number */
#10          ECHILD                 /* No child processes */
#11          EAGAIN                 /* Try again */
#12          ENOMEM                 /* Out of memory */
#13          EACCES                 /* Permission denied */
#14          EFAULT                 /* Bad address */
#15          ENOTBLK                /* Block device required */
#16          EBUSY                  /* Device or resource busy */
#17          EEXIST                 /* File exists */
#18          EXDEV                  /* Cross-device link */
#19          ENODEV                 /* No such device */
#20          ENOTDIR                /* Not a directory */
#21          EISDIR                 /* Is a directory */
#22          EINVAL                 /* Invalid argument */
#23          ENFILE                 /* File table overflow */
#24          EMFILE                 /* Too many open files */
#25          ENOTTY                 /* Not a typewriter */
#26          ETXTBSY                /* Text file busy */
#27          EFBIG                  /* File too large */
#28          ENOSPC                 /* No space left on device */
#29          ESPIPE                 /* Illegal seek */
#30          EROFS                  /* Read-only file system */
#31          EMLINK                 /* Too many links */
#32          EPIPE                  /* Broken pipe */
#33          EDOM                   /* Math argument out of domain of func */
#34          ERANGE                 /* Math result not representable */
#35          EDEADLK                /* Resource deadlock would occur */
#36          ENAMETOOLONG           /* File name too long */
#37          ENOLCK                 /* No record locks available */
#38          ENOSYS                 /* Function not implemented */
#39          ENOTEMPTY              /* Directory not empty */
#40          ELOOP                  /* Too many symbolic links encountered */
#42          ENOMSG                 /* No message of desired type */
#43          EIDRM                  /* Identifier removed */
#44          ECHRNG                 /* Channel number out of range */
#45          EL2NSYNC               /* Level 2 not synchronized */
#46          EL3HLT                 /* Level 3 halted */
#47          EL3RST                 /* Level 3 reset */
#48          ELNRNG                 /* Link number out of range */
#49          EUNATCH                /* Protocol driver not attached */
#50          ENOCSI                 /* No CSI structure available */
#51          EL2HLT                 /* Level 2 halted */
#52          EBADE                  /* Invalid exchange */
#53          EBADR                  /* Invalid request descriptor */
#54          EXFULL                 /* Exchange full */
#55          ENOANO                 /* No anode */
#56          EBADRQC                /* Invalid request code */
#57          EBADSLT                /* Invalid slot */
#59          EBFONT                 /* Bad font file format */
#60          ENOSTR                 /* Device not a stream */
#61          ENODATA                /* No data available */
#62          ETIME                  /* Timer expired */
#63          ENOSR                  /* Out of streams resources */
#64          ENONET                 /* Machine is not on the network */
#65          ENOPKG                 /* Package not installed */
#66          EREMOTE                /* Object is remote */
#67          ENOLINK                /* Link has been severed */
#68          EADV                   /* Advertise error */
#69          ESRMNT                 /* Srmount error */
#70          ECOMM                  /* Communication error on send */
#71          EPROTO                 /* Protocol error */
#72          EMULTIHOP              /* Multihop attempted */
#73          EDOTDOT                /* RFS specific error */
#74          EBADMSG                /* Not a data message */
#75          EOVERFLOW              /* Value too large for defined data type */
#76          ENOTUNIQ               /* Name not unique on network */
#77          EBADFD                 /* File descriptor in bad state */
#78          EREMCHG                /* Remote address changed */
#79          ELIBACC                /* Can not access a needed shared library */
#80          ELIBBAD                /* Accessing a corrupted shared library */
#81          ELIBSCN                /* .lib section in a.out corrupted */
#82          ELIBMAX                /* Attempting to link in too many shared libraries */
#83          ELIBEXEC               /* Cannot exec a shared library directly */
#84          EILSEQ                 /* Illegal byte sequence */
#85          ERESTART               /* Interrupted system call should be restarted */
#86          ESTRPIPE               /* Streams pipe error */
#87          EUSERS                 /* Too many users */
#88          ENOTSOCK               /* Socket operation on non-socket */
#89          EDESTADDRREQ           /* Destination address required */
#90          EMSGSIZE               /* Message too long */
#91          EPROTOTYPE             /* Protocol wrong type for socket */
#92          ENOPROTOOPT            /* Protocol not available */
#93          EPROTONOSUPPORT        /* Protocol not supported */
#94          ESOCKTNOSUPPORT        /* Socket type not supported */
#95          EOPNOTSUPP             /* Operation not supported on transport endpoint */
#96          EPFNOSUPPORT           /* Protocol family not supported */
#97          EAFNOSUPPORT           /* Address family not supported by protocol */
#98          EADDRINUSE             /* Address already in use */
#99          EADDRNOTAVAIL          /* Cannot assign requested address */
#100         ENETDOWN               /* Network is down */
#101         ENETUNREACH            /* Network is unreachable */
#102         ENETRESET              /* Network dropped connection because of reset */
#103         ECONNABORTED           /* Software caused connection abort */
#104         ECONNRESET             /* Connection reset by peer */
#105         ENOBUFS                /* No buffer space available */
#106         EISCONN                /* Transport endpoint is already connected */
#107         ENOTCONN               /* Transport endpoint is not connected */
#108         ESHUTDOWN              /* Cannot send after transport endpoint shutdown */
#109         ETOOMANYREFS           /* Too many references: cannot splice */
#110         ETIMEDOUT              /* Connection timed out */
#111         ECONNREFUSED           /* Connection refused */
#112         EHOSTDOWN              /* Host is down */
#113         EHOSTUNREACH           /* No route to host */
#114         EALREADY               /* Operation already in progress */
#115         EINPROGRESS            /* Operation now in progress */
#116         ESTALE                 /* Stale NFS file handle */
#117         EUCLEAN                /* Structure needs cleaning */
#118         ENOTNAM                /* Not a XENIX named type file */
#119         ENAVAIL                /* No XENIX semaphores available */
#120         EISNAM                 /* Is a named type file */
#121         EREMOTEIO              /* Remote I/O error */
#122         EDQUOT                 /* Quota exceeded */
#123         ENOMEDIUM              /* No medium found */
#124         EMEDIUMTYPE            /* Wrong medium type */
#125         ECANCELED              /* Operation Canceled */
#126         ENOKEY                 /* Required key not available */
#127         EKEYEXPIRED            /* Key has expired */
#128         EKEYREVOKED            /* Key has been revoked */
#129         EKEYREJECTED           /* Key was rejected by service */
#130         EOWNERDEAD             /* Owner died */
#131         ENOTRECOVERABLE        /* State not recoverable */
#132         ERFKILL                /* Operation not possible due to RF-kill */")
    (beginning-of-buffer))
  (toggle-read-only 1))

(defun sw/add-hooks (mode-list something)
  "helper function to add a callback to multiple hooks"
  (dolist (mode mode-list)
    (add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))

(defun sw/minicom()
  (interactive)
  (serial-term "/dev/ttyUSB1" 115200))

(defun sw/set-tags-table (f)
  (interactive "fSet tag file: ")
  (setq tags-table-list nil)
  (setq tags-file-name nil)
  (visit-tags-table f))

(defun sw/sql-tidy-region (beg end)
  "Beautify SQL in region between beg and END."
  (interactive "r")
  (save-excursion
    (shell-command-on-region beg end "sqltidy" nil t)))

(defun sw/sql-tidy-buffer ()
  "Beautify SQL in buffer."
  (interactive)
  (sql-tidy-region (point-min)
                   (point-max)))

(defun sw/bury-buffer-or-kill-frame()
  (interactive)
  (if (frame-parameter nil 'client)
      (save-buffers-kill-terminal)
    (bury-buffer)))

(setq sw/window-configurations nil)
(defun sw/push-window-configuration ()
  (setq sw/window-configurations (cons (current-window-configuration) sw/window-configurations)))

(defun sw/pop-window-configuration ()
  (let
      ((wc
        (car sw/window-configurations)))
    (if wc
        (progn
          (set-window-configuration wc)
          (setq sw/window-configurations (cdr sw/window-configurations))))))

(defun sw/transpose-windows (arg)
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let
          ((this-win
            (window-buffer))
           (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (cl-plusp arg)
                    (1- arg)
                  (1+ arg))))))

(defun sw/find-dired ()
  (interactive)
  (let
      ((dir
        (read-directory-name "Find files in directory: " nil nil t)))
    (setq wildcard (read-string (concat "Find files in `" (file-name-nondirectory
                                                           (directory-file-name dir))  "': ")))
    (find-dired dir (concat "-iname " "\"*" wildcard "*\"" ))))

(defun find-in-session ()
  (interactive)
    (find-file-in ""))

(defun find-in-art ()
  (interactive)
    (find-file-in "/art/"))

(defun find-in-bionic ()
  (interactive)
    (find-file-in "/bionic/"))

(defun find-in-kernel ()
  (interactive)
    (find-file-in "/kernel/"))

(defun find-in-libcore ()
  (interactive)
    (find-file-in "/libcore/"))

(defun find-in-miui ()
  (interactive)
    (find-file-in "/miui/"))

(defun find-in-system ()
  (interactive)
    (find-file-in "/system/"))

(defun find-in-packages ()
  (interactive)
    (find-file-in "/packages/"))

(defun find-in-frameworks ()
  (interactive)
    (find-file-in "/frameworks/"))

(defun find-file-in (in-dir)
  (let
    ((dir (concat (get-session-root) in-dir)))
    (setq wildcard (read-string (concat "Find files in '" (file-name-nondirectory
                                                           (directory-file-name dir))  "': ")))
    (find-dired dir (concat "-iname " "\"" wildcard "\"" ))))

(defun sw/in-comment()
  (nth 8 (syntax-ppss (point))))

(defun sw/reload-emacs()
  (interactive)
  (load-file "~/.emacs"))

(defun sw/eol ()
  (save-excursion
    (let
        ((current-point
          (point)))
      (end-of-line)
      (if (eq (point) current-point) t nil))))

(defun sw/is-first-word()
  (s-match "^[ \t]*[a-zA-Z]+$"
           (buffer-substring-no-properties
            (point)
            (line-beginning-position))))

(defun sw/indent-up-level()
  (interactive)
  (indent-guide--beginning-of-level))

(defun sw/indent-prev-level()
  (interactive)
  (save-excursion
    ;; (indent-guide--beginning-of-level)
    (back-to-indentation)
    (setq line-col (current-column)))
  (while
      (and (forward-line -1)
          (progn
            (back-to-indentation)
            (or (= (string-match-p "^\\s-*$" (thing-at-point 'line)) 0)
                (or (< line-col (current-column))
                    (bobp))))
          (not (bobp)))))

(defun sw/indent-prev-level()
  (interactive)
  (let (line-col (tmp-forward-line 0) last-col)
    (save-excursion
      ;; (indent-guide--beginning-of-level)
      (back-to-indentation)
      (setq line-col (current-column))
      (setq last-col line-col))
    (save-excursion
      (while
          (and (forward-line -1)
              (setq tmp-forward-line (1- tmp-forward-line))
              (progn
                (back-to-indentation)
                (setq last-col (current-column))
                (or (= (string-match-p "^\\s-*$" (thing-at-point 'line)) 0)
                    (or (< line-col last-col)
                        (bobp))))
              (not (eobp)))))
    (when (= line-col last-col)
      (forward-line tmp-forward-line)
      (back-to-indentation))))

(defun sw/indent-next-level()
  (interactive)
  (let (line-col (tmp-forward-line 0) last-col)
    (save-excursion
      ;; (indent-guide--beginning-of-level)
      (back-to-indentation)
      (setq line-col (current-column))
      (setq last-col line-col))
    (save-excursion
      (while
          (and (forward-line 1)
              (setq tmp-forward-line (1+ tmp-forward-line))
              (progn
                (back-to-indentation)
                (setq last-col (current-column))
                (or (= (string-match-p "^\\s-*$" (thing-at-point 'line)) 0)
                    (or (< line-col last-col)
                        (bobp))))
              (not (eobp)))))
    (when (= line-col last-col)
      (forward-line tmp-forward-line)
      (back-to-indentation))))

(setq missing-executable nil)
(defmacro with-executable (e &optional x)
  `(if (executable-find ,e)
       (progn
         ,x
         t)
     (add-to-list 'missing-executable ,e) nil))

(defun sw/join-path (root &rest dirs)
  (if (not dirs)
      root
    (apply 'sw/join-path
           (expand-file-name (car dirs) root)
           (cdr dirs))))

(defmacro unless-run-as-daemon (x)
  `(let ((daemon-name (daemonp)))
     (unless (string= daemon-name "daemon")
       ,x)))

(defmacro if-run-as-daemon (x)
  `(let ((daemon-name (daemonp)))
     (if (string= daemon-name "daemon")
         ,x)))

(load-file (concat sw/user-init-d "misc/census_list.el"))
(defun sw/pick-random-name()
  (nth (random (1- (1+ (length sw/names)))) sw/names))

(defun sw/find-git-repo (dir)
  (if (string= "/" dir)
      (message "not in a git repo.")
    (if (file-exists-p (expand-file-name ".git/" dir))
        dir
      (sw/find-git-repo (expand-file-name "../" dir)))))

(defun sw/git-current-branch (root)
  (let ((result) (branches
                  (split-string
                   (shell-command-to-string
                    (concat
                     "git --git-dir="
                     root
                     ".git branch --no-color"))
                   "\n" t)))
    (while (and branches (null result))
      (if (string-match "^\* \\(.+\\)" (car branches))
          (setq result (match-string 1 (car branches)))
        (setq branches (cdr branches))))
    result))



(defun sw/project-run ()
  (interactive)
  (let ((orig-command compile-command)
        (project-supported (call-process "project")))
    (if (eq project-supported 1)
        (call-interactively 'quickrun)
      (progn
        (if (get-buffer "*project-run*")
            (kill-buffer "*project-run*"))

        (setq command "project run")
        (with-current-buffer (compilation-start command nil)
          (rename-buffer "*project-run*")
          (pop-to-buffer (current-buffer)))
        (setq compile-command orig-command)))))

(defun sw/project-build ()
  (interactive)
  (let ((orig-command compile-command)
        (project-supported (call-process "project")))
    (if (eq project-supported 1)
        (call-interactively 'quickrun-compile-only)
      (progn
        (if (get-buffer "*project-build*")
            (kill-buffer "*project-build*"))
        (setq command "project build")
        (with-current-buffer (compilation-start command nil)
          (rename-buffer "*project-build*")
          (pop-to-buffer (current-buffer)))
        (setq compile-command orig-command)))))

(defun sw/project-stdin ()
  (interactive)
  (let ((project-root (shell-command-to-string "project root"))
        (project-supported (call-process "project")))
    (if (eq project-root "unknown")
        (find-file (concat project-root "/stdin"))
      (find-file (concat (buffer-file-name) ".stdin")))))
