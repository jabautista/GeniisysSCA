<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<script type="text/javascript">
	objGIPIWGroupedItems = [];
	objGIPIWItmperlGrouped = [];
	objGIPIWGrpItemsBeneficiary = [];
	objGIPIWItmperlBeneficiary = [];
	
	objGIPIWGroupedItems = JSON.parse('${objGIPIWGroupedItems}'.replace(/\\/g, '\\\\'));
	objGIPIWItmperlGrouped = JSON.parse('${objGIPIWItmperlGrouped}'.replace(/\\/g, '\\\\'));
	objGIPIWGrpItemsBeneficiary = JSON.parse('${objGIPIWGrpItemsBeneficiary}'.replace(/\\/g, '\\\\'));
	objGIPIWItmperlBeneficiary = JSON.parse('${objGIPIWItmperlBeneficiary}'.replace(/\\/g, '\\\\'));
	objGIPIItmPerilGrouped = JSON.parse('${gipiItmPerilGrouped}');
</script>
<div id="groupedItemsInformationInfo" class="sectionDiv" style="display: block; width:872px; background-color:white; ">
	<div id="groupedItemsInfo" name="groupedItemsInfo"  style="width : 100%;">
		<div style="margin: 10px;" id="accidentGroupedItemsTable" name="accidentGroupedItemsTable">	
			<div class="tableHeader" style="margin-top: 5px; font-size: 10px;">
				<label style="text-align: right; width: 20px; margin-right: 2px;">&nbsp;</label>
				<label style="text-align: left; width: 90px; margin-right: 2px;">Enrollee Code</label>
				<label style="text-align: left; width: 210px; margin-right: 2px;">Enrollee Name</label>
				<label style="text-align: left; width: 90px; margin-right: 0px;">Principal Code</label>
				<label style="text-align: left; width: 100px; margin-right: 4px;">Plan</label>
				<label style="text-align: left; width: 100px; margin-right: 2px;">Payment Mode</label>
				<label style="text-align: left; width: 100px; margin-right: 2px;">Effectivity Date</label>
				<label style="text-align: left; width: 100px;">Expiry Date</label>				
			</div>		
			<div class="tableContainer" id="accidentGroupedItemsListing" name="accidentGroupedItemsListing" style="display: block;"></div>
		</div>
	</div>		
	<table align="center" border="0" style="width:100%;">
		<tr>
			<td class="rightAligned" style="width: 350px;">Enrollee Code </td>
			<td class="leftAligned">
				<input id="groupedItemNo" name="groupedItemNo" type="text" style="width: 215px;" maxlength="7" class="required integerNoNegativeUnformatted" errorMsg="Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Enrollee Name </td>
			<td class="leftAligned">
				<input id="groupedItemTitle" name="groupedItemTitle" type="text" style="width: 215px;" maxlength="50" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Principal Code </td>
			<td class="leftAligned">
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
		<tr>
			<td class="rightAligned">Delete</td>		
			<td class="leftAligned" style="padding-top: 5px;">
				<input type="checkbox" id="deleteSw" name="deleteSw" style="float: left;" disabled="disabled" />
				<div style="border: none; width: 150px; height: 21px; margin-right:3px; float: left;">
	    			&nbsp;
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
				<select  id="controlTypeCd" name="controlTypeCd" style="width: 223px;">
					<option value=""></option>
					<c:forEach var="controlTypes" items="${controlTypes}">
						<option value="${controlTypes.controlTypeCd}">${controlTypes.controlTypeDesc}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Birthday </td>
			<td class="leftAligned">
			<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:15px;">
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
				<input id="salary" name="salary" type="text" style="width: 215px;" maxlength="14" class="money2" min="-9999999999.99" max="9999999999.99" errorMsg="Invalid Salary. Value should be from -9,999,999,999.99 to 9,999,999,999.99." />
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
				<input id="amountCovered" name="amountCovered" type="text" style="width: 215px;" class="money2" maxlength="17" readonly="readonly" min="-99999999999999.99" max="99999999999999.99" errorMsg="Invalid Amount Covered. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." />
			</td>
		</tr>			
		<tr>
			<td>
				<input id="includeTag" 	name="includeTag" 	type="hidden" value="" maxlength="1" readonly="readonly"/>
				<input id="remarks" 	name="remarks" 		type="hidden" value=""/>
				<input id="lineCd" 		name="lineCd" 		type="hidden" value=""/>
				<input id="sublineCd" 	name="sublineCd" 	type="hidden" value=""/>
				<!-- <input id="deleteSw" 	name="deleteSw" 	type="hidden" value=""/> -->
				<input id="gAnnTsiAmt" 	name="gAnnTsiAmt" 	type="hidden" value="" class="money" maxlength="18"/>
				<input id="gAnnPremAmt" name="gAnnPremAmt" 	type="hidden" value="" class="money" maxlength="14"/>
				<input id="gTsiAmt" 	name="gTsiAmt" 		type="hidden" value="" class="money" maxlength="18"/>
				<input id="gPremAmt" 	name="gPremAmt" 	type="hidden" value="" class="money" maxlength="14"/>
				<input id="overwriteBen" 	name="overwriteBen" 	type="hidden" value=""/>
				<input id="itemSeqField" name="itemSeqField" type="hidden" />
				<input id="isItmPerilExists" name="isItmPerilExists" type="hidden" value="${isItmPerilExists}" />
			</td>
		</tr>
	</table>
	
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 3px;">
				<input type="button" class="button" 		id="btnUploadEnrollees" 	name="btnUploadEnrollees" 		value="Upload Enrollees" 		style="width: 120px;" />
				<input type="button" class="button" 		id="btnPopulateBenefits" 	name="btnPopulateBenefits" 		value="Populate Benefits" 		style="width: 120px; display : none;" />
				<input type="button" class="button" 		id="btnRetrieveGrpItems" 	name="btnRetrieveGrpItems" 		value="Retrieve Grp Items" 		style="width: 120px;" />
				<input type="button" class="button" 		id="btnDeleteBenefits" 		name="btnDeleteBenefits" 		value="Delete Benefits" 		style="width: 102px; display: none;" />
				<input type="button" class="button" 		id="btnRenumber" 			name="btnRenumber" 				value="Renumber" 				style="width: 80px; display: none;" />
				<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 					style="width: 120px;" />
				<input type="button" class="button" 		id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 					style="width: 120px;" />
			</td>
		</tr>
	</table>
