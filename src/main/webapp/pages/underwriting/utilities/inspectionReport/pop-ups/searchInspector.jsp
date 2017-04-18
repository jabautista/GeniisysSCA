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
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" onkeypress="onEnterEvent(event, searchInspector);" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchInspector();" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnInspectorOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnInspectorCancel" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script>
	searchInspector();
	$("btnInspectorOk").observe("click", function(){
		if (!$F("selectedRow").blank()) {
			var selectedRowId = $($F("selectedRow")).down("input", 0).value;
			$("inspectorCd").value = selectedRowId;
			$("inspector").value = $($F("selectedRow")).down("input", 1).value;
			
			Modalbox.hide();
		} else {
			showMessageBox("Please select inspector first.", imgMessage.ERROR);
			return false;
		}
	});
</script>