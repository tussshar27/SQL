--to comment shortcut: do Ctrl + kc
--to uncomment shortcut: do Ctrl + ku
use db_home;

--Control character	Value
--Tab	char(9)
--Space	char(32)
--Line feed	char(10)
--Carriage return	char(13)

--TO view the output og below queries, select Results to Text instead of Results to Grid option from above.
SELECT 'Line 1' + CHAR(13) + CHAR(10) + 'Line 2' AS NewlineString;	--CHAR(13) goes to the start of a line, CHAR(10) goes to new line.

PRINT 'Line 1' + CHAR(13) + CHAR(10) + 'Line 2';	--make it text by default

SELECT concat('Line 1' ,' ', 'Line 2', CHAR(13) , CHAR(10) ,	--create new line
'Tushar' )AS NewlineString;


