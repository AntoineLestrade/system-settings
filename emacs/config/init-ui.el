;;; init-ui.el --- My Emacs configuration: initializr UI settings
;;; Commentary:
;;; Code:
(use-package zenburn-theme
  :ensure t)
;;(use-package monokai-theme :ensure t)


;; Disable toolbar
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(menu-bar-mode -1)
(blink-cursor-mode -1)

(setq inhibit-startup-screen t)
;; improve scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;;(setq-default show-trailing-whitespace t)
;;(setq whitespace-global-modes '(prog-mode fundamental-mode text-mode))
(add-hook 'prog-mode-hook '(lambda()
                             (setq show-trailing-whitespace t)))

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(global-hl-line-mode t)

;; Chage frame title
(setq frame-title-format
      '("" invocatin-name " Emacs - " (:eval (if (buffer-file-name)
						 (abbreviate-file-name (buffer-file-name))
					       "%b"))))

(provide 'init-ui)
;;; init-ui.el ends here
