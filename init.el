(add-to-list 'load-path "~/.emacs.d/elisp")
(progn (cd "~/.emacs.d/elisp")
       (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path "~/.emacs.d/iy-go-to-char")

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq-default indent-tabs-mode nil)
(set-face-attribute 'default nil :height 100)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))
(global-set-key [f11] 'toggle-fullscreen)

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(global-set-key (kbd "C-<tab>") 'select-next-window)
(global-set-key (kbd "C-`")  'select-previous-window)

(global-set-key [M-left] 'windmove-left)          ; move to left window
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to down window

(global-set-key (kbd "M-<kp-4>") 'windmove-left)          ; move to left window
(global-set-key (kbd "M-<kp-6>") 'windmove-right)        ; move to right window
(global-set-key (kbd "M-<kp-8>") 'windmove-up)              ; move to upper window
(global-set-key (kbd "M-<kp-2>") 'windmove-down)          ; move to down window
(global-set-key (kbd "M-<kp-5>") 'windmove-down)          ; move to down window
(global-set-key (kbd "M-<kp-7>") 'next-buffer)          ; scroll buffer next
(global-set-key (kbd "M-<kp-9>") 'previous-buffer)          ; scroll buffer previous

(global-set-key (kbd "M-]") 'next-buffer)          ; scroll buffer next
(global-set-key (kbd "M-[") 'previous-buffer)          ; scroll buffer previous

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))

(setq x-select-enable-clipboard t)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-'") 'shrink-window)
(global-set-key (kbd "C-\"") 'enlarge-window)

(display-time-mode 1)

;; rinari
(require 'rinari)
(global-rinari-mode)

;; Whether installed through ELPA or from source you probably want to
;; add the following lines to your .emacs file:

;; ido
(require 'ido)
(ido-mode t)

(load-theme 'wheatgrass)

(defun append-semicolon ()
  "Append a semicolon without moving cursor"
  (interactive)
  (let ((tmp (point)))
    (end-of-line)
    (insert ";")
    (goto-char tmp)))

(global-set-key (kbd "C-;") 'append-semicolon)

(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)

(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(require 'magit)

(setq yas-snippet-dirs
      '("~/.emacs.d/elisp/yasnippet/snippets/"            ;; default
        ))
(require 'yasnippet)
(yas-global-mode 1)

;work around to get tab working in ansi-term
(add-hook 'term-mode-hook (lambda()
                (yas-minor-mode -1)))


(require 'emms-setup)
(emms-standard)
(emms-default-players)
(global-set-key (kbd "C-c b") 'browse-url)
(require 'iy-go-to-char)
(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c F") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c ;") 'iy-go-to-char-continue)
(global-set-key (kbd "C-c ,") 'iy-go-to-char-continue-backward)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Dropbox/todo.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(require 'multi-term)

(global-set-key (kbd "<f5>") 'cycle-ansi-term)
(defun cycle-ansi-term ()
  "cycle through buffers whose major mode is term-mode"
  (interactive)
  (when (string= "term-mode" major-mode)
    (bury-buffer))
  (let ((buffers (cdr (buffer-list))))
    (while buffers
      (when (with-current-buffer (car buffers) (string= "term-mode" major-mode))
        (switch-to-buffer (car buffers))
        (setq buffers nil))
      (setq buffers (cdr buffers)))))

(global-set-key (kbd "C-c e <up>") 'emms-start)
(global-set-key (kbd "C-c e <down>") 'emms-stop)
(global-set-key (kbd "C-c e <right>") 'emms-next)
(global-set-key (kbd "C-c e <left>") 'emms-previous)
