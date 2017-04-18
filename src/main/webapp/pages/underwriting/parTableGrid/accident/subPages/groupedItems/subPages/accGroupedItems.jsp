<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<script type="text/javascript">
	objGIPIWGroupedItems = [];
	objGIPIWItmperlGrouped = [];
	objGIPIWGrpItemsBeneficiary = [];
	objGIPIWItmperlBeneficiary = [];
</script>
<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;">
	<div id="innerDiv" name="innerDiv">
		<label>Grouped Items/Beneficiary Information</label>
			<span class="refreshers" style="margin-top: 0;">
			<label id="showAccGroupedItems" name="groItem" style="margin-left: 5px;">Hide</label>
		</span>
	</div>	
</div>
<div id="groupedItemsInformationInfo" class="sectionDiv" style="display: block; width:872px; background-color:white;">
	<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accGroupedItemsTableGridListing.jsp"></jsp:include>
	<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 90px;" for="groupedItemNo">Enrollee Code </td>
			<td class="leftAligned" style="">
				<!-- 
				<input tabindex="10001" id="groupedItemNo" name="groupedItemNo" type="text" style="width: 184px;" maxlength="7" class="required integerUnformattedOnBlur" min="1" max="9999999" errorMsg="Entered Enrollee Code is invalid. Valid value is from 0000001 to 9999999." />
				 -->
				<input tabindex="10001" id="groupedItemNo" name="groupedItemNo" type="text" style="width: 184px;" maxlength="7" class="required applyWholeNosRegExp" regExpPatt="pDigit07" min="1" max="9999999" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" />
			</td>
			<td class="rightAligned" style="width: 70px;">Sex </td>
			<td class="leftAligned" style="width: 170px;">
				<select tabindex="10007" id="grpSex" name="grpSex" style="width: 182px">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
			<td class="rightAligned" style="width: 100px;">Control Type </td>
			<td class="leftAligned" style="width: 165px;">
				<select tabindex="10013" id="controlTypeCd" name="controlTypeCd" style="width: 182px">
					<option value=""></option>
					<c:forEach var="controlTypes" items="${controlTypes}">
						<option value="${controlTypes.controlTypeCd}">${controlTypes.controlTypeDesc}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Enrollee Name </td>
			<td class="leftAligned">
				<input tabindex="10002" id="groupedItemTitle" name="groupedItemTitle" type="text" style="width: 184px;" maxlength="50" class="required allCaps"/>
			</td>
			<td class="rightAligned" >Birthday </td>
			<td class="rightAligned">
				<div style="float:left; border: solid 1px gray; width: 98px; height: 21px; margin-right:3px; margin-left:4px;">
			   		<input tabindex="10008" style="width: 70px; border: none; float: left;" id="grpDateOfBirth" name="grpDateOfBirth" type="text" value="" readonly="readonly"/>
			   		<img name="accModalDate" id="hrefGrpBirthDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpDateOfBirth'),this, null);" alt="Birthday" style="margin-right:2px;" class="hover" />
				</div>
				<label class="rightAligned" style="margin-top: 5px;margin-left: 4px;">Age</label>
				<input tabindex="10009" id="grpAge" name="grpAge" type="text" style="width: 40px;" maxlength="3" class="integerNumbersOnly leftAligned" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Control Code </td>
			<td class="leftAligned" >
				<input tabindex="10014" id="controlCd" name="controlCd" type="text" style="width: 175px;" maxlength="250"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Principal Code </td>
			<td class="leftAligned">
				<div style="float: left;">
					<input tabindex="10003" id="principalCd" name="principalCd" type="text" style="width: 38px;" maxlength="5" class="integerUnformattedOnBlur" min="1" max="99999" errorMsg="Entered Principal Code is invalid. Valid value is from 00001 to 99999."/>
				</div>
				<div style="float: right;">
					<label style="margin-top: 5px;margin-left: 5px;">Plan </label>
					<select tabindex="10004" id="grpPackBenCd" name="grpPackBenCd" style="margin-left: 7px;width: 108px; margin-top: 2px;">
						<option value=""></option>
						<c:forEach var="plans" items="${plans}">
							<option value="${plans.packBenCd}">${plans.packageCd}</option>
						</c:forEach>					
					</select>
				</div>				
			</td>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned" >
				<select tabindex="10010" id="civilStatus" name="civilStatus" style="width: 182px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStatus}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" for="grpSalary">Salary </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="10015" id="grpSalary" name="grpSalary" type="text" style="width: 175px;" maxlength="14" class="money2" min="0" max="9999999999.99" errorMsg="Entered salary is invalid. Valid value is from 0.00 to 9,999,999,999.99." />
				 -->
				<input tabindex="10015" id="grpSalary" name="grpSalary" type="text" style="width: 175px;" maxlength="14" class="applyDecimalRegExp" regExpPatt="pDeci1002" min="0" max="9999999999.99" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Payment Mode </td>
			<td class="leftAligned">
				<select tabindex="10005" id="paytTerms" name="paytTerms" style="width: 192px">
					<option value=""></option>
					<c:forEach var="payTerms" items="${payTerms}">
						<option value="${payTerms.paytTerms}">${payTerms.paytTermsDesc}</option>				
					</c:forEach>
				</select>				
			</td>
			<td class="rightAligned" >Occupation </td>
			<td class="leftAligned" >
				<select tabindex="10011" id="grpPositionCd" name="=grpPositionCd" style="width: 182px">
					<option value=""></option>
					<c:forEach var="positionCds" items="${positionListing}">
						<option value="${positionCds.positionCd}">${positionCds.position}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" >Salary Grade </td>
			<td class="leftAligned" >
				<input tabindex="10016" id="salaryGrade" name="salaryGrade" type="text" style="width: 175px;" maxlength="3"/>
			</td>			
		</tr>		
		<tr>
			<td class="rightAligned" >Effectivity Date </td>
			<td class="leftAligned">
				<div style="float:left; border: solid 1px gray; width: 92px; height: 21px; margin-right:3px;">
		    		<input tabindex="10006" style="width: 62px; border: none; float: left;" id="grpFromDate" name="grpFromDate" type="text" value="" readonly="readonly"/>
		    		<img name="accModalDate" id="hrefacgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpFromDate'),this, null);" style="float: right;" alt="From Date" class="hover" />
				</div>
				<div style="float:right; border: solid 1px gray; width: 92px; height: 21px;">
		    		<input tabindex="10006" style="width: 62px; border: none; float: left;" id="grpToDate" name="grpToDate" type="text" value="" readonly="readonly"/>
		    		<img name="accModalDate" id="hrefacgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('grpToDate'),this, null);" style="float: right;" alt="To Date" class="hover" />
				</div>
			</td>
			<td class="rightAligned" >Group </td>
			<td class="leftAligned" >
				<select tabindex="10012" id="groupCd" name="groupCd" style="width: 182px">
					<option value=""></option>
					<c:forEach var="groups" items="${groups}">
						<option value="${groups.groupCd}">${groups.groupDesc}</option>				
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" for="amountCovered">Amount Covered </td>
			<td class="leftAligned">				
				<input tabindex="10017" id="amountCovered" name="amountCovered" type="text" style="width: 175px;" class="money2" maxlength="18" readonly="readonly" min="-9999999999.99" max="9999999999.99" errorMsg="Entered salary is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99." />
			</td>
		</tr>
		<tr>
			<td>
				<input id="grpIncludeTag" 	name="grpIncludeTag" 	type="hidden" value="Y" maxlength="1" readonly="readonly"/>
				<input id="grpRemarks" 		name="grpRemarks" 		type="hidden" value=""/>
				<input id="grpLineCd" 		name="grpLineCd" 		type="hidden" value=""/>
				<input id="grpSublineCd" 	name="grpSublineCd" 	type="hidden" value=""/>
				<input id="grpDeleteSw" 	name="grpDeleteSw" 		type="hidden" value=""/>
				<input id="grpAnnTsiAmt" 	name="grpAnnTsiAmt" 	type="hidden" value="" class="money" maxlength="18"/>
				<input id="grpAnnPremAmt" 	name="grpAnnPremAmt" 	type="hidden" value="" class="money" maxlength="14"/>
				<input id="grpTsiAmt" 		name="grpTsiAmt" 		type="hidden" value="" class="money" maxlength="18"/>
				<input id="grpPremAmt" 		name="grpPremAmt" 		type="hidden" value="" class="money" maxlength="14"/>
				<input id="overwriteBen" 	name="overwriteBen" 	type="hidden" value=""/>
				<input id="applyRenumber"	name="applyRenumber"	type="hidden" value="N" />
			</td>
		</tr>
	</table>
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 3px;">
				<input tabindex="10018" type="button" class="button" 			id="btnUploadEnrollees" 	name="btnUploadEnrollees" 		value="Upload Enrollees" 		style="width: 110px;" />
				<input tabindex="10019" type="button" class="button" 			id="btnPopulateBenefits" 	name="btnPopulateBenefits" 		value="Populate Benefits" 		style="width: 110px;" />
				<input tabindex="10020" type="button" class="disabledButton" 	id="btnDeleteBenefits" 		name="btnDeleteBenefits" 		value="Delete Benefits" 		style="width: 110px;" />
				<input tabindex="10021" type="button" class="button" 			id="btnRenumberGrp" 		name="btnRenumberGrp" 			value="Renumber" 				style="width: 110px;" />
				<input tabindex="10022" type="button" class="button" 			id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 					style="width: 110px;" />
				<input tabindex="10223" type="button" class="disabledButton"	id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 					style="width: 110px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
