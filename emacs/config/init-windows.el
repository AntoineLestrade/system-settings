(winner-mode 1)

(require-package 'switch-window)
(require 'switch-window)
(setq switch-window-shortcut-style 'alphabet)
(global-set-key (kbd "C-x o") 'switch-window)


;; ;;----------------------------------------------------------------------------
;; ;; When splitting window, show (other-buffer) in the new window
;; ;;----------------------------------------------------------------------------
;; (defun split-window-func-with-other-buffer (split-function)
;;   (lexical-let ((s-f split-function))
;;     (lambda ()
;;       (interactive)
;;       (funcall s-f)
;;       (set-window-buffer (next-window) (other-buffer)))))

;; (global-set-key "\C-x2" (split-window-func-with-other-buffer 'split-window-vertically))
;; (global-set-key "\C-x3" (split-window-func-with-other-buffer 'split-window-horizontally))

;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
(defun split-window-horizontally-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-horizontally))))

(defun split-window-vertically-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-vertically))))

(global-set-key "\C-x|" 'split-window-horizontally-instead)
(global-set-key "\C-x_" 'split-window-vertically-instead)

(provide 'init-windows)
;;; init-windows.el ends here
