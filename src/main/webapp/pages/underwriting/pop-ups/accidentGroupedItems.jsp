<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
	<div id="groupedItemsInformationInfo" class="sectionDiv" style="display: block; width:872px; background-color:white; ">
		<jsp:include page="/pages/underwriting/subPages/accidentGroupedItemsListing.jsp"></jsp:include>
			<table align="center" border="0" style="margin-top:10px; margin-bottom:10px;">
				<tr>
					<td class="rightAligned" style="width:90px;">Enrollee Code </td>
					<td class="leftAligned" colspan="3">
						<input id="groupedItemNo" name="groupedItemNo" type="text" style="width: 215px;" maxlength="7" class="integerNoNegativeUnformattedNoComma required" errorMsg="Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Enrollee Name </td>
					<td class="leftAligned" colspan="3">
						<input id="groupedItemTitle" name="groupedItemTitle" type="text" style="width: 215px;" maxlength="50" class="required"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Principal Code </td>
					<td class="leftAligned" colspan="3">
						<input id="principalCd" name="principalCd" type="text" style="width: 215px;" maxlength="7" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Principal Code is invalid. Valid value is from 0000001 to 9999999"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Plan </td>
					<td class="leftAligned" >
						<select id="packBenCd" name="packBenCd" style="width: 223px">
						<option value=""></option>
						<c:forEach var="plans" items="${plans}">
							<option value="${plans.packBenCd}"
							<c:if test="${item.packBenCd == plans.packBenCd}">
								selected="selected"
							</c:if>>${plans.packageCd}</option>				
						</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Payment Mode </td>
					<td class="leftAligned" >
						<select id="paytTerms" name="paytTerms" style="width: 223px">
						<option value=""></option>
						<c:forEach var="payTerms" items="${payTerms}">
							<option value="${payTerms.paytTerms}"
							<c:if test="${item.paytTerms == payTerms.paytTerms}">
								selected="selected"
							</c:if>>${payTerms.paytTermsDesc}</option>				
						</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Effectivity Date </td>
					<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
			    		<input style="width: 80px; border: none;" id="grpFromDate" name="grpFromDate" type="text" value="" readonly="readonly"/>
			    		<img name="accModalDate" id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpFromDate'),this, null);" alt="From Date" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
			    		<input style="width: 80px; border: none;" id="grpToDate" name="grpToDate" type="text" value="" readonly="readonly"/>
			    		<img name="accModalDate" id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpToDate'),this, null);" alt="To Date" />
					</div>
					</td>
				</tr>				
			</table>
	</div>
	
	<div id="groupedItemsInformationInfo2" class="sectionDiv" style="display: block; width:872px; background-color:white; ">
		<table align="center" border="0" style="margin-top:10px; margin-bottom:10px;">
			<tr>
				<td class="rightAligned" >Sex </td>
				<td class="leftAligned" >
					<select  id="sex" name="sex" style="width: 223px">
						<option value=""></option>
						<option value="F">Female</option>
						<option value="M">Male</option>
					</select>
				</td>
				<td class="rightAligned" style="width:105px;">Control Type </td>
				<td class="leftAligned" >
					<select  id="controlTypeCd" name="controlTypeCd" style="width: 223px">
						<option value=""></option>
						<c:forEach var="controlTypes" items="${controlTypes}">
							<option value="${controlTypes.controlTypeCd}">${controlTypes.controlTypeDesc}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Birthday </td>
				<td class="rightAligned">
				<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px; margin-left:4px;">
			   		<input style="width: 80px; border: none;" id="dateOfBirth" name="dateOfBirth" type="text" value="" readonly="readonly"/>
			   		<img name="accModalDate" id="hrefBirthdayDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateOfBirth'),this, null);" alt="Birthday" style="margin-right:2px;"/>
				</div>
					Age
					<input id="age" name="age" type="text" style="width: 64px;" maxlength="3" class="integerNoNegativeUnformattedNoComma rightAligned" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
				</td>
				<td class="rightAligned" >Control Code </td>
				<td class="leftAligned" >
					<input id="controlCd" name="controlCd" type="text" style="width: 215px;" maxlength="250"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Civil Status </td>
				<td class="leftAligned" >
					<select  id="civilStatus" name="civilStatus" style="width: 223px">
						<option value=""></option>
						<c:forEach var="civilStats" items="${civilStats}">
							<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Salary </td>
				<td class="leftAligned" >
					<input id="salary" name="salary" type="text" style="width: 215px;" maxlength="14" class="money"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Occupation </td>
				<td class="leftAligned" >
					<select  id="positionCd" name="positionCd" style="width: 223px">
						<option value=""></option>
						<c:forEach var="positionCds" items="${positionListing}">
							<option value="${positionCds.positionCd}">${positionCds.position}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Salary Grade </td>
				<td class="leftAligned" >
					<input id="salaryGrade" name="salaryGrade" type="text" style="width: 215px;" maxlength="3"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Group </td>
				<td class="leftAligned" >
					<select  id="groupCd" name="groupCd" style="width: 223px">
						<option value=""></option>
						<c:forEach var="groups" items="${groups}">
							<option value="${groups.groupCd}"
							<c:if test="${item.groupCd == groups.groupCd}">
								selected="selected"
							</c:if>>${groups.groupDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Amount Covered </td>
				<td class="leftAligned" >
					<input id="amountCovered" name="amountCovered" type="text" style="width: 215px;" class="money" maxlength="18" readonly="readonly"/>
				</td>
			</tr>			
			<tr>
				<td>
					<input id="includeTag" 	name="includeTag" 	type="hidden" value="" maxlength="1" readonly="readonly"/>
					<input id="remarks" 	name="remarks" 		type="hidden" value=""/>
					<input id="lineCd" 		name="lineCd" 		type="hidden" value=""/>
					<input id="sublineCd" 	name="sublineCd" 	type="hidden" value=""/>
					<input id="deleteSw" 	name="deleteSw" 	type="hidden" value=""/>
					<input id="annTsiAmt" 	name="annTsiAmt" 	type="hidden" value="" class="money" maxlength="18"/>
					<input id="annPremAmt" 	name="annPremAmt" 	type="hidden" value="" class="money" maxlength="14"/>
					<input id="tsiAmt" 		name="tsiAmt" 		type="hidden" value="" class="money" maxlength="18"/>
					<input id="premAmt" 	name="premAmt" 		type="hidden" value="" class="money" maxlength="14"/>
					<input id="overwriteBen" 	name="overwriteBen" 	type="hidden" value=""/>
					<input id="itemSeqField" name="itemSeqField" type="hidden" />
				</td>
			</tr>
		</table>
		
		<table align="center" style="margin-bottom:10px;">
			<tr>
				<td class="rightAligned" style="text-align: left; padding-left: 3px;">
					<input type="button" class="button" 		id="btnUploadEnrollees" 	name="btnUploadEnrollees" 		value="Upload Enrollees" 		style="width: 117px;" />
					<input type="button" class="button" 		id="btnPopulateBenefits" 	name="btnPopulateBenefits" 		value="Populate Benefits" 		style="width: 117px;" />
					<input type="button" class="button" 		id="btnDeleteBenefits" 		name="btnDeleteBenefits" 		value="Delete Benefits" 		style="width: 102px;" />
					<input type="button" class="button" 		id="btnRenumber" 			name="btnRenumber" 				value="Renumber" 				style="width: 80px;" />
					<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 					style="width: 60px;" />
					<input type="button" class="button" 		id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 					style="width: 60px;" />
				</td>
			</tr>
		</table>
	</div>
	
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("packBenCd").observe("change", function () {
		var exists = false;
		if ($F("groupedItemNo") == "") {
			showMessageBox("Enrollee Code must be entered.", imgMessage.ERROR);
			exists = true;
		} else if ($F("groupedItemTitle") == "") {
			showMessageBox("Enrollee Name must be entered.", imgMessage.ERROR);
			exists = true;
		}
		$$("div[name='grpItem']").each( function(a)	{
			if (!a.hasClassName("selectedRow"))	{
				if (a.getAttribute("groupedItemNo") == $F("groupedItemNo") && a.getAttribute("groupedItemTitle") == $F("groupedItemTitle"))	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				} else if (a.getAttribute("groupedItemNo") == $F("groupedItemNo"))	{
					exists = true;
					showMessageBox("Enrollee Code must be unique.", imgMessage.ERROR);
				} else if (a.getAttribute("groupedItemTitle") == $F("groupedItemTitle"))	{
					exists = true;
					showMessageBox("Enrollee Name must be unique.", imgMessage.ERROR);
				}	
			}
		});
		if (!exists){
			showConfirmBox("Message", "Selecting/changing a plan will populate/overwrite perils for this grouped item. Would you like to continue?",  
					"Yes", "No", onOkFuncPopBen, onCancelFuncPopBen);
		} else{
			onCancelFuncPopBen();
		}	
	});	
	function onOkFuncPopBen(){
		var ctr = 0;
		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});
		if (ctr<2){
			$("newNoOfPerson").value = $("noOfPerson").value;
		} else{
			$("newNoOfPerson").value = ctr;
		}
		
		$("isFromOverwriteBen").value = "Y";
		$("overwriteBen").value = "Y";
		addGroupedItems();
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentGroupedItemsModal", {
			method : "POST",
			postBody : Form.serialize("accidentModalForm"),
			asynchronous : false,
			evalScripts : true,
			onCreate : 
				function(){
					$("accidentModalForm").disable();
					showNotice("Saving, please wait...");
				},
			onComplete :
				function(response){
					$("isSaved").value = "Y";
					$("tempSave").value = "";
					if (response.responseText == "SUCCESS"){
						hideNotice("SUCCESS, Refreshing page please wait...");	
						showAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"Y");
					} else{
						showMessageBox(response.responseText, imgMessage.ERROR);	
					}			
				}
		});	
	}	
	function onCancelFuncPopBen(){
		var p=0;
		$$("div[name='grpItem']").each(function(grp){
			if (grp.hasClassName("selectedRow")){
				$("packBenCd").value = grp.down("input",5).value;		
				p=1;
			}	
		});	
		if (p==0){
			$("packBenCd").selectedIndex = 0;
		}	
	}	
	
	$("controlCd").observe("blur", function () {
		var exist = "N";
		$$("div[name='grpItem']").each(function(grp){
			if (!grp.hasClassName("selectedRow")){
				if (grp.down("input",16).value == $F("controlCd") && grp.down("input",15).value == $F("controlTypeCd")){
					 exist = "Y";
				}	
			}	
			
		});	

		if (exist == "Y"){
			if ($F("controlCd") != "" && $F("controlTypeCd") != ""){
				showMessageBox("Control Code Already Exists. Re-enter value for control code.",imgMessage.ERROR);
				$("controlCd").value = "";
				return false;
			}
		}	
	});	
	
	var origGroupedItemNo = "";
	var fromDateFromItem = $F("fromDate");
	var toDateFromItem = $F("toDate");
	var packBenCdFromItem = $F("accidentPackBenCd");
