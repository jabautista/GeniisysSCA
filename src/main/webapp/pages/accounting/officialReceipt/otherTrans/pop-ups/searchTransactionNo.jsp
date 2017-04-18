<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find</td>
				<td class="leftAligned"><input type="text" id="keyword" name="keyword" style="margin-bottom: 0; width: 200px;" value=""/></td>
				<td><input class="button" type="button" id="searchTrans" style="width: 60px;" value="Search"/></td>
			</tr>
		</table>
	</div>
	<div style="padding: 10px; height: 360px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center"></div>
	<div id="buttonDiv" align="right" style="margin: 10px; margin-right: 0">
		<input type="button" id="btnTransOk" class="button" value="Ok" style="width: 60px;"/>
		<input type="button" id="btnTransCancel" class="button" value="Cancel" onclick="Modalbox.hide();"/>
	</div>
</div>

<script type="text/javascript">
	searchTransactionNoDetails(1);
	
	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchTransactionNoDetails(1);
		}
	});

	$("searchTrans").observe("click", function(){
		searchTransactionNoDetails(1);
	});

	$("btnTransOk").observe("click", function(){
		if (!$F("selectedRow").blank()) {
			$("oldTransNo").value 	 	= $($F("selectedRow")).down("input", 0).value;
			$("oldFundCode").value   	= $($F("selectedRow")).down("input", 1).value;
			$("hidOldBranchName").value	= $($F("selectedRow")).down("input", 2).value;
			$("oldItemNo").value 	 	= $($F("selectedRow")).down("input", 3).value;
			$("hidGaccTranId").value 	= $($F("selectedRow")).down("input", 4).value;
			$("oldBranch").value		= $($F("selectedRow")).down("input", 5).value;
			$("tranYear").value	 	 	= $($F("selectedRow")).down("input", 6).value;
			$("tranMonth").value	 	= $($F("selectedRow")).down("input", 7).value;
			$("tranSeqNo").value	 	= $($F("selectedRow")).down("input", 8).value;
			Modalbox.hide();
			getDefaultAmount();	
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
	});

</script>

