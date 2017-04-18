<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- 
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="">Additional Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
 -->
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table align="center" width="100%;" border="0" style="margin-top:10px;">
			<tr>
				<td class="rightAligned" style="width:20%;">No. of Person </td>
				<td class="leftAligned" colspan="3" style="width: 20%;">
					<input id="noOfPerson" name="noOfPerson" type="text" style="width: 180px; text-align:right;" maxlength="12" class="integerNoNegative" errorMsg="Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999." />
				</td>
				<td rowspan="6"  style="width: 16%;">
					<table border="0" align="center" style="width: 160px; margin-left: 0;">
						<tr align="center">
							<td>
							<input type="button" id="btnGroupedItems" style="width: 160px;"  name="btnGroupedItems" 	     class="button" value="Grouped Items"/>
							</td>
						</tr>
						<tr align="center">
							<td>
							<input type="button" id="btnPersonalAddtlInfo"	style="width: 160px;" name="btnPersonalAddtlInfo"  class="button" value="Personal Additional Info" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Occupation </td>
				<td class="leftAligned" colspan="3">
					<select  id="positionCd" name="positionCd" style="width: 494px">
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
					<input id="destination" name="destination" type="text" style="width: 486px" maxlength="500"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Salary </td>
				<td class="leftAligned" ><input id="monthlySalary" name="monthlySalary" type="text" style="width: 180px;" maxlength="14" class="money"/></td>
				<td class="rightAligned" style="width:81px;">Salary Grade </td>
				<td class="leftAligned" ><input id="salaryGrade" name="salaryGrade" type="text" style="width: 179px;" maxlength="3"/></td>
			</tr>
			<tr>
				<td>
					<input id="deleteGroupedItemsInItem" name="deleteGroupedItemsInItem" type="hidden" value="" />	
				</td>
		</table>
		<div style="width: 100%;margin-bottom: 10px; margin-top: 20px;">
			<input type="button" style="width: 100px; margin-left: 353px;" id="btnSaveItem" class="button" value="Add" />
			<input type="button" style="width: 100px;" id="btnDelete" class="disabledButton" value="Delete" disabled="disabled" />
		</div>
	</div>
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	disableButton("btnGroupedItems");
	enableButton("btnPersonalAddtlInfo");
	//$("personalAdditionalInfoDetail").hide();
	//$("personalAdditionalInformationInfo").hide();
	//$("showPersonalAdditionalInfo").update("Show"); 

	$("btnPersonalAddtlInfo").observe("click", function () {
		if ($("positionCd").value == ""){
			showMessageBox("Please select an Occupation first.", imgMessage.ERROR);
			return false;
		} else{
			if ($F("itemNo") != ""){
				if ($F("addInfoSw") == "Y"){
					showOverlayContent(contextPath+"/GIPIWAccidentItemController?action=showPersonalAdditionalInfoOverlay&globalParId="+$F("globalParId")+"&itemNo="+$F("itemNo"), 
							"Personal Additional Information", overlayOnComplete, 200, 200, 20);
					//$("addInfoSw").value = "N";
				} else {
					getAdditionalInfoInput();
				}			
			} else {
				showOverlayContent(contextPath+"/pages/underwriting/endt/accident/pop-ups/accidentEndtPersonalAdditionalInfo.jsp", "Personal Additional Information", overlayOnComplete, 200, 200, 20);
			}		
			resizeOverlayToContent(200);
		}	
	});

	function getAdditionalInfoInput(){
		showOverlayContent(contextPath+"/GIPIWAccidentItemController?action=showPersonalAdditionalInfoOverlay&globalParId="+$F("globalParId")+"&itemNo="+$F("itemNo"), 
				"Personal Additional Information", overlayOnComplete, 200, 200, 20);
	}
	
	$("noOfPerson").observe("blur", function () {
		if (parseInt($F("noOfPerson").replace(/,/g, "")) > 999999999999 || parseInt($F("noOfPerson").replace(/,/g, "")) < 1){
			showMessageBox("Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999.", imgMessage.ERROR);
			$("noOfPerson").value = "";
			return false;
		}

		$$('div#itemTable div[name="row"]').each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				id = row.readAttribute("id");
				if (row.down("input",31).value.replace(/,/g, "") != $F("noOfPerson").replace(/,/g, "")){
					if (parseInt(row.down("input",31).value) > 1){
						if (row.down("input",36).value != "Y"){
							if ($F("deleteGroupedItemsInItem") != "Y"){
								if ($F("itemWgroupedItemsExist") == "Y"){
									showConfirmBox("Message", "No of Persons can be changed using the Group Items window. If you change the No of Persons now, current information in group items will be deleted, do you want to continue?",  
											"Yes", "No", onOkFunc, onCancelFunc);
								}
							}
						}
					} else{
						if ($F("hidDateOfBirth") != "" || $F("hidSex") != "" || $F("hidAge") != "" || $F("hidHeight") != "" || $F("hidCivilStatus") != "" || $F("hidWeight") != ""){
							showConfirmBox("Message", "Changing No of Persons will delete personal additional information , do you want to continue?",  
									"Yes", "No", onOkFunc2, onCancelFunc2);
						}
					}	
				}	
			}
			function onOkFunc(){
				$("deleteGroupedItemsInItem").value = "Y";
				$("positionCd").selectedIndex = 0;
				//enableButton("btnPersonalAddtlInfo");
				//disableButton("btnGroupedItems");
				//$("personalAdditionalInfoDetail").show();
				//$("personalAdditionalInformationInfo").hide();
				//$("showPersonalAdditionalInfo").update("Show");
			}
			function onCancelFunc(){
				$("noOfPerson").value = (row.down("input",31).value == "" ? "" :formatNumber(row.down("input",31).value));
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				//$("personalAdditionalInfoDetail").hide();
				//$("personalAdditionalInformationInfo").hide();
				//$("showPersonalAdditionalInfo").update("Show");
			}
			function onOkFunc2(){
				$("positionCd").selectedIndex = 0;
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				//$("personalAdditionalInfoDetail").hide();
				//$("personalAdditionalInformationInfo").hide();
				//$("showPersonalAdditionalInfo").update("Show");
				$("hidDateOfBirth").value = "";
				$("hidAge").value = "";
				$("hidCivilStatus").value = "";
				$("hidSex").value = "";
				$("hidHeight").value = "";
				$("hidWeight").value = "";
			}	
			function onCancelFunc2(){
				$("noOfPerson").value = (row.down("input",31).value == "" ? "" :formatNumber(row.down("input",31).value));
				enableButton("btnPersonalAddtlInfo");
				disableButton("btnGroupedItems");
			}
		});

		if (parseInt($F("noOfPerson").replace(/,/g, "")) >1){
			enableButton("btnGroupedItems");
			disableButton("btnPersonalAddtlInfo");	
			$("monthlySalary").disable();
			$("salaryGrade").disable();
			$("monthlySalary").clear();
			$("salaryGrade").clear();
			//$("personalAdditionalInfoDetail").hide();
			//$("personalAdditionalInformationInfo").hide();
			//$("showPersonalAdditionalInfo").update("Show");
		} else{
			enableButton("btnPersonalAddtlInfo");
			disableButton("btnGroupedItems");
			$("monthlySalary").enable();
			$("salaryGrade").enable();
			//$("personalAdditionalInfoDetail").show();
			//$("personalAdditionalInformationInfo").hide();
			//$("showPersonalAdditionalInfo").update("Show");
		}
	});

	$("monthlySalary").observe("blur", function() {
		if (parseFloat($F('monthlySalary').replace(/,/g, "")) < 0) {
			showMessageBox("Entered Salary is invalid. Valid value is from 0 - 9,999,999,999.99.", imgMessage.ERROR);
			$("monthlySalary").focus();
			$("monthlySalary").value = "";
		} else if (parseFloat($F('monthlySalary').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Salary is invalid. Valid value is from 0 - 9,999,999,999.99.", imgMessage.ERROR);
			$("monthlySalary").focus();
			$("monthlySalary").value = "";
		}		
	});

	$("btnGroupedItems").observe("click", function () {
		if ($F("tempItemNumbers") == "" && $F("tempBeneficiaryItemNos") == "" && $F("tempDeductibleItemNos") == "" && $F("tempPerilItemNos") == ""){
			var exist = "N";
			var newItemNo = 0;

			if ($F("copiedItemNo") == "") {
				newItemNo = $F("itemNo");
			} else {
				newItemNo = $F("copiedItemNo");
			}
			
			$$('div#itemTable div[name="row"]').each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					exist = "Y";
					if (row.down("input",31).value.replace(/,/g, "") == $F("noOfPerson").replace(/,/g, "")){
						window.scrollTo(0,0);
						showAccidentEndtGroupedItemsModal($F("globalParId"),$F("itemNo"),"");
					} else{
						showMessageBox("Please save the item first.", imgMessage.ERROR);
						return false;
					}
				}		
			});
			if (exist == "N"){
				showMessageBox("Please save the item first.", imgMessage.ERROR);
				return false;
			}	
		} else{
			showMessageBox("Please save the item first.", imgMessage.ERROR);
			return false;
		}	
	});
</script>