/*	$$("div#itemTable div[name='rowItem']").each(function(a){
		if (a.hasClassName("selectedRow")){
			fromDateFromItem = a.down("input",14).value;
			toDateFromItem = a.down("input",15).value;
			packBenCdFromItem = a.down("input",27).value;
		}	
	});*/
	
	$("groupedItemNo").observe("blur", function () {
		
		if ($F("groupedItemNo") != ""){
			isNumber("groupedItemNo","Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.","");
			$("groupedItemNo").value = formatNumberDigits($F("groupedItemNo"),7);
			if ($F("groupedItemNo") < 1){
				showMessageBox("Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.",imgMessage.ERROR);
				$("groupedItemNo").value = "";
				$("groupedItemNo").focus();
				return false;
			}
			if (fromDateFromItem != ""){
				$("grpFromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("grpToDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("packBenCd").value = packBenCdFromItem;
			}	
		}	
	});

	$("groupedItemTitle").observe("blur", function () {
		if ($F("groupedItemNo") != ""){
			if (fromDateFromItem != ""){
				$("grpFromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("grpToDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("packBenCd").value = packBenCdFromItem;
			}
		}	
	});		

	$("principalCd").observe("blur", function () {
		if ($F("principalCd") != ""){
			isNumber("principalCd","Entered Principal Code is invalid. Valid value is from 0000001 to 9999999.","");
			$("principalCd").value = formatNumberDigits($F("principalCd"),7);
			if ($F("principalCd") == $F("groupedItemNo")){
				showMessageBox("Principal enrollee cannot be the same as enrollee.",imgMessage.ERROR);
				$("principalCd").value = "";
				$("principalCd").focus();
				return false;
			} else if ($F("principalCd") < 1){
				showMessageBox("Entered Principal Code is invalid. Valid value is from 0000001 to 9999999.",imgMessage.ERROR);
				$("principalCd").value = "";
				$("principalCd").focus();
				return false;
			} else{
				var exists = false;
				$$("div[name='grpItem']").each( function(a)	{
					if (a.getAttribute("groupedItemNo") == $F("principalCd"))	{
						exists = true;
					}	
				});
				if (!exists){
					showMessageBox("Non-existing enrollee could not be used as Principal enrollee.", imgMessage.ERROR);
					$("principalCd").value = "";
					$("principalCd").focus();
					return false;
				}
			}	
		}
	});

	$("age").observe("blur", function () {
		if (parseInt($F("age")) > 999 || parseInt($F("age")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("age").value ="";
			return false;
		} else{
			isNumber("age","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("dateOfBirth").observe("blur", function () {
		$("age").value = computeAge($("dateOfBirth").value);
		checkBday();
	});

	$("age").observe("blur", function () {
		if ($("dateOfBirth").value != ""){
			if ($("age").value != ""){
				$("age").value = computeAge($("dateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("dateOfBirth"));
		if (bday>today){
			$("dateOfBirth").value = "";
			$("age").value = "";
			hideNotice("");
		}	
	}

	$("salary").observe("blur", function() {
		if (parseFloat($F('salary').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered Salary is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("salary").focus();
			$("salary").value = "0.00";
		} else if (parseFloat($F('salary').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Salary is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("salary").focus();
			$("salary").value = "0.00";
		}		
	});

	$("amountCovered").observe("blur", function() {
		if (parseFloat($F('amountCovered').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCovered").focus();
			$("amountCovered").value = "0.00";
		} else if (parseFloat($F('amountCovered').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCovered").focus();
			$("amountCovered").value = "0.00";
		}
	});

	$("grpFromDate").observe("blur", function() {
		if(!($F("grpFromDate").empty()) && !($F("grpToDate").empty())){
			var grpFromDate = nvl($F("grpFromDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpFromDate")));
			var grpToDate = nvl($F("grpToDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpToDate")));
			var itemFromDate = nvl(fromDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(fromDateFromItem));
			var itemToDate = nvl(toDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(toDateFromItem));
			var iDate = nvl($F("wpolbasInceptDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasInceptDate"), "mm-dd-yyyy")));
			var eDate = nvl($F("wpolbasExpiryDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasExpiryDate"), "mm-dd-yyyy")));
			
			if(compareDatesIgnoreTime(grpFromDate, grpToDate) == -1){
				showMessageBox("Start of Effectivity date should not be earlier than the End of Effectivity date.");
				$("grpFromDate").value = "";
				$("grpFromDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpFromDate, iDate) == 1){
				showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.");
				$("grpFromDate").value = "";
				$("grpFromDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpFromDate, eDate) == -1){
				showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date.");
				$("grpFromDate").value = "";
				$("grpFromDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpFromDate, nvl(itemFromDate, grpFromDate)) == 1){
				showMessageBox("Start of Effectivity date should not be earlier than the Item Inception date.");
				$("grpFromDate").value = "";
				$("grpFromDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpFromDate, nvl(itemToDate, grpFromDate)) == -1){
				showMessageBox("Start of Effectivity date should not be later than the Item Expiry date.");
				$("grpFromDate").value = "";
				$("grpFromDate").focus();
				return false;
			}
		}
		/*
		var grpFromDate = nvl($F("grpFromDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpFromDate")));
		var grpToDate = nvl($F("grpToDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpToDate")));
		var itemFromDate = nvl(fromDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(fromDateFromItem));
		var itemToDate = nvl(toDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(toDateFromItem));
		var iDate = nvl($F("wpolbasInceptDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasInceptDate"), "mm-dd-yyyy")));
		var eDate = nvl($F("wpolbasExpiryDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasExpiryDate"), "mm-dd-yyyy")));
			
		if ((grpFromDate > grpToDate) && grpFromDate != "" && grpToDate != ""){
			showMessageBox("Start of Effectivity date should not be earlier than the End of Effectivity date.");
			$("grpFromDate").value = "";
			$("grpFromDate").focus();
			return false;				
		}
		if ((grpFromDate < iDate) && grpFromDate != "" && iDate != ""){
			showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.");
			$("grpFromDate").value = "";
			$("grpFromDate").focus();
			return false;
		}
		if ((grpFromDate > eDate) && grpFromDate != "" && eDate != ""){
			showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date.");
			$("grpFromDate").value = "";
			$("grpFromDate").focus();
			return false;
		}
		if ((grpFromDate < itemFromDate) && grpFromDate != "" && itemFromDate != ""){
			showMessageBox("Start of Effectivity date should not be earlier than the Item Inception date.");
			$("grpFromDate").value = "";
			$("grpFromDate").focus();
			return false;
		}
		if ((grpFromDate > itemToDate) && grpFromDate != "" && itemToDate != ""){
			showMessageBox("Start of Effectivity date should not be later than the Item Expiry date.");
			$("grpFromDate").value = "";
			$("grpFromDate").focus();
			return false;
		}	
		*/
	});

	$("grpToDate").observe("blur", function() {
		if(!($F("grpFromDate").empty()) && !($F("grpToDate").empty())){
			var grpFromDate = nvl($F("grpFromDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpFromDate")));
			var grpToDate = nvl($F("grpToDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpToDate")));
			var itemFromDate = nvl(fromDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(fromDateFromItem));
			var itemToDate = nvl(toDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(toDateFromItem));
			var iDate = nvl($F("wpolbasInceptDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasInceptDate"), "mm-dd-yyyy")));
			var eDate = nvl($F("wpolbasExpiryDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasExpiryDate"), "mm-dd-yyyy")));
			
			if(compareDatesIgnoreTime(grpToDate, grpFromDate) == 1){
				showMessageBox("End of Effectivity date should not be earlier than the Star of Effectivity date.");
				$("grpToDate").value = "";
				$("grpToDate").focus();		
				return false;
			}
			
			if(compareDatesIgnoreTime(grpToDate, iDate) == 1){
				showMessageBox("End of Effectivity date should not be earlier than the Policy Inception date.");
				$("grpToDate").value = "";
				$("grpToDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpToDate, eDate) == -1){
				showMessageBox("End of Effectivity date should not be later than the Policy Expiry date.");
				$("grpToDate").value = "";
				$("grpToDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpToDate, nvl(itemFromDate, grpToDate)) == 1){
				showMessageBox("End of Effectivity date should not be earlier than the Item Inception date.");
				$("grpToDate").value = "";
				$("grpToDate").focus();
				return false;
			}
			
			if(compareDatesIgnoreTime(grpToDate, nvl(itemToDate, grpToDate)) == -1){
				showMessageBox("End of Effectivity date should not be later than the Item Expiry date.");
				$("grpToDate").value = "";
				$("grpToDate").focus();
				return false;
			}
		}
		/*
		var grpFromDate = nvl($F("grpFromDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpFromDate")));
		var grpToDate = nvl($F("grpToDate"),"") == "" ? "" :ignoreDateTime(makeDate($F("grpToDate")));
		var itemFromDate = nvl(fromDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(fromDateFromItem));
		var itemToDate = nvl(toDateFromItem,"") == "" ? "" :ignoreDateTime(makeDate(toDateFromItem));
		var iDate = nvl($F("wpolbasInceptDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasInceptDate"), "mm-dd-yyyy")));
		var eDate = nvl($F("wpolbasExpiryDate"),"") == "" ? "" :ignoreDateTime(makeDate(dateFormat($F("wpolbasExpiryDate"), "mm-dd-yyyy")));

		if ((grpToDate < grpFromDate) && grpToDate != "" && grpFromDate != ""){
			showMessageBox("End of Effectivity date should not be earlier than the Star of Effectivity date.");
			$("grpToDate").value = "";
			$("grpToDate").focus();		
			return false;		
		}
		if ((grpToDate < iDate) && grpToDate != "" && iDate != ""){
			showMessageBox("End of Effectivity date should not be earlier than the Policy Inception date.");
			$("grpToDate").value = "";
			$("grpToDate").focus();
			return false;
		}
		if ((grpToDate > eDate) && grpToDate != "" && eDate != ""){
			showMessageBox("End of Effectivity date should not be later than the Policy Expiry date.");
			$("grpToDate").value = "";
			$("grpToDate").focus();
			return false;
		}
		if ((grpToDate < itemFromDate) && grpToDate != "" && itemFromDate != ""){
			showMessageBox("End of Effectivity date should not be earlier than the Item Inception date.");
			$("grpToDate").value = "";
			$("grpToDate").focus();
			return false;
		}
		if ((grpToDate > itemToDate) && grpToDate != "" && itemToDate != ""){
			showMessageBox("End of Effectivity date should not be later than the Item Expiry date.");
			$("grpToDate").value = "";
			$("grpToDate").focus();
			return false;
		}
		*/
	});

	$("btnAddGroupedItems").observe("click", function() {
		$("popBenDiv").hide();
		addGroupedItems();
	});

	$$("div[name='grpItem']").each(
			function (newDiv)	{
				loadRowMouseOverMouseOutObserver(newDiv);

				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='grpItem']").each(function (li)	{
							if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						
						var groupedItemNo = newDiv.down("input",2).value;	
						var groupedItemTitle = newDiv.down("input",3).value;	
						var principalCd = newDiv.down("input",4).value;	
						var packBenCd = newDiv.down("input",5).value;		
						var paytTerms = newDiv.down("input",6).value;	
						var grpFromDate = newDiv.down("input",7).value;	
						var grpToDate = newDiv.down("input",8).value;
						var sex = newDiv.down("input",9).value;
						var dateOfBirth = newDiv.down("input",10).value;
						var age = newDiv.down("input",11).value;
						var civilStatus = newDiv.down("input",12).value;
						var positionCd = newDiv.down("input",13).value;
						var groupCd = newDiv.down("input",14).value;
						var controlTypeCd = newDiv.down("input",15).value;
						var controlCd = newDiv.down("input",16).value;
						var salary = newDiv.down("input",17).value;
						var salaryGrade = newDiv.down("input",18).value;
						var amountCovered = newDiv.down("input",19).value;
						var includeTag = newDiv.down("input",20).value;
						var remarks = newDiv.down("input",21).value;
						var lineCd = newDiv.down("input",22).value;
						var sublineCd = newDiv.down("input",23).value;
						var deleteSw = newDiv.down("input",24).value;
						var annTsiAmt = newDiv.down("input",25).value;
						var annPremAmt = newDiv.down("input",26).value;
						var tsiAmt = newDiv.down("input",27).value;
						var premAmt = newDiv.down("input",28).value;
							
						$("groupedItemNo").value = formatNumberDigits(groupedItemNo,7);
						$("groupedItemTitle").value = groupedItemTitle;
						$("principalCd").value = (principalCd == "" ? "" :formatNumberDigits(principalCd,7));
						$("packBenCd").value = packBenCd;
						$("paytTerms").value = paytTerms;
						$("grpFromDate").value = grpFromDate;
						$("grpToDate").value = grpToDate;
						$("sex").value = sex;
						$("dateOfBirth").value = dateOfBirth;
						$("age").value = age;
						$("civilStatus").value = civilStatus;
						$("positionCd").value = positionCd;
						$("groupCd").value = groupCd;
						$("controlTypeCd").selectedIndex = 0;
						$("controlTypeCd").value = controlTypeCd;
						$("controlCd").value = controlCd;
						$("salary").value = salary;
						$("salaryGrade").value = salaryGrade;
						$("amountCovered").value = formatCurrency(amountCovered);
						$("includeTag").value = includeTag;
						$("remarks").value = remarks;
						$("lineCd").value = lineCd;
						$("sublineCd").value = sublineCd;
						$("deleteSw").value = deleteSw;
						$("annTsiAmt").value = annTsiAmt;
						$("annPremAmt").value = annPremAmt;
						$("tsiAmt").value = formatCurrency(tsiAmt);
						$("premAmt").value = formatCurrency(premAmt);

						setRecordListPerItem(true);
						generateSequenceItemInfo("benefit","bBeneficiaryNo","groupedItemNo",$F("groupedItemNo"),"nextItemNoBen2");
						getDefaults();
						//belle 05052011
						hideAllGroupedItemPerilOptions();
						selectGroupedItemPerilOptionsToShow(); 
						hideExistingGroupedItemPerilOptions(); 
					} else {
						clearForm();
					}
				}); 
				
			}	
	);	
	
	function addGroupedItems() {	
		try	{
			var gParId = $F("parId");
			var gItemNo = $F("itemNo");
			var gGroupedItemNo = $("groupedItemNo").value;
			var gGroupedItemTitle = changeSingleAndDoubleQuotes2($("groupedItemTitle").value);
			var gPrincipalCd = changeSingleAndDoubleQuotes2($("principalCd").value);
			var gPackBenCd = $("packBenCd").value;
			var gPaytTerms = $("paytTerms").value;
			var gFromDate = $("grpFromDate").value;
			var gToDate = $("grpToDate").value;
			var gSex = $("sex").value;
			var gDateOfBirth = $("dateOfBirth").value;
			var gAge = $("age").value;
			var gCivilStatus = $("civilStatus").value;
			var gPositionCd = $("positionCd").value;
			var gGroupCd = $("groupCd").value;
			var gControlTypeCd = $("controlTypeCd").value;
			var gControlCd = changeSingleAndDoubleQuotes2($("controlCd").value);
			var gSalary = $("salary").value;
			var gSalaryGrade = $("salaryGrade").value;
			var gAmountCovered = $("amountCovered").value;
			var gIncludeTag = ($("includeTag").value == "" ? "Y" : $("includeTag").value);
			var gRemarks = $("remarks").value;
			var gLineCd = ($("lineCd").value == "" ? (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $("globalLineCd").value) :$("lineCd").value);
			var gSublineCd = ($("sublineCd").value == "" ? (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $("globalSublineCd").value) :$("sublineCd").value);
			var gDeleteSw = $("deleteSw").value;
			var gAnnTsiAmt = $("annTsiAmt").value;
			var gAnnPremAmt = $("annPremAmt").value;
			var gTsiAmt = $("tsiAmt").value;
			var gPremAmt = $("premAmt").value;
			
			var gPlanDesc = changeSingleAndDoubleQuotes2($("packBenCd").options[$("packBenCd").selectedIndex].text);
			var gPaymentDesc = changeSingleAndDoubleQuotes2($("paytTerms").options[$("paytTerms").selectedIndex].text);
			var overwriteBen = $F("overwriteBen");
			
			var exists = false;
			
			if (gGroupedItemNo == "") {
				showMessageBox("Enrollee Code must be entered.", imgMessage.ERROR);
				exists = true;
			} else if (gGroupedItemTitle == "") {
				showMessageBox("Enrollee Name must be entered.", imgMessage.ERROR);
				exists = true;
			}	
			
			$$("div[name='grpItem']").each( function(a)	{
				if (!a.hasClassName("selectedRow"))	{
					if (a.getAttribute("groupedItemNo") == gGroupedItemNo && a.getAttribute("groupedItemTitle") == gGroupedItemTitle)	{
						exists = true;
						showMessageBox("Record already exists!", imgMessage.ERROR);
					} else if (a.getAttribute("groupedItemNo") == gGroupedItemNo)	{
						exists = true;
						showMessageBox("Enrollee Code must be unique.", imgMessage.ERROR);
					} else if (a.getAttribute("groupedItemTitle") == gGroupedItemTitle)	{
						exists = true;
						showMessageBox("Enrollee Name must be unique.", imgMessage.ERROR);
					}	
				}
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="grpParIds" 		     		name="grpParIds" 	        	value="'+gParId+'" />'+
			 	  			  '<input type="hidden" id="grpItemNos" 		     	name="grpItemNos" 	        	value="'+gItemNo+'" />'+ 
							  '<input type="hidden" id="grpGroupedItemNos"       	name="grpGroupedItemNos"     	value="'+gGroupedItemNo+'" />'+ 
						 	  '<input type="hidden" id="grpGroupedItemTitles"  	 	name="grpGroupedItemTitles"  	value="'+gGroupedItemTitle+'" />'+  
						 	  '<input type="hidden" id="grpPrincipalCds" 	 		name="grpPrincipalCds" 		 	value="'+gPrincipalCd+'" />'+ 
						 	  '<input type="hidden" id="grpPackBenCds" 				name="grpPackBenCds"  			value="'+gPackBenCd+'" />'+ 
						 	  '<input type="hidden" id="grpPaytTermss" 				name="grpPaytTermss" 			value="'+gPaytTerms+'" />'+ 
						 	  '<input type="hidden" id="grpFromDates"   			name="grpFromDates"  	 		value="'+gFromDate+'" />'+
						 	  '<input type="hidden" id="grpToDates"  	 			name="grpToDates" 	 			value="'+gToDate+'" />'+
						 	  '<input type="hidden" id="grpSexs"  	 				name="grpSexs" 	 				value="'+gSex+'" />'+
						 	  '<input type="hidden" id="grpDateOfBirths"  	 		name="grpDateOfBirths" 	 		value="'+gDateOfBirth+'" />'+
						 	  '<input type="hidden" id="grpAges"  	 				name="grpAges" 	 				value="'+gAge+'" />'+
						 	  '<input type="hidden" id="grpCivilStatuss"  	 		name="grpCivilStatuss" 	 		value="'+gCivilStatus+'" />'+
						 	  '<input type="hidden" id="grpPositionCds"  	 		name="grpPositionCds" 	 		value="'+gPositionCd+'" />'+
						 	  '<input type="hidden" id="grpGroupCds"  	 			name="grpGroupCds" 	 			value="'+gGroupCd+'" />'+
						 	  '<input type="hidden" id="grpControlTypeCds"  	 	name="grpControlTypeCds" 	 	value="'+gControlTypeCd+'" />'+
						 	  '<input type="hidden" id="grpControlCds"  	 		name="grpControlCds" 	 		value="'+gControlCd+'" />'+
						 	  '<input type="hidden" id="grpSalarys"  	 			name="grpSalarys" 	 			value="'+gSalary+'" />'+
						 	  '<input type="hidden" id="grpSalaryGrades"  	 		name="grpSalaryGrades" 	 		value="'+gSalaryGrade+'" />'+
						 	  '<input type="hidden" id="grpAmountCovereds"  	 	name="grpAmountCovereds" 	 	value="'+gAmountCovered+'" />'+
						 	  '<input type="hidden" id="grpIncludeTags"  	 		name="grpIncludeTags" 	 		value="'+gIncludeTag+'" />'+	
						 	  '<input type="hidden" id="grpRemarkss"  	 			name="grpRemarkss" 	 			value="'+gRemarks+'" />'+	
						 	  '<input type="hidden" id="grpLineCds"  	 			name="grpLineCds" 	 			value="'+gLineCd+'" />'+	
						 	  '<input type="hidden" id="grpSublineCds"  	 		name="grpSublineCds" 	 		value="'+gSublineCd+'" />'+	
						 	  '<input type="hidden" id="grpDeleteSws"  	 			name="grpDeleteSws" 	 		value="'+gDeleteSw+'" />'+	
						 	  '<input type="hidden" id="grpAnnTsiAmts"  	 		name="grpAnnTsiAmts" 	 		value="'+gAnnTsiAmt+'" />'+	
						 	  '<input type="hidden" id="grpAnnPremAmts"  	 		name="grpAnnPremAmts" 	 		value="'+gAnnPremAmt+'" />'+	
						 	  '<input type="hidden" id="grpTsiAmts"  	 			name="grpTsiAmts" 	 			value="'+gTsiAmt+'" />'+	
						 	  '<input type="hidden" id="grpPremAmts"  	 			name="grpPremAmts" 	 			value="'+gPremAmt+'" />'+	
						 	  '<input type="hidden" id="grpPlanDescs"  	 			name="grpPlanDescs" 		 	value="'+gPlanDesc+'" />'+
						 	  '<input type="hidden" id="grpPaymentDescs"  	 		name="grpPaymentDescs" 	 		value="'+gPaymentDesc+'" />'+
						 	  '<input type="hidden" id="grpOverwriteBens"  	 		name="grpOverwriteBens" 	 	value="'+overwriteBen+'" />'+
 
						 	  '<label name="textG" style="text-align: left; width: 10%; margin-right: 2px;">'+(gGroupedItemNo == "" ? "---" :gGroupedItemNo.truncate(10, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 12%; margin-right: 2px;">'+(gGroupedItemTitle == "" ? "---" :gGroupedItemTitle.truncate(15, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 11%; margin-right: 0px;">'+(gPrincipalCd == "" ? "---" :gPrincipalCd.truncate(10, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 8%;  margin-right: 4px;">'+(gPlanDesc == "" ? "---" :gPlanDesc.truncate(1, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 11%; margin-right: 2px;">'+(gPaymentDesc == "" ? "---" :gPaymentDesc.truncate(15, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 12%; margin-right: 3px;">'+(gFromDate == "" ? "---" :gFromDate.truncate(10, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 10%; margin-right: 2px;">'+(gToDate == "" ? "---" :gToDate.truncate(10, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 9%; margin-right: 2px; text-align:right;" class="money">'+(gTsiAmt == "" ? "---" :gTsiAmt.truncate(10, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 14%; text-align:right;" class="money">'+(gPremAmt == "" ? "---" :gPremAmt.truncate(10, "..."))+'</label>';

			   var content2 = '<input type="hidden" id="popParIds" 		     		name="popParIds" 	        	value="'+gParId+'" />'+
			 	  			  '<input type="hidden" id="popItemNos" 		     	name="popItemNos" 	        	value="'+gItemNo+'" />'+ 
							  '<input type="hidden" id="popGroupedItemNos"       	name="popGroupedItemNos"     	value="'+gGroupedItemNo+'" />'+ 
						 	  '<input type="hidden" id="popGroupedItemTitles"  	 	name="popGroupedItemTitles"  	value="'+gGroupedItemTitle+'" />'+  	
						 	  '<input type="hidden" id="popCheckSw"  	 	        name="popCheckSw"  	            value="Y" />'+ 	
						 	  '<label style="text-align: left; margin-right: 6px;"><input type="checkbox" id="popCheck" name="popCheck" checked="checked"/></label>'+	
							  '<label name="textG" id="num" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">'+(gGroupedItemNo == "" ? "---" :gGroupedItemNo.truncate(15, "..."))+'</label>'+
							  '<label name="textG" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">'+(gGroupedItemTitle == "" ? "---" :gGroupedItemTitle.truncate(15, "..."))+'</label>';			  	 
							  			    
				if ($F("btnAddGroupedItems") == "Update") {	
					origGroupedItemNo = getSelectedRowAttrValue("grpItem","groupedItemNo");
					if (origGroupedItemNo != $F("groupedItemNo")){
						if (getRowCountInTable("coverageTable","cov","groupedItemNo",origGroupedItemNo) > 0){
							showConfirmBox("Message", "Updating Enrollee Code will delete all existing records in Enrollee Coverage & Beneficiary Information, do you want to continue?",  
									"Yes", "No", onOkFunc, onCancelFunc);
						} else{
							$("rowGroupedItems"+gItemNo+origGroupedItemNo).update(content);
							$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
							$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
							$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("id","rowGroupedItems"+gItemNo+gGroupedItemNo);

							$("rowPopBens"+gItemNo+origGroupedItemNo).update(content2);
							$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
							$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
							$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("id","rowPopBens"+gItemNo+gGroupedItemNo); 
							var rowPopBenDiv = $("rowPopBens"+gItemNo+gGroupedItemNo);							

							loadRowMouseOverMouseOutObserver(rowPopBenDiv);

							rowPopBenDiv.down("input",5).observe("change", function()	{
								if (rowPopBenDiv.down("input",5).checked == true){
									rowPopBenDiv.down("input",4).value = "Y";
								} else{
									rowPopBenDiv.down("input",4).value = "N";
								}
							});

							rowPopBenDiv.down("label",1).observe("click", function()	{
								if (rowPopBenDiv.down("input",5).checked == true){
									rowPopBenDiv.down("input",5).checked = false;
									rowPopBenDiv.down("input",4).value = "N";
								} else{
									rowPopBenDiv.down("input",5).checked = true;
									rowPopBenDiv.down("input",4).value = "Y";
								}
							});
							rowPopBenDiv.down("label",2).observe("click", function()	{
								if (rowPopBenDiv.down("input",5).checked == true){
									rowPopBenDiv.down("input",5).checked = false;
									rowPopBenDiv.down("input",4).value = "N";
								} else{
									rowPopBenDiv.down("input",5).checked = true;
									rowPopBenDiv.down("input",4).value = "Y";
								}
							});
							
							$("tempSave").value = "Y";
							createDeleteGroupedItems(origGroupedItemNo);
							origGroupedItemNo = "";
							updateEnrolleeName();
							clearForm();
						}	
					} else{
						$("rowGroupedItems"+gItemNo+origGroupedItemNo).update(content);
						$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
						$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
						$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("id","rowGroupedItems"+gItemNo+gGroupedItemNo);

						$("rowPopBens"+gItemNo+origGroupedItemNo).update(content2);
						$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
						$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
						$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("id","rowPopBens"+gItemNo+gGroupedItemNo);
						var rowPopBenDiv = $("rowPopBens"+gItemNo+gGroupedItemNo);						

						loadRowMouseOverMouseOutObserver(rowPopBenDiv);

						rowPopBenDiv.down("input",5).observe("change", function()	{
							if (rowPopBenDiv.down("input",5).checked == true){
								rowPopBenDiv.down("input",4).value = "Y";
							} else{
								rowPopBenDiv.down("input",4).value = "N";
							}
						});

						rowPopBenDiv.down("label",1).observe("click", function()	{
							if (rowPopBenDiv.down("input",5).checked == true){
								rowPopBenDiv.down("input",5).checked = false;
								rowPopBenDiv.down("input",4).value = "N";
							} else{
								rowPopBenDiv.down("input",5).checked = true;
								rowPopBenDiv.down("input",4).value = "Y";
							}
						});
						rowPopBenDiv.down("label",2).observe("click", function()	{
							if (rowPopBenDiv.down("input",5).checked == true){
								rowPopBenDiv.down("input",5).checked = false;
								rowPopBenDiv.down("input",4).value = "N";
							} else{
								rowPopBenDiv.down("input",5).checked = true;
								rowPopBenDiv.down("input",4).value = "Y";
							}
						});
							
						//updateTempBeneficiaryItemNos();
						$("tempSave").value = "Y";
						origGroupedItemNo = "";
						updateEnrolleeName();
						clearForm();
					}
				} else { 
					var newDiv = new Element('div');
					newDiv.setAttribute("name","grpItem");
					newDiv.setAttribute("id","rowGroupedItems"+gItemNo+gGroupedItemNo);
					newDiv.setAttribute("item",gItemNo);
					newDiv.setAttribute("groupedItemNo",gGroupedItemNo); 
					newDiv.setAttribute("groupedItemTitle",gGroupedItemTitle); 
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('accidentGroupedItemsListing').insert({bottom: newDiv});

					loadRowMouseOverMouseOutObserver(newDiv);					
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='grpItem']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							
							var groupedItemNo = newDiv.down("input",2).value;	
							var groupedItemTitle = newDiv.down("input",3).value;	
							var principalCd = newDiv.down("input",4).value;	
							var packBenCd = newDiv.down("input",5).value;		
							var paytTerms = newDiv.down("input",6).value;	
							var grpFromDate = newDiv.down("input",7).value;	
							var grpToDate = newDiv.down("input",8).value;
							var sex = newDiv.down("input",9).value;
							var dateOfBirth = newDiv.down("input",10).value;
							var age = newDiv.down("input",11).value;
							var civilStatus = newDiv.down("input",12).value;
							var positionCd = newDiv.down("input",13).value;
							var groupCd = newDiv.down("input",14).value;
							var controlTypeCd = newDiv.down("input",15).value;
							var controlCd = newDiv.down("input",16).value;
							var salary = newDiv.down("input",17).value;
							var salaryGrade = newDiv.down("input",18).value;
							var amountCovered = newDiv.down("input",19).value;
							var includeTag = newDiv.down("input",20).value;
							var remarks = newDiv.down("input",21).value;
							var lineCd = newDiv.down("input",22).value;
							var sublineCd = newDiv.down("input",23).value;
							var deleteSw = newDiv.down("input",24).value;
							var annTsiAmt = newDiv.down("input",25).value;
							var annPremAmt = newDiv.down("input",26).value;
							var tsiAmt = newDiv.down("input",27).value;
							var premAmt = newDiv.down("input",28).value;
								
							$("groupedItemNo").value = formatNumberDigits(groupedItemNo,7);
							$("groupedItemTitle").value = groupedItemTitle;
							$("principalCd").value = (principalCd == "" ? "" :formatNumberDigits(principalCd,7));
							$("packBenCd").value = packBenCd;
							$("paytTerms").value = paytTerms;
							$("grpFromDate").value = grpFromDate;
							$("grpToDate").value = grpToDate;
							$("sex").value = sex;
							$("dateOfBirth").value = dateOfBirth;
							$("age").value = age;
							$("civilStatus").value = civilStatus;
							$("positionCd").value = positionCd;
							$("groupCd").value = groupCd;
							$("controlTypeCd").selectedIndex = 0;
							$("controlTypeCd").value = controlTypeCd;
							$("controlCd").value = controlCd;
							$("salary").value = salary;
							$("salaryGrade").value = salaryGrade;
							$("amountCovered").value = formatCurrency(amountCovered);
							$("includeTag").value = includeTag;
							$("remarks").value = remarks;
							$("lineCd").value = lineCd;
							$("sublineCd").value = sublineCd;
							$("deleteSw").value = deleteSw;
							$("annTsiAmt").value = annTsiAmt;
							$("annPremAmt").value = annPremAmt;
							$("tsiAmt").value = formatCurrency(tsiAmt);
							$("premAmt").value = formatCurrency(premAmt);

							setRecordListPerItem(true);
							generateSequenceItemInfo("benefit","bBeneficiaryNo","groupedItemNo",$F("groupedItemNo"),"nextItemNoBen2");
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));
						}
					});
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
					clearForm();

					var newDiv2 = new Element('div');
					newDiv2.setAttribute("name","popBens");
					newDiv2.setAttribute("id","rowPopBens"+gItemNo+gGroupedItemNo);
					newDiv2.setAttribute("item",gItemNo);
					newDiv2.setAttribute("groupedItemNo",gGroupedItemNo); 
					newDiv2.setAttribute("groupedItemTitle",gGroupedItemTitle); 
					newDiv2.addClassName("tableRow");
  
					newDiv2.update(content2);
					$('accidentPopBenListing').insert({bottom: newDiv2});					

					loadRowMouseOverMouseOutObserver(newDiv2);

					newDiv2.down("input",5).observe("change", function()	{
						if (newDiv2.down("input",5).checked == true){
							newDiv2.down("input",4).value = "Y";
						} else{
							newDiv2.down("input",4).value = "N";
						}
					});

					newDiv2.down("label",1).observe("click", function()	{
						if (newDiv2.down("input",5).checked == true){
							newDiv2.down("input",5).checked = false;
							newDiv2.down("input",4).value = "N";
						} else{
							newDiv2.down("input",5).checked = true;
							newDiv2.down("input",4).value = "Y";
						}
					});
					newDiv2.down("label",2).observe("click", function()	{
						if (newDiv2.down("input",5).checked == true){
							newDiv2.down("input",5).checked = false;
							newDiv2.down("input",4).value = "N";
						} else{
							newDiv2.down("input",5).checked = true;
							newDiv2.down("input",4).value = "Y";
						}
					});
					
					Effect.Appear(newDiv2, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","grpItem","item",$F("itemNo"));
						}
					});
				}
				//clearForm();
			}

		} catch (e)	{
			showErrorMessage("addGroupedItems", e);
		}
	}

	function onOkFunc() {	
		var gParId = $F("parId");
		var gItemNo = $F("itemNo");
		var gGroupedItemNo = $("groupedItemNo").value;
		var gGroupedItemTitle = changeSingleAndDoubleQuotes2($("groupedItemTitle").value);
		var gPrincipalCd = changeSingleAndDoubleQuotes2($("principalCd").value);
		var gPackBenCd = $("packBenCd").value;
		var gPaytTerms = $("paytTerms").value;
		var gFromDate = $("grpFromDate").value;
		var gToDate = $("grpToDate").value;
		var gSex = $("sex").value;
		var gDateOfBirth = $("dateOfBirth").value;
		var gAge = $("age").value;
		var gCivilStatus = $("civilStatus").value;
		var gPositionCd = $("positionCd").value;
		var gGroupCd = $("groupCd").value;
		var gControlTypeCd = $("controlTypeCd").value;
		var gControlCd = changeSingleAndDoubleQuotes2($("controlCd").value);
		var gSalary = $("salary").value;
		var gSalaryGrade = $("salaryGrade").value;
		var gAmountCovered = $("amountCovered").value;
		var gIncludeTag = ($("includeTag").value == "" ? "Y" : $("includeTag").value);
		var gRemarks = $("remarks").value;
		var gLineCd = ($("lineCd").value == "" ? (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $("globalLineCd").value) :$("lineCd").value);
		var gSublineCd = ($("sublineCd").value == "" ? (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $("globalSublineCd").value) :$("sublineCd").value);
		var gDeleteSw = $("deleteSw").value;
		var gAnnTsiAmt = $("annTsiAmt").value;
		var gAnnPremAmt = $("annPremAmt").value;
		var gTsiAmt = $("tsiAmt").value;
		var gPremAmt = $("premAmt").value;
		
		var gPlanDesc = changeSingleAndDoubleQuotes2($("packBenCd").options[$("packBenCd").selectedIndex].text);
		var gPaymentDesc = changeSingleAndDoubleQuotes2($("paytTerms").options[$("paytTerms").selectedIndex].text);
		var overwriteBen = $F("overwriteBen");
		
		var content = '<input type="hidden" id="gParIds" 		name="grpParIds" 	        	value="'+gParId+'" />'+
		  '<input type="hidden" id="grpItemNos" 		     	name="grpItemNos" 	        	value="'+gItemNo+'" />'+ 
		  '<input type="hidden" id="grpGroupedItemNos"       	name="grpGroupedItemNos"     	value="'+gGroupedItemNo+'" />'+ 
	 	  '<input type="hidden" id="grpGroupedItemTitles"  	 	name="grpGroupedItemTitles"  	value="'+gGroupedItemTitle+'" />'+  
	 	  '<input type="hidden" id="grpPrincipalCds" 	 		name="grpPrincipalCds" 		 	value="'+gPrincipalCd+'" />'+ 
	 	  '<input type="hidden" id="grpPackBenCds" 				name="grpPackBenCds"  			value="'+gPackBenCd+'" />'+ 
	 	  '<input type="hidden" id="grpPaytTermss" 				name="grpPaytTermss" 			value="'+gPaytTerms+'" />'+ 
	 	  '<input type="hidden" id="grpFromDates"   			name="grpFromDates"  	 		value="'+gFromDate+'" />'+
	 	  '<input type="hidden" id="grpToDates"  	 			name="grpToDates" 	 			value="'+gToDate+'" />'+
	 	  '<input type="hidden" id="grpSexs"  	 				name="grpSexs" 	 				value="'+gSex+'" />'+
	 	  '<input type="hidden" id="grpDateOfBirths"  	 		name="grpDateOfBirths" 	 		value="'+gDateOfBirth+'" />'+
	 	  '<input type="hidden" id="grpAges"  	 				name="grpAges" 	 				value="'+gAge+'" />'+
	 	  '<input type="hidden" id="grpCivilStatuss"  	 		name="grpCivilStatuss" 	 		value="'+gCivilStatus+'" />'+
	 	  '<input type="hidden" id="grpPositionCds"  	 		name="grpPositionCds" 	 		value="'+gPositionCd+'" />'+
	 	  '<input type="hidden" id="grpGroupCds"  	 			name="grpGroupCds" 	 			value="'+gGroupCd+'" />'+
	 	  '<input type="hidden" id="grpControlTypeCds"  	 	name="grpControlTypeCds" 	 	value="'+gControlTypeCd+'" />'+
	 	  '<input type="hidden" id="grpControlCds"  	 		name="grpControlCds" 	 		value="'+gControlCd+'" />'+
	 	  '<input type="hidden" id="grpSalarys"  	 			name="grpSalarys" 	 			value="'+gSalary+'" />'+
	 	  '<input type="hidden" id="grpSalaryGrades"  	 		name="grpSalaryGrades" 	 		value="'+gSalaryGrade+'" />'+
	 	  '<input type="hidden" id="grpAmountCovereds"  	 	name="grpAmountCovereds" 	 	value="'+gAmountCovered+'" />'+
	 	  '<input type="hidden" id="grpIncludeTags"  	 		name="grpIncludeTags" 	 		value="'+gIncludeTag+'" />'+	
	 	  '<input type="hidden" id="grpRemarkss"  	 			name="grpRemarkss" 	 			value="'+gRemarks+'" />'+	
	 	  '<input type="hidden" id="grpLineCds"  	 			name="grpLineCds" 	 			value="'+gLineCd+'" />'+	
	 	  '<input type="hidden" id="grpSublineCds"  	 		name="grpSublineCds" 	 		value="'+gSublineCd+'" />'+	
	 	  '<input type="hidden" id="grpDeleteSws"  	 			name="grpDeleteSws" 	 		value="'+gDeleteSw+'" />'+	
	 	  '<input type="hidden" id="grpAnnTsiAmts"  	 		name="grpAnnTsiAmts" 	 		value="'+gAnnTsiAmt+'" />'+	
	 	  '<input type="hidden" id="grpAnnPremAmts"  	 		name="grpAnnPremAmts" 	 		value="'+gAnnPremAmt+'" />'+	
	 	  '<input type="hidden" id="grpTsiAmts"  	 			name="grpTsiAmts" 	 			value="'+gTsiAmt+'" />'+	
	 	  '<input type="hidden" id="grpPremAmts"  	 			name="grpPremAmts" 	 			value="'+gPremAmt+'" />'+	
	 	  '<input type="hidden" id="grpPlanDescs"  	 			name="grpPlanDescs" 		 	value="'+gPlanDesc+'" />'+
	 	  '<input type="hidden" id="grpPaymentDescs"  	 		name="grpPaymentDescs" 	 		value="'+gPaymentDesc+'" />'+
	 	  '<input type="hidden" id="grpOverwriteBens"  	 		name="grpOverwriteBens" 	 	value="'+overwriteBen+'" />'+

	 	  '<label name="textG" style="text-align: left; width: 11%; margin-right: 2px;">'+(gGroupedItemNo == "" ? "---" :gGroupedItemNo.truncate(10, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 12%; margin-right: 2px;">'+(gGroupedItemTitle == "" ? "---" :gGroupedItemTitle.truncate(15, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 12%; margin-right: 0px;">'+(gPrincipalCd == "" ? "---" :gPrincipalCd.truncate(10, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 5%;  margin-right: 4px;">'+(gPlanDesc == "" ? "---" :gPlanDesc.truncate(1, "..."))+'</label>'+ 
		  '<label name="textG" style="text-align: left; width: 12%; margin-right: 2px;">'+(gPaymentDesc == "" ? "---" :gPaymentDesc.truncate(15, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 13%; margin-right: 3px;">'+(gFromDate == "" ? "---" :gFromDate.truncate(10, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 10%; margin-right: 2px;">'+(gToDate == "" ? "---" :gToDate.truncate(10, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 9%; margin-right: 2px; text-align:right;" class="money">'+(gTsiAmt == "" ? "---" :gTsiAmt.truncate(10, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 13%; text-align:right;" class="money">'+(gPremAmt == "" ? "---" :gPremAmt.truncate(10, "..."))+'</label>';

	    var content2 = '<input type="hidden" id="popParIds" 	name="popParIds" 	        	value="'+gParId+'" />'+
		  '<input type="hidden" id="popItemNos" 		     	name="popItemNos" 	        	value="'+gItemNo+'" />'+ 
		  '<input type="hidden" id="popGroupedItemNos"       	name="popGroupedItemNos"     	value="'+gGroupedItemNo+'" />'+ 
	 	  '<input type="hidden" id="popGroupedItemTitles"  	 	name="popGroupedItemTitles"  	value="'+gGroupedItemTitle+'" />'+  	
	 	  '<input type="hidden" id="popCheckSw"  	 	        name="popCheckSw"  	            value="Y" />'+ 	
	 	  '<label style="text-align: left; margin-right: 6px;"><input type="checkbox" id="popCheck" name="popCheck" checked="checked"/></label>'+	
		  '<label name="textG" id="num" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">'+(gGroupedItemNo == "" ? "---" :gGroupedItemNo.truncate(15, "..."))+'</label>'+
		  '<label name="textG" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">'+(gGroupedItemTitle == "" ? "---" :gGroupedItemTitle.truncate(15, "..."))+'</label>';			  	 
 
		$("rowGroupedItems"+gItemNo+origGroupedItemNo).update(content);
		$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
		$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
		$("rowGroupedItems"+gItemNo+origGroupedItemNo).setAttribute("id","rowGroupedItems"+gItemNo+gGroupedItemNo);

		$("rowPopBens"+gItemNo+origGroupedItemNo).update(content2);
		$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemNo",gGroupedItemNo); 
		$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("groupedItemTitle",gGroupedItemTitle); 
		$("rowPopBens"+gItemNo+origGroupedItemNo).setAttribute("id","rowPopBens"+gItemNo+gGroupedItemNo);
		var rowPopBenDiv = $("rowPopBens"+gItemNo+gGroupedItemNo);		

		loadRowMouseOverMouseOutObserver(rowPopBenDiv);

		rowPopBenDiv.down("input",5).observe("change", function()	{
			if (rowPopBenDiv.down("input",5).checked == true){
				rowPopBenDiv.down("input",4).value = "Y";
			} else{
				rowPopBenDiv.down("input",4).value = "N";
			}
		});

		rowPopBenDiv.down("label",1).observe("click", function()	{
			if (rowPopBenDiv.down("input",5).checked == true){
				rowPopBenDiv.down("input",5).checked = false;
				rowPopBenDiv.down("input",4).value = "N";
			} else{
				rowPopBenDiv.down("input",5).checked = true;
				rowPopBenDiv.down("input",4).value = "Y";
			}
		});
		rowPopBenDiv.down("label",2).observe("click", function()	{
			if (rowPopBenDiv.down("input",5).checked == true){
				rowPopBenDiv.down("input",5).checked = false;
				rowPopBenDiv.down("input",4).value = "N";
			} else{
				rowPopBenDiv.down("input",5).checked = true;
				rowPopBenDiv.down("input",4).value = "Y";
			}
		});
		
		//updateTempBeneficiaryItemNos();
		$("tempSave").value = "Y";
		removeAllRowInTable("coverageTable","cov","groupedItemNo",origGroupedItemNo);
		removeAllRowInTable("bBenefeciaryTable","benefit","groupedItemNo",origGroupedItemNo);	
		removeAllRowInTable("benPerilTable","benPeril","groupedItemNo",origGroupedItemNo);
		createDeleteGroupedItems(origGroupedItemNo);
		origGroupedItemNo = "";
		updateEnrolleeName();
		clearForm();
	}
	function onCancelFunc() {
		$("groupedItemNo").value = origGroupedItemNo;
	}
	
	$("btnDeleteGroupedItems").observe("click", function() {
		$("popBenDiv").hide();
		var exists = false;
		var grpItemNo = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each( function(a)	{
			if (a.down("input",4).value == grpItemNo)	{
				exists = true;
			}	
		});
		if (exists){
			showMessageBox("Cannot delete enrollee if used as a principal enrollee.", imgMessage.ERROR);
		} else{
			removeAllRowInTable("coverageTable","cov","groupedItemNo",grpItemNo);	
			removeAllRowInTable("bBenefeciaryTable","benefit","groupedItemNo",grpItemNo);	
			removeAllRowInTable("benPerilTable","benPeril","groupedItemNo",grpItemNo);	
			deleteGroupedItems();
		}	 
	}); 

	function deleteGroupedItems(){
		$$("div[name='grpItem']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var itemNo		    = $F("itemNo");
						var gGroupedItemNo	= getSelectedRowAttrValue("grpItem","groupedItemNo");
						var listingDiv 	    = $("accidentGroupedItemsListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+itemNo+gGroupedItemNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delGroupItemsItemNos" 	value="'+itemNo+'" />' +
							'<input type="hidden" name="delGroupedItemNos" 	value="'+gGroupedItemNo+'" />');
						listingDiv.insert({bottom : newDiv});
						//updateTempGroupItemsItemNos();
						$("tempSave").value = "Y";
						//objGIPIWItemWGroupedPeril.recordStatus = -1;
						acc.remove();
						clearForm();
						checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));

						$("rowPopBens"+itemNo+gGroupedItemNo).remove();
						checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","grpItem","item",$F("itemNo"));
					} 
				});
			}
		});
	}	
	
	function createDeleteGroupedItems(origGroupedItemNo){
		$$("div[name='grpItem']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				var itemNo		    = $F("itemNo");
				var gGroupedItemNo	= origGroupedItemNo;
				var listingDiv 	    = $("accidentGroupedItemsListing");
				var newDiv 		    = new Element("div");
				newDiv.setAttribute("id", "row"+itemNo+gGroupedItemNo); 
				newDiv.setAttribute("name", "rowDelete"); 
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display : none");
				newDiv.update(										
					'<input type="hidden" name="delGroupItemsItemNos" 	value="'+itemNo+'" />' +
					'<input type="hidden" name="delGroupedItemNos" 	value="'+gGroupedItemNo+'" />');
				listingDiv.insert({bottom : newDiv});
				//updateTempGroupItemsItemNos();
				$("tempSave").value = "Y";
				checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));
			}
		});
	}	
	
	function getDefaults()	{
		$("btnAddGroupedItems").value = "Update";
		enableButton("btnDeleteGroupedItems"); 
	}  

	function clearForm()	{
		$("groupedItemNo").value = "";
		$("groupedItemTitle").value = "";
		$("principalCd").value = "";
		$("packBenCd").selectedIndex = 0;
		$("paytTerms").selectedIndex = 0;
		$("grpFromDate").value = "";
		$("grpToDate").value = "";
		$("sex").selectedIndex = 0;
		$("dateOfBirth").value = "";
		$("age").value = "";
		$("civilStatus").selectedIndex = 0;
		$("positionCd").selectedIndex = 0;
		$("groupCd").selectedIndex = 0;
		$("controlTypeCd").selectedIndex = 0;
		$("controlCd").value = "";
		$("salary").value = "";
		$("salaryGrade").value = "";
		$("amountCovered").value = "0.00";
		$("includeTag").value = "Y";
		$("remarks").value = "";
		$("lineCd").value = "";
		$("sublineCd").value = "";
		$("deleteSw").value = "";
		$("annTsiAmt").value = "";
		$("annPremAmt").value = "";
		$("tsiAmt").value = "";
		$("premAmt").value = "";

		//setRecordListPerItem(false); //lipat ko sa dulo niknok 10.20.2010
		
		$("btnAddGroupedItems").value = "Add";
		disableButton("btnDeleteGroupedItems");
		deselectRows("accidentGroupedItemsTable","grpItem");
		checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));

		clearFormCoverage();
		clearFormBeneficiary();
		clearFormBeneficiaryPeril();

		var countRow = 0;
		$$("div[name='grpItem']").each( function(a)	{
			countRow++;	
		});
		if (countRow > 0){
			enableButton("btnPopulateBenefits"); 
			enableButton("btnCopyBenefits");
			enableButton("btnDeleteBenefits");
			enableButton("btnSelectedGroupedItems");
			enableButton("btnAllGroupedItems");
			enableButton("btnRenumber"); 
		} else{
			disableButton("btnRenumber"); 
			disableButton("btnPopulateBenefits"); 
			disableButton("btnCopyBenefits");
			disableButton("btnDeleteBenefits");
			disableButton("btnSelectedGroupedItems");
			disableButton("btnAllGroupedItems");
		}	
		var margin = parseInt(12*countRow);
		if (countRow<6){
			$("subButtonDiv").setStyle("margin-top:"+margin+"px");
		}
		showListing($("cPerilCd"));
		setRecordListPerItem(false);
	}

	function setRecordListPerItem(blnApply){			
		var listTableName 	= ["coverageTable","bBenefeciaryTable"];
		var listRowName		= ["cov","benefit"];
		var listCode 		= ["groupedItemNo","groupedItemNo"];

		clearFormCoverage();
		clearFormBeneficiary();
		clearFormBeneficiaryPeril();
		computeTotalForPeril();
		
		if(blnApply){
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){						
						if (row.getAttribute("groupedItemNo") != $F("groupedItemNo")){
							$(row.getAttribute("id")).hide();
						} else{
							$(row.getAttribute("id")).show();
						}	
					});
			}			
			filterLOV("cPerilCd","cov",2,"","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
			hideAllGroupedItemPerilOptions();
			selectGroupedItemPerilOptionsToShow(); 
			hideExistingGroupedItemPerilOptions(); 
		} else{
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){
						row.hide();
					});
			}
		}
		$("popBenDiv").hide();
		$("popBenefitsSw").value = "";
		checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
		checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	function updateEnrolleeName(){
		$$("div[name='cov']").each(function(row){						
			if (row.getAttribute("groupedItemNo") == $F("groupedItemNo")){
				$(row.getAttribute("id")).down("label",0).update($F("groupedItemTitle").truncate(15, "..."));
			}	
		});
	}	

	function clearFormCoverage(){
		$("cPerilCd").selectedIndex = 0;
		$("cPremRt").value = formatToNineDecimal(0);	
		$("cTsiAmt").value = "";	
		$("cPremAmt").value = "";	
		$("cNoOfDays").value = "";	
		$("cBaseAmt").value = "";	
		$("cAggregateSw").checked = true;
		$("cAnnPremAmt").value = "";	
		$("cAnnTsiAmt").value = "";	
		$("cGroupedItemNo").value = "";	
		$("cLineCd").value = "";	
		$("cRecFlag").value = "";	
		$("cRiCommRt").value = "";	
		$("cRiCommAmt").value = "";	
		
		$("btnAddCoverage").value = "Add";
		disableButton("btnDeleteCoverage");
		deselectRows("coverageTable","cov");
		checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	function clearFormBeneficiary(){
		generateSequenceItemInfo("benefit","bBeneficiaryNo","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"),"nextItemNoBen2");
		$("bBeneficiaryName").value = "";
		$("bBeneficiaryAddr").value = "";
		$("bDateOfBirth").value = "";
		$("bAge").value = "";
		$("bRelation").value = "";
		$("bCivilStatus").selectedIndex = 0;
		$("bSex").selectedIndex = 0;

		$("btnAddBeneficiary").value = "Add";
		disableButton("btnDeleteBeneficiary");
		deselectRows("bBenefeciaryTable","benefit");
		checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}	

	function clearFormBeneficiaryPeril()	{
		$("bpPerilCd").selectedIndex = 0;
		$("bpTsiAmt").value = "";
		$("bpGroupedItemNo").value = "";
		$("bpBeneficiaryNo").value = "";
		$("bpLineCd").value = "";
		$("bpRecFlag").value = "";
		$("bpPremRt").value = "";
		$("bpPremAmt").value = "";
		$("bpAnnTsiAmt").value = "";
		$("bpAnnPremAmt").value = "";

		$("btnAddBeneficiaryPerils").value = "Add";
		disableButton("btnDeleteBeneficiaryPerils");
		deselectRows("benPerilTable","benPeril");
		checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	function computeTotalForPeril(){
		var tsiAmtTotal = 0;
		var grpNo = "";
		var benNo = "";
		$$("div[name='benefit']").each(function(grp){
			grpNo = grp.getAttribute("groupedItemNo");
			benNo = grp.getAttribute("beneficiaryNo");
			$$("div[name='benPeril']").each(function(row){
				if (row.getAttribute("groupedItemNo") == grpNo && row.getAttribute("beneficiaryNo") == benNo){
					tsiAmtTotal = parseFloat(tsiAmtTotal) + parseFloat(row.down("input",3).value.replace(/,/g, ""));
				}
			});
			grp.down("label",5).update(formatCurrency(tsiAmtTotal).truncate(15, "..."));
			tsiAmtTotal = 0;
			grpNo = "";
			benNo = ""; 
		});	
	}		

	setRecordListPerItem(false);
	disableButton("btnDeleteGroupedItems");
	checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));
</script>
	