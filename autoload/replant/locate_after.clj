(some identity
  (for [potential-dev-ns ['dev 'user 'boot.user]
        potential-fn ['go 'start]]
    (do
      (try (require potential-dev-ns)
           (catch Exception _))
      (some-> (find-ns potential-dev-ns)
              (ns-resolve potential-fn)
              (str)
              (->> (re-matches #"#'(.*)")
                   (second))
              symbol))))
