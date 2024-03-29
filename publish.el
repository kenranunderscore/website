(package-initialize)

;; Output CSS classes for syntax highlighting instead of inline CSS by
;; default.
(require 'htmlize)
(setq org-html-htmlize-output-type 'css)

(require 'ox-publish)
(setq org-html-validation-link nil)

;; If the file is loaded via emacs -l, `load-file-name' is set to its
;; file path.  Otherwise we assume we're running interactively from
;; within Emacs, where we can use `default-directory' (otherwise that
;; points to the directory where emacs is executed from).
(setq base-dir
      (if load-file-name
          (file-name-directory load-file-name)
        default-directory))
(setq publish-dir (concat base-dir "html/"))

(require 'f)

;; The final website consists of some special top-level pages,
;; "generic" blog entries, and stuff that is served statically.
(setq org-publish-project-alist
      (let ((postamble (f-read-text "assets/postamble.html")))
        (list
         (list
          "top-level-pages"
          :base-directory base-dir
          :base-extension "org"
          :exclude "README.org"
          :publishing-directory publish-dir
          :publishing-function 'org-html-publish-to-html
          :with-toc nil
          :section-numbers nil
          :html-doctype "html5"
          :html-html5-fancy t
          :html-head-include-default-style nil
          :htmlized-source t
          :html-preamble nil
          :html-postamble postamble)
         (list
          "emacs-config"
          :base-directory (concat base-dir "emacs-config/")
          :base-extension "org"
          :recursive t
          :publishing-directory (concat publish-dir "emacs-config/")
          :publishing-function 'org-html-publish-to-html
          :with-title t
          :with-toc t
          :html-doctype "html5"
          :html-html5-fancy t
          :html-head-include-default-style nil
          :html-head-include-scripts nil
          :html-preamble (f-read-text "assets/nav.html")
          :htmlized-source t
          :html-postamble postamble)
         (list
          "blog-entries"
          :base-directory (concat base-dir "blog/")
          :base-extension "org"
          :recursive t
          :publishing-directory (concat publish-dir "blog/")
          :publishing-function 'org-html-publish-to-html
          :with-date t
          :with-author nil
          :with-title t
          :with-toc nil
          :auto-sitemap t
          :sitemap-filename "all-entries.org"
          :sitemap-sort-files 'anti-chronologically
          :sitemap-title nil
          :html-doctype "html5"
          :html-html5-fancy t
          :html-head-include-default-style nil
          :html-head-include-scripts nil
          :html-preamble (f-read-text "assets/nav.html")
          :html-postamble postamble
          :htmlized-source t)
         (list
          "static"
          :base-directory (concat base-dir "assets/")
          :base-extension "css\\|text\\|jpg\\|png"
          :recursive t
          :publishing-directory publish-dir
          :publishing-function 'org-publish-attachment)
         (list
          "final-website"
          :components '("top-level-pages" "emacs-config" "blog-entries" "static")))))

;; Publish all projects, and force (re)creation of HTML.
(org-publish-all t)
