<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="${keyword }" /></td>
				<td><input id="searchSlName" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnSlNameOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnSlNameCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchSlNameInputVatModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnSlNameCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchSlName").observe("click", function(){
		searchSlNameInputVatModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchSlNameInputVatModal(1,$("keyword").value);
		}	
	});

	//when OK button click
	$("btnSlNameOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowSlNameInputVatList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;

				$("hidSlCdInputVat").value = row.down("input",0).value;
				$("txtSlNameInputVat").value = row.down("input",1).value;
				Modalbox.hide();  
			}
		});
		if (!hasSelected){
			Modalbox.hide();
		}
	});
</script>	