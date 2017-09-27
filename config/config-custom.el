(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "xelatex")
 '(TeX-command-list
   (quote
    (("TeX" "%(PDF)%(tex) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (plain-tex-mode texinfo-mode ams-tex-mode)
      :help "Run plain TeX")
     ("LaTeX" "xelatex%(mode) %t" TeX-run-TeX nil
      (latex-mode doctex-mode)
      :help "Run LaTeX")
     ("Makeinfo" "makeinfo %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with Info output")
     ("Makeinfo HTML" "makeinfo --html %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with HTML output")
     ("AmSTeX" "%(PDF)amstex %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (ams-tex-mode)
      :help "Run AMSTeX")
     ("ConTeXt" "texexec --once --texutil %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt once")
     ("ConTeXt Full" "texexec %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt until completion")
     ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX")
     ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")
     ("Print" "%p" TeX-run-command t t :help "Print the file")
     ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command)
     ("File" "%(o?)dvips %d -o %f " TeX-run-command t t :help "Generate PostScript file")
     ("Index" "makeindex %s" TeX-run-command nil t :help "Create index file")
     ("Check" "lacheck %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for correctness")
     ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document")
     ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files")
     ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files")
     ("Other" "" TeX-run-command t t :help "Run an arbitrary command"))))
 '(TeX-file-extensions
   (quote
    ("tex" "sty" "cls" "ltx" "texi" "texinfo" "dtx" "bmer")))
 '(TeX-outline-extra
   (quote
    (("[:blank:]*\\\\begin{CJK}" 1)
     ("[:blank:]*\\\\end{CJK}" 1))))
 '(TeX-output-view-style
   (quote
    (("^dvi$"
      ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$")
      "%(o?)dvips -t landscape %d -o && gv %f")
     ("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f")
     ("^dvi$"
      ("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "^landscape$")
      "%(o?)xdvi %dS -paper a4r -s 0 %d")
     ("^dvi$" "^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)xdvi %dS -paper a4 %d")
     ("^dvi$"
      ("^a5\\(?:comb\\|paper\\)$" "^landscape$")
      "%(o?)xdvi %dS -paper a5r -s 0 %d")
     ("^dvi$" "^a5\\(?:comb\\|paper\\)$" "%(o?)xdvi %dS -paper a5 %d")
     ("^dvi$" "^b5paper$" "%(o?)xdvi %dS -paper b5 %d")
     ("^dvi$" "^letterpaper$" "%(o?)xdvi %dS -paper us %d")
     ("^dvi$" "^legalpaper$" "%(o?)xdvi %dS -paper legal %d")
     ("^dvi$" "^executivepaper$" "%(o?)xdvi %dS -paper 7.25x10.5in %d")
     ("^dvi$" "." "%(o?)xdvi %dS %d")
     ("^pdf$" "." "acroread %o")
     ("^html?$" "." "firefox %o"))))
 '(ahs-case-fold-search nil)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#d6d6d6"))
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 100)
 '(auto-coding-alist
   (quote
    (("\\.\\(arc\\|zip\\|lzh\\|lha\\|zoo\\|[jew]ar\\|xpi\\|rar\\|7z\\|ARC\\|ZIP\\|LZH\\|LHA\\|ZOO\\|[JEW]AR\\|XPI\\|RAR\\|7Z\\)\\'" . no-conversion-multibyte)
     ("\\.\\(exe\\|EXE\\)\\'" . no-conversion)
     ("\\.\\(sx[dmicw]\\|odt\\|tar\\|t[bg]z\\)\\'" . no-conversion)
     ("\\.\\(gz\\|Z\\|bz\\|bz2\\|xz\\|gpg\\)\\'" . no-conversion)
     ("\\.\\(jpe?g\\|png\\|gif\\|tiff?\\|p[bpgn]m\\)\\'" . no-conversion)
     ("\\.pdf\\'" . no-conversion)
     ("/#[^/]+#\\'" . emacs-mule)
     ("\\.org\\'" . utf-8)
     ("\\.tin\\'" . gbk))))
 '(auto-indent-blank-lines-on-move nil)
 '(auto-indent-current-pairs nil)
 '(auto-indent-next-pair-timer-geo-mean (quote ((default 0.0005 0))))
 '(auto-indent-next-pair-timer-interval
   (quote
    ((emacs-lisp-mode 1.5)
     (java-mode 1.5)
     (default 0.0005))))
 '(auto-save-default t)
 '(awk-it-default-mode 2)
 '(back-button-index-timeout 0)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-no-duplicates t)
 '(c-offsets-alist (quote ((case-label . 0))))
 '(canlock-password "e8b2356fc28fdc87defe0d5b18dda7a9d2f2e7db")
 '(cc-search-directories
   (quote
    ("../include" "../src" "." "/usr/include" "/usr/local/include/*")))
 '(clean-buffer-list-delay-general 30)
 '(clean-buffer-list-kill-regexps (quote ("\\*.*\\*")))
 '(column-number-mode t)
 '(company-idle-delay 0.3)
 '(company-minimum-prefix-length 2)
 '(cua-enable-cua-keys nil)
 '(custom-safe-themes
   (quote
    ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "949cfd4a96205b2d5e6a2ac0d2c2d0534843a55d51387cc6b6ee03a0e61fba57" "f34b107e8c8443fe22f189816c134a2cc3b1452c8874d2a4b2e7bb5fe681a10b" "3cc6980d5a57904cb910d0b011581cd53e357357ae69284659a5bf18cb332560" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "f6194ef939ebbe331d359fa2df3fb3a6206c590c91f53063f39595fc6eaf0026" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "e9680c4d70f1d81afadd35647e818913da5ad34917f2c663d12e737cdecd2a77" default)))
 '(deft-auto-save-interval 60.0)
 '(deft-extension "org")
 '(deft-recursive t)
 '(deft-recursive-ignore-dir-regexp "\\(?:\\.\\|\\.\\.\\|archieve\\|private\\)$")
 '(deft-strip-title-regexp "^.*? ")
 '(deft-text-mode (quote org-mode))
 '(diff-hl-draw-borders t)
 '(dired-backup-overwrite t)
 '(dired-find-subdir nil)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-default-load-average nil)
 '(display-time-mail-file (quote none))
 '(display-time-mode t)
 '(display-time-string-forms
   (quote
    ((if
         (and
          (not display-time-format)
          display-time-day-and-date)
         (format-time-string "%A %m/%d " now)
       "")
     (propertize
      (format-time-string
       (or display-time-format
           (if display-time-24hr-format "%H:%M" "%-I:%M%p"))
       now)
      (quote help-echo)
      (format-time-string "%a %b %e, %Y" now))
     load
     (if mail
         (concat " "
                 (propertize display-time-mail-string
                             (quote display)
                             (\`
                              (when
                                  (and display-time-use-mail-icon
                                       (display-graphic-p))
                                (\,@ display-time-mail-icon)
                                (\,@
                                 (if
                                     (and display-time-mail-face
                                          (memq
                                           (plist-get
                                            (cdr display-time-mail-icon)
                                            :type)
                                           (quote
                                            (pbm xbm))))
                                     (let
                                         ((bg
                                           (face-attribute display-time-mail-face :background)))
                                       (if
                                           (stringp bg)
                                           (list :background bg)))))))
                             (quote face)
                             display-time-mail-face
                             (quote help-echo)
                             "You have new mail; mouse-2: Read mail"
                             (quote mouse-face)
                             (quote mode-line-highlight)
                             (quote local-map)
                             (make-mode-line-mouse-map
                              (quote mouse-2)
                              read-mail-command)))
       ""))))
 '(dtrt-indent-active-mode-line-info "")
 '(dtrt-indent-max-lines 200)
 '(dtrt-indent-verbosity 0)
 '(ediff-custom-diff-options "-c -b")
 '(ediff-diff-options "-b")
 '(edit-server-new-frame nil)
 '(electric-indent-mode nil)
 '(electric-pair-inhibit-predicate (quote electric-pair-conservative-inhibit))
 '(elisp-format-newline-keyword-addons-list
   (quote
    ("interactive" "setq" "set" "buffer-substring" "buffer-substring-no-properties" "progn")))
 '(elisp-format-split-subexp-keyword-addons-list
   (quote
    ("and" "or" "buffer-substring" "buffer-substring-no-properties" "font-lock-add-keywords" "progn" "save-excursion" "ignore-errors" "with-temp-buffer" "when")))
 '(elisp-format-split-subexp-keyword-keep-alist
   (quote
    ((1 "not" "and" "or" "let" "let*" "while" "when" "catch" "unless" "if" "dolist" "dotimes" "lambda" "cond" "condition-case" "with-current-buffer" "with-temp-message" "with-selected-window" "with-output-to-temp-buffer" "with-selected-frame" "use-package")
     (2 "defun" "defun*" "defsubst" "defmacro" "defadvice" "define-skeleton" "define-minor-mode" "define-global-minor-mode" "define-globalized-minor-mode" "define-derived-mode" "define-generic-mode" "define-compiler-macro" "define-modify-macro" "defsetf" "define-setf-expander" "define-method-combination" "defgeneric" "defmethod" "defalias" "defvar" "defconst" "defconstant" "defcustom" "defparameter" "define-symbol-macro" "defgroup" "deftheme" "deftype" "defstruct" "defclass" "define-condition" "define-widget" "defface" "defpackage")
     (5 "loop"))))
 '(ff-ignore-include t)
 '(file-cache-filter-regexps
   (quote
    ("~$" "\\.o$" "\\.exe$" "\\.a$" "\\.elc$" ",v$" "\\.output$" "\\.$" "#$" "\\.class$" "\\.git")))
 '(find-grep-options "-q  -I -i")
 '(fixmee-notice-regexp
   "\\(@@@+\\|\\_<\\(?:XXX:+\\)\\)\\(?:[/:?!.
]+\\|-+\\(?:\\s-\\|[
]\\)\\|\\_>\\)")
 '(flycheck-checkers
   (quote
    (bash c/c++-clang c/c++-cppcheck coffee coffee-coffeelint css-csslint d-dmd elixir erlang go-gofmt go-build go-test haml haskell-hdevtools haskell-ghc haskell-hlint html-tidy javascript-jshint javascript-gjslint json-jsonlint less lua perl php php-phpmd php-phpcs puppet-parser puppet-lint python-flake8 python-pylint rst ruby-rubocop ruby ruby-jruby rust sass scala scss sh-dash sh-bash slim tex-chktex tex-lacheck xml-xmlstarlet xml-xmllint yaml-ruby zsh)))
 '(flycheck-display-errors-function (quote sw/flycheck-display-error))
 '(flycheck-indication-mode nil)
 '(gdb-enable-debug t)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 60 60 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))
 '(ibuffer-saved-filter-groups nil)
 '(ibuffer-saved-filters nil)
 '(ibus-cursor-color "red")
 '(ido-enable-last-directory-history nil)
 '(ido-enable-tramp-completion nil)
 '(ido-use-filename-at-point nil)
 '(ido-use-url-at-point nil)
 '(ispell-dictionary "en")
 '(ispell-query-replace-choices t)
 '(large-file-warning-threshold nil)
 '(magit-completing-read-function (quote magit-ido-completing-read))
 '(magit-push-always-verify nil)
 '(magit-set-upstream-on-push t)
 '(mail-host-address nil)
 '(message-log-max 1000)
 '(midnight-mode t nil (midnight))
 '(mm-text-html-renderer (quote w3m-standalone))
 '(mo-git-blame-blame-window-width 60)
 '(mo-git-blame-use-ido (quote always))
 '(nxml-slash-auto-complete-flag t)
 '(org-startup-with-latex-preview nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(password-cache-expiry 600)
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(pulse-flag nil)
 '(python-shell-completion-native-enable nil)
 '(python-shell-interpreter "python3")
 '(python-skeleton-autoinsert t)
 '(python-use-skeletons t)
 '(rails-ws:default-server-type "webrick")
 '(rcirc-always-use-server-buffer-flag t)
 '(rcirc-encode-coding-system (quote utf-8))
 '(rcirc-log-flag t)
 '(rcirc-startup-channels-alist nil)
 '(rcirc-track-minor-mode t)
 '(read-file-name-completion-ignore-case t)
 '(safe-local-variable-values
   (quote
    ((time-stamp-active . t)
     (read-only-mode . t)
     (view-mode . t)
     (eval ignore-errors
           (push
            (quote
             ("Tests" "(\\(\\<ert-deftest\\)\\>\\s *\\(\\(?:\\sw\\|\\s_\\)+\\)?" 2))
            imenu-generic-expression)
           (when
               (string-match-p "test"
                               (buffer-file-name))
             (setq emojify-inhibit-emojify-in-current-buffer-p t)))
     (rspec-use-bundler-when-possible)
     (eval font-lock-add-keywords nil
           (\`
            (((\,
               (concat "("
                       (regexp-opt
                        (quote
                         ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl"))
                        t)
                       "\\_>"))
              1
              (quote font-lock-variable-name-face)))))
     (nxml-heading-element-name-regexp . "activity")
     (nxml-section-element-name-regexp . "activity")
     (Coding . utf-8)
     (default-justification . left)
     (lexical-binding . t)
     (require-final-newline . t)
     (mangle-whitespace . t)
     (todo-categories "Todo" "Todo")
     (folded-file . t))))
 '(savehist-additional-variables (quote (kill-ring compile-command)))
 '(scheme-program-name "racket")
 '(select-active-regions (quote only))
 '(senator-minor-mode-hook nil)
 '(show-paren-mode t)
 '(show-paren-style (quote parenthesis))
 '(show-paren-when-point-inside-paren nil)
 '(smex-auto-update t)
 '(smtpmail-debug-info t)
 '(sp-autodelete-closing-pair nil)
 '(sp-autodelete-wrap nil)
 '(sp-autoescape-string-quote nil)
 '(sp-autoinsert-if-followed-by-word nil)
 '(sql-electric-stuff (quote semicolon))
 '(sql-product (quote sqlite))
 '(sql-sqlite-program "sqlite3")
 '(tabbar-home-button (quote (("") "")))
 '(tabbar-scroll-left-button (quote (("") "")))
 '(tabbar-scroll-right-button (quote (("") "")))
 '(tramp-default-host "")
 '(tramp-default-method "ssh")
 '(tramp-remote-path
   (quote
    (tramp-default-remote-path "/usr/sbin" "/usr/local/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/SunStudio_11/SUNWspro/bin" "/usr/sfw/bin")))
 '(tramp-syntax (quote ftp))
 '(type-break-demo-functions (quote (type-break-demo-boring type-break-demo-life)))
 '(type-break-interval 2700)
 '(type-break-query-interval 300)
 '(type-break-terse-messages t)
 '(undo-tree-visualizer-timestamps t)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator "@")
 '(uniquify-strip-common-suffix t)
 '(url-show-status nil)
 '(vc-annotate-very-old-color nil)
 '(vc-follow-symlinks nil)
 '(w3m-default-display-inline-images nil)
 '(wakatime-api-key "2ba746e3-a8a2-4abe-8b81-fe97e064931d")
 '(wakatime-cli-path #("/sbin/wakatime" 1 5 (face flx-highlight-face)))
 '(wg-first-wg-name "WG/0")
 '(wg-flag-modified nil)
 '(wg-morph-hsteps 50)
 '(wg-morph-on nil)
 '(wg-morph-vsteps 30)
 '(wg-no-confirm t)
 '(wg-query-for-save-on-emacs-exit nil)
 '(wg-query-for-save-on-workgroups-mode-exit nil)
 '(wg-use-faces nil)
 '(winner-ring-size 5)
 '(wl-biff-check-interval 60)
 '(wl-draft-preview-attributes nil)
 '(wl-draft-send-confirm-with-preview nil)
 '(wl-draft-sendlog nil)
 '(wl-interactive-exit nil)
 '(wl-interactive-save-folders nil)
 '(wl-interactive-send nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "APPL" :slant normal :weight normal :height 113 :width normal))))
 '(ahs-plugin-bod-face ((t (:background "DodgerBlue"))))
 '(bm-face ((((class color) (background dark)) (:background "SkyBlue1" :foreground "Black"))))
 '(cfw:face-day-title ((t nil)))
 '(cfw:face-select ((t (:background "dim gray" :foreground "lawn green"))))
 '(cfw:face-today ((t (:foreground "lawn green" :weight bold))))
 '(cfw:face-today-title ((t (:background "dim gray" :foreground "cyan" :weight bold))))
 '(cfw:face-toolbar ((t nil)))
 '(cfw:face-toolbar-button-off ((t (:foreground "dark gray" :weight bold))))
 '(cfw:face-toolbar-button-on ((t (:foreground "light salmon" :weight bold))))
 '(company-tooltip-annotation ((t (:foreground "orange red"))))
 '(cursor ((t (:background "orange red"))))
 '(diff-added ((((background dark)) (:foreground "#FFFF9B9BFFFF")) (t (:foreground "DarkGreen"))))
 '(diff-changed ((((background dark)) (:foreground "Yellow")) (t (:foreground "MediumBlue"))))
 '(diff-context ((((background dark)) (:foreground "White")) (t (:foreground "Black"))))
 '(diff-file-header ((((background dark)) (:foreground "Cyan" :background "Black")) (t (:foreground "Red" :background "White"))))
 '(diff-header ((((background dark)) (:foreground "Cyan")) (t (:foreground "Red"))))
 '(diff-hl-change ((t (:background "cornflower blue" :foreground "blue"))))
 '(diff-hl-delete ((t (:background "LightPink1" :foreground "red"))))
 '(diff-hl-insert ((t (:background "pale green" :foreground "green"))))
 '(diff-hunk-header ((((background dark)) (:foreground "Black" :background "#05057F7F8D8D")) (t (:foreground "White" :background "Salmon"))))
 '(diff-index ((((background dark)) (:foreground "Magenta")) (t (:foreground "Green"))))
 '(diff-nonexistent ((((background dark)) (:foreground "#FFFFFFFF7474")) (t (:foreground "DarkBlue"))))
 '(diff-refine-added ((t (:inherit diff-refine-change))))
 '(diff-removed ((((background dark)) (:foreground "#7474FFFF7474")) (t (:foreground "DarkMagenta"))))
 '(ediff-fine-diff-B ((t (:background "dark violet"))))
 '(ediff-odd-diff-A ((t (:background "gray25"))))
 '(ediff-odd-diff-B ((t (:background "gray28"))))
 '(eopengrok-file-face ((t (:inherit font-lock-warning-face))))
 '(flx-highlight-face ((t (:inherit font-lock-variable-name-face))))
 '(flycheck-fringe-info ((t nil)))
 '(flycheck-fringe-warning ((t nil)))
 '(flycheck-info ((t nil)))
 '(flycheck-warning ((t nil)))
 '(font-latex-sectioning-2-face ((t (:foreground "green" :height 1.5))))
 '(font-latex-sectioning-3-face ((t (:inherit font-latex-sectioning-4-face :foreground "yellow" :height 1.3))))
 '(font-latex-sectioning-4-face ((t (:inherit font-latex-sectioning-5-face :foreground "cyan" :height 1.1))))
 '(font-latex-verbatim-face ((((class color) (background dark)) (:foreground "burlywood" :family "monospace"))))
 '(font-lock-comment-face ((t (:foreground "#9192a4"))))
 '(git-gutter:modified ((t (:inherit default :foreground "dark orange" :weight bold))))
 '(hl-line ((t (:background "#464752"))))
 '(hs-fringe-face ((t (:foreground "yellow"))))
 '(js2-warning ((t (:underline nil))))
 '(link ((t (:foreground "sandy brown" :underline t))))
 '(magit-diff-hunk-header ((t nil)))
 '(magit-header ((t (:inherit highlight))))
 '(magit-section-title ((t (:inherit header-line :foreground "LightSalmon3"))))
 '(mode-line-inactive ((t (:background "gray70" :foreground "gray21" :box (:line-width 1 :color "#282a36")))))
 '(mu4e-header-highlight-face ((t (:inherit hl-line :weight normal))))
 '(mu4e-replied-face ((t (:weight normal))))
 '(org-agenda-clocking ((t (:box (:line-width 1 :color "orange")))))
 '(org-agenda-date ((t (:foreground "salmon" :weight bold :height 1.0))))
 '(org-agenda-date-today ((t (:inherit org-agenda-date :underline t :weight normal :height 1.1))))
 '(org-agenda-date-weekend ((t (:foreground "spring green" :weight bold))))
 '(org-agenda-done ((t (:foreground "gray"))))
 '(org-agenda-structure ((t (:background "#282a36" :foreground "chartreuse" :box nil :weight bold))))
 '(org-habit-clear-future-face ((t (:background "gray27"))))
 '(org-habit-ready-future-face ((t (:background "ForestGreen"))))
 '(org-level-1 ((t (:foreground "#e2e2dc" :weight normal :height 1.0))))
 '(org-level-2 ((t (:foreground "#ccccc7" :weight normal :height 1.0))))
 '(org-level-3 ((t (:foreground "#b6b6b2" :weight normal :height 1.0))))
 '(org-level-4 ((t (:foreground "dark gray" :weight normal :height 1.0))))
 '(org-link ((t (:foreground "dark gray" :underline t))))
 '(org-mode-line-clock ((t (:foreground "green"))))
 '(org-scheduled-previously ((t (:foreground "yellow green"))))
 '(org-scheduled-today ((t (:foreground "#50fa7b" :weight normal :height 1.0))))
 '(org-table ((t (:foreground "dim gray"))))
 '(org-warning ((t (:foreground "tomato" :underline nil :height 1.0))))
 '(parenthesis ((t (:foreground "gray46"))))
 '(pulse-highlight-start-face ((t (:background "steel blue"))))
 '(rcirc-track-keyword ((t (:background "red" :weight bold))))
 '(rcirc-track-nick ((t (:background "red" :weight bold))))
 '(semantic-highlight-func-current-tag-face ((t (:box (:line-width 1 :color "grey75")))))
 '(show-paren-match ((t (:background "dark khaki" :foreground "black"))))
 '(variable-pitch ((t nil)))
 '(which-func ((((class color) (background dark)) nil)))
 '(wl-highlight-folder-zero-face ((t (:foreground "gray57"))))
 '(wl-highlight-summary-normal-face ((t (:foreground "gray60"))))
 '(wl-highlight-summary-thread-top-face ((t (:foreground "gray53"))))
 '(yas-field-highlight-face ((t (:foreground "spring green" :box (:line-width 1 :color "grey75") :weight bold)))))
