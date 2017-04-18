<div id="repairDetailsInfoDiv" style="padding: 5px;">
	<form id="repairDetailsForm" name="repairDetailsForm">
<!-- 		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Repair Details</label>
				<span class="refreshers" style="margin-top: 0;">
			 		<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div> -->
		<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 5px;" >
			<table align="center">
				<tr>
					<td class="rightAligned" >Company Type</td>  
					<td class="leftAligned" style=" width: 260px;">
						<div id="dspCompanyTypeDiv" style="width: 247px; float: left;" class="withIconDiv required">
							<input type="hidden" id="payeeTypeCd" name="payeeTypeCd"/>
							<input type="text" id="dspCompanyType" name="dspCompanyType" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyTypeIcon"  alt="Go" />
						</div>
					</td>
					<td class="rightAligned" >Company</td>  
					<td class="leftAligned">
						<div id="dspCompanyDiv" style="width: 260px; float: left;" class="withIconDiv required">
							<input id="payeeCd" name="payeeCd"  type="hidden"/>
							<input type="text" id="dspCompany" name="dspCompany" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyIcon"  alt="Go" />
						</div>
					</td>
				</tr>	
			</table>
		</div>
		<div class="sectionDiv" style="">
			<div id="lpsDtlDiv"  style="padding:5px;  height: 140px; margin-bottom: 5px; "></div>
			
			<div  style="padding: 10px; height: 100px; margin-bottom: 0;" changeTagAttr="true">
				<table align="right">
					<tr>
						<td class="rightAligned" >Total Amount from Labor Point System</td>  
						<td class="leftAligned" style=" width: 149px;">
							<input style="width: 120px;  float: left;" readonly="readonly" id="dspTotalT" name="dspTotalT" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>
						<td class="rightAligned" >
							<input style="width: 120px;  float: left;" readonly="readonly" id="dspTotalP" name="dspTotalP" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>  
						<td class="leftAligned">
							<input style="width: 150px;  float: left;" readonly="readonly" id="lpsRepairAmt" name="lpsRepairAmt" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Actual Labor Amount</td>  
						<td class="leftAligned" >
							<input style="width: 120px;  float: left;"  id="actualTinsmithAmt" name="actualTinsmithAmt" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>
						<td class="rightAligned" >
							<input style="width: 120px;  float: left;"  id="actualPaintingAmt" name="actualPaintingAmt" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td> 
						<td class="rightAligned" >
							<input style="width: 150px;  float: left;"  id="actualTotalAmt" name="actualTotalAmt" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td> 
					</tr>	
					<tr>
						<td td class="rightAligned" colspan="2">
							<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 80px;">With V.A.T.</label>
							<div style="float: left;">
								<input id="withVat"  name="withVat" type="checkbox" value="" style="width:16px; height:20px;" title="Exclusive of Vat">
							</div>
						</td>
						<td class="rightAligned" >Other Labor Amount</td>  
						<td class="rightAligned" >
							<input readonly="readonly" style="width: 150px;   float: left;"  id="otherLaborAmt" name="otherLaborAmt" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>
					</tr>
					<tr>
						<td td class="rightAligned" colspan="3">Total Labor Amount</td>
						<td>
							<input style="width: 150px;  float: left;"  id="dspTotalLabor" name="dspTotalLabor" type="text" value="" min="1" max="9999999999999.90" class="money2"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="sectionDiv" id="repairLpsDtlFields" style="padding-top: 5px;" >
		<!-- <div class="sectionDiv" id="repairLpsDtlFields" style="padding: 5px;  height: 130px; margin-top: 10px; margin-bottom:10px;" > -->
