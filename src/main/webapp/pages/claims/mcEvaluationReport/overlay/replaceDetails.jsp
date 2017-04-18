<div id="repairDetailsInfoDiv" style="padding: 5px;">	
	<form id="replaceDetailsForm" name="replaceDetailsForm">
<%-- 		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Replace Details</label>
				<span class="refreshers" style="margin-top: 0;">
			 		<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}"> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div> --%>
		<div class="sectionDiv" style="margin-top: 0;">
			<div style="padding: 5px;  height: 205px; margin-top: 0; ">
				<div id="replaceTG" style="height: 180px;"></div>
			</div>
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="right" style="width: 170px;"><b>Total Parts Amount:</b></td>
						<td><input type="text" id="totalParts" name="totalParts" class="money" style="width: 120px; margin-right: 20px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
<!-- 		<div class="sectionDiv" style="border: none;">
			<div style="float: right; margin-bottom: 5px;">
				<table>
					<tr>
						<td align="right" style="width: 170px;"><b>Total Parts Amount:</b></td>
						<td><input type="text" id="totalParts" name="totalParts" class="money" style="width: 120px; margin-right: 20px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div> -->
		<div id="replaceDetailsDiv" class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 0; margin-bottom:5px; " changeTagAttr="true">
			<table align="center">
				<tr>
					<td class="rightAligned" >Item No:</td>
					<td class="leftAligned" style=" width: 280px;">
						<div style=" width: 60px; height: 21px; float: left;">
							<input style="width: 50px;  float: left;" id="repaceDetitemNo"  type="text" value="" readOnly="readonly" />  
						</div>
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 41px;"">Type:</label>
						<div style="width: 162px; float: left;"  >
							<select class="required" id="partType" name="partType" style="width: 162px;"> 
								<option value="O" selected="selected">Original</option>
								<option value="S">Surplus</option>
								<option value="R">Replacement</option>
								<option></option>
							</select>
						</div>
					</td>
					<td class="rightAligned" >Parts:</td>
					<td class="leftAligned">
						<div style="width: 250px; float: left;" class="withIconDiv required">
							<input type="hidden" id="lossExpCd" name="lossExpCd"/>
							<input type="text" id="dspPartDesc" name="dspPartDesc" value="" style="width: 200px;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspPartDescIcon"  alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Company Type:</td>  
					<td class="leftAligned">
						<div style="width: 267px; float: left;" class="withIconDiv required">
							<input type="hidden" id="payeeTypeCd" name="payeeTypeCd"/>
							<input type="text" id="dspCompanyType" name="dspCompanyType" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyTypeIcon"  alt="Go" />
						</div>
					</td>
					<td class="rightAligned" >Company:</td>  
					<td class="leftAligned">
						<div style="width: 250px; float: left;" class="withIconDiv required">
							<input id="payeeCd" name="payeeCd"  type="hidden"/>
							<input type="text" id="dspCompany" name="dspCompany" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspCompanyIcon"  alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Neg Amt:</td>
					<td class="leftAligned" style=" width: 280px;">
						<div style="width: 130px; height: 21px; float: left;">
							<input style="width: 120px;  float: left;" id="baseAmt" name="baseAmt" type="text" value="" min="1" max="9999999999999.90" class="money2 required" errorMsg="Field must be of form 9,999,999,999,999.90."/>  
						</div>
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 80px;">No. Of Units:</label>
						<div style="width: 53px; height: 21px; float: left;">
							<input style="width: 47px; float: left;" id="noOfUnits" name="noOfUnits" type="text" value=""  class="integerNoNegativeUnformatted required" errorMsg="Legal characters are 0-9 - + E."/>  
						</div>
					</td>
					<td class="rightAligned" >Part Amt:</td>
					
					<td class="leftAligned" style=" width: 280px;">
						<div style="width: 130px; height: 21px; float: left;">
							<input style="width: 120px;  float: left;" id="partAmt" name="partAmt" type="text" value=""  class="money required" readonly="readonly"/>  
						</div>
						<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 80px;">With V.A.T.</label>
						<div style="float: left;">
							<input id="replaceDetWithVat"  name="replaceDetWithVat" type="checkbox" value="" style="width:16px; height:20px;" title="Exclusive of Vat">
						</div>
					</td>
					
				</tr>
			</table>
			<!-- extra hidden fields -->
			<input id="updateSw" name="updateSw" type="hidden"/>
			<input id="partOrigAmt" name="partOrigAmt" type="hidden"/>
			<input id="origPayeeTypeCd" name="origPayeeTypeCd" type="hidden"/>
			<input id="origPayeeCd" name="origPayeeCd" type="hidden"/>
			<input id="revisedSw" name="revisedSw" type="hidden" /> 
			<input id="replacedMasterId" name="replacedMasterId" type="hidden" />
			<input id="replaceId" name="replaceId" type="hidden" />
			<input id="totalPartAmt" name="totalPartAmt" type="hidden" />
			<input id="paytPayeeCd"  name="paytPayeeCd" type="hidden" />
			<input id="paytPayeeTypeCd"  name="paytPayeeTypeCd" type="hidden" />
			
			<input id="existingPaytPayeeTypeCd" type="hidden">
			<input id="existingPaytPayeeCd" type="hidden">	
			<input id="updateOldEvalVat"  name="updateOldEvalVat" type="hidden" />
			<input id="updateDeductibles" name="updateDeductibles" type="hidden"> 
			<input id="deleteOldDepreciation" name="deleteOldDepreciation" type="hidden">
			
			<input id="oldLossExpCd" name="oldLossExpCd" type="hidden"/> 
			<input id="deleteOldDepreciationValidate" name="deleteOldDepreciationValidate" type="hidden">
			
			<input id="varPaytPayeeTypeCd" name=varPaytPayeeTypeCd type="hidden"/> 
			<input id="varPaytPayeeCd" name="varPaytPayeeCd" type="hidden"/> 
			<input id="varPayeeTypeCd" name="varPayeeTypeCd" type="hidden"/> 
			<input id="varPayeeCd" name="varPayeeCd" type="hidden"/> 
			
			<table style="margin-top: 10px;" align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnAddReplaceDet" value="Add" style="width:100px;"/>
						<input type="button" class="disabledButton" id="btnDeleteReplaceDet" value="Delete" style="width:100px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-bottom:10px; " >
			<div style="text-align:center">
				<input type="button" class="button" id="btnRepairDetails" value="Repair Details" style="width:100px;"/>
				<input type="button" class="button" id="btnChangePaymentPayee" value="Change Payment Payee" style="width:170px;"/>
				<input type="button" class="button" id="btnVAT" value="V.A.T." style="width:100px;"/>
				<input type="button" class="button" id="btnDeductibles" value="Deductibles" style="width:100px;"/>
				<input type="button" class="button" id="btnDepreciation" value="Depreciation" style="width:100px;"/>
				<input type="button" class="button" id="btnMainScreen" value="Main Screen" style="width:100px;" title="back to main"/>
			</div>
		</div>
	</form>	
