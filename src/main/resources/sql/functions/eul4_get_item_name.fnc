DROP FUNCTION CPI.EUL4_GET_ITEM_NAME;

CREATE OR REPLACE FUNCTION CPI.EUL4_GET_ITEM_NAME(QSID in NUMBER)
return VARCHAR2 is
Itmid VARCHAR2(2000):=null;
--
startpt 		BINARY_INTEGER :=1;
BMP 		LONG RAW;
pos		BINARY_INTEGER :=0;
ctr		BINARY_INTEGER :=0;
chklgth		BINARY_INTEGER;
hexstring	VARCHAR2(10);
hexid		BINARY_INTEGER :=0;
decnibble1	NUMBER;
decnibble2	BINARY_INTEGER;
decnibble3	BINARY_INTEGER;
decnibble4	BINARY_INTEGER;
decnibble5	BINARY_INTEGER;
decnibble6	BINARY_INTEGER;
decnibble7	BINARY_INTEGER;
decnibble8	BINARY_INTEGER;
decnibble9	BINARY_INTEGER;
decnibble10 	BINARY_INTEGER;
hexchar		VARCHAR2(1);
expid		BINARY_INTEGER;
aggtype		BINARY_INTEGER;
nibblezero	BOOLEAN;
--
-- Occasionally, due to a bug, the first 5 bytes of the string are not always populated with id of
-- the item so rather than go all the way down the string looking a every 5 bytes until it reaches
-- the end (a slow process) I count the number of empy stings I have found so far and when it
-- reaches the the value held in 'noemptyblocks'  it moves on to the next string
--
noemptyblks  	BINARY_INTEGER:=10;
--
--
--
--
-- This cursor finds the Dimension values
--
cursor dbmp is
select qs_dbmp0||qs_dbmp1||qs_dbmp2||qs_dbmp3||qs_dbmp4||qs_dbmp5||qs_dbmp6||qs_dbmp7 from eul4_qpp_stats
where qs_id = QSID;
--
--
-- This cursor finds the Measure values
--
cursor mbmp is
select  qs_mbmp0||qs_mbmp1||qs_mbmp2||qs_mbmp3||qs_mbmp4||qs_mbmp5||qs_mbmp6||qs_mbmp7
from eul4_qpp_stats
where qs_id = QSID;
--
--
begin
--
-- Loop Twice First loop deals with the Dimensions values the scond with the Measure Values
--
for itype in 1..2 loop
if itype = 1 then
open dbmp;
else
open mbmp;
end if;
hexid:=0;
--
--
--This bit takes a five byte chunk in the string.
-- It then loops until it reaches the end of the string or it find no more values
--
while hexid <> noemptyblks loop
if itype = 1 then
fetch  dbmp into BMP;
else
fetch mbmp into BMP;
end if;
 ctr:=ctr+1;
  pos:=pos+10;
  if pos=4090 then
  hexid:= noemptyblks;
  startpt:=1;
  pos:=0;
 else
  hexstring:=nvl(substr(rawtohex(BMP),startpt,10),'0000000000');
 	if
		hexstring = '0000000000' then
		hexid:=hexid + 1;
		decnibble1:=0;
		decnibble2:=0;
		decnibble3:=0;
		decnibble4:=0;
		decnibble5:=0;
		decnibble6:=0;
		decnibble7:=0;
		decnibble8:=0;
		decnibble9:=0;
		decnibble10:=0;
		nibblezero:= TRUE;
			if hexid = noemptyblks then
			startpt:=1;
			pos:=0;
			end if;
