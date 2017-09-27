(use-package org-eldoc
  :commands (org-eldoc-load))

(use-package org
  :init
  (progn
    (setq org-insert-heading-respect-content nil)
    (setq org-blank-before-new-entry '((heading . auto) (plain-list-item . auto)))
    (setq org-icalendar-include-todo t)
    (setq org-clock-idle-time nil)
    (setq org-icalendar-use-deadline (quote (event-if-not-todo event-if-todo todo-due)))
    (setq org-icalendar-use-scheduled (quote (event-if-not-todo event-if-todo todo-start)))
    (setq org-latex-create-formula-image-program 'imagemagick)

    (setq org-refile-targets (quote ((org-agenda-files :maxlevel . 2))))
    (setq org-startup-folded nil)
    (setq org-startup-indented t)
    (setq org-startup-with-inline-images t)
    (setq org-use-speed-commands t)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))
    (setq org-cycle-separator-lines 1)

    (setq org-file-apps
          (quote
           ((auto-mode . emacs)
            ("\\.mm\\'" . default)
            ("\\.x?html?\\'" . default)
            ("\\.pdf\\'" . "acroread %s"))))

    (setq org-default-priority ?C)
    (setq org-lowest-priority ?C)
    (setq org-highest-priority ?A)
    (setq org-confirm-babel-evaluate nil)
    (setq org-keep-stored-link-after-insertion t)
    (setq org-link-file-path-type 'relative)
    (setq org-hide-leading-stars t)
    (setq org-log-done 'note)
    (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")))
    (setq org-todo-keyword-faces
          (quote (("TODO" :foreground  "orange red" :weight bold)
                  ("DONE" :foreground "forest green" :weight bold)
                  ("WAIT" :foreground "orange" :weight bold)
                  ("CANCELLED" :foreground "forest green" :weight bold))))
    (setq org-use-fast-todo-selection t)
    (setq org-refile-use-outline-path t)
    (setq org-deadline-warning-days 3)
    (setq org-tag-alist '(("study" . ?s)
                          ("leetcode" . ?l)
                          ("work" . ?w)
                          ("algo" . ?a)
                          ("personal" . ?p)
                          ("kpi" . ?k)
                          ("FLAGGED" . ??)
                          ("info" . ?i)))
    (setq org-agenda-hide-tags-regexp ".*")
    (setq org-completion-use-ido t)
    (setq org-ditaa-jar-path (concat sw/user-init-d "misc/ditaa0_9.jar"))
    (setq org-plantuml-jar-path (concat sw/user-init-d "misc/plantuml.jar"))
    (setq org-src-fontify-natively t)
    (setq org-babel-default-header-args
          '((:session . "none")
            (:results . "output replace")
            (:exports . "code")
            (:cache . "no")
            (:noweb . "no")
            (:hlines . "no")
            (:tangle . "no")))
    (setq org-babel-load-languages
          (quote
           ((emacs-lisp . t)
            (dot . t)
            (ditaa . t)
            (R . t)
            (python . t)
            (ruby . t)
            (gnuplot . t)
            (clojure . t)
            (sh . t)
            (ledger . t)
            (org . t)
            (plantuml . t)
            (latex . t)))))
  :mode ("\\.org\\$". org-mode)
  :bind ("C-c o l" . org-store-link)
  :config
  (progn
    ;; (use-package org-mu4e
    ;;   :if (with-executable "mu"))
    (org-eldoc-load)
    (add-to-list 'org-latex-default-packages-alist
                 '("" "xeCJK" nil)
                 t)
    (setq org-format-latex-options (plist-put org-format-latex-options :scale 2))

    (defadvice org-tags-expand (after modify-syntax-for-tags activate)
      (modify-syntax-entry ?_ "_" org-mode-syntax-table))

    (add-hook 'org-mode-hook '(lambda () (org-decrypt-entries)))
    (add-hook 'org-mode-hook 'org-hide-block-all)
    ;; (add-hook 'org-mode-hook 'flyspell-mode)

    (defun sw/org-update-statistics-cookies ()
      (interactive)
      (ignore-errors
        (save-excursion
          (outline-up-heading 3)
          (call-interactively 'org-update-statistics-cookies)))
      ;; (org-update-statistics-cookies 'all)
      )

    (add-hook 'org-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'sw/org-update-statistics-cookies nil t)))

    (defadvice org-insert-link (after org-toggle-inline-image activate)
      (org-display-inline-images))

    (defadvice org-babel-execute-src-block (after org-babel-execute-src-block-image activate)
      (org-display-inline-images))

    (bind-key "C-'" nil org-mode-map)
    (bind-key "<C-return>" nil org-mode-map)
    ;; (bind-key "C-c '" nil org-mode-map)
    (bind-key "C-c ;" nil org-mode-map)
    (bind-key "RET" 'org-return-indent org-mode-map)
    (bind-key "C-c C-n" 'outline-forward-same-level org-mode-map)
    (bind-key "C-c C-p" 'outline-backward-same-level org-mode-map)
    (bind-key "C-," nil org-mode-map)

    (use-package ox-beamer
      :init
      (progn
        (setq org-beamer-frame-level 2)
        (setq org-beamer-theme "CambridgeUS")
        (setq org-beamer-column-view-format
              "%40ITEM %10BEAMER_env(Env) %9BEAMER_envargs(Env Args) %4BEAMER_col(Col) %10BEAMER_extra(Extra)")))

    (use-package ox-latex
      :config
      (progn
        (setq org-latex-pdf-process
              (quote
               ("xelatex -interaction nonstopmode %f" "xelatex -interaction nonstopmode %f" "xelatex -interaction nonstopmode %f")))
        (setq org-latex-to-pdf-process
              (quote
               ("xelatex -interaction nonstopmode %f" "xelatex -interaction nonstopmode %f")))

        (setq org-export-exclude-tags (quote ("noexport" "crypt")))
        (setq org-export-latex-emphasis-alist
              (quote
               (("*" "\\textbf{%s}" nil)
                ("/" "\\emph{%s}" nil)
                ("_" "\\underline{%s}" nil)
                ("+" "\\st{%s}" nil)
                ("=" "\\protectedtexttt" t)
                ("~" "\\verb" t))))

        (add-to-list 'org-latex-classes
                     '("beamer" "
\\documentclass[presentation]{beamer}
\\usepackage{xeCJK}
\\setCJKmainfont{SimSun}
\\setmainfont{SimSun}
\\usepackage{hyperref}
\\hypersetup{%
colorlinks = true,
linkcolor  = blue
}
"
                       ("\\section{%s}" . "\\section*{%s}")
                       ("\\subsection{%s}" . "\\subsection*{%s}")
                       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
        (add-to-list 'org-latex-classes
                     '(
                       "article"
                       "
\\documentclass[11pt]{article}
\\usepackage{xeCJK}
\\setCJKmainfont{SimSun}
\\setmainfont{SimSun}
\\usepackage{hyperref}
\\hypersetup{%
colorlinks = true,
linkcolor  = blue
}
"
                       ("\\section{%s}" . "\\section*{%s}")
                       ("\\subsection{%s}" . "\\subsection*{%s}")
                       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                       ("\\paragraph{%s}" . "\\paragraph*{%s}")
                       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))))

(use-package org-agenda
  :init (progn
          (defalias 'agenda  'org-agenda)
          ;; (add-hook 'midnight-hook 'sw/agenda)
          (defun sw/agenda()
            (interactive)
            (org-agenda nil "a")
            (delete-other-windows)
            (org-agenda-goto-today)
            (org-agenda-clock-goto))
          (defun sw/org-agenda()
            (interactive)
            ;; (org-agenda nil "a")
            (org-agenda)
            (delete-other-windows)
            (org-agenda-goto-today)
            (org-agenda-clock-goto)))
  :commands org-agenda
  :bind ("C-c o a" . sw/org-agenda)
  :bind ("<s-return>" . sw/agenda)
  :config (progn
            (setq org-agenda-span 1)
            (setq org-agenda-start-with-log-mode t)
            (setq org-agenda-log-mode-items '(clock))
            (setq org-agenda-start-with-clockreport-mode nil)
            (setq org-clock-continuously nil)
            (setq org-use-property-inheritance t)
            (setq org-agenda-prefix-format
                  '((agenda
                     .
                     " %i %-12:c%?-12t% s %b")
                    (timeline . "  % s")
                    (todo
                     .
                     " %i %-12:c %b")
                    (tags . " %i %-12:c %b")
                    (search . " %i %-12:c")))
            (if (file-accessible-directory-p "~/gtd")
                (progn
                  (setq org-agenda-files (quote ("~/gtd")))
                  (setq org-directory "~/gtd")
                  ;; (setq org-agenda-custom-commands
                  ;;       (quote
                  ;;        (("a" "Agenda and all TODO's"
                  ;;          ((agenda "")))
                  ;;         )))
                  ))
            (setq org-agenda-custom-commands
                  '(("a" "Daily agenda and all TODOs"
                     (
                      (agenda "" ((org-agenda-span 2)))
                      (tags "PRIORITY=\"A\""
                            ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                             (org-agenda-overriding-header "Top-task:"))))
                     ((org-agenda-compact-blocks t)))))
            (setq org-agenda-include-diary t)
            (setq org-agenda-persistent-filter t)
            (setq org-agenda-include-diary t)
            (setq org-agenda-skip-scheduled-if-done t)
            (setq org-agenda-skip-deadline-if-done t)
            (setq org-agenda-todo-ignore-scheduled 'future)
            (setq org-agenda-todo-ignore-deadlines 'future)
            (setq org-agenda-todo-ignore-with-date nil)
            (setq org-agenda-clockreport-parameter-plist (quote
                                                          (:link t
                                                                 :maxlevel 4
                                                                 :fileskip0 t
                                                                 :stepskip0 t)))
            (bind-key "a" 'org-agenda org-agenda-mode-map)
            (bind-key "q" 'sw/bury-buffer-or-kill-frame org-agenda-mode-map)
            (bind-key "k" 'org-capture org-agenda-mode-map)
            (bind-key "r" 'org-agenda-refile org-agenda-mode-map)
            (setq org-agenda-sorting-strategy
                  '((agenda
                     time-up
                     priority-down
                     category-keep)
                    (todo
                     todo-state-down
                     priority-down
                     category-keep)
                    (tags priority-down category-keep)
                    (search category-keep)))
            (add-hook 'org-clock-in-hook
                      '(lambda()
                         (f-touch "/tmp/org-clock.pid")))
            (add-hook 'org-clock-out-hook
                      '(lambda()
                         (ignore-errors
                           (f-delete "/tmp/org-clock.pid"))))
            (defadvice org-agenda-redo (after org-agenda-redo-add-appts activate)
              (progn
                (setq appt-time-msg-list nil)
                (org-agenda-to-appt)))
            (org-agenda-to-appt)
            (defun sw/org-clocktable-indent-string (level)
              (if (= level 1) "" (let ((str ""))
                                   (while (> level 2)
                                     (setq level (1- level) str (concat str "　")))
                                   (concat str "　"))))
            (advice-add 'org-clocktable-indent-string
                        :override #'sw/org-clocktable-indent-string)
            (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
            (add-hook 'org-agenda-finalize-hook 'org-save-all-org-buffers)
            (advice-add 'org-agenda-quit
                        :before 'org-save-all-org-buffers)))

(use-package org-capture
  :commands org-capture
  :config
  (progn
    (if (file-accessible-directory-p "~/gtd")
        (setq org-capture-templates
              (quote (("s" "study" entry (file "~/gtd/study.org")
                       "* TODO %?  :study:\n\n")
                      ("m" "mail" entry (file "~/gtd/kpi.org")
                       "* TODO %:fromname: %a%?  :kpi:\n%:appt\n%T\n")
                      ("p" "personal" entry (file "~/gtd/personal.org")
                       "* TODO %? :personal:\n\n")
                      ("k" "kpi" entry (file "~/gtd/kpi.org")
                       "* TODO %? :kpi:\n\n")
                      ("w" "work" entry (file "~/gtd/work.org")
                       "* TODO %? :work:\n\n")
                      ("K" "kpi habit" entry (file "~/gtd/kpi.org")
                       "* TODO %? :kpi:habit:\nSCHEDULED: <%<%Y-%m-%d %a +1d/2d>> \n:PROPERTIES:\n:STYLE: habit\n:END:\n")
                      ("S" "study habit" entry (file "~/gtd/study.org")
                       "* TODO %? :study:habit:\nSCHEDULED: <%<%Y-%m-%d %a +1d/2d>> \n:PROPERTIES:\n:STYLE: habit\n:END:\n")
                      ("P" "personal habit" entry (file "~/gtd/personal.org")
                       "* TODO %? :personal:habit:\nSCHEDULED: <%<%Y-%m-%d %a +1d/2d>> \n:PROPERTIES:\n:STYLE: habit\n:END:\n")))))
    (setq org-capture-bookmark nil)
    (add-hook 'org-capture-after-finalize-hook
              '(lambda()
                 (org-agenda-to-appt)
                 (org-save-all-org-buffers))))
  :bind ("C-c o k" . org-capture))

(use-package org-src
  :init
  (setq org-src-lang-modes
        '(("plantuml" . plantuml)
          ("ocaml" . tuareg)
          ("elisp" . emacs-lisp)
          ("ditaa" . fundamental)
          ("asymptote" . asy)
          ("dot" . graphviz-dot)
          ("sqlite" . sql)
          ("calc" . fundamental)
          ("C" . c)
          ("asm" . asm)
          ("cpp" . c++)
          ("C++" . c++)
          ("screen" . shell-script)
          ("shell" . sh)
          ("bash" . sh)))
  :commands org-edit-src-code
  :config
  (progn
    (defadvice org-edit-src-code (after transpose-window-org-src activate)
      (call-interactively 'sw/transpose-windows))
    (setq org-edit-src-persistent-message nil)
    (add-hook 'org-src-mode-hook '(lambda() (setq c-basic-offset 2)))
    (add-hook 'org-src-mode-hook '(lambda() (auto-fill-mode -1)))))

(use-package org-crypt
  :commands org-decrypt-entries
  :config
  (progn
    ;; (setq org-crypt-key "wei.sun")
    ;; (setq org-crypt-key nil)
    ;; (setq auto-save-default nil)
    (setq org-crypt-disable-auto-save t)
    (org-crypt-use-before-save-magic)))

(use-package ox-publish
  :config
  (progn
    (setq org-publish-list-skipped-files t)
    (setq org-publish-sitemap-sort-files (quote anti-chronologically))
    (setq org-publish-use-timestamps-flag t)
    (setq org-publish-timestamp-directory "~/.github.pages/org-cache/")
    (setq org-publish-project-alist
          '(("note"
             :base-directory "~/drops/note/"
             :base-extension "rel.org"
             :publishing-directory "~/.github.pages"
             :sitemap-filename "index.org"
             :sitemap-title "Site Map"
             :recursive t
             :publishing-function org-html-publish-to-html
             :headline-levels 4
             :auto-preamble t
             :auto-sitemap t
             :html-postamble "
<div id=\"disqus_thread\"></div>
<script>

(function() { // DON'T EDIT BELOW THIS LINE
         var d = document, s = d.createElement('script');
         s.src = '//sunwayforever-github-io.disqus.com/embed.js';
         s.setAttribute('data-timestamp', +new Date());
         (d.head || d.body).appendChild(s);
         })();
</script>
"
             :sitemap-sort-folders nil)
            ("extra"
             :base-directory "~/drops/note/extra/"
             :base-extension "png"
             :publishing-directory "~/.github.pages/extra"
             :publishing-function org-publish-attachment
             :recursive t)))
    (setq org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheets/main.css\" media=\"screen\" />")
    (setq org-html-style-default "<link rel=\"stylesheet\" type=\"text/css\" href=\"../stylesheets/main.css\" media=\"screen\" />"))
  :commands (org-publish org-publish-all org-publish-remove-all-timestamps))

(use-package appt
  :init
  (progn
    (run-at-time "24:01" 3600 'org-agenda-to-appt)
    (appt-activate 1))
  :commands (appt org-agenda-to-appt)
  :config
  (progn
    (defun my-appt-display (min-to-app new-time msg)
      (shell-command (concat "notify-send -u critical" " '" msg "'")))
    (setq appt-time-msg-list nil
          appt-display-mode-line nil
          appt-display-format 'window
          appt-disp-window-function (function my-appt-display)
          appt-message-warning-time 15
          appt-display-interval 5)))

(use-package pangu-spacing
  :config
  (add-hook 'org-mode-hook
            '(lambda ()
               (pangu-spacing-mode t)
               (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))
  :commands pangu-spacing-mode)

(use-package org-bullets
  :init
  (progn
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    (setq org-bullets-bullet-list '("❶" "❷" "❸" "❹" "❺" "❻")))
  :commands org-bullets-mode)

(use-package org-mime
  :init
  (defalias 'org-mail-this-buffer 'org-mime-org-buffer-htmlize)
  :commands org-mime-org-buffer-htmlize)

(use-package org-tree-slide
  :init
  (defalias 'org-slide 'org-tree-slide-mode)
  (defalias 'org-slide-content 'org-tree-slide-mode)
  :commands org-tree-slide-mode
  :config
  (progn
    (bind-key "SPC" 'org-tree-slide-move-next-tree org-tree-slide-mode-map)
    (bind-key "S-SPC" 'org-tree-slide-move-previous-tree org-tree-slide-mode-map)))

(use-package org-drill
  :init
  (progn
    (defun drill()
      (interactive)
      (let ((buffer (find-file-noselect youdao-drill-file)))
        (with-current-buffer buffer
          (org-drill)))))
  :commands org-drill
  :config
  (progn
    (setq org-drill-optimal-factor-matrix (quote ((1 (2.6 . 4.14) (2.36 . 3.86)))))))

(use-package deft
  :commands deft
  :config
  (progn
    (if (file-accessible-directory-p "~/drops/note/")
        (setq deft-directory "~/drops/note/"))
    (bind-key "C-x k" 'quit-window deft-mode-map)
    (bind-key "<f12>" 'quit-window deft-mode-map))
  :bind ("<f12>" . deft))

(use-package ox
  :init
  (progn
    (setq org-export-headline-levels 3)
    (setq org-export-with-toc 3)
    (setq org-preview-latex-image-directory "/tmp/latex_preview/")
    (setq org-export-with-email t)
    (setq org-export-with-sub-superscripts (quote {})))
  :commands org-export-as
  :config
  (progn
    (require 'ox-latex)
    (require 'ox-beamer)
    (defun clear-single-linebreak-in-cjk-string (string)
      "clear single line-break between cjk characters that is usually soft line-breaks"
      (let* ((regexp "\\([\u4E00-\u9FA5]\\)\n\\([\u4E00-\u9FA5]\\)")
             (start (string-match regexp string)))
        (while start
          (setq string (replace-match "\\1\\2" nil nil string)
                start (string-match regexp string start))))
      string)

    (defun ox-html-clear-single-linebreak-for-cjk (string backend info)
      (when (org-export-derived-backend-p backend 'html)
        (clear-single-linebreak-in-cjk-string string)))

    (add-to-list 'org-export-filter-final-output-functions
                 'ox-html-clear-single-linebreak-for-cjk)))

(setq youdao-drill-file (expand-file-name "~/drops/note/vocabulary_memo.org"))

;; (use-package org-weather
;;   :config (progn
;;             (setq org-weather-api-key "d925dfb546bca5f7aca59f58d5df0540")
;;             (setq org-weather-location "Tianjin, CN")
;;             (setq org-weather-format "⛅ %desc, %tmin/%tmax%tu, %h%hu, %s%su")
;;             (run-with-timer 60 300 'org-weather-refresh)
;;             (org-weather-refresh)
;;             ;; (defadvice org-agenda-redo (before org-agenda-refresh-weather activate)
;;             ;;   (org-weather-refresh))
;;             ))

(use-package org-habit
  :config (progn
            (setq org-habit-show-habits-only-for-today nil)
            (setq org-habit-graph-column 80)
            (setq org-habit-show-done-always-green t)
            (setq org-habit-preceding-days 60)
            (setq org-habit-following-days 1)))

(use-package plantuml-mode
  :init (progn
          (setq plantuml-java-command (concat sw/user-init-d "misc/java.sh"))
          ;; (setq plantuml-java-args "-jar")
          (setq plantuml-output-type "png")
          (setq plantuml-jar-path org-plantuml-jar-path))
  :commands (plantuml-mode))
