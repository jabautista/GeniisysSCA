<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="checkReleaseInfoDiv">
	<table align="center" style="margin: 10px auto;">
		<tr>
			<td width="90px">Check No.</td>
			<td> : </td>
			<td>
				<input type="text" id="txtCheckPrefSuf" name="txtCheckPrefSuf" value="${checkPrefSuf}" readonly="readonly" style="width: 74px;" tabindex="501"/>
				---
				<input type="text" id="txtCheckNo" value="${checkNo}" readonly="readonly" style="width: 95px;" tabindex="502"/>
			</td>
			<td width="20px"></td>
			<td>Check Received By</td>
			<td> : </td>
			<td><input type="text" id="txtCheckReceivedBy" value="${checkReceivedBy}" readonly="readonly" style="width: 200px;" tabindex="506"/></td>
		</tr>
		
		<tr>
			<td>Check Release Date</td>
			<td> : </td>
			<td><input type="text" id="txtReleaseDate" value="${checkReleaseDate}" readonly="readonly" style="width: 200px;" tabindex="503"/></td>
			<td width="20px"></td>
			<td>O.R. No.</td>
			<td> : </td>
			<td><input type="text" id="txtOrNo" value="${orNo}" readonly="readonly" style="width: 200px;" tabindex="507"/></td>
		</tr>
		
		<tr>
			<td>Check Released By</td>
			<td> : </td>
			<td><input type="text" id="txtCheckReleasedBy" value="${checkReleasedBy}" readonly="readonly" style="width: 200px;" tabindex="504"/></td>
			<td width="20px"></td>
			<td>O.R. Date</td>
			<td> : </td>
			<td><input type="text" id="txtOrDate" value="${orDate}" readonly="readonly" style="width: 200px;" tabindex="508"/></td>
		</tr>
		
		<tr>
			<td>User ID</td>
			<td> : </td>
			<td><input type="text" id="txtUserId" value="${userId}" readonly="readonly" style="width: 200px;" tabindex="505"/></td>
			<td width="20px"></td>
			<td>Last Update</td>
			<td> : </td>
			<td><input type="text" id="txtLastUpdate" value="${lastUpdate}" readonly="readonly" style="width: 200px;" tabindex="509"/></td>
		</tr>
	</table>
	<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px; width: 120px;" tabindex="701"/></center>
</div>
<script>
	try {
		$("txtCheckPrefSuf").focus();
		$("btnReturn").observe("click", function(){
			overlayCheckReleaseInfo.close();
			delete overlayCheckReleaseInfo;
		});
	} catch(e) {
		showErrorMessage("Error in Check Release Info : ", e);
	}
</script>