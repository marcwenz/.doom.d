(setq user-full-name "Marc Wenzlawski"
      user-mail-address "marc.wenzlawski@gmail.com")

(add-hook! 'text-mode-hook 'auto-fill-mode)
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
(setq doom-theme 'doom-city-lights)

(setq doom-font (font-spec :family "Source Code Pro" :size 16 :weight 'light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

(set-face-foreground 'font-lock-comment-face "light pink")

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
   org-noter-doc-split-fraction '(0.3 . 0.3)
   )
  )

(map! :map pdf-view-mode-map
      :gn "i" #'org-noter-insert-note
      :gn "q" #'nil
      :gn "n" #'pdf-view-next-page
      :gn "p" #'pdf-view-previous-page)

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

(use-package! pdf-tools
    :config
    (pdf-tools-install)
    (setq-default pdf-view-display-size 'fit-height))

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
