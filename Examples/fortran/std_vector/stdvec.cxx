/* File : stdvec.cxx */

#include "stdvec.h"

#include <iostream>
using std::cout;
using std::endl;

/* -------------------------------------------------------------------------
 * FREE FUNCTIONS
 * ------------------------------------------------------------------------- */

template<class T>
void print_view(const T* data, std::size_t size) {
  cout << "{";
  auto iter = data;
  auto end  = data + size;
  if (iter != end) {
    cout << *iter++;
  }
  while (iter != end) {
    cout << ", " << *iter++;
  }
  cout << "}" << endl;
}

/* -------------------------------------------------------------------------
 * EXPLICIT INSTANTIATION
 * ------------------------------------------------------------------------- */

template void print_view(const double* data, std::size_t size);


/* vim: set ts=2 sw=2 sts=2 tw=129 : */
