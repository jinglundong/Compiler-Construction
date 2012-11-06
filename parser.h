#ifndef PARSER_H
#define PARSER_H
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

struct token{
 char* property;
 char* value;
 char* type;
};

struct ids {
  int index;
  struct ids* next;
  int depth;
};

struct ids* newid(int id, struct ids* next);
#endif
