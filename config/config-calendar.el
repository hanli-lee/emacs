(use-package calendar
  :init (progn
          (setq calendar-view-holidays-initially-flag t)
          (setq calendar-mark-diary-entries-flag t)
          (setq calendar-mark-holidays-flag t)
          (setq calendar-week-start-day 1)
          (setq mark-holidays-in-calendar t)
          (setq calendar-latitude +39.92)
          (setq calendar-longitude +116.46)
          (setq calendar-location-name "Beijing")
          (setq diary-file (concat sw/user-init-d "misc/diary")))
  :commands calendar
  :config (setq calendar-holidays
                '((holiday-chinese
                   5
                   4
                   "洋洋的生日")
                  (holiday-chinese 2 5 "文雅的生日")
                  (holiday-chinese 9  20 "可儿的生日")
                  (holiday-fixed 3 8 "妇女节")
                  (holiday-float 5 0 2 "母亲节")
                  (holiday-float 6 0 3 "父亲节")
                  (holiday-fixed 2 14 "情人节")
                  (holiday-fixed 6 1 "儿童节")
                  (holiday-chinese 1 1 "春节")
                  (holiday-chinese 1 15 "元宵节")
                  (holiday-chinese 2 2 "龙抬头")
                  (holiday-chinese 5 5 "端午")
                  (holiday-chinese 7 7 "七夕")
                  (holiday-chinese 8 15 "仲秋节")
                  (holiday-chinese 9 9 "重阳节")
                  (holiday-chinese 12 8 "腊八节")
                  (holiday-chinese 12 23 "小年")
                  (holiday-fixed 1 1 "元旦")
                  (holiday-fixed 4 1 "愚人节")
                  (holiday-fixed 5 1 "劳动节")
                  (holiday-fixed 10 1 "国庆节")
                  (holiday-fixed 12 25 "圣诞节")
                  (holiday-solar-term "清明" "清明节")
                  (holiday-solar-term "小寒" "小寒")
                  (holiday-solar-term "大寒" "大寒")
                  (holiday-solar-term "立春" "立春")
                  (holiday-solar-term "雨水" "雨水")
                  (holiday-solar-term "惊蛰" "惊蛰")
                  (holiday-solar-term "春分" "春分")
                  (holiday-solar-term "清明" "清明")
                  (holiday-solar-term "谷雨" "谷雨")
                  (holiday-solar-term "立夏" "立夏")
                  (holiday-solar-term "小满" "小满")
                  (holiday-solar-term "芒种" "芒种")
                  (holiday-solar-term "夏至" "夏至")
                  (holiday-solar-term "小暑" "小暑")
                  (holiday-solar-term "大暑" "大暑")
                  (holiday-solar-term "立秋" "立秋")
                  (holiday-solar-term "处暑" "处暑")
                  (holiday-solar-term "白露" "白露")
                  (holiday-solar-term "秋分" "秋分")
                  (holiday-solar-term "寒露" "寒露")
                  (holiday-solar-term "霜降" "霜降")
                  (holiday-solar-term "立冬" "立冬")
                  (holiday-solar-term "小雪" "小雪")
                  (holiday-solar-term "大雪" "大雪")
                  (holiday-solar-term "冬至" "冬至")))
  :bind ("<f11>" . calendar))

(use-package cal-china-x
  :commands (holiday-solar-term cal-china-x-birthday-from-chinese holiday-lunar))

(use-package calfw
  :init (progn
          (defun sw/calendar ()
            (interactive)
            (cfw:open-calendar-buffer
             :contents-sources
             (list
              (cfw:org-create-source "IndianRed")
              ))))
  :config (progn
            (defadvice cfw:refresh-calendar-buffer (before sw/refresh-gcal activate)
              (sw/refresh-gcal))
            (defun cfw:details-popup (text)
              (let ((buf (get-buffer cfw:details-buffer-name))
                    (before-win-num (length (window-list)))
                    (main-buf (current-buffer)))
                (unless (and buf (eq (buffer-local-value 'major-mode buf)
                                   'cfw:details-mode))
                  (setq buf (get-buffer-create cfw:details-buffer-name))
                  (with-current-buffer buf
                    (cfw:details-mode)
                    (set (make-local-variable 'cfw:before-win-num) before-win-num)))
                (with-current-buffer buf
                  (let (buffer-read-only)
                    (set (make-local-variable 'cfw:main-buf) main-buf)
                    (erase-buffer)
                    (insert text)
                    (goto-char (point-min))))
                (switch-to-buffer buf)))

            (defun cfw:refresh-calendar-buffer (no-resize)
              (interactive "P")
              (let ((cp (cfw:cp-get-component)))
                (when cp
                  (unless no-resize
                    (cfw:cp-resize cp (window-width) (- (window-height) 10)))
                  (loop for s in (cfw:cp-get-contents-sources cp)
                        for f = (cfw:source-update s)
                        if f do (funcall f))
                  (loop for s in (cfw:cp-get-annotation-sources cp)
                        for f = (cfw:source-update s)
                        if f do (funcall f))
                  (cfw:cp-update cp))))

            (defun cfw:dest-init-buffer (&optional buf width height custom-map)
              (lexical-let
                  ((buffer (or buf (get-buffer-create cfw:calendar-buffer-name)))
                   (window (or (and buf (get-buffer-window buf)) (selected-window)))
                   dest)
                (setq dest
                      (make-cfw:dest
                       :type 'buffer
                       :min-func 'point-min
                       :max-func 'point-max
                       :buffer buffer
                       :width (or width (window-width window))
                       :height (or height (- (window-height window) 10))
                       :clear-func (lambda ()
                                     (with-current-buffer buffer
                                       (erase-buffer)))))
                (with-current-buffer buffer
                  (unless (eq major-mode 'cfw:calendar-mode)
                    (cfw:calendar-mode custom-map)))
                dest))
            (use-package calfw-org)
            (use-package calfw-ical))
  :commands (cfw:open-calendar-buffer))

(global-set-key (kbd "<f11>") 'sw/calendar)

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
