;;; init-benchmarking.el --- Module to benchmark emacs initialization steps
;;; Commentary:
;;;  Benchmark time consumed by each 'require' call
;;;  This benchmark is stored in the 'myconfig/require-times' variable
;;; Code:

(defun myconfig/time-substract-millis (b a)
  "Internal function to get time ellapsed between B and A in milliseconds."
  (* 1000.0 (float-time (time-subtract b a))))

(defvar myconfig/require-times nil
  "A list of (FEATURE . LOAD-DURATION).
LOAD-DURATION is the time taken in milliseconds to load FEATURE.")

(defadvice require
    (around build-require-times (feature &optional filename noerror) activate)
  "Note in `myconfig/require-times' the time tale to require each feature."
  (let* ((already-loaded (memq feature features))
         (require-start-time (and (not already-loaded) (current-time))))
    (prog1
        ad-do-it
      (when (and (not already-loaded) (memq feature features))
        (add-to-list 'myconfig/require-times
                     (cons feature
                           (myconfig/time-substract-millis (current-time)
                                                          require-start-time))
                     t)))))

(provide 'init-benchmarking)
;;; init-benchmarking ends here
