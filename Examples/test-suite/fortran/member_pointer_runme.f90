! File : member_pointer_runme.f90

program member_pointer_runme
  use member_pointer
  use ISO_C_BINDING
  implicit none
  type(SwigOpaqueMemFunPtr) :: area_memptr, perim_memptr
  type(Square) :: s
  real(C_DOUBLE) :: val

  ! Call C functions that return the member function pointers
  area_memptr = areapt()
  perim_memptr = perimeterpt()

  ! Allocate a square
  s = Square(10.0d0)

  ! Call a function that takes a member function pointer and an object
  val = do_op(s, area_memptr)
  write(0,*) "Area:", val
  if (val /= 100.0d0) stop 1

  ! Get a function pointer via a global variable
  area_memptr = get_areavar()
  val = do_op(s, area_memptr)
  write(0,*) "Area:", val
  if (val /= 100.0d0) stop 1

  ! Change the function pointer
  call set_areavar(perim_memptr)
  val = do_op(s, get_areavar())
  write(0,*) "Perimiter:", val
  if (val /= 40.0d0) stop 1

  ! Try the external constants
  perim_memptr = PERIMPT
  val = do_op(s, get_areavar())
  write(0,*) "Perimiter:", val
  if (val /= 40.0d0) stop 1

  write(0,*) "SUCCESS"
end program

! vim: set ts=2 sw=2 sts=2 tw=129 :
