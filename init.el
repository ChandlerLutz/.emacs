;; init.el
;; Emacs Initialization file for Chandler Lutz

;; From these speed tips
;; https://blog.d46.us/advanced-emacs-startup/
;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
;; (setq gc-cons-threshold (* 50 1000 1000))
;; see https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 500000000)
(setq read-process-output-max (* 1024 1024 3)) ;; 3mb


;; ---------------------------------------- ;;
;; -- Package Installitation information -- ;;
;; ---------------------------------------- ;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

;; use-package for package installation and maintenance 
(require 'use-package)
(setq use-package-always-ensure t)

;; For use-package chords
;; https://github.com/jwiegley/use-package#use-package-chords
(use-package use-package-chords
  :config (key-chord-mode 1))

;; ------------------- ;;
;; -- General Setup -- ;;
;; ------------------- ;;

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable tool bar

;; Font 
(set-face-attribute 'default nil :font "Fira Code Retina" :height 100)

;; Theme 
(use-package material-theme
  :config
  (load-theme 'material t))

;; -- Highlight current line and visually wrap lines -- ;;

;; https://stackoverflow.com/questions/20275596/how-to-use-hl-line-mode-to-highlight-just-one-1-line-when-visual-line-mode-is#comment30278964_20276250
(defun visual-line-line-range () (save-excursion (cons (progn (vertical-motion 0) (point)) (progn (vertical-motion 1) (point)))))
(setq hl-line-range-function 'visual-line-line-range)

(global-hl-line-mode 1)
;; To *visually* wrap lines
(global-visual-line-mode t)


;; line numbers
(column-number-mode)  ;; column numbers
(global-display-line-numbers-mode t) ;; line numbers

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
	       treemacs-mode-hook
	       eshell-mode-hook
	       ;; from https://stackoverflow.com/a/37447489
	       inferior-ess-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; -------------- ;;
;; -- Spelling -- ;;
;; -------------- ;;

(use-package flyspell
  :defer 3
  ;; define modes as here:
  ;; https://github.com/manugoyal/.emacs.d
  :init
  (progn
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (add-hook 'text-mode-hook 'flyspell-mode)
    )
  :config
  ;; if function emacs-modified-version function is nill 
  (if (file-exists-p "~/.emacs.d/hunspell_windows/hunspell_dicts_dir/en_US.aff")
      (progn
;;https://www.reddit.com/r/emacs/comments/dgj0ae/tutorial_spellchecking_with_hunspell_170_for/
    (setq ispell-program-name "hunspell")
    (setq ispell-hunspell-dict-paths-alist
	  '(("en_US" "~/.emacs.d/hunspell_windows/hunspell_dicts_dir/en_US.aff")))
    (setq ispell-local-dictionary "en_US")
    (setq ispell-local-dictionary-alist
	  '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
    ;; the following line won't make flyspell-mode enabled by default as you might think
    ;;(flyspell-mode 1)
    ;; ispell-word for showing correcting options of the current misspelled word
    (global-set-key (kbd "M-\\") 'ispell-word)
    ))
  )


;; ------------------ ;;
;; --  Parentheses -- ;;
;; ------------------ ;;

;; Matches parentheses and such in every mode
(show-paren-mode 1)

(use-package rainbow-delimiters
  :hook ((prog-mode markdown-mode latex) . rainbow-delimiters-mode)
  :defer 2)

;; ----------- ;;
;; -- Shell -- ;;
;; ----------- ;;

(setq explicit-shell-file-name
      "C:/Program Files/Git/bin/bash.exe")

;; --------------- ;;
;; -- Which Key -- ;;
;; --------------- ;;

(use-package which-key
  ;; init runs before the package loads
  :init (which-key-mode)
  :diminish which-key-mode
  :defer 2
  :config
  (setq which-key-idle-delay 1))

;; ---------------------------------------- ;;
;; -- Ivy, swiper counsel, helpful, etc. -- ;;
;; ---------------------------------------- ;;

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  ;; for fuzzy regex in ivy but swiper
  ;; https://emacs.stackexchange.com/a/41549
  (setq ivy-re-builders-alist
      '((swiper . regexp-quote)
        (t      . ivy--regex-fuzzy)))
  ;; to speed up swiper
  ;; https://www.reddit.com/r/emacs/comments/cfdv1y/swiper_is_extreamly_slow/
  (setq swiper-use-visual-line nil)
  (setq swiper-use-visual-line-p (lambda (a) nil))
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))


;; Use counsel buffer switcher with C-M-j
;; (global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :defer 3
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; see here to try to get the incons working
;; https://github.com/daviwil/emacs-from-scratch/issues/1
(use-package doom-modeline
  :defer 2
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package all-the-icons)

;; -------------- ;;
;; -- LSP Mode -- ;;
;; -------------- ;;

;; emacs from scratch example 
;; https://www.youtube.com/watch?v=E-NAM9U5JYE
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  ;; prefix lsp commands with C-c l
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  ;; see
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
  (setq lsp-completion-provider :capf)
  ;; disable ui doc b/c of possible slow performance on windows
  ;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
  ;;(setq lsp-ui-doc-enable nil)
  )
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  ;; set the delay for lsp ui doc
  (lsp-ui-doc-delay 1)
  ;; set the delay to lsp sideline code actions
  ;; see https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
  (lsp-ui-sideline-delay 0.75)
  )



;; ----------------------------- ;;
;; -- Lsp Mode Dart & Flutter -- ;;
;; ----------------------------- ;;

;; for path to the dart analysis server
;; see https://lupan.pl/dotemacs/
(use-package lsp-dart
  :init
  (setq lsp-dart-analysis-sdk-dir "C:\development\flutter\bin\cache\dart-sdk")
  :hook (dart-mode . lsp)
  :custom
  ;; disable buffer at the bottom
  ;; https://github.com/emacs-lsp/lsp-mode/issues/1223#issuecomment-586674535
  (lsp-signature-auto-activate nil)
  ;; to remove bottom doc buffer as this is already in the
  ;; doc tool tip
  ;; https://github.com/emacs-lsp/lsp-mode/issues/1028
  (lsp-eldoc-hook nil)
  )
(use-package smartparens
  :hook ((dart-mode) .  smartparens-mode)
  :defer 2
  )

  

;; -------------- ;;
;; -- flycheck -- ;;
;; -------------- ;;

(use-package flycheck)

;; ---------------- ;;
;; -- ESS R mode -- ;;
;; ---------------- ;;

(use-package ess
  :mode "\\.R|.r\\'"
  :config
  
  ;; To get R 3.0.0 and higher working with emacs
  (setq inferior-R-program-name "C:/R/Rcurrent/bin/x64/Rterm.exe")
  ;; Do not ask for ess startup location 
  (setq ess-ask-for-ess-directory nil)
  ;; To make a new process start with just *R* for the below
  ;; shift enter
  ;; see https://github.com/emacs-ess/ESS/issues/1073
  (setq ess-gen-proc-buffer-name-function 'ess-gen-proc-buffer-name:simple)
  ;; The name of the ESS process associated with the buffer.
  (setq ess-local-process-name "R")
  (setq ansi-color-for-comint-mode 'filter)
  (setq comint-scroll-to-bottom-on-input t)
  (setq comint-scroll-to-bottom-on-output t)
  (setq comint-move-point-for-output t)
  ;; This makes <S-return> start a new session window to the right
  ;; with the program on the left -- currently not working with R
  ;; programs in the `~/` directory as the inferior ess buffer starts
  ;; for `~/.emacs.d/scratch.R` as `R:.emacs.d`
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
  
  ;; Set R style
  ;; see https://stackoverflow.com/a/34873014
  (add-hook 'find-file-hook 'my-r-style-hook)
  (defun my-r-style-hook ()
    (when (string-match (file-name-extension buffer-file-name) "[r|R]$")
      (ess-set-style 'RStudio)
      ;; to try a defualt setting
      ;; (ess-set-style 'OWN)
      ;; (setq ess-indent-offset 2)
      ;; (setq ess-offset-arguments 'prev-call)
      ;; (setq ess-offset-arguments-newline 'prev-call)
      
      ))
  :bind (("C-=" . "<-")
	 ;; Shift-enter runs an R line using my-ess-eval above
	 ("<S-return>" . my-ess-eval)
	 )
  :chords ((">>" . " %>% ")))

;; ----------------------- ;;
;; -- Electric Operator -- ;;
;; ----------------------- ;;

;; https://github.com/davidshepherd7/electric-operator
;; for an example use package setup, see
;; https://github.com/chuvanan/dot-files/blob/master/emacs-init.el
(use-package electric-operator
  :config

  ;; ess-r 
  (add-hook 'ess-mode-hook #'electric-operator-mode)
  (electric-operator-add-rules-for-mode 'ess-r-mode
					(cons "=" " = ")
					(cons ";" "; ")
					;;data.table convenience functions 
					(cons "%like%" " %like% ")
					(cons "%chin%" " %chin% ")
					;;(cons "% chin%" " %chin%")
					(cons "%between%" " %between% ")
					(cons "%inrange%" " %inrange% ")
					;; lubridate convenience functions
					(cons "%m+%" " %m+% ")
					(cons "%m-%" " %m-% "))
  ;; ess-r inferior 
  (add-hook 'inferior-ess-mode-hook #'electric-operator-mode)
  (electric-operator-add-rules-for-mode 'inferior-ess-r-mode
					(cons "=" " = ")
					(cons ";" "; ")
					;;data.table convenience functions 
					(cons "%like%" " %like% ")
					(cons "%chin%" " %chin% ")
					;;(cons "% chin%" " %chin%")
					(cons "%between%" " %between% ")
					(cons "%inrange%" " %inrange% ")
					;; lubridate convenience functions
					(cons "%m+%" " %m+% ")
					(cons "%m-%" " %m-% "))
  
  ;; python 
  (add-hook 'python-mode-hook #'electric-operator-mode)
  (electric-operator-add-rules-for-mode 'python-mode
					(cons "->" " -> ")
					(cons "=>" " => "))
  )


;; --------------------------------- ;;
;; -- Company Mode for Completion -- ;;
;; --------------------------------- ;;

(use-package company
  :hook (prog-mode . company-mode)

  ;; To make sure that there are we can use tab completion
  ;; but we can use tab to auto-complete and return only
  ;; works when there the user interacts with company mode 
  ;; https://github.com/raxod502/radian/blob/223abc524f693504af6ebbc70ad2d84d9a6e2d1b/radian-emacs/radian-autocomplete.el#L6-L182
  :bind (;; Replace `completion-at-point' and `complete-symbol' with
         ;; `company-manual-begin'. You might think this could be put
         ;; in the `:bind*' declaration below, but it seems that
         ;; `bind-key*' does not work with remappings.
         ([remap completion-at-point] . company-manual-begin)
         ([remap complete-symbol] . company-manual-begin)

         ;; The following are keybindings that take effect whenever
         ;; the completions menu is visible, even if the user has not
         ;; explicitly interacted with Company.

         :map company-active-map

         ;; Make TAB always complete the current selection. Note that
         ;; <tab> is for windowed Emacs and TAB is for terminal Emacs.
         ("<tab>" . company-complete-selection)
         ("TAB" . company-complete-selection)

         ;; Prevent SPC from ever triggering a completion.
         ("SPC" . nil)

         ;; The following are keybindings that only take effect if the
         ;; user has explicitly interacted with Company.

         :map company-active-map
         :filter (company-explicit-action-p)

         ;; Make RET trigger a completion if and only if the user has
         ;; explicitly interacted with Company. Note that <return> is
         ;; for windowed Emacs and RET is for terminal Emacs.
         ("<return>" . company-complete-selection)
         ("RET" . company-complete-selection)

         ;; We then do the same for the up and down arrows. Note that
         ;; we use `company-select-previous' instead of
         ;; `company-select-previous-or-abort'. I think the former
         ;; makes more sense since the general idea of this `company'
         ;; configuration is to decide whether or not to steal
         ;; keypresses based on whether the user has explicitly
         ;; interacted with `company', not based on the number of
         ;; candidates.

         ("<up>" . company-select-previous)
         ("<down>" . company-select-next))
    
  ;; :bind (:map company-active-map
  ;; 	      ("<tab>" . company-complete-selection)
  ;; 	      ("C-;" . company-complete-selection)
  ;; 	      )
  ;;        ;; (:map lsp-mode-map
  ;;        ;; ("<tab>" . company-indent-or-complete-common))
  :defer 2 
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.0)
  )


;; ------------------ ;;
;; -- yas-snippets -- ;;
;; ------------------ ;;

;; https://github.com/joaotavora/yasnippet/blob/master/README.mdown
;; https://www.youtube.com/watch?v=-4O-ZYjQxks
;; https://www.reddit.com/r/emacs/comments/9bvawd/use_yasnippet_via_usepackage/e59vh0w?utm_source=share&utm_medium=web2x&context=3
;; Expand snippet and go to next field using <C-tab>

(use-package yasnippet
  :config
  ;; Use everywhere
  (yas-global-mode t)
  ;; Add to the path 
  ;; (add-to-list 'load-path
  ;;              "~/.emacs.d/plugins/yasnippet")
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
)


;; ------------ ;;
;; -- Auctex -- ;;
;; ------------ ;;

;; I don't think that this is working
;; at the moment 
;; (use-package latex-mode
(use-package LaTeX-mode
  :ensure auctex
  ;;:defer 1
  :mode ("\\.tex\\'" . latex-mode)
  ;;:hook ((latex-mode) . flyspell-mode)
  :config
  (
   (setq latex-run-command "pdflatex")
   (setq TeX-auto-save t) ; Enable parse on save.
   (setq TeX-parse-self t) ; Enable parse on load.
   (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
   (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
   ;; (add-hook 'LaTeX-mode-hook 'rainbow-delimiters-mode))
   )
  )

;; ---------------------- ;;
;; -- (R)markdown mode -- ;;
;; ---------------------- ;;

(use-package adaptive-wrap)

;; from https://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  ;;:ensure auctex
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
("\\.Rmd\\'" . markdown-mode)
  :init (setq markdown-command "multimarkdown")
  :config
  (setq markdown-enable-math t)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'markdown-mode-hook 'adaptive-wrap-prefix-mode)
  )

;; From
;; https://github.com/SteveLane/dot-emacs/blob/master/packages-polymode.el
(use-package polymode
  :ensure markdown-mode
  :ensure poly-R
  :ensure poly-noweb
  :config
  ;; R/tex polymodes
  (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
  (add-to-list 'auto-mode-alist '("\\.rnw" . poly-noweb+r-mode))
  (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
  (setq markdown-enable-math t)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  ;; 
  )

;; --------------- ;; 
;; -- yaml mode -- ;;
;; --------------- ;;

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  )

;; -------------------------- ;;
;; -- Custom Set Variables -- ;;
;; -------------------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(package-selected-packages
   '(smartparens adaptive-wrap yaml-mode yaml yasnippet poly-markdown polymode fyspell latex highlight-parentheses flycheck doom-modeline counsel helpful ivy-rich ivy which-key rainbow-delimiters use-package material-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; GC
;; Make gc pauses faster by decreasing the threshold.
;; (setq gc-cons-threshold (* 2 1000 1000))
