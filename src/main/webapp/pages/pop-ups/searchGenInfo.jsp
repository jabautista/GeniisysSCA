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
				<td><input id="searchGenInfo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnGenInfoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnGenInfoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchGenInfoModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnGenInfoCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchGenInfo").observe("click", function(){
		searchGenInfoModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchGenInfoModal(1,$("keyword").value);
		}
	});

	//when OK button click
	$("btnGenInfoOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowGenInfoList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true; 
				var id = getSelectedRowId("rowGenInfoList");
				for(var a=0; a<objSearchGenInfo.length; a++){
					if (objSearchGenInfo[a].divCtrId == id){
						$("generalInformation").value = unescapeHTML2(changeSingleAndDoubleQuotes(nvl(objSearchGenInfo[a].genInfo01,"")+nvl(objSearchGenInfo[a].genInfo02,"")+nvl(objSearchGenInfo[a].genInfo03,"")+nvl(objSearchGenInfo[a].genInfo04,"")+nvl(objSearchGenInfo[a].genInfo05,"")+nvl(objSearchGenInfo[a].genInfo06,"")+nvl(objSearchGenInfo[a].genInfo07,"")+nvl(objSearchGenInfo[a].genInfo08,"")+nvl(objSearchGenInfo[a].genInfo09,"")+nvl(objSearchGenInfo[a].genInfo10,"")+nvl(objSearchGenInfo[a].genInfo11,"")+nvl(objSearchGenInfo[a].genInfo12,"")+nvl(objSearchGenInfo[a].genInfo13,"")+nvl(objSearchGenInfo[a].genInfo14,"")+nvl(objSearchGenInfo[a].genInfo15,"")+nvl(objSearchGenInfo[a].genInfo16,"")+nvl(objSearchGenInfo[a].genInfo17,"")));
						objUW.hidObjGIPIS002.geninInfoCd = changeSingleAndDoubleQuotes(nvl(objSearchGenInfo[a].geninInfoCd,""));
						$("generalInformation").focus();
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