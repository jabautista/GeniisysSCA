<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/>
<div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="reportType" value="${reportType}">
	<input type="hidden" id="extractId" value="0">
	<!-- <input type="hidden" id="policyId" value="${policyId}"> -->
</div>
<div id="reportGeneratorMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%;">
	
	<table border="0" style="margin-top: 10px; width: 98%;">
		<tr>
			<td class="rightAligned" style="width: 35%;">Branch</td>
			<td class="leftAligned" style="width: 65%;">
				<input type="text" id="branchCd" style="width: 30px;" />
				<input type="text" id="branchDesc" style="width: 150px;" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">Destination</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="destination" style="width: 60%;">
					<option value="PRINTER">PRINTER</option>
					<option value="SCREEN">SCREEN</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">Printer</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="printerName" style="width: 60%;">
					<option value=""></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">No. of Copies</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="noOfCopies" style="width: 60%;">
					<option value=""></option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
				</select>
			</td>
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px; margin-top: 5px;">
	<input type="button" class="button" id="btnSpoiledPrint" value="Print" style=""/>
	<input type="button" class="button" id="btnReturn" value="Return"  style=""/>
</div>
<script>
insertPrinterNames();
$("destination").selectedIndex = 1;
$("printerName").disable();
$("noOfCopies").disable();

$("destination").observe("change", function(){
	var destination = $("destination").value; 
	if ("SCREEN" == destination){
		$("printerName").disable();
		$("noOfCopies").disable();
		$("printerName").selectedIndex = 0;
		$("noOfCopies").selectedIndex = 0;
	} else {
		$("printerName").enable();
		$("noOfCopies").enable();
	}
});
$("btnSpoiledPrint").observe("click", function(){
		showMessageBox("Coming Soon, Happy to Serve..", imgMessage.INFO);
});

$("btnReturn").observe("click", hideOverlay);
</script>