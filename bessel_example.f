program bessel_example
  implicit none
  real :: x, result, nu,ans,an
!  external besj
  x = 0.5
  nu = 0.25
  result = besj11(x, nu)
  print *, 'Result = ', result

 contains
    function besj11(x, nu)
    implicit none
    real, intent(in) :: x, nu
    real ::  y, xx, yy, an, ans, besj11
    integer :: n
    y = x
    if (y < 0.0) y = -y
    if (y < 8.0) then
      xx = y * y
      ans = (-0.78539816339744830962e0 + xx * (0.24425791298490536243e-2 &
     + xx * (-0.12714303849074419195e-3 + xx * (0.79068343905355159726e-5 & 
     + xx * (-0.58698992615997543648e-6 + xx * (0.51196498083350582399e-7 &
     + xx * (-0.48450589915113850805e-8 + xx * 0.50047305076637952576e-9)))))))
      ans = ans + log(y) * (1.0 + xx * (0.43784888935372444303e-2 &
     + xx * (0.28247599709037641206e-4 + xx * (0.22131884008630972210e-6 &
     + xx * (0.17640789565767294347e-8 + xx * 0.14777819605723681441e-10)))))  
     
      besj11 = ans
    else
      xx = 8.0 / y
      yy = y - 2.356194491
      an = 1.0 + xx * (0.183105e-2 + xx * (-0.3516396496e-4 + xx * (0.2457520174e-5 &
     + xx * (-0.240337019e-6 + xx * (0.28533415e-7 + xx * (-0.39019017e-8 + xx * 0.6116095e-9))))))
      besj11 = sqrt(0.636619772e0 / y) * (cos(yy) * an - 0.5e0 * sin(yy) * (xx * (0.105787412e-3 &
     + xx * (-0.88228987e-5 +  xx * (0.8449199096e-6 + xx * (-0.8724859e-7 + xx * (0.988116e-8 + xx * &
             (-0.133733e-8 + xx * 0.2044e-9))))))))
    end if 
  end function besj11

end program bessel_example
