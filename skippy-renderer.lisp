;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SKIPPY/RENDERER
;;;; © Michał "phoe" Herda 2017
;;;; skippy-renderer.lisp

(defpackage #:skippy-renderer
  (:use #:cl #:skippy)
  (:export #:render))

(in-package :skippy-renderer)

;;; TODO implement "Restore to Previous"

(defun render (data-stream &key (byte-order :argb))
  "Given a GIF data stream, returns a rendered image.
\
The BYTE-ORDER keyword argument is one of :ARGB or :BGRA. It states the order
of bytes in the resulting vectors.
\
Three values are returned.
The first value is a list of vectors containing resulting ARGB data in
row-first order and each second element
The second value is a list of integer values for the frame delays in
milliseconds.
The third value is a list of three values: image width, image height and a
generalized boolean signifying if the GIF should loop."
  (check-type byte-order (member :argb :bgra))
  (loop with color-table = (color-table data-stream)
        with loopingp = (loopingp data-stream)
        with width = (width data-stream)
        with height = (height data-stream)
        with frame = (make-array (* 4 width height)
                                 :element-type '(unsigned-byte 8)
                                 :initial-element 0)
        for image across (images data-stream)
        for delay-time = (delay-time image)
        do (render-image-to-frame frame width image color-table
                                  :byte-order byte-order)
        collect (copy-seq frame) into result
        collect delay-time into delays
        finally (return (values result
                                delays
                                (list width height loopingp)))))

(defun render-image-to-frame (frame frame-width image color-table
                              &key byte-order)
  (let ((disposal-method (disposal-method image)))
    (case disposal-method
      (:restore-background (loop for i below (array-dimension frame 0)
                                 do (setf (aref frame i) 0)))
      (:restore-previous (error "Not implemented yet." #| TODO |#))))
  (loop with fn = (ecase byte-order
                    (:argb #'index-argb)
                    (:bgra #'index-bgra))
        with color-table = (or (color-table image) color-table)
        with t-index = (transparency-index image)
        with width = (width image)
        with height = (height image)
        with top = (top-position image)
        with left = (left-position image)
        with data = (image-data image)
        for y from 0 below height
        do (loop for x from 0 below width
                 for index = (elt data (+ x (* y width)))
                 for value = (funcall fn color-table index t-index)
                 for offset = (* 4 (+ left x (* frame-width (+ top y))))
                 unless (ecase byte-order
                          (:argb (= (first value) 0))
                          (:bgra (= (fourth value) 0)))
                   do (setf (subseq frame offset) value))))

(defun index-argb (color-table index transparency-index)
  (if (eql index transparency-index)
      (list 0 0 0 0)
      (cons 255 (multiple-value-list
                 (color-rgb (color-table-entry color-table index))))))

(defun index-bgra (color-table index transparency-index)
  (if (eql index transparency-index)
      (list 0 0 0 0)
      (append (reverse (multiple-value-list
                        (color-rgb (color-table-entry color-table index))))
              '(255))))
