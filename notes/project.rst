
.. _project:

==========================================
Final Project [2014]
==========================================

.. warning:: Incomplete, more to be added.

Due Wednesday, June 11, 2014, by 11:00pm PDT.

Some resources:

* The notebook `$UWHPSC/lab17/Tridiagonal.ipynb` has a discussion of 
  tridiagonal matrices in Python, and `$UWHPSC/lab17/tridiag.f90` contains a
  solution to the lab problem of solving a tridiagonal system in Fortran.
  See :ref:`lab17` for more links.


**Part 1**

The notebook `$UWHPSC/project/BVP.ipynb` illustrates
the solution of the two-point boundary value problem :math:`u''(x)
= -f(x)` by setting up and solving a tridiagonal system.  
This was discussed in :ref:`lab18`.
(`nbviewer
<http://nbviewer.ipython.org/url/faculty.washington.edu/rjl/notebooks/BVP.ipynb>`_, `video <https://canvas.uw.edu/courses/893991/wiki/lab-18>`_)

The goal of Part 1 is to create a Fortran 90 module that contains 
subroutines `solve_bvp_direct` and `solve_bvp_split` that mimic
the Python codes, and then add OpenMP to the latter in order to 
solve the four boundary value problems simultaneously with 4 threads.

You do **not** need to convert the recursive code to Fortran, although
if you want more of a challenge you might try to do this with OpenMP.

The directory `$UWHPSC/project/part1` contains the following files:

* `main1.f90` a driver program for the first part below.
* `problem.f90`, a module containing the problem description (right hand
  side function `f` and true solution function `u_true`).
* `bvp_solvers.f90`, the template for a module that should be filled in 
  properly with three subroutines following the directions below.
* `Makefile1` for the first part below.

Note that the problem specified in `problem.f90` is the same one used in the
IPython notebook and in Lecture 23.  You might want to test your routines
with a different problem, e.g. choose a different true solution and
differentiate twice to get the corresponding right hand side (and remember
to change the boundary conditions specified in the main program to be
suitable).  We might do the same to test your routines.

#.  Finish writing the subroutine `solve_BVP_direct`  in the module
    `bvp_solvers.f90`.  This routine should set up a
    tridiagonal system and solve it using the LAPACK subroutine `DGTSV`.
    As input it takes a 1-dimensional array `x`, and two real numbers
    `u_left` and `u_right` and the output should be an array `u` containing
    the approximate solution at the points specified in `x`.  It can be assumed
    that the points in `x` are equally spaced.

    **Notes:**

    * For consistency with the Python code, the arrays `x` and `u`
      have been declared to start with index 0 rather than 1.  Note how this
      is indicated in the declaration of these arrays in the subroutine
      `solve_bvp_direct`.
    
    * Instead of `DGTSV <http://www.netlib.no/netlib/lapack/double/dgtsv.f>`_,
      you could use 
      `DPTSV <http://www.netlib.no/netlib/lapack/double/dptsv.f>`_, 
      which solves a tridiagonal
      `symmetric positive definite
      <http://en.wikipedia.org/wiki/Positive-definite_matrix>`_ 
      system.  The matrix `A` for this boundary
      value problem is symmetric but is negative definite rather than
      positive definite, so if you want to do this you would have to negate
      the system and solve :math:`-u''(x) = f(x)`.  
      The `DPTSV` routine is slightly more efficient, but it's fine to
      use `DGTSV`.

    Add a print statement to your subroutine so that running the code
    produces output like this::

        $ make test -f Makefile1 
        Wrote data to input_data.txt
        ./test.exe
         n =           20
        Solving tridiagonal system with n =     20
         error_max =   3.99812551471256938E-003


        $ make test -f Makefile1 n=10000
        Wrote data to input_data.txt
        ./test.exe
         n =        10000
        Solving tridiagonal system with n =  10000
         error_max =   1.69490235180091986E-008

#.  Add another subroutine `solve_bvp_split` to the `bvp_solvers` module
    that has the same calling sequence and produces the same result, but  
    that splits the interval roughly in half and makes four calls to
    `solve_bvp_direct`, following the same idea as in the IPython notebook.

    Provide a second main program `main2.f90` and makefile `Makefile2` to
    test this routine.

    Add print statements to the subroutine so that it gives results similar
    to::

        $ make test -f Makefile2
        Wrote data to input_data.txt
        ./test.exe
         n =           20
        Solving tridiagonal system with n =     10
        Solving tridiagonal system with n =      9
        Solving tridiagonal system with n =     10
        Solving tridiagonal system with n =      9
        Computed G0 =   0.1186D+02  G1 =   0.1167D+02  z =  -0.6111D+02
         error_max =   3.99812551484757250E-003


        $ make test -f Makefile2 n=10000
        Wrote data to input_data.txt
        ./test.exe
         n =        10000
        Solving tridiagonal system with n =   5000
        Solving tridiagonal system with n =   4999
        Solving tridiagonal system with n =   5000
        Solving tridiagonal system with n =   4999
        Computed G0 =   0.2442D-01  G1 =   0.2402D-01  z =  -0.6004D+02
         error_max =   1.73004366388340713E-008

    Printing out `G0, G1`, and `z` might be useful for debugging to compare
    with what the Python code produces.

