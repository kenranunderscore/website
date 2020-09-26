(ns kenranunderscore.app
  (:require [reacl-c.core :as c :include-macros true]
            [reacl-c.browser :as browser]
            [active.clojure.functions :as f]
            [active.clojure.lens :as lens]
            [reacl-c.dom :as dom]))

(def indices (range 9))

(defrecord Row [index cells])

(defrecord Cell [column state])

(defn make-row
  [i]
  (->> indices
       (map (fn [j] (->Cell j {})))
       (->Row i)))

(def initial-sudoku-state
  (map make-row indices))

(c/def-item cell
  (c/with-state-as state
    (print (pr-str state))
    (dom/td (str (:state state)))))

(c/def-item sudoku
  (c/with-state-as state
    (c/fragment
     (apply dom/table
            (map (fn [i]
                   (apply dom/tr
                          (map (fn [j]
                                 (c/focus (lens/>> (lens/at-index i)
                                                   :cells
                                                   (lens/at-index j))
                                          cell))
                               indices)))
                 indices)))))

(browser/run (.getElementById js/document "root")
  sudoku
  initial-sudoku-state)
