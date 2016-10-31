;;; github-pullrequest.el --- Create and fetch Github Pull requests with ease  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Jakob Lind

;; Author: Jakob Lind <karl.jakob.lind@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'request)

(defun github-pullrequest-name-from-branch (branchname)
  "Create a human readable name from BRANCHNAME."
  (replace-regexp-in-string "-" " " branchname))

(defun github-pullrequest-api-new (access-token)
  "Create a Github Pull Request using the current branch as head and master branch as base and ACCESS-TOKEN."
  (request (concat (github-pullrequest-get-repo-api-base) (concat "pulls?access_token=" access-token))
           :type "POST"
           :headers '(("Content-Type" . "application/json"))
           :data  (json-encode
                   (list (cons "title" . (github-pullrequest-name-from-branch (magit-get-current-branch)))
                         (cons "head" (magit-get-current-branch))
                         '("base" . "master")))
           :parser 'json-read
           :error (cl-function (lambda (&rest args &key response data error-thrown &allow-other-keys)
                                 (message "Error creating pull request: %S"
                                        ;(alist-get 'message (elt (assoc-default 'errors (request-response-data response)) 0))
                                          (request-response-data response))))
           :success (cl-function (lambda (&key data response &allow-other-keys) (message "A Pull request was created! %S" (assoc-default 'html_url (request-response-data response)))))))

(defun github-pullrequest-get-repo-api-base ()
  "Get the base API URL of the current repository from magit."
  (concat "https://api.github.com/repos" (replace-regexp-in-string "^https?://github.com" "" (replace-regexp-in-string ".git$" "" (magit-get "remote" "origin" "url"))) "/"))

(defun github-pullrequest-get-access-token ()
  "Fetch the users Github access token, either from input or the current repos git config."
  (let ((token (replace-regexp-in-string "\n" "" (github-pullrequest-run-command "config" "--get" "github.token"))))
    (if (string= token "")
        (let ((new-token (read-from-minibuffer "Github access-token: ")))
          (github-pullrequest-run-command "config" "--add" "github.token" new-token)
          new-token)
      token)))

(defun github-pullrequest-run-command (&rest args)
  "Run a git command defined in ARGS."
  (let ((git (executable-find "git")))
    (with-output-to-string
      (apply 'process-file git nil standard-output nil args))))

(defun github-pullrequest-is-validate-state ()
  "Return t if we are in a valid state to create a PR, return nil otherwise."
  (cond ((string= (magit-get-current-branch) "master")
         (message "You are on master, you can't create a pull request from here") nil)
        ((eq (magit-get-upstream-branch) nil)
         (message "You have not defined an upstream for current branch") nil)
        (t t)))

(defun github-pullrequest-new ()
  "Create a new pull request."
  (interactive)
  (when (github-pullrequest-is-validate-state)
    (let ((accesstoken (github-pullrequest-get-access-token)))
      (github-pullrequest-api-new accesstoken))))

(provide 'github-pullrequest)
;;; github-pullrequest.el ends here
