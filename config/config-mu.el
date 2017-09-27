(if-run-as-daemon
 (progn
   (use-package smtpmail-async
     :init
     (setq send-mail-function 'async-smtpmail-send-it
           message-send-mail-function 'async-smtpmail-send-it)
     (setq smtpmail-smtp-user "hl09083253cy@126.com"
           smtpmail-default-smtp-server "localhost"
           smtpmail-smtp-server "localhost"
           smtpmail-smtp-service 1025)
     :commands async-smtpmail-send-it)

   (setq sw/fortunes-list
         '("女友说她需要时间和距离，她是要算速度吗"
           "Q: 深海里的动物为什么都长的挺怪异的?\nA: 深海没光看不见, 大家都按照自己的想象力随便长长"
           "陨石为什么总是落在坑里呢"
           "统计结果指出，每五场交通意外死亡中就有1场是因为司机酒驾，如此看来，没喝酒的司机才是大杀器"
           "请问不孕症会遗传么"
           "别减肥了， 你的丑不仅是因为胖"
           "努力不一定会成功， 但是不努力一定会很轻松哦"
           "很多人不是心理疾病， 而不是心理残疾， 治不好的"
           "对今天解决不了的事情不必着急， 因为明天还是解决不了"
           "有些女生觉得说自己是吃货显得可爱， 其实并没有什么效果"
           "很多时候别人对你好并不是因为喜欢你： 他们就是喜欢对人好"
           "回首青春， 我发现我失去了很多宝贵的东西， 但我并不难过， 因为我知道我以后还会失去更多"
           "被门夹过的核桃, 吃了还补脑吗?"
           "英国马拉松仅一人完成比赛, 第二名带着五千人跑错路"
           "在曹操墓发现一具小孩尸骨, 砖家说是小时候的曹操"
           "女子为吓男友报警称其是逃犯, 警方调查后发现真的是逃犯"
           "乌克兰提议取消俄罗斯的一票否决权被俄罗斯一票否决"
           "男子酒驾遭查跳广场舞, 因跟不上节奏被识破"
           "浙江夫妻幻想中奖500万, 因分配不均大打出手"
           "一男子投诉在淘宝花39元买了卡地亚戒指, 怀疑买到假货"
           "学医女票发现男友出轨连捅32刀, 刀刀避开要害"
           "Q: 如何反驳'我吃的盐比你吃的饭还多'?\nA: 闭嘴, 我不想和海鲜讲话!"
           "Q: 为什么许多人在面试的时候喜欢问薪资待遇?\nA: 难道人家该问: '你们公司的梦想是什么'?"
           "Q: 天津大妈和北京大妈比谁更厉害?\nA: 天津没有大妈, 天津只有姐姐..."
           "A: 看了一晚上的高数\nB: 看懂了?\nA: 看开了"
           "大师兄跟我一样, c++ 的功底深厚, 面向对象的各种技能用的精通, 只可惜, 他还没有对象"
           "百年陈酿女儿红...这是一个悲伤的故事"
           "客户: '这个图下班之前必须发给我！'\n设计师: '好的！'\n第二天清早...\n客户: '图怎么还没发过来？'\n设计师: '我还没下班呢…'"
           "软件名称: 瑞星小狮子中文版\n软件大小: 5MB\n软件简介: 去掉了瑞星无用的杀毒和防火墙功能, 只保留小狮子."
           "机场安检处...\n前面一哥们背个书包, 安检员: 有电脑吗？\n哥们说: 有\n安检员: 拿出来\n哥们: 在家呢..."
           "某女: 你能让这个论坛的人都吵起来, 我今晚就跟你走.\n某软件工程师: PHP 是最好的语言！\n某论坛真的就炸锅了, 各种吵架...\n某女: 服了你了, 我们走吧.\n某软件工程师: 今天不行, 我一定要说服他们, PHP 必须是最好的语言."
           "程序员去面试.\n面试官问: '你毕业才两年, 这三年经验是怎么来的？！'\n程序员: '加班！'"
           "我是个程序员, 大学刚毕业去一家公司面试, 老板语重心长的对我说: 虽然薪水不多, 但是你可以在这里获得快速的成长, 这对年轻人来说是最重要的.\n现在, 两年过去了, 老板没有骗我, 我看起来已经像是40岁的人了."
           "xxx 入门\n -> xxx 应用实践\n  -> xxx 高级编程\n   -> xxx 的科学与艺术\n    -> xxx 之美\n     -> xxx 之道\n      -> xxx 之禅\n       -> 颈椎病康复指南..."
           "Q: push 的反义词是什么？\n非程序员: pull\n程序员: pop"
           "皇帝(严厉的说): 来人啊, 都给我退下."
           "有一个哥们每次说话都要很叼地来一句: 'for example', 我一直都觉得也许他是英语好习惯了吧.\n直到有一天他话比较多, 说了一句: 'for 两个 zample'"
           "弟弟今年五岁, 特别娇气, 动不动就爱哭. 一天, 弟弟突然问我: '要是有一天家里没钱了, 爸妈会把你卖了还是把我卖了?'\n我毫不犹豫地说: '肯定卖了你'. \n本以为他一定会哭, 没想到他居然咧嘴一笑: '我就知道你不值钱……'"
           "小时候犯错误, 被老爸打两巴掌, 倒也不是特别重, 就是气氛有点尴尬. \n为了缓解下气氛, 我想表达下对老爸的关心, 问他饿不饿, 结果一张嘴成了: '你是不是没吃饭…'\n那一夜被揍的那个叫用力啊…"
           "Q: 面对敌人的酷刑, 你会变节吗?\nA: 说好的色诱呢?"
           "Q: 今年情人节你还是一个人么?\nA: 难道我特么会变成狗么?"
           "<<21 天学会 emacs: 从入门到放弃>>"
           "\"重要的妖怪打三次\" -- 西游记之三打白骨精"
           "政客们说的话连一个标点符号都不能信"
           "国家防总总指挥: 汪洋"
           "羊是牛科动物..."
           "狗鼻子湿是因为它老舔，病的时候懒得舔就干了"
           "火龙果是仙人掌科的"
           "猕猴桃是藤本植物，不是长在树上的"
           "菠萝是草本植物"
           "英法百年战争打了116年"
           "客机上的黑盒 Black box 是橙色的"
           "1918年流感: 全世界都称为西班牙大流感, 只有西班牙称为法国流感"
           "W 其实它读作 'double u', 而不是 '达不溜'"
           "荷兰豆在荷兰叫中国豆"
           "鬣狗来自猫型总科"
           "gcc 的 -O4 优化选项是将你的代码邮件给 Jeff Dean 重写一下"
           "编译器从来不给 Jeff Dean 编译警告, 而是 Jeff Dean 警告编译器"
           "在2000年后段, Jeff Dean 码代码的速度突然激增了 40 倍, 原因是他把自己的键盘升级到了 USB 2.0"
           "Jeff Dean 对常量的时间复杂度并不满足, 于是他创造了世界上第一个 O(1/n) 的算法"
           "Jeff Dean 曾被迫发明了异步API, 原因是经他优化后的某个函数会在调用开始前返回"
           "当 Jeff Dean 听 MP3 时, 他查看其中的二进制内容然后在他脑子里进行音频解码"
           "在 2002 年, Google 搜索曾挂了几个小时, 于是 Jeff Dean 站出来手动处理用户的查询请求, 搜索准确度翻了番"
           "x86-64 指令集中有一些没有被记入到文档的 '私用' 指令, 事实上, 他们是给 Jeff Dean 用的"
           "有次 Jeff Dean 移位移得太狠了, 结果有一位跑到另一台计算机上去了"
           "Jeff Dean 通讯录的排序规则是按照联系人的 md5 值"
           "高斯能完整地背出圆周率: 倒着背"
           "高斯不能理解随机过程, 因为他能预测随机数"
           "高斯小时候, 老师让他算从1到100的和. 他计算了这个无穷级数的和, 然后一个一个地减去从 100 开始的所用自然数. 而且, 是心算"
           "中华人民共和国战略忽悠局"
           "A: 今天去相亲了.\nB: 长得怎么样?\nA: 像何首乌的根...\nB: 什么意思?\nA: 初具人形..."
           "有一次高斯证明了一条定理, 但他不喜欢它, 所以他又证明了它是假命题"))

   (defun sw/get-random-fortune ()
     "Returns a random element of LIST."
     (let
         ((fortune
           (nth (random (1- (1+ (length sw/fortunes-list)))) sw/fortunes-list)))
       (if (string= fortune "fortune")
           (shell-command-to-string "fortune") fortune)))

   (defun sw/fortune-signature ()
     (concat (sw/get-random-fortune) "

Li Han(韩立)
公司
分机: 
手机: 
"))

   (defun sw/formal-signature()
     "Li Han
Software Engineer, *** Communications, Inc.")

   (setq user-full-name "Li Han")
   (setq user-mail-address "hl09083253cy@126.com")

   (use-package mu4e
     :if (with-executable "mu")
     :init (progn
             (setq mu4e-view-fields '(:from :subject :date :attachments :to :cc))
             (setq mu4e-msg2pdf "/usr/local/bin/msg2pdf")
             (setq mu4e-use-fancy-chars nil)
             (setq mu4e-headers-include-related nil)
             ;; (setenv "MU_PLAY_PROGRAM" (executable-find "anyopen"))
             (setq mu4e-bookmarks '(("maildir:/ AND flag:unread AND NOT flag:trashed" "未读邮件"
                                     ?u)
                                    ("flag:flagged"                  "星标邮件"     ?f)
                                    ("(maildir:/ OR maildir:/sent) AND date:today..now AND NOT flag:trashed"
                                     "今日邮件"     ?t)
                                    ("(maildir:/ OR maildir:/sent) AND date:7d..now AND NOT flag:trashed"
                                     "最近一周邮件"          ?w)
                                    ("maildir:/sent"                     "已发送邮件" ?a)
                                    ("maildir:/archive"                     "归档" ?v)
                                    ("maildir:/trash"                     "垃圾筒" ?h)
                                    ("maildir:/drafts"                     "草稿" ?d)
                                    ("maildir:/spam"                     "垃圾邮件" ?s)
                                    ("to:sunwayforever"                     "个人邮件" ?p)
                                    ("cc:salsa OR to:salsa OR s:salsa OR f:\"J Sun\" OR f:\"Alex Pelts\" OR f:Amanieu OR f:atp-sw-admin"
                                     "salsa" ?l)))
             (setq mu4e-get-mail-command "fetchmail")
             (setq mu4e-compose-dont-reply-to-self t)
             (setq mu4e-compose-signature-auto-include nil)
             (setq mu4e-view-scroll-to-next nil)
             (setq mu4e-html2text-command 'mu4e-shr2text)
             (advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))
             ;; (setq mu4e-html2text-command "w3m -dump -T text/html")
             (setq mail-user-agent 'mu4e-user-agent)
             (setq message-kill-buffer-on-exit t)
             (setq message-confirm-send t)
             (setq mu4e-maildir       "~/Mail")
             (setq mu4e-sent-folder   "/sent")
             (setq mu4e-drafts-folder "/drafts")
             (setq mu4e-trash-folder  "/trash")
             (setq mu4e-refile-folder "/archive")
             (setq mu4e-update-interval 300)
             (setq mu4e-headers-leave-behavior 'apply)
             (setq mu4e-attachment-dir "/home/sunway/download")
             (setq mu4e-use-fancy-chars nil)
             (setq mu4e-confirm-quit nil)
             (setq mu4e-headers-time-format "%R")
             (setq mu4e-headers-date-format "%D")
             (setq mu4e-headers-fields '((:human-date . 12) (:flags . 6) (:from2 . 15) (:size . 6) (:thread-subject . 80)))
             (setq mu4e-view-show-images t)
             (setq mu4e-headers-sort-direction 'ascending)
             (setq mu4e-headers-results-limit 500)
             (setq sw/mu4e-pos-stack nil)
             (setq sw/mu4e-last-pos nil)

             (add-hook 'mu4e-headers-found-hook
                       (lambda()
                         (interactive)
                         (ignore-errors
                           (if sw/mu4e-last-pos (goto-char sw/mu4e-last-pos)
                             (progn
                               (goto-char (point-max))
                               (previous-line)
                               (goto-char (line-beginning-position))))
                           (hl-line-mode t)
                           (setq sw/mu4e-last-pos nil))))

             (when (fboundp 'imagemagick-register-types)
               (imagemagick-register-types))
             (setq mu4e-split-view 'horizontal)

             (defun mu ()
               (interactive)
               (setq sw/mu4e-pos-stack nil)
               (mu4e-headers-search
                "(maildir:/ OR maildir:/sent) AND date:today..now AND NOT flag:trashed")
               ;; (require 'mu4e-alert)
               ;; (mu4e-alert--get-mu-unread-mails
               ;;  (lambda (mails)
               ;;    (setq mu4e~headers-query-past nil)
               ;;    (if mails (mu4e-alert-view-unread-mails)
               ;;      (mu4e-headers-search
               ;;       "(maildir:/ OR maildir:/sent) AND date:today..now AND NOT flag:trashed"))))
               )
             (add-hook 'message-mode-hook '(lambda()
                                             (turn-off-auto-fill)))
             (add-hook 'after-init-hook (lambda()
                                          (mu4e t))))
     :config (progn
               (require 'mu4e-contrib)
               (use-package adaptive-mail-signature
                 :ensure nil
                 :config
                 (setq adaptive-mail-signature-alist
                       '(("xxtrum" . sw/fortune-signature)
                         ("salsa" . sw/formal-signature))))

               (defadvice mu4e-headers-mark-for-something (around mu4e-mark-for-read-advice activate)
                 (if current-prefix-arg
                     (mu4e-headers-mark-all)
                   ad-do-it))

               (add-to-list 'mu4e-view-actions '("hview in browser" . mu4e-action-view-in-browser) t)
               (defadvice mu4e-headers-mark-for-read (around mu4e-mark-for-read-advice activate)
                 (if current-prefix-arg
                     (mu4e-headers-mark-all-unread-read)
                   ad-do-it))

               (add-to-list
                'mu4e-header-info-custom
                '(:from2
                  .
                  (:name "From" :shortname "From" :help "From"
                         :function
                         (lambda (msg)
                           (let*  ((from (car (car (mu4e-message-field msg :from))))
                                   (is-reply nil))
                             (unless from
                               (setq from (cdr (car (mu4e-message-field msg :from)))))
                             (if (string= from "wei.sun")
                                 (progn
                                   (setq from (car (car (mu4e-message-field msg :to))))
                                   (unless from
                                     (setq from (cdr (car (mu4e-message-field msg :to)))))
                                   (unless from
                                     (setq from "no-name"))
                                   (setq is-reply t)))

                             (if (string-match ".*(\\(.*\\)).*" from)
                                 (setq from (match-string 1 from)))
                             (if is-reply
                                 (concat "To: " from)
                               from))))))

               (defun mu-add-appt (msg)
                 (interactive)
                 (let ()
                   (save-excursion
                     (with-temp-buffer
                       (insert (mu4e-message-body-text msg))
                       (goto-char (point-min))
                       ;; When:
                       ;; 2015年10月14日, 14:00 (2 hrs), China Time (Beijing, GMT+08:00).
                       (let ((y)
                             (m)
                             (d)
                             (time))
                         (cond ((search-forward-regexp "^时间: \\([0-9]+\\)年\\([0-9]+\\)月\\([0-9]+\\)日.*? \\(.*?\\)-" nil t nil)
                                (setq y (match-string 1))
                                (setq m (s-pad-left 2 "0" (match-string 2)))
                                (setq d (match-string 3))
                                (setq time (match-string 4)))
                               ((search-forward-regexp "\\([0-9]+\\)年\\([0-9]+\\)月\\([0-9]+\\)日, \\(.*?\\) \(" nil t nil)
                                (setq y (match-string 1))
                                (setq m (s-pad-left 2 "0" (match-string 2)))
                                (setq d (match-string 3))
                                (setq time (match-string 4)))
                               ;; 时间：中国时间（北京，GMT+08:00）2016年4月19日 19:00 （1 小时）。
                               ((search-forward-regexp "\\([0-9]+\\)年\\([0-9]+\\)月\\([0-9]+\\)日 \\(.*?\\) " nil t nil)
                                (setq y (match-string 1))
                                (setq m (s-pad-left 2 "0" (match-string 2)))
                                (setq d (match-string 3))
                                (setq time (match-string 4)))
                               (t (setq y nil)))
                         (if y
                             (progn
                               (defadvice org-mu4e-store-link (after org-mu4e-store-link-advice activate)
                                 (org-add-link-props :appt (format "DEADLINE: <%s-%s-%s xxx %s>" y m d time)))
                               (with-current-buffer mu4e~view-buffer
                                 (org-capture nil "m")
                                 (ad-recover 'org-mu4e-store-link)))
                           (message "no appt found")))))))
               (add-to-list 'mu4e-view-actions '("aadd appt" . mu-add-appt) t)
               (add-to-list 'mu4e-view-actions '("ocapture to org" . mu-capture-to-org) t)

               (defun mu-capture-to-org (msg)
                 (interactive)
                 (with-current-buffer mu4e~view-buffer
                   (org-mu4e-store-link)
                   (org-capture nil "m")))

               (defun sw/switch-or-compose-mail()
                 (interactive)
                 (if (get-buffer "*draft*")
                     (switch-to-buffer "*draft*")
                   (compose-mail)))

               (setq mu4e-register-as-spam-cmd "bogofilter -Ns < %s")
               (setq mu4e-register-as-ham-cmd "bogofilter -Sn < %s")

               (defun mu4e-register-msg-as-spam (msg)
                 "Mark message as spam."
                 (interactive)
                 (let* ((path (shell-quote-argument (mu4e-message-field msg :path)))
                        (command (format mu4e-register-as-spam-cmd path))) ;; re-register msg as spam
                   (shell-command command))
                 (if (eq major-mode 'mu4e-headers-mode)
                     (mu4e-mark-at-point 'trash nil)))
               (defun mu4e-register-msg-as-ham (msg)
                 "Mark message as ham."
                 (interactive)
                 (let* ((path (shell-quote-argument(mu4e-message-field msg :path)))
                        (command (format mu4e-register-as-ham-cmd path))) ;; re-register msg as ham
                   (shell-command command))
                 (if (eq major-mode 'mu4e-headers-mode)
                     (mu4e-mark-set 'move "/")))

               (add-to-list 'mu4e-headers-actions
                            '("aMark as spam" . mu4e-register-msg-as-spam) t)

               (add-to-list 'mu4e-headers-actions
                            '("bMark as ham" . mu4e-register-msg-as-ham) t)

               (defun mu4e-ask-bookmark (prompt &optional kar)
                 (unless mu4e-bookmarks (mu4e-error "No bookmarks defined"))
                 (let*
                     ((prompt
                       " ")
                      (bmarks (mapconcat
                               (lambda (bm)
                                 (let
                                     ((query
                                       (nth 0 bm))
                                      (title (nth 1 bm))
                                      (key (nth 2 bm)))
                                   (concat "["  (make-string 1 key) "]" title)))
                               mu4e-bookmarks "\n "))
                      (kar (read-char (concat prompt bmarks))))
                   (mu4e-get-bookmark-query kar)))

               (defadvice mu4e~headers-quit-buffer (around mu4e-hide-main-buffer-advice activate)
                 (sw/bury-buffer-or-kill-frame))

               (defadvice mu4e~headers-push-query (before sw/mu4e-remember-pos-advice activate)
                 (push (point) sw/mu4e-pos-stack))

               (defadvice mu4e~headers-pop-query (before sw/mu4e-pop-pos-advice activate)
                 (setq sw/mu4e-last-pos (pop sw/mu4e-pos-stack)))

               (bind-key "<mouse-1>" 'mu4e~view-compose-contact mu4e-view-contacts-header-keymap)

               (bind-key "q" 'sw/bury-buffer-or-kill-frame mu4e-main-mode-map)
               (bind-key "q" 'mu4e-headers-query-prev mu4e-headers-mode-map)
               ;; (bind-key "r" 'mu4e-compose-reply mu4e-headers-mode-map)
               ;; (bind-key "e" 'mu4e-compose-edit mu4e-headers-mode-map)
               ;; (bind-key "c" 'mu4e-compose-new mu4e-main-mode-map)
               ;; (bind-key "f" 'mu4e-compose-forward mu4e-headers-mode-map)
               ;; (bind-key "f" 'mu4e-compose-forward mu4e-view-mode-map)
               ;; (bind-key "r" 'mu4e-compose-reply mu4e-view-mode-map)
               ;; (bind-key "c" 'mu4e-compose-new mu4e-headers-mode-map)
               ;; (bind-key "c" 'mu4e-compose-new mu4e-view-mode-map)
               ;; (bind-key "m" 'mu4e-headers-mark-for-something mu4e-headers-mode-map)
               (bind-key "SPC" 'mu4e-headers-view-message mu4e-headers-mode-map)
               (use-package mu-bbs-key-binding))
     :bind ("C-x m" . sw/switch-or-compose-mail)
     :commands (mu4e mu))

   (use-package gnus-dired
     :init (progn
             (add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
             (setq gnus-dired-mail-mode 'mu4e-user-agent))
     :commands turn-on-gnus-dired-mode)

   (use-package mu4e-alert
     :if (with-executable "mu")
     :init (progn
             (setq mu4e-alert-interesting-mail-query "flag:unread AND NOT flag:trashed AND maildir:/"))
     :config (progn
               (defadvice mu4e-alert-update-mail-count-modeline (after mu4e-alert-update-wm activate)
                 (mu4e-alert--get-mu-unread-mails
                  (lambda (mails)
                    (ignore-errors
                      (if (= (length mails) 0)
                          (f-delete "/tmp/mu4e-alert.pid")
                        (f-touch "/tmp/mu4e-alert.pid"))))))
               (mu4e-alert-set-default-style 'libnotify)
               (mu4e-alert-enable-notifications)
               (mu4e-alert-enable-mode-line-display)))))
