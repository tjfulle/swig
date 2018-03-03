! File : runme.f90
program class_runme
  call run()
contains

subroutine run()
  use example
  use iso_c_binding
  implicit none

  type(Circle)          :: c
  type(Square), target  :: s ! 'target' allows it to be pointed to
  class(Shape), pointer :: sh

  ! ----- Object creation -----
    
  write(*,*) "Creating some objects"
  c = create_circle(10.0)
  s = create_square(10.0)

  ! ----- Access a static member -----
  write(*,'(a,i2,a)')"A total of", s%get_nshapes(), " shapes were created"

  ! ----- Member data access -----

  ! Notice how we can do this using functions specific to
  ! the 'Circle' class.
  call c%set_x(20.0)
  call c%set_y(30.0)

  ! Now use the same functions in the base class
  sh => s
  call sh%set_x(-10.0)
  call sh%set_y(  5.0)

  write(*,*)"Here is their current position:"
  write(*,'(a,f5.1,a,f5.1,a)')"  Circle = (", c%get_x(), ",", c%get_y(), " )"
  write(*,'(a,f5.1,a,f5.1,a)')"  Square = (", s%get_x(), ",", s%get_y(), " )"

  ! ----- Call some methods -----

  write(*,*)"Here are some properties of the shapes:"
  call print_shape(c)
  call print_shape(s)

  ! Call function that takes base class
  write(*,*)" Circle P/A  = ", surface_to_volume(c)
  write(*,*)" Square P/A  = ", surface_to_volume(s)

  ! Example of exception handling
  c = create_circle(-2.0)
  if (ierr /= 0) then
    write(*,*) "Caught the following error: ", get_serr()
    ierr = 0
  endif

  ! ----- Delete everything -----

  ! Note: this invokes the virtual destructor
  call c%release()
  call s%release()

  write(*,*)c%get_nshapes(), "shapes remain"
  write(*,*) "Goodbye"
end subroutine

subroutine print_shape(s)
  use example, only : Shape
  use iso_c_binding
  implicit none
  class(Shape), intent(in) :: s

  write(*,*)"  ", s%kind(), ":"
  write(*,*)"    area      = ",s%area()
  write(*,*)"    perimeter = ",s%perimeter()
end subroutine

end program
! vim: set ts=2 sw=2 sts=2 tw=129 :