--
--
-- Converts Hex Nibble into Decimal value.
--
	else
		nibblezero:=FALSE;
		hexchar:=substr(rawtohex(BMP),startpt,1);
		if hexchar = '0' then decnibble1:=0;
		elsif hexchar ='A' then decnibble1:=10;
		elsif hexchar ='B' then decnibble1:=11;
		elsif hexchar ='C' then decnibble1:=12;
		elsif hexchar ='D' then decnibble1:=13;
		elsif hexchar ='E' then decnibble1:=14;
		elsif hexchar ='F' then decnibble1:=15;
		else decnibble1:=to_number(hexchar);
		end if;
		hexchar:=substr(rawtohex(BMP),startpt+1,1);
		if hexchar = '0' then decnibble2:=0;
		elsif hexchar ='A' then decnibble2:=10;
		elsif hexchar ='B' then decnibble2:=11;
		elsif hexchar ='C' then decnibble2:=12;
		elsif hexchar ='D' then decnibble2:=13;
		elsif hexchar ='E' then decnibble2:=14;
		elsif hexchar ='F' then decnibble2:=15;
		else decnibble2:=to_number(hexchar);
		end if;
		hexchar:=substr(rawtohex(BMP),startpt+2,1);
		if hexchar = '0' then decnibble3:=0;
		elsif hexchar ='A' then decnibble3:=10;
		elsif hexchar ='B' then decnibble3:=11;
		elsif hexchar ='C' then decnibble3:=12;
		elsif hexchar ='D' then decnibble3:=13;
		elsif hexchar ='E' then decnibble3:=14;
		elsif hexchar ='F' then decnibble3:=15;
		else decnibble3:=to_number(hexchar);
		end if;
		hexchar:= substr(rawtohex(BMP),startpt+3,1);
		if hexchar = '0' then decnibble4:=0;
		elsif  hexchar ='A' then decnibble4:=10;
		elsif hexchar ='B' then decnibble4:=11;
		elsif hexchar ='C' then decnibble4:=12;
		elsif hexchar ='D' then decnibble4:=13;
		elsif hexchar ='E' then decnibble4:=14;
		elsif hexchar ='F' then decnibble4:=15;
		else decnibble4:=to_number(hexchar);
		end if;
		hexchar :=substr(rawtohex(BMP),startpt+4,1);
		if hexchar = '0' then decnibble5:=0;
		elsif hexchar ='A' then decnibble5:=10;
		elsif hexchar ='B' then decnibble5:=11;
		elsif hexchar ='C' then decnibble5:=12;
		elsif hexchar ='D' then decnibble5:=13;
		elsif hexchar ='E' then decnibble5:=14;
		elsif hexchar ='F' then decnibble5:=15;
		else decnibble5:=to_number(hexchar );
		end if;
		hexchar := substr(rawtohex(BMP),startpt+5,1);
		if hexchar = '0' then decnibble6:=0;
		elsif hexchar ='A' then decnibble6:=10;
		elsif hexchar='B' then decnibble6:=11;
		elsif hexchar='C' then decnibble6:=12;
		elsif hexchar='D' then decnibble6:=13;
		elsif hexchar='E' then decnibble6:=14;
		elsif hexchar='F' then decnibble6:=15;
		else decnibble6:=to_number(hexchar);
		end if;
		hexchar := substr(rawtohex(BMP),startpt+6,1);
		if hexchar = '0' then decnibble7:=0;
		elsif hexchar ='A' then decnibble7:=10;
		elsif hexchar='B' then decnibble7:=11;
		elsif hexchar='C' then decnibble7:=12;
		elsif hexchar='D' then decnibble7:=13;
		elsif hexchar='E' then decnibble7:=14;
		elsif hexchar='F' then decnibble7:=15;
		else decnibble7:=to_number(hexchar);
		end if;
		hexchar :=substr(rawtohex(BMP),startpt+7,1);
		if hexchar = '0' then decnibble8:=0;
		elsif hexchar ='A' then decnibble8:=10;
		elsif hexchar='B' then decnibble8:=11;
		elsif hexchar='C' then decnibble8:=12;
		elsif hexchar='D' then decnibble8:=13;
		elsif hexchar='E' then decnibble8:=14;
		elsif hexchar='F' then decnibble8:=15;
		else decnibble8:=to_number(hexchar);
		end if;
		hexchar:= substr(rawtohex(BMP),startpt+8,1);
		if hexchar = '0' then decnibble9:=0;
		elsif hexchar ='A' then decnibble9:=10;
		elsif hexchar='B' then decnibble9:=11;
		elsif hexchar='C' then decnibble9:=12;
		elsif hexchar='D' then decnibble9:=13;
		elsif hexchar='E' then decnibble9:=14;
		elsif hexchar='F' then decnibble9:=15;
		else decnibble9:=to_number(hexchar);
		end if;
	if itype = 2 then
		hexchar :=substr(rawtohex(BMP),startpt+9,1);
		if hexchar = '0' then decnibble10:=0;
		elsif hexchar ='A' then decnibble10:=10;
		elsif hexchar='B' then decnibble10:=11;
		elsif hexchar='C' then decnibble10:=12;
		elsif hexchar='D' then decnibble10:=13;
		elsif hexchar='E' then decnibble10:=14;
		elsif hexchar='F' then decnibble10:=15;
		else decnibble10:=to_number(hexchar);
		end if;
	end if;
