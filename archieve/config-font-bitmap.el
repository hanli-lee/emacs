(if (string= window-system "w32")
    (progn
      (create-fontset-from-fontset-spec
       "-*-terminus-medium-r-normal--16-*-*-*-*-*-fontset-gbk,
         chinese-gb2312:-*-文泉驿正黑-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-gbk:-*-文泉驿正黑-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-5:-*-文泉驿正黑-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-6:-*-文泉驿正黑-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-7:-*-文泉驿正黑-medium-r-normal--0-0-75-75-p-0-iso10646-1" t)
      ;; (setq default-frame-alist'((font . "fontset-gbk")))
      )
  (progn
    (create-fontset-from-fontset-spec
     "-*-terminus-medium-r-normal--16-*-*-*-*-*-fontset-gbk,
         chinese-gb2312:-wenquanyi-wenquanyi bitmap song-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-gbk:-wenquanyi-wenquanyi bitmap song-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-5:-wenquanyi-wenquanyi bitmap song-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-6:-wenquanyi-wenquanyi bitmap song-medium-r-normal--0-0-75-75-p-0-iso10646-1,
         chinese-cns11643-7:-wenquanyi-wenquanyi bitmap song-medium-r-normal--0-0-75-75-p-0-iso10646-1" t)
    (setq default-frame-alist
	  '(
	    (font . "fontset-gbk")))))

