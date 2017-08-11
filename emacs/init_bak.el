;;; init.el --- Configuration entry point
;; Copyrigth (c) 2015 Antoine Lestrade
;; Author Antoine Lestrade <antoine.lestrade@gmail.com>
;; Version 0.0.1


;;; Commentary:
;;

;;; Code:

(defvar loc-cache-dir (concat user-emacs-directory "cache/"))
(defvar loc-data-dir (concat user-emacs-directory "data/"))
;(defcustom loc-cache-dir (concat user-emacs-directory ".cache/")
;  "Cache directory."
;  :group 'al-config)

(add-to-list 'load-path (expand-file-name "config" (file-name-directory load-file-name)))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries, like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; use-package + Manage packages
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))
;; https://github.com/jwiegley/use-package
(require 'use-package)

(require 'init-core)

;;(require 'init-autocompletion)
(require 'init-smartparens)
(require 'init-helm)
(require 'init-projectile)
(require 'init-programming)
(require 'init-ui)
(require 'init-git)
(require 'init-web)
(require 'init-ahk)
(require 'init-csharp)
(require 'init-powershell)

;;; init.el ends here.