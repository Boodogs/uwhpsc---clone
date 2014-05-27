
program tridiag

    implicit none
    integer, parameter :: n = 5
    integer :: nrhs,ldb,info,i
    real(kind=8) :: dl(n-1), du(n-1), d(n),  b(n,1)

    do i=1,n
        d(i) = float(i)
        enddo

    do i=1,n-1
        dl(i) = 10.d0*i
        du(i) = 100.d0*(i+1)
        enddo

    b = reshape((/201.d0, 312.d0, 423.d0, 534.d0, 45.d0 /), (/5,1/))

    ! or it also works if you declare b(n) to be 1-dimensional, and then use:
    ! b = (/201.d0, 312.d0, 423.d0, 534.d0, 45.d0 /)

    call dgtsv(n, nrhs, dl, d, du, b, ldb, info)

    ! on return, b is the solution:
    print *, 'x = ', b

end program tridiag
