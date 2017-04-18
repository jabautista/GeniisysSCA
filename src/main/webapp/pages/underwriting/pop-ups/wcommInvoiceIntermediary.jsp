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
				<td><input id="btnWcominvIntmSearch" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnIntmModalOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	lovName = "${intmLOVName}";

	showGipis085IntmAjaxResult(1, lovName);

	$("btnWcominvIntmSearch").observe("click", function() {
		showGipis085IntmAjaxResult(1, lovName);
	});

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			showGipis085IntmAjaxResult(1, lovName);
		}
	});
	
	$("btnIntmModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			var selectedRowId = $($F("selectedRow")).down("input", 0).value;
			$("txtIntmNo").value = $($F("selectedRow")).down("input", 0).value;
			$("txtIntmName").value = $($F("selectedRow")).down("input", 1).value;
			$("txtParentIntmNo").value = $($F("selectedRow")).down("input", 2).value;
			$("txtParentIntmName").value = $($F("selectedRow")).down("input", 3).value;
			$("txtIntmActiveTag").value = $($F("selectedRow")).down("input", 4).value;
			$("txtDspIntmName").value = $($F("selectedRow")).down("input", 0).value + " - " + $($F("selectedRow")).down("input", 1).value;
			$("txtDspParentIntmName").value = (!$($F("selectedRow")).down("input", 2).value.blank() && !$($F("selectedRow")).down("input", 3).value.blank()) ? ($($F("selectedRow")).down("input", 2).value + " - " + $($F("selectedRow")).down("input", 3).value) : "";
			$("isIntmOkForValidation").value = "Y"; 
			$("txtDspIntmName").focus();
			
			Modalbox.hide();
		} else {
			showMessageBox("Please select intermediary first.", imgMessage.ERROR);
			return false;
		}
	});
</script>