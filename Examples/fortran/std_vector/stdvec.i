/* File : stdvec.i */

%module stdvec

%{
#include <utility>
#include "stdvec.h"
%}

/* -------------------------------------------------------------------------
 * Instantiate the vector-double
 * ------------------------------------------------------------------------- */

%include <std_vector.i>

// Replace ULL type with fortran standard integer
%apply int { std::vector<double>::size_type };

%template(VecDbl) std::vector<double>;

/* -------------------------------------------------------------------------
 * Parse and instantiate the templated vector functions
 * ------------------------------------------------------------------------- */

// Make the "as_array_ptr" return an array pointer
%apply std::vector<double>& POINTER
{ std::vector &as_array_ptr<double> };

// Make the "as_array" function return a native allocated fortran array
%apply const std::vector<double>& NATIVE
{ const std::vector &as_array<double> };

// Make any vector input argument named "view" accept an array pointer
%apply const std::vector<double>& POINTER
{ const std::vector &view };

%include "stdvec.h"

%template(as_array) as_array<double>;
%template(as_array_ptr) as_array_ptr<double>;
%template(as_reference) as_reference<double>;
%template(as_const_reference) as_const_reference<double>;

%template(print_vec) print_vec<double>;

/* -------------------------------------------------------------------------
 * Add a special copy-free "view" method that looks directly at a
 * Fortran-owned piece of data
 */

%include <typemaps.i>

%apply (SWIGTYPE *DATA, size_t SIZE) { (const double* data, std::size_t view) }

%template(print_view) print_view<double>;

/* -------------------------------------------------------------------------
 * Example of creating an allocatable array in Fortran by returning a vector by
 * value in C++ [requires C++11]
 */

%apply std::vector<double> NATIVE { std::vector make_array };

%inline %{
std::vector<double> make_array() { return {1,1,2,3,5}; }
%}

/* vim: set ts=2 sw=2 sts=2 tw=129 : */
