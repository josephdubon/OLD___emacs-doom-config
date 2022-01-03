;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Joseph Dubon"
      user-mail-address "josephdubon@pm.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-dracula) ;; << This line enables the theme

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme

  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  )

;;; Set custom font -match your IDE and terminal
(setq doom-font(font-spec
                :family "MesloLGS NF"
                :size 12))

;; Hide Org markup indicators.
(setq org-hide-emphasis-markers t)

; Custom Org markers
(setq
    org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Configure attachments to be stored together with their Org document.
(setq org-attach-id-dir "attachments/")

;; Org-Journal Settings
(setq org-journal-dir "~/org/journal/")
(setq org-journal-date-prefix "#+TITLE: "
      org-journal-time-prefix "* "
      org-journal-date-format "%a, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org"
      )

;; org-super-agenda provides great grouping and customization features to make
;; agenda mode easier to use.
(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))

;; Capturing and Notetaking
;; First, I define where all my Org-captured things can be found.

(setq org-agenda-files '("~/org" "~/org/journal" "~/org/roam"))

;; set path for projectile
(setq projectile-project-search-path '("~/Matrix"))

(after! org
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator #x2501
        org-agenda-compact-blocks t
        org-agenda-start-with-log-mode t)
  (with-eval-after-load 'org-journal
    (setq org-agenda-files '("~/org" "~/org/journal" "~/org/roam")))
  (setq org-agenda-clockreport-parameter-plist
        (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
  (setq org-agenda-deadline-faces
        '((1.0001 . org-warning)              ; due yesterday or before
          (0.0    . org-upcoming-deadline))))  ; due today or later

;; Copy paste from external clipboard (for terminal emacs window)
(setq osx-clipboard-mode t)

;; copy/paste between macOS and Emacs
;; [[https://emacs.stackexchange.com/questions/48607/os-copy-paste-not-working-for-emacs-mac][post]]
 (setq select-enable-clipboard t)
 (setq interprogram-paste-function
 (lambda ()
   (shell-command-to-string "pbpaste")))

;; Mouse scroll
;; reference:
;; http://ergoemacs.org/emacs/emacs%5Fmouse%5Fwheel%5Fconfig.html https://www.emacswiki.org/emacs/SmoothScrolling
(global-set-key (kbd "<mouse-4>")  (lambda () (interactive) (scroll-down 1) (previous-line)))  ;; non-natural scroll, mouse-4 is down
(global-set-key (kbd "<mouse-5>")(lambda () (interactive) (scroll-up 1) (next-line)))
(setq mouse-wheel-follow-mouse t) ;; scroll window under mouse
(setq scroll-preserve-screen-position t)

;; Blog settings - using this with ox-publish org-publish to blog
;; inspiration from https://opensource.com/article/20/3/blog-emacs
(after! (org-capture)
  (defun create-blog-post ()
    "Create an org file in ~/org/dubon-blog/posts/"
    (interactive)
    (let ((name (read-string "Filename: ")))
      (expand-file-name (format "%s.org" name) "~/org/dubon-blog/posts/")))
  (add-to-list 'org-capture-templates
               '("b" "Blog Post"
                 plain
                 (file create-blog-post)
                 (file "~/org/dubon-blog/org-templates/post.orgcaptmpl")
                 :kill-buffer t))
)

;; Waka-time config
(use-package! wakatime-mode)

;; If you want to enable wakatime in all buffers
;; put at end of file
(global-wakatime-mode)