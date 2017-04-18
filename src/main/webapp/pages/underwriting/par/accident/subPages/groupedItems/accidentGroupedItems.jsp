<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="acGroupedItemsForm">
	<div id="groupedItemsInformationInfo" class="sectionDiv" style="display: block; width:872px; background-color:white; ">
		
		<div style="margin: 10px; margin-bottom:0px;" id="accidentGroupedItemsTable" name="accidentGroupedItemsTable">
			<div class="tableHeader" style="margin-top: 5px; font-size: 10px;">
				<label style="text-align: left; width: 10%; margin-right: 2px;">Enrollee Code</label>
				<label style="text-align: left; width: 12%; margin-right: 2px;">Enrollee Name</label>
				<label style="text-align: left; width: 11%; margin-right: 0px;">Principal Code</label>
				<label style="text-align: left; width: 8%;  margin-right: 4px;">Plan</label>
				<label style="text-align: left; width: 11%; margin-right: 2px;">Payment Mode</label>
				<label style="text-align: left; width: 12%; margin-right: 2px;">Effectivity Date</label>
				<label style="text-align: left; width: 10%; margin-right: 0px;">Expiry Date</label>
				<label style="text-align: right; width: 9%; margin-right: 2px;">Tsi Amount</label>
				<label style="text-align: right; width: 14%;">Premium Amount</label>
			</div>
			<div id="acGroupedItemsListing" name="acGroupedItemsListing"></div>
		</div>
		
		<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
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
				<td class="rightAligned">Plan</td>
				<td class="leftAligned">
					<select id="grpPackBenCd" name="grpPackBenCd" style="width: ">
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
		    		<img name="accModalDate" id="hrefacgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpFromDate'),this, null);" alt="From Date" />
				</div>
				<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
		    		<input style="width: 80px; border: none;" id="grpToDate" name="grpToDate" type="text" value="" readonly="readonly"/>
		    		<img name="accModalDate" id="hrefacgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpToDate'),this, null);" alt="To Date" />
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
					<select  id="grpSex" name="grpSex" style="width: 223px">
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
			   		<input style="width: 80px; border: none;" id="grpDateOfBirth" name="grpDateOfBirth" type="text" value="" readonly="readonly"/>
			   		<img name="accModalDate" id="hrefGrpBirthDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpDateOfBirth'),this, null);" alt="Birthday" style="margin-right:2px;"/>
				</div>
					Age
					<input id="grpAge" name="grpAge" type="text" style="width: 64px;" maxlength="3" class="integerNoNegativeUnformattedNoComma rightAligned" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
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
					<input id="grpSalary" name="grpSalary" type="text" style="width: 215px;" maxlength="14" class="money"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Occupation </td>
				<td class="leftAligned" >
					<select  id="grpPositionCd" name="=grpPositionCd" style="width: 223px">
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
					<input id="grpIncludeTag" 	name="grpIncludeTag" 	type="hidden" value="" maxlength="1" readonly="readonly"/>
					<input id="grpRemarks" 		name="grpRemarks" 		type="hidden" value=""/>
					<input id="grpLineCd" 		name="grpLineCd" 		type="hidden" value=""/>
					<input id="grpSublineCd" 	name="grpSublineCd" 	type="hidden" value=""/>
					<input id="grpDeleteSw" 	name="grpDeleteSw" 	type="hidden" value=""/>
					<input id="grpAnnTsiAmt" 	name="grpAnnTsiAmt" 	type="hidden" value="" class="money" maxlength="18"/>
					<input id="grpAnnPremAmt" 	name="grpAnnPremAmt" 	type="hidden" value="" class="money" maxlength="14"/>
					<input id="grpTsiAmt" 		name="grpTsiAmt" 		type="hidden" value="" class="money" maxlength="18"/>
					<input id="grpPremAmt" 		name="grpPremAmt" 		type="hidden" value="" class="money" maxlength="14"/>
					<input id="overwriteBen" 	name="overwriteBen" 	type="hidden" value=""/>
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
					<input type="button" class="disabledButton"	id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 					style="width: 60px;" />
				</td>
			</tr>
		</table>
	</div>
	
</div>

