<div id="depreciationDetailsInfoDiv" style="padding: 5px;">
<!-- 	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Depreciation Details</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div> -->
	
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 0; margin-bottom:0; " >
		<table align="center">
			<tr>
				<td class="rightAligned" >Payee:</td>  
				<td class="leftAligned" style=" width: 260px;">
					<div id="dspCompanyTypeDiv" style="width: 247px; float: left;" class="withIconDiv required">
						<input type="hidden" id="payeeTypeCd" name="payeeTypeCd"/>
						<input type="text" id="dspCompanyType" name="dspCompanyType" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyTypeIcon"  alt="Go" />
					</div>
				</td>
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
		<div id="depDtlDiv"  style=" height: 220px; "></div>
		<!-- <div style="width: 400px; float: right; margin-right: 10px; margin-top: 10px; margin-bottom: 10px;">
			<input type="text" style="float: right; width: 140px;" id="total"  readonly="readonly" class="rightAligned"/>
			<label style="float: right; margin-top: 5px;" class="money2">total: </label>
		</div> -->
		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="right" style="width: 170px;"><b>Total:</b></td>
						<td><input type="text" id="total" name="total" class="money" style="width: 150px; margin-right: 8px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="depreciationDetailsDiv" style="padding: 10px;  height: 100px; margin-bottom:10px; width: ; "changeTagAttr="true">
			<table align="center">
				<tr>
					<td class="rightAligned" >Part:</td>  
					<td class="leftAligned" style=" width: 70px;">
						<input style="width: 60px;  float: left;" readonly="readonly" id="lossExpCd" name="lossExpCd" type="text" />
					</td>
					<td class="rightAligned" >Part Decription:</td>  
					<td class="leftAligned" >
						<input style="width: 200px;  float: left;" readonly="readonly" id="partDesc" name="partDesc" type="text" value="" />
					</td>  
				</tr>
				<tr>
					<td class="rightAligned" >Rate:</td>  
					<td class="rightAligned" style=" width: 63px;">
						<input style="width: 60px;   float: left;"  id="dedRt" name="dedRt" type="text" value="" min="0" max="100" class="money2 required" errorMsg="Invalid rate."/> <!-- modified by robert the min and max 04.26.2013 -->
					</td>
					<td class="rightAligned" >Part Amount:</td> 
					<td class="leftAligned" >
						<input style="width: 200px;  float: left;" readonly="readonly" id="partAmt" name="partAmt" type="text" class="money2"/>
					</td>   
				</tr>
				<tr>
					<td class="rightAligned" >Depreciation Amount:</td>  
					<td class="rightAligned" style=" width: 63px;" colspan="5">
						<input style="width: 200px;  float: left;" readonly="readonly" id="dedAmt" name="dedAmt" type="text" class="money2" />
					</td>
				</tr>
			</table>
		</div>
		<div id="depreciationDetailsButtonsDiv">
			<table style=" margin-bottom: 10px;" align="center" >
				<tr>
					<td>
						<input type="button" class="disabledButton" id="btnUpdateDepDet" value="Update" style="width:100px;" />
					</td>
				</tr>
			</table>
		</div>
	</div>
	<input type="hidden" id="partType"/>
	<input type="hidden" id="itemNo"/>
	<input type="hidden" id="payeeCdOld"/>
	<input type="hidden" id="payeeTypeCdOld"/>
	<input type="hidden" id="vatExist"/>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnApplyDepreciation" value="Apply Depreciation" style="width:150px;"/>
			<input type="button" class="button" id="btnSaveDepreciation" value="Save" style="width:100px;" title="Save"/>
			<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:100px;" title="back to main"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	var depPayeeObj =JSON.parse('${depPayeeObj}'.replace(/\\/g, '\\\\')); 
	var initialPayeeObj =JSON.parse('${initialPayeeObj}'.replace(/\\/g, '\\\\'));
	giclEvalDepDtlTGArrObj = [];
	changeTag = 0;
	
	if(JSON.stringify(depPayeeObj) == "{}"){ // means null, populate the fields using initial payee based on repair details
		$("payeeTypeCd").value = initialPayeeObj== null ? "" : initialPayeeObj.payeeTypeCd;
		$("dspCompanyType").value = initialPayeeObj== null ? "" : unescapeHTML2(initialPayeeObj.dspCompanyType);
		$("payeeCd").value = initialPayeeObj== null ? "" : initialPayeeObj.payeeCd;
		$("dspCompany").value = initialPayeeObj== null ? "" : unescapeHTML2(initialPayeeObj.dspCompany);
		$("total").value = initialPayeeObj== null ? "" : formatCurrency(initialPayeeObj.totalAmount);
	}else{
		$("payeeTypeCd").value = depPayeeObj== null ? "" : depPayeeObj.payeeTypeCd;
		$("dspCompanyType").value = depPayeeObj== null ? "" : unescapeHTML2(depPayeeObj.dspCompanyType);
		$("payeeCd").value = depPayeeObj== null ? "" : depPayeeObj.payeeCd;
		$("dspCompany").value = depPayeeObj== null ? "" : unescapeHTML2(depPayeeObj.dspCompany);
		$("total").value = initialPayeeObj== null ? "" : formatCurrency(depPayeeObj.totalAmount);
	}
	
	function updateDepDetail(){
		try{
			var dep = {};
			var dedRt = unformatNumber($F("dedRt"));
			dep.lossExpCd = $F("lossExpCd");
			dep.partDesc = escapeHTML2($F("partDesc"));
			dep.partAmt = $F("partAmt");
			dep.evalId = selectedMcEvalObj.evalId;
			dep.partType = $F("partType");
			dep.itemNo = $F("itemNo");
			dep.recordStatus = 1;
			var partAmt = parseFloat(unformatNumber(dep.partAmt));
			var dedAmt = (parseFloat(dedRt)/100) * partAmt;
			// compute total ded amount first
			var origDepAmt =  parseFloat(nvl(unformatNumber(depreciationGrid.geniisysRows[selectedDepIndex].dedAmt),"0"));
			var total = (parseFloat(nvl(unformatNumber($F("total")),"0"))) + dedAmt;
			$("total").value = formatCurrency((total - origDepAmt));
			
			if(dedRt != "" ){
				dep.dedRt = dedRt;
				dep.payeeCd = $F("payeeCd");
				dep.payeeTypeCd = $F("payeeTypeCd");
				dep.dedAmt = dedAmt;
			}else{
				dep.dedRt = '';
				dep.payeeCd = "";
				dep.payeeTypeCd = "";
				dep.dedAmt = '';
			}
			
			depreciationGrid.updateVisibleRowOnly(dep, selectedDepIndex);
			//adds custom attributes
			dep.payeeTypeCdOld = $F("payeeTypeCdOld");
			dep.payeeCdOld = $F("payeeCdOld");
			dep.vatExist = nvl($F("vatExist"),"N");
			//updates the obj array and the TG
			for ( var i = 0; i < giclEvalDepDtlTGArrObj.length; i++) {
				var oldDep = giclEvalDepDtlTGArrObj[i];
				if(dep.lossExpCd == oldDep.lossExpCd){
					giclEvalDepDtlTGArrObj.splice(i,1,dep);
					
				}
			}
			populateDepreciationDtlFields(null);
			depreciationGrid.releaseKeys();
			changeTag = 1;
		}catch (e) {
			showErrorMessage("updateDepDetail",e);
		}
	}
	
	$("btnSaveDepreciation").observe("click",function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}else{
			if($F("dspCompanyType") == "" ||$F("dspCompany") == ""){// condition to prevent adding of replace det when there is no payee selsected
				showMessageBox("Please select a company first", "I");
			}else{
				saveDepreciationDtls();	
			}
		}
	});
	
	function checkDepVat(){
		try{
			new Ajax.Request(contextPath + "/GICLEvalDepDtlController", {
				parameters:{
					action: "checkDepVat",
					evalId: selectedMcEvalObj.evalId,
					lossExpCd: $F("lossExpCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams(); 
						$("vatExist").value = res.vatExist;
						if(res.vatExist == "Y"){
							showConfirmBox("Vat Exist","The report to which this detail is under already has Tax/es. Updating this record will detele the Tax/es. Are you sure you want to save the changes?",
								"Yes","No",function(){
									$("payeeTypeCdOld").value = res.payeeTypeCd;
									$("payeeCdOld").value = res.payeeCd;
									updateDepDetail();
							},null		
							);
						}else{
							updateDepDetail();
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch (e) {
			showErrorMessage("checkDepVat",e);
		} 
		
	}
	
	$("btnUpdateDepDet").observe("click",function(){
		if($F("dspCompanyType") == "" ||$F("dspCompany") == ""){// condition to prevent adding of replace det when there is no payee selsected
			showMessageBox("Please select a company first", "I");
		}else if(formatToNineDecimal($F("dedRt").replace(/,/g, "")) > 100.000000000) {	//added by robert 04.26.2013		
				showMessageBox("Invalid Rate.", imgMessage.ERROR, 
					function(){
						$("dedRt").select();
						$("dedRt").focus();
						return false;
					});		
		}else{
			var dedRt = $F("dedRt");
			if(nvl(dedRt, "0") != nvl(prevDedRt, "0")){
				checkDepVat();
			}else{
				updateDepDetail();
			}
		}
	});
	
	$("dspCompanyTypeIcon").observe("click",function(){
		getEvalDepCompanyTypeLOV(selectedMcEvalObj.evalId);
	});
	
	$("dspCompanyIcon").observe("click",function(){
		getEvalDepCompanyLOV(selectedMcEvalObj.evalId);
	});
	
	$("btnApplyDepreciation").observe("click",applyDepreciation);
	
	observeCancelForm("btnMainScreen", saveDepreciationDtls, function(){
		genericObjOverlay.close();
		if(hasSaved == "Y"){
			refreshMainMcEvalList();
		}
	});
	
/* 	observeReloadForm("reloadForm",function(){
		genericObjOverlay.close();
		showMcEvalDepreciationDetails();
	}); */
	
	getEvalDepList(nvl(selectedMcEvalObj.evalId,null));
	checkIfDepreciationDetIsEditable();
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeChangeTagBehavior(saveDepreciationDtls);
	
	// bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("depreciationDetailsDiv").hide();
		$("depreciationDetailsButtonsDiv").hide();
		$("btnApplyDepreciation").hide();
		$("btnSaveDepreciation").hide();
		$("dspCompanyTypeDiv").removeClassName("required");
		$("dspCompanyType").removeClassName("required");
		$("dspCompanyTypeIcon").hide();
		$("dspCompanyDiv").removeClassName("required");
		$("dspCompany").removeClassName("required");
		$("dspCompanyIcon").hide();
	}
</script>