</div>
<input type="hidden" value="" id="lovTrigger" />
<script type="text/javascript">
	changeTag = 0;
	selectedReplaceDetObj= {};
	var origPartType;
	var tempReplaceObj = {};
	
	var totalParts = parseFloat(nvl(unformatNumber(selectedMcEvalObj.replaceAmt),"0"));
	$("totalParts").value = formatCurrency(selectedMcEvalObj.replaceAmt);
	
	function populateTempReplaceObj(){
		try{
			tempReplaceObj.lossExpCd = $F("lossExpCd");
			tempReplaceObj.partType =$F("partType");
			tempReplaceObj.payeeTypeCd =$F("payeeTypeCd");
			tempReplaceObj.dspPartDesc = $F("dspPartDesc");
			tempReplaceObj.payeeCd = $F("payeeCd");
			tempReplaceObj.dspCompanyType = $F("dspCompanyType");
			tempReplaceObj.baseAmt = unformatNumber($F("baseAmt"));
			tempReplaceObj.partAmt = unformatNumber($F("partAmt"));
			tempReplaceObj.withVat = $("replaceDetWithVat").checked == true ? "Y": "N";
			tempReplaceObj.partAmt = unformatNumber($F("partAmt"));
			tempReplaceObj.revisedSw = $F("revisedSw");
			tempReplaceObj.totalPartAmt = $F("totalPartAmt");
			tempReplaceObj.origPayeeTypeCd = $F("origPayeeTypeCd");
			tempReplaceObj.origPayeeCd = $F("origPayeeCd");
			tempReplaceObj.partAmt = unformatNumber($F("partOrigAmt"));
			tempReplaceObj.paytPayeeTypeCd = $F("paytPayeeTypeCd");
			tempReplaceObj.paytPayeeCd = $F("paytPayeeCd");
			tempReplaceObj.dspCompanyType = $F("dspCompanyType");
			tempReplaceObj.dspCompany = $F("dspCompany");
			
		}catch(e){
			showErrorMessage("populateTempReplaceObj",e);
		}
	}
	
	function undoChanges(){
		try{
			$("partType").value =tempReplaceObj.partType;
			$("lossExpCd").value = tempReplaceObj.lossExpCd;
			$("dspPartDesc").value = tempReplaceObj.dspPartDesc;
			$("payeeTypeCd").value = tempReplaceObj.payeeTypeCd;
			$("dspCompanyType").value = tempReplaceObj.dspCompanyType;
			
			$("payeeCd").value = tempReplaceObj.payeeCd;
			$("dspCompany").value = tempReplaceObj.dspCompany;
			$("baseAmt").value = formatCurrency(tempReplaceObj.baseAmt);
			$("noOfUnits").value = tempReplaceObj.noOfUnits;
			$("partAmt").value = formatCurrency(tempReplaceObj.partAmt);
			if(tempReplaceObj.withVat == "Y"){
				$("replaceDetWithVat").setAttribute("title","Inclusive Of Vat");
				$("replaceDetWithVat").checked = true;
			}else{
				$("replaceDetWithVat").setAttribute("title","Exclusive Of Vat");
				$("replaceDetWithVat").checked = false;
			}	
			
			$("partOrigAmt").value =tempReplaceObj.partOrigAmt;
			$("origPayeeTypeCd").value = tempReplaceObj.origPayeeTypeCd;
			$("origPayeeCd").value = tempReplaceObj.origPayeeCd;
			$("revisedSw").value = tempReplaceObj.revisedSw;
			$("paytPayeeTypeCd").value = tempReplaceObj.paytPayeeTypeCd;
			$("paytPayeeCd").value = tempReplaceObj.paytPayeeCd;
		}catch(e){
			
		}
	}
	
	/**company type functions*/
	function validateCompanyType(){
		try{
			if(nvl($F("updateSw"),'X' )!= 'N'){
				$("updateSw").value = "N";
			}
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "companyType"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("payeeTypeCd").value ="";
								$("dspCompanyType").value = "";
							});
						}else{
							changeTag = 1;
							var res = response.responseText.toQueryParams();
							if(res.updateSw != ""){	
								$("updateSw").value = res.updateSw;	
							}
							
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" &&tempReplaceObj.payeeTypeCd != $F("payeeTypeCd")){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciationValidate").value = "Y";
										contValidateCompanyType();
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciationValidate").value = "";
										undoChanges();
									}
								);
							}else{
								contValidateCompanyType();
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateCompanyType",e);
		}
	}
	var tempCompanyType = "";
	function contValidateCompanyType(){
		try{
			if($F("payeeTypeCd") == ""){
				$("dspCompany").value = "";
				$("payeeCd").value = "";
			}
		
			if(variablesObj.assdClassCd ==  $F("payeeTypeCd")){
				new Ajax.Request( contextPath + "/GICLReplaceController?action=getPayeeDetailsMap",{
					method: "GET",
					parameters: {
						claimId : selectedMcEvalObj.claimId,
						payeeTypeCd :$F("payeeTypeCd")
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						var payeeDetObj = response.responseText.toQueryParams();
						$("payeeCd").value = payeeDetObj.payeeCd;
						$("dspCompany").value = unescapeHTML2(payeeDetObj.dspCompany);
					}
				});
			}
			if($F("dspCompanyType")!= "" && $F("dspCompanyType") != tempCompanyType){
				$("dspCompany").value ="" ;
			}
			
			if(replaceGrid.rows.length == 1){
				tempCompanyType = $F("dspCompanyType") ;
			}
	
		}catch(e){
			showErrorMessage("contValidateCompanyType",e);
		}
	}
	function getMcEvalCompanyTypeListLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getMcEvalCompanyTypeListLOV",
								page : 1},
				title: "Company Type",
				width: 380,
				height: 400,
				columnModel : [
								{
									id : "classDesc",
									title: "Parts",
									width: '350px'
								},
								{
									id : "payeeClassCd",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("payeeTypeCd").value = row.payeeClassCd;
					$("dspCompanyType").value = unescapeHTML2(row.classDesc);
					
					$("dspCompany").value ="";
					validateCompanyType();
				}
			});	
		}catch(e){
			showErrorMessage("getMcEvalCompanyTypeListLOV",e);
		}
	}
	
	/**end of company type functions*/
	function checkReplaceDetIsExisting(){
		try{
			//var addRows = replaceGrid.getNewRowsAdded();
			//var modRows = replaceGrid.getModifiedRows();
			
			var lossExpCd = nvl($F("lossExpCd"),"");
			var partType = nvl($F("partType"),"");
			var payeeTypeCd = nvl($F("payeeTypeCd"),"");
			var payeeCd = nvl($F("payeeCd"),"");
			var baseAmt = nvl($F("baseAmt"),"");
			
			for ( var i = 0; i < replaceGrid.rows.length; i++) {
				var tempRow = replaceGrid.getRow(i);
				if(tempRow.lossExpCd == lossExpCd && tempRow.partType == partType && tempRow.payeeTypeCd == payeeTypeCd &&
						tempRow.payeeCd == payeeCd && tempRow.baseAmt == baseAmt 		
				){
					return true;
				}
			}
			/*
			// checks the added rows of TG if same details is existing
			for ( var i = 0; i < addRows.length; i++) {
				if(addRow[i].lossExpCd == lossExpCd && addRow[i].partType == partType && addRow[i].payeeTypeCd == payeeTypeCd &&
						addRow[i].payeeCd == payeeCd && addRow[i].baseAmt == baseAmt 		
				){
					return true;
				}
			}
			// checks the modfied rows of TG if same details is existing
			for ( var i = 0; i < modRows.length; i++) {
				if(modRows[i].lossExpCd == lossExpCd && modRows[i].partType == partType && modRows[i].payeeTypeCd == payeeTypeCd &&
						modRows[i].payeeCd == payeeCd && modRows[i].baseAmt == baseAmt 		
				){
					return true;
				}
			}*/
			
			//return false;
		}catch(e){
			showErrorMessage("checkReplaceDetIsExisting",e);
		}
	}
	
	function validatePartType(){
		try{
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "partType"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						changeTag = 1;
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("partType").value = tempReplaceObj.partType;
								tempReplaceObj.partType = "";
							});
						}else{
							if(res.updateSw != ""){	
								$("updateSw").value = res.updateSw;	
							}
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" ){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciationValidate").value = "Y";
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciation").value = "";
										undoChanges();
									}
								);
							}
						}
						
					}
				}
			});
		}catch(e){
			showErrorMessage("validatePartType",e);
		}
	}
	/**parts functions and lovs*/
	function validatePartDesc(){
		try{
			if(nvl($F("updateSw"),'X' )!= 'N'){
				$("updateSw").value = "N";
			}
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "partDesc"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams();
						changeTag =1;
						//checks if existing
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("lossExpCd").value = "";
								$("dspPartDesc").value = "";
								
								$("dspCompanyType").value = "";
								$("dspCompany").value ="";
							});
						}else{
							
							if(res.updateSw != ""){	
								$("updateSw").value = res.updateSw;	
							}
							
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" &&tempReplaceObj.lossExpCd != $F("lossExpCd")){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciation").value = "Y";
										countPrevPartListLOV();	
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciationValidate").value = "";
										undoChanges();
									}
								);
							}else{
								countPrevPartListLOV();	
							}
							
						}
					}
					
				}
			});
		}catch(e){
			showErrorMessage("validatePartType",e);
		}
	}
	function getReplacePartsListLOV(evalId,partType){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getReplacePartsListLOV",
								evalId : evalId,
								partType: partType,
								//notIn: notIn,
								page : 1},
				title: "Parts",
				width: 390,
				height: 400,
				columnModel : [
								{
									id : "lossExpDesc",
									title: "Parts",
									width: '350px'
								},
								{
									id : "lossExpCd",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("lossExpCd").value = row.lossExpCd;
					$("dspPartDesc").value = unescapeHTML2(row.lossExpDesc);
					
					$("dspCompanyType").value = "";
					$("dspCompany").value ="";
					changeTag =1;
					validatePartDesc();
					
				}
			});	
		}catch(e){
			showErrorMessage("getReplacePartsListLOV",e);
		}
	}
	function getPrevPartListLOV(){ // part of show_replace program_unit in gicls070
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getPrevPartListLOV",
								lossExpCd : $F("lossExpCd"),
								partType : $F("partType"),
								tpSw : selectedMcEvalObj.tpSw,
								claimId: selectedMcEvalObj.claimId,
								itemNo: selectedMcEvalObj.itemNo,
								payeeClassCd: nvl(selectedMcEvalObj.payeeClassCd,""),
								payeeNo : nvl(selectedMcEvalObj.payeeNo ,"" ),
								page : 1},
				title: "Latest Evaluation Report",
				querySort: false,
				width: 700,
				height: 400,
				columnModel : [
								{
									id : "dspPartTypeDesc",
									title: "Part Type",
									width: '100px',
									sortable: false
								},{
									id : "dspCompanyType",
									title: "Company Type",
									width: '150px',
									sortable: false
								},{
									id : "dspCompany",
									title: "Company",
									width: '200px',
									sortable: false
								},{
									id : "evalDate",
									title: "Evaluation Date",
									width: '100px',
									sortable: false
								},{
									id : "partAmt",
									title: "Amount",
									align: 'right',
									geniisysClass : 'money',
									width: '100px',
									sortable: false
								},
								{
									id : "partType",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "payeeCd",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "payeeTypeCd",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("payeeTypeCd").value = row.payeeTypeCd ;
					$("payeeCd").value = row.payeeCd ;
					$("dspCompanyType").value = unescapeHTML2(row.dspCompanyType) ;
					$("dspCompany").value = unescapeHTML2(row.dspCompany) ;
					$("baseAmt").value = formatCurrency(row.partAmt) ;
					$("partType").value = row.partType;
					if(checkCompanyIfExisting($F("payeeTypeCd"),$F("payeeCd"))){
						showConfirmBox("Existing Company","There's an existing record for this company that has a different payee, Would you like to apply the payee to this record?",
							"Yes","No",
							function(){
								$("paytPayeeTypeCd").value =$F("existingPaytPayeeTypeCd");
								$("paytPayeeCd").value = $F("existingPaytPayeeCd");
								checkPartIfExistMaster("Y");
							},function(){
								checkPartIfExistMaster("Y");
							}
						);
					}else{
						checkPartIfExistMaster("Y");
					}
				},onCancel: function(){ 
					
					if($F("partType") != "" || $F("lossExpCd") !=""){
						//pag nag cancel, kunin ung record pinaka mababa na part_orig_amt, kasama ang orig_payee_type_cd at orig_payeeCd
						//naka order by part_amt asc 
						$("partOrigAmt").value = tbgLOV.getRow(0).partAmt;
						$("origPayeeTypeCd").value = tbgLOV.getRow(0).payeeTypeCd;
						$("origPayeeCd").value = tbgLOV.getRow(0).payeeCd;
						
						//if the replace records is greater than 1, get the values from the 1st record
						if(replaceGrid.rows.length >= 1){
							$("dspCompanyType").value = unescapeHTML2(replaceGrid.getRow(0).dspCompanyType);
						  	$("dspCompany").value = unescapeHTML2(replaceGrid.getRow(0).dspCompany);
						  	$("payeeTypeCd").value = replaceGrid.getRow(0).payeeTypeCd;
						  	$("payeeCd").value = replaceGrid.getRow(0).payeeCd;
						}
					}
					checkPartIfExistMaster("N");
		  		}
			});	
		}catch(e){
			showErrorMessage("getPrevPartListLOV",e );
		}
	}
	
	function checkPartIfExistMaster(value){
		try{
			if (selectedMcEvalObj.reportType == "AD"){
				new Ajax.Request( contextPath + "/GICLReplaceController?action=checkPartIfExistMaster",{
					method: "GET",
					parameters: {
						lossExpCd : $F("lossExpCd"),
						partType : $F("partType"),
						evalId : selectedMcEvalObj.evalId, 
						evalMasterId: selectedMcEvalObj.evalMasterId,
						payeeCd: $F("payeeCd"),
						payeeTypeCd: $F("payeeTypeCd"),
						varS : value
					},onComplete: function(response){
						if(checkErrorOnResponse(response)){
							var objResult = response.responseText.toQueryParams();
							if(objResult.resultMessage != "0"){
								showConfirmBox("Part Existing","This part already exists in the master and/or other posted additional reports. Do you want to revise it?","Yes","No",function(){
									$("revisedSw").value = "Y";
									if(objResult.resultMessage == "2"){ // show multiple records lov
										getMultiplePartsLOV();
									}else{
										$("replacedMasterId").value = objResult.replacedMasterId;
										copyMasterPart("Y");
									}
								},function(){
									// will only add new record
									$("revisedSw").value = "N";	
								});	
							}else{
								// part is not existing on master or any other posted additional reports
								$("revisedSw").value = "N";
							}
							
						}	
					}
				});				
			}
		}catch(e){
			showErrorMessage("continuePartProcess",e);
		}
	}
	
	function getMultiplePartsLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getMultiplePartsLOV",
								lossExpCd : $F("lossExpCd"),
								partType : $F("partType"),
								evalId : selectedMcEvalObj.evalId, 
								evalMasterId: selectedMcEvalObj.evalMasterId,
								page : 1},
				title: "Revise Existing Parts",
				querySort: false,
				width: 400,
				height: 400,
				columnModel : [
								{
									id : "dspCompanyType",
									title: "Company Type",
									width: '150px',
									sortable: false
								},{
									id : "dspCompany",
									title: "Company",
									width: '200px',
									sortable: false
								},{
									id : "baseAmt",
									title: "Amount",
									align: 'right',
									geniisysClass : 'money',
									width: '100px',
									sortable: false
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
								},
								{
									id : "replaceId",
									title: "",
									width: '0',
									visible: false
								},
								{
									id : "dspPartDesc",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("dspCompanyType").value = unescapeHTML2(row.dspCompanyType);
					$("dspCompany").value = unescapeHTML2(row.dspCompany);
					$("baseAmt").value = formatCurrency(row.baseAmt);
					$("payeeTypeCd").value = row.payeeTypeCd;
					$("payeeCd").value = row.payeeCd;
					$("replacedMasterId").value = row.replaceId;	
					copyMasterPart("N");
				},onCancel: function(){ 
					// will only create a new record
					$("revisedSw").value = "N";
		  		}
			});	
		}catch(e){
			showErrorMessage("getPrevPartListLOV", e);
		}
	}
	
	function copyMasterPart(allDtlFlag){
		try{
			new Ajax.Request( contextPath + "/GICLReplaceController?action=copyMasterPart",{
				method: "GET",
				parameters: {
					allDtlFlag : allDtlFlag,
					replacedMasterId : $F("replacedMasterId")
				},onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var objCopiedMasterDtl = response.responseText.toQueryParams();
						if(allDtlFlag == "Y"){
							$("payeeTypeCd").value = objCopiedMasterDtl.payeeTypeCd ;
							$("payeeCd").value = objCopiedMasterDtl.payeeCd ;
							$("dspCompanyType").value = unescapeHTML2(objCopiedMasterDtl.dspCompanyType) ;
							$("dspCompany").value = unescapeHTML2(objCopiedMasterDtl.dspCompany) ;
							$("baseAmt").value = formatCurrency(objCopiedMasterDtl.baseAmt) ;
							$("noOfUnits").value = objCopiedMasterDtl.noOfUnits ;
							$("partAmt").value = formatCurrency(objCopiedMasterDtl.partAmt) ;	
						}
						$("totalPartAmt").value =  (parseFloat(nvl(unformatNumber($F("baseAmt")),0)) +  (parseFloat (objCopiedMasterDtl.totalPartAmt))) ;
					}
				}
			});
		}catch(e){
			showErrorMessage("copyMasterPart",e);
		}
	}
	function countPrevPartListLOV(){
		try{
			new Ajax.Request( contextPath + "/GICLReplaceController?action=countPrevPartListLOV",{
				method: "GET",
				parameters: {
					lossExpCd : $F("lossExpCd"),
					partType : $F("partType"),
					tpSw : selectedMcEvalObj.tpSw,
					claimId: selectedMcEvalObj.claimId,
					itemNo: selectedMcEvalObj.itemNo,
					payeeClassCd:selectedMcEvalObj.payeeClassCd,
					payeeNo :selectedMcEvalObj.payeeNo
				},onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(parseInt(response.responseText) > 0){
							getPrevPartListLOV();
						}else{
							if($F("partType") != "" || $F("lossExpCd") !=""){
								showWaitingMessageBox("This is the first report.","I",function(){
									//if the replace records is greater than 1, get the values from the 1st record
									if(replaceGrid.rows.length >= 1){
										$("dspCompanyType").value = unescapeHTML2(replaceGrid.getRow(0).dspCompanyType);
									  	$("dspCompany").value = unescapeHTML2(replaceGrid.getRow(0).dspCompany);
									  	$("payeeTypeCd").value = replaceGrid.getRow(0).payeeTypeCd;
									  	$("payeeCd").value = replaceGrid.getRow(0).payeeCd;
									}
									checkPartIfExistMaster("N");
								});
							}else{
								checkPartIfExistMaster("N");
							}
							
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("countPrevPartListLOV",e);
		}
	}
	
	/**end of parts**/
	function populateReplaceDetFields(obj){
		try{
			$("repaceDetitemNo").value = obj == null ? "" : obj.itemNo;
			$("partType").value =obj == null ? "O" : obj.partType;
			$("lossExpCd").value =obj == null ? "" : obj.lossExpCd;
			$("dspPartDesc").value = obj == null ? "" : obj.dspPartDesc;
			$("payeeTypeCd").value = obj == null ? "" : obj.payeeTypeCd;
			$("dspCompanyType").value = obj == null ? "" : obj.dspCompanyType;
			
			$("payeeCd").value = obj == null ? "" : obj.payeeCd;
			$("dspCompany").value = obj == null ? "" : obj.dspCompany;
			$("baseAmt").value = obj == null ? "" : formatCurrency(obj.baseAmt);
			$("noOfUnits").value = obj == null ? "" : obj.noOfUnits;
			$("partAmt").value = obj == null ? "" : formatCurrency(obj.partAmt);
			if(obj!= null){
				if(obj.withVat == "Y"){
					$("replaceDetWithVat").setAttribute("title","Inclusive Of Vat");
					$("replaceDetWithVat").checked = true;
				}else{
					$("replaceDetWithVat").setAttribute("title","Exclusive Of Vat");
					$("replaceDetWithVat").checked = false;
				}	
			}else{
				$("replaceDetWithVat").checked = false;
			}
			$("updateSw").value = obj == null ? "" : obj.updateSw;
			$("partOrigAmt").value = obj == null ? "" : obj.partOrigAmt;
			$("origPayeeTypeCd").value = obj == null ? "" : obj.origPayeeTypeCd;
			$("origPayeeCd").value = obj == null ? "" : obj.origPayeeCd;
			$("revisedSw").value = obj == null ? "" : obj.revisedSw;
			$("replacedMasterId").value = obj == null ? "" : obj.replacedMasterId;
			$("paytPayeeTypeCd").value = obj == null ? "" : obj.paytPayeeTypeCd;
			$("paytPayeeCd").value = obj == null ? "" : obj.paytPayeeCd;
			$("totalPartAmt").value = obj == null ? "" : obj.totalPartAmt;
			$("replaceId").value = obj == null ? "" : obj.replaceId;
			
			
			
		}catch(e){
			showErrorMessage("populateReplaceDetFields",e);
		}
	}
	
	
	/**COMPANY FUNCTIONS*/
	var varPaytPayeeTypeCd;
	var varPaytPayeeCd;
	var varPayeeTypeCd;
	var varPayeeCd;
	function getMortgageeListLOV(claimId, itemNo){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getMortgageeListLOV",
								claimId: claimId,
								itemNo : itemNo,
								page : 1},
				title: "Company Type",
				width: 380,
				height: 400,
				columnModel : [
								{
									id : "dspCompany",
									title: "Parts",
									width: '350px'
								},
								{
									id : "payeeNo",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("payeeCd").value = row.payeeNo;
					$("dspCompany").value = unescapeHTML2(row.dspCompany);
					validateCompanyDesc();
				}
			});	
		}catch(e){
			showErrorMessage("getMortgageeListLOV",e);
		}
	}
	function getCompanyListLOV(claimId, payeeTypeCd){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getCompanyListLOV",
								claimId: claimId,
								payeeTypeCd : payeeTypeCd,
								page : 1},
				title: "Company Type",
				width: 380,
				height: 400,
				columnModel : [
								{
									id : "dspCompany",
									title: "Parts",
									width: '350px'
								},
								{
									id : "payeeNo",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("payeeCd").value = row.payeeNo;
					$("dspCompany").value = unescapeHTML2(row.dspCompany);
					validateCompanyDesc();
				}
			});	
		}catch(e){
			showErrorMessage("getCompanyListLOV",e);
		}
	}
	
	function validateCompanyDesc(){
		try{
			if(nvl($F("updateSw"),'X' )!= 'N'){
				$("updateSw").value = "N";
			}
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "companyDesc"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("payeeCd").value ="";
								$("dspCompany").value ="";
							});
						}else{
							changeTag = 1;
							var res = response.responseText.toQueryParams();
							if(res.updateSw != ""){	
								$("updateSw").value = res.updateSw;	
							}
							
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" &&tempReplaceObj.payeeCd != $F("payeeCd")){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciationValidate").value = "Y";
										preCheckOFcompany();	
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciationValidate").value = "";
										undoChanges();
									}
								);
							}else{
								preCheckOFcompany();
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateCompanyDesc",e);
		}
	}
	
	function preCheckOFcompany(){
		try{
			if(checkCompanyIfExisting($F("payeeTypeCd"),$F("payeeCd"))){
				showConfirmBox("Existing Company","There's an existing record for this company that has a different payee, Would you like to apply the payee to this record?",
					"Yes","No",
					function(){
						$("paytPayeeTypeCd").value =$F("existingPaytPayeeTypeCd");
						$("paytPayeeCd").value = $F("existingPaytPayeeCd");
						contValidateCompany();
					},contValidateCompany
				);
			}else{
				contValidateCompany();
			}
		}catch (e) {
			showErrorMessage("preCheckOFcompany",e);
		}
	}
	var varPaytPayeeTypeCd;
	var varPaytPayeeCd;
	var varPayeeTypeCd;
	var varPayeeCd;
	var varDspCompany;
	//opted to move the validation for vat, deductibles and depreciation on before saving rather than per field
	function contValidateCompany(){ 
		try{
			if($F("paytPayeeTypeCd") != ""){//means company is the payee
				new Ajax.Request( contextPath + "/GICLReplaceController?action=checkVatAndDeductibles",{
					method: "GET",
					parameters: {
						evalId :selectedMcEvalObj.evalId, 
						payeeCd	: $F("payeeCd"),
						payeeTypeCd : 	$F("payeeTypeCd"),
						paytPayeeCd	: $F("paytPayeeCd"),
						paytPayeeTypeCd : $F("paytPayeeTypeCd"),
						payeeCdOld	: varPayeeCd,
						payeeTypeCdOld	: varPayeeTypeCd,
						paytPayeeCdOld: varPaytPayeeCd,
						paytPayeeTypeCdOld : varPaytPayeeTypeCd
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						var res = response.responseText.toQueryParams();
						
						// for vat
						if(res.oldPayeeDed == "1" && res.newPayeeDed == "0"){
							showConfirmBox("V.A.T.","The report to which this detail is under already has TAX/ES. Updating this record will detele the TAX/ES. Do You want to continue?",
								"Yes","No",function(){
									$("updateOldEvalVat").value = "Y";
									$("varPaytPayeeTypeCd").value = varPaytPayeeTypeCd;
									$("varPaytPayeeCd").value = varPaytPayeeCd;
									$("varPayeeTypeCd").value = varPayeeTypeCd;
									$("varPayeeCd").value = varPayeeCd;
									checkDeductibles(res.oldPayeeDed2, res.newPayeeDed2,res.payeeDep);
								},function(){
									$("payeeCd").value = varPayeeCd;
									$("dspCompany").value= varDspCompany;
									$("updateOldEvalVat").value = "";
									checkDeductibles(res.oldPayeeDed2, res.newPayeeDed2,res.payeeDep);
								}		
							);
							
						}
						
						
					}
				});
			}
		}catch(e){
			showErrorMessage("contValidateCompany",e);
		}
	}
	
	function checkDeductibles(oldPayeeDed,newPayeeDed,payeeDep){
		try{
			if(oldPayeeDed == "1" && newPayeeDed =="0"){
				$("updateDeductibles").value = "Y";
			}
			if(oldPayeeDed == "1"){
				showConfirmBox("Deductibles","The report to which this detail is under already has Deductible/s. Updating this record will detele the Decductible/s. Do You want to continue?",
					"Yes","No",
					function(){
						checkDepreciation(payeeDep);
					},function(){
						$("payeeCd").value = varPayeeCd;
						$("dspCompany").value= varDspCompany;
						$("updateDeductibles").value = "";
					}
				);
			}
		}catch(e){
			showErrorMessage("checkDeductibles",e);
		}
	}
	
	function checkDepreciation(payeeDep){
		try{
			if(payeeDep == "1"){
				showConfirmBox("Deprectiation","The report to which this detail is under already has Depreciation/s. Updating this record will detele the Depreciation/s. Do You want to continue?",
						"Yes","No",
						function(){
							$("deleteOldDepreciation").value = "Y";
						},function(){
							$("payeeCd").value = varPayeeCd;
							$("dspCompany").value= varDspCompany;
							$("deleteOldDepreciation").value = "";
						}
					);
			}
		}catch(e){
			showErrorMessage("checkDepreciation",e);
		}
	}
	
	function checkCompanyIfExisting(payeeTypeCd,payeeCd){ // UPDATE_COMPANY_RG in forms;
		try{
			var addRows = replaceGrid.getNewRowsAdded();
			var modRows = replaceGrid.getModifiedRows();
			var existing = false;
			
			for ( var i = 0; i < replaceGrid.rows.length; i++) {
				var tempRow = replaceGrid.getRow(i);
				if(tempRow.payeeTypeCd == payeeTypeCd && tempRow.payeeCd == payeeCd ){
					
					$("existingPaytPayeeCd").value = tempRow.paytPayeeCd;
					$("existingPaytPayeeTypeCd").value = tempRow.paytPayeeTypeCd;
					if(tempRow.withVat == "Y"){
						$("replaceDetWithVat").checked = true;
					}else{
						$("replaceDetWithVat").checked = false;
					}	
					existing =true;
				}
			}
			/*
			for ( var i = 0; i < addRows.length; i++) {
				if(addRow[i].payeeTypeCd == payeeTypeCd && addRow[i].payeeCd == payeeCd ){
					$("existingPaytPayeeCd").value = addRow[i].paytPayeeCd;
					$("existingPaytPayeeTypeCd").value = addRow[i].paytPayeeTypeCd;
					if(addRow[i].withVat == "Y"){
						$("replaceDetWithVat").checked = true;
					}else{
						$("replaceDetWithVat").checked = false;
					}	
					existing =true;
				}
			}
			// checks the modfied rows of TG if same details is existing
			if(!existing){
				for ( var i = 0; i < modRows.length; i++) {
					if(modRows[i].payeeTypeCd == payeeTypeCd && modRows[i].payeeCd == payeeCd){
						$("existingPaytPayeeCd").value = modRows[i].paytPayeeCd;
						$("existingPaytPayeeTypeCd").value = modRows[i].paytPayeeTypeCd;
						if(addRow[i].withVat == "Y"){
							$("replaceDetWithVat").checked = true;
						}else{
							$("replaceDetWithVat").checked = false;
						}	
						existing = true;
					}
				}	
			}*/
			
			return existing;
			
		}catch(e){
			showErrorMessage("checkCompanyIfExisting", e);
		}
	}
	/*END OF COMPANY*/
	
	/**NEG(baseAmt) AMOUNT*/
	function validateBaseAmt(){
		try{
			if(nvl($F("updateSw"),'X' )!= 'N'){
				$("updateSw").value = "N";
			}
			
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "baseAmt"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						//checks if existing
						var res = response.responseText.toQueryParams();
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("totalPartAmt").value ="";
								$("baseAmt").value = "";
							});
						}else{
							if(res.updateSw != ""){	
								$("updateSw").value = res.updateSw;	
							}
							
							function contTemp(){
								if(nvl($F("revisedSw"),"N") =="Y"){
									copyMasterPart("N");
								}else{
									if (nvl($F("noOfUnits"),"0") == "0" ){
										$("noOfUnits").value = "1";
									}
									$("partAmt").value = formatCurrency(nvl((parseFloat($("baseAmt").value.replace(/,/g, "")) * (parseFloat($F("noOfUnits")))),"0"));
									$("totalPartAmt").value = unformatNumber($F("baseAmt"));
								}
								if (nvl($F("noOfUnits"),"0") == "0" ){
									$("noOfUnits").value = "1";
								}
							}
							
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  res.tempReplaceObj =="O" &&tempReplaceObj.baseAmt != $F("baseAmt")){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciationValidate").value = "Y";
										contTemp();
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciationValidate").value = "";
										undoChanges();
									}
								);
							}else{
								contTemp();
							}
							
							
						}
						
					}
				}
			});
			//$("partAmt").value = (parseFloat($("baseAmt").value.replace(/,/g, "")) * parseFloat($F("noOfUnits")));
		}catch(e){
			showErrorMessage("validateBaseAmt",e);
		}
	}
	
	/*end of base amt function*/
	/*no of units functions*/
	function validateNoOfUnits(){
		try{
			if(nvl($F("updateSw"),'X' )!= 'N'){
				$("updateSw").value = "N";
			}
			new Ajax.Request( contextPath + "/GICLReplaceController?action=validateDetField",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					baseAmt	: unformatNumber($F("baseAmt")),
					lossExpCd : 	$F("lossExpCd"),
					noOfUnits	: $F("noOfUnits"),
					partType : $F("partType"),
					payeeCd	: $F("payeeCd"),
					payeeTypeCd	: $F("payeeTypeCd"),
					oldLossExpCd : tempReplaceObj.lossExpCd,
					field: "noOfUnits"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					
					if(checkErrorOnResponse(response)) {
						//checks if existing
						var res = response.responseText.toQueryParams();
						if(checkReplaceDetIsExisting()){
							showWaitingMessageBox("A part with the same details already exists.","I", function(){
								$("noOfUnits").value ="";
								$("dspCompanyType").value = "";
								$("partAmt").value.value = "";
							});
						}else{
							function contTempNo(res2){
								if(res2.updateSw != ""){	
									$("updateSw").value = res2.updateSw;	
								}
								if($F("noOfUnits") == "0"){
									$("noOfUnits").value ="1";
								}
								$("partAmt").value = formatCurrency(nvl((parseFloat($("baseAmt").value.replace(/,/g, "")) * (parseFloat($F("noOfUnits")))),"0"));
							}
							
							if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" &&tempReplaceObj.noOfUnits != $F("noOfUnits")){
								showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
									"Yes","No",
									function (){
										$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
										$("deleteOldDepreciationValidate").value = "Y";
										contTempNo(res);
									},function(){
										$("oldLossExpCd").value = "";
										$("deleteOldDepreciationValidate").value = "";
										undoChanges();
									}
								);
							}else{
								contTempNo(res);	
							}
							
							
						}
					}
					
					
				}
			});
		}catch(e){
			showErrorMessage("validateNoOfUnits",e);
		}
	}
	/**/
	/**with vat functions*/
	
	function validateWithVat(){
		try{
			var res = checkUpdateRepDtl();
			
			if(res.masterReportType == "RD" && res.depExist =="Y" &&  tempReplaceObj.partType =="O" &&tempReplaceObj.withVat != $F("replaceDetWithVat")){
				showConfirmBox("Depreciation","Updating this record will mean removing the depreciation to which it applies. Do you want to continue?",
					"Yes","No",
					function (){
						$("oldLossExpCd").value = tempReplaceObj.lossExpCd;
						$("deleteOldDepreciationValidate").value = "Y";
						checkWithVat();
					},function(){
						$("oldLossExpCd").value = "";
						$("deleteOldDepreciationValidate").value = "";
						undoChanges();
					}
				);
			}else{
				checkWithVat();
			}
		}catch(e){
			showErrorMessage("validateWithVat",e);
		}
	}
	
	function checkWithVat(){
		try{
			new Ajax.Request( contextPath + "/GICLReplaceController?action=getWithVatList",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null)
				},
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var res = response.responseText.split(",");
						var typeTag;
						var withVat = $("replaceDetWithVat").checked == true ? "Y" : "N";
						for ( var i = 0; i < res.length; i++) {
							typeTag = res[i] == "Y" ? "Y" : "N";
							if(selectedMcEvalObj.reportType == "AD"){
								if(withVat =="Y"){
									if(typeTag == "Y"){
										$("replaceDetWithVat").setAttribute("title","Inclusive Of Vat");
										$("replaceDetWithVat").checked = true;
										changeTag= 1;
									}else if(typeTag == "N"){
										$("replaceDetWithVat").setAttribute("title","Exclusive Of Vat");
										$("replaceDetWithVat").checked = false;
										showMessageBox("Parent Replace Details are Exclusive of VAT for the part/s to be tagged as ''With VAT''.","I");
										break;
									}
								}else if(withVat =="N"){
									if(typeTag =="N"){
										$("replaceDetWithVat").setAttribute("title","Exclusive Of Vat");
										$("replaceDetWithVat").checked = false;
										changeTag= 1;
									}else if(typeTag =="Y"){
										$("replaceDetWithVat").setAttribute("title","Inclusive Of Vat");
										$("replaceDetWithVat").checked = true;
										showMessageBox("Parent Replace Details are Inclusive of VAT. Please add VAT details.","I");
										break;
									}
								}
							}else if(selectedMcEvalObj.reportType == "NR"){
								if(withVat == "Y"){
									$("replaceDetWithVat").setAttribute("title","Inclusive Of Vat");
									$("replaceDetWithVat").checked = true;
									changeTag= 1;
								}else if(withVat =="N"){
									$("replaceDetWithVat").setAttribute("title","Exclusive Of Vat");
									$("replaceDetWithVat").checked = false;
									changeTag= 1;
								}
							}
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
					
				}
			});	
			
		}catch(e){
			showErrorMessage("checkWithVat",e);
		}
	}
	/***/
	
	/**save functions*/
	function checkUpdateRepDtl(){
		try{
			var res; 
			new Ajax.Request( contextPath + "/GICLReplaceController?action=checkUpdateRepDtl",{
				method: "POST",
				parameters: {
					evalMasterId : nvl(selectedMcEvalObj.evalMasterId, null),
					evalId :selectedMcEvalObj.evalId, 
					oldLossExpCd : tempReplaceObj.lossExpCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						res = response.responseText.toQueryParams();
					}
				}
			});	
			return res;
		}catch(e){
			showErrorMessage("checkUpdateRepDtl",e);
		}
	}
	function validateAllDetails(){
		try{
			if(checkFields()){
				//function for check final ded
				function finalCheckDed(){
					if(tempReplaceObj.partAmt != unformatNumber($F("partAmt")) || tempReplaceObj.lossExpCd != $("lossExpCd")){
						new Ajax.Request( contextPath + "/GICLReplaceController?action=finalCheckDed",{
							method: "POST",
							parameters: {
								lossExpCd : $F("lossExpCd"),
								evalId :selectedMcEvalObj.evalId
							},
							asynchronous: false,
							evalScripts: true,
							onComplete: function(response){
								if(checkErrorOnResponse(response)) {
									if(response.responseText == "Y"){
										showConfirmBox("Existing Depreciation","The report to which this detail is under already has Depreciation/s. Updating this record will detele the Depreciation/s. Do You want to continue?",
											"Yes", "No",proceedSave, undoChanges	
										);
									}else{
										proceedSave();
									}
								}
							}
						});	
					}else{
						proceedSave();
					}
				}
				
				if(tempReplaceObj.partAmt != unformatNumber($F("partAmt")) || tempReplaceObj.withVat != ($("replaceDetWithVat").checked == true ? "Y" : "N")){
					// checks final vat
					new Ajax.Request( contextPath + "/GICLReplaceController?action=finalCheckVat",{
						method: "POST",
						parameters: {
							paytPayeeTypeCd : $F("paytPayeeTypeCd"),
							paytPayeeCd : $F("paytPayeeCd"),
							payeeTypeCd : $F("payeeTypeCd"),
							payeeCd : $F("payeeCd"),
							evalId :selectedMcEvalObj.evalId
						},
						asynchronous: false,
						evalScripts: true,
						onComplete: function(response){
							if(checkErrorOnResponse(response)) {
								if(response.responseText == "Y"){
									showConfirmBox("Existing V.A.T.","The report to which this detail is under already has Tax/es. Updating this record will detele the Tax/es. Do You want to continue?",
										"Yes", "No",finalCheckDed, undoChanges	
									);
								}else{
									finalCheckDed();
								}
							}
						}
					});	
				}else{
					finalCheckDed();
				}
			}
		}catch(e){
			showErrorMessage("validateAllDetails",e);
		}
	}
	
	function finalCheckDelete(){
		//function for check final ded
		function finalCheckDed(){
			if(tempReplaceObj.partAmt != unformatNumber($F("partAmt")) || tempReplaceObj.lossExpCd != $("lossExpCd")){
				new Ajax.Request( contextPath + "/GICLReplaceController?action=finalCheckDed",{
					method: "POST",
					parameters: {
						lossExpCd : $F("lossExpCd"),
						evalId :selectedMcEvalObj.evalId
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							if(response.responseText == "Y"){
								showConfirmBox("Existing Depreciation","The report to which this detail is under already has Depreciation/s. Updating this record will detele the Depreciation/s. Do You want to continue?",
									"Yes", "No",deleteReplaceDetail, undoChanges	
								);
							}else{
								deleteReplaceDetail();
							}
						}
					}
				});	
			}else{
				deleteReplaceDetail();
			}
		}
		
		if(tempReplaceObj.partAmt != unformatNumber($F("partAmt")) || tempReplaceObj.withVat != ($("replaceDetWithVat").checked == true ? "Y" : "N")){
			// checks final vat
			new Ajax.Request( contextPath + "/GICLReplaceController?action=finalCheckVat",{
				method: "POST",
				parameters: {
					paytPayeeTypeCd : $F("paytPayeeTypeCd"),
					paytPayeeCd : $F("paytPayeeCd"),
					payeeTypeCd : $F("payeeTypeCd"),
					payeeCd : $F("payeeCd"),
					evalId :selectedMcEvalObj.evalId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "Y"){
							showConfirmBox("Existing V.A.T.","The report to which this detail is under already has Tax/es. Updating this record will detele the Tax/es. Do You want to continue?",
								"Yes", "No",finalCheckDed, undoChanges	
							);
						}else{
							finalCheckDed();
						}
					}
				}
			});	
		}else{
			finalCheckDed();
		}
	}
	
	function proceedSave(){
		try{
			var withVat = ($("replaceDetWithVat").checked == true ? "Y" : "N");
			var newRecord = ($("btnAddReplaceDet").value == "Add" ? "Y" : "N");
			
			var partAmt = parseFloat(nvl(unformatNumber($F("partAmt")),"0"));
			
			// total computation
			selectedMcEvalObj.replaceAmt = $("btnAddReplaceDet").value == "Add" ? (totalParts + partAmt): totalParts - ((parseFloat(nvl(unformatNumber(selectedReplaceDetObj.partAmt),"0")))) + partAmt;
			new Ajax.Request(contextPath + "/GICLReplaceController?action=saveReplaceDetail&ajaxModal=1&evalId=" + selectedMcEvalObj.evalId+"&withVat="+withVat+"&newRecord="+newRecord+
				"&reportType="+selectedMcEvalObj.reportType+"&evalMasterId="+nvl(selectedMcEvalObj.evalMasterId,""),{
				method: "POST",
				postBody : Form.serialize("replaceDetailsForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Saving Replace Detail. Please wait...");
				},
				onComplete: function(response){
					hideNotice("");	
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								changeTag = 0;
								hasSaved = "Y";
								genericObjOverlay.close();
								showMcEvalReplaceDetails();
							});
						}else{
							showMessageBox(response.responseText,"E");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("proceedSave",e);
		}
	}
	
	function deleteReplaceDetail(){
		try{
			var partAmt = parseFloat(nvl(unformatNumber($F("partAmt")),"0"));
			selectedMcEvalObj.replaceAmt = (totalParts - partAmt);
			new Ajax.Request(contextPath + "/GICLReplaceController?action=deleteReplaceDetail&ajaxModal=1&evalId=" + selectedMcEvalObj.evalId+
				"&reportType="+selectedMcEvalObj.reportType+"&evalMasterId="+nvl(selectedMcEvalObj.evalMasterId,""),{
				method: "POST",
				postBody : Form.serialize("replaceDetailsForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Deleting Replace Detail. Please wait...");
				},
				onComplete: function(response){
					hideNotice("");	
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								changeTag = 0;
								hasSaved = "Y";
								genericObjOverlay.close();
								showMcEvalReplaceDetails();
							});
						}else{
							showMessageBox(response.responseText,"E");
						}
					}
				}
			});
		
		}catch(e){
			showErrorMessage("deleteReplaceDetail",e);
		}
	}
	/***/
	$("replaceDetWithVat").observe("change", function(){
		populateTempReplaceObj();
		validateWithVat();
	});
	$("noOfUnits").observe("blur",function(){
		populateTempReplaceObj();
		validateNoOfUnits();
	});
	$("baseAmt").observe("blur", function(){
		populateTempReplaceObj();
		validateBaseAmt();
	});
	$("dspPartDescIcon").observe("click", function(){
		//var notIn = createCompletedNotInParam(replaceGrid, "lossExpCd");
		populateTempReplaceObj();
		getReplacePartsListLOV(selectedMcEvalObj.evalId,$F("partType"));	
		
	});	
	
	$("dspCompanyTypeIcon").observe("click", function(){
		if($F("dspPartDesc") == ""){
			showMessageBox("Please Enter a part first.", "I");
		}else{
			populateTempReplaceObj();
			getMcEvalCompanyTypeListLOV();	
		}
		
	});
	
	$("dspCompanyIcon").observe("click",function(){
		if($F("dspPartDesc") == ""){
			showMessageBox("Please Enter a part first.", "I");
		}else if($F("dspCompanyType") == ""){
			showMessageBox("Please enter company type first.", "I");
		}else{
			populateTempReplaceObj();
			varPaytPayeeTypeCd = $F("paytPayeeTypeCd");
			varPaytPayeeCd= $F("paytPayeeCd");
			varPayeeTypeCd = $F("payeeTypeCd");
			varPayeeCd = $F("payeeCd");
			varDspCompany = $F("dspCompany");
			 if($F("payeeTypeCd") == variablesObj.mortgageeClassCd){
				 getMortgageeListLOV(mcMainObj.claimId, mcMainObj.itemNo);
			 }else if($F("payeeTypeCd") != ""){
				 getCompanyListLOV(mcMainObj.claimId, $F("payeeTypeCd"));
			 }
		}
	});
	
	$("btnAddReplaceDet").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");			
		}else{
			validateAllDetails();	
		}
	});
	
	$("btnDeleteReplaceDet").observe("click", finalCheckDelete);
	

	$("partType").observe("click",function(){
		populateTempReplaceObj();
		//origPartType = $F("partType");
	});
	$("partType").observe("change", validatePartType);
	try{
		var objEvalReplace = JSON.parse('${mcEvalReplaceTg}'.replace(/\\/g, '\\\\'));
		
		var replaceTableModel = {
			id: 5,
			url: contextPath+"/GICLReplaceController?action=getMcEvalReplaceListing&refresh=1&evalId="+selectedMcEvalObj.evalId,
			options: {
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						selectedReplaceDetObj = null;
						populateReplaceDetFields(null);
						tempReplaceObj = {};
						$("btnAddReplaceDet").value = "Add";
						disableButton("btnDeleteReplaceDet");
						return true;
					}
				},beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						selectedReplaceDetObj = null;
						populateReplaceDetFields(null);
						tempReplaceObj = {};
						$("btnAddReplaceDet").value = "Add";
						disableButton("btnDeleteReplaceDet");
						return true;
					}
				},
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						selectedReplaceDetObj = replaceGrid.getRow(y);
						populateReplaceDetFields(selectedReplaceDetObj);
						$("btnAddReplaceDet").value = "Update";
						
						if(nvl(variablesObj.giclReplaceAllowupdate ,"Y")== "Y"){
							enableButton("btnDeleteReplaceDet");
						}
						
					}
					replaceGrid.releaseKeys();
				},onRemoveRowFocus : function(){
					selectedReplaceDetObj = null;
					populateReplaceDetFields(null);
					tempReplaceObj = {};
					$("btnAddReplaceDet").value = "Add";
					disableButton("btnDeleteReplaceDet");
			  	},toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function (){
						//getMcEvalCslDtlTGList(null);
					}
				}
			},columnModel : [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'itemNo',
					width: '20',
					title: 'No.',
				  	filterOption: true
				},
				{	
					id: 'dspPartTypeDesc',
					width: '60',
					title: 'Type',
				  	filterOption: true
				},
				{	
					id: 'dspPartDesc',
					width: '100',
					title: 'Parts',
				  	filterOption: true
				},
				{	
					id: 'dspCompanyType',
					width: '120',
					title: 'Company Type',
				  	filterOption: true
				},
				{	
					id: 'dspCompany',
					width: '250',
					title: 'Company',
				  	filterOption: true
				},
				{	
					id: 'baseAmt',
					width: '100',
					title: 'Nego Amt',
					align: 'right',
					titleAlign: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},
				{	
					id: 'noOfUnits',
					width: '40',
					title: 'No. of Units',
				  	filterOption: true,
				  	align: 'right'
				},
				{	
					id: 'partAmt',
					width: '90',
					title: 'Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},
				{	
					id: 'partType',
					width: '0',
				  	visible: false 
				},{   
					id: 'withVat',
					title: 'V',
				    width: '20',
				    editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					tooltipStrCondition: 'Y,N',
					tooltipValue: 'Inclusive of Vat,Exclusive of Vat',
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},{
					id: 'lossExpCd',
					width: '0',
					visible:false
				},{
					id: 'payeeTypeCd',
					width: '0',
					visible:false
				},{
					id: 'updateSw',
					width: '0',
					visible:false
				},{
					id: 'payeeCd',
					width: '0',
					visible:false
				},{
					id: 'partOrigAmt',
					width: '0',
					visible:false
				},{
					id: 'origPayeeTypeCd',
					width: '0',
					visible:false
				},{
					id: 'origPayeeCd',
					width: '0',
					visible:false
				},{
					id: 'revisedSw',
					width: '0',
					visible:false
				},{
					id: 'paytPayeeTypeCd',
					width: '0',
					visible:false
				},{
					id: 'paytPayeeCd',
					width: '0',
					visible:false
				},{
					id: 'totalPartAmt',
					width: '0',
					visible:false
				},{
					id: 'replacedMasterId',
					width: '0',
					visible:false
				},{
					id: 'replaceId',
					width: '0',
					visible:false
				}
				
			],
			rows: objEvalReplace.rows
		};
		
		replaceGrid = new MyTableGrid(replaceTableModel);
		replaceGrid.pager = objEvalReplace;
		replaceGrid.render('replaceTG');
		
	}catch(e){
		showErrorMessage("Replace details TG",e);
	}
	
	function checkFields(){
		try{
			if($F("dspPartDesc") == ""){
				showMessageBox("Please Enter a part first.", "I");
				return false;
			}else if($F("dspCompanyType") == ""){
				showMessageBox("Please Enter a company type first.", "I");
				return false;
			}else if($F("dspCompanyType") == ""){
				showMessageBox("Please Enter a company type first.", "I");
				return false;
			}else if($F("dspCompany") == ""){
				showMessageBox("Please Enter a company first.", "I");
				return false;
			}else if($F("dspCompany") == ""){
				showMessageBox("Please Enter a company first.", "I");
				return false;
			}else if($F("baseAmt") == "" || unformatNumber($F("baseAmt")) == "0"){
				showMessageBox("Nego Amt cannot be 0.", "I");
				return false;
			}else if($F("noOfUnits") == ""){
				showMessageBox("Please Enter a no. of units first.", "I");
				return false;
			}else{
				return true;
			}
		}catch(e){
			showErrorMessage("checkFields",e);
		}
	}
	
	initializeAll();
	initializeAllMoneyFields();
	checkIfReplaceDetIsEditable();
	initializeChangeTagBehavior(validateAllDetails);
	observeCancelForm("btnMainScreen", validateAllDetails, function(){
		genericObjOverlay.close();
		if(hasSaved == "Y"){
			refreshMainMcEvalList();
		}
	});
	
	$("btnRepairDetails").observe("click",function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalRepairDetails();
		}
	});
	
	$("btnChangePaymentPayee").observe("click",function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showReplaceChangePayee();
		}
	});
	
	$("btnVAT").observe("click",function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalVATDetails();
		}
	});
	
	$("btnDeductibles").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalDeductibleDetails();
		}
	});
	
	$("btnDepreciation").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genericObjOverlay.close();
			showMcEvalDepreciationDetails();
		}
	});
/* 	observeReloadForm("reloadForm",function(){
		genericObjOverlay.close();
		showMcEvalReplaceDetails();
	}); */
	
	// bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("replaceDetailsDiv").hide();
		$("btnChangePaymentPayee").hide();
	}
</script>