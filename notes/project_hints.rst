
.. _project_hints:

Project Hints
-------------

Some hints on problems encountered in the :ref:`project`:

* See :ref:`homework3_solution` and :ref:`homework4_solution` for some 
  pointers based on common errors on the these homeworks.

* The notebook `$UWHPSC/labs/lab17/Tridiagonal.ipynb` has a discussion of 
  tridiagonal matrices in Python, and `$UWHPSC/labs/lab17/tridiag.f90` contains a
  solution to the lab problem of solving a tridiagonal system in Fortran.
  See :ref:`lab17` for more links.

* You may have to install JSAnimation on your SMC project, see
  :ref:`animation`.

* For hints on viewing an html file created on SMC, see
  :ref:`smc_view_html`. 

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

* In the Python notebook for the implicit heat equation solver, 
  sparse matrix notation is used to define the sparse identity matrix
  and the matrices :math:`A = I - \frac{\Delta t}{2} D_2` and
  :math:`B = I + \frac{\Delta t}{2} D_2` then `rhs = B*i[1:-1]` uses
  the fact that if `B` is a sparse matrix then this does the matrix-vector
  product efficiently.  In Fortran there's no easy way to do all this with
  sparse matrices, and the intention was to instead just fill things with 
  loops.  In particular, the arrays that are passed in to the tridiagonal
  solver are for the 3 diagonals and you will want to figure out what the
  correct values to put in these are from the finite difference equations,
  
  :math:`U_i^{N+1} = U_i^N +  \frac{\Delta t}{\Delta x^2} [(U_{i-1}^N -
  2U_i^N + U_{i+1}^N) + (U_{i-1}^{N+1} - 2U_i^{N+1} + U_{i+1}^{N+1})].`

  Recall that :math:`U_j^N` is known for all values of :math:`j`, 
  so all these terms go on the Right Hand Side, while the :math:`U_j^{N+1}` 
  terms all go on the left hand side and define the tridiagonal linear system 
  to be solved.  

* Don't forget to use constants like `2.d0` in  Fortran rather than just `2`
  in order to insure that double precision is used.

* In Part 2, to generate and print the solution at each time step that
  go into the file `frames.txt`, note that you can call
  `solve_heat_explicit` or `solve_heat_implicit` repeatedly to take a single
  time step each time, with the input being :math:`U^N` and the output being
  :math:`U^{N+1}`.  Make sure the input parameters you pass into the
  function are all the appropriate things for taking a single step from 
  time :math:`t_N` to time :math:`t_{N+1}` and that the `u` array that is
  returned from the routine in one step is the input for the next step.

