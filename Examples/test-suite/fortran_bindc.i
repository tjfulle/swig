%module fortran_bindc

%{
#include <stdlib.h>
%}

// Give *all* types the struct typemap by default
%fortran_bindc_struct(SWIGTYPE);
// Apply the "bindc" feature to everything
%bindc "1";

%feature("matched_name") DBmrgtree   "! OK     DBmrgtree   ";
%feature("matched_name") f_DBmrgtree "ERROR  ! f_DBmrgtree ";
%feature("matched_name") _DBmrgtree  "ERROR  ! _DBmrgtree  ";

// XXX Ideally %ignore should be applied to DBmrgtree...
%ignore _DBmrgtree;
// ... because the typemap does
%apply void * {DBmrgtree*};
// (although fully specifying does as well)
%apply void * { struct _DBmrgtree* };


%inline %{
typedef struct _DBmrgtree {
    int should_be_ignored[sizeof(double)];
} DBmrgtree;

void do_something(DBmrgtree* dbm) { dbm->should_be_ignored[1] = 2; }
void do_something_else(struct _DBmrgtree* dbm) { dbm->should_be_ignored[1] = 2; }
%}
