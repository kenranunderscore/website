(ns kenranunderscore.app
  (:require [reacl-c.core :as c :include-macros true]
            [reacl-c.browser :as browser]
            [reacl-c.dom :as dom]))

(defn init
  []
  (println "Hello world"))

(c/def-dynamic main state
  (c/fragment (dom/div "foo")))

(browser/run (.getElementById js/document "root")
  main
  {})