</div>
	
<script type="text/javascript">
	var objGIPIGroupedItemsLocal = {};	
	
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	var tempFromDate = "";	// added by steven 9/8/2012
	var tempToDate = "";	// added by steven 9/8/2012
	/*
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
	*/
	var origGroupedItemNo = "";
	var fromDateFromItem = $F("fromDate");
	var toDateFromItem = $F("toDate");
	var packBenCdFromItem = $F("accidentPackBenCd");
	//$$("div#itemTable div[name='rowItem']").each(function(a){
	//	if (a.hasClassName("selectedRow")){
	//		fromDateFromItem = a.down("input",14).value;
	//		toDateFromItem = a.down("input",15).value;
	//		packBenCdFromItem = a.down("input",27).value;
	//	}	
	//});	
	
	$("groupedItemNo").observe("blur", function () {		
		if ($F("groupedItemNo") != ""){
			var isNum = isNumber("groupedItemNo","Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.","popup");
			$("groupedItemNo").value = formatNumberDigits($F("groupedItemNo"),7);
			//$("groupedItemNo").value = parseInt($F("groupedItemNo")).toPaddedString(7);
			var groupedItemNoTemp = removeLeadingZero($F("groupedItemNo"));
			if ($F("groupedItemNo") < 1){
				showMessageBox("Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.",imgMessage.ERROR);
				$("groupedItemNo").value = "";
				$("groupedItemNo").focus();
				return false;
			}
			
			new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=getGroupedItemsForEndt", {
				method : "POST",
				parameters : {
					lineCd : objGIPIWPolbas.lineCd,
					sublineCd : objGIPIWPolbas.sublineCd,
					issCd : objGIPIWPolbas.issCd,
					issueYy : objGIPIWPolbas.issueYy,
					polSeqNo : objGIPIWPolbas.polSeqNo,
					renewNo : objGIPIWPolbas.renewNo,
					itemNo : $F("itemNo"),
					groupedItemNo : groupedItemNoTemp
				},
				asynchronous : true,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){						
						var objGroupItems = eval(response.responseText);		
												
						objGIPIGroupedItemsLocal = objGroupItems[0];
						if(nvl(objGIPIGroupedItemsLocal, null) != null || objGroupItems[0].groupedItemNo != null) {
							setAccidentGroupedItemForm(objGroupItems[0], true);		
						}								
					}
				}
			});		

			/*
			if (fromDateFromItem != ""){
				$("grpFromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("grpToDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("packBenCd").value = packBenCdFromItem;
			}
			*/	
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
			if ($F("principalCd") == removeLeadingZero($F("groupedItemNo"))){
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

	$("grpFromDate").observe("blur", function() { 
		if(!($F("grpFromDate").empty()) && !($F("grpToDate").empty())){
			var grpFromDate 	= makeDate($F("grpFromDate"));
			var grpToDate		= makeDate($F("grpToDate"));
			var itemFromDate	= makeDate(objCurrItem.dateFormatted == "Y" ? objCurrItem.fromDate : objCurrItem.strFromDate == undefined ? dateFormat(objCurrItem.fromDate, "mm-dd-yyyy") : dateFormat(objCurrItem.strFromDate, "mm-dd-yyyy"));
			var itemToDate		= makeDate(objCurrItem.dateFormatted == "Y" ? objCurrItem.toDate : objCurrItem.strToDate == undefined ? dateFormat(objCurrItem.toDate, "mm-dd-yyyy") : dateFormat(objCurrItem.strToDate, "mm-dd-yyyy"));

			if(compareDatesIgnoreTime(grpFromDate, itemFromDate) == 1 && objCurrItem.toDate != null){	//added by steven 9.05.2012
				showMessageBox("Date entered must not be earlier than inception date " + dateFormat(itemFromDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpFromDate").focus();
				$("grpFromDate").value = tempFromDate;
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, grpToDate) == -1){
				showMessageBox("Date entered must not be later than the effectivity end date " + dateFormat(grpToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpFromDate").focus();
				$("grpFromDate").value = tempFromDate;
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, itemToDate) == -1 && objCurrItem.fromDate != null){
				showMessageBox("Date entered must not be later than the expiry date " + dateFormat(itemToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpFromDate").focus();	
				$("grpFromDate").value = tempFromDate;
				return false;
			}
			/*if(compareDatesIgnoreTime(grpFromDate, itemFromDate) == 1 && objCurrItem.fromDate != null){
				showMessageBox("Date entered must not be earlier than inception date " + dateFormat(itemFromDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, itemToDate) == -1 && objCurrItem.toDate != null){
				showMessageBox("Date entered must not be later than the expiry date " + dateFormat(grpToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, grpToDate) == -1){
				showMessageBox("Date entered must not be later than the effectivity end date " + dateFormat(grpToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			}*/
		}				
	});

	$("grpToDate").observe("blur", function() { 
		if(!($F("grpFromDate").empty()) && !($F("grpToDate").empty())){
			var grpFromDate 	= makeDate($F("grpFromDate"));
			var grpToDate		= makeDate($F("grpToDate"));
			var itemFromDate	= makeDate(objCurrItem.dateFormatted == "Y" ? objCurrItem.fromDate : objCurrItem.strFromDate == undefined ? dateFormat(objCurrItem.fromDate, "mm-dd-yyyy") : dateFormat(objCurrItem.strFromDate, "mm-dd-yyyy"));
			var itemToDate		= makeDate(objCurrItem.dateFormatted == "Y" ? objCurrItem.toDate : objCurrItem.strToDate == undefined ? dateFormat(objCurrItem.toDate, "mm-dd-yyyy") : dateFormat(objCurrItem.strToDate, "mm-dd-yyyy"));

			if(compareDatesIgnoreTime(grpToDate, itemToDate) == -1 && objCurrItem.toDate != null){	//added by steven 9.04.2012
				showMessageBox("Date entered must not be later than expiry date " + dateFormat(itemToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpToDate").focus();		
				$("grpToDate").value = tempToDate;
				return false;
			}else if(compareDatesIgnoreTime(grpToDate, grpFromDate) == 1){
				showMessageBox("Date entered must not be earlier than effectivity start date " + dateFormat(grpFromDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpToDate").focus();	
				$("grpToDate").value = tempToDate;
				return false;
			}else if(compareDatesIgnoreTime(grpToDate, itemFromDate) == 1 && objCurrItem.fromDate != null){
				showMessageBox("Date entered must not be earlier than the inception date " + dateFormat(itemFromDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
// 				$("grpFromDate").focus();
				$("grpToDate").value = tempToDate;
				return false;
			}
			
			/* if(compareDatesIgnoreTime(grpFromDate, itemFromDate) == 1 && objCurrItem.fromDate != null){
				showMessageBox("Date entered must not be earlier than inception date " + dateFormat(itemFromDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, itemToDate) == -1 && objCurrItem.toDate != null){
				showMessageBox("Date entered must not be later than the expiry date " + dateFormat(grpToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			}else if(compareDatesIgnoreTime(grpFromDate, grpToDate) == -1){
				showMessageBox("Date entered must not be later than the effectivity end date " + dateFormat(grpToDate, "mmmm d, yyyy") + ".", imgMessage.INFO);
				$("grpFromDate").focus();			
				return false;
			} */
		}		
	});

	$("btnAddGroupedItems").observe("click", function() {
		var itemNo = $F("itemNo");
		var groupedItemNo = removeLeadingZero(($F("groupedItemNo")));
		
		$("popBenDiv").hide();
		
		if(nvl($F("groupedItemNo"), "") == "" || nvl($F("groupedItemTitle"), "") == ""){
			showMessageBox("Please fill up required fields.", "E");
			return false;
		} // added by: Nica 11.08.2011 to fill up required fields before adding or updating

		if($(("rowEnrollee"+itemNo)+groupedItemNo) != null && $F("btnAddGroupedItems") == "Add"){
			showMessageBox("Record already exists!", imgMessage.ERROR);
			return false;
		}
		
		addGroupedItems();
		//updateObjCopyToInsert(objArray, itemNo);		
		
		if((objGIPIWItmperlGrouped.filter(function(obj){	return nvl(obj.recordStatus, 0) == 2;	})).length > 0){			
			for(var i=0, length=objGIPIWItmperlGrouped.length; i < length; i++){				
				if(objGIPIWItmperlGrouped[i].itemNo == itemNo && objGIPIWItmperlGrouped[i].groupedItemNo == groupedItemNo && objGIPIWItmperlGrouped[i].recordStatus == 2){
					objGIPIWItmperlGrouped[i].recordStatus = 0;
				}
			}
			
			// recreate coverage listing
			$("coverageListing").update("");
			showCoverageList(objGIPIWItmperlGrouped);			
			cascadeAccidentGroup(objGIPIWItmperlGrouped, "coverageTable", "coverageListing", $F("itemNo"), removeLeadingZero($F("groupedItemNo")));
		}

		if(objCurrItem.recordStatus == 1){
			for(var i=0, length=objGIPIWItem.length; i < length; i++){
				if(objGIPIWItem[i].itemNo == objCurrItem.itemNo){
					objGIPIWItem.splice(i, 1);
					objGIPIWItem.push(objCurrItem);
				}
			}
		}

		//selectAccidentGroupedItemPerilOptionsToShow(groupedItemNo); // andrew - 01.10.2012 - comment out
	});
	/*
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
						
						var obj = new Object();

						obj.groupedItemNo		= newDiv.down("input",2).value;
						obj.groupedItemTitle	= newDiv.down("input",3).value;
						obj.principalCd			= newDiv.down("input",4).value;
						obj.packBenCd			= newDiv.down("input",5).value;
						obj.paytTerms			= newDiv.down("input",6).value;
						obj.fromDate			= newDiv.down("input",7).value;
						obj.toDate				= newDiv.down("input",8).value;
						obj.sex					= newDiv.down("input",9).value;
						obj.dateOfBirth			= newDiv.down("input",10).value;
						obj.age					= newDiv.down("input",11).value;
						obj.civilStatus			= newDiv.down("input",12).value;
						obj.positionCd			= newDiv.down("input",13).value;
						obj.groupCd				= newDiv.down("input",14).value;
						obj.controlTypeCd		= newDiv.down("input",15).value;
						obj.controlCd			= newDiv.down("input",16).value;
						obj.salary				= newDiv.down("input",17).value;
						obj.salaryGrade			= newDiv.down("input",18).value;
						obj.amountCovered		= newDiv.down("input",19).value;
						obj.includeTag			= newDiv.down("input",20).value;
						obj.remarks				= newDiv.down("input",21).value;
						obj.lineCd				= newDiv.down("input",22).value;
						obj.sublineCd			= newDiv.down("input",23).value;
						obj.deleteSw			= newDiv.down("input",24).value;
						obj.annTsiAmt			= newDiv.down("input",25).value;
						obj.annPremAmt			= newDiv.down("input",26).value;
						obj.tsiAmt				= newDiv.down("input",27).value;
						obj.premAmt				= newDiv.down("input",28).value;
						
						setAccidentGroupedItemForm(obj, false);

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
	*/
	function addGroupedItems() {	
		try	{			
			var newObj 	= setGroupedItemsObject();
			var content = prepareAccidentGroupedItemsDisplay(newObj);
			var rowId 	= (("rowEnrollee"+newObj.itemNo)+newObj.groupedItemNo);			
			
			if($F("btnAddGroupedItems") == "Update"){
				rowId = getSelectedRow("rowEnrollee"); // added by: Nica 11.08.2011 - to prevent element is null error
				$(rowId).update(content);
				addModifiedJSONObject(objGIPIWGroupedItems, newObj);
				fireEvent($(rowId), "click");
			}else{				
				newObj.recordStatus = 0;
				objGIPIWGroupedItems.push(newObj);
				
				if (objUWParList.binderExist == "Y"){
					showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
					return false;
				}
				
				var table = $("accidentGroupedItemsListing");
				var newDiv = new Element("div");

				newDiv.setAttribute("id", rowId);
				newDiv.setAttribute("name", "rowEnrollee");
				newDiv.setAttribute("parId", newObj.parId);
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItem", newObj.groupedItemNo);
				newDiv.setAttribute("principalCd", newObj.principalCd);			
				newDiv.addClassName("tableRow");

				newDiv.update(content);

				setAccidentGroupedItemsRowObserver(newDiv);

				table.insert({bottom : newDiv});

				resizeTableBasedOnVisibleRows("accidentGroupedItemsTable", "accidentGroupedItemsListing");
				checkTableIfEmpty("rowEnrollee", "accidentGroupedItemsTable");
				
				//checkIfToResizeTable("accidentGroupedItemsListing", "rowEnrollee");
				//checkTableIfEmpty("rowEnrollee", "accidentGroupedItemsTable");			
				
				new Effect.Appear(rowId, {
						duration: 0.2
					});
			}

			setAccidentGroupedItemForm(null);
			($$("div#groupedItemsDetail [changed=changed]")).invoke("removeAttribute", "changed");			
			
		} catch (e)	{
			showErrorMessage("addGroupedItems", e);
		}
	}	
	
	function onCancelFunc() {
		$("groupedItemNo").value = origGroupedItemNo;
	}	
	
	/*	
	function getDefaults()	{
		$("btnAddGroupedItems").value = "Update";
		enableButton("btnDeleteGroupedItems"); 
	}  

	function clearForm()	{
		$("groupedItemNo").value 			= "";
		$("groupedItemTitle").value 		= "";
		$("principalCd").value 				= "";
		$("packBenCd").selectedIndex 		= 0;
		$("paytTerms").selectedIndex 		= 0;
		$("grpFromDate").value 				= "";
		$("grpToDate").value 				= "";
		$("sex").selectedIndex 				= 0;
		$("dateOfBirth").value 				= "";
		$("age").value 						= "";
		$("civilStatus").selectedIndex 		= 0;
		$("positionCd").selectedIndex 		= 0;
		$("groupCd").selectedIndex 			= 0;
		$("controlTypeCd").selectedIndex 	= 0;
		$("controlCd").value 				= "";
		$("salary").value 					= "";
		$("salaryGrade").value 				= "";
		$("amountCovered").value 			= "";
		$("includeTag").value 				= "Y";
		$("remarks").value 					= "";
		$("lineCd").value 					= "";
		$("sublineCd").value 				= "";
		$("deleteSw").value 				= "";
		$("gAnnTsiAmt").value 				= "";
		$("gAnnPremAmt").value 				= "";
		$("gTsiAmt").value 					= "";
		$("gPremAmt").value 				= "";
		$("deleteSw").checked 				= false;

		//setRecordListPerItem(false); //lipat ko sa dulo niknok 10.20.2010
		
		$("btnAddGroupedItems").value = "Add";
		disableButton("btnDeleteGroupedItems");
		deselectRows("accidentGroupedItemsTable","grpItem");
		//checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));

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
		$("cAggregateSw").checked = false;
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
	*/
	$("deleteSw").observe("click", function(){
		try{
			if($("deleteSw").checked){
				var objParameters = new Object();			

				objCurrItem.toDate = objCurrItem.toDate == null ? null : dateFormat(objCurrItem.toDate, "mm-dd-yyyy HH:MM:ss");
				objCurrItem.fromDate = objCurrItem.fromDate == null ? null : dateFormat(objCurrItem.fromDate, "mm-dd-yyyy HH:MM:ss");

				objGIPIGroupedItemsLocal.dateOfBirth = objGIPIGroupedItemsLocal.dateOfBirth == null ? null : dateFormat(objGIPIGroupedItemsLocal.dateOfBirth, "mm-dd-yyyy HH:MM:ss");
				objGIPIGroupedItemsLocal.toDate = objGIPIGroupedItemsLocal.toDate == null ? null : dateFormat(objGIPIGroupedItemsLocal.toDate, "mm-dd-yyyy HH:MM:ss");
				objGIPIGroupedItemsLocal.fromDate = objGIPIGroupedItemsLocal.fromDate == null ? null : dateFormat(objGIPIGroupedItemsLocal.fromDate, "mm-dd-yyyy HH:MM:ss");

				objParameters.gipiWPolbas 		= prepareJsonAsParameter(objGIPIWPolbas);
				objParameters.gipiWItem			= prepareJsonAsParameter(objCurrItem);
				objParameters.gipiWGroupedItems	= prepareJsonAsParameter(objGIPIGroupedItemsLocal);
				
				new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=checkIfGroupItemIsZeroOutOrNegated", {
					method : "POST",
					parameters : { parameters : JSON.stringify(objParameters) },
					asynchronous : true,
					evalScripts : true,
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							if(!(response.responseText.empty())){
								showMessageBox(response.responseText, imgMessage.INFO);
								return false;
							}else{
								checkIfPrincipalEnrollee();
							}
						}
					}
				});
			}else{
				showConfirmBox("Delete Perils", "Untagging Delete switch will totally delete all existing perils for this group item. Would you like to continue?",
						"Yes", "No", 
						function(){						
							/*var objFilteredArr = objGIPIWItmperlGrouped.filter(
									function(obj){	
										return obj.itemNo != $F("itemNo") && obj.groupedItemNo != objGIPIGroupedItemsLocal.groupedItemNo && nvl(objGIPIGroupedItemsLocal.recordStatus, 0) != -1;
									});
							
							objGIPIWItmperlGrouped = objFilteredArr;
							showWaitingMessageBox("Deletion has been sucessfully completed.", imgMessage.INFO, checkIfPrincipalEnrollee);*/
							
							var objParameters = new Object();			

							objCurrItem.toDate = objCurrItem.toDate == null ? null : dateFormat(objCurrItem.toDate, "mm-dd-yyyy HH:MM:ss");
							objCurrItem.fromDate = objCurrItem.fromDate == null ? null : dateFormat(objCurrItem.fromDate, "mm-dd-yyyy HH:MM:ss");


							objParameters.gipiWPolbas 			= prepareJsonAsParameter(objGIPIWPolbas);
							objParameters.gipiWItem				= prepareJsonAsParameter(objCurrItem);

							for ( var i = 0; i < objGIPIWGroupedItems.length; i++) {
								
								if(objGIPIWGroupedItems[i].itemNo == $F("itemNo") && objGIPIWGroupedItems[i].groupedItemNo == removeLeadingZero(($F("groupedItemNo"))) && nvl(objGIPIWGroupedItems[i].recordStatus, 0) != -1){
									objGIPIWGroupedItems[i].deleteSw = "N";
									objParameters.gipiWGroupedItems		= prepareJsonAsParameter(objGIPIWGroupedItems[i]/*objGIPIGroupedItemsLocal*/);
								}
							}
							objParameters.delGroupedItemRows	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWGroupedItems));
							
							new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=untagDeleteItemGroup", {
								method : "POST",
								parameters : { parameters : JSON.stringify(objParameters) },
								asynchronous : true,
								evalScripts : true,
								onComplete : function(response){
									if(checkErrorOnResponse(response)){							
										
										//showEndtAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
										
										clearObjectRecordStatus2(objGIPIWGroupedItems);
										clearObjectRecordStatus2(objGIPIWItmperlGrouped);
										clearObjectRecordStatus2(objGIPIWGrpItemsBeneficiary);
										clearObjectRecordStatus2(objGIPIWItmperlBeneficiary);
										changeTag = 0;
										showWaitingMessageBox("Deletion has been sucessfully completed... Check Grouped Item Peril Module for information.", imgMessage.SUCCESS, 
										function(){	
											//overlayAccidentGroup.close();
											$("btnCancelGrp").click();
											showItemInfo();
										});	
										//showMessageBox("Deletion has been sucessfully completed... Check Grouped Item Peril Module for information.", imgMessage.SUCCESS);	
										
									}else{
										showMessageBox(response.responseText, imgMessage.ERROR);
										return false;
									}
								}
							});
								
						}, 
						function() {
							// re-check delete_sw if user selects "No" (emman 05.18.2011)
							$("deleteSw").checked = true;
							stopProcess();
						});
				var objFilteredArr = objGIPIWItmperlGrouped.filter(
						function(obj){	
							return obj.itemNo != $F("itemNo") && obj.groupedItemNo != objGIPIGroupedItemsLocal.groupedItemNo && nvl(objGIPIGroupedItemsLocal.recordStatus, 0) != -1;
						});
				
				if(objFilteredArr.length > 0){
					showConfirmBox("Delete Perils", "Untagging Delete switch will totally delete all existing perils for this group item. Would you like to continue?",
							"Yes", "No", 
							function(){
								objGIPIWItmperlGrouped = objFilteredArr;
								showWaitingMessageBox("Deletion has been sucessfully completed.", imgMessage.INFO, checkIfPrincipalEnrollee);					
							}, stopProcess);
				}	
			}
		}catch(e){
			showErrorMessage("deleteSw observe behavior", e);
		}
	});

	function checkIfPrincipalEnrollee(){
		try{
			new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=checkIfPrincipalEnrollee", {
				method : "POST",
				parameters : {
					lineCd : objGIPIWPolbas.lineCd,
					sublineCd : objGIPIWPolbas.sublineCd,
					issCd : objGIPIWPolbas.issCd,
					issueYy : objGIPIWPolbas.issueYy,
					polSeqNo : objGIPIWPolbas.polSeqNo,
					renewNo : objGIPIWPolbas.renewNo,
					itemNo : $F("itemNo"),
					groupedItemNo : removeLeadingZero($F("groupedItemNo"))
				},
				asynchronous : true,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(!(response.responseText.empty())){
							showWaitingMessageBox(response.responseText, imgMessage.INFO);
						}else{
							checkIfPrincipalEnrolleInPar();
						}							
					}
				}
			});			
		}catch(e){
			showErrorMessage("checkIfPrincipalEnrollee", e);
		}
	}

	//delete
	function checkIfPrincipalEnrolleInPar(){
		try{
			if((objGIPIWGroupedItems.filter(function(obj){	return obj.itemNo == $F("itemNo") && obj.principalCd == removeLeadingZero($F("groupedItemNo"));	})).length > 0){
				showMessageBox("Cannot delete Enrollee. Currently being used as the principal of other enrollees.", imgMessage.INFO);
			}else{
				showConfirmBox("Negate Peril", "Tagging Delete switch will automatically negate all perils for current group item , which means that it is deleted. Do you want to continue?",
						"Yes", "No", negateDeleteItemGroup, 
							function() {
								$("deleteSw").checked = false;
								stopProcess();
							});
			}
		}catch(e){
			showErrorMessage("checkIfPrincipalEnrolleInPar", e);
		}
	}

	function negateDeleteItemGroup(){
		try{
			function createParameters(includeDeleteGroupedItem){
				var objParameters = new Object();			

				objCurrItem.toDate = objCurrItem.toDate == null ? null : dateFormat(objCurrItem.toDate, "mm-dd-yyyy HH:MM:ss");
				objCurrItem.fromDate = objCurrItem.fromDate == null ? null : dateFormat(objCurrItem.fromDate, "mm-dd-yyyy HH:MM:ss");

				objGIPIGroupedItemsLocal.dateOfBirth = objGIPIGroupedItemsLocal.dateOfBirth == null ? null : dateFormat(objGIPIGroupedItemsLocal.dateOfBirth, "mm-dd-yyyy HH:MM:ss");
				objGIPIGroupedItemsLocal.toDate = objGIPIGroupedItemsLocal.toDate == null ? null : dateFormat(objGIPIGroupedItemsLocal.toDate, "mm-dd-yyyy HH:MM:ss");
				objGIPIGroupedItemsLocal.fromDate = objGIPIGroupedItemsLocal.fromDate == null ? null : dateFormat(objGIPIGroupedItemsLocal.fromDate, "mm-dd-yyyy HH:MM:ss");

				objParameters.gipiWPolbas 			= prepareJsonAsParameter(objGIPIWPolbas);
				objParameters.gipiWItem				= prepareJsonAsParameter(objCurrItem);
				/*var tempObj = (objGIPIWGroupedItems.filter(
						function(obj){	
							return obj.itemNo == $F("itemNo") && obj.groupedItemNo == parseInt($F("groupedItemNo")) &&
								nvl(obj.recordStatus, 0) != -1;	}));
				*/
				for ( var i = 0; i < objGIPIWGroupedItems.length; i++) {
					
					if(objGIPIWGroupedItems[i].itemNo == $F("itemNo") && objGIPIWGroupedItems[i].groupedItemNo == removeLeadingZero(($F("groupedItemNo"))) && nvl(objGIPIWGroupedItems[i].recordStatus, 0) != -1){
						objGIPIWGroupedItems[i].deleteSw = "Y";
						objParameters.gipiWGroupedItems		= prepareJsonAsParameter(objGIPIWGroupedItems[i]/*objGIPIGroupedItemsLocal*/);
					}
				}
				//objParameters.gipiWGroupedItems		= prepareJsonAsParameter(tempObj[0]/*objGIPIGroupedItemsLocal*/);
				if(includeDeleteGroupedItem){
					objParameters.delGroupedItemRows	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWGroupedItems));
				}				

				return objParameters;
			}

			function processNegateDelete(){
				try{
					var objArrFiltered = objGIPIWItmperlGrouped.filter(function(obj){	return obj.itemNo == $F("itemNo") && obj.groupedItemNo == removeLeadingZero($F("groupedItemNo"));	});

					objGIPIWItmperlGrouped = [];
					objGIPIWItmperlGrouped = objArrFiltered;
					
					new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=negateDeleteItemGroup", {
						method : "POST",
						parameters : { parameters : JSON.stringify(createParameters(true)) },
						asynchronous : true,
						evalScripts : true,
						onComplete : function(response){
							if(checkErrorOnResponse(response)){							
								var newObj = JSON.parse(response.responseText);

								$("gPremAmt").value 	= newObj.groupPremAmt; 
								$("gTsiAmt").value 		= newObj.groupTsiAmt;
								$("gAnnPremAmt").value 	= newObj.groupAnnPremAmt;
								$("gAnnTsiAmt").value 	= newObj.groupAnnTsiAmt;

								for(var i=0, length=newObj.gipiWItmperlGrouped.length; i < length; i++){
									newObj.gipiWItmperlGrouped[i].recordStatus = 2;
								}
								
								objGIPIWItmperlGrouped = objGIPIWItmperlGrouped.concat(newObj.gipiWItmperlGrouped);							
								
								for(var i=0, length=newObj.gipiWItmperl.length; i < length; i++){
									newObj.gipiWItmperl[i].recordStatus = 2;
								}
								
								objGIPIWItemPeril = objGIPIWItemPeril.concat(newObj.gipiWItmperl);

								objCurrItem.tsiAmt = newObj.tsiAmt;
								objCurrItem.premAmt = newObj.premAmt;
								objCurrItem.annTsiAmt = newObj.annTsiAmt;
								objCurrItem.annPremAmt = newObj.annPremAmt;
								objCurrItem.recordStatus = 1;
								
								//showEndtAccidentGroupedItemsModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),$F("itemNo"),"");
								
								clearObjectRecordStatus2(objGIPIWGroupedItems);
								clearObjectRecordStatus2(objGIPIWItmperlGrouped);
								clearObjectRecordStatus2(objGIPIWGrpItemsBeneficiary);
								clearObjectRecordStatus2(objGIPIWItmperlBeneficiary);
								changeTag = 0;
								showWaitingMessageBox("Deletion has been sucessfully completed... Check Grouped Item Peril Module for information.", imgMessage.SUCCESS, 
								function(){	
									//overlayAccidentGroup.close();
									$("btnCancelGrp").click();
									showItemInfo();
								});	
								//showMessageBox("Deletion has been sucessfully completed... Check Grouped Item Peril Module for information.", imgMessage.SUCCESS);	
								
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								return false;
							}
						}
					});
				}catch(e){
					showErrorMessage("processNegateDelete",e);
				}
				
			}
			
			function continueNegateDelete(){				
				if($F("globalBackEndt") == "Y"){					
					new Ajax.Request(contextPath + "/GIPIGroupedItemsController?action=checkIfBackEndt", {
						method : "POST",
						parameters : { parameters : JSON.stringify(createParameters(false)) },
						asynchronous : true,
						evalScripts : true,
						onComplete : function(response){
							if(checkErrorOnResponse(response)){							
								if(response.responseText != "SUCCESS"){
									showMessageBox(response.responseText, imgMessage.ERROR);
									return false;
								}else{
									processNegateDelete();
								}
							}
						}
					});
				}else{
					processNegateDelete();
				}
			}
					
			if((objGIPIWItmperlGrouped.filter(function(obj){	return obj.itemNo == $F("itemNo") && obj.groupedItemNo == removeLeadingZero($F("groupedItemNo"));	})).length > 0){
				showConfirmBox("Perils", "Existing perils for this grouped item will be automatically deleted. Do you want to continue?",
						"Yes", "No", continueNegateDelete, 
							function(){
								$("deleteSw").checked = false;
								stopProcess();						
							}
						);
			}else{
				continueNegateDelete();
			}
		}catch(e){
			showErrorMessage("negateDeleteItemGroup", e);
		}
	}

	//setRecordListPerItem(false);
	//disableButton("btnDeleteGroupedItems");
	//checkTableItemInfoAdditionalModal("accidentGroupedItemsTable","accidentGroupedItemsListing","grpItem","item",$F("itemNo"));

	

	$("btnDeleteGroupedItems").observe("click", function() {
		if (objUWParList.binderExist == "Y"){ //added by d.alcantara
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
			return false;
		}
		//$("popBenDiv").hide();
		
		if(($$("div#accidentGroupedItemsTable .selectedRow")).length > 0){
			var deleteDiv = ($$("div#accidentGroupedItemsTable .selectedRow"))[0];
			
			if(($$("div#accidentGroupedItemsTable div[principalCd='" + deleteDiv.getAttribute("grpItem") + "']")).length > 0){
				showMessageBox("Cannot delete enrollee if used as a principal enrollee.", imgMessage.ERROR);
				return false;
			}else{
				var delObj = setGroupedItemsObject(); //setItemPerilGrouped();//setGrpCoverageObj();				

				// set lists' deleted objects to -1 (emman 05.18.2011)
				// modified by mark jm 05.30.2011						

				// delete child records
				
				if(($$("div#coverageTable .selectedRow")).length > 0){
					fireEvent(($$("div#coverageTable .selectedRow"))[0], "click");
				}

				if(($$("div#bBeneficiaryTable .selectedRow")).length > 0){
					fireEvent(($$("div#bBeneficiaryTable .selectedRow"))[0], "click");
				}

				if(($$("div#benPerilTable .selectedRow")).length > 0){
					fireEvent(($$("div#benPerilTable .selectedRow"))[0], "click");
				}

				var forSplicing = [];				
				// enrollee coverage											
				for (var i = 0, length = objGIPIWItmperlGrouped.length; i < length; i++) {
					var delCovObj = objGIPIWItmperlGrouped[i];
					if (delObj.itemNo == delCovObj.itemNo && delObj.groupedItemNo == delCovObj.groupedItemNo) {												
						var row = (("rowCoverage"+delCovObj.itemNo)+delCovObj.groupedItemNo)+delCovObj.perilCd;						

						forSplicing.push(delCovObj);
						$(row) != null ? $(row).remove() : null;								
					}
				}

				for(var i=0, length=forSplicing.length; i < length; i++){
					addDelObjByAttr(objGIPIWItmperlGrouped, forSplicing[i], "groupedItemNo perilCd");
				}							
				resizeTableBasedOnVisibleRows("coverageTable", "coverageListing");
				//checkTableIfEmpty("rowCoverage", "coverageTable");						

				// enrollee beneficiary
				forSplicing = [];
				for (var i = 0, length = objGIPIWGrpItemsBeneficiary.length; i < length; i++) {
					var delBenObj = objGIPIWGrpItemsBeneficiary[i];
					if (delObj.itemNo == delBenObj.itemNo && delObj.groupedItemNo == delBenObj.groupedItemNo) {						
						var row = (("rowEnrolleeBen" + delBenObj.itemNo) + delBenObj.groupedItemNo) + delBenObj.beneficiaryNo;								

						forSplicing.push(delBenObj);
						$(row) != null ? $(row).remove() : null;								
					}
				}
				
				for(var i=0, length=forSplicing.length; i < length; i++){
					addDelObjByAttr(objGIPIWGrpItemsBeneficiary, forSplicing[i], "groupedItemNo beneficiaryNo");
				}										
				resizeTableBasedOnVisibleRows("bBeneficiaryTable", "bBeneficiaryListing");
				//checkTableIfEmpty("rowEnrolleeBen", "bBeneficiaryTable");

				// enrollee beneficiary perils
				forSplicing = [];
				for (var i = 0, length = objGIPIWItmperlBeneficiary.length; i < length; i++) {
					var delBenPerilObj = objGIPIWItmperlBeneficiary[i];
					if (delObj.itemNo == delBenPerilObj.itemNo && delObj.groupedItemNo == delBenPerilObj.groupedItemNo) {												
						var row = "rowBenPeril" + delBenPerilObj.itemNo + "_" + delBenPerilObj.groupedItemNo + "_" + delBenPerilObj.beneficiaryNo + "_" + delBenPerilObj.perilCd;						

						forSplicing.push(delBenPerilObj);						
						$(row) != null ? $(row).remove() : null;
					}
				}

				for(var i=0, length=forSplicing.length; i < length; i++){
					addDelObjByAttr(objGIPIWItmperlBeneficiary, forSplicing[i], "groupedItemNo beneficiaryNo perilCd");
				}					
				resizeTableBasedOnVisibleRows("benPerilTable", "benPerilListing");					
				//checkTableIfEmpty("rowBenPeril", "benPerilTable");				

				// remove parent record
				Effect.Fade(deleteDiv, {
					duration: .2,
					afterFinish: function() {
						addDelObjByAttr(objGIPIWGroupedItems, delObj, "groupedItemNo");
						deleteDiv.remove();
						
						setAccidentGroupedItemForm(null, false);
						//checkIfToResizeTable("accidentGroupedItemsListing", "rowEnrollee");
						resizeTableBasedOnVisibleRows("accidentGroupedItemsTable", "accidentGroupedItemsListing");
						checkTableIfEmpty("rowEnrollee", "accidentGroupedItemsTable");
					}
				});

				//selectAccidentGroupedItemPerilOptionsToShow(delObj.groupedItemNo); // andrew - 01.10.2012 - comment out
			}			
		}	 
	});

	function retrieveGroupedItems(){
		try{
			var objParameters = new Object();

			objParameters.setGroupedItems	= prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems));
			objParameters.delGroupedItems	= prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWGroupedItems));
			/*
			Modalbox.show(contextPath+"/GIPIWAccidentItemController", {
				title: "Retrieve Grouped Items",
				params : {
					action : "retrieveGroupedItems",
					globalParId : objUWParList.parId,
					itemNo : $F("itemNo"),
					parameters : JSON.stringify(objParameters),
					page : 1
				},
				width: 910,
				asynchronous: true
			});			
			*/
			
			overlatAccidentRetrieveGroupedItems = Overlay.show(contextPath + "/GIPIWAccidentItemController", {
				title : "Retrieve Grouped Items",
				urlContent : true,
   				urlParameters : {
   					action : "retrieveGroupedItems",
   					globalParId : objUWParList.parId,
   					itemNo : $F("itemNo"),
   					parameters : JSON.stringify(objParameters),
   					page : 1},
   				width : 600,
   				height : 270,
   				closable : true,
   				draggable : true});   			
   			
			/*
			new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=retrieveGroupedItems", {
				method : "POST",
				parameters : {	
					globalParId : objUWParList.parId,
					itemNo : $F("itemNo")					
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function(){
					showNotice("Retrieving grouped items ...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						//
					}
				}
			});
			*/
		}catch(e){
			showErrorMessage("retrieveGroupedItems", e);
		}
	}

	$("btnRetrieveGrpItems").observe("click", function(){
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=checkIfPerilsExistsForEndt",{
			method : "POST",
			parameters : {
				globalParId : objUWParList.parId,
				itemNo : $F("itemNo")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : function(){
				showNotice("Checking for existing perils ....");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(response.responseText == "Y"){
						showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module", imgMessage.INFO);
						return false;
					}else{
						retrieveGroupedItems();
					}
				}
			}
		});
	}); 

	$("hrefFromDate").observe("click",function (){	// added by steven 9/8/2012
		tempFromDate = $F("grpFromDate");
	});
	$("hrefToDate").observe("click",function (){	// added by steven 9/8/2012
		tempToDate = $F("grpToDate");
	});
	observeBackSpaceOnDate("dateOfBirth");
	observeBackSpaceOnDate("grpFromDate");
	observeBackSpaceOnDate("grpToDate");
	
	showAccidentGroupedItemsList(objGIPIWGroupedItems);	

</script>
	