(require 'hide-comnt)

(setq sw/hs-current-state 'show)
(make-variable-buffer-local 'sw/hs-current-state)
(defun sw/hs-toogle-all ()
  (interactive)
  (if (eq sw/hs-current-state 'hide)
      (progn
        (setq sw/hs-current-state 'show)
        (call-interactively 'hs-show-all))
    (progn
      (setq sw/hs-current-state 'hide) 
      (call-interactively 'hs-hide-all))))

(setq sw/hide-ifdef-state 'show)
(make-variable-buffer-local 'sw/hide-ifdef-state)
(defun sw/toggle-hide-ifdef ()
  (interactive)
  (if (eq sw/hide-ifdef-state 'hide)
      (progn
        (setq sw/hide-ifdef-state 'show)
        (call-interactively 'show-ifdef-block))
    (progn
      (setq sw/hide-ifdef-state 'hide)
      (call-interactively 'hide-ifdef-block))))

(use-package hideshow
  :init
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'c-mode-common-hook 'hs-minor-mode)
  (add-hook 'c++-mode-hook 'hs-minor-mode)
  (add-hook 'python-mode-hook 'hs-minor-mode)
  (add-hook 'java-mode-hook 'hs-minor-mode)
  :config
  (progn
    (define-key hs-minor-mode-map (kbd "C-, C-,")
      '(lambda ()
         (interactive)
         (if current-prefix-arg
             (progn
               (setq current-prefix-arg nil)
               (sw/hs-toogle-all))
           (save-excursion
             (beginning-of-line)
             (if  (and (fboundp 'hide-ifdefs) (looking-at "#if"))
                 (sw/toggle-hide-ifdef)
               (hs-toggle-hiding))))))
    (setq hs-isearch-open nil))
  :commands hs-minor-mode)
