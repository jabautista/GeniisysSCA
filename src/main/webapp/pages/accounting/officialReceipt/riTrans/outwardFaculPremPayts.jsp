<!--
Remarks: For deletion
Date : 05-16-2012
Developer: S. Ramirez
Replacement : /pages/accounting/officialReceipt/riTrans/outwardFaculPremPaytsTableGrid.jsp
--> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="outwardFaculPremPaymtsDivMain" changeTagAttr="true">
	<!-- Hidden Fields -->
		<input type="hidden" id="hiddenBinderId" />
		<input type="hidden" id="hiddenAssdNo" />
		<input type="hidden" id="hiddenConvertRate" />
		<input type="hidden" id="hiddenPolicyId" />
		<input type="hidden" id="hiddenIssCd" />
		<input type="hidden" id="hiddenPremSeqNo" />
		<input type="hidden" id="hiddenRecStatus" />
	<!-- End Hidden Fields -->
	<jsp:include page="subPages/outwardFaculPremPaytsListing.jsp"></jsp:include>		
	<table width="85%" align="center" cellspacing="1" border="0">
		<tr>
			<td class="rightAligned" style="width: 100px;">Transaction Type</td>
			<td class="leftAligned" style="width: 200px;"> 
				<select id="tranType" style="width: 250px;" class="required">
					<option></option>
				</select>
			</td>
			<td class="rightAligned" style="width: 100px;">Assured Name</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="assuredName" style="width: 220px;" readOnly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Reinsurer</td>
			<td class="leftAligned" style="width: 200px;"> 
				<select id="reinsurer" style="width: 250px;" class="required">
					<option></option>
				</select>
			</td>
			<td class="rightAligned" style="width: 100px;">Policy No.</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="policyNo" style="width: 220px;" readOnly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Binder No.</td>
			<td class="leftAligned">
				<input type="text" id="faculPremLineCd" style="width: 50px; height: 15px; margin-top: .5px; float: left;" class="required" />
				<input type="text" id="faculPremBinderYY" style="width: 50px; height: 15px; margin-top: .5px; margin-left: 2px; float: left;" class="required" />
				<div id="binderNoDiv" style=" border: 1px solid gray; width: 128px; height: 21px; float: left; background-color: cornsilk; margin-left: 2px;"> 
					<input style="width: 101.5px; border: none; float: left; margin-top: .5px;" id="binderSeqNo" name="binderSeqNo" type="text" value="" class="leftAligned required" /> 
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBinderNo" name="oscmBinderNo" alt="Go" />
				</div>
			</td>
			<!-- 
			<td class="leftAligned" style="width: 200px;"> 
				<select id="binderNo" style="width: 250px;" class="required">
					<option></option>
				</select>
			</td>
			-->
			<td class="rightAligned" style="width: 100px;">Remarks</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="remarks" style="width: 220px;" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Amount</td>
			<td class="leftAligned" style="width: 250px;"> 
				<input type="text" id="amount" style="width: 242px; text-align: right;" class="required" />
			</td>
			<td  colspan="2"> 
				<input type="button" id="breakdown" style="width: 100px;" value="BreakDown" class="disabledButton" />
				<input type="button" id="binderBtn" value="Binder" class="disabledButton" />
				<input type="button" id="overideUserBtn" value="Override" class="disabledButton" />
				<input type="button" id="overriedDefBtn" style="width: 115px;" value="Override Default" class="disabledButton" />
		    </td>
		</tr>
		
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="leftAligned" style="width: 250px;"> 
				<input type="checkbox" id="wPremiumTag" style="width: 10px;" disabled />
				w/ Premium Warranty
			</td>
			<td colspan="2"> 
				<input type="button" id="currInformation" value="Currency Information" class="disabledButton" />
				<input type="button" id="revertBtn" value="Revert to Default" class="disabledButton" />
				<input type="button" id="outfaculList"value="Outfacul List" class="disabledButton" />
		    </td>
		</tr>
	</table>
	<div style="margin-top: 10px; height: 30px;" changeTagAttr="true">
		<input style="float: left; margin-left: 250px;" type="button" id="btnAdd" name="btnAdd" class="button" value="Add" />
		<input style="float: left; margin-left: 4px;" type="button"  id="btnDelete" name="btnDelete"	class="disabledButton" value="Delete" />
	</div>	
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 70px; margin-left: 35px;" id="btnCancel" name="btnCancel"	class="button" value="Cancel" />
	<input type="button" style="width: 70px;" id="btnSave" name="btnSave" class="button" value="Save" />
