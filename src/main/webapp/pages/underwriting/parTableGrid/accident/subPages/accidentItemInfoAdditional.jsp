<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true"> 
		<div changeTagAttr="true"> <!-- added by steven 8.22.2012 -->
			<table id="accidentsTable" align="center" width="580px;" cellspacing="1" border="0" style="margin-top: 10px;">
				<tr><td><br /></td></tr>
				<tr>
					<td class="rightAligned" style="width:100px;" for="noOfPerson">No. of Person </td>
					<td class="leftAligned" colspan="3">
						<!-- 
						<input tabindex="1501" id="noOfPerson" name="noOfPerson" type="text" style="width: 180px; text-align:right;" maxlength="12" min="1" max="999999999999"
							class="integerUnformattedOnBlur required" errorMsg="Entered No. of Person is invalid. Valid value is from 1 to 999,999,999,999." />
						 -->
						<input tabindex="1501" id="noOfPerson" name="noOfPerson" type="text" style="width: 180px; text-align:right;" maxlength="12" min="1" max="999999999999"
							class="applyWholeNosRegExp required" regExpPatt="pDigit12" hasOwnBlur="Y" hasOwnChange="Y" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Occupation </td>
					<td class="leftAligned" colspan="3">
						<input type="hidden" id="hidPosition" name="hidPosition" value="" />
						<select tabindex="1502" id="positionCd" name="positionCd" style="width: 470px">
							<option value=""></option>
							<c:forEach var="positionCds" items="${positionListing}">
								<option value="${positionCds.positionCd}">${fn:escapeXml(positionCds.position)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned" colspan="3">
						<input tabindex="1503" id="destination" name="destination" type="text" style="width: 462px" maxlength="50"/>	<!-- changed maxlength from 500 to 50 - Gzelle 09222014 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" for="monthlySalary">Salary </td>
					<td class="leftAligned" >
						<!-- 
						<input tabindex="1504" id="monthlySalary" name="monthlySalary" type="text" style="width: 180px;" maxlength="14" class="money2" min="0.01" max="9999999999.99" errorMsg="Invalid Salary. Valid value is from 0.01 to 9,999,999,999.99."/>
						 -->
						<input tabindex="1504" id="monthlySalary" name="monthlySalary" type="text" style="width: 180px;" maxlength="14" class="applyDecimalRegExp" regExpPatt="pDeci1002" min="0.01" max="9999999999.99" />
					</td>
					<td class="rightAligned" style="width:81px;">Salary Grade </td>
					<td class="leftAligned" >
						<input tabindex="1505" id="salaryGrade" name="salaryGrade" type="text" style="width: 180px;" maxlength="3"/>
					</td>
				</tr>
				<tr>
					<td>
						<input id="deleteGroupedItemsInItem" name="deleteGroupedItemsInItem" type="hidden" value="" />	
					</td>
				</tr>
			</table> 
		</div>	
		<table align="center" style="margin-bottom:10px;">
			<tr><td>
				<input type="hidden" id="isSaved" name="isSaved" value="" />
				<input tabindex="1506" type="button" id="btnGroupedItems"	    name="btnGroupedItems" 	     class="button" style="width: 150px;" value="Grouped Items" />					
				<input tabindex="1507" type="button" id="btnPersonalAddtlInfo"	name="btnPersonalAddtlInfo"  class="button" style="width: 150px;" value="Personal Additional Info" />
			</td></tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input tabindex="1508" type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input tabindex="1509" type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<input id="itemToDate" type="hidden"/>
<input id="itemFromDate" type="hidden"/>
<input id="itemProrateFlag" type="hidden"/>
<input id="itemCompSw" type="hidden"/>
<input id="itemShortRtPercent" type="hidden"/>
<script type="text/javascript">
try{
	disableButton("btnGroupedItems");
	enableButton("btnPersonalAddtlInfo");
	
	$("noOfPerson").observe("focus", function(){
		objFormVariables.varNoOfPerson = $F("noOfPerson");
	});
	
	function validateNoOfPerson(m){
		try{
			function updateFields(){
				if(!($F("noOfPerson").empty()) && $F("noOfPerson") > 1){
					$("monthlySalary").setAttribute("readonly", "readonly");			
					$("salaryGrade").setAttribute("readonly", "readonly");
					disableButton("btnPersonalAddtlInfo");
					enableButton("btnGroupedItems");
				}else{
					$("monthlySalary").removeAttribute("readonly");
					$("salaryGrade").removeAttribute("readonly");
					disableButton("btnGroupedItems");
					enableButton("btnPersonalAddtlInfo");
				}
			}
			
			if(!((m.value).empty())){
				if(isNaN(parseInt((m.value).replace(/,/g, "")))){
					m.value = "";
					customShowMessageBox(getNumberFieldErrMsg(m, false), imgMessage.ERROR, m.id);
				}else{
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						customShowMessageBox(getNumberFieldErrMsg(m, false), imgMessage.ERROR, m.id);
						return false;
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						customShowMessageBox(getNumberFieldErrMsg(m, false), imgMessage.ERROR, m.id);
						return false;
					}else{
						m.value = removeLeadingZero((m.value).replace(/,/g, ""));
						
						var groupedItems = objGIPIWGroupedItems.filter(function(obj){ return obj.itemNo == $F("itemNo"); }).length;
						
						if((objFormVariables.varNoOfPerson != "") && (objFormVariables.varNoOfPerson != $F("noOfPerson"))){
							var message = "";
							if(objFormVariables.varNoOfPerson > 1){
								message = "No of Persons can be changed using the Group Items window. If you " + 
									"change the No of Persons now, current information in group items will " + 
									"be deleted, do you want to continue?";
							}else{
								message = "Changing No of Persons will delete personal additional information , do you want to continue?";
							}
							
							showConfirmBox("Change No. of Persons", message, "Ok", "Cancel",
								function(){
									if(objFormVariables.varNoOfPerson > 1){
										objFormMiscVariables.miscChangeNoOfPerson = "Y";
										$("positionCd").value 		= "";
									}else{
										$("positionCd").value 		= "";
										//$("destination").value		= "";
										$("monthlySalary").value	= "";
										$("salaryGrade").value		= "";
										$("pDateOfBirth").value		= "";
										$("pSex").value				= "";
										$("pAge").value				= "";
										$("pCivilStatus").value		= "";
										$("pHeight").value			= "";
										$("pWeight").value			= "";
									}
									updateFields();
							}, function(){
								$("noOfPerson").value = objFormVariables.varNoOfPerson;
								updateFields();
							});
						}else{
							updateFields();
						}
						
						$("noOfPerson").setAttribute("lastValidValue", m.value);
					}
				}
			}			
		}catch(e){
			showErrorMessage("validateNoOfPerson", e);
		}
	}
	
	$("noOfPerson").observe("change", function(){
		validateNoOfPerson($("noOfPerson"));
	});
	
	$("noOfPerson").observe("blur", function(){
		validateNoOfPerson($("noOfPerson"));		
	});
	
	$("btnGroupedItems").observe("click", function(){
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		if($$("div#itemInformationDiv [changed=changed]").length > 0 ||
            (objGIPIWItem.filter(function(o){return o.recordStatus == -1 || o.recordStatus == 0 || o.recordStatus == 1;}).length > 0)){ //marco - 06.04.2013 - SR 13315
            showMessageBox("Please save changes first.", imgMessage.INFO);
            return false;
        }
		
		if($F("noOfPerson") > 1){
			$("itemToDate").value = objCurrItem.strToDate;
			$("itemFromDate").value = objCurrItem.strFromDate;
			$("itemCompSw").value = objCurrItem.compSw;
			$("itemShortRtPercent").value = objCurrItem.shortRtPercent;
			$("itemProrateFlag").value = objCurrItem.prorateFlag;
			/* Modalbox.show(contextPath+"/GIPIWAccidentItemController?action=showACGroupedItemsTableGrid&parId="+parId+
					"&itemNo="+$F("itemNo"), {	//}+"&isFromOverwriteBen="+isFromOverwriteBen, {
				title: "Additional Information",
				overlayClose : false,
				headerClose : false,
				width : 910,
				asynchronous : false
			}); */
			
			try {
				overlayGroupedItems = Overlay.show(contextPath
						+ "/GIPIWAccidentItemController", {
					urlContent : true,
					urlParameters : {
						action : "showACGroupedItemsTableGrid",
						ajax : "1",
						parId : parId,
						itemNo: $F("itemNo")
						},
					title : "Additional Information",
					 height: 500,
					 width: 902,
					draggable : true
				}); 
			} catch (e) {
				showErrorMessage("showGroupedItems", e);
			}
		}
	});
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);
}
</script>