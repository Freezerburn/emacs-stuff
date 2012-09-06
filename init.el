(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("ca2d69f5dd853dbf6fbcf5d0f1759ec357fda19c481915431015417ec9c1fbd8" default)))
 '(ns-auto-hide-menu-bar nil)
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; END OF CUSTOM STUFF THAT EMACS NEEDS

(setenv "PATH"
        (concat "/usr/local/bin:" (getenv "PATH")))

;; Line numbers!
(global-linum-mode t)
;; And on top of that, relative line numbering!
(defvar my-linum-format-string "%3d")

(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  (let* ((width (1+ (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

(defun my-linum-relative-line-numbers (line-number)
  (let ((offset (abs (- line-number my-linum-current-line-number))))
    (propertize (format my-linum-format-string offset) 'face 'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

;; Rainbowize parentheses, brackets, etc.
(add-to-list 'load-path "~/.emacs.d/")
(require 'rainbow-delimiters)
;;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(global-rainbow-delimiters-mode)

(electric-pair-mode t)

;; Spaces are inserted when indenting instead of tabs.
(setq c-basic-indent 2)
(setq-default indent-tabs-mode nil)

;; Load the Tuareg OCaml mode.
(add-to-list 'load-path "~/.emacs.d/tuareg-2.0.6")
(load "tuareg.el")
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
(autoload 'tuareg-mode "tuareg" "Major mode for editing OCaml code" t)
(autoload 'tuareg-run-ocaml "tuareg" "Run an inferior OCaml process." t)
(autoload 'ocamldebug "ocamldebug" "Run the OCaml debugger" t)

;; Loads evil-mode and makes it the default at startup.
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; Key bindings for evil-mode.
;; This bit of code sets up evil-mode so that typing in 'jj' will emulate typing
;; esc.
(define-key evil-insert-state-map "j" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))
;; End 'jj' keybinding.

;; Load auto-complete.
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
(ac-config-default)

;; Org mode, for notes and stuff.
(require 'org-install)
;; Always need these keys to actually work with org mode:
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; This setup ensures that '.org' files will switch to org mode.

;; Special python-mode that is not included by emacs anymore.
(add-to-list 'load-path "~/.emacs.d/python-mode.el-6.0.11")
(setq py-install-directory "~/.emacs.d/python-mode.el-6.0.11")
(require 'python-mode)

;; Whatever custom commands I want here:
(global-set-key (kbd "¥") "\\")

;; Load the emacs version of the zenburn theme.
(add-to-list 'custom-theme-load-path "~/.emacs.d/zenburn-emacs")
(add-to-list 'custom-theme-load-path "~/.emacs.d/tomorrow-theme/emacs")
(load-theme 'tomorrow-night-bright)