</div> 

<script>
	setModuleId("GIACS019");
	//objAC.currModifiedRows = new Array(); objOutFaculPremPayts
	objAC.isValid = false;
	objAC.tempObj = null;
	objAC.wsDisbursementAmt = null;
	objAC.overideOk = validateUserFunc2("OD", "GIACS019");
	objAC.overrideDef = "N";
	var objTranType = JSON.parse('${tranTypeListJSON}'.replace(/\\/g, '\\\\'));
	var objReinsurer = JSON.parse('${giisReinsurerJSON}'.replace(/\\/g, '\\\\'));
	var objReturnMessage = "";
	objAC.currModifiedRows = JSON.parse('${outFaculPremPaytsJSON}'.replace(/\\/g, '\\\\'));
	
	populateTranTypeDtls(objTranType, 0);
	populateReinsurerDtls(objReinsurer, 0);
	showOutFaculListParam(objAC.currModifiedRows);

	changeTag = 0;

	function populateTranTypeDtls(obj, value){
		$("tranType").update('<option value="" tranTypeCode="" tranTypeDesc=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].rvLowValue+'" tranTypeCode="'+obj[i].rvLowValue+'" tranTypeDesc="'+obj[i].rvMeaning+'">'+obj[i].rvMeaning+'</option>';
		}
		$("tranType").insert({bottom: options}); 
		$("tranType").selectedIndex = value;
	}

	function populateReinsurerDtls(obj, value){
		$("reinsurer").update('<option value="" riCd="" riName=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].riCd+'" riName="'+obj[i].riName+'">'+obj[i].riName+'</option>';
		}
		$("reinsurer").insert({bottom: options}); 
		$("reinsurer").selectedIndex = value;
	}

	function openSearchBinderModal() {
		Modalbox.show(contextPath+"/GIACOutFaculPremPaytsController?action=openSearchBinderModal&ajaxModal=1&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $("reinsurer").options[$("reinsurer").selectedIndex].value + "&lineCd=" + $F("faculPremLineCd") + "&binderYY=" + $F("faculPremBinderYY") + "&gaccTranId=" + objACGlobal.gaccTranId + "&moduleId=" + "GIACS019" + "&binderSeqNo=" + $F("binderSeqNo") , 
		{	title: "Search Binder No.", 
			width: 680,
			overlayClose: false
		});	
	}

	function validateBinderNo(){
		if ($F("faculPremLineCd") != "" && $F("faculPremBinderYY") != "" && $F("binderSeqNo") != ""){
			new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=validateBinderNo&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $("reinsurer").options[$("reinsurer").selectedIndex].value + "&lineCd=" + $F("faculPremLineCd") + "&binderYY=" + $F("faculPremBinderYY") + "&gaccTranId=" + objACGlobal.gaccTranId + "&moduleId=" + "GIACS019" + "&binderSeqNo=" + $F("binderSeqNo"), { 
				method: "GET",
				parameters: {
					
				},
				evalscripts: true,
				asynchronous: true,
				onComplete: function (response){
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (result.length > 0) {
						objAC.tempObj = result;
						setNewFormValues(result);
						enableButton("breakdown");
						enableButton("currInformation");
						if (result[0].message != null) {
							showMessageBox(result[0].message, imgMessage.ERROR);
							objReturnMessage = result[0].message;
							objAC.isValid = false;
						}else{
							setOverrideButtons();
						}
					}else{
						objAC.isValid = false;
						showMessageBox("The Line Code, Binder Year, Binder Seq. No. does not exist.", imgMessage.ERROR);
					}
				}
			});
		}
	}

	function setNewFormValues(obj){
		$("assuredName").value = obj[0].assdName;
		$("policyNo").value = obj[0].policyNo;
		$("remarks").value = obj[0].remarks;
		$("amount").value = obj[0].disbursementAmt;
		$("faculPremLineCd").value = obj[0].lineCd;
		$("faculPremBinderYY").value = obj[0].binderYY;
		$("binderSeqNo").value = parseInt(obj[0].binderSeqNo).toPaddedString(5);
		$("hiddenBinderId").value = obj[0].binderId;
		$("hiddenAssdNo").value = obj[0].assdNo;
		objAC.tempDisbursementAmt = obj[0].disbursementAmt;
		objAC.isValid = true;
	}

	function clearFormValues(){
		$("tranType").selectedIndex = 0;
		$("reinsurer").selectedIndex = 0;
		$("assuredName").value = null;
		$("policyNo").value = null;
		$("remarks").value = null;
		$("amount").value = null;
		$("faculPremLineCd").value = null;
		$("faculPremBinderYY").value = null;
		$("binderSeqNo").value = null;
		$("hiddenRecStatus").value = null;
		objAC.tempObj = null;
		disableButton("btnDelete");
		$("btnAdd").value = "Add";
		disableButton("breakdown");
		disableButton("currInformation");
		disableButton("outfaculList");
		enableDisableAllFields("enable");
		disableButton("overriedDefBtn");
		disableButton("revertBtn");
	}

	function showOutFaculList(){
		try {
			var outFaculPremPaytsTable = $("outwardFaculPremPaytsTableContainer");
			
				var content = prepareOutFaculPremPaytsListInfo();										
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "row"+$F("hiddenBinderId"));
				newDiv.setAttribute("name", "outFaculPremPayts");
				newDiv.setAttribute("binderId", $F("hiddenBinderId"));
				newDiv.setAttribute("trantype", $("tranType").value);
				newDiv.setAttribute("reinsurer", $("reinsurer").value);
				newDiv.setAttribute("disbursementAmt", unformatCurrency("amount"));
				newDiv.setAttribute("recordStatus", "0");
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				outFaculPremPaytsTable.insert({bottom : newDiv});
				divEvents(newDiv);
				checkTableIfEmpty("outFaculPremPayts", "outwardFaculPremPaytsTable");
		} catch (e) {
			showErrorMessage("showOutFaculList", e);
			//showMessageBox("showOutFaculList : " + e.message);
		}
	}

	function prepareOutFaculPremPaytsListInfo(){
		try {				
			var outFaculPremPaytsListInfo = '<label style="width: 35px; text-align: right; margin-left: 78px;" name="lblTranType" id="lblTranType">'+ $F("tranType") +'</label>'+
			  '<label style="width: 215px; text-align: left; margin-left: 80px;" name="lblRiName" id="lblRiName">'+$("reinsurer").options[$("reinsurer").selectedIndex].getAttribute("riName").truncate(28, "...")+'</label>'+
			  '<label style="width: 115px; text-align: left; margin-left: 13px;" name="lblBinderNo" id="lblBinderNo">'+ $F("faculPremLineCd") + "-" + $F("faculPremBinderYY") + "-" + parseFloat($F("binderSeqNo")).toPaddedString(5) +'</label>'+
			  '<label style="width: 115px; text-align: right; margin-left: 17px;" name="lblDisbursementAmt" id="lblDisbursementAmt">'+ formatCurrency($F("amount")) +'</label>';     
	     
			return outFaculPremPaytsListInfo;
			
		} catch (e) {
			showErrorMessage("prepareOutFaculPremPaytsListInfo", e);
			//showMessageBox("outFaculPremPaytsListInfo : " + e.message);
		}
	}

	function showOutFaculListParam(objArray){
		try {
			var outFaculPremPaytsTable = $("outwardFaculPremPaytsTableContainer");
			for(var i=0; i<objArray.length; i++) {		
				if (objArray[i].recordStatus != -1){
					objArray[i].message = null;
					var content = prepareOutFaculPremPaytsListInfoParam(objArray[i]);										
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+objArray[i].binderId);
					newDiv.setAttribute("name", "outFaculPremPayts");
					newDiv.setAttribute("binderId", objArray[i].binderId);
					newDiv.setAttribute("tranType", objArray[i].tranType);
					newDiv.setAttribute("reinsurer", objArray[i].riCd);
					newDiv.setAttribute("convertRate", objArray[i].currencyRt);
					newDiv.setAttribute("policyId", objArray[i].policyId);
					newDiv.setAttribute("recordStatus", "");
					newDiv.addClassName("tableRow");
					
					newDiv.update(content);
					outFaculPremPaytsTable.insert({bottom : newDiv});
					checkTableIfEmpty("outFaculPremPayts", "outwardFaculPremPaytsTable");
					divEvents(newDiv);
				}		
				checkTableIfEmpty("outFaculPremPayts", "outwardFaculPremPaytsTable");
			}
		} catch (e) {
			showMessageBox("showOutFaculList : " + e.message);
		}
	}

	function prepareOutFaculPremPaytsListInfoParam(obj){
		try {				

			var outFaculPremPaytsListInfo = '<label style="width: 35px; text-align: right; margin-left: 78px;" name="lblTranType" id="lblTranType">'+ obj.tranType +'</label>'+
			  '<label style="width: 215px; text-align: left; margin-left: 80px;" name="lblRiName" id="lblRiName">'+obj.riName.truncate(28, "...")+'</label>'+
			  '<label style="width: 115px; text-align: left; margin-left: 13px;" name="lblBinderNo" id="lblBinderNo">'+ obj.lineCd + "-" + obj.binderYY + "-" + parseFloat(obj.binderSeqNo).toPaddedString(5) +'</label>'+
			  '<label style="width: 115px; text-align: right; margin-left: 17px;" name="lblDisbursementAmt" id="lblDisbursementAmt">'+ formatCurrency(obj.disbursementAmt) +'</label>';     

			     
			return outFaculPremPaytsListInfo;
			
		} catch (e) {
			showMessageBox("outFaculPremPaytsListInfo : " + e.message);
		}
	}
	

	function setAddedOutFaculPremPayts(){
		var newObj = new Object();
		try{
			newObj.gaccTranId = objACGlobal.gaccTranId;
			newObj.tranType = $F("tranType");
			newObj.riName	= $("reinsurer").options[$("reinsurer").selectedIndex].getAttribute("riName");
			newObj.riCd		= $("reinsurer").value;//options[$("reinsurer").selectedIndex].getAttribute("tranTypeCode");
			newObj.binderId = $F("hiddenBinderId");
			newObj.lineCd   = $F("faculPremLineCd");
			newObj.binderYY = $F("faculPremBinderYY");
			newObj.binderSeqNo = parseFloat($F("binderSeqNo"));
			newObj.assdName	= $F("assuredName");
			newObj.assdNo 	= $F("hiddenAssdNo");
			newObj.policyNo = $F("policyNo");
			newObj.remarks  = $F("remarks");	
			newObj.disbursementAmt = unformatCurrency("amount");
			newObj.incTag	= true;
			newObj.currencyCd = objAC.tempObj[0].currencyCd;
			newObj.currencyRt = objAC.tempObj[0].currencyRt;
			newObj.currencyDesc = objAC.tempObj[0].currencyDesc;
			newObj.foreignCurrAmt = unformatCurrency("amount") * objAC.tempObj[0].currencyRt;
			newObj.orPrintTag = "N";
			newObj.recordStatus = 0;

			objAC.currModifiedRows.push(newObj); 
			clearFormValues();
		
		}catch(e){
			showMessageBox("setAddedOutFaculPremPayts : " + e.message);
		}	
	}

	function setUpdatedOutFaculPremPayts(){
		for (var i=0; i<objAC.currModifiedRows.length; i++){
			if (objAC.currModifiedRows[i].binderId == $F("hiddenBinderId")){
				//objAC.currModifiedRows[i].gaccTranId = objACGlobal.gaccTranId;
				objAC.currModifiedRows[i].tranType = $F("tranType");
				objAC.currModifiedRows[i].riName	= $("reinsurer").options[$("reinsurer").selectedIndex].getAttribute("riName");
				objAC.currModifiedRows[i].riCd		= $("reinsurer").value;//options[$("reinsurer").selectedIndex].getAttribute("tranTypeCode");
				objAC.currModifiedRows[i].binderId = $F("hiddenBinderId");
				objAC.currModifiedRows[i].lineCd   = $F("faculPremLineCd");
				objAC.currModifiedRows[i].binderYY = $F("faculPremBinderYY");
				objAC.currModifiedRows[i].binderSeqNo = parseFloat($F("binderSeqNo"));
				objAC.currModifiedRows[i].assdName	= $F("assuredName");
				objAC.currModifiedRows[i].assdNo 	= $F("hiddenAssdNo");
				objAC.currModifiedRows[i].policyNo = $F("policyNo");
				objAC.currModifiedRows[i].remarks  = $F("remarks");	
				objAC.currModifiedRows[i].disbursementAmt = unformatCurrency("amount");
				objAC.currModifiedRows[i].foreignCurrAmt = unformatCurrency("amount") * objAC.currModifiedRows[i].currencyRt;
				objAC.currModifiedRows[i].recordStatus = 1;
				clearFormValues();
				break;
			}
		}
	}

	function divEvents(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			//clearFormValues();
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='outFaculPremPayts']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						objAC.tempObj = null;
						enableButton("btnDelete");
						enableButton("breakdown");
						enableButton("currInformation");
						enableButton("outfaculList");
						$("btnAdd").value = "Update";
						objAC.tempDisbursementAmt = r.getAttribute("disbursementAmt");
						setFormValues(r);
						setOverrideButtons();
					}
			    });	
			}else{
				clearFormValues();
			} 
		});
	}

	function setFormValues(div){
		for (var i=0; i<objAC.currModifiedRows.length; i++ ){
			if (objAC.currModifiedRows[i].binderId == div.getAttribute("binderId")){
				$("tranType").value = div.getAttribute("tranType");
				$("reinsurer").value = div.getAttribute("reinsurer");
				$("assuredName").value = objAC.currModifiedRows[i].assdName;
				$("policyNo").value = objAC.currModifiedRows[i].policyNo;
				$("remarks").value = objAC.currModifiedRows[i].remarks;
				$("amount").value = formatCurrency(objAC.currModifiedRows[i].disbursementAmt);
				$("faculPremLineCd").value = objAC.currModifiedRows[i].lineCd;
				$("faculPremBinderYY").value = objAC.currModifiedRows[i].binderYY;
				$("binderSeqNo").value = parseInt(objAC.currModifiedRows[i].binderSeqNo).toPaddedString(5);
				$("hiddenBinderId").value = objAC.currModifiedRows[i].binderId;
				$("hiddenAssdNo").value = objAC.currModifiedRows[i].assdNo;
				$("hiddenConvertRate").value = div.getAttribute("convertRate");
				$("hiddenPolicyId").value = div.getAttribute("policyId");
				$("hiddenRecStatus").value = div.getAttribute("recordStatus");		
				if (objAC.currModifiedRows[i].recordStatus != 0) {
					enableDisableAllFields("disable");
				}
				break;
			}
		}
	}

	function enableDisableAllFields(param){
		if (param == "disable"){
			$("tranType").disabled = true;
			$("reinsurer").disabled = true;
			$("faculPremLineCd").disabled = true;
			$("faculPremBinderYY").disabled = true;
			$("binderSeqNo").disabled = true;
			$("amount").disabled = true;
			$("remarks").readOnly = true;
			disableButton("btnAdd");
			disableButton("binderBtn");
			disableButton("overideUserBtn");
			disableButton("revertBtn");
			disableButton("overriedDefBtn");
			
		}else{
			$("tranType").disabled = false;
			$("reinsurer").disabled = false;
			$("faculPremLineCd").disabled = false;
			$("faculPremBinderYY").disabled = false;
			$("binderSeqNo").disabled = false;
			$("amount").disabled = false;
			$("remarks").readOnly = false;
			enableButton("btnAdd");

		}
	}

	function markRecordAsDeleted(binderId){
		for(var i=0; i<objAC.currModifiedRows.length; i++) {		
			if (binderId == parseInt(objAC.currModifiedRows[i].binderId)){
				objAC.currModifiedRows[i].recordStatus = -1;
				break;
			}
		}			
	}

	function checkIfBinderExistInList(){
		var exists = false;
		$$("div[name='outFaculPremPayts']").each(function (row)	{
			if ($F("hiddenBinderId") == row.getAttribute("binderId")){
				exists = true;
			}
		});

		return exists;
	}

	function prepareParameters(){
		try {			
			var setAddedModifiedOutFaculPremPayts		= getAddedModifiedOutFaculJSONObject();
			var delOutFaculPremPayts					= getDeletedOutFaculJSONObject();
		
			// Sets the parameters
			var objParameters = new Object();
			objParameters.addModifiedOutFaculPremPayts	 = setAddedModifiedOutFaculPremPayts;
			objParameters.deletedOutFaculPremPayts	     = delOutFaculPremPayts;

			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
		}
	}
	//function getAddedModified
	function getAddedModifiedOutFaculJSONObject(){
		var tempObjArray = new Array();
		for(var i=0; i<objAC.currModifiedRows.length; i++) {	
			if (objAC.currModifiedRows[i].recordStatus == 0){
				tempObjArray.push(objAC.currModifiedRows[i]);
			}else if (objAC.currModifiedRows[i].recordStatus == 1){
				tempObjArray.push(objAC.currModifiedRows[i]);
			}
		}
		
		return tempObjArray;
	}
	
	function getDeletedOutFaculJSONObject(){
		var tempObjArray = new Array();
		
		for(var i=0; i<objAC.currModifiedRows.length; i++) {	
			if (objAC.currModifiedRows[i].recordStatus == -1){
				tempObjArray.push(objAC.currModifiedRows[i]);
			}
		}
		return tempObjArray;
	}

	function getBinderDtls(){
		if ($("tranType").selectedIndex > 0) {
			if ($("reinsurer").selectedIndex > 0){
				openSearchBinderModal();
			}else{
				showMessageBox("RI code does not exist.", imgMessage.ERROR);
			}
				
		}else{
			showMessageBox("Please select transaction type first.", imgMessage.ERROR);
		}
	}

	function getDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getDisbursementAmt", {
			method: "POST",
			parameters: {
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				riCd: $("reinsurer").options[$("reinsurer").selectedIndex].value,
				lineCd: $F("faculPremLineCd"),
				binderYY: $F("faculPremBinderYY"),
				binderId: $F("hiddenBinderId"),
				convertRate: $F("hiddenConvertRate"),
				binderSeqNo: $F("binderSeqNo"),
				policyId: $F("hiddenPolicyId"),
				allowDef: true
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response){
				var disbursementAmt = response.responseText;
				objAC.wsDisbursementAmt = disbursementAmt;
				validateDisbursement();
			}
		});
	}

	function getOverrideDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getOverrideDisbursementAmt", {
			method: "POST",
			parameters: {
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				lineCd: $F("faculPremLineCd"),
				binderYY: $F("faculPremBinderYY"),
				binderId: $F("hiddenBinderId"),
				binderSeqNo: $F("binderSeqNo")
				},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var disbursement = response.responseText.toQueryParams();
				if (disbursement.message.length == 0){
					objAC.wsDisbursementAmt = disbursement.disbursementAmt;
				}else{
					showMessageBox(disbursement.message, imgMessage.ERROR);
				}
				validateDisbursement();
			}
		});	
	}

	function getRevertDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getRevertDisbursementAmt", {
			method: "POST",
			parameters: {
				binderId: $F("hiddenBinderId"),
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				lineCd:  $F("faculPremLineCd"),
				gaccTranId: objACGlobal.gaccTranId,
				riCd: $F("reinsurer")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var result = response.responseText;
				var disbursement = response.responseText.toQueryParams();
				if (disbursement.message.length == 0){
					objAC.wsDisbursementAmt = disbursement.disbursementAmt;
				}else{
					showMessageBox(disbursement.message, imgMessage.ERROR);
				}
				validateDisbursement();
			}
		});
	}

	function validateDisbursement(){
		if (unformatCurrency("amount") == 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("No payment equal to zero(0) is accepted.", imgMessage.ERROR, "amount");
		}else if (($F("tranType") == 1 || $F("tranType") == 4) && unformatCurrency("amount") < 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("Please enter a positive amount for transaction type [1,4].", imgMessage.ERROR, "amount");
		}else if (($F("tranType") == 2 || $F("tranType") == 3) && unformatCurrency("amount") > 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("Please enter a negative amount for transaction type [2,3].", imgMessage.ERROR, "amount");
		}
		if (unformatCurrency("amount") != objAC.tempDisbursementAmt){
			if (Math.abs(unformatCurrency("amount")) > Math.abs(objAC.wsDisbursementAmt)){
				if ($F("tranType") == 1 || $F("tranType") == 4) {
					showConfirmBox("", "Policy is partially paid and allowed facul premium payment is " +  formatCurrency(objAC.wsDisbursementAmt) + " only. Do you want to pay facul premium more than " + formatCurrency(objAC.wsDisbursementAmt) + "?", "Yes", "No", 
							function (){
								if (!objAC.overideOk) {
									showMessageBox("You are not allowed to process this transaction. However you can override by pressing the Override button beside Binder button.", imgMessage.INFO);
									enableButton("overideUserBtn");
									$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
									setOverrideButtons();
								}else{
									$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
									setOverrideButtons();
								}
							},"");
				}else if ($F("tranType") == 2 || $F("tranType") == 3){
					showMessageBox("Entered amount must be greater than or equal to " + formatCurrency(objAC.wsDisbursementAmt), imgMessage.ERROR);
					$("amount").value = objAC.tempDisbursementAmt;
					setOverrideButtons();
				}
			}
		}
	}
	
	function saveFuncMain(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=saveOutFaculPremPayts" , {
			method: "POST",
			parameters: {
				parameter: prepareParameters(),
				gaccTranId: objACGlobal.gaccTranId,
				branchCd: objACGlobal.branchCd,
				fundCd: objACGlobal.fundCd,
				tranSource: objACGlobal.tranSource,
				orFlag: objACGlobal.orFlag
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function() {
				showNotice("Saving information, please wait...");
			},
			onComplete: function (response) {
				var result = response.responseText;
				if (result == "SUCCESS") {
					showMessageBox(result, imgMessage.SUCCESS);
					$$("div[name='outFaculPremPayts']").each(function (div)	{
						div.setAttribute("recordStatus", "");
					});
				}
			}
		});
	}

	/* OBSERVE ITEMS */
	
	$("btnCancel").observe("click", function () {
		if(changeTag != 0){
			showConfirmBox3("Cancel Facultative", objCommonMessage.WITH_CHANGES , "Yes", "No", function () {saveFuncMain(); changeTag = 0;}, showRITransOutFaculPremPayts); 
		}else {
			showRITransOutFaculPremPayts();
		}
	});
	
	$("tranType").observe("change", function () {
		$("reinsurer").selectedIndex = 0;
		$("assuredName").value = null;
		$("policyNo").value = null;
		$("remarks").value = null;
		$("amount").value = null;
		$("faculPremLineCd").value = null;
		$("faculPremBinderYY").value = null;
		//$("binderSeqNo").value = null;
	});
	
	$("reinsurer").observe("change", function () {
		$("assuredName").value = null;
		$("policyNo").value = null;
		$("remarks").value = null;
		$("amount").value = null;
		$("faculPremLineCd").value = null;
		$("faculPremBinderYY").value = null;
		//$("binderSeqNo").value = null;
	});
	
	$("oscmBinderNo").observe("click", getBinderDtls);

	$("faculPremLineCd").observe("blur", function (){
		validateBinderNo();
	}); 
	
	$("faculPremBinderYY").observe("blur", function (){
		validateBinderNo();
	}); 
	
	$("binderSeqNo").observe("blur", function (){
		validateBinderNo();
	}); 

	$("breakdown").observe("click", function () {
		showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=showBreakdown&lineCd=" + $F("faculPremLineCd") + "&riCd=" + $F("reinsurer") + "&binderYY=" + $F("faculPremBinderYY") + "&binderSeqNo=" + $F("binderSeqNo") + "&disbursementAmt=" + unformatCurrency("amount") , "Breakdown", 350, "", 100);			
	});

	$("btnAdd").observe("click", function () {
		if ($("tranType").selectedIndex > 0) {
			if ($("reinsurer").selectedIndex > 0){
				if (checkRequiredDisabledFields()){
					if ($("btnAdd").value == "Add") {
						if (objAC.isValid == true) {
							if (!checkIfBinderExistInList()) {
								showOutFaculList();
								setAddedOutFaculPremPayts();
								objAC.isValid = false;
							}else{
								showMessageBox("Binder already in list.", imgMessage.ERROR);
							}	
						}else{
							if (objReturnMessage == "") {
								showMessageBox("The Line Code, Binder Year, Binder Seq. No. does not exist.", imgMessage.ERROR);
							}else{
								showMessageBox(objReturnMessage, imgMessage.ERROR);
							}
						}
					}else {
						setUpdatedOutFaculPremPayts();
					}	
				} else {
					showMessageBox("Please input all required fields.", imgMessage.ERROR);
				}	
			}else{
				showMessageBox("RI code does not exist.", imgMessage.ERROR);
			}
				
		}else{
			showMessageBox("Please select transaction type first.", imgMessage.ERROR);
		}
	});

	$("btnDelete").observe("click", function ()	{
		$$("div[name='outFaculPremPayts']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						markRecordAsDeleted(row.getAttribute("binderId"));
						row.remove();	
						clearFormValues();
						checkTableIfEmpty("outFaculPremPayts", "outwardFaculPremPaytsTable");				
					}
				});
			}
		});
	});

	$("binderBtn").observe("click", getBinderDtls);

	$("btnSave").observe("click", function () {
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		saveFuncMain();
		changeTag = 0;
	});

	$("currInformation").observe("click", function (){
		var currCd;
		var currRt;
		var currAmt;
		var currDesc;
		if (objAC.tempObj == null) {
			for (var i=0; i<objAC.currModifiedRows.length; i++){
				if (objAC.currModifiedRows[i].binderId == $F("hiddenBinderId")) {
					currCd = objAC.currModifiedRows[i].currencyCd;
					currRt = objAC.currModifiedRows[i].currencyRt;
					currAmt = unformatCurrency("amount") * objAC.currModifiedRows[i].currencyRt;
					currDesc = objAC.currModifiedRows[i].currencyDesc;
					break;
				}
			}
		}else {
			currCd = objAC.tempObj[0].currencyCd;
			currRt = objAC.tempObj[0].currencyRt;
			currAmt = unformatCurrency("amount") * objAC.tempObj[0].currencyRt;
			currDesc = objAC.tempObj[0].currencyDesc;
		}
		showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=showCurrencyInfo&currCd=" + currCd + "&currRt=" +  currRt + "&currAmt=" + currAmt + "&currDesc=" + currDesc, "Currency Information", 350, "", 100);		
	});

	$("outfaculList").observe("click", function () {
		showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=printOutFaculPremPayts" , "Outward Facultative Premiums", 350, "", 100);		
	});

	$("overideUserBtn").observe("click", function () {
		if (!objAC.overideOk) {
			objAC.funcCode = "OD";
			commonOverrideOkFunc = function () {
								     objAC.overideOk = true;
								   };
			commonOverrideNotOkFunc	= function () {
									    objAC.overideOk = false;
									    showMessageBox($F("overideUserName") + "is not allowed to override this transaction.", imgMessage.ERROR);
									  };				   
			getUserInfo();
		}
	});

	$("amount").observe("change", function() {
		if (checkRequiredDisabledFields()) {
			if (!objAC.overideOk){
				getDisbursementAmt();
			}else{
				getOverrideDisbursementAmt();
			}
		}
	});

	$("revertBtn").observe("click", function() {
		if ($("revertBtn").getAttribute("class") != "disabledButton") {
			objAC.overrideDef = "N";
			getRevertDisbursementAmt();
			setOverrideButtons();
			enableButton("overriedDefBtn");
		}
	});

	$("overriedDefBtn").observe("click", function() {
		if ($("overriedDefBtn").getAttribute("class") != "disabledButton") {
			objAC.overrideDef = "Y";
			getOverrideDisbursementAmt();
			setOverrideButtons();
			enableButton("revertBtn");
		}
	});
	/* END OBSERVE ITEMS */

	initializeChangeTagBehavior(saveFuncMain); 
	
</script>