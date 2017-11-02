(import nvim nvim)
(import compiler/resolve resolve)
(import lua/string string)

(define output {})

(defmacro with-hl-group (hl-group &body)
  `(progn
     ;; TODO: fix gensym here
     (nvim/nvim_command (.. "echohl " ,hl-group))
     ,@body
     (nvim/nvim_command "echohl Normal")))

(defun echo (msg)
  (nvim/nvim_command ($ "echo \"${msg}\"")))

(defun emit (msg hl-group)
  (with-hl-group hl-group
    (echo msg)))

(defun struct->list* (s)
  (if s
    (struct->list s)
    s))

(defun cider--abbreviate-file-protocol (file-with-protocol)
  "Abbreviate the file-path in `file:/path/to/file' of FILE-WITH-PROTOCOL."
  (with (file (string/match file-with-protocol "^file:(.*)"))
    (if file
      (nvim/nvim_call_function "fnamemodify" [file ":."])
      file-with-protocol)))

(defun set-local-opt (opt*)
  (nvim/nvim_command
    (.. "setlocal "
        (destructuring-bind [(?opt ?val) opt*]
          (if (boolean? val)
            (let [(no (if (not val) "no" ""))]
              ($ "${no}${opt}"))
            ($ "${opt}=${val}"))))))

