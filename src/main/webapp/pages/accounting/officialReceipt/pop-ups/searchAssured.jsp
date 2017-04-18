<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIACPremDepAssdNameLOV function in accounting-lov.js
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
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" onkeypress="onEnterEvent(event, searchClientModal2);" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchAssured2();" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 320px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnAssuredOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnCancelAssdListing" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	searchAssured2();
	$("btnAssuredOk").observe("click", function () {
		var selectedId= $("selectedClientId").value;
		if (selectedId != "")	{
			$("txtAssdNo").value = selectedId;
			$("txtDrvAssuredName").value =  selectedId + " - " + $F(selectedId+"assdName");
			$("txtAssuredName").value = $F(selectedId+"assdName");
		}
		
		$("txtAssuredName").focus();
		Modalbox.hide();
	});

	//added to restore line settings preceding cancel of assured designation
	$("btnCancelAssdListing").observe("click", function(){
		
	});
</script>