(setq user-full-name "Marc Wenzlawski"
      user-mail-address "marc.wenzlawski@gmail.com")

;; (add-hook! 'text-mode-hook 'auto-fill-mode)
(setq inhibit-compacting-font-caches t)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(setq display-line-numbers-type t)

(add-hook 'org-mode-hook
    (lambda () (set-input-method "latex")))

(setq emacs-dir (file-name-directory
                (or (buffer-file-name) load-file-name)))
(add-to-list 'load-path emacs-dir)
(require 'latex-input)



;; (load-theme 'cobalt t t)
;; (enable-theme 'cobalt)
(setq doom-theme 'doom-oceanic-next)

(setq doom-font (font-spec :family "Source Code Pro" :size 16 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

 ;; Set transparency of emacs
 (defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (set-frame-parameter (selected-frame) 'alpha value))

 (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

(setq org-directory "~/org/")

(define-key org-mode-map [remap backward-word] 'org-mark-ring-goto)
(setq org-ellipsis "⤵")
(setq org-hide-emphasis-markers t)

(set-face-attribute 'org-document-title nil :height 2.0)
(set-face-attribute 'org-level-1 nil :height 1.5)
(set-face-attribute 'org-level-2 nil :height 1.25)
(set-face-attribute 'org-level-3 nil :height 1.15)
(set-face-attribute 'org-level-4 nil :height 1.1)
(set-face-attribute 'org-done nil :height 1.0)
(set-face-attribute 'org-todo nil :height 1.0)

(defun nolinum ()
  (setq display-line-numbers nil)
  (centered-window-mode t)
)
(add-hook 'org-mode-hook 'nolinum)

(map! :map org-mode-map
      :gn "<s-up>" 'org-timestamp-up
      :gn "<s-down>" 'org-timestamp-down
      :gn "<s-left>" 'org-timestamp-down-day
      :gn "<s-right>" 'org-timestamp-up-day)


(add-hook 'org-mode-hook
      (lambda ()
         (add-hook 'after-save-hook 'org-preview-latex-fragment nil 'make-it-local)))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")

(defun check-cell ()
  (interactive)
  (let ((cell (org-table-get-field)))
    (if (string-match "[[:graph:]]" cell)
        (org-table-blank-field)
      (insert "[X]")
      (org-table-align))
    (org-table-next-row)))

;; (setq org-agenda-files)

;; put your css files there
;; (defvar org-theme-css-dir "~/.doom.d/org-css/")

;; (defun toggle-org-custom-inline-style ()
;;   (interactive)
;;   (let ((hook 'org-export-before-parsing-hook)
;;         (fun 'set-org-html-style))
;;     (if (memq fun (eval hook))
;;         (progn
;;           (remove-hook hook fun 'buffer-local)
;;           (message "Removed %s from %s" (symbol-name fun) (symbol-name hook)))
;;       (add-hook hook fun nil 'buffer-local)
;;       (message "Added %s to %s" (symbol-name fun) (symbol-name hook)))))

;; (defun org-theme ()
;;   (interactive)
;;   (let* ((cssdir org-theme-css-dir)
;;          (css-choices (directory-files cssdir nil ".css$"))
;;          (css (completing-read "theme: " css-choices nil t)))
;;     (concat cssdir css)))

;; (defun set-org-html-style (&optional backend)
;;   (interactive)
;;   (when (or (null backend) (eq backend 'html))
;;     (let ((f (or (and (boundp 'org-theme-css) org-theme-css) (org-theme))))
;;       (if (file-exists-p f)
;;           (progn
;;             (set (make-local-variable 'org-theme-css) f)
;;             (set (make-local-variable 'org-html-head)
;;                  (with-temp-buffer
;;                    (insert "<style type=\"text/css\">\n<!--/*--><![CDATA[/*><!--*/\n")
;;                    (insert-file-contents f)
;;                    (goto-char (point-max))
;;                    (insert "\n/*]]>*/-->\n</style>\n")
;;                    (buffer-string)))
;;             (set (make-local-variable 'org-html-head-include-default-style)
;;                  nil)
;;             (message "Set custom style from %s" f))
;;        (message "Custom header file %s doesnt exist")))))

(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(setq org-superstar-lightweight-lists 't)

(setq org-todo-keywords
        '((sequence "TODO(t!)" "PROG(!p)" "SOMD(s)" "WAIT(w)" "|" "DONE(d!)" "CANC(c!)")
      (sequence "[ ](T!)" "[-](!N)" "[S](S)" "[W](W)" "|" "[X](D!)" "[C](C!)")))

;; (defun org-summary-todo (n-done n-not-done)
;;   "Switch entry to DONE when all subentries are done, to TODO otherwise."
;;   (let (org-log-done org-log-states)   ; turn off logging
;;     (org-todo (if (and (/= n-not-done 0) (/= n-done 0)) "[-]" (if (= n-not-done 0) "[X]" "[ ]")))))
;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(setq org-log-into-drawer 't)
;; (setq org-log-done-with-time nil)
;; (setq org-log-repeat nil)
;; (setq org-log-state-notes-into-drawer nil)
;; (setq org-log-into-drawer nil)

(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   org-noter-hide-other nil
   org-noter-hide-other 't
   org-noter-doc-split-fraction '(0.4 . 0.4)
   )
  )

(map! :localleader :map org-mode-map "n" 'nil)

(map! :localleader
      :map org-mode-map
      (:prefix ("n" . "noter")
        :desc "Generate skeleton of PDF" "s" 'org-noter-create-skeleton
        :desc "Insert Note" "i" 'org-noter-insert-note
        :desc "Focus current page" "c" 'org-noter-sync-current-page-or-chapter
      ))

(use-package! org-pdftools
  :hook (org-load . org-pdftools-setup-link))

(setq org-pomodoro-lenght 45)

(setq company-idle-delay 0.2
      company-minimum-prefix-length 3)

(require 'org-mime)

;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e/")
(require 'mu4e)

(setq mu4e-maildir (expand-file-name "~/email"))

; get mail
(setq mu4e-get-mail-command "mbsync -c ~/.doom.d/.mbsyncrc personal-gmail"
  ;; mu4e-html2text-command "w3m -T text/html" ;;using the default mu4e-shr2text
  mu4e-view-prefer-html t
  mu4e-update-interval 180
  mu4e-headers-auto-update t
  mu4e-compose-signature-auto-include nil
  mu4e-compose-format-flowed t)

;; to view selected message in the browser, no signin, just html mail
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; enable inline images
(setq mu4e-view-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; every new email composition gets its own frame!
(setq mu4e-compose-in-new-frame t)

;; don't save message to Sent Messages, IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

(add-hook 'mu4e-view-mode-hook #'visual-line-mode)

;; <tab> to navigate to links, <RET> to open them in browser
(add-hook 'mu4e-view-mode-hook
  (lambda()
;; try to emulate some of the eww key-bindings
(local-set-key (kbd "<RET>") 'mu4e~view-browse-url-from-binding)
(local-set-key (kbd "<tab>") 'shr-next-link)
(local-set-key (kbd "<backtab>") 'shr-previous-link)))

;; from https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/elgoumx
(add-hook 'mu4e-headers-mode-hook
      (defun my/mu4e-change-headers ()
	(interactive)
	(setq mu4e-headers-fields
	      `((:human-date . 25) ;; alternatively, use :date
		(:flags . 6)
		(:from . 22)
		(:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
		(:size . 7)))))

;; if you use date instead of human-date in the above, use this setting
;; give me ISO(ish) format date-time stamps in the header list
;(setq mu4e-headers-date-format "%Y-%m-%d %H:%M")

;; spell check
(add-hook 'mu4e-compose-mode-hook
    (defun my-do-compose-stuff ()
       "My settings for message composition."
       (visual-line-mode)
       (org-mu4e-compose-org-mode)
           (use-hard-newlines -1)
       (flyspell-mode)))

(require 'smtpmail)

;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)

;;set up queue for offline email
;;use mu mkdir  ~/Maildir/acc/queue to set up first
(setq smtpmail-queue-mail nil)  ;; start in normal mode

;;from the info manual
(setq mu4e-attachment-dir  "~/dwn")

(setq message-kill-buffer-on-exit t)
(setq mu4e-compose-dont-reply-to-self t)

(require 'org-mu4e)

;; convert org mode to HTML automatically
(setq org-mu4e-convert-to-html t)

;;from vxlabs config
;; show full addresses in view message (instead of just names)
;; toggle per name with M-RET
(setq mu4e-view-show-addresses 't)

;; don't ask when quitting
(setq mu4e-confirm-quit nil)

;; mu4e-context
(setq mu4e-context-policy 'pick-first)
(setq mu4e-compose-context-policy 'always-ask)
(setq mu4e-contexts
  (list
   (make-mu4e-context
    :name "personal" ;;for acc1-gmail
    :enter-func (lambda () (mu4e-message "Entering context personal"))
    :leave-func (lambda () (mu4e-message "Leaving context personal"))
    :match-func (lambda (msg)
		  (when msg
		(mu4e-message-contact-field-matches
		 msg '(:from :to :cc :bcc) "marc.wenzlawski@gmail.com")))
    :vars '((user-mail-address . "marc.wenzlawski@gmail.com")
	    (user-full-name . "Marc Wenzlawski")
	    (mu4e-sent-folder . "/[personal].Sent Mail")
	    (mu4e-drafts-folder . "/[personal].drafts")
	    (mu4e-trash-folder . "/[personal].Bin")
	    (mu4e-compose-signature . (concat "Formal Signature\n" "Emacs 25, org-mode 9, mu4e 1.0\n"))
	    (mu4e-compose-format-flowed . t)
	    (smtpmail-queue-dir . "~/email/personal-gmail/queue/cur")
	    (message-send-mail-function . smtpmail-send-it)
	    (smtpmail-smtp-user . "marc.wenzlawski")
	    ;; (smtpmail-starttls-credentials . (("smtp.gmail.com" 587 nil nil)))
	    (smtpmail-auth-credentials . (expand-file-name "~/.authinfo.gpg"))
	    (smtpmail-default-smtp-server . "smtp.gmail.com")
	    (smtpmail-smtp-server . "smtp.gmail.com")
	    (smtpmail-smtp-service . 587)
	    (smtpmail-debug-info . t)
	    (smtpmail-debug-verbose . t)
	    (mu4e-maildir-shortcuts . ( ("/INBOX"            . ?i)
					("/[personal].Sent Mail" . ?s)
					("/[personal].Bin"       . ?t)
					("/[personal].All Mail"  . ?a)
					("/[personal].Starred"   . ?r)
					("/[personal].drafts"    . ?d)
					))))
					))

(require 'calfw)
(require 'calfw-org)
(setq cfw:org-overwrite-default-keybinding t)
(setq cfw:display-calendar-holidays nil)
;; (setq cfw:org-agenda-schedule-args '(:timestamp))

(map! :leader
      :desc "Open org calendar view" "oc" #'cfw:open-org-calendar)

(map! :map cfw:org-custom-map
      :gn "n" #'cfw:org-goto-date
      :gn "SPC" #'nil
      :gn "p" #'org-capture
      :gn "j" #'cfw:navi-next-week-command
      :gn "k" #'cfw:navi-previous-week-command)

(use-package! pdf-tools
    :config
    (pdf-tools-install)
    (setq-default pdf-view-display-size 'fit-height))

(setq pdf-view-resize-factor 1.1)

(defun mrw:no-center ()
  (centered-window-mode nil)
)
(add-hook 'pdf-view-mode-hook 'mrw:no-center)

(map! :map pdf-view-mode-map
      ;; :gn "i" #'org-noter-insert-note
      :gn "q" #'nil
      :gn "n" #'pdf-view-next-page
      :gn "p" #'pdf-view-previous-page
      :gv "i" #'pdf-annot-add-highlight-markup-annotation
      :gn "t" #'pdf-annot-add-text-annotation
      :gv "e" #'pdf-annot-add-underline-markup-annotation
      :gv "s" #'pdf-annot-add-squiggly-markup-annotation
      :gn "D" #'pdf-annot-delete)

(map! :map dired-mode-map
      [remap dired-find-file] 'dired-find-alternate-file
      [remap dired-up-directory] (lambda () (interactive) (find-alternate-file ".."))
      ) ; was dired-find-file

(use-package! rg
    :config
    (rg-enable-default-bindings))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	  TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
	  TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
		  #'TeX-revert-document-buffer)

(use-package! lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))  ; or lsp-deferred

(setq lsp-rust-server 'rust-analyzer)