#.  Add another subroutine `solve_bvp_split_omp` to the `bvp_solvers` module
    that has the same calling sequence and produces the same result, but  
    that uses OpenMP in such a way that four different threads make the four
    calls to `solve_bvp_direct`.  

    Do this by using `omp parallel sections
    <https://computing.llnl.gov/tutorials/openMP/#SECTIONS>`_, see for example
    `$UWHPSC/codes/openmp/demo2.f90` or
    `$UWHPSC/codes/adaptive_quadrature/openmp2/adapquad_mod.f90`.

    This will take a bit of thought about what variables should be private
    to each thread and perhaps some rearrangement of the code to make
    sure each thread is solving the desired problem and all four results can
    be combined as needed.  To help debug, you might want to print out
    various things from the serial version of the code and compare to the
    parallel version, and try running with small values of `n`.

    You can call `omp_set_num_threads(4)` in the subroutine and do not
    need to test with a different number of threads.

    **Note:** This is not a great problem for OpenMP since solving a
    tridiagonal system is so quick, and the overhead of forking threads
    will probably make the OpenMP version run slower than the serial version
    unless `n` were very large, but the point is to understand and debug the
    code.

    Provide a new main program `main3.f90` and `Makefile3` that compiles
    with OpenMP and links with OpenMP and the LAPACK libraries, e.g. set:: 

        LFLAGS = -lblas -llapack -fopenmp
        FFLAGS = -fopenmp

    Add print statements to your subroutine so that it gives output such as::

        $ make test -f Makefile3
        test.exe
        Wrote data to input_data.txt
        ./test.exe
         n =           20
         nthreads =            4
        Thread   0 taking from   0.000 to   0.524 with u_mid =   0.000
        Solving tridiagonal system with n =     10
        Thread   1 taking from   0.524 to   1.000 with u_mid =   0.000
        Solving tridiagonal system with n =      9
        Thread   2 taking from   0.000 to   0.524 with u_mid =   1.000
        Solving tridiagonal system with n =     10
        Thread   3 taking from   0.524 to   1.000 with u_mid =   1.000
        Solving tridiagonal system with n =      9
        Computed G0 =   0.1186D+02  G1 =   0.1167D+02  z =  -0.6111D+02
         error_max =   3.99812551484757250E-003

        $ make test -f Makefile3 n=10000
        Wrote data to input_data.txt
        ./test.exe
         n =        10000
         nthreads =            4
        Thread   1 taking from   0.000 to   0.500 with u_mid =   0.000
        Solving tridiagonal system with n =   5000
        Thread   0 taking from   0.500 to   1.000 with u_mid =   0.000
        Solving tridiagonal system with n =   4999
        Thread   2 taking from   0.000 to   0.500 with u_mid =   1.000
        Solving tridiagonal system with n =   5000
        Thread   3 taking from   0.500 to   1.000 with u_mid =   1.000
        Solving tridiagonal system with n =   4999
        Computed G0 =   0.2442D-01  G1 =   0.2402D-01  z =  -0.6004D+02
         error_max =   1.73004366388340713E-008




             
To submit
---------

* At the end, you should have committed the following 
  files to your repository:

  **Part 1**

  * `$MYHPSC/project/part1/Makefile1`  (unchanged from original)
  * `$MYHPSC/project/part1/main1.f90`  (unchanged from original)
  * `$MYHPSC/project/part1/problem.f90`  (unchanged from original)
  * `$MYHPSC/project/part1/bvp_solvers.f90` (with 3 subroutines)
  * `$MYHPSC/project/part1/Makefile2`  
  * `$MYHPSC/project/part1/main2.f90` 
  * `$MYHPSC/project/part1/Makefile3`  
  * `$MYHPSC/project/part1/main3.f90` 

  **Part 2**

  * To appear.

  **Please be sure you have the specified directory and file names.**
  It is hard to grade otherwise, and points will be deducted.
  

  Make sure you push to bitbucket after committing.

* Submit the commit number that you want graded by following the link
  provided on the `Canvas page for the project
  <https://canvas.uw.edu/courses/893991/assignments/2520179>`_.

* There will also be a survey (to appear) worth 10 points.

