<div id="depreciationDetailsInfoDiv" style="padding: 10px;">
<!-- 	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>VAT Details</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div> -->
	
	<div class="sectionDiv" >
		<div style="height: 210px;">
			<jsp:include page="/pages/claims/mcEvaluationReport/overlay/vatDetailsTGListing.jsp" ></jsp:include>
		</div>
		
		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="right" style="width: 170px;"><b>Total:</b></td>
						<td><input type="text" id="totalVat" name="totalVat" class="money" style="width: 120px; margin-right: 30px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="vatDetailsDiv" style="padding: 10px;  height: 100px; margin-bottom:10px; " changeTagAttr="true" >
			<table align="center">
				<tr>
					<td align="right" style="width: 120px;">Company:</td>
					<td align="left" >
						<div style="width: 236px; float: left;" class="withIconDiv required">
							<input type="text" id="dspCompany" name="dspCompany" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyIcon"  alt="Go" />
						</div>
					</td>
					<td align="right" style="width: 100px;">Part/Labor:</td>
					<td class="leftAligned">
						<div style="width: 236px; float: left;" class="withIconDiv required">
							<input type="text" id="dspPartLabor" name="dspPartLabor" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspPartLaborIcon"  alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Taxable Amount:</td>  
					<td class="rightAligned" >
						<input style="width: 230px;   float: left;"  id="baseAmt" name="baseAmt" type="text" class="money2" errorMsg="Invalid rate." readonly="readonly"/>
					</td>
					<td class="rightAligned" >Tax Percent:</td> 
					<td class="leftAligned" >
						<input style="width: 230px;  float: left;" readonly="readonly" id="vatRate" name="vatRate" type="text" class="money2"/>
					</td>   
				</tr>
				<tr>
					<td class="rightAligned" >Tax Amount:</td> 
					<td class="leftAligned" >
						<input style="width: 230px;  float: left;" readonly="readonly" id="vatAmt" name="vatRate" type="text" class="money2"/>
					</td>   
					
					<td class="leftAligned" style=" width: 280px;" colspan="2">
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 120px;">Less Deductible</label>
						<div style="float: left;">
							<input id="lessDed"  type="checkbox" value="" style="width:16px; height:20px;" title="Less Deductible">
						</div>
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 120px;">Less Depreciation</label>
						<div style="float: left;">
							<input id="lessDep"   type="checkbox" value="" style="width:16px; height:20px;" title="Less Depreciation">
						</div>
					</td>
				</tr>				
			</table>
		</div>
		<div id="vatDetailsButtonsDiv">
			<table style=" margin-bottom: 10px;" align="center" >
				<tr>
					<td>
						<input type="button" class="button" id="btnAddVat" value="Add" style="width:100px;" />
						<input type="button" class="disabledButton" id="btnDelVat" value="Delete" style="width:100px;" />
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnCreateVatDetails" value="Create VAT Details" style="width:150px;"/>
			<input type="button" class="button" id="btnSaveVatDetail" value="Save" style="width:100px;" title="Save"/>
			<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:100px;" title="back to main"/>
		</div>
	</div>
	<input type="hidden" id="payeeTypeCd"/>
	<input type="hidden" id="payeeCd"/>
	<input type="hidden" id="applyTo"/>
	<input type="hidden" id="paytPayeeTypeCd"/>
	<input type="hidden" id="paytPayeeCd"/>
	<input type="hidden" id="netTag"/>
	<input type="hidden" id="withVat"/>
</div>	

