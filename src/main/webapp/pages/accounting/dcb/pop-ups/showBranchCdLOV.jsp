<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<input type="hidden" id="branchCdLOVFundCd" 	name="branchCdLOVFundCd" 	value="${gfunFundCd }" />
	<input type="hidden" id="branchCdLOVModuleId" 	name="branchCdLOVModuleId"  value="${moduleId }" />
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchBranchCdLOV(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" class="button" id="btnBranchCdLOVModalOk"     value="Ok" 	  style="width: 60px;" />
		<input type="button" class="button" id="btnBranchCdLOVModalCancel" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script type="text/javascript">
	searchBranchCdLOV(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchBranchCdLOV(1);
		}
	});
	
	$("btnBranchCdLOVModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			$("gaccGibrBranchCd").value = $($F("selectedRow")).down("input", 0).value;
			$("gaccDspBranchName").value = $($F("selectedRow")).down("input", 1).value;
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
	});

	$("btnBranchCdLOVModalCancel").observe("click", function() {
		Modalbox.hide();
	});
</script>