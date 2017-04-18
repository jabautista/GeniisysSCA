<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
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
			    		<input style="width: 80px; border: none;" id="fromDate" name="fromDate" type="text" value="" readonly="readonly"/>
			    		<img name="accModalDate" id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);" alt="From Date" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 108px; height: 21px; margin-right:3px;">
			    		<input style="width: 80px; border: none;" id="toDate" name="toDate" type="text" value="" readonly="readonly"/>
			    		<img name="accModalDate" id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" alt="To Date" />
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
			   		<input style="width: 80px; border: none; float: left;" id="dateOfBirth" name="dateOfBirth" type="text" value="" readonly="readonly"/>
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
				</td>
			</tr>
		</table>
		
		<table align="center" style="margin-bottom:10px; margin-left:250px;">
			<tr>
				<td class="rightAligned" style="text-align: left; padding-left: 3px;">
					<input type="button" class="button" 		id="btnUploadEnrollees" 	name="btnUploadEnrollees" 		value="Upload Enrollees" 		style="width: 117px;" />
					<input type="button" class="button"			id="btnRetrieveGroupedItems" name="btnRetrieveGroupedItems" value="Retrieve Grp Items"		style="width: 120px;" />
					<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 					style="width: 80px;" />
					<input type="button" class="button" 		id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 					style="width: 80px;" />
				</td>
			</tr>
		</table>
	</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	objSelectedGroupedItems = eval('[]');
	
	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	$$("div#itemTable div[name='row']").each(function(a){
		if (a.hasClassName("selectedRow")){
			fromDateFromItem = a.down("input",14).value;
			toDateFromItem = a.down("input",15).value;
			packBenCdFromItem = a.down("input",27).value;
		}	
	});

	$("controlCd").observe("blur", function () {
		var exist = "N";
		$$("div[name='grpItem']").each(function(grp){
			if (!grp.hasClassName("selectedRow")){
				var controlCd = "";
				var controlTypeCd = "";
				for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
					if (formatNumberDigits(objGipiwGroupedItemsList[i].groupedItemNo, 7) == grp.id){
						controlCd = objGipiwGroupedItemsList[i].controlCd;
						controlTypeCd = objGipiwGroupedItemsList[i].controlTypeCd;
					}
				}	
				if (controlCd == $F("controlCd") && controlTypeCd == $F("controlTypeCd")){
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
	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	$$("div#itemTable div[name='row']").each(function(a){
		if (a.hasClassName("selectedRow")){
			fromDateFromItem = a.down("input",14).value;
			toDateFromItem = a.down("input",15).value;
			packBenCdFromItem = a.down("input",27).value;
		}	
	});

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
				$("fromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("toDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("packBenCd").value = packBenCdFromItem;
			}	
			if(checkEnrolleeCd($F("groupedItemNo"))){
				showMessageBox("Enrollee Id must be unique.", imgMessage.ERROR);
				$("groupedItemNo").value = "";
			}
		}	
		
	});


	function checkEnrolleeCd(enrolleeCd){
		var exists = false;
		
		$$("div[name='grpItem']").each(function (groupedItemNo){
			if (groupedItemNo.id == enrolleeCd){
				exists = true;
			}
		});

		return exists;
	}
	
	$("groupedItemTitle").observe("blur", function () {
		if ($F("groupedItemTitle") != ""){
			if (fromDateFromItem != ""){
				$("fromDate").value = fromDateFromItem;
			}	
			if (toDateFromItem != ""){
				$("toDate").value = toDateFromItem;
			}
			if (packBenCdFromItem != ""){
				$("packBenCd").value = packBenCdFromItem;
			}
			if (checkEnrolleeName($F("groupedItemTitle"))){
				showMessageBox("Enrollee Name must be unique.", imgMessage.ERROR);
				$("groupedItemTitle").value = "";
			}
		}
		var enrolleeName = $F("groupedItemTitle").toUpperCase();
		$("groupedItemTitle").value = enrolleeName;		
	});	

	function checkEnrolleeName(enrolleeName){
		var exists = false;
		
		$$("div[name='grpItem']").each(function (groupedItemTitle){
			if (groupedItemTitle.getAttribute("enrolleeName").toUpperCase() == enrolleeName.toUpperCase()){
				exists = true;
			}
		});

		return exists;
	}

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
					if (formatNumberDigits(a.id, 7) == $F("principalCd"))	{
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

		//added by angelo
		if ($F("dateOfBirth") == "") {
			$("dateOfBirth").value = "01-01-1901";
		}	
		
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

	$("fromDate").observe("blur", function() {
		var fromDate = makeDate($F("fromDate"));
		var toDate = makeDate($F("toDate"));
		var itemFromDate = makeDate(fromDateFromItem);
		var itemToDate = makeDate(toDateFromItem);
		var iDate = makeDate($F("globalInceptDate"));
		var eDate = makeDate($F("globalExpiryDate"));
		
		if (fromDate > toDate){
			showMessageBox("Start of Effectivity date should not be earlier than the End of Effectivity date " + toDate.toString().substring(4, 15) + ".");
			$("fromDate").value = "";
			$("fromDate").focus();				
		} else if (fromDate < iDate){
			showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date " + iDate.toString().substring(4, 15) + ".");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate > eDate){
			showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date " + eDate.toString().substring(4, 15) + ".");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate < itemFromDate){
			showMessageBox("Start of Effectivity date should not be earlier than the Item Inception date " + fromDateFromItem + ".");
			$("fromDate").value = "";
			$("fromDate").focus();
		} else if (fromDate > itemToDate){
			showMessageBox("Start of Effectivity date should not be later than the Item Expiry date " + toDateFromItem + ".");
			$("fromDate").value = "";
			$("fromDate").focus();
		} 
		
	});

	$("toDate").observe("blur", function() {
		
		var fromDate = makeDate($F("fromDate"));
		var toDate = makeDate($F("toDate"));
		var itemFromDate = makeDate(fromDateFromItem);
		var itemToDate = makeDate(toDateFromItem);	
		var iDate = makeDate($F("globalInceptDate"));
		var eDate = makeDate($F("globalExpiryDate"));
		
		if (toDate < fromDate){
			showMessageBox("End of Effectivity date should not be earlier than the Start of Effectivity date " + fromDate.toString().substring(4, 15) + ".");
			$("toDate").value = "";
			$("toDate").focus();				
		} else if (toDate < iDate){
			showMessageBox("End of Effectivity date should not be earlier than the Policy Inception date " + iDate.toString().substring(4, 15) + ".");
			$("toDate").value = "";
			$("toDate").focus();
		} else if (toDate > eDate){
			showMessageBox("End of Effectivity date should not be later than the Policy Expiry date " + eDate.toString().substring(4, 15) + ".");
			$("toDate").value = "";
			$("toDate").focus();
		} else if (toDate < itemFromDate){
			showMessageBox("End of Effectivity date should not be earlier than the Item Inception date " + fromDateFromItem + ".");
			$("toDate").value = "";
			$("toDate").focus();
		} else if (toDate > itemToDate){
			showMessageBox("End of Effectivity date should not be later than the Item Expiry date " + toDateFromItem + ".");
			$("toDate").value = "";
			$("toDate").focus();
		}	
	});

	$("btnRetrieveGroupedItems").observe("click", function () {
		if ($F("perilExists") == "Y"){ //revert to Y after testing...
			showMessageBox('You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module');
		}
		else {
			checkRetrieveGroupedItems();
		}
	});

	function checkRetrieveGroupedItems(){
		var expectedMessage = 'You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module';
		if ($F("itemPerilExist") == "Y" && $F("itemPerilGroupedExist") != "Y"){
			showMessageBox(expectedMessage);
			return false;
		} else {
			new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=checkRetrieveGroupedItems", {
					method: "POST",
					parameters: {
						globalParId:	$F("globalParId"),
						lineCd: 		$F("globalLineCd"),
						sublineCd: 		$F("globalSublineCd"),
						issCd: 			$F("globalIssCd"),
						issueYy: 		$F("globalIssueYy"),
						polSeqNo: 		$F("globalPolSeqNo"),
						renewNo: 		$F("globalRenewNo"),
						itemNo: 		$F("itemNo"),
						effDate: 		$F("globalInceptDate")
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function (response){
						var message = response.responseText;
						if (message == "OK"){
							retrieveGroupedItems();
						} else if(message != expectedMessage){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
			});
		}
	}

	function retrieveGroupedItems(){
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=retrieveGroupedItems", {
				method: "POST",
				parameters: {
					globalParId:	$F("globalParId"),
					lineCd: 		$F("globalLineCd"),
					sublineCd: 		$F("globalSublineCd"),
					issCd: 			$F("globalIssCd"),
					issueYy: 		$F("globalIssueYy"),
					polSeqNo: 		$F("globalPolSeqNo"),
					renewNo: 		$F("globalRenewNo"),
					itemNo: 		$F("itemNo"),
					effDate: 		$F("globalInceptDate")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
					$("popGrpItems").show();
				},
				onComplete: function (response){
					var object = eval(response.responseText);
					//if ($F("retGrpItemsTag") == "N"){
						objRetGipiwGroupedItems = eval(object[0]);
						objRetGipiwCoverageItems = eval(object[1]);
						objRetGipiwGroupedBenItems = eval(object[2]);
						objRetGroupedItemsParams = prepareRetGroupedItemsParams(eval(object[3]));

						fillPopRetGrpItems(objRetGipiwGroupedItems);
					//}
				}
		});
	}

	function prepareRetGroupedItemsParams(groupedItemsParams){
		var params = eval('[]');
		
		for (var i = 0; i < groupedItemsParams.length; i++){
			groupedItemsParams[i].parId 		= $F("globalParId");
			groupedItemsParams[i].lineCd		= $F("globalLineCd");
			groupedItemsParams[i].sublineCd		= $F("globalSublineCd");
			groupedItemsParams[i].issCd			= $F("globalIssCd");
			groupedItemsParams[i].issueYy		= $F("globalIssueYy");
			groupedItemsParams[i].polSeqNo 		= $F("globalPolSeqNo");
			groupedItemsParams[i].renewNo 		= $F("globalRenewNo");
			groupedItemsParams[i].effDate 		= $F("globalInceptDate");

			params.push(groupedItemsParams);
		}

		return params;
	}

	function fillPopRetGrpItems(retGrpItemObject){
		var emptyTag = "Y";
		if (retGrpItemObject == null){
			showMessageBox("No Grouped Items Retrieved", imgMessage.ERROR);
		} else {
			try {
				$$("div[name='popRetGrpItems']").each(function (popRow){
					popRow.remove();
				});
				
				for (var i = 0; i < retGrpItemObject.length; i++){
					if (!checkIfAlreadyInserted(retGrpItemObject[i])){
						retGrpItemsContent = '<label style="text-left: left; margin-right:8px; margin-left:4px;"><input type="checkbox" id="popRetCheck" name="popRetCheck" checked="checked"/></label>' +
											 '<label name="textRetGrpItem" id="num" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">' + retGrpItemObject[i].groupedItemNo + '</label>' + 
											 '<label name="textRetGrpItem" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">' + retGrpItemObject[i].groupedItemTitle + '</label>';
			
						var rgiDiv = new Element("div");
						rgiDiv.setAttribute("id", retGrpItemObject[i].groupedItemNo);
						rgiDiv.setAttribute("name", "popRetGrpItems");
						rgiDiv.setStyle("padding-left : 1px;");
						rgiDiv.addClassName("tableRow");
						rgiDiv.update(retGrpItemsContent);
						$("accidentGrpItemsListing").insert({bottom : rgiDiv});
	
						$("retGrpItemsTag").value = "Y";
						emptyTag = "N";
					}
				}

				if (emptyTag == "Y"){
					showMessageBox('No Grouped Items Retrieved.', imgMessage.ERROR);
				} else {
					showMessageBox('Grouped Items Successfully Retrieved.', imgMessage.INFO);
				}
				
			} catch (e){
				showErrorMessage("fillPopRetGrpItems", e);
			}	
		}

	}

	function checkIfAlreadyInserted(objItem){
		var inserted = false;
		var groupedItemNo = 0;
		
		for (var j = 0; j < objGipiwGroupedItemsList.length; j++){
			if (objGipiwGroupedItemsList[j].inserted == "Y"){
				groupedItemNo = objGipiwGroupedItemsList[j].groupedItemNo;
				if (objItem.groupedItemNo == groupedItemNo &&
					objItem.itemNo == objGipiwGroupedItemsList[j].itemNo){
					inserted = true;
				}
			}
		}

		return inserted;
	}
		
	/*
	$("btnPopulateBenefits").observe("click", function(){
		if ($F("itemPerilExist")== "Y" && $F("itemPerilGroupedExist") != "Y"){
			showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module.", imgMessage.ERROR);
		} else{	
			if (checkGroupedItemNoExist()){
				if ($F("itemPerilGroupedExist") == "Y"){
					showConfirmBox("Message", "This will insert the default perils for the grouped item and overwrite the existing perils. Would  you like to continue?",  
							"Yes", "No", onOkFuncPopBen, onCancelFuncPopBen);
				} else{
					onOkFuncPopBen();
				}	
			} else{
				return false;
			}	
		}	
	});*/

	function onOkFuncPopBen(){
		$$("div[name='popBens']").each(function (a){
			//a.down("input",4).value = "Y";
			a.down("input",0).checked = true;
			a.show();
		});
		checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","popBens","item",$F("itemNo"));
		$("popBenDiv").down("label").update("Populate Benefits");
		$("popBenDiv").show();
		$("btnOkPopBen").show();
		$("btnOkCopyBen").hide();
		$("btnOkDeleteBen").hide();	
	}

	function onCancelFuncPopBen(){
		$("popBenDiv").hide();
		$("btnOkPopBen").show();
		$("btnOkDeleteBen").show();
		$("btnOkCopyBen").show();
	}

	$("btnCopyBenefits").observe("click",function(){
		if (checkGroupedItemNoExist()){
			$("popBenDiv").down("label").update("Copy Benefits");
			$("popBenDiv").show();
			$("btnOkPopBen").hide();
			$("btnOkCopyBen").show();
			$("btnOkDeleteBen").hide();

			$$("div[name='popBens']").each(function (a){
				if (a.getAttribute("id") == "rowPopBens"+$F("itemNo")+""+getSelectedRowAttrValue("grpItem","groupedItemNo")){
					//a.down("input",4).value = "N";
					a.down("input",0).checked = false;
					a.hide();
				} else{
					//a.down("input",4).value = "Y";
					a.down("input",0).checked = true;
					a.show();
				}		
			});
			var ctr = 0;
			$$("div[name='grpItem']").each( function(a)	{
				ctr++;	
			});
			if (ctr<=5){
				$("accidentPopBenTable").setStyle("height: " + (ctr*31) +"px;"); 
			}
		} else{
			return false;
		}
	});	

	$("btnCancelPopBen").observe("click",function(){
		$("popBenDiv").hide();
		$("popBenefitsSw").value = "";
	});

	$("btnOkPopBen").observe("click",function(){
		$("popBenefitsSw").value = "P";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				$("popBenefitsPackBenCd").value = row.down("input",5).value;	
			}	
		});
		if (checkGroupedItemNoExist()){
			okPopBen();
		}
	});

	/*
	$("btnOkCopyBen").observe("click",function(){
		$("popBenefitsSw").value = "C";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
					if (row.id == objGipiwGroupedItemsList[i].groupedItemNo){
						$("popBenefitsPackBenCd").value = objGipiwGroupedItemsList[i].packBenCd;
					}
				}
			}
		});
		if (checkGroupedItemNoExist()){
			okPopBen();
		}
	});	*/

	$("btnOkCopyBen").observe("click", function(){		
		for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
			if (objGipiwGroupedItemsList[i].groupedItemNo == getSelectedRowAttrValue("grpItem", "id") && objGipiwGroupedItemsList[i].itemNo == $F("itemNo")){
				objGipiwGroupedItemsList[i].popBenefitsSw = "C";
				objGipiwGroupedItemsList[i].popBenefitsGroupedItemNo = objGipiwGroupedItemsList[i].groupedItemNo;
				objGipiwGroupedItemsList[i].popBenefitsPackBenCd = objGipiwGroupedItemsList[i].packBenCd;

			}
		}

		if (checkGroupedItemNoExist()){
			okPopBen();
		}
	});	

	$("btnOkDeleteBen").observe("click",function(){
		$("popBenefitsSw").value = "D";
		$("popBenefitsGroupedItemNo").value = getSelectedRowAttrValue("grpItem","groupedItemNo");
		$$("div[name='grpItem']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				$("popBenefitsPackBenCd").value = row.down("input",5).value;	
			}	
		});
		okPopBen();
	});	

	function okPopBen(){
		var ctr = 0;
		
		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});
		if (ctr<2){
			$("newNoOfPerson").value = $("noOfPerson").value;
		} else{
			$("newNoOfPerson").value = ctr;
		}

		for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
			$$("div[name='grpItem']").each(function(row){
				if (row.hasClassName("selectedRow")){
					if (row.id == objGipiwGroupedItemsList[i].groupedItemNo && objGipiwGroupedItemsList[i].itemNo == $F("itemNo")){
						objGipiwGroupedItemsList[i].newNoOfPerson = $F("newNoOfPerson");
					}
				}
			});
		}

		for (var i = 0; i < objGipiwCoverageItems.length; i++){
			$$("div[name='cov']").each(function (covRow){
				if (covRow.hasClassName("selectedRow")){
					if (covRow.getAttribute("groupedItemNo") == objGipiwGroupedItemsList[i].groupedItemNo && objGipiwGroupedItemsList[i].itemNo == $F("itemNo")){
						objGipiwCoverageItems[i].newNoOfPerson = $F("newNoOfPerson");
					}
				}
			});
		}

		saveEndtGroupedItems();
	}

	function saveEndtGroupedItems(){
		var groupedItemsObjParameters = prepareAccEndtGroupedObjParams();

		/*
		new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveAccidentEndtGroupedItemsModal&globalParId="
				+$F("globalParId"), {
			method : "POST",
			parameters : {
				groupedItemsObjParameters : JSON.stringify(groupedItemsObjParameters)		
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function (){
				$("isSaved").value = "Y";
				$("tempSave").value = "";
				$("popBenefitsSw").value = "";
				$("popBenefitsGroupedItemNo").value = "";

			}
		});*/
		
	}
	
	$("btnUploadEnrollees").observe("click",function(){
		showUploadEnrolleesOverlay($("globalParId").value,$("itemNo").value,"");
		document.getElementById("contentHolder").style.width = "885px";
		document.getElementById("contentHolder").style.marginLeft = "52px";
	});

	
</script>
		