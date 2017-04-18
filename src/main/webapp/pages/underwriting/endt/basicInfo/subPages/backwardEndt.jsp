<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="float: left; width: 100%;">
	<label style="margin: 10px 10px 10px 10px;">
		This is a backward endorsement since its effectivity is earlier than the effectivity 
		date of previous endorsement(s).  Annualize amount of the previous endorsement(s)
		will be calculated again.  Would you like to include non-affecting changes of this 
		endorsement like date, address, etc., in updating previous endorsement(s)?  
		Remember that all information herein will be the current  information of the policy. 
		Continue with the updates?
	</label>
</div>
<div style="float: left; width: 100%;">
	<table align="center" width="60%">
		<tr>
			<td><input type="radio" name="backwardEndt" id="radioYes"	value="Y" checked="checked"/></td>
			<td><label for="radioYes"> Yes (save with updates on previous endorsement)</label></td>
		</tr>
		<tr>
			<td><input type="radio" name="backwardEndt" id="radioNo" value="N" /></td>
			<td><label for="radioNo"> No (save without updates on previous endorsement)</label></td>
		</tr>
		<tr>
			<td><input type="radio" name="backwardEndt" id="radioCancel" value="C" /></td>
			<td><label for="radioCancel"> Cancel (return)</label></td>
		</tr>
	</table>					
</div>