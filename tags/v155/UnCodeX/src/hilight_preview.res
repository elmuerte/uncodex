        ��  ��                  �  8   U S C R I P T   P R E V I E W       0           // this is a comment
/* so is this */
class someType extends Object config(UnCodeX) native;

#EXEC DO SOME MACRO STUFF

cpptext {
	#error this doesn't compile
}

const aString   = "something";
const aInt		= 123456789;
const aFloat	= 123.456789;
const aName     = 'name';

native(123) static final bool Function(out int param1, optional string param2)
{
	param1 = self.aInt;
	while (param1 > 0)
	{
		param1--;
	}
	if (param2 == "")	return true;
	else return false;
}   