<script type="text/javascript">

	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeAccordion2();

	$("btnAddGroupedItems").observe("click", function() {
		try {
			var newObj = setGrpItemsObj();
			var newContent = prepareAcGroupedItemInfo(newObj);
			var tableContainer = $("acGroupedItemsListing");
			
			if($F("btnAddGroupedItems") == "Update") {
				$("grpRow"+$F("itemNo")+$F("groupedItemNo")).update(newContent);
				addModifiedGroupedJSONObj(objGIPIWGroupedItems, newObj);
			} else {
				newObj.recordStatus = 0;
				objGIPIWGroupedItems.push(newObj);
				
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "grpRow"+newObj.itemNo+newObj.groupedItemNo/*+newObj.perilCd*/);
				newDiv.setAttribute("name", "grpRow");
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setAttribute("grpItem", newObj.groupedItemNo);
				newDiv.addClassName("tableRow");
				newDiv.setStyle({fontSize: '10px'});	

				newDiv.update(newContent);
				tableContainer.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
				clickACGrouped(newObj, newDiv);
			}
			setACGroupedForm(null);
			checkIfToResizeTable("acGroupedItemsListing", "grpRow");
			checkTableIfEmpty("grpRow", "accidentGroupedItemsTable");
		} catch(e) {
			showErrorMessage("addGroupedItems", e);
		}
	});

	function setGrpItemsObj() {
		try {
			var newObj = new Object();

			newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo 			= $F("itemNo");
			newObj.groupedItemNo	= $F("groupedItemNo");
			newObj.includeTag		= $F("grpIncludeTag");
			newObj.groupedItemTitle	= $F("groupedItemTitle");
			newObj.groupCd			= $F("groupCd");
			newObj.amountCovered	= $F("amountCovered");
			newObj.remarks			= $F("grpRemarks");
			newObj.lineCd			= $F("grpLineCd");
			newObj.sublineCd		= $F("grpSublineCd");
			newObj.sex				= $F("grpSex");
			newObj.positionCd		= $F("grpPositionCd");
			newObj.civilStatus		= $F("civilStatus");
			newObj.dateOfBirth		= $F("grpDateOfBirth") == "" ? null : makeDate($F("grpDateOfBirth"));
			newObj.age				= $F("grpAge");
			newObj.salary			= $F("grpSalary");
			newObj.salaryGrade		= $F("salaryGrade");
			newObj.deleteSw			= $F("grpDeleteSw");
			newObj.fromDate			= $F("grpFromDate") == "" ? null : makeDate($F("grpFromDate"));
			newObj.toDate			= $F("grpToDate") == "" ? null : makeDate($F("grpToDate"));
			newObj.paytTerms		= $F("paytTerms");
			newObj.packBenCd		= $F("grpPackBenCd");
			newObj.annTsiAmt		= $F("grpAnnTsiAmt");
			newObj.annPremAmt		= $F("grpAnnPremAmt");
			newObj.tsiAmt			= $F("grpTsiAmt");
			newObj.premAmt			= $F("grpPremAmt");
			newObj.controlCd		= $F("controlCd");
			newObj.controlTypeCd	= $F("controlTypeCd");
			newObj.principalCd		= $F("principalCd");
			//newObj.packageCd		= "";
			//newObj.paytTermsDesc	= "";
		
			return newObj;
		} catch (e) {
			showErrorMessage("setGrpItemObj", e);
		}
	}

	$("btnDeleteGroupedItems").observe("click", function() {
		try {
			var itemNo = $F("itemNo");
			var grpItemNo = $F("groupedItemNo");
			$$("div#accidentGroupedItemsTable div[id='grpRow"+itemNo+grpItemNo+"']").each(function(row) {
				Effect.Fade(row, {
					duration: .2,
					afterFinish : function() {
						var delObj = setGrpItemsObj();
						addDeletedGroupedJSONObj(objGIPIWGroupedItems, delObj);
						row.remove();

						setACGroupedForm(null);
						checkIfToResizeTable("acGroupedItemsListing", "grpRow");
						checkTableIfEmpty("grpRow", "accidentGroupedItemsTable");
					}
				});
			}); 
		} catch(e) {
			showErrorMessage("deleteGroupedItems", e);
		}
	});

	$("grpPackBenCd").observe("change", function() {
		var exists = false;
		if($F("groupedItemNo") == "") {
			showMessageBox("Enrollee Code must be entered.", imgMessage.ERROR);
			exists = true;
		} else if($F("groupedItemTitle") == "") {
			showMessageBox("Enrollee Name must be entered.", imgMessage.ERROR);
			exists = true;	
		}

		if (!exists){
			showConfirmBox("Message", "Selecting/changing a plan will populate/overwrite perils for this grouped item. Would you like to continue?",  
					"Yes", "No", onOkFuncPopBen, onCancelFuncPopBen);
		} else{
			onCancelFuncPopBen();
		}
	});

	function onOkFuncPopBen() {
		showMessageBox("ok");
	}

	function onCancelFuncPopBen() {
		showMessageBox("cancel");
	}
	
	function initializeAccordion2()	{
		$$("label[name='gro2']").each(function (label)	{
			label.observe("click", function ()	{
				label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
				var infoDiv = label.up("div", 1).next().readAttribute("id");
				Effect.toggle(infoDiv, "blind", {duration: .3});
				Effect.toggle("groupedItemsInformationInfo2", "blind", {duration: .3});
			});
		});
	
		$$("label[name='gro3']").each(function (label)	{
			label.observe("click", function ()	{
				if ($F("itemPerilExist") == "Y" && $F("itemPerilGroupedExist") != "Y"){
					showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module");
					return false;
				} else{
					label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
					var infoDiv = label.up("div", 1).next().readAttribute("id");
					Effect.toggle(infoDiv, "blind", {duration: .3});
				}		
			});
		});
	}

	$("controlCd").observe("blur", function () {
		var exist = "N";
		var  objArr = objGIPIWGroupedItems;

		for(var i=0; i<objArr.length; i++) {
			if(objArr[i].controlCd == $F("controlCd") && objArr[i].controlTypeCd == $F("controlTypeCd")) {
				exist = "Y";
			}
		}

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

	$("groupedItemNo").observe("blur", function () {
		if ($F("groupedItemNo") != ""){
			isNumber("groupedItemNo","Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.","");
			if($F("groupedItemNo") < 1) {
				showMessageBox("Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999.",imgMessage.ERROR);
				$("groupedItemNo").value = "";
				$("groupedItemNo").focus();
				return false;
			}
			$("groupedItemNo").value = formatNumberDigits($F("groupedItemNo"),7);
			if (fromDateFromItem != ""){
				$("grpFromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("grpToDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("grpPackBenCd").value = packBenCdFromItem;
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
				$("grpPackBenCd").value = packBenCdFromItem;
			}
		}	
	});	

	$("principalCd").observe("blur", function() {
		if ($F("principalCd") != ""){
			isNumber("principalCd","Entered Principal Code is invalid. Valid value is from 0000001 to 9999999.","");

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
			} else {
				var exists = false;
				for(var i=0; i<objGIPIWGroupedItems.length; i++) {
					if($F("principalCd") == objGIPIWGroupedItems[i].groupedItemNo) {
						exists = true;
					}
				}
				if(!exists) {
					showMessageBox("Non-existing enrollee could not be used as Principal enrollee.", imgMessage.ERROR);
					$("principalCd").value = "";
					$("principalCd").focus();
					return false;
				}
			}
		}
	});

	$("grpAge").observe("blur", function () {
		if (parseInt($F("grpAge")) > 999 || parseInt($F("grpAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("age").value ="";
			return false;
		} else{
			isNumber("grpAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("grpDateOfBirth").observe("blur", function () {
		$("age").value = computeAge($("grpDateOfBirth").value);
		checkBday();
	});

	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("grpDateOfBirth"));
		if (bday>today){
			$("grpDateOfBirth").value = "";
			$("grpAge").value = "";
			hideNotice("");
		}	
	}

	$("grpSalary").observe("blur", function() {
		if (parseFloat($F('grpSalary').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered salary is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("grpSalary").focus();
			$("grpSalary").value = "0.00";
		} else if (parseFloat($F('grpSalary').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered salary is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("grpSalary").focus();
			$("grpSalary").value = "0.00";
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
		var fromDate = makeDate($F("grpFromDate"));
		var toDate = makeDate($F("grpToDate"));
		var itemFromDate = makeDate(fromDateFromItem);
		var itemToDate = makeDate(toDateFromItem);
		var iDate = ($F("wpolbasInceptDate"));
		var eDate = ($F("wpolbasExpiryDate"));
		
		if (fromDate > toDate){
			showMessageBox("Start of Effectivity date should not be earlier than the End of Effectivity date.");
			$("fromDate").value = "";
			$("fromDate").focus();				
		} else if (fromDate < iDate){
			showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate > eDate){
			showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date.");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate < itemFromDate){
			showMessageBox("Start of Effectivity date should not be earlier than the Item Inception date.");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate > itemToDate){
			showMessageBox("Start of Effectivity date should not be later than the Item Expiry date.");
			$("fromDate").value = "";
			$("fromDate").focus();
		}	
	});
</script>