<%-- 			<table align="center">
				<tr>
					<td class="rightAligned" >Item No:</td>  
					<td class="leftAligned" style=" width: 72px;">
						<div style=" width: 60px; height: 21px; float: left;">
							<input style="width: 60px;  float: left;" id="itemNo"  type="text" value="" readOnly="readonly" />  
						</div>
					</td>
					<td class="rightAligned" >Vehicle Part:</td>  
					<td colspan="3">
						<div style="width: 247px; float: left;" class="withIconDiv required">
							<input type="hidden" id="lossExpCd" />
							<input type="text" id="dspLossDesc" name="dspLossDesc" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspLossDescIcon"  alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" colspan="2">
						
						<input disabled="disabled" class="rightAligned" id="tinsmithRepairCd"  name="tinsmithRepairCd" type="checkbox" value="" style="width:16px; height:20px; float: right;" title="Add Tinsmith Amount">
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: right; width: 10px;">T</label>
					</td>
					<td class="rightAligned">Tinsmith Type:</td>
					<td class="leftAligned">
						<div style="width: 120px; float: left;"  >
							<select class="required" id="tinsmithType" name="tinsmithType" style="width: 125px;" disabled="disabled"> 
								<option value="L" >Light</option>
								<option value="M">Medium</option>
								<option value="H">Heavy</option>
								<option selected="selected" ></option>
							</select>
						</div>
					</td>
					<td class="rightAligned">Tinsmith:</td>
					<td>
						<input style="width: 120px;  float: left;" id="tinsmithAmount" name="tinsmithAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" colspan="2">
						<input disabled="disabled"  class="rightAligned" id="paintingsRepairCd"  name="paintingsRepairCd" type="checkbox" value="" style="width:16px; height:20px; float: right;" title="Add Paintings Amount">
						<label  class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: right; width: 10px;">P</label>
					</td>
					<td class="rightAligned">Paintings:</td>
					<td>
						<input style="width: 120px;  float: left;" id="paintingsAmount" name="paintingsAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
					<td class="rightAligned">Total:</td>
					<td>
						<input style="width: 120px;  float: left;" id="totalAmount" name="totalAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
				</tr>
			</table> --%>
			<table align="center">
				<tr>
					<td class="rightAligned" >Item No</td>  
					<td class="leftAligned">
						<div style=" width: 60px; height: 21px; float: left;">
							<input style="width: 60px;  float: left;" id="itemNo"  type="text" value="" readOnly="readonly" />  
						</div>
					</td>
					<td class="rightAligned">						
						<input disabled="disabled" class="rightAligned" id="tinsmithRepairCd"  name="tinsmithRepairCd" type="checkbox" value="" style="width:16px; height:20px; float: right;" title="Add Tinsmith Amount">
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: right; width: 10px;">T</label>
					</td>
					<td class="rightAligned">Tinsmith Type</td>
					<td class="leftAligned">
						<div style="width: 120px; float: left;"  >
							<select class="required" id="tinsmithType" name="tinsmithType" style="width: 125px;" disabled="disabled"> 
								<option value="L" >Light</option>
								<option value="M">Medium</option>
								<option value="H">Heavy</option>
								<option selected="selected" ></option>
							</select>
						</div>
					</td>
					<td class="rightAligned">Tinsmith</td>
					<td>
						<input style="width: 120px;  float: left;" id="tinsmithAmount" name="tinsmithAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Vehicle Part</td>  
					<td>
						<div style="width: 247px; float: left;" class="withIconDiv required">
							<input type="hidden" id="lossExpCd" />
							<input type="text" id="dspLossDesc" name="dspLossDesc" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspLossDescIcon"  alt="Go" />
						</div>
					</td>
					<td class="rightAligned">
						<input disabled="disabled"  class="rightAligned" id="paintingsRepairCd"  name="paintingsRepairCd" type="checkbox" value="" style="width:16px; height:20px; float: right;" title="Add Paintings Amount">
						<label  class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: right; width: 10px;">P</label>
					</td>
					<td class="rightAligned">Paintings</td>
					<td>
						<input style="width: 120px;  float: left;" id="paintingsAmount" name="paintingsAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
					<td class="rightAligned">Total</td>
					<td>
						<input style="width: 120px;  float: left;" id="totalAmount" name="totalAmount" type="text" value=""  class="money required" readonly="readonly"/>
					</td>
				</tr>
			</table>			
			<table style="margin-top: 5px; margin-bottom: 5px;" align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnAddRepairDet" value="Add" style="width:100px;"/>
						<input type="button" class="disabledButton" id="btnDeleteRepairDet" value="Delete" style="width:100px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 5px; margin-bottom:0; " >
			<div style="text-align:center">
				<input type="button" class="button" id="btnOtherLabor" value="Other Labor" style="width:100px;"/>
				<input type="button" class="button" id="btnReplaceDetails" value="Replace Details" style="width:120px;"/>
				<input type="button" class="button" id="btnVAT" value="V.A.T." style="width:100px;"/>
				<input type="button" class="button" id="btnDeductibles" value="Deductibles" style="width:100px;"/>
				<input type="button" class="button" id="btnLPSMaintenance" value="LPS Maintenance" style="width:150px;"/>
				<input type="button" class="button" id="btnSaveRepairDtl" value="Save" style="width:100px;" title="Save"/>
				<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:100px;" title="back to main"/>
			</div>
		</div>
		<input id="dspLaborComType" type="hidden" />
		<input id="dspLaborCompany" type="hidden" />
		<input id="initialTinsmithAmount" type="hidden" />
	</form>
