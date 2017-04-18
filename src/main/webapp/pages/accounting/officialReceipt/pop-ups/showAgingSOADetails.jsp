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
				<td><input class="button" type="button" style="width: 60px;" onclick="searchAgingSOADetails(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnAgingSOAOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	searchAgingSOADetails(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchAgingSOADetails(1);
		}
	});

	$("btnAgingSOAOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			$("txtB140IssCd").value = $($F("selectedRow")).down("input", 0).value;
			premDepIssCdTrigger();
			$("txtB140PremSeqNo").value = $($F("selectedRow")).down("input", 1).value;
			$("txtInstNo").value = $($F("selectedRow")).down("input", 2).value.blank() ? "" : parseInt($($F("selectedRow")).down("input", 2).value, 10).toPaddedString(2);
			$("txtDspA150LineCd").value = $($F("selectedRow")).down("input", 3).value;
			$("txtDspTotalAmountDue").value = $($F("selectedRow")).down("input", 4).value;
			$("txtDspTotalPayments").value = $($F("selectedRow")).down("input", 5).value;
			$("txtDspTempPayments").value = $($F("selectedRow")).down("input", 6).value;
			$("txtDspBalanceAmtDue").value = $($F("selectedRow")).down("input", 7).value;
			$("txtAssdNo").value = $($F("selectedRow")).down("input", 8).value;
			validateTranType1();
			getParSeqNo2();
			$("txtDrvAssuredName").value = $F("txtAssdNo") + " - " + $F("txtAssuredName");
			
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
	});
</script>