--
--
-- Off set the nibble by One Byte
-- Then calculate the Item id
--
if nibblezero = FALSE then
		decnibble1:=decnibble1*2;
		if decnibble2 > 7 then
		decnibble1:=decnibble1+1;
		decnibble2:=decnibble2-8;
		end if;
	decnibble1:=decnibble1 * 268435456;
	decnibble2:=decnibble2 * 2;
		if decnibble3 > 7 then
		decnibble2:=decnibble2+1;
		decnibble3:=decnibble3-8;
		end if;
	decnibble2:=decnibble2 * 16777216;
	decnibble3:=decnibble3*2;
		if decnibble4 > 7 then
		decnibble3:=decnibble3+1;
		decnibble4:=decnibble4-8;
		end if;
	decnibble3:=decnibble3 * 1048576;
	decnibble4:=decnibble4*2;
		if decnibble5 > 7 then
		decnibble4:=decnibble4+1;
		decnibble5:=decnibble5-8;
		end if;
	decnibble4:=decnibble4 * 65536;
	decnibble5:=decnibble5*2;
		if decnibble6 > 7 then
		decnibble5:=decnibble5+1;
		decnibble6:=decnibble6-8;
		end if;
	decnibble5:=decnibble5 * 4096;
	decnibble6:=decnibble6*2;
		if decnibble7 > 7 then
		decnibble6:=decnibble6+1;
		decnibble7:=decnibble7-8;
		end if;
	decnibble6:=decnibble6 * 256;
	decnibble7:=decnibble7*2;
		if decnibble8 > 7 then
		decnibble7:=decnibble7+1;
		decnibble8:=decnibble8-8;
		end if;
	decnibble7:=decnibble7 * 16;
	decnibble8:=decnibble8*2;
		if decnibble9 > 7 then
		decnibble8:=decnibble8+1;
		decnibble9:=decnibble9-8;
		end if;
if itype=2 then
	if decnibble9>0 then
	decnibble9:=(decnibble9-2)*8;
	end if;
	decnibble10:=decnibble9+(decnibble10/2);
end if;
expid:= decnibble1 + decnibble2 + decnibble3 + decnibble4 + decnibble5 + decnibble6 + decnibble7 + decnibble8;
end if;
end if;
end if;
startpt:=pos+1;
--
--
-- Build up the string of item ids used in the query
--
if nibblezero = FALSE then
   if itype =1 then
          if nvl(length(itmid),0)=0 then
          itmid:=to_char(expid)||',0';
   else
          chklgth:= length(itmid)+length(to_char(expid))+3;
                 if chklgth > 1999 then
                   itmid:=itmid||'*';
                   exit;
                 else
                   itmid:=itmid||'.'||to_char(expid)||',0';
                 end if;
   end if;
   else
   chklgth:= nvl(length(itmid),0)+length(to_char(expid))+3;
                 if chklgth > 1999 then
                   itmid:=itmid||'*';
                   exit;
                 elsif chklgth =length(to_char(expid))+3 then
		   itmid:=to_char(expid)||','||to_char(decnibble10);
		 else
                   itmid:=itmid||'.'||to_char(expid)||','||to_char(decnibble10);
                 end if;
   end if;
end if;
--
-- Go get the next five bytes in the string
--
end loop;
--
--
--  Close the cursor on the first loop for the dimensions
--  on the second for the Measures
--
if itype = 1 then
close dbmp;
else
close mbmp;
end if;
--
end loop;
--
return itmid;
-- return hexstring;
--
end EUL4_GET_ITEM_NAME;
/

DROP FUNCTION CPI.EUL4_GET_ITEM_NAME;