</div>

<script type="text/javascript">
	changeTag = 0;
	
	giclRepairObj  = '${giclRepairObj}' == '{}' ? null : JSON.parse('${giclRepairObj}'.replace(/\\/g, '\\\\'));
	objGICLReplaceLpsDtlArr = [];
	objGICLReplaceLpsDtlDelRows = [];
	/* $("tinsmithType").disabled = "disabled";
	$("tinsmithRepairCd").disabled = "disabled";
	$("paintingsRepairCd").disabled = "disabled"; */
	/*TINSMITH**/
	function getTinsmithAmount(){
		try{
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "getTinsmithAmount",
					lossExpCd: $F("lossExpCd"),
					tinsmithType : $F("tinsmithType")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var tins = parseFloat(response.responseText);
						$("initialTinsmithAmount").value =$F("tinsmithAmount"); // store the value of tinsmith before query 
						$("tinsmithAmount").value = formatCurrency(tins);
						changeTag = 1;
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("getTinsmithAmount",e);
		}
	}
	/***/
	/*PAINTINGS**/
	function getPaintingsAmount(){
		try{
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "getPaintingsAmount",
					lossExpCd: $F("lossExpCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						if(response.responseText == 'Painting has no amount.'){
							showMessageBox(response.responseText , "I");
							$("paintingsRepairCd").checked = false;
						}else{
							var painting = parseFloat(response.responseText);
							$("paintingsAmount").value = formatCurrency(painting);
							changeTag = 1;
						}
						
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("getPaintingsAmount",e);
		}
	}
	
	/***/
	/**COMPUTATIONS*/
	
	function computeAmounts(operation){
		try{
			var dspTotalT = parseFloat(nvl(unformatNumber($F("dspTotalT")),"0"));
			var dspTotalP = parseFloat(nvl(unformatNumber($F("dspTotalP")),"0"));
			var tinsmithAmount = parseFloat(nvl(unformatNumber($F("tinsmithAmount")),"0"));
			var paintingsAmount = parseFloat(nvl(unformatNumber($F("paintingsAmount")),"0"));
			var tinTotal;
			var paintTotal;
			if(operation == "add"){
				tinTotal = dspTotalT  + tinsmithAmount;
				paintTotal = dspTotalP + paintingsAmount;
			}else if(operation =="update"){
				// substracts the old amounts first before adding the new amounts
				var origTinsmith =  parseFloat(nvl(unformatNumber(repairGrid.geniisysRows[repairGridSelectedIndex].tinsmithAmount),"0"));
				var origPaintings =  parseFloat(nvl(unformatNumber(repairGrid.geniisysRows[repairGridSelectedIndex].paintingsAmount),"0"));
				tinTotal = (dspTotalT - origTinsmith) + tinsmithAmount;
				paintTotal = (dspTotalP - origPaintings) + paintingsAmount;
			}
			
			$("dspTotalT").value = formatCurrency(tinTotal);
			$("dspTotalP").value = formatCurrency(paintTotal);
			
			$("actualPaintingAmt").value = formatCurrency(paintTotal);
			$("actualTinsmithAmt").value = formatCurrency(tinTotal);
			
			$("lpsRepairAmt").value = formatCurrency(tinTotal + paintTotal);
		
			computeActualTotalAmt();
		}catch(e){
			showErrorMessage("computeAmounts",e);
		}
	}
	
	function computeActualTotalAmt(){
		try{
			var actualPaintingAmt = parseFloat(nvl(unformatNumber($F("actualPaintingAmt")),"0"));
			var actualTinsmithAmt = parseFloat(nvl(unformatNumber($F("actualTinsmithAmt")),"0"));
			var otherLaborAmt = parseFloat(nvl(unformatNumber($F("otherLaborAmt")),"0"));;
			$("actualTotalAmt").value = formatCurrency((actualPaintingAmt + actualTinsmithAmt));
			$("dspTotalLabor").value = formatCurrency((actualPaintingAmt + actualTinsmithAmt+ otherLaborAmt));
		}catch(e){
			showErrorMessage("computeActualTotalAmt",e);
		}
	}
	
	function computeTotalAmount(){
		try{
			$("totalAmount").value = formatCurrency(parseFloat(nvl(unformatNumber($F("tinsmithAmount")),"0"))+parseFloat(nvl(unformatNumber($F("paintingsAmount")),"0")));
		}catch(e){
			showErrorMessage("computeTotalAmount",e);
		}
	}
	/*END OF COMPUTATIONS**/
	
	function createGICLRepairLpsObj(){
		var newRep = {};
		var text = $("tinsmithType").options[$("tinsmithType").selectedIndex].innerHTML;
		newRep.evalId = selectedMcEvalObj.evalId;
		newRep.lossExpCd = $F("lossExpCd");
		newRep.tinsmithType = $F("tinsmithType");
		newRep.tinsmithTypeDesc =text;
		newRep.updateSw = "N";
		newRep.tinsmithRepairCd = $("tinsmithRepairCd").checked ? "Y" : "N";
		newRep.tinsmithAmount = $F("tinsmithAmount");
		newRep.paintingsRepairCd = $("paintingsRepairCd").checked ? "Y" : "N";
		newRep.paintingsAmount = $F("paintingsAmount");
		newRep.dspLossDesc = $F("dspLossDesc");
		newRep.totalAmount = $F("totalAmount");
		return newRep;
	}
	
	function addRepairDet(){
		try{
			var newRep = createGICLRepairLpsObj();
			
			if($F("btnAddRepairDet") == "Add"){
				newRep.itemNo = "";
				newRep.recordStatus = "0";
				computeAmounts("add");
				repairGrid.addBottomRow(newRep);
				objGICLReplaceLpsDtlArr.push(newRep);
			}else{
				newRep.itemNo = $F("itemNo");
				newRep.recordStatus = "1";
				computeAmounts("update");
				repairGrid.updateVisibleRowOnly(newRep, repairGridSelectedIndex);
				//repairGrid.updateRowAt(newRep, repairGridSelectedIndex);
			
				addModifiedRepairLpsDtl(newRep);
			}
		
			populateRepairLpsDtlFields(null);
			$("btnAddRepairDet").value = "Add";
			disableButton("btnDeleteRepairDet");
			repairGridSelectedIndex = null;		
			repairGrid.releaseKeys();
			if(changeInDetails == 1){
				changeTag = 1;	
			}else{
				changeTag = 0;
			}
			
		}catch(e){
			showErrorMessage("addRepairDet",e);
		}
	}
	function addModifiedRepairLpsDtl(editedObj){
		try{
			for ( var i = 0; i < objGICLReplaceLpsDtlArr.length; i++) {
				var repair = objGICLReplaceLpsDtlArr[i];
				if(/*repair.itemNo = editedObj.itemNo ||*/ editedObj.lossExpCd == repair.lossExpCd){
					if(repair.recordStatus == "0" && editedObj.recordStatus == "-1"){ // removed if just added
						objGICLReplaceLpsDtlArr.splice(i,1);
					}else{// if modified
						objGICLReplaceLpsDtlArr.splice(i,1,editedObj);
					}
				}
			}
			
		}catch(e){
			showErrorMessage("addModifiedRepairLpsDtl",e);
		}
	}
	
	// added by kenneth 11.20.2013
	changeInDetails = 0;
	
	$$("input[type='text']").each(function(div) {
		div.observe("change", function() {
			changeInDetails = 1;
		});
	});
	
	$$("input[type='checkbox']").each(function(div) {
		div.observe("click", function() {
			changeInDetails = 1;
		});
	});
	// end
	
	$("btnAddRepairDet").observe("click",function(){
		if($F("dspLossDesc") == ""){
			showMessageBox("Please select a vehicle part first.", "I");
		}else if($F("tinsmithAmount") == "" && $F("paintingsAmount") == ""){
			showMessageBox("Tinsmith or Painting amount is required.", "I");
		}else{
			addRepairDet();
		}
		
	});
	
	$("btnDeleteRepairDet").observe("click",function(){
		computeAmounts("delete");
		var delObj = createGICLRepairLpsObj();
		delObj.itemNo = $F("itemNo");
		delObj.recordStatus = "-1";
		
		addModifiedRepairLpsDtl(delObj);
		repairGrid.deleteVisibleRowOnly(repairGridSelectedIndex);
		populateRepairLpsDtlFields(null);
		
		$("btnAddRepairDet").value = "Add";
		disableButton("btnDeleteRepairDet");
		changeTag = 1;
		changeInDetails = 1;
	});
	
	$("tinsmithRepairCd").observe("change",function(){
		if($("tinsmithRepairCd").checked){
			$("tinsmithType").disabled = "";
			$("tinsmithType").value = "L";
			getTinsmithAmount();
		}else{
			$("tinsmithType").disabled = "disabled";
			$("tinsmithType").value = "";
			$("tinsmithAmount").value = "";
		}
		computeTotalAmount();
	});
	
	$("paintingsRepairCd").observe("change",function(){
		if($("paintingsRepairCd").checked){
			getPaintingsAmount();
		}else{
			$("paintingsAmount").value = "";
		}
		computeTotalAmount();
	});
	
	$("tinsmithType").observe("change",function(){
		getTinsmithAmount();
		computeTotalAmount();	//added by Gzelle 08052014
	});
	
	$("dspCompanyTypeIcon").observe("click",getMcEvalCompanyTypeListLOV2);
	
	$("dspCompanyIcon").observe("click",function(){
		if($F("dspCompanyType") == ""){
			showMessageBox("Please enter company type first.", "I");
		}else{
			if($F("payeeTypeCd") == variablesObj.mortgageeClassCd){
				getCompanyListLOV2(mcMainObj.claimId, $F("payeeTypeCd"));
			 }else if($F("payeeTypeCd") != ""){
				 getCompanyListLOV2(mcMainObj.claimId, $F("payeeTypeCd"));
			 }
			
		}
	});

	$("dspLossDescIcon").observe("click",function(){
		if($F("payeeTypeCd") == "" ||$F("payeeCd") == ""){// condition to prevent adding of replace det when there is no payee selsected
			showMessageBox("Please select a company first", "I");
		}else{
			var notIn = createCompletedNotInParam(repairGrid, "lossExpCd");
			getVehiclePartsListLOV(selectedMcEvalObj.evalId,notIn);
		}
		
	});
	
	/* observeCancelForm("btnMainScreen", validateRepairBeforeSave, function(){
		genericObjOverlay.close();
		if(hasSaved == "Y"){
			refreshMainMcEvalList();
		}
	}); */
	
 	$("btnMainScreen").observe("click",function(){
		if(changeTag == 1 && changeInDetails == 1){
			validateRepairBeforeSave("main");
		}else{
			genericObjOverlay.close();
			if(hasSaved == "Y"){
				refreshMainMcEvalList();
			}
		}
	}); 
	