<script>
	$("totalVat").value = formatCurrency(selectedMcEvalObj.vat);
	
	function validateEvalCom(evalId, payeeCd, payeeTypeCd){
		try{
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "validateEvalCom",
					evalId: evalId,
					payeeCd: payeeCd,
					payeeTypeCd: payeeTypeCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						$("vatAmt").value =formatCurrency(res.vatAmt);
						$("vatRate").value = formatCurrency(res.vatRate);
						$("baseAmt").value = formatCurrency(res.baseAmt);
						$("dspPartLabor").value =unescapeHTML2(res.dspPartLabor);
						$("applyTo").value =unescapeHTML2(res.applyTo);
						if(res.allowLaborLov == "Y"){
							enableSearch("dspPartLaborIcon");
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch (e) {
			showErrorMessage("validateEvalCom",e);
		}
	}
	
	function validateEvalPartLabor(evalId, payeeCd, payeeTypeCd,applyTo){
		try{
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "validateEvalPartLabor",
					evalId: evalId,
					payeeCd: payeeCd,
					payeeTypeCd: payeeTypeCd,
					applyTo: applyTo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						$("vatAmt").value =formatCurrency(res.vatAmt);
						$("vatRate").value = formatCurrency(res.vatRate);
						$("baseAmt").value = formatCurrency(res.baseAmt);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch (e) {
			showErrorMessage("validateEvalPartLabor",e);
		}
	}
	
	function getEvalVatComLOV(evalId){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getEvalVatComLOV",
								evalId : evalId,
								page : 1},
				title: "vat",
				width: 380,
				height: 400,
				columnModel : [
					{
						id : "dspCompany",
						title: "Company",
						width: '350px'
					},
					{
						id : "payeeTypeCd",
						title: "",
						width: '0',
						visible: false
					},
					{
						id : "payeeCd",
						title: "",
						width: '0',
						visible: false
					}
				],
				draggable: true,
				onSelect : function(row){
					$("payeeTypeCd").value = row.payeeTypeCd;
					$("payeeCd").value = row.payeeCd;
					$("dspCompany").value = unescapeHTML2(row.dspCompany);
					changeTag =1;
					validateEvalCom(selectedMcEvalObj.evalId,row.payeeCd,row.payeeTypeCd);
				}
			});	
		}catch(e){
			showErrorMessage("getEvalVatComLOV",e);
		}
	}
	
	function getEvalVatPartLaborLOV(evalId,payeeCd, payeeTypeCd){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getEvalVatPartLaborLOV",
								evalId: evalId,
								payeeCd: payeeCd,
								payeeTypeCd: payeeTypeCd,
								page : 1},
				title: "vat",
				width: 380,
				height: 400,
				columnModel : [
					{
						id : "dspPartLabor",
						title: "Company",
						width: '250px'
					},
					{
						id : "baseAmt",
						title: "Amount",
						align: 'right',
						geniisysClass : 'money',
						width: '150px',
						sortable: false
					},
					{
						id : "applyTo",
						title: "",
						width: '0',
						visible: false
					},
					{
						id : "withVat",
						title: "",
						width: '0',
						visible: false
					}
				],
				draggable: true,
				onSelect : function(row){
					$("dspPartLabor").value = unescapeHTML2(row.dspPartLabor);
					$("applyTo").value = row.applyTo;
					$("withVat").value = row.withVat;
					validateEvalPartLabor(selectedMcEvalObj.evalId,$F("payeeCd"),$F("payeeTypeCd"),row.applyTo);
				},onCancel: function(){ 
					
		  		}
			});	
		}catch(e){
			showErrorMessage("getEvalVatComLOV",e);
		}
	}
	
	function checkIfVatDetIsEditable(){
		try{
			if(variablesObj.giclEvalVatAllowUpdate =="N"){
				disableSearch("dspCompanyIcon");
				disableSearch("dspPartLaborIcon");
				$("lessDed").disabled = "disabled";
				$("lessDep").disabled = "disabled";
				disableButton("btnAddVat");
				disableButton("btnDelVat");
				disableButton("btnSaveVatDetail");
				disableButton("btnCreateVatDetails");
				
			}
		}catch(e){
			showErrorMessabe("checkIfVatDetIsEditable",e);
		}
	}
	
	function validateLessDeductibles(evalId, payeeCd, payeeTypeCd, applyTo, lessDed){
		try{
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "validateLessDeductibles",
					evalId: evalId,
					payeeCd: payeeCd,
					payeeTypeCd: payeeTypeCd,
					applyTo: applyTo,
					lessDed : lessDed
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						if(res.message == "1"){
							showMessageBox("Deductible may only be applied to parts.", "I");
							$("lessDed").checked = false;
						}else if (res.message == "2"){
							showMessageBox("No deductibles exist for this evaluation, checking of this option is not applicable.", "I");
							$("lessDed").checked = false;
						}else{
							$("vatAmt").value =formatCurrency(res.vatAmt);
							$("baseAmt").value = formatCurrency(res.baseAmt);
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("validateLessDeductibles",e);
		}
	}
	
	function validateLessDepreciation(evalId, payeeCd, payeeTypeCd, applyTo, lessDep){
		try{
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "validateLessDepreciation",
					evalId: evalId,
					payeeCd: payeeCd,
					payeeTypeCd: payeeTypeCd,
					applyTo: applyTo,
					lessDep : lessDep
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						if(res.message == "1"){
							$("lessDep").checked = false;
							showMessageBox("Depreciation may only be applied to labor.", "I");
							
						}else if (res.message == "2"){
							$("lessDep").checked = false;
							showMessageBox("No depriciation amounts exist for this evaluation, checking of this option is not applicable.", "I");
						}else{
							$("vatAmt").value =formatCurrency(res.vatAmt);
							$("baseAmt").value = formatCurrency(res.baseAmt);
							enableButton("btnCreateVatDetails");
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("validateLessDeductibles",e);
		}
	}
	
	function checkEnableCreateVat(evalId){
		try{
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "checkEnableCreateVat",
					evalId: evalId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText;
						if(res == "Y"){
							enableButton("btnCreateVatDetails");
						}else{
							disableButton("btnCreateVatDetails");
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("validateLessDeductibles",e);
		}
	}
	
	function createGICLEvalVatObj(){
		try{
			var obj = {};
			obj.dspCompany = $F("dspCompany");
			obj.dspPartLabor = $F("dspPartLabor");
			obj.evalId = selectedMcEvalObj.evalId;
			obj.payeeTypeCd = $F("payeeTypeCd");
			obj.payeeCd = $F("payeeCd");
			obj.applyTo = $F("applyTo");
			obj.paytPayeeTypeCd = $F("paytPayeeTypeCd");
			obj.paytPayeeCd = $F("paytPayeeCd");
			obj.netTag = $F("netTag");
			obj.lessDed = $("lessDed").checked ? "Y" : "N";
			obj.lessDep = $("lessDep").checked ? "Y" : "N";
			obj.vatAmt = unformatNumber($F("vatAmt"));
			obj.vatRate = unformatNumber($F("vatRate"));
			obj.baseAmt = unformatNumber($F("baseAmt")); 
			obj.withVat = $F("withVat");
			return obj;
		}catch(e){
			showErrorMessage("createGICLEvalVatObj",e);
		}
	}
	
	function addVatDetails(){
		try{
			var newVat = createGICLEvalVatObj();
			
			if($F("btnAddVat") == "Add"){
				newVat.recordStatus = "0";
				computeTotalVat("add");
				vatGrid.addBottomRow(newVat);
				giclEvalVatDtlTGArrObj.push(newVat);
			}else{
				newVat.recordStatus = "1";
				computeTotalVat("update");
				vatGrid.updateVisibleRowOnly(newVat, selectedVatIndex);
				addModifiedVatDtl(newVat);
			}
			populateVatDetails(null);
			$("btnAddVat").value = "Add";
			disableButton("btnDelVat");
			selectedVatIndex = null;		
			vatGrid.releaseKeys();
			changeTag= 1;
		}catch(e){
			showErrorMessage("addVatDetails",e);
		}
	}
	
	function addModifiedVatDtl(editedVat){
		try{
			for ( var i = 0; i < giclEvalVatDtlTGArrObj.length; i++) {
				var vat = giclEvalVatDtlTGArrObj[i];
				if(editedVat.payeeCd == vat.payeeCd && editedVat.payeeTypeCd == vat.payeeTypeCd){
					if(vat.recordStatus == "0" && editedVat.recordStatus == "-1"){ // removed if just added
						giclEvalVatDtlTGArrObj.splice(i,1);
					}else{// if modified
						giclEvalVatDtlTGArrObj.splice(i,1,editedVat);
					}
				}
			}
		}catch(e){
			showErrorMessage("addModifiedVatDtl",e);
		}
	}
	
	function computeTotalVat(operation){
		try{
			var totalVat = parseFloat(nvl(unformatNumber($F("totalVat")),"0"));
			var newTotal;
			var vatAmt = parseFloat(nvl(unformatNumber($F("vatAmt")),"0"));
			if(operation == "add"){
				newTotal = totalVat + vatAmt;
			}else if(operation =="update"){
				// substracts the old amounts first before adding the new amounts
				var origVatAmt =  parseFloat(nvl(unformatNumber(vatGrid.geniisysRows[selectedVatIndex].vatAmt),"0"));
				newTotal = (totalVat - origVatAmt) + vatAmt;
			}else{
				newTotal = totalVat - vatAmt;
			}
			
			$("totalVat").value = formatCurrency(newTotal);
		}catch(e){
			showErrorMessage("computeTotalVat",e);
		}
	}
	
	function createVatDetails(){
		try{
			var objParameters = {};
			objParameters.setRows 	= getAddedAndModifiedJSONObjects(giclEvalVatDtlTGArrObj);
			objParameters.evalId = selectedMcEvalObj.evalId;
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "createVatDetails",
					strParameters: strParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.split(",");
						if(res[0] == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								changeTag = 0;
								hasSaved = "Y";
								selectedMcEvalObj.vat = res[1]; // temporarily update the main eval vat total
								genericObjOverlay.close();
								showMcEvalVATDetails();
							});	
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				}		
			});
		}catch (e) {
			showErrorMessage("CreateVatDetails",e);
		}
	}
	
	function saveVatDetail(){
		try{
			var objParameters = {};
			objParameters.setRows 	= getAddedAndModifiedJSONObjects(giclEvalVatDtlTGArrObj);
			objParameters.deletedRows = getDeletedJSONObjects(giclEvalVatDtlTGArrObj);
			objParameters.evalId = selectedMcEvalObj.evalId;
			objParameters.totalVat = unformatNumber($F("totalVat"));
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GICLEvalVatController", {
				parameters:{
					action: "saveVatDetail",
					strParameters: strParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								changeTag = 0;
								hasSaved = "Y";
								selectedMcEvalObj.vat = $F("totalVat"); // temporarily update the main eval vat total
								genericObjOverlay.close();
								showMcEvalVATDetails();
							});	
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				}		
			});
		}catch (e) {
			showErrorMessage("saveVatDetail",e);
		}
	}
	
	$("btnCreateVatDetails").observe("click", createVatDetails);
	
	$("btnSaveVatDetail").observe("click",function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}else{
			saveVatDetail();
		}
	});
	
	$("btnAddVat").observe("click",function(){
		if($F("dspCompany") == ""){
			showMessageBox("Please select a company first.", "I");
		}else if($F("dspPartLabor") == ""){
			showMessageBox("Please select a part/labor first.", "I");
		}else{
			addVatDetails();
		}
	});
	
	$("btnDelVat").observe("click",function(){
		computeTotalVat("delete");
		var delObj = createGICLEvalVatObj();
		delObj.recordStatus = "-1";
		addModifiedVatDtl(delObj);
		vatGrid.deleteVisibleRowOnly(selectedVatIndex);
		populateVatDetails(null);
		
		$("btnAddVat").value = "Add";
		disableButton("btnDelVat");
		changeTag = 1;
	});
	
	$("lessDep").observe("change",function(){
		validateLessDepreciation(selectedMcEvalObj.evalId,$F("payeeCd"),$F("payeeTypeCd"),$F("applyTo"),($("lessDep").checked ?"Y": "N"));
	});
	
	$("lessDed").observe("change",function(){
		validateLessDeductibles(selectedMcEvalObj.evalId,$F("payeeCd"),$F("payeeTypeCd"),$F("applyTo"),($("lessDed").checked ?"Y": "N"));
	});
	
	$("dspCompanyIcon").observe("click", function(){
		getEvalVatComLOV(selectedMcEvalObj.evalId);
	});
	
	$("dspPartLaborIcon").observe("click", function(){
		getEvalVatPartLaborLOV(selectedMcEvalObj.evalId,$F("payeeCd"),$F("payeeTypeCd"));
	});
	observeCancelForm("btnMainScreen", saveVatDetail, function(){
		genericObjOverlay.close();
		if(hasSaved == "Y"){
			refreshMainMcEvalList();
		}
	});
	
/* 	observeReloadForm("reloadForm",function(){
		genericObjOverlay.close();
		showMcEvalVATDetails();
	}); */
	disableSearch("dspPartLaborIcon");
	
	checkEnableCreateVat(selectedMcEvalObj.evalId);
	checkIfVatDetIsEditable();
	initializeAll();
	initializeAllMoneyFields();
	
	//bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("vatDetailsDiv").hide();
		$("vatDetailsButtonsDiv").hide();
		$("btnCreateVatDetails").hide();
		$("btnSaveVatDetail").hide();
	}
</script>