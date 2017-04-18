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
				<td><input id="searchInitInfo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnInitInfoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnInitInfoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchInitInfoModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnInitInfoCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchInitInfo").observe("click", function(){
		searchInitInfoModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchInitInfoModal(1,$("keyword").value);
		}
	});

	//when OK button click
	$("btnInitInfoOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowInitInfoList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;
				var id = getSelectedRowId("rowInitInfoList");
				for(var a=0; a<objSearchInitInfo.length; a++){
					if (objSearchInitInfo[a].divCtrId == id){
						//changed from $("initialInformation").innerHTML adpascual 06.20.2012
						$("initialInformation").value = changeSingleAndDoubleQuotes(nvl(objSearchInitInfo[a].initialInfo01,"")+nvl(objSearchInitInfo[a].initialInfo02,"")+nvl(objSearchInitInfo[a].initialInfo03,"")+nvl(objSearchInitInfo[a].initialInfo04,"")+nvl(objSearchInitInfo[a].initialInfo05,"")+nvl(objSearchInitInfo[a].initialInfo06,"")+nvl(objSearchInitInfo[a].initialInfo07,"")+nvl(objSearchInitInfo[a].initialInfo08,"")+nvl(objSearchInitInfo[a].initialInfo09,"")+nvl(objSearchInitInfo[a].initialInfo10,"")+nvl(objSearchInitInfo[a].initialInfo11,"")+nvl(objSearchInitInfo[a].initialInfo12,"")+nvl(objSearchInitInfo[a].initialInfo13,"")+nvl(objSearchInitInfo[a].initialInfo14,"")+nvl(objSearchInitInfo[a].initialInfo15,"")+nvl(objSearchInitInfo[a].initialInfo16,"")+nvl(objSearchInitInfo[a].initialInfo17,""));
						objUW.hidObjGIPIS002.geninInfoCd = changeSingleAndDoubleQuotes(nvl(objSearchInitInfo[a].geninInfoCd,""));
						$("initialInformation").focus();
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