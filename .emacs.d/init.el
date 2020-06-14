;; list the packages to install 
(setq package-list '(tuareg monokai-theme anzu async bash-completion dash helm helm-core helm-projectile helm-swoop popup projectile smex smartparens sublimity tramp-term undo-tree with-editor neotree rainbow-delimiters ace-jump-mode auto-complete moe-theme org-babel-eval-in-repl magit))
(setq package-enable-at-startup nil)
(package-initialize)

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
(add-to-list 'package-archives
			 '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

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
(global-anzu-mode +1)

(global-undo-tree-mode)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

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

(add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(delete-selection-mode 1)

(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "WAITING" "ON HOLD" "|" "DONE" "DELEGATED" "CANCELED")))

(setq org-blank-before-new-entry
      '((heading . always)
        (plain-list-item . always)))

(setq org-cycle-separator-lines 2)

(setq org-latex-create-formula-image-program 'dvipng)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.1))
(setq org-agenda-files (list "~/org" "~/org/work"))
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-agenda-mode-hook 'visual-line-mode)
(setq org-hide-emphasis-markers t)

(defun skip-daily-tasks () 
  (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
        (headline (or (and (org-at-heading-p) (point))
                      (save-excursion (org-back-to-heading)))))
    (if (string= (org-get-repeat) "+1d")
        next-headline
      nil)))


(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority")))
          (agenda "Present"
                  ((org-agenda-span 'day)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-overriding-header "Don't waste your time or time will waste you")
                   ))
          (agenda "Future"
                  ((org-agenda-span 5)
                   (org-agenda-start-day "+1d")
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-overriding-header "Through the looking glass")
                   ))
          (agenda "Past"
                  ((org-agenda-span 2)
                   (org-agenda-start-day "-2d")
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-overriding-header "Don't look back in anger")
                   ))
          (alltodo "")))))

(setq org-agenda-include-diary t)
(setq diary-file "~/org/calendar/ical-diary")
(setq org-agenda-prefix-format '(
  ;; (agenda  . " %i %-12:c%?-12t% s") ;; file name + org-agenda-entry-type
  (agenda  . " %i %?-12t% s")
  (timeline  . "  % s")
  (todo  . " %i %-12:c")
  (tags  . " %i %-12:c")
  (search . " %i %-12:c")))

(global-set-key (kbd "C-c c") 'org-capture)
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-capture-templates
      '(("m" "Misc" entry (file org-default-notes-file)
          "*  %? :misc: \n")
        ("t" "TODO" entry (file org-default-notes-file)
          "* TODO %? :todo: \n")
        ("q" "Quote" entry (file org-default-notes-file)
          "* %? :reading: \n")
         ("i" "Research idea" entry (file (concat org-directory "/work/ideas.org"))
          "* %? :research:idea: \n")
         ("r" "Research TODO" entry (file org-default-notes-file)
          "* TODO %? :research:todo: \n")
         ("p" "Personal" entry (file org-default-notes-file)
          "* %? :personal: \n")))

(setq org-src-fontify-natively t)
(setq mac-option-modifier 'meta)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Verdana" :slant normal :weight normal :height 1.0 :width normal))))
 '(org-agenda-current-time ((t (:inherit org-time-grid :foreground "Yellow" :height 1))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(variable-pitch ((t (:family "Verdana" :height 150 :weight light)))))

(add-hook 'org-mode-hook 'org-indent-mode)


(setenv "PATH" (concat "/Library/TeX/texbin" (getenv "PATH")))
(setq exec-path (append '("/Library/TeX/texbin") exec-path))

(add-to-list 'org-latex-packages-alist '("" "dsfont"))
(add-to-list 'org-latex-packages-alist '("" "color"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t)))

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
    (magit org-babel-eval-in-repl zenburn-theme xkcd with-editor undo-tree tuareg tramp-term sublimity spacemacs-theme solarized-theme smex smartparens scala-mode2 rust-mode rainbow-delimiters org-bullets noctilux-theme neotree moe-theme latex-preview-pane heroku-theme helm-swoop helm-projectile helm-ag gruvbox-theme gnuplot-mode gnuplot flycheck cyberpunk-theme clues-theme calfw-org calfw-ical calfw bash-completion auctex anzu ample-zen-theme alect-themes afternoon-theme ace-jump-mode ac-helm))))
