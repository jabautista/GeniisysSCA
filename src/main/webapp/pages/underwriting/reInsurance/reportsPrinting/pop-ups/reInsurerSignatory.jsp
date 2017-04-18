<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="riSignatoryDivMain" name="riSignatoryDivMain" align="left" style="margin: 20px 0px 0px 20px;">
	<table>
		<!-- <tr>
			<td style="width: 130px;">Reinsurer Signatory</td>
		</tr> removed by: Nica 05.28.2013-->
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Name</td>
			<td><input id="txtRiName" name="txtRiName" type="text" maxlength="30" value="" style="width: 300px;"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Designation</td>
			<td><input id="txtRiDesignation" name="txtRiDesignation" type="text" maxlength="30" value="" style="width: 300px;"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Attest</td>
			<td><input id="txtRiAttest" name="txtRiAttest" type="text" maxlength="30" value="" style="width: 300px;"></td>
		</tr>
	</table>
	
	<center><input id="btnOk" name="btnOk" class="button" type="button" value="OK" align="center" style="width: 120px; margin-top: 15px;"></center>
</div>

<script type="text/javascript">
	$("txtRiName").value = objRiReports.riSignatory.name;
	$("txtRiDesignation").value = objRiReports.riSignatory.designation;
	$("txtRiAttest").value = objRiReports.riSignatory.attest;
	
	$("btnOk").observe("click", function(){
		objRiReports.riSignatory.name = unescapeHTML2($("txtRiName").value);
		objRiReports.riSignatory.designation = unescapeHTML2($("txtRiDesignation").value);
		objRiReports.riSignatory.attest = unescapeHTML2($("txtRiAttest").value);
		objRiReports.riSignatory.nbtTag = 1;
		genericObjOverlay.close();
	});
</script>