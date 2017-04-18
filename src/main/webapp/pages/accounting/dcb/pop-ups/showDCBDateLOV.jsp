<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<input type="hidden" id="dcbDateLOVFundCd" 		name="dcbDateLOVFundCd" 	value="${gfunFundCd }" />
	<input type="hidden" id="dcbDateLOVBranchCd" 	name="dcbDateLOVBranchCd"  	value="${gibrBranchCd }" />
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchDCBDateLOV(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" class="button" id="btnDCBDateLOVModalOk"      value="Ok" 	  style="width: 60px;" />
		<input type="button" class="button" id="btnDCBDateLOVModalCancel" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script type="text/javascript">
	searchDCBDateLOV(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchDCBDateLOV(1);
		}
	});
	
	$("btnDCBDateLOVModalOk").observe("click", function () {
		/* WHEN-VALIDATE-ITEM (giacs035 - dcb_date) */
		if (!$F("selectedRow").blank()) {
			$("gaccDspDCBDate").value = $($F("selectedRow")).down("input", 1).value;
			$("gaccDspDCBYear").value = $($F("selectedRow")).down("input", 2).value;
			$("gaccDspDCBNo").value = "";
			$("controlPrevDCBDate").value = $F("gaccDspDCBDate");
			$("gicdSumDspFcSumAmt").value = "";
			$("controlDspGicdSumAmt").value = "";

			// set parameters to blank to avoid returning records when refreshed
			gicdSumListTableGrid.url = contextPath+"/GIACAccTransController?action=refreshGicdSumListing";
			gdbdListTableGrid.url = contextPath+"/GIACAccTransController?action=refreshGdbdListing";
			gicdSumListTableGrid.empty();
			gdbdListTableGrid.empty();
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
		/* end of WHEN-VALIDATE-ITEM (giacs035 - dcb_date) */
	});

	$("btnDCBDateLOVModalCancel").observe("click", function() {
		Modalbox.hide();
	});
</script>