try{
	observeBackSpaceOnDate("grpFromDate");
	observeBackSpaceOnDate("grpToDate");
	function validateGroupedItemNo(action){
		try{
			var m = $("groupedItemNo");
			
			if(m.getAttribute("executeOnBlur") != "N"){
				if(!((m.value).empty())){				
					var objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
						&& obj.groupedItemNo == $F("groupedItemNo");	});
					
					if(objArrFiltered.length > 0 && $F("btnAddGroupedItems") == "Add"){				
						customShowMessageBox("Grouped Item No. must be unique.", imgMessage.ERROR, "groupedItemNo");
						return false;
					}else{
						$("grpFromDate").value 	= $F("fromDate") != "" ? $F("fromDate") : "";
						$("grpToDate").value 	= $F("toDate") != "" ? $F("toDate") : "";
						$("grpPackBenCd").value = $F("accidentPackBenCd") != "" ? $F("accidentPackBenCd") : "" ;
						
						$("grpFromDate").setAttribute("lastValidValue", $F("grpFromDate"));	
						$("grpToDate").setAttribute("lastValidValue", $F("grpToDate"));
						
						$("groupedItemNo").setAttribute("lastValidValue", $F("groupedItemNo"));
					}				
				}
			}						
		}catch(e){
			showErrorMessage("validateGroupedItemNo", e);
		}
	}
	
	$("groupedItemNo").observe("keyup", function(e){		
		var m = $("groupedItemNo");
		var pattern = m.getAttribute("regExpPatt");
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox(getNumberFieldErrMsg(m, false), imgMessage.ERROR, function(){					
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{
				m.value = (m.value).match(RegExWholeNumber[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}		 
		}else{
			m.value = (m.value).match(RegExWholeNumber[pattern])[0];
			m.setAttribute("executeOnBlur", "Y");
		}			   						
	});
	
	$("groupedItemNo").observe("blur", function(){ validateGroupedItemNo("blur");});
	$("groupedItemNo").observe("change", function(){ validateGroupedItemNo("change");});
	
	$("groupedItemTitle").observe("blur", function(){
		if($F("groupedItemTitle") != ""){
			var objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") 
				&& obj.groupedItemTitle == $F("groupedItemTitle");	});
			
			if(objArrFiltered.length > 0 && $F("btnAddGroupedItems") == "Add"){				
				customShowMessageBox("Grouped Item Title must be unique.", imgMessage.ERROR, "groupedItemTitle");
				return false;
			}else{
				$("grpFromDate").value 	= $F("fromDate") != "" ? $F("fromDate") : "";
				$("grpToDate").value 	= $F("toDate") != "" ? $F("toDate") : "";
				$("grpPackBenCd").value = $F("accidentPackBenCd") != "" ? $F("accidentPackBenCd") : "" ;
				
				$("grpFromDate").setAttribute("lastValidValue", $F("grpFromDate"));	
				$("grpToDate").setAttribute("lastValidValue", $F("grpToDate"));
			}
		}
	});
	
	$("principalCd").observe("blur", function() {
		if ($F("principalCd") != ""){
			//isNumber("principalCd","Entered Principal Code is invalid. Valid value is from 00001 to 99999.","");

			if ($F("principalCd") == $F("groupedItemNo")){
				customShowMessageBox("Principal enrollee cannot be the same as enrollee.",imgMessage.ERROR, "principalCd");				
				return false;
			} else if($F("principalCd") == 0){
				customShowMessageBox("Entered Principal Code is invalid. Valid value is from 00001 to 99999.", imgMessage.ERROR, "principalCd");
				return false;
			} else {
				var objArrFiltered = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.groupedItemNo == $F("principalCd");	});
				
				if(objArrFiltered.length < 1){
					customShowMessageBox("Non-existing enrollee could not be used as Principal enrollee.", imgMessage.ERROR, "principalCd");
					return false;
				}				
			}
		}
	});
	
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("grpDateOfBirth"));
		if (bday>today){
			$("grpDateOfBirth").value = "";
			$("grpAge").value = "";			
		}	
	}
	
	$("grpDateOfBirth").observe("blur", function () {
		if(!($F("grpDateOfBirth").empty())){
			$("grpAge").value = computeAge($("grpDateOfBirth").value);
			checkBday();
		}		
	});
	
	$("grpFromDate").observe("blur", function() {
		var fromDate = $F("grpFromDate");
		var toDate = $F("grpToDate");
		var itemFromDate = $F("fromDate");
		var itemToDate = $F("toDate");
		//var inceptDate = objGIPIWPolbas.inceptDate.split(" ")[0];
		var inceptDate = objGIPIWPolbas.formattedInceptDate.split(" ")[0]; // andrew - 02.07.2012 - use the java formatted date
		//var expiryDate = objGIPIWPolbas.expiryDate.split(" ")[0];		
		var expiryDate = objGIPIWPolbas.formattedExpiryDate.split(" ")[0]; // andrew - 02.07.2012 - use the java formatted date
		
		if(!(fromDate.empty()) && !(toDate.empty())){
			if(!(fromDate.empty())){
				fromDate = makeDate(fromDate);
				toDate = makeDate(toDate);
				itemFromDate = makeDate(itemFromDate);
				itemToDate = makeDate(itemToDate);
				inceptDate = makeDate(inceptDate);
				expiryDate = makeDate(expiryDate);
				
				if(fromDate > toDate){
					$("grpFromDate").value = $("grpFromDate").getAttribute("lastValidValue");	
					customShowMessageBox("Effectivity date should not be later than the Expiry date.", imgMessage.INFO, "grpFromDate");
					return false;
				}else if(fromDate < inceptDate){
					$("grpFromDate").value = $("grpFromDate").getAttribute("lastValidValue");
					customShowMessageBox("Effectivity date should not be earlier than the Policy Inception date.", imgMessage.INFO, "grpFromDate");
					return false;
				}else if(fromDate > expiryDate){
					$("grpFromDate").value = $("grpFromDate").getAttribute("lastValidValue");
					customShowMessageBox("Effectivity date should not be later than the Policy Expiry date.", imgMessage.INFO, "grpFromDate");
					return false;
				}else if(fromDate < itemFromDate){
					$("grpFromDate").value = $("grpFromDate").getAttribute("lastValidValue");
					customShowMessageBox("Effectivity date should not be earlier than the Item Inception date.", imgMessage.INFO, "grpFromDate");
					return false;
				}else if(fromDate > itemToDate){
					$("grpFromDate").value = $("grpFromDate").getAttribute("lastValidValue");
					customShowMessageBox("Effectivity date should not be later than the Item Expiry date.", imgMessage.INFO, "grpFromDate");
					return false;
				}else{
					$("grpFromDate").setAttribute("lastValidValue", $F("grpFromDate"));	
				}
			}
		}		
	});
	
	$("grpToDate").observe("blur", function() {
		var fromDate = $F("grpFromDate");
		var toDate = $F("grpToDate");
		var itemFromDate = $F("fromDate");
		var itemToDate = $F("toDate");
		//var inceptDate = objGIPIWPolbas.inceptDate.split(" ")[0];
		var inceptDate = objGIPIWPolbas.formattedInceptDate.split(" ")[0]; // andrew - 02.07.2012 - use the java formatted date
		//var expiryDate = objGIPIWPolbas.expiryDate.split(" ")[0];
		var expiryDate = objGIPIWPolbas.formattedExpiryDate.split(" ")[0]; // andrew - 02.07.2012 - use the java formatted date
		
		if(!(fromDate.empty()) && !(toDate.empty())){
			fromDate = makeDate(fromDate);
			toDate = makeDate(toDate);
			itemFromDate = makeDate(itemFromDate);
			itemToDate = makeDate(itemToDate);
			inceptDate = makeDate(inceptDate);
			expiryDate = makeDate(expiryDate);
			
			if(toDate < fromDate){
				$("grpToDate").value = $("grpToDate").getAttribute("lastValidValue");
				customShowMessageBox("Expiry date should not be earlier than the Effectivity date.", imgMessage.INFO, "grpToDate");
				return false;
			}else if(toDate < inceptDate){
				$("grpToDate").value = $("grpToDate").getAttribute("lastValidValue");
				customShowMessageBox("Expiry date should not be earlier than the Policy Inception date.", imgMessage.INFO, "grpToDate");
				return false;
			}else if(toDate > expiryDate){
				$("grpToDate").value = $("grpToDate").getAttribute("lastValidValue");
				customShowMessageBox("Expiry date should not be later than the Policy Expiry date.", imgMessage.INFO, "grpToDate");
				return false;
			}else if(toDate < itemFromDate){
				$("grpToDate").value = $("grpToDate").getAttribute("lastValidValue");
				customShowMessageBox("Expiry date should not be earlier than the Item Inception date.", imgMessage.INFO, "grpToDate");
				return false;
			}else if(toDate > itemToDate){
				$("grpToDate").value = $("grpToDate").getAttribute("lastValidValue");
				customShowMessageBox("Expiry date should not be later than the Item Expiry date.", imgMessage.INFO, "grpToDate");
				return false;
			}else{
				$("grpToDate").setAttribute("lastValidValue", $F("grpToDate"));	
			}
		}		
	});	
	
	function addAccidentGroupedItems(){
		try{
			var newObj = setAccidentGroupedItemsObj();
			
			if($F("btnAddGroupedItems") == "Update"){
				addModedObjByAttr(objGIPIWGroupedItems, newObj, "groupedItemNo");							
				tbgGroupedItems.updateVisibleRowOnly(newObj, tbgGroupedItems.getCurrentPosition()[1]);
				changeTag = 1;
			}else{
				if (objUWParList.binderExist == "Y"){
					showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
					return false;
				}
				
				addNewJSONObject(objGIPIWGroupedItems, newObj);
				tbgGroupedItems.addBottomRow(newObj);			
			}
			
			setACGroupedItemFormTG(null);
			changeTag = 1; //added by steve 8.22.2012
			($$("div#groupedItemsDetail [changed=changed]")).invoke("removeAttribute", "changed");
			changeTag = 1;
		}catch(e){
			showErrorMessage("addAccidentGroupedItems", e);
		}
	}
	
	$("btnAddGroupedItems").observe("click", function(){		
		if ($F("groupedItemNo") == "") {
			//showMessageBox("Enrollee Code is required.", imgMessage.ERROR);
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "groupedItemNo");
			return false;
		} else if ($F("groupedItemTitle") == "") {
			//showMessageBox("Enrollee Name is required.", imgMessage.ERROR);
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "groupedItemTitle");
			return false;
		}	
		
		
		
		addAccidentGroupedItems();
	});
	
	$("btnDeleteGroupedItems").observe("click", function(){
		var delObj = setAccidentGroupedItemsObj();
		
		if (objUWParList.binderExist == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
			return false;
		}
		
		if(objGIPIWGroupedItems.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.principalCd == delObj.groupedItemNo; }).length > 0){
			showMessageBox("Cannot delete enrollee if used as a principal enrollee.", imgMessage.ERROR);
			return false;
		}
		
		addDelObjByAttr(objGIPIWGroupedItems, delObj, "groupedItemNo");			
		tbgGroupedItems.deleteVisibleRowOnly(tbgGroupedItems.getCurrentPosition()[1]);
		setACGroupedItemFormTG(null);
		updateTGPager(tbgGroupedItems);
		
		// clear related table grid
		deleteParItemTG(tbgItmperlGrouped);
		deleteParItemTG(tbgGrpItemsBeneficiary);
		deleteParItemTG(tbgItmperlBeneficiary);
		
		// clear related table form fields
		setItmperlGroupedFormTG(null);				
		setGrpItemBeneficiaryFormTG(null);
		setItmperlBeneficiaryFormTG(null);
		
		changeTag = 1;
	});
	
	function onOkFuncPopBen() {
		showMessageBox("ok");
	}

	function onCancelFuncPopBen() {
		showMessageBox("cancel");
	}
	
	$("grpPackBenCd").observe("change", function() {
		var exists = false;
		if($F("groupedItemNo") == "") {
			showMessageBox("Enrollee Code must be entered.", imgMessage.ERROR);
			return false;
		} else if($F("groupedItemTitle") == "") {
			showMessageBox("Enrollee Name must be entered.", imgMessage.ERROR);
			return false;	
		}
		
		showConfirmBox("Message", "Selecting/changing a plan will populate/overwrite perils for this grouped item. Would you like to continue?", "Yes", "No", 
				function(){ 
					objFormMiscVariables.miscPlanPopulateBenefits = "Y";
					$("accidentPackBenCd").value = $F("grpPackBenCd");
					addModifiedJSONObject(objGIPIWItem, setParItemObj());
				}, "");		
	});
	
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
	
	/*	buttons */	
	
	$("btnPopulateBenefits").observe("click", function(){
		//if(hasPendingGroupedItemsChildRecords()){		
		if(changeTag != 0){
			showMessageBox("Please save changes first.", imgMessage.INFO);
			return false;
		}else{
			if(objGIPIWGroupedItems.filter(function(o){ return nvl(o.recordStatus, 0) != -1; }).length < 1){
				showMessageBox("No grouped item record found.", imgMessage.INFO);
				return false;
			}else{
				var itemPerilExist = objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1; }).length > 0 ? true : false;
				var grpPerilExist =  objGIPIWItmperlGrouped.filter(function(o){ return nvl(o.recordStatus, 0) != -1; }).length > 0 ? true : false;
				
				if(itemPerilExist && !(grpPerilExist)){
					showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. " +
							"Please check the records in the item peril module.", imgMessage.ERROR);
				}else{
					if(grpPerilExist){
						showConfirmBox("Message", "This will insert the default perils for the grouped item and overwrite the existing perils. Would  you like to continue?",  
								"Yes", "No", function(){	showPopulateBenefits("Copy", 0, "", "Y");	}, "");
					}else{				
						showPopulateBenefits("Copy", 0, "", "Y");
					}
				}
			}			
		}		
	});
	
	$("btnDeleteBenefits").observe("click", function(){
		showPopulateBenefits("Delete", 0, "", "Y");
	});
	
	function genericRenumber(objArray, basisCol, noExistingRecordMssg, nonSequentialMssg, confirmMssg, onOkFunc, onCancelFunc){
		try{
			var consecutive = true;
			var previousValue = 0;		
			
			if(objArray.length > 0){
				var arrSortedItem = objArray.slice(0);			
				
				arrSortedItem = arrSortedItem.sort(function(objPre, objCurr){	return objPre[basisCol] - objCurr[basisCol];	});
				
				for(var i=0, length=arrSortedItem.length; i < length; i++){			
					if((arrSortedItem[i][basisCol] - previousValue) == 1){
						previousValue = arrSortedItem[i][basisCol];
					}else{
						consecutive = false;
					}
				}

				if(consecutive){
					showMessageBox(nonSequentialMssg, imgMessage.INFO);
				}else{				
					showConfirmBox("Renumber", confirmMssg,	"Continue", "Cancel", onOkFunc, onCancelFunc);
				}
			}else{
				showMessageBox(noExistingRecordMssg, imgMessage.INFO);
			}	
		}catch(e){
			showErrorMessage("genericRenumber", e);
		}	
	}
	
	$("btnRenumberGrp").observe("click", function(){
		function grpRenumber(){
			genericRenumber(objGIPIWGroupedItems, "groupedItemNo", "Renumber will only work if there are existing group items.",
					"Renumber will only work if group item are not arranged consecutively.", 
					"Renumber will automatically reorder your group item number(s) sequentially. Do you want to continue?",
					function(){
						new Ajax.Request(contextPath + "/GIPIWGroupedItemsController", {
							parameters : {
								action : "renumberGroupedItems",
								parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
			   					itemNo : $F("itemNo")
							},
							evalScripts : true,
							asynchronous : false,
							onComplete : function(response){
								if(checkErrorOnResponse(response)){
									showWaitingMessageBox("Grouped Items had been renumbered.", imgMessage.INFO, function(){ $("btnGroupedItems").click(); });
								}else{
									showMessageBox(response.responseText, imgMessage.ERROR);
								}
							}
						});						
					}, function(){ return false;});
		}
		
		if(hasPendingGroupedItemsChildRecords()){
			//showConfirmBox("Message", "Changes made will automatically be saved. Do you want to continue?", "Yes", "No", 
			//		function(){	$("applyRenumber").value = "Y";	grpRenumber();	}, function(){	$("applyRenumber").value = "N";	});
			showMessageBox("Please save changes first.", imgMessage.INFO);
			return false;
		}else{
			grpRenumber();
		}
	});
	
	$("btnUploadEnrollees").observe("click",function(){
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
		showUploadEnrolleesOverlay2(parId, $F("itemNo"), "");
	});
}catch(e){
	showErrorMessage("Accident Grouped Items Page", e);
}
</script>