(defmacro create-immutable-buffer (name  &body)
  (let [(options (gensym))
        (opt* (gensym))]
    `(progn
       (nvim/nvim_command (.. "vsplit " ,name))
       (let [(,options (list
                         (list "bufhidden" "hide")
                         (list "buflisted" false)
                         (list "buftype" "nofile")
                         (list "foldcolumn" "0")
                         (list "foldenable" false)
                         (list "number" false)
                         (list "swapfile" false)
                         (list "modifiable" true)))]
         (dolist [(,opt* ,options)]
           (set-local-opt ,opt*)))
       ,@body
       (set-local-opt (list "modifiable" false)))))

(defun list->struct
  (x)
  (when (list? x)
    (.<! x :n nil)
    (.<! x :tag nil))
  x)

(defun do-stuff (str)
  (create-immutable-buffer
    "foobar"
    (nvim/nvim_call_function* "setline"
                              (nvim/nvim_call_function* "line" "$")
                              (list->struct (list "# THE END")))
    (nvim/nvim_call_function* "append"
                              (nvim/nvim_call_function* "line" "$")
                              (list->struct (list "# j/k")))
    (nvim/nvim_call_function* "append"
                              (nvim/nvim_call_function* "line" "$")
                              (list->struct (list "# j/k2")))))

(defun do-athing ()
  (list->struct (list 1 2 3)))

(defun buffer-echo (msg)
  (with [line (nvim/nvim_call_function* "line" "$")]
    (nvim/nvim_call_function* "append"
                              (nvim/nvim_call_function* "line" "$")
                              msg)))

(defun buffer-emit (msg hl-group)
  (with [line (nvim/nvim_call_function* "line" "$")]
    (nvim/nvim_call_function* "append"
                              (nvim/nvim_call_function* "line" "$")
                              msg)
    (nvim/nvim_buf_add_highlight
      (nvim/nvim_get_current_buf)
      -1
      hl-group
      line
      0
      (string/len msg))))

(defun doc-buffer (info)
  (let* [(emit buffer-emit)
         (echo buffer-echo)
         (ns      (.> info "ns"))
         (name    (.> info "name"))
         (added   (.> info "added"))
         (depr    (.> info "deprecated"))
         (macro   (.> info "macro"))
         (special (.> info "special-form"))
         (file    (.> info "file"))
         (forms   (when-with [str (.> info "forms-str")]
                             (string/split str "\n")))
         (args    (when-with [str (.> info "arglists-str")]
                             (string/split str "\n")))
         (doc     (or (.> info "doc") "Not documented."))
         (url     (.> info "url"))
         (class   (.> info "class"))
         (member  (.> info "member"))
         (javadoc (.> info "javadoc"))
         (super   (.> info "super"))
         (ifaces  (.> info "interfaces"))
         (spec    (struct->list* (.> info "spec")))
         (clj-name  (if ns ($ "${ns}/${name}") name))
         (java-name (if member (concat class "/" member) class))
         (see-also (struct->list* (.> info "see-also")))]
    (create-immutable-buffer (.. (or (if class java-name clj-name) "niledout") ".replantdoc")

      (emit (if class java-name clj-name) "Error")
      (when super
        (echo ($ "   Extends: ${super}")))
      (when ifaces
        (echo ($ "Implements: ~{(car ifaces)}"))
        (do [(iface (cdr ifaces))]
          (echo ($ "            ${iface}"))))
      (when (or super ifaces)
        (echo "\n"))

      (when-with [forms (or forms args)]
                 (do [(form forms)]
                   (emit ($ " ${form}") "Error")))

      (when special
        (emit "Special Form" "Error"))
      (when macro
        (emit "Macro" "Error"))
      (when added
        (emit ($ "Added in ${added}") "Comment"))
      (when depr
        (emit ($ "Deprecated in ${depr}") "Error"))

      (echo ($ "  ${doc}"))
      (when-with (url (or url javadoc))
                 (echo ($ "\nPlease see ${url}")))

      (when (and spec (.> spec 1)) ;; (when (seq spec)) in clojure
        (echo "\nSpec: ")
        (do [(s spec)]
          (echo ($ "${s}\n"))))

      ; (if cider-docview-file
      ;   (progn
      ;     (insert (propertize (if class java-name clj-name)
      ;                         'font-lock-face 'font-lock-function-name-face)
      ;             " is defined in ")
      ;     (insert-text-button (cider--abbreviate-file-protocol cider-docview-file)
      ;                         'follow-link t
      ;                         'action (lambda (_x)
      ;                                   (cider-docview-source)))
      ;     (insert "."))
      ;   (insert "Definition location unavailable."))

      (let [(name (if class java-name clj-name))
            (c-file (cider--abbreviate-file-protocol file))]
        (emit ($ "${name} is defined in ${c-file}") "Comment"))

      (when see-also
        (echo (.. "\nAlso see: " (string/concat see-also " "))))

      ; (cider--doc-make-xrefs)
      ; (let ((beg (point-min))
      ;       (end (point-max)))
      ;   (nrepl-dict-map (lambda (k v)
      ;                     (put-text-property beg end k v))
      ;                   info))
      )))

(defun doc (info)
  (let* [(ns      (.> info "ns"))
         (name    (.> info "name"))
         (added   (.> info "added"))
         (depr    (.> info "deprecated"))
         (macro   (.> info "macro"))
         (special (.> info "special-form"))
         (file    (.> info "file"))
         (forms   (when-with [str (.> info "forms-str")]
                    (string/split str "\n")))
         (args    (when-with [str (.> info "arglists-str")]
                    (string/split str "\n")))
         (doc     (or (.> info "doc") "Not documented."))
         (url     (.> info "url"))
         (class   (.> info "class"))
         (member  (.> info "member"))
         (javadoc (.> info "javadoc"))
         (super   (.> info "super"))
         (ifaces  (.> info "interfaces"))
         (spec    (struct->list* (.> info "spec")))
         (clj-name  (if ns ($ "${ns}/${name}") name))
         (java-name (if member (concat class "/" member) class))
         (see-also (struct->list* (.> info "see-also")))]
    (emit (if class java-name clj-name) "Error")
    (when super
      (echo ($ "   Extends: ${super}")))
    (when ifaces
      (echo ($ "Implements: ~{(car ifaces)}"))
      (do [(iface (cdr ifaces))]
        (echo ($ "            ${iface}"))))
    (when (or super ifaces)
      (echo "\n"))

    (when-with [forms (or forms args)]
              (do [(form forms)]
                (emit ($ " ${form}") "Error")))

    (when special
      (emit "Special Form" "Error"))
    (when macro
      (emit "Macro" "Error"))
    (when added
      (emit ($ "Added in ${added}") "Comment"))
    (when depr
      (emit ($ "Deprecated in ${depr}") "Error"))

    (echo ($ "  ${doc}"))
    (when-with (url (or url javadoc))
      (echo ($ "\nPlease see ${url}")))

    (when (and spec (.> spec 1)) ;; (when (seq spec)) in clojure
      (echo "\nSpec: ")
      (do [(s spec)]
        (echo ($ "${s}\n"))))

    ; (if cider-docview-file
    ;   (progn
    ;     (insert (propertize (if class java-name clj-name)
    ;                         'font-lock-face 'font-lock-function-name-face)
    ;             " is defined in ")
    ;     (insert-text-button (cider--abbreviate-file-protocol cider-docview-file)
    ;                         'follow-link t
    ;                         'action (lambda (_x)
    ;                                   (cider-docview-source)))
    ;     (insert "."))
    ;   (insert "Definition location unavailable."))

    (let [(name (if class java-name clj-name))
          (c-file (cider--abbreviate-file-protocol file))]
      (emit ($ "${name} is defined in ${c-file}") "Comment"))

    (when see-also
      (echo (.. "\nAlso see: " (string/concat see-also " "))))

    ; (cider--doc-make-xrefs)
    ; (let ((beg (point-min))
    ;       (end (point-max)))
    ;   (nrepl-dict-map (lambda (k v)
    ;                     (put-text-property beg end k v))
    ;                   info))
    ))

{:doc doc
 :do_stuff do-stuff
 :do_athing do-athing
 :buffer_emit buffer-emit
 :buffer_doc doc-buffer}