/* 	observeReloadForm("reloadForm",function(){
		genericObjOverlay.close();
		showMcEvalRepairDetails();
	}); */
	
	$("btnReplaceDetails").observe("click",function(){
		if(changeTag == 1 && changeInDetails == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalReplaceDetails();
		}
	});
	
	function saveRepairDet(goTo){
		try{
			var objParameters = {};
			objParameters.giclRepairHdrObj = prepareGICLRepairDtlObject();
			objParameters.setRows 	= getAddedAndModifiedJSONObjects(objGICLReplaceLpsDtlArr);
			objParameters.deletedRows = getDeletedJSONObjects(objGICLReplaceLpsDtlArr);
			objParameters.evalId = selectedMcEvalObj.evalId;
			objParameters.evalMasterId = selectedMcEvalObj.evalMasterId;
			
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "saveRepairDet",
					strParameters: strParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						genericObjOverlay.close();
						showMcEvalRepairDetails();
						showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
							changeTag = 0;
							hasSaved = "Y";
							if(goTo == "main"){
								genericObjOverlay.close();
								if(hasSaved == "Y"){
									refreshMainMcEvalList();
								}
							}
						});	
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});	
		}catch(e){
			showErrorMessage("saveRepairDet",e);
		}
	}
	
	function prepareGICLRepairDtlObject(){
		try{
			var obj ={};
			obj.evalId = selectedMcEvalObj.evalId;
			obj.payeeTypeCd = $F("payeeTypeCd");
			obj.payeeCd = $F("payeeCd");
			obj.lpsRepairAmt = unformatNumber($F("lpsRepairAmt"));
			obj.actualTotalAmt = unformatNumber($F("actualTotalAmt"));
			obj.actualTinsmithAmt = unformatNumber($F("actualTinsmithAmt"));
			obj.actualPaintingAmt = unformatNumber($F("actualPaintingAmt"));
			obj.otherLaborAmt = unformatNumber($F("otherLaborAmt"));
			obj.actualTotalAmt = unformatNumber($F("actualTotalAmt"));
			obj.dspTotalLabor = unformatNumber($F("dspTotalLabor"));
			obj.withVat = ($("withVat").checked ? "Y" : "N");
				
			return obj;
		}catch(e){
			showErrorMessage("prepareGICLRepairDtlObject",e);
		}
	}
	
	function validateRepairBeforeSave(goTo){
		try{
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "validateRepairBeforeSave",
					evalMasterId: selectedMcEvalObj.evalMasterId,
					evalId: selectedMcEvalObj.evalId,
					payeeTypeCd: $F("payeeTypeCd"),
					payeeCd : $F("payeeCd"),
					actualTotalAmt : unformatNumber($F("actualTotalAmt"))
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText; 

						if(res == "Y"){
							showConfirmBox("Vat Exist","VAT already exist for Labor, saving this would automatically delete VAT record. Are you sure you want to save the changes?",
								"Yes","No",function(){
								saveRepairDet(goTo);},function(){
									saveRepairDet(goTo);}, function(){
										if(goTo == "main"){
											changeTag = 0;
											genericObjOverlay.close();
											if(hasSaved == "Y"){
												refreshMainMcEvalList();
											}
										}else{
											genericObjOverlay.close();
											showMcEvalRepairDetails();
										}
									}		
								);
						}else{
							/* showConfirmBox("Save Confirmation","Are you sure you want to save the changes?", replaced by kenneth L. 11.20.2013
									"Yes","No",function(){
								saveRepairDet(goTo);},
								null		
							);	 */	 
							
							showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
								saveRepairDet(goTo);}, function(){
									if(goTo == "main"){
										changeTag = 0;
										genericObjOverlay.close();
										if(hasSaved == "Y"){
											refreshMainMcEvalList();
										}
									}else{
										genericObjOverlay.close();
										showMcEvalRepairDetails();
									}
								}, null);
							}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("validateRepairBeforeSave",e);	
		}
	}
	$("btnSaveRepairDtl").observe("click",function(){
		if(changeTag == 0 && changeInDetails == 0){
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}else{
			if($F("payeeTypeCd") == "" ||$F("payeeCd") == ""){// condition to prevent adding of replace det when there is no payee selsected
				showMessageBox("Please select a company first", "I");
			}else{
				validateRepairBeforeSave(null);	
			}
		}
	});
	
	$("actualTinsmithAmt").observe("blur",computeActualTotalAmt);
	$("actualPaintingAmt").observe("blur",computeActualTotalAmt);
	$("actualTotalAmt").observe("blur",function(){
		var otherLaborAmt = parseFloat(nvl(unformatNumber($F("otherLaborAmt")),"0"));
		var actualTotalAmt= parseFloat(nvl(unformatNumber($F("actualTotalAmt")),"0"));
		$("dspTotalLabor").value = formatCurrency((otherLaborAmt + actualTotalAmt));
	});
	
	$("btnOtherLabor").observe("click",function(){
		if($F("payeeTypeCd") == "" ||$F("payeeCd") == ""){
			showMessageBox("Please select a company first", "I");
		}else if(changeTag == 1 && changeInDetails == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showRepairOtherLaborDetails();
		}
	});
	
	$("btnVAT").observe("click",function(){
		if(changeTag == 1 && changeInDetails == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalVATDetails();
		}
	});
	
	$("btnDeductibles").observe("click", function(){
		if(changeTag == 1 && changeInDetails == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalDeductibleDetails();
		}
	});
	$("btnLPSMaintenance").observe("click",function(){
		showMessageBox(objCommonMessage.UNAVAILABLE_MODULE,"I");
	});
	
	//actualPaintingAmt actualTotalAmt
	populateRepairDtlFields(nvl(giclRepairObj, null));
	getGicls070LpsDetailsList(giclRepairObj == null ? null : giclRepairObj.evalId);
	checkIfRepairDetIsEditable();
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	//initializeChangeTagBehavior(validateRepairBeforeSave);
	
	// bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("dspCompanyTypeDiv").removeClassName("required");
		$("dspCompanyType").removeClassName("required");
		$("dspCompanyTypeIcon").hide();
		$("dspCompanyDiv").removeClassName("required");
		$("dspCompany").removeClassName("required");
		$("dspCompanyIcon").hide();
		$("repairLpsDtlFields").hide();
		$("btnLPSMaintenance").hide();
		$("btnSaveRepairDtl").hide();
	}
</script>