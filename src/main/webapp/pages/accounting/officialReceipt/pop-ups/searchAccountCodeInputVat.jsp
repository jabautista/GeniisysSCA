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
				<td><input id="searchAcctCode" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnAcctCodeOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnAcctCodeCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchAcctCodeInputVatModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnAcctCodeCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchAcctCode").observe("click", function(){
		searchAcctCodeInputVatModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchAcctCodeInputVatModal(1,$("keyword").value);
		}
	});

	//when OK button click
	$("btnAcctCodeOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowAcctCodeInputVatList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;
				var id = getSelectedRowId("rowAcctCodeInputVatList");
				for(var a=0; a<objSearchAcctCode.length; a++){
					if (objSearchAcctCode[a].glAcctId == id){
						$("hidSlCdInputVat").clear(); 
						$("txtSlNameInputVat").clear();
						$("txtGlAcctCategoryInputVat").value = objSearchAcctCode[a].glAcctCategory;
						$("txtGlControlAcctInputVat").value = objSearchAcctCode[a].glControlAcct;
						$("txtGlSubAcct1InputVat").value = objSearchAcctCode[a].glSubAcct1;
						$("txtGlSubAcct2InputVat").value = objSearchAcctCode[a].glSubAcct2;
						$("txtGlSubAcct3InputVat").value = objSearchAcctCode[a].glSubAcct3;
						$("txtGlSubAcct4InputVat").value = objSearchAcctCode[a].glSubAcct4;
						$("txtGlSubAcct5InputVat").value = objSearchAcctCode[a].glSubAcct5;
						$("txtGlSubAcct6InputVat").value = objSearchAcctCode[a].glSubAcct6;
						$("txtGlSubAcct7InputVat").value = objSearchAcctCode[a].glSubAcct7;
						$("txtDspAccountName").value = changeSingleAndDoubleQuotes(objSearchAcctCode[a].glAcctName);
						$("hidGlAcctIdInputVat").value = objSearchAcctCode[a].glAcctId;
						$("hidGsltSlTypeCdInputVat").value = objSearchAcctCode[a].gsltSlTypeCd;
						if ($F("hidGsltSlTypeCdInputVat") != ""){
							$("txtSlNameInputVat").addClassName("required");
							$("txtSlNameInputVatDiv").addClassName("required");
							$("txtSlNameInputVatDiv").setStyle("background-color:"+$("txtSlNameInputVat").getStyle("background-color"));
						}else{
							$("txtSlNameInputVat").removeClassName("required");
							$("txtSlNameInputVatDiv").removeClassName("required");
							$("txtSlNameInputVatDiv").setStyle("background-color:"+$("txtSlNameInputVat").getStyle("background-color"));
						}	
					}	
				}	
				Modalbox.hide();
			}
		});
		if (!hasSelected){
			Modalbox.hide();
		}
	});
</script>	