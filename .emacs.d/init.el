;; list the packages to install 
(setq package-list '(tuareg monokai-theme anzu async bash-completion dash helm helm-core helm-projectile helm-swoop helm-ag popup projectile smex smartparens tramp-term undo-tree with-editor neotree rainbow-delimiters ace-jump-mode auto-complete moe-theme org-babel-eval-in-repl magit dimmer scala-mode))
(setq package-enable-at-startup nil)

(setq auto-save-default nil)
(setq make-backup-files nil)
(set-keyboard-coding-system nil)

(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(setq max-lisp-eval-depth 10000)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-hook 'python-mode-hook
  (lambda () (setq python-indent-offset 4)))

(require 'package)
(add-to-list 'load-path "~/.emacs.d/load")
;(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
	(package-install package)))

(setq ispell-program-name "aspell") ; could be ispell as well, depending on your preferences
(setq ispell-dictionary "english") ; this can obviously be set to any language your spell-checking program supports

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(load-theme 'monokai t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-anzu-mode +1)

(global-undo-tree-mode)

(require 'smartparens-config)

;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
	  '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(defun always-display-buffer-in-side-window (buffer alist)
  (let ((result (display-buffer-in-side-window buffer alist))
		(window (get-buffer-window buffer)))
	;; Avoid error when helm tries to make itself the only window despite being a
	;; side window, such as when invoking `helm-help'
	(set-window-parameter
	 window 'delete-other-windows #'ignore)
	result))
(add-to-list 'display-buffer-alist
			 `(,(rx bos "*helm" (* not-newline) "*" eos)
			   (always-display-buffer-in-side-window)
			   (inhibit-same-window . t)
			   (window-height . 0.4)))
;; Prevent helm from splitting unrelated windows unnecessarily. The split will
;; always be handled by the above entry in `display-buffer-alist'
(setq helm-split-window-preferred-function #'ignore)

(ac-config-default)

(require 'neotree)
  (global-set-key (kbd "C-x C-d") 'neotree-toggle)

(add-hook 'java-mode-hook #'rainbow-delimiters-mode)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(define-key global-map (kbd "C-x C-m") 'magit)

(define-key global-map (kbd "M-s") 'set-mark-command)

(delete-selection-mode 1)

(require 'dimmer)
(dimmer-configure-which-key)
(dimmer-configure-helm)
(dimmer-mode t)

(setq mac-option-modifier 'meta)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("816bacf37139d6204b761fea0d25f7f2f43b94affa14aa4598bce46157c160c2" default)))
 '(package-selected-packages
   (quote
    (helm-rg ag dimmer magit org-babel-eval-in-repl zenburn-theme xkcd with-editor undo-tree tuareg tramp-term sublimity spacemacs-theme solarized-theme smex smartparens scala-mode2 rust-mode rainbow-delimiters org-bullets noctilux-theme neotree moe-theme latex-preview-pane heroku-theme helm-swoop helm-projectile helm-ag gruvbox-theme gnuplot-mode gnuplot flycheck cyberpunk-theme clues-theme calfw-org calfw-ical calfw bash-completion auctex anzu ample-zen-theme alect-themes afternoon-theme ace-jump-mode ac-helm))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
