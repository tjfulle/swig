%module member_pointer

%{
#if defined(__SUNPRO_CC)
#pragma error_messages (off, badargtype2w) /* Formal argument ... is being passed extern "C" ... */
#pragma error_messages (off, wbadinit) /* Using extern "C" ... to initialize ... */
#pragma error_messages (off, wbadasg) /* Assigning extern "C" ... */
#endif
%}

%inline %{
class Shape {
public:
  Shape() {
    nshapes++;
  }
  virtual ~Shape() {
    nshapes--;
  };
  double  x, y;
  double  *z;

  void    move(double dx, double dy);
  virtual double area(void) = 0;
  virtual double perimeter(void) = 0;
  static  int nshapes;
};

class Circle : public Shape {
private:
  double radius;
public:
  Circle(double r) : radius(r) { };
  virtual double area(void);
  virtual double perimeter(void);
};

class Square : public Shape {
private:
  double width;
public:
  Square(double w) : width(w) { };
  virtual double area(void);
  virtual double perimeter(void);
};

/* Typedef */
typedef double (Shape::*PerimeterFunc_td)(void);

extern double do_op(Shape *s, double (Shape::*m)(void));
extern double do_op_td(Shape *s, PerimeterFunc_td m);

/* Functions that return member pointers */

extern double (Shape::*areapt())(void);
extern double (Shape::*perimeterpt())(void);
extern PerimeterFunc_td perimeterpt_td();

/* Global variables that are member pointers */
extern double (Shape::*areavar)(void);
extern double (Shape::*perimetervar)(void);
extern PerimeterFunc_td perimetervar_td;
%}

%{
#  define SWIG_M_PI 3.14159265358979323846

/* Move the shape to a new location */
void Shape::move(double dx, double dy) {
  x += dx;
  y += dy;
}

int Shape::nshapes = 0;

double Circle::area(void) {
  return SWIG_M_PI*radius*radius;
}

double Circle::perimeter(void) {
  return 2*SWIG_M_PI*radius;
}

double Square::area(void) {
  return width*width;
}

double Square::perimeter(void) {
  return 4*width;
}

double do_op(Shape *s, double (Shape::*m)(void)) {
  return (s->*m)();
}

double do_op_td(Shape *s, PerimeterFunc_td m) {
  return (s->*m)();
}

double (Shape::*areapt())(void) {
  return &Shape::area;
}

double (Shape::*perimeterpt())(void) {
  return &Shape::perimeter;
}

PerimeterFunc_td perimeterpt_td() {
  return &Shape::perimeter;
}

/* Member pointer variables */
double (Shape::*areavar)(void) = &Shape::area;
double (Shape::*perimetervar)(void) = &Shape::perimeter;
PerimeterFunc_td perimetervar_td = &Shape::perimeter;
%}

/* Avoid -Werror=conversion-null error caused by passing NULL into a templated
 * function (NULL is by definition an integer, so templating on that parameter
 * will *always* cause this error).
 *
 * Instead, use `nullptr` which is of type nullptr_t and implicitly convertible
 * to a pointer. For builds using C++98, define as the integer zero (rather
 * than the macro NULL) in order to silence the warning.
 *
 * Finally, some C++03 build systems seem to define a nullptr type: at least,
 * this is the case in the default Clang build on apple systems:
member_pointer_wrap.cxx:1891:9: error: 'nullptr' macro redefined [-Werror,-Wmacro-redefined]
#define nullptr 0
        ^
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1/cstddef:87:9: note: previous definition is here
#define nullptr _VSTD::__get_nullptr_t()
 *
 */
%{
#include <cstddef>
#if (__cplusplus < 201103L) && !defined(nullptr)
#define nullptr 0
#endif
%}

/* Some constants */
%constant double (Shape::*AREAPT)(void) = &Shape::area;
%constant double (Shape::*PERIMPT)(void) = &Shape::perimeter;
%constant double (Shape::*NULLPT)(void) = nullptr;

/*
%inline %{
  struct Funktions {
    void retByRef(int & (*d)(double)) {}
  };
  void byRef(int & (Funktions::*d)(double)) {}
%}
*/

%inline %{

struct Funktions {
  int addByValue(const int &a, int b) { return a+b; }
  int * addByPointer(const int &a, int b) { static int val; val = a+b; return &val; }
  int & addByReference(const int &a, int b) { static int val; val = a+b; return val; }
};

int call1(int (Funktions::*d)(const int &, int), int a, int b) { Funktions f; return (f.*d)(a, b); }
int call2(int * (Funktions::*d)(const int &, int), int a, int b) { Funktions f; return *(f.*d)(a, b); }
int call3(int & (Funktions::*d)(const int &, int), int a, int b) { Funktions f; return (f.*d)(a, b); }
%}

%constant int (Funktions::*ADD_BY_VALUE)(const int &, int) = &Funktions::addByValue;
%constant int * (Funktions::*ADD_BY_POINTER)(const int &, int) = &Funktions::addByPointer;
%constant int & (Funktions::*ADD_BY_REFERENCE)(const int &, int) = &Funktions::addByReference;

