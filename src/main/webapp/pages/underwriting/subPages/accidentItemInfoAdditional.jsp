<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true">
		<table align="center" width="580px;" border="0" style="margin-top:10px;">
			<tr>
				<td class="rightAligned" style="width:100px;">No. of Person </td>
				<td class="leftAligned" colspan="3">
					<input id="noOfPerson" name="noOfPerson" type="text" style="width: 180px; text-align:right;" maxlength="12" class="integerNoNegative" errorMsg="Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999." />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Occupation </td>
				<td class="leftAligned" colspan="3">
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
				<input type="button" id="btnGroupedItems"	    name="btnGroupedItems" 	     class="button" value="Grouped Items" />					
				<input type="button" id="btnPersonalAddtlInfo"	name="btnPersonalAddtlInfo"  class="button" value="Personal Additional Info" />
			</td></tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAdd" 	class="button" 			value="Add" />
					<input type="button" id="btnDelete" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	disableButton("btnGroupedItems");
	enableButton("btnPersonalAddtlInfo");
	$("personalAdditionalInfoDetail").hide();
	$("personalAdditionalInformationInfo").hide();
	$("showPersonalAdditionalInfo").update("Show"); 
	
	$("btnGroupedItems").observe("click", function () {
		if ($F("tempItemNumbers") == "" && $F("tempBeneficiaryItemNos") == "" && $F("tempDeductibleItemNos") == "" && $F("tempPerilItemNos") == ""){
			var exist = "N";
			$$('div#itemTable div[name="rowItem"]').each(function (row)	{
				if (row.hasClassName("selectedRow")){
					exist = "Y"; 
					if (row.down("input",31).value.replace(/,/g, "") == $F("noOfPerson").replace(/,/g, "")){
						window.scrollTo(0,0); 
						showAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
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

	$("btnPersonalAddtlInfo").observe("click", function () {
		if ($("positionCd").value == ""){
			showMessageBox("Please select an Occupation first.", imgMessage.ERROR);
			return false;
		} else{
			$("personalAdditionalInfoDetail").show();
			Effect.toggle("personalAdditionalInformationInfo", "blind", {duration: .3});
			//$("personalAdditionalInformationInfo").show();
			$("showPersonalAdditionalInfo").update("Hide");
			
		}	
	});
		
	$("noOfPerson").observe("blur", function () {
		if (parseInt($F("noOfPerson").replace(/,/g, "")) > 999999999999 || parseInt($F("noOfPerson").replace(/,/g, "")) < 1){
			showMessageBox("Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999.", imgMessage.ERROR);
			$("noOfPerson").value = "";
			return false;
		}
		
		$$('div#itemTable div[name="rowItem"]').each(function (row)	{
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
						if ($F("pDateOfBirth") != "" || $F("pSex") != "" || $F("pAge") != "" || $F("pHeight") != "" || $F("pCivilStatus") != "" || $F("pWeight") != ""){
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
				$("personalAdditionalInfoDetail").show();
				$("personalAdditionalInformationInfo").hide();
				$("showPersonalAdditionalInfo").update("Show");
			}
			function onCancelFunc(){
				$("noOfPerson").value = (row.down("input",31).value == "" ? "" :formatNumber(row.down("input",31).value));
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				$("personalAdditionalInfoDetail").hide();
				$("personalAdditionalInformationInfo").hide();
				$("showPersonalAdditionalInfo").update("Show");
			}
			function onOkFunc2(){
				$("positionCd").selectedIndex = 0;
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				$("personalAdditionalInfoDetail").hide();
				$("personalAdditionalInformationInfo").hide();
				$("showPersonalAdditionalInfo").update("Show");
				$("pDateOfBirth").value = "";
				$("pAge").value = "";
				$("pCivilStatus").selectedIndex = 0;
				$("pSex").selectedIndex = 0;
				$("pHeight").value = "";
				$("pWeight").value = "";
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
			$("personalAdditionalInfoDetail").hide();
			$("personalAdditionalInformationInfo").hide();
			$("showPersonalAdditionalInfo").update("Show");
		} else{
			enableButton("btnPersonalAddtlInfo");
			disableButton("btnGroupedItems");
			$("monthlySalary").enable();
			$("salaryGrade").enable();
			$("personalAdditionalInfoDetail").show();
			$("personalAdditionalInformationInfo").hide();
			$("showPersonalAdditionalInfo").update("Show");
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

</script>		