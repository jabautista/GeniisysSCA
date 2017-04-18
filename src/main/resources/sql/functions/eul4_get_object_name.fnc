DROP FUNCTION CPI.EUL4_GET_OBJECT_NAME;

CREATE OR REPLACE FUNCTION CPI.EUL4_GET_OBJECT_NAME(USEKEY in VARCHAR2, TYPEKEY in varchar2)
return VARCHAR2 is
oname varchar2(2000);
--
-- Type Key is either 'F' for folder or 'I' for item.
--
--
startpt 	NUMBER :=1;
endpt		NUMBER :=length(USEKEY);
pos		NUMBER :=1;
ctr		NUMBER :=0;
chklgth		NUMBER;
objid		NUMBER;
aggtype		NUMBER;
objname	VARCHAR2(100);
--
--
cursor folder is
  select obj_name
  from eul4_objs
  where obj_id = objid;

-- exception when others then objname := '*';
-- end;
--
--
cursor item is
 select exp_name
 from eul4_expressions
 where exp_id = objid;
-- exception when others then objname := '*';
-- end;
--
begin
--
-- This bit works out the id's position in the string and moves down the string by looping
--
--
--
while pos <> 0 loop
  aggtype:=0;
  ctr:=ctr+1;
  pos:=instr(USEKEY,'.',1,ctr);
if pos=0 then
   if upper(TYPEKEY)='F' then
    objid:= to_number(substr(USEKEY,startpt,(endpt-startpt+1)));
   else
    objid:= to_number(substr(USEKEY,startpt,(endpt-startpt-1)));
    aggtype:=  to_number(substr(USEKEY,endpt,1));
   end if;
else
   if  upper(TYPEKEY)='F' then
     objid:= to_number(substr(USEKEY,startpt,(pos-startpt)));
   else
     objid:= to_number(substr(USEKEY,startpt,(pos-startpt-2)));
     aggtype:=  to_number(substr(USEKEY,pos-1,1));
   end if;
  startpt:=pos+1;
 end if;
 --
if upper(TYPEKEY) ='F' then
open folder;
fetch folder into objname;
-- exception when others then objname := '*';
-- end;
close folder;
end if;
--
--
if upper(TYPEKEY)='I' then
open item;
fetch item into objname;
close item;
-- exception when others then objname := '*';
-- end;
end if;
--
--
--
-- This bit builds up the string of folder names if it exceeds
-- 2000 chars it stops then places an '*' at the end.
--
if ctr=1 then
 if aggtype=0 then
 oname:=objname;
 elsif aggtype=1 then oname:=objname||' SUM';
 elsif aggtype=2 then oname:=objname||' AVG';
 elsif aggtype=3 then oname:=objname||' COUNT';
 elsif aggtype=4 then oname:=objname||' MAX';
 elsif aggtype=5 then oname:=objname||' MIN';
 else oname:=objname;
 end if;
else
    if aggtype=0 then
      chklgth:= length(oname)+length(objname)+2;
      elsif aggtype=1 then  chklgth:= length(oname)+length(objname)+6;
      elsif aggtype=2 then  chklgth:= length(oname)+length(objname)+6;
      elsif aggtype=3 then  chklgth:= length(oname)+length(objname)+8;
      elsif aggtype=4 then  chklgth:= length(oname)+length(objname)+6;
      elsif aggtype=5 then  chklgth:= length(oname)+length(objname)+6;
    else chklgth:= length(oname)+length(objname)+2;
    end if;
    if chklgth > 1999 then
        oname:=oname||'*';
        exit;
    else
        if aggtype = 0 then
        oname:=oname||', '||objname;
        elsif aggtype=1 then oname:=oname||', '||objname||' SUM';
        elsif aggtype=2 then oname:=oname||', '||objname||' AVG';
        elsif aggtype=3 then oname:=oname||', '||objname||' COUNT';
        elsif aggtype=4 then oname:=oname||', '||objname||' MAX';
        elsif aggtype=5 then oname:=oname||', '||objname||' MIN';
        else oname:=oname||', '||objname;
        end if;
   end if;
end if;
end loop;
--
--
return oname;
--
end EUL4_GET_OBJECT_NAME;
/

DROP FUNCTION CPI.EUL4_GET_OBJECT_NAME;
