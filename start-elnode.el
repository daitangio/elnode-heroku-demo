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

(defconst DocRoot
  (concat default-directory "./public_html"))

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

                      

(defun heartbeat (httpcon)
  "Heart Beat Function: exposes environment too"
  (elnode-http-start httpcon "200"
                     '("Content-type" . "text/html")
		     '("X-Framework"  . "DaitanElnodeV1")
                     `("Server" . ,(concat "GNU Emacs " emacs-version)))
  (elnode-http-return httpcon
		      (concat "<html><body><h1>Hello from ElNode.</h1>"
			      "<p>Env as seen by Emacs:</p><hr /><br/>"
			      "<ul>"
			      ;; Not sure in-place sorting is a GoodThing(TM) 
			      (mapconcat  (lambda (x) (concat "<li>" x)) process-environment  "\n")
			      "</ul>"
			      "<br />"
			      "</body></html>")))


;; Customize elnode-webserver-docroot
(require  'elnode)
(custom-set-variables
  '(elnode-webserver-docroot DocRoot)
)

(defvar
   eldos-app-routes
   '(
     (".*//heartbeat\\(.*\\)" . heartbeat)
     ;; ("/$" . (elnode-webserver-handler-maker DocRoot))
     ))

;; Force byte compilation of lisp directory to be in sync
(byte-recompile-directory  (concat default-directory "./lisp") 0 t)
(byte-recompile-directory  (concat default-directory "./lisplet") 0 t)
(add-to-list 'load-path (concat default-directory "./lisp"))
;; Manually init lisplet engine: it will recursive init 
;; "lisplet" 
(load "lisplet-engine")
(add-to-list 'eldos-app-routes (lisplet-init))



(defun root-handler (httpcon)
	  (elnode-hostpath-dispatcher httpcon eldos-app-routes))	

(elnode-start 'root-handler :port elnode-init-port :host elnode-init-host)
;;(elnode-start 'handler :port elnode-init-port :host elnode-init-host)
;;(elnode-init)
(message "Elnode Ready. DocRoot:%s" elnode-webserver-docroot )
(while t
  (accept-process-output nil 1))

;; End
