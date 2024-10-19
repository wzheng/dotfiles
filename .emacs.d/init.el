;; list the packages to install
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(setq package-list '(tuareg monokai-theme anzu async bash-completion dash helm helm-core helm-projectile helm-swoop popup projectile smex tramp-term undo-tree with-editor neotree rainbow-delimiters ace-jump-mode moe-theme org-babel-eval-in-repl magit dimmer scala-mode cmake-mode dumb-jump swiper rust-mode))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
	(package-install package)))

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

(setq ispell-program-name "aspell") ; could be ispell as well, depending on your preferences
(setq ispell-dictionary "english") ; this can obviously be set to any language your spell-checking program supports

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

(load-theme 'monokai t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(require 'helm)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'helm-projectile)
(define-key global-map (kbd "C-c o") 'projectile-find-other-file)
(define-key global-map (kbd "C-c m") 'magit)
(define-key global-map (kbd "C-c f") 'xref-find-definitions)
(define-key global-map (kbd "C-c d") 'dumb-jump-back)
(define-key global-map (kbd "C-s") 'swiper)
(define-key global-map (kbd "C-r") 'swiper)

(global-anzu-mode +1)

(global-undo-tree-mode)

(require 'smartparens-config)

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

(require 'neotree)
  (global-set-key (kbd "C-x C-d") 'neotree-toggle)

(add-hook 'java-mode-hook #'rainbow-delimiters-mode)

(add-hook 'c-mode-common-hook #'google-set-c-style)

(delete-selection-mode 1)

(require 'dimmer)
(dimmer-configure-which-key)
(dimmer-configure-helm)
(dimmer-mode t)

(setq mac-option-modifier 'meta)

(setq dumb-jump-selector 'helm)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
(setq dumb-jump-disable-obsolete-warnings t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("816bacf37139d6204b761fea0d25f7f2f43b94affa14aa4598bce46157c160c2" default))
 '(package-selected-packages
   '(swiper-helm helm-xref xref cmake-mode google-c-style protobuf-mode dumb-jump helm-rg ag dimmer magit org-babel-eval-in-repl zenburn-theme xkcd with-editor undo-tree tuareg tramp-term sublimity spacemacs-theme solarized-theme smex smartparens scala-mode2 rust-mode rainbow-delimiters org-bullets noctilux-theme neotree moe-theme latex-preview-pane heroku-theme helm-swoop helm-projectile helm-ag gruvbox-theme gnuplot-mode gnuplot flycheck cyberpunk-theme clues-theme calfw-org calfw-ical calfw bash-completion auctex anzu ample-zen-theme alect-themes afternoon-theme ace-jump-mode ac-helm)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
