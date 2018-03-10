struct SwigArrayWrapper {
    void* data;
    size_t size;
};


SWIGINTERN SwigArrayWrapper SwigArrayWrapper_uninitialized() {
  SwigArrayWrapper result;
  result.data = NULL;
  result.size = 0;
  return result;
}

SWIGEXPORT SwigArrayWrapper swigc_passthrough(SwigArrayWrapper *farg1) {
  SwigArrayWrapper fresult ;
  std::string *arg1 = 0 ;
  std::string tempstr1 ;
  std::string result;
  
  tempstr1 = std::string(static_cast<const char *>(farg1->data), farg1->size);
  arg1 = &tempstr1;
  result = passthrough((std::string const &)*arg1);
  fresult.size = (&result)->size();
  if (fresult.size > 0) {
    fresult.data = malloc(fresult.size);
    memcpy(fresult.data, (&result)->c_str(), fresult.size);
  } else {
    fresult.data = NULL;
  }
  return fresult;
}



