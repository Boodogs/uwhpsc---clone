
.. _project_hints:

Project Hints
-------------

Some hints on problems encountered in the :ref:`project`:

* The LAPACK routine `DGTSV` takes three vectors as input, `DL, D, DU`.
  If the matrix is symmetric then `DL` and `DU` will be filled with the same
  values when calling the routine, but it is **not** ok to just fill one array
  and pass it in as both `DL` and `DU`.  These storage locations are used in
  doing Gaussian elimination (with pivoting in the general) and if you read the
  documentation you will find that on return they are filled with different
  things.  If you pass in the same array location twice, it will not work.

  Note that this is a Fortran 77 style routine and does not use dynamic memory
  allocation, so the only arrays it has available to use for the elimination 
  process is what gets passed in.

* Also note that since  `DL, D, DU` are changed by a call to `DGTSV` (or `DPTSV`
  if you choose to use that), they no longer describe the matrix in a form that
  can be used in a second call to the routine.  So if you call this routine
  multiple times in your program, make sure it is using the matrix you think it is.

* The Makefiles provided in `$UWHPSC/labs/lab20` have a phony target `clobber` in
  addition to `clean`.  Doing  `make clobber`
  does the same as `make clean`  but also removes the `.txt` and `.html` files
  and the `_plots` directory with all the `png` files.  This is a common
  convention in Makefiles, that `make clean` removes things like object and 
  executable files generated when compiling the program but `make clobber` also
  removes data or figures produced by running the code.
