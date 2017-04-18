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
				<td><input id="searchEndtText" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnEndtTextOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnEndtTextCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchEndtTextModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnEndtTextCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchEndtText").observe("click", function(){
		searchEndtTextModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchEndtTextModal(1,$("keyword").value);
		}
	});

	//when OK button click
	$("btnEndtTextOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowEndtTextList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true; 
				var id = getSelectedRowId("rowEndtTextList");
				for(var a=0; a<objSearchEndtText.length; a++){
					if (objSearchEndtText[a].divCtrId == id){
						if(nvl($F("globalPackParId"), null) == null || nvl($F("globalPackParId"), null) == ""
								|| nvl($F("globalPackParId"), null) == "0") {
							if($F("globalLineCd")=="SU" && $F("globalParType")=="E") {
								//$("endtInformation").value = changeSingleAndDoubleQuotes(nvl(objSearchEndtText[a].endtText,"")); // replaced by: Nica 07.20.2012
								$("endtInformation").value = unescapeHTML2(nvl(objSearchEndtText[a].endtText,""));
							} else {
								//$("endtInformation").value = changeSingleAndDoubleQuotes(nvl(objSearchEndtText[a].endtText,""));
								$("endtInformation").value = unescapeHTML2(nvl(objSearchEndtText[a].endtText,""));
							}
						} else {
							//$("endtInformation").value = changeSingleAndDoubleQuotes(nvl(objSearchEndtText[a].endtText,""));
							$("endtInformation").value = unescapeHTML2(nvl(objSearchEndtText[a].endtText,""));
						}
						objUW.hidObjGIPIS002.endtCd = unescapeHTML2(nvl(objSearchEndtText[a].endtCd,"")); //Modified by Jerome 09.08.2016 SR 5648
						$("endtInformation").focus();
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