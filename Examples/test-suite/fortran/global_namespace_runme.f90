! File : global_namespace_runme.f90

program global_namespace_runme
  use global_namespace
  use ISO_C_BINDING
  implicit none
  type(Klass1) :: k1
  type(Klass2) :: k2
  type(Klass3) :: k3
  type(Klass4) :: k4
  type(Klass5) :: k5
  type(Klass6) :: k6
  type(Klass7) :: k7
  type(KlassMethods) :: km
  type(XYZ1) :: x1
  type(XYZ2) :: x2
  type(XYZ3) :: x3
  type(XYZ4) :: x4
  type(XYZ5) :: x5
  type(XYZ6) :: x6
  type(XYZ7) :: x7
  type(XYZMethods) :: xyzm
  type(TheEnumMethods) :: tem

  k1 = create_Klass1()
  k2 = create_Klass2()
  k3 = create_Klass3()
  k4 = create_Klass4()
  k5 = create_Klass5()
  k6 = create_Klass6()
  k7 = create_Klass7()

  call km%methodA(k1, k2, k3, k4, k5, k6, k7)
  call km%methodB(k1, k2, k3, k4, k5, k6, k7)

  call k1%release()
  call k2%release()
  call k3%release()
  call k4%release()
  call k5%release()
  call k6%release()
  call k7%release()

  k1 = getKlass1A()
  k2 = getKlass2A()
  k3 = getKlass3A()
  k4 = getKlass4A()
  k5 = getKlass5A()
  k6 = getKlass6A()
  k7 = getKlass7A()

  call km%methodA(k1, k2, k3, k4, k5, k6, k7)
  call km%methodB(k1, k2, k3, k4, k5, k6, k7)

  call k1%release()
  call k2%release()
  call k3%release()
  call k4%release()
  call k5%release()
  call k6%release()
  call k7%release()

  k1 = getKlass1B()
  k2 = getKlass2B()
  k3 = getKlass3B()
  k4 = getKlass4B()
  k5 = getKlass5B()
  k6 = getKlass6B()
  k7 = getKlass7B()

  call km%methodA(k1, k2, k3, k4, k5, k6, k7)
  call km%methodB(k1, k2, k3, k4, k5, k6, k7)

  call k1%release()
  call k2%release()
  call k3%release()
  call k4%release()
  call k5%release()
  call k6%release()
  call k7%release()

  x1 = create_XYZ1()
  x2 = create_XYZ2()
  x3 = create_XYZ3()
  x4 = create_XYZ4()
  x5 = create_XYZ5()
  x6 = create_XYZ6()
  x7 = create_XYZ7()

  call xyzm%methodA(x1, x2, x3, x4, x5, x6, x7)
  call xyzm%methodB(x1, x2, x3, x4, x5, x6, x7)

  call x1%release()
  call x2%release()
  call x3%release()
  call x4%release()
  call x5%release()
  call x6%release()
  call x7%release()

  call tem%methodA(theenum1, theenum2, theenum3)
  call tem%methodA(theenum1, theenum2, theenum3)
    
end program

! vim: set ts=2 sw=2 sts=2 tw=129 :
