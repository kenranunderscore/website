(require 'ox-publish)
(require 'f)

;; If the file is loaded via emacs -l, `load-file-name' is set to its
;; file path.  Otherwise we assume we're running interactively from
;; within Emacs, where we can use `default-directory' (otherwise that
;; points to the directory where emacs is executed from).
(setq base-dir
      (if load-file-name
          (file-name-directory load-file-name)
        default-directory))
(setq publish-dir (concat base-dir "html/"))

;; NOTE: For now I assume that I'm publishing interactively from
;; within my Emacs, with my personal configuration loaded.  I'd
;; otherwise have to set some more customization options here, as well
;; as load a couple of packages (htmlize, for instance).

(setq org-publish-project-alist
      (list
       (list
        "top-level-pages"
        :base-directory base-dir
        :base-extension "org"
        :exclude "README.org"
        :publishing-directory publish-dir
        :with-toc nil
        :section-numbers nil
        :html-doctype "html5"
        :html-html5-fancy t
        :html-head-include-default-style nil)
       (list
        "blog-entries"
        :base-directory (concat base-dir "blog/")
        :base-extension "org"
        :recursive t
        :publishing-directory (concat publish-dir "blog/")
        :with-date t
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
        :html-preamble (f-read-text "assets/nav.html"))
       (list
        "static"
        :base-directory (concat base-dir "assets/")
        :base-extension "css\\|text\\|jpg\\|png"
        :recursive t
        :publishing-directory publish-dir
        :publishing-function 'org-publish-attachment)
       (list
        "final-website"
        :components '("top-level-pages" "blog-entries" "static"))))
