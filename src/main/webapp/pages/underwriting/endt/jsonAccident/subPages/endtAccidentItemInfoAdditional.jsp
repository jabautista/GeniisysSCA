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
						class="integerUnformatted required" errorMsg="Entered No. of Person is invalid."
						oldValue=""/>
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
	
	$("noOfPerson").observe("focus", function(){
		$("noOfPerson").setAttribute("oldValue", $F("noOfPerson"));
	});
	
	$("noOfPerson").observe("change", function() {
		var num = isNaN($F("noOfPerson")) ? "" : parseInt($F("noOfPerson"));
		var cnt = checkGroupedItems();
		var oldValue = parseInt($("noOfPerson").getAttribute("oldValue"));
		var nop = validateNoOfPersons();

		if($F("noOfPerson") < 0 && Math.abs($F("noOfPerson")) > nop){
			showWaitingMessageBox("No of persons should not be less than " + nop + ".", "I", function(){
				$("noOfPerson").value = oldValue;
			});
		}else if(oldValue > 1 && ($F("deleteGroupedItemsInItem") != "Y" ? nvl(cnt, 0) > 0 : true)){
			showConfirmBox("Confirmation", "No of Persons can be changed using the Group Items window. If you change the " +
				"No of Persons now, current information in group items will be deleted, do you want to continue?", "Ok", "Cancel", 
				function(){
					$("deleteGroupedItemsInItem").value = "Y";
					$("positionCd").selectedIndex = 0;
					if(isNaN(num) || num <= 1) {
						enableButton($("btnPersonalAddtlInfo"));
						disableButton($("btnGroupedItems"));
					} else {
						disableButton($("btnPersonalAddtlInfo"));
						enableButton($("btnGroupedItems"));
					}
				},
				function(){
					$("noOfPerson").value = oldValue;
				}, "");
		}else if(oldValue <= 1 && checkPersonalInfo()){
			showConfirmBox("Confirmation", "Changing No of Persons will delete personal additional information, " + 
				"do you want to continue?", "Ok", "Cancel", 
				function(){
					$("pDateOfBirth").value = "";
					$("pAge").value = "";
					$("pCivilStatus").selectedIndex = 0;
					$("pSex").selectedIndex = 0;
					$("pHeight").value = "";
					$("pWeight").value = "";
					$("positionCd").selectedIndex = 0;
					$("monthlySalary").value = "";
					$("salaryGrade").value = "";
					
					if(isNaN(num) || (num <= 1 && nop <= 0)) {	//modified by Gzelle 10072014
						enableButton($("btnPersonalAddtlInfo"));
						disableButton($("btnGroupedItems"));
					} else {
						disableButton($("btnPersonalAddtlInfo"));
						enableButton($("btnGroupedItems"));
					}
				},
				function(){
					$("noOfPerson").value = oldValue;
				}, "");
		}else{
			if(isNaN(num) || (num <= 1 && nop <= 0)) {	//modified by Gzelle 10072014
				enableButton($("btnPersonalAddtlInfo"));
				disableButton($("btnGroupedItems"));
			} else {
				disableButton($("btnPersonalAddtlInfo"));
				enableButton($("btnGroupedItems"));
			}
		}
	});
	
	$("btnGroupedItems").observe("click", function () {
		//var isSaved = $F("isSaved");
		//var exists = false;
		var polFlag = nvl($("globalPolFlag"), null) != null ? $("globalPolFlag").value : "";
		// added changeTag irwin 11.22.2011
		
		if(changeTag == 1 && polFlag != "4"){
			showMessageBox("Please save changes first before pressing the GROUP ITEM button.");
		}else{
			$$("div#parItemTableContainer div[name='row']").each(function (row) {
				if(row.hasClassName("selectedRow")) {
					//showEndtAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
					objUW.showEndtAccidentGroupedItemsOverlay(); //marco - 09.06.2012 - replace with function above to revert to old grouped items modal window
				}
			});
		}
		/*
		$$("div#parItemTableContainer div[name='row']").each(function (row) {
			if(row.hasClassName("selectedRow")) {
				exists = true;
				//var itemNum = row.down("input", 0).value;
				if(parseInt($F("noOfPerson")) > 1) {
					if(isSaved == "1") {
						showMessageBox("Please save first...");
					} else {
						showEndtAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
						//showACGroupedItemsModal($F("globalParId"),parseInt($F("itemNo")),"");
						//showACGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),parseInt($F("itemNo")),"");
					}
				}
			} 
		});
		if(!exists) {
			showMessageBox("Please add/update the item first...");
		}*/
	});


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
	
	//marco - 09.06.2012 - new grouped items overlay
	function showEndtAccidentGroupedItemsOverlay(){
		groupedItemsOverlay = Overlay.show(contextPath+"/GIPIWGroupedItemsController", {
			urlParameters: {
				action : "getGroupedItemsListing",
				parId  : objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"),
				itemNo : $F("itemNo")
			},
			urlContent : true,
			draggable: true,
		    title: "Grouped Items",
		    height: 575,
		    width: 932
		});
	}
	objUW.showEndtAccidentGroupedItemsOverlay = showEndtAccidentGroupedItemsOverlay;
	
	function checkGroupedItems(){
		var result = "";
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=checkGroupedItems",{
			parameters : {
				parId  : objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"),
				itemNo : $F("itemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					result = response.responseText;
				}
			}
		});
		return result;
	}
	
	function validateNoOfPersons(){
		var result = "";
		new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateNoOfPersons",{
			parameters : {
				lineCd    : objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"),
				sublineCd : objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"),
				issCd 	  : $F("globalIssCd"),
				issueYy   : $F("globalIssueYy"),
				polSeqNo  : $F("globalPolSeqNo"),
				renewNo	  : $F("globalRenewNo"),
				itemNo 	  : $F("itemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					result =  response.responseText;
				}
			}
		});
		return result;
	}
	
	function checkPersonalInfo(){
		if($F("positionCd") != "" || $F("monthlySalary") != "" || $F("salaryGrade") != "" || $F("pSex") != "" || 
			$F("pDateOfBirth") != "" || $F("pAge") != "" || $F("pCivilStatus") != "" || $F("pHeight") != "" || $F("pWeight") != ""){
			return true;
		}
		return false;
	}
</script>