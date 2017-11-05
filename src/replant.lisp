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
      (nvim/nvim_call_function* "fnamemodify" file ":." )
      file-with-protocol)))

(defun info-file->vim-file
  (file)
  (cond
    [(= nil file) 0]

    [(string/match file "^file:(.*)")
     (nvim/nvim_call_function* "fnamemodify" (string/match file "^file:(.*)") ":.")]

    [(string/match file "^jar:file:(.*)")
     (string/gsub file "^jar:file:(.*)!/(.*)" "zipfile:%1::%2")]

    [else 0]))

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
       (nvim/nvim_command (.. "split " ,name))
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
       (nvim/nvim_command "%delete _")
       ,@body
       (set-local-opt (list "modifiable" false)))))

(defun buffer-echo (msg)
  (with [line (- (nvim/nvim_call_function* "line" "$") 1)]
    (nvim/nvim_call_function* "append" line msg)))

(defun buffer-emit (msg hl-group)
  (with [line (- (nvim/nvim_call_function* "line" "$") 1)]
    (nvim/nvim_call_function* "append" line msg)
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
      (nvim/nvim_command "resize 20")
      (emit (if class java-name clj-name)
            (cond
              [macro "Macro"]
              [special "Special"]
              [args "Function"]
              [class "StorageClass"]
              [(and ns name) "Macro"]
              [else "Error"]))
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
          (echo ($ " ${form}"))))

      (when special
        (echo "Special Form"))
      (when macro
        (echo "Macro"))
      (when added
        (emit ($ "Added in ${added}") "Comment"))
      (when depr
        (emit ($ "Deprecated in ${depr}") "Error"))

      (let [(ndoc (list->struct (string/split ($ "  ${doc}") "\n")))]
        (echo ndoc))
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

      ;; Commented out in favour of a mapping in the buffer
      ; (let [(name (if class java-name clj-name))
      ;       (j-file (info-file->vim-file file))]
      ;   (emit ($ "Jump to ${j-file}") "Comment"))

      (with [amicrazy (info-file->vim-file file)]
        ;; some bug causes this not to work if the function call is in-line, so
        ;; I create a var… I might start drinking.
        (nvim/nvim_buf_set_var (nvim/nvim_get_current_buf) "replant_jump_file" amicrazy))
      (nvim/nvim_buf_set_var (nvim/nvim_get_current_buf) "replant_jump_line" (.> info "line"))
      (nvim/nvim_buf_set_var (nvim/nvim_get_current_buf) "replant_jump_column" (.> info "column"))

      (when see-also
        (echo
          (list->struct
            (list
              ""
              (.. "Also see: " (string/concat see-also " "))))))

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
 :buffer_emit buffer-emit
 :buffer_doc doc-buffer}
