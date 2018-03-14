/*
This test case tests that various types of arrays are working.
*/

%module arrays

%{
#include <stdlib.h>
%}

#if defined(SWIGSCILAB)
%rename(ArrSt) ArrayStruct;
#endif

%inline %{
#define ARRAY_LEN 2

typedef enum {One, Two, Three, Four, Five} finger;

typedef struct {
	double         double_field;
} SimpleStruct;

typedef struct {
	char           array_c [ARRAY_LEN];
	signed char    array_sc[ARRAY_LEN];
	unsigned char  array_uc[ARRAY_LEN];
	short          array_s [ARRAY_LEN];
	unsigned short array_us[ARRAY_LEN];
	int            array_i [ARRAY_LEN];
	unsigned int   array_ui[ARRAY_LEN];
	long           array_l [ARRAY_LEN];
	unsigned long  array_ul[ARRAY_LEN];
	long long      array_ll[ARRAY_LEN];
	float          array_f [ARRAY_LEN];
        double         array_d [ARRAY_LEN];
        SimpleStruct   array_struct[ARRAY_LEN];
        SimpleStruct*  array_structpointers[ARRAY_LEN];
        int*           array_ipointers [ARRAY_LEN];
	finger         array_enum[ARRAY_LEN];
	finger*        array_enumpointers[ARRAY_LEN];
	const int      array_const_i[ARRAY_LEN];
} ArrayStruct;

void fn_taking_arrays(SimpleStruct array_struct[ARRAY_LEN]) {}

/* Pointer helper functions used in the Java run test */
int* newintpointer() {
    return (int*)malloc(sizeof(int));
}
void setintfrompointer(int* intptr, int value) {
    *intptr = value;
}
int getintfrompointer(int* intptr) {
    return *intptr;
}

%}

// This tests wrapping of function that involves pointer to array


%inline %{
void array_pointer_func(int (*x)[10]) {}
%}


%inline %{
typedef float FLOAT;

typedef FLOAT cartPosition_t[3];

typedef struct {
cartPosition_t p;
} CartPoseData_t;

%}

#ifdef SWIGFORTRAN
/* Fortran can't handle hex, but it can substitute compile-time constants like
 * the enum into the 'contains' part of the code. HOWEVER, the interface would
 * have to "import" the enums for that to work, which we don't support. */
%ignore oned_hex;
%ignore oned_enum;
%ignore twod_enum;
%bindc oned_unknown;
%bindc twod_unknown_int;
#endif

%inline %{
enum {TEN = 10};
void oned_int(int a[10]) { a[0] = 0; }
void oned_expr(int a[2*5]) { a[0] = 0; }
void oned_enum(int a[TEN]) { a[0] = 0; }
void oned_hex(int a[0xa]) { a[0] = 0; }
void twod_int(int a[10][4]) { a[0][0] = 0; }
void twod_expr1(int a[2*5][4]) { a[0][0] = 0; }
void twod_expr2(int a[10][2*2]) { a[0][0] = 0; }
void twod_expr3(int a[2*5][2*2]) { a[0][0] = 0; }
void twod_enum(int a[TEN][4]) { a[0][0] = 0; }

#ifdef __cplusplus
extern "C" {
#endif
/* The "bindc" typemap will be used on these for Fortran */
void oned_unknown(int a[]) { a[0] = 0; }
void twod_unknown_int(int a[][10], int nj) {
    int i, j;
    for (j = 0; j < nj; ++j) {
        for (i = 0; i < 10; ++i) {
            a[j][i] = 10 * j + i + 1;
        }
    }
}

#ifdef __cplusplus
}
#endif
%}

%inline %{
void* get_ptr(void* inp) { return inp; }
%}

/* Test preferential matching of [][ANY] over [ANY][ANY].
 * This should be consistent between the "SWIGTYPE" evaulation
 * and an explicit type's evaluation.
 *
 * The documentation states that [ANY] is for "fixed size arrays handling"
 * and [] is for "unknown sized array handling"
 */

#ifndef SWIGFORTRAN
%define OTHERTYPE SWIGTYPE* %enddef
#else
%define OTHERTYPE void*     %enddef
#endif

%typemap(in) int[][ANY] = OTHERTYPE;
%typemap(in) int[ANY][ANY] %{
/* this should NOT match */
#error "Matched the wrong integer array typemap"
%}

%typemap(in) SWIGTYPE[][ANY] = OTHERTYPE;
%typemap(in) SWIGTYPE[][] %{
#error "Matched the wrong generic array typemap"
%}

%inline %{

/* This should match int[][ANY] */
void match_int(int a[][10]) {
    a[0][0] = 0;
}

/* This should match SWIGTYPE[][ANY] */
void twod_unknown_float(float a[][10]) {
    a[0][0] = 0;
}

%}
