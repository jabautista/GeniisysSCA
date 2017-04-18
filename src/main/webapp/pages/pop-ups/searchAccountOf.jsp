<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<div id="searchOptions" align="center">
		<input type="hidden" id="selectedClientId" name="selectedClientId" value="0" readonly="readonly" />
		<div style="text-align: left;">
			<table>
				<tr>
					<td class="rightAligned">Name Keyword </td>
					<td class="leftAligned"><input name="c" style="margin-bottom: 0; width: 200px;" id="keyword" type="text" value="" /></td>
					<td><input class="button" type="button" style="width: 60px;" id="searchBtn" name="searchBtn" value="Search" /></td>
				</tr>
			</table>
		</div>
		<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
		</div>
	
		<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
			<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
			<input type="button" class="button" value="Ok" style="width: 60px;" onclick="useAccount(); Modalbox.hide();" />
			<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();">
		</div>
	</div>
</div>
<script type="text/javascript">
	openSearchAccountOf2($("assuredNo").value,$("keyword").value);
	$("searchBtn").observe("click",function(){
		openSearchAccountOf2($("assuredNo").value,$("keyword").value);
	});
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			openSearchAccountOf2($("assuredNo").value,$("keyword").value);
		}	
	});
</script>