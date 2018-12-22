(do
  (clojure.core/create-ns 'replant.locate)
  (clojure.core/in-ns 'replant.locate)
  (clojure.core/require '[clojure.core :refer :all])

  (some identity
        (for [potential-dev-ns ['dev 'user 'boot.user]
              potential-fn ['resume 'go 'start]]
          (do
            (try (require potential-dev-ns)
                 (catch Exception _))
            (some-> (find-ns potential-dev-ns)
                    (ns-resolve potential-fn)
                    (str)
                    (->> (re-matches #"#'(.*)")
                         (second))
                    symbol)))))
