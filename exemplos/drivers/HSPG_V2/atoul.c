unsigned long atoul(register const char * s)
{
	register unsigned long	a;

	while(*s == ' ' || *s == '\t')
 {
 	s++;
 }

	a = 0;

	while(*s >='0' && *s <='9')
 {
		a = a*10L + (*s++ - '0');
 }
	return(a);
}
