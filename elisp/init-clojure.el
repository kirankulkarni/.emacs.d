;;; init-clojure.el ---
;;
;; Filename: init-clojure.el
;; Description:
;; Author: Kiran Kulkarni
;; Maintainer:
;; Copyright (C) 2019 Kiran Kulkarni
;; Created: Wed Nov  6 12:19:25 2024 (+0530)
;; Version:
;; Package-Requires: ()
;; Last-Updated:
;;           By:
;;     Update #: 7
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(use-package clojure-mode
  :ensure t
  :init
  (defun pretty-fns ()
    (font-lock-add-keywords
     nil '(("(\\(fn\\)[\[[:space:]]"
            (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                      "ƒ")
                      nil))))))

  (defun pretty-reader-macros ()
    (font-lock-add-keywords
     nil '(("\\(#\\)("
            (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                      "λ")
                      nil))))))

  (defun pretty-sets ()
    (font-lock-add-keywords
     nil '(("\\(#\\){"
            (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                      "∈")
                      nil))))))

  :config
  ;; ;; Require additional font locking after clojure-mode loads
  ;; (require 'clojure-mode-extra-font-locking)

  ;; Set up indentation for various forms
  (dolist (form '(describe testing given using with it do-t))
    (put-clojure-indent form 'defun))

  ;; Add hooks using :hook keyword
  :hook ((clojure-mode . pretty-fns)
         (clojure-mode . pretty-reader-macros)
         (clojure-mode . pretty-sets)
         (clojure-mode . subword-mode)))


;; Configuration for cider-mode
(use-package cider
  :ensure t
  :init
  (defun cider-repl-prompt-on-newline (ns)
    "Return a prompt string with newline.
NS is the namespace information passed into the function by cider."
    (concat ns ">\n"))

  :custom
  (cider-repl-history-size most-positive-fixnum)
  (cider-repl-wrap-history t)
  (cider-repl-prompt-function 'cider-repl-prompt-on-newline)
  (cider-repl-use-pretty-printing nil)
  (nrepl-buffer-name-separator "-")
  (nrepl-buffer-name-show-port t)
  (nrepl-log-messages t)
  (cider-mode-line nil)
  (cider-annotate-completion-candidates t)
  (cider-completion-annotations-include-ns 'always)
  (cider-show-error-buffer 'always)
  (cider-prompt-for-symbol nil)
  (cider-auto-jump-to-error 'errors-only)
  (cider-apropos-actions
   '(("find-def" . cider--find-var)
     ("display-doc" . cider-doc-lookup)
     ("lookup-on-clojuredocs" . cider-clojuredocs-lookup)))

  :config
  ;; Enable eldoc-mode in cider-mode
  (add-hook 'cider-mode-hook 'eldoc-mode)

  :bind (:map cider-mode-map
              ("C-c z" . cider-selector)))


(use-package cider-repl
  :after cider
  :hook (cider-repl-mode . subword-mode)
  :bind (:map cider-repl-mode-map
              ("C-M-q" . prog-indent-sexp)
              ("C-c M-o" . cider-repl-clear-buffer)))

(provide 'init-clojure)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-clojure.el ends here
