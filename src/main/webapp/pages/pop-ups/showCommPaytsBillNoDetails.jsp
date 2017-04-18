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
				<td><input class="button" type="button" style="width: 60px;" onclick="searchCommPaytsBillNoDetails(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnBillNoModalOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	searchCommPaytsBillNoDetails(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchCommPaytsBillNoDetails(1);
		}
	});
	
	$("btnBillNoModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			//These parts are executed on GIACS020 module (directTransCommPayts.jsp)
			$("txtPremSeqNo").value = $($F("selectedRow")).down("input", 0).value;
			//if (chkModifiedComm()) {
				//getCommPaytsIntermediary();
				//validateCommPaytsIntmNo();
				$("isIntmNoValidated").value = "N";
				$("txtDspIntmName").focus();
			//}
			Modalbox.hide();
		} else {
			showMessageBox("Please select bill first.", imgMessage.ERROR);
			return false;
		}
	});
</script>