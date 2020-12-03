;; init.el
;; Emacs Initialization file for Chandler Lutz

;; ---------------------------------------- ;;
;; -- Package Installitation information -- ;;
;; ---------------------------------------- ;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.
(package-initialize)

;; Set package archives
;; From Mastering Emacs p. 62
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "http://melpa.milkbox.net/packages/")))

;; ------------------- ;;
;; -- General Setup -- ;;
;; ------------------- ;;


;; Menu customizations and packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(package-selected-packages
   (quote
    (adaptive-wrap lsp-dart lsp-mode use-package ansible yaml-mode highlight-indent-guides docker-tramp web-mode magit ahk-mode auto-complete zenburn-theme yasnippet rainbow-delimiters material-theme key-chord electric-operator)))
 '(tool-bar-mode nil))
 ;; hide the menu bar
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; zenburn theme
;; (load-theme 'zenburn t)
;; material theme
(load-theme 'material t)

;; rainbow deliminators for most programming modesx
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; for consolas font
;; http://stackoverflow.com/a/13279410/1317443
(set-face-attribute 'default nil :height 117 :family "Consolas")

;; disable auto-fill-mode
(auto-fill-mode -1)
(remove-hook 'text-mode-hook #'turn-on-auto-fill)


;; for smooth scrolling
;; for smooth scrolling:
;; http://stackoverflow.com/a/4160949/1317443
;; https://zhangda.wordpress.com/2009/05/21/customize-emacs-automatic-scrolling-and-stop-the-cursor-from-jumping-around-as-i-move-it/
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1
  scroll-up-aggressively 0.01
  scroll-down-aggressively 0.01
  )

;; To make emacs automatically show line numbers
(global-linum-mode 1)

;; To *visually* wrap lines
(global-visual-line-mode t)

;; Adaptive wrap mode for markdown-mode
(add-hook 'markdown-mode-hook 'adaptive-wrap-prefix-mode)


;; Highlight current row
(global-hl-line-mode 1)

;; Matches parentheses and such in every mode
(show-paren-mode 1)

;; To show matching parens when they are off screen
;; https://www.emacswiki.org/emacs/ShowParenMode#toc1
(defadvice show-paren-function
      (after show-matching-paren-offscreen activate)
      "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
      (interactive)
      (let* ((cb (char-before (point)))
             (matching-text (and cb
                                 (char-equal (char-syntax cb) ?\) )
                                 (blink-matching-open))))
        (when matching-text (message matching-text))))

;;To enable ido (Interactively do things) mode
;;See here: http://www.emacswiki.org/emacs/InteractivelyDoThings
;;See also this stackoverflow question
;;http://stackoverflow.com/questions/17986194/emacs-disable-automatic-file-search-in-ido-mode
(require 'ido)
(setq ido-enable-flex-matching t)
(ido-mode t)
(setq ido-auto-merge-delay-time 9)

;;To modify multi-occur-in-matching-buffers
;;to allow for M-s / and then search
;;see this stackoverflow answer
;;http://stackoverflow.com/a/3434098/1317443
(defun my-multi-occur-in-matching-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))
(global-set-key (kbd "M-s /") 'my-multi-occur-in-matching-buffers)

;; ------------------ ;;
;; -- yas snippits -- ;;
;; ------------------ ;;

;; To use yasnippits
;; https://github.com/joaotavora/yasnippet/blob/master/README.mdown
;; https://www.youtube.com/watch?v=-4O-ZYjQxks
;; Expand snippet and go to next field using <C-tab>
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
;; bind yas snippit key to C-tab
;; http://emacs.stackexchange.com/a/9695/10338
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
;; To move to the next field using C-tab
;; from http://emacs.stackexchange.com/a/10796/10338
(define-key yas-keymap (kbd "TAB") nil)
(define-key yas-keymap (kbd "<tab>") nil)
(define-key yas-keymap (kbd "<C-tab>") 'yas-next-field-or-maybe-expand)
(define-key yas-keymap (kbd "<C-tab>") 'yas-next-field)


;; -------------- ;;
;; -- org mode -- ;;
;; -------------- ;;

;; to automatically activate org mode
;; see http://orgmode.org/org.html#Introduction
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;;Add spell check to org mod
;;from http://superuser.com/a/695123
(add-hook 'org-mode-hook 'turn-on-flyspell)
;;org auto-indent mode
;;see http://stackoverflow.com/a/1775652/1317443
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode t))
          t)

;; ------------------- ;;
;; -- auto-complete -- ;;
;; ------------------- ;;

;; Use emacs auto-complete
(require 'auto-complete-config)
(ac-config-default)
;; remove return as a completion key
;; https://www.emacswiki.org/emacs/ESSAuto-complete
(define-key ac-completing-map "\r" nil)
(define-key ac-completing-map "\t" 'ac-complete)
;; Remove quick help from autocomplete
(setq ac-use-quick-help nil)
;; Get tab completion in R script files
;; See this page here
;; https://stat.ethz.ch/pipermail/ess-help/2013-March/008719.html
;; Make sure that this is after the auto-complete package initialization
(setq  ess-tab-complete-in-script t)


;; ------------- ;;
;; -- ESS (R) -- ;;
;; ------------- ;;

;; To get R 3.0.0 and higher working with emacs
(setq inferior-R-program-name "C:/R/Rcurrent/bin/x64/Rterm.exe")

;;To make shift enter do the following:
;;Starting with an R file in the buffer, hitting shift-enter vertically splits the window and starts R in the right-side buffer. If R is running and a region is highlighted, shift-enter sends the region over to R to be evaluated. If R is running and no region is highlighted, shift-enter sends the current line over to R. Repeatedly hitting shift-enter in an R file steps through each line (sending it to R), skipping commented lines. The cursor is also moved down to the bottom of the R buffer after each evaluation.
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(require 'ess-site)

;; Set ess style to that used by Rstudio
;; see https://stackoverflow.com/a/34873014
;; (setq ess-set-style 'RStudio)
(add-hook 'find-file-hook 'my-r-style-hook)
(defun my-r-style-hook ()
  (when (string-match (file-name-extension buffer-file-name) "[r|R]$")
    (ess-set-style 'RStudio)))


;; rainbow deliminators for ess mode
(add-hook 'ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inferior-ess-mode-hook #'rainbow-delimiters-mode)


;; To get C-= to <- for R
;; https://statbandit.wordpress.com/2010/05/14/a-small-customization-of-ess/
;; https://www.r-bloggers.com/a-small-customization-of-ess/
(setq ess-S-assign-key (kbd "C-="))
(ess-toggle-S-assign-key t) ; enable above key definition
;; leave my underscore key alone!
(ess-toggle-underscore nil)

;; To bind %>% to >>
;; See https://github.com/emacs-ess/ESS/issues/96
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global ">>" " %>% ")

;; https://github.com/davidshepherd7/electric-operator
(require 'electric-operator)
;; ess-mode
(add-hook 'ess-mode-hook #'electric-operator-mode)
;; Add rules for ess mode
;; see perhaps https://github.com/davidshepherd7/electric-operator/issues/84
(electric-operator-add-rules-for-mode 'ess-mode
  (cons "=" " = ")
  (cons ";" "; ")
  ;; the data.table `:=` update by reference operator 
  (cons ":=" " := ")
  ;;data.table convenience functions 
  (cons "%like%" " %like% ")
  (cons "%chin%" " %chin% ")
  (cons "%between%" " %between% ")
  (cons "%inrange%" " %inrange% ")
  ;; lubridate convenience functions
  (cons "%m+%" " %m+% ")
  (cons "%m-%" " %m-% ")
  )
;;python mode
(add-hook 'python-mode-hook #'electric-operator-mode)
(electric-operator-add-rules-for-mode 'python-mode
  (cons "->" " -> ")
  (cons "=>" " => "))
;;dart mode
(add-hook 'lsp-dart-hook #'electric-operator-mode)

;; ---------------------- ;;
;; -- (R)markdown Mode -- ;;
;; ---------------------- ;;

;; Function to get r code chunk in Rmd mode
;; See http://emacs.stackexchange.com/a/27419/10338
(defun tws-insert-r-chunk (header)
  "Insert an r-chunk in markdown mode. Necessary due to interactions between polymode and yas snippet"
  (interactive "sHeader: ")
  (insert (concat "```{r " header "}\n\n```"))
  (forward-line -1))
;; Map the tws-insert-r-chunk to C-c R
(defun mp-add-markdown-keys ()
  (local-set-key (kbd "C-c R") 'tws-insert-r-chunk))
(add-hook 'markdown-mode-hook 'mp-add-markdown-keys)
;; Spelling for markdown mode http://emacs.stackexchange.com/a/17271/10338
(add-hook 'markdown-mode-hook 'flyspell-mode)
;; enable math for markdown
(setq markdown-enable-math t)

;; rainbow deliminators for Markdown mode
(add-hook 'markdown-mode-hook #'rainbow-delimiters-mode)

;; -------------- ;;
;; -- Rnw Mode -- ;;
;; -------------- ;;

;; To automatically load Rnw mode for .Rnw files
;; For code, see here:
;; https://www.emacswiki.org/emacs/AutoModeAlist
 (add-to-list 'auto-mode-alist '("\\.Rnw\\'" . Rnw-mode))


;; ------------ ;;
;; -- Acutex -- ;;
;; ------------ ;;

;; Using pdflatex as the default compiler for .tex files
(setq latex-run-command "pdflatex")

;; To automatically load LaTex Mode for .tex files
(add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))

;; https://www.gnu.org/software/auctex/manual/auctex/Parsing-Files.html
(setq TeX-auto-save t) ; Enable parse on save.
(setq TeX-parse-self t) ; Enable parse on load.
;; https://www.emacswiki.org/emacs/AUCTeX
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; rainbow deliminators for LaTex mode
(add-hook 'LaTeX-mode-hook #'rainbow-delimiters-mode)

;; -------------- ;;
;; -- web-mode -- ;;
;; -------------- ;;

;; from http://web-mode.org/
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; from middle of from http://web-mode.org/
;; see also https://github.com/fxbois/web-mode/issues/669
(setq web-mode-engines-alist
      '(("django"    . "\\.html\\'"))
      )


;; 
;; Set Windows-specific preferences if running in a Windows environment.
(setq explicit-shell-file-name
      "C:/Program Files/Git/bin/bash.exe")
(setq shell-file-name explicit-shell-file-name)
(add-to-list 'exec-path "C:/Program Files/Git/bin")


;; https://masteringemacs.org/article/running-shells-in-emacs-overview
(setq explicit-shell-file-name "C:/Program Files/Git/bin/bash.exe")
(setq shell-file-name "bash")
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)


;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
    (add-hook 'yaml-mode-hook
      '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; For highlighting indentations
;; https://github.com/DarthFennec/highlight-indent-guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;;Add minor mode syntax from https://emacs.stackexchange.com/a/5364
(add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'column)


;; lsp-dart -- https://github.com/emacs-lsp/lsp-dart
(use-package lsp-mode :ensure t)
(use-package lsp-dart 
  :ensure t 
  :hook (dart-mode . lsp))
(setq lsp-dart-sdk-dir "C:/flutter/bin/cache/dart-sdk")
;; for yas-snippets
(add-hook 'dart-mode-hook '(lambda () (set (make-local-variable 'yas-indent-line) 'auto)))
