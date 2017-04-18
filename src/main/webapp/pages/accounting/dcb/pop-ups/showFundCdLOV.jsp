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
				<td><input class="button" type="button" style="width: 60px;" onclick="searchFundCdLOV(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" class="button" id="btnFundCdLOVModalOk"     value="Ok" 	  style="width: 60px;" />
		<input type="button" class="button" id="btnFundCdLOVModalCancel" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script type="text/javascript">
	searchFundCdLOV(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchFundCdLOV(1);
		}
	});
	
	$("btnFundCdLOVModalOk").observe("click", function () {
		if (!$F("selectedRow").blank()) {
			$("gaccGfunFundCd").value = $($F("selectedRow")).down("input", 0).value;
			$("gaccDspFundDesc").value = $($F("selectedRow")).down("input", 1).value;
			Modalbox.hide();
		} else {
			showMessageBox("Please select record first.", imgMessage.ERROR);
			return false;
		}
	});

	$("btnFundCdLOVModalCancel").observe("click", function() {
		Modalbox.hide();
	});
</script>