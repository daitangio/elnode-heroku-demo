;; -*- lexical-binding: t -*-
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")))
(message "package archives configured added")

(package-initialize)
(message "packages initialized")


(setq
 elnode-init-port
 (string-to-number (or (getenv "PORT") "8080")))
(setq elnode-init-host "0.0.0.0")
(setq elnode-do-init nil)
(message "elnode init done")

;; TODO Put here your preferred elnode version
(if (package-installed-p 'elnode '(0 9 9 6 9))
    (message "ELNODE Already installed OK") 
  (package-refresh-contents)
  (message "packages refreshed")
  (package-install 'elnode)
  (message "elnode installed")
)

(defun handler (httpcon)
  "Demonstration function"
  (elnode-http-start httpcon "200"
                     '("Content-type" . "text/html")
                     `("Server" . ,(concat "GNU Emacs " emacs-version)))
  (elnode-http-return httpcon
                      "<html><body><h1>Hello from EEEMACS.</h1></body></html>"))

;;(elnode-start 'handler :port elnode-init-port :host elnode-init-host)
(elnode-init)

(while t
  (accept-process-output nil 1))

;; End
