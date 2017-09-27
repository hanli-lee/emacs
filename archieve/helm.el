(add-to-list 'load-path "~/.elisp/helm/")
(require 'helm-config)
(add-to-list 'load-path "~/.elisp/helm-swoop/")
(require 'helm-swoop)
(global-set-key (kbd "M-i") 'helm-swoop)
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

(add-to-list 'load-path "~/.elisp/helm-dash/")
(require 'helm-dash)

(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-s") 'helm-swoop)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
