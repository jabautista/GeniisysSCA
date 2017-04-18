<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<input type="hidden" id="dcbNoLOVFundCd" 		name="dcbNoLOVFundCd" 		value="${gfunFundCd }" />
	<input type="hidden" id="dcbNoLOVBranchCd" 		name="dcbNoLOVBranchCd"  	value="${gibrBranchCd }" />
	<input type="hidden" id="dcbNoLOVDCBDate" 		name="dcbNoLOVDCBDate"  	value="${dcbDate }" />
	<input type="hidden" id="dcbNoLOVDCBYear" 		name="dcbNoLOVDCBYear"  	value="${dcbYear }" />
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 100px;" type="text" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchDCBNoLOV(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" class="button" id="btnDCBNoLOVModalOk"      value="Ok" 	  style="width: 60px;" />
		<input type="button" class="button" id="btnDCBNoLOVModalCancel" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script type="text/javascript">
	searchDCBNoLOV(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchDCBNoLOV(1);
		}
	});
	
	$("btnDCBNoLOVModalOk").observe("click", function () {
		/* WHEN-VALIDATE-ITEM (giacs035 - dcb_date) */
		if (!$F("selectedRow").blank()) {
			$("gaccDspDCBNo").value = $($F("selectedRow")).down("input", 0).value;
			validateGiacs035DCBNo1();
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
		/* end of WHEN-VALIDATE-ITEM (giacs035 - dcb_date) */
	});

	$("btnDCBNoLOVModalCancel").observe("click", function() {
		Modalbox.hide();
	});
</script>