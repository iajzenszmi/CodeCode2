program test
  integer, parameter  :: qp = selected_real_kind(p=30)
  real(qp)            :: a

  a = -2._qp

  print *, abs(a)
  print *, sqrt(-a)
end program
