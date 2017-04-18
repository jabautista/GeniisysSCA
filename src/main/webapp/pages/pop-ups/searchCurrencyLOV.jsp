<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIISCurrencyLOV function in accounting-lov.js
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
				<td><input class="button" type="button" style="width: 60px;" onclick="showGIISCurrencyLOVAjaxResult(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnOldItemNoModalOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	showGIISCurrencyLOVAjaxResult(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			showGIISCurrencyLOVAjaxResult(1);
		}
	});
	
	$("btnOldItemNoModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			var selectedRow = $($F("selectedRow"));
			var currencyCd = selectedRow.down("input", 0).value;
			var currencyDesc = selectedRow.down("input", 1).value;
			var convertRate = roundNumber(parseFloat(nvl(selectedRow.down("input", 2).value, "0")), 3);

			$("txtCurrencyCd").value = currencyCd;
			$("txtDspCurrencyDesc").value = currencyDesc;
			$("txtConvertRate").value = convertRate;
			$("txtForeignCurrAmt").value = formatCurrency((parseFloat($F("txtCollectionAmt").replace(/,/g,"")) / convertRate));

			if ($F("dfltCurrencyCd") == $F("txtCurrencyCd")) {
				$("txtConvertRate").readOnly = true;
			} else {
				$("txtConvertRate").readOnly = false;
			}
			
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
	});
</script>