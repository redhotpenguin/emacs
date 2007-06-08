
;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
(setq transient-mark-mode t)
(defalias 'perl-mode 'cperl-mode)
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode 1)
(setq font-lock-auto-fontify t))
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq visible-bell t)
(setq-default indent-tabs-mode nil)



(setq load-path
      (cons (expand-file-name "~/.emacs.d/lisp") load-path))
 (autoload 'tt-mode "tt-mode")
 (setq auto-mode-alist
  (append '(("\\.tmpl$" . tt-mode))  auto-mode-alist ))
 
(defun perltidy ()
  "Run perltidy on the current region or buffer."
  (interactive)
  (save-excursion
	(unless mark-active (mark-defun))
	(shell-command-on-region (point) (mark) "perltidy -q" nil t)))
(require 'psvn)
(global-set-key [f7] 'perltidy)
(setq load-path (cons (expand-file-name "~/.emacs.d/lisp") load-path))
(require 'template)
(template-initialize)
(require 'perlnow)

  (setq perlnow-script-location
      (substitute-in-file-name "$HOME/bin"))
  (setq perlnow-pm-location
      (substitute-in-file-name "$HOME/lib"))
  (setq perlnow-h2xs-location'
      (substitute-in-file-name "$HOME/perldev"))
  (perlnow-define-standard-keymappings)

 (global-set-key "\C-xt" 'perltidy-region)
 (defun perltidy-region ()
   "Run the perltidy parser on the current region."
   (interactive)    
   (let ((start (mark))
         (end (point))
         (shell-command-default-error-buffer "perltidy-errors")
         (command "perltidy"))
         (shell-command-on-region 
             start 
             end 
             command 
             t t 
             shell-command-default-error-buffer))) 

(global-set-key [f4] 'perlnow-script)

(add-hook'cperl-mode-hook
 '(lambda () 
	(define-key cperl-mode-map [f1] 'perlnow-perl-check) ))

; auto completion
;;;;;;;;;;;;;;;;;
(setq perl-wordlist-default-file "~/.vim/wordlists/perl.list")
(setq auto-load-wordlist 't)
(if auto-load-wordlist
      (find-file-noselect perl-wordlist-default-file 'NOWARN)    
)

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")

(global-set-key "\C-i" 'my-tab)

(defun my-tab (&optional pre-arg)
  "If preceeding character is part of a word then dabbrev-expand,
else if right of non whitespace on line then tab-to-tab-stop or
indent-relative, else if last command was a tab or return then dedent
one step, else indent 'correctly'"
  (interactive "*P")
  (cond ((= (char-syntax (preceding-char)) ?w)
         (let ((case-fold-search t)) (dabbrev-expand pre-arg)))
        ((> (current-column) (current-indentation))
         (indent-relative))
        (t (indent-according-to-mode)))
  (setq this-command 'my-tab))

(add-hook 'cperl-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'html-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'sgml-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'perl-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'text-mode-hook
          '(lambda () 
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'cperl-mode-hook
          '(lambda ()
            (local-set-key "\C-i"     'my-tab)))

; add more hooks here
