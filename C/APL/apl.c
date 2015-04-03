#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
//#include <editline/readline.h>

enum {AVAL_NULL, AVAL_INT, AVAL_FLOAT, AVAL_ARRAY};

typedef struct aval {
	int type;

	int val_i;
	float val_f;

	int val_a_len;
	struct aval** val_a;

} aval;

void reverse(char* s) {
	for(int i = 0; i <= (strlen(s) - 1) >> 1; i++){
		char t = s[i];
		s[i] = s[strlen(s) - i - 1];
		s[strlen(s) - i - 1] = t;
	}
}

void append(char* orig, char c) {
	
	int len = strlen(orig);
	orig[len] = c;
	orig[len+1] = '\0';
	
	//strcat(orig,&c);
}

void print_aval(aval* a) {
	printf("TYPE: %i val_i: %i val_f: %f val_a_len: %i\n", a->type, a->val_i, a->val_f, a->val_a_len);
	if(a->type == AVAL_ARRAY) {
		for(int i = 0; i < a->val_a_len; i++) {
			printf("\tval_a[%i] = ", i);
			print_aval(a->val_a[i]);
		}

	}
}

void add_arr_aval(aval* a, aval* b) {
	a->val_a_len++;
	if(a->val_a_len == 1)
		a->val_a = malloc(sizeof(aval*));
	else
		a->val_a = realloc(a->val_a, sizeof(aval*) * a->val_a_len);
	a->val_a[a->val_a_len - 1] = b;
}

aval* new_aval() {
	aval* a = malloc(sizeof(aval));
	a->type = AVAL_NULL;
	a->val_i = 0;
	a->val_f = 0;
	a->val_a_len = 0;
	a->val_a = NULL;
	return a;
}

void del_aval(aval* a) {
	free(a);
}

aval* make_aval(char* data, int len) {

	aval* a = new_aval();

	int currdatalen = 0;

	char* s = malloc(sizeof(char));
	s[0] = '\0';


	for(int i = 0; i < len; i++) {

		if(data[i] == ' ') {
			if(currdatalen == 0)
				continue;
			add_arr_aval(a, make_aval(s, currdatalen));
			currdatalen = 0;
			s[0] = '\0';
		}

		else {
			currdatalen++;
			s = realloc(s, sizeof(char) * currdatalen);
			append(s, data[i]);
		}
		
	}
	
	if(a->val_a_len == 0){
		a->type = AVAL_INT;
		a->val_i = atoi(s);
		return a;
	}
	else {
		a->type = AVAL_ARRAY;
		aval* last_a = make_aval(s, currdatalen);
		add_arr_aval(a, last_a);
	}

	return a;
}

/*
aval_op getrop(char* expr, int expr_end) {

}
*/

aval* getrdata(char* expr, int *expr_end) {
	for(int i = *expr_end; i >= 0; i--){
		if(isdigit(expr[i])) {
			
			int val_len = 1;
			char* val_s = &expr[i];
			
			expr[i+1] = '\0';

			while(i-1 >= 0 && (isdigit(expr[i - 1]) || expr[i - 1] == ' ')) {
				i--;
				if(expr[i] == ' ' && expr[i + 1] == ' ')
					continue;
				val_len++;
				append(val_s, expr[i]);
			}

			if(expr[i] == ' ')
				val_s[--val_len] = '\0';

			reverse(val_s);

			char* nval_s = malloc(strlen(val_s));
			strcpy(nval_s, val_s);
			expr[i]= '\0';

			aval* a = make_aval(nval_s, val_len);

			//printf("Run %i: string: %s len: %i\n", i, nval_s, val_len);
			//print_aval(a);
			free(nval_s);

			*expr_end = i;
			return a;
		}
	}
	return NULL;
}

aval* eval(char* expr, int expr_end) {
	printf("BEFORE: %i\n", expr_end);
	aval* rdata = getrdata(expr, &expr_end);
	print_aval(rdata);
	printf("AFTER: %i\n", expr_end);
	return rdata;
}

static char input[2048];

int main(int argc, char** argv) {
	puts("APL interpreter v 0.01");

	while(1) {
		fputs("apl> ", stdout);
		fgets(input, 2048, stdin);
		eval(input, strlen(input) - 2);
	}
	return 0;
}