;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SKIPPY/RENDERER
;;;; © Michał "phoe" Herda 2017
;;;; skippy-renderer.asd

(asdf:defsystem #:skippy-renderer
  :description "GIF renderer for SKIPPY"
  :author "Michał \"phoe\" Herda"
  :license "MIT"
  :depends-on (#:skippy)
  :serial t
  :components ((:file "skippy-renderer")))
