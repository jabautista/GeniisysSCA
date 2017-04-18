<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" changeTagAttr="true" masterDetail="true">
		
		<table id="accidentsTable" align="center" width="580px;" cellspacing="1" border="0" style="margin-top: 10px;">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width:100px;">No. of Person </td>
				<td class="leftAligned" colspan="3">
					<input id="noOfPerson" name="noOfPerson" type="text" style="width: 180px; text-align:right;" maxlength="12" 
						class="integerNoNegativeUnformatted required" errorMsg="Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999." />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Occupation </td>
				<td class="leftAligned" colspan="3">
					<input type="hidden" id="hidPosition" name="hidPosition" value="" />
					<select  id="positionCd" name="positionCd" style="width: 470px">
						<option value=""></option>
						<c:forEach var="positionCds" items="${positionListing}">
							<option value="${positionCds.positionCd}">${positionCds.position}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned" colspan="3">
					<input id="destination" name="destination" type="text" style="width: 462px" maxlength="500"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Salary </td>
				<td class="leftAligned" ><input id="monthlySalary" name="monthlySalary" type="text" style="width: 180px;" maxlength="14" class="money"/></td>
				<td class="rightAligned" style="width:81px;">Salary Grade </td>
				<td class="leftAligned" ><input id="salaryGrade" name="salaryGrade" type="text" style="width: 180px;" maxlength="3"/></td>
			</tr>
			<tr>
				<td>
					<input id="deleteGroupedItemsInItem" name="deleteGroupedItemsInItem" type="hidden" value="" />	
				</td>
			</tr>
		</table> 	
		
		<table align="center" style="margin-bottom:10px;">
			<tr><td>
				<input type="hidden" id="isSaved" name="isSaved" value="" />
				<input type="button" id="btnGroupedItems"	    name="btnGroupedItems" 	     class="button" value="Grouped Items" />					
				<input type="button" id="btnPersonalAddtlInfo"	name="btnPersonalAddtlInfo"  class="button" value="Personal Additional Info" />
			</td></tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
//	initializeChangeTagAtrBehavior();

	disableButton("btnGroupedItems");
	enableButton("btnPersonalAddtlInfo");

	$("noOfPerson").observe("blur", function() {
		var num = isNaN($F("noOfPerson")) ? "" : parseInt($F("noOfPerson"));
		if(isNaN(num) || num <= 1) {
			enableButton($("btnPersonalAddtlInfo"));
			disableButton($("btnGroupedItems"));
		} else {
			disableButton($("btnPersonalAddtlInfo"));
			enableButton($("btnGroupedItems"));
		}
	});

	$("btnGroupedItems").observe("click", function () {
		var isSaved = $F("isSaved");
		var exists = false;
		$$("div#parItemTableContainer div[name='row']").each(function (row) {
			if(row.hasClassName("selectedRow")) {
				exists = true;
				//var itemNum = row.down("input", 0).value;
				if(parseInt($F("noOfPerson")) > 1) {
					if(isSaved == "1") {
						showMessageBox("Please save first...");
					} else {
						showAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
						//showACGroupedItemsModal($F("globalParId"),parseInt($F("itemNo")),"");
						//showACGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),parseInt($F("itemNo")),"");
					}
				}
			} 
		});
		if(!exists) {
			showMessageBox("Please add/update the item first...");
		}
	});

	function showACGroupedItemsModal(globalParId,itemNo,isFromOverwriteBen) {
		Modalbox.show(contextPath+"/GIPIWAccidentItemController?action=showACGroupedItems&globalParId="+globalParId+
				"&itemNo="+itemNo+"&isFromOverwriteBen="+isFromOverwriteBen, {
			title: "Additional Information",
			width: 910,
			asynchronous:false
		});
	}

	/*
	function showAccidentGroupedItemsModal(globalParId,itemNo,isFromOverwriteBen){
	Modalbox.show(contextPath+"/GIPIWAccidentItemController?action=showAccidentGroupedItemsModal&globalParId="+globalParId+"&itemNo="+itemNo+"&isFromOverwriteBen="+isFromOverwriteBen, {
		title: "Additional Information",
		width: 910,
		asynchronous:false
	});
}
	*/

	$("btnPersonalAddtlInfo").observe("click", function () {
		if ($("positionCd").value == ""){
			showMessageBox("Please select an Occupation first.", imgMessage.ERROR);
			return false;
		} else{
			$("personalAdditionalInfoDetail").show();
			Effect.toggle("personalAdditionalInformationInfo", "blind", {duration: .3});
			$("personalAdditionalInformationInfo").show();
			$("showPersonalAdditionalInfo").update("Hide");
			
		}	
	});
</script>