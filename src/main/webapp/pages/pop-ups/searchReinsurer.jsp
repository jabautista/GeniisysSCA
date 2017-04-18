<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIACPremDepRILOV function in accounting-lov.js
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="showReinsurerAjaxResult(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnRiModalOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	showReinsurerAjaxResult(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			showReinsurerAjaxResult(1);
		}
	});
	
	$("btnRiModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			var selectedRowId = $($F("selectedRow")).down("input", 0).value;
			$("txtRiCd").value = selectedRowId;
			$("txtRiName").value = $($F("selectedRow")).down("input", 1).value;
			$("txtDrvRiName").value = selectedRowId + " - " + $($F("selectedRow")).down("input", 1).value;
			
			Modalbox.hide();
		} else {
			showMessageBox("Please select reinsurer first.", imgMessage.ERROR);
			return false;
		}
	});
</script>