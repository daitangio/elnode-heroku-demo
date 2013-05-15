;;; lisplet-engine.el --- Lisplet, servlet-like in elnode

;;; Commentary:
;; 


;; Scan lisplet/and mount them in a dynamic way.
;; See also http://nic.ferrier.me.uk/blog/2010_10/elnode
;; Manually defined lisplet:

;; (autoload 'hello-lisplet
;;        "hello-lisplet" "Small lisplet example" t)

(defun lisplet-init ()
  (setq app-routes 
	       '("^.*//\\(.*\\)" . elnode-webserver))
  ;; Now checks and load lisplet 
  (let ((default-directory (concat default-directory "../lisplet")))
    (message "%s" (pp-to-string (file-expand-wildcards "*.el")))
    ;; Scan files, load them and go
    )
  app-routes
)

(provide 'lisplet-engine)


(when (eq (car eval-buffer-list) (current-buffer))
  (progn
    (require 'ert)
    (ert-deftest lispletloader ()      
      (should (equal '("^.*//\\(.*\\)" . elnode-webserver)
		     (lisplet-init)))
      )

    (ert ".*lisplet.*" nil nil)
))

;;; lisplet-engine.el ends here
