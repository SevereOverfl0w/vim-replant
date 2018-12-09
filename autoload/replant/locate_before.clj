(do
  (clojure.core/create-ns 'replant.locate)
  (clojure.core/in-ns 'replant.locate)

  (some identity
        (for [potential-dev-ns ['user 'dev 'boot.user]
              potential-fn ['stop 'halt]]
          (do
            (try (require potential-dev-ns)
                 (catch Exception _))
            (some-> (find-ns potential-dev-ns)
                    (ns-resolve potential-fn)
                    (str)
                    (->> (re-matches #"#'(.*)")
                         (second))
                    symbol)))))
