module cbext
 use, intrinsic :: ISO_C_BINDING
 implicit none
  
type, bind(C) :: SwigArrayWrapper
  type(C_PTR), public :: data = C_NULL_PTR
  integer(C_SIZE_T), public :: size = 0
end type

abstract interface
  function fp_transform(s) &
    result(swig_result)
    use, intrinsic :: ISO_C_BINDING
    character(kind=C_CHAR, len=:), allocatable :: swig_result
    character(kind=C_CHAR, len=*), target :: s
  end function
  function swigc_fp_transform(farg1) &
    result(fresult)
    use, intrinsic :: ISO_C_BINDING
    import :: SwigArrayWrapper
    type(SwigArrayWrapper) :: farg1
    type(SwigArrayWrapper) :: fresult
  end function
end interface
contains
  function enquote_single(s) &
      result(news)
    use, intrinsic :: ISO_C_BINDING
    character(kind=C_CHAR, len=:), allocatable :: news
    character(kind=C_CHAR, len=*), target :: s
    news = "'" // s // "'"
  end function

  function bracket(s) &
      result(news)
    use, intrinsic :: ISO_C_BINDING
    character(kind=C_CHAR, len=:), allocatable :: news
    character(kind=C_CHAR, len=*), target :: s
    news = "[" // s // "]"
  end function

  function f_c_transform(funptr, s) &
      result(swig_result)
    procedure(swigc_fp_transform), pointer :: funptr
    character(kind=C_CHAR, len=:), allocatable :: swig_result
    character(kind=C_CHAR, len=*), target :: s
    character(kind=C_CHAR), dimension(:), allocatable, target :: farg1_chars
    type(SwigArrayWrapper) :: fresult 
    type(SwigArrayWrapper) :: farg1 

    call SWIG_string_to_chararray(s, farg1_chars, farg1)
    fresult = swigc_enquote(farg1)
    call SWIG_chararray_to_string(fresult, swig_result)
    call SWIG_free(fresult%data)
      
  function join_transformed_fancy(joiner, cb) &
    result(swig_result)
    use, intrinsic :: ISO_C_BINDING
    character(kind=C_CHAR, len=:), allocatable :: swig_result
    character(kind=C_CHAR, len=*), target :: joiner
    procedure(fp_transform), pointer :: cb => null()
    type(C_FUNPTR), intent(in), value :: farg2

  call SWIG_string_to_chararray(joiner, farg1_chars, farg1)
  farg2 = cb
  fresult = swigc_join_transformed(farg1, farg2)
  call SWIG_chararray_to_string(fresult, swig_result)
  call SWIG_free(fresult%data)
  end function
end module

program test_callback
  use cbext
  implicit none

  call test_cb()
  call test_transform()

contains
subroutine test_cb
  use cbext
  implicit none
  procedure(fp_transform), pointer :: trans => null()

  trans => enquote_single
  write(*,*) "Result: " // trans("whee")
  trans => bracket
  write(*,*) "Result: " // trans("whee")
end subroutine

subroutine test_transform
  use callback
  use, intrinsic :: ISO_C_BINDING
  implicit none
  character(kind=C_CHAR, len=:), allocatable :: str 

  str = join_transformed(", and ", enquote_cb)
  write(0,*) "Got string: " // str
end subroutine

end program
! vim: set ts=2 sw=2 sts=2 tw=129 :
