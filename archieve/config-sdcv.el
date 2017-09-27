(require 'sdcv)
(setq sdcv-dictionary-simple-list   
      '("朗道英汉字典5.0"
        "朗道汉英字典5.0"))
(setq sdcv-dictionary-complete-list
      '("朗道英汉字典5.0"
        "朗道汉英字典5.0"))
(global-set-key (kbd "M-?") 'sdcv-search-input+)
