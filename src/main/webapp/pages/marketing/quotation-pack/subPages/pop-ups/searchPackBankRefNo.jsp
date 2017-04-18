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
				<td><input id="searchBankRefNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnBankRefNoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnBankRefNoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>

<script type="text/javascript">
	searchPackBankRefNo(1,$("keyword").value);

	$("btnBankRefNoCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchBankRefNo").observe("click", function(){
		searchPackBankRefNo(1,$("keyword").value);
	});

	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchPackBankRefNo(1,$("keyword").value);
		}
	});

	$("btnBankRefNoOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowBankRefNoList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;
				var id = getSelectedRowId("rowBankRefNoList");
				for(var a=0; a<objSearchBankRefNo.length; a++){
					if (objSearchBankRefNo[a].divCtrId == id){
						$("nbtAcctIssCd").value = changeSingleAndDoubleQuotes(objSearchBankRefNo[a].acctIssCd);;
						$("nbtBranchCd").value = changeSingleAndDoubleQuotes(objSearchBankRefNo[a].branchCd);;
						$("dspRefNo").value = changeSingleAndDoubleQuotes(objSearchBankRefNo[a].refNo);;
						$("dspModNo").value = changeSingleAndDoubleQuotes(objSearchBankRefNo[a].modNo);;
						$("bankRefNo").value = changeSingleAndDoubleQuotes(objSearchBankRefNo[a].bankRefNo);
						$("nbtBranchCd").focus();
						$("otherChanges").value = changeTag==1?"1":"0";
						changeTag = 1;
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