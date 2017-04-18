<div style=" padding: 5px;">
<!-- 	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Other Labor</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div> -->
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px;" >
		<table align="center">
			<tr>
				<td class="rightAligned" >Company Type:</td>  
				<td class="leftAligned" style=" width: 260px;">
					<div id="dspCompanyTypeOtherDiv" style="width: 247px; float: left;" class="withIconDiv required">
						<input type="hidden" id="payeeTypeCdOther" name="payeeTypeCdOther"/>
						<input type="text" id="dspCompanyTypeOther" name="dspCompanyTypeOther" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
					</div>
				</td>
				<td class="rightAligned" >Company:</td>  
				<td class="leftAligned">
					<div id="dspCompanyOtherDiv" style="width: 260px; float: left;" class="withIconDiv required">
						<input id="payeeCdOther" name="payeeCdOther"  type="hidden"/>
						<input type="text" id="dspCompanyOther" name="dspCompanyOther" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
					</div>
				</td>
			</tr>	
		</table>
	</div>
	<div class="sectionDiv" style="" align="center">
		<div style="padding: 5px; height: 200px; margin-top: 5px; width: 630px;" align="center">
			<div id="repairOtherLaborTgDiv" style="height: 180px; width: 630px;" align="center"></div>
		</div>
		<div style="width: 400px; float: right; margin-right: 103px; margin-top: 5px; margin-bottom: 5px;">
			<input type="text" style="float: right; width: 140px;" id="otherLaborAmtOther"  readonly="readonly" class="rightAligned"/>
			<label style="float: right; margin-top: 5px;" class="money2">Other Labor Amount: </label>
		</div>
	</div>
	<div id="repairOtherLaborDiv" class="sectionDiv"  style="" >
		<table align="center">
			<tr>
				<td class="rightAligned" >Item No:</td>  
				<td class="leftAligned" style=" width: 72px;">
					<div style=" width: 60px; height: 21px; float: left;">
						<input style="width: 60px;  float: left;" id="itemNoOther"  type="text" value="" readOnly="readonly" />  
					</div>
				</td>
				<td class="rightAligned" >Labor Type:</td>  
				<td colspan="3">
					<div style="width: 247px; float: left;" class="withIconDiv required">
						<input type="hidden" id="repairCd" name="repairCd" >
						<input type="text" id="repairDesc" name="repairDesc" value="" style="width: 80%;" class="withIcon required"   readonly="readonly">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="repairDescIcon"  alt="Go" />
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<td class="rightAligned" >Amount:</td>  
					<td class="leftAligned" >
						<input style="width: 120px;  float: left;"   id="amountOther" name="amountOther" type="text" value="" min="1" max="9999999999999.90" class="money2 required" errorMsg="Field must be of form 9,999,999,999,999.90."/>
					</td>
				</td>
			</tr>
		</table>
		
		<table style="margin-top: 5px; margin-bottom: 5px;" align="center">
			<tr>
				<td>
					<input type="button" class="button" id="btnAddLabor" value="Add" style="width:100px;"/>
					<input type="button" class="disabledButton" id="btnDeleteLabor" value="Delete" style="width:100px;"/>
				</td>
			</tr>
		</table>	
	</div>
	<div class="sectionDiv"  style="padding-top: 10px; padding-bottom: 10px;" >
		<div style="text-align:center">
			<input type="button" class="button" id="btnSaveLabor" value="Save" style="width:100px;"/>
			<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;" />
		</div>
	</div>
	<input type="hidden" id="vatExist" />
	<input type="hidden" id="dedExist" />
	<input type="hidden" id="masterReportType" />
</div>

<script type="text/javascript">
	var otherSelectedIndex;
	try{
		$("payeeCdOther").value =  giclRepairObj.payeeCd;
		$("payeeTypeCdOther").value =  giclRepairObj.payeeTypeCd;
		$("dspCompanyTypeOther").value =  unescapeHTML2(giclRepairObj.dspCompanyType);
		$("dspCompanyOther").value =  unescapeHTML2(giclRepairObj.dspCompany);
		$("otherLaborAmtOther").value =  formatCurrency(giclRepairObj.otherLaborAmt);
		if(variablesObj.giclRepairHdrAllowUpdate == "N"){
			disableInputField("amountOther");
			disableSearch("repairDescIcon");
			disableButton("btnSaveLabor");
			disableButton("btnAddLabor");
		}
		
		var objRepairOtherDtl= JSON.parse('${repairOtherDtlTg}'.replace(/\\/g, '\\\\'));
		var objRepairOtherDtlArr = JSON.parse('${repairOtherDtlTg}'.replace(/\\/g, '\\\\')).rows;
		
		var repairOtherLaborTableModel = {
			id: 7,
			url: contextPath+"/GICLRepairHdrController?action=getGiclRepairOtherDtlList&refresh=1&evalId="+nvl(giclRepairObj.evalId,null),
			options: {
				//width: '600px',
				newRowPosition: 'bottom',
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateOtherLaborFields(null);
						return true;
					}
				},beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateOtherLaborFields(null);
						return true;
					}
				},
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						otherSelectedIndex= y;
						populateOtherLaborFields(otherLaborGrid.geniisysRows[y]);
					}						
					otherLaborGrid.keys.releaseKeys();
				},onRemoveRowFocus : function(){
					otherSelectedIndex = null;
					populateOtherLaborFields(null);
					otherLaborGrid.keys.releaseKeys();
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
					id: 'repairDesc',
					width: '420',
					title: 'Labor Type',
				  	filterOption: true
				},{	
					id: 'amount',
					width: '140',
					title: 'Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},{
					id: 'updateSw',
					width: '0',
					visible:false
				},{
					id: 'evalId',
					width: '0',
					visible:false
				},{
					id: 'repairCd',
					width: '0',
					visible:false
				}
			],
			rows: objRepairOtherDtl.rows
		};
		
		otherLaborGrid = new MyTableGrid(repairOtherLaborTableModel);
		otherLaborGrid.pager = objRepairOtherDtl;
		otherLaborGrid.render('repairOtherLaborTgDiv');
	}catch (e) {
		showErrorMessage("repairOtherDtlTg",e);
	}
	
	
	function getRepairTypeLOV(evalId,notIn){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getRepairTypeLOV",
								evalId: evalId,
								notIn: notIn,
								page : 1},
				title: "Vehicle Parts",
				width: 380,
				height: 400,
				columnModel : [
								{
									id : "repairDesc",
									title: "Labor Type",
									width: '350px'
								},
								{
									id : "repairCd",
									title: "",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("repairCd").value = row.repairCd;
					$("repairDesc").value = unescapeHTML2(row.repairDesc);
					changeTag = 1;
					$("repairDesc").setAttribute("changed", "changed");
				}
			});	
		}catch(e){
			showErrorMessage("getRepairTypeLOV",e);
		}
	}
	
	function populateOtherLaborFields(obj){
		try{
			$("itemNoOther").value = obj == null ? "" : obj.itemNo;
			$("repairCd").value = obj == null ? "" : obj.repairCd;
			$("repairDesc").value = obj == null ? "" : unescapeHTML2(obj.repairDesc);
			$("amountOther").value = obj == null ? "" : formatCurrency(obj.amount);
			
			if(variablesObj.giclRepairHdrAllowUpdate == "Y"){
				if(obj == null){
					$("btnAddLabor").value = "Add";
					enableSearch("repairDescIcon");
					disableButton("btnDeleteLabor");
				}else{
					$("btnAddLabor").value = "Update";
					disableSearch("repairDescIcon");
					enableButton("btnDeleteLabor");
				}
			}else{
				disableSearch("repairDescIcon");
			}
		}catch (e) {
			showErrorMessage("populateOtherLaborFields",e);
		}
	}
	function addLaborType(){
		try{
			var laborType = {};
			laborType.repairDesc = escapeHTML2($F("repairDesc"));
			laborType.amount = unformatNumber($F("amountOther"));
			laborType.updateSw = "N";
			laborType.evalId = selectedMcEvalObj.evalId;
			laborType.repairCd = $F("repairCd");
		
			if($F("btnAddLabor") == "Add"){
				laborType.itemNo = "";
				laborType.recordStatus = "0";
				computeOtherLaborAmount("Add");
				otherLaborGrid.addBottomRow(laborType);
				objRepairOtherDtlArr.push(laborType);
			}else{
				laborType.recordStatus = "1";
				laborType.itemNo = $F("itemNoOther");
				computeOtherLaborAmount("Update");
				otherLaborGrid.updateVisibleRowOnly(laborType, otherSelectedIndex);
				addModifiedLaborType(laborType);
			}
			changeTag= 1;
			populateOtherLaborFields(null);
		}catch(e){
			showErrorMessage("addLaborType",e);
		}
	}
	
	function addModifiedLaborType(editedObj){
		for ( var i = 0; i < objRepairOtherDtlArr.length; i++) {
			var laborType = objRepairOtherDtlArr[i];
			if(laborType.repairCd == editedObj.repairCd){
				if(laborType.recordStatus == "0" && editedObj.recordStatus == "-1"){ // removed if just added
					objRepairOtherDtlArr.splice(i,1);
				}else{// if modified
					objRepairOtherDtlArr.splice(i,1,editedObj);
				}
			}
		}
	}
	
	function computeOtherLaborAmount(operation){
		try{
			var otherLaborAmt = parseFloat(nvl(unformatNumber($F("otherLaborAmtOther")),"0"));
			var amount = parseFloat(nvl(unformatNumber($F("amountOther")),"0"));
			var total;
			if(operation == "Add"){
				total = formatCurrency((otherLaborAmt + amount));
			}else if(operation == "Update"){
				var origAmt =  parseFloat(nvl(unformatNumber(otherLaborGrid.geniisysRows[otherSelectedIndex].amount),"0"));
				total = ((otherLaborAmt - origAmt) + amount);
			}else{
				total = formatCurrency((otherLaborAmt - amount));
			}
			$("otherLaborAmtOther").value = formatCurrency(total);
		}catch(e){
			showErrorMessage("computeOtherLaborAmount",e);
		}
	}
	
	function validateBeforeSaveOther(){
		try{
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "validateBeforeSaveOther",
					evalId: selectedMcEvalObj.evalId,
					payeeTypeCd: $F("payeeTypeCdOther"),
					payeeCd : $F("payeeCdOther"),
					evalMasterId: selectedMcEvalObj.evalMasterId,
					dspTotalLabor:giclRepairObj.dspTotalLabor
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText.toQueryParams(); 
						$("vatExist").value = res.vatExist;
						$("dedExist").value = res.dedExist;
						$("masterReportType").value = res.masterReportType;
						if(res.vatExist == "Y"){
							showConfirmBox("Vat Exist","The report to which this detail is under already has Tax/es. Updating this record will detele the Tax/es. Do You want to continue?",
								"Yes","No",saveOtherLabor,null		
							);
						}else if(res.dedExist =="Y"){
							showConfirmBox("Deductible Exist","The report to which this detail is under already has Deductible/s. Updating this record will detele the Deductible/s. Do You want to continue?",
								"Yes","No",saveOtherLabor,null		
							);
						}else{
							showConfirmBox("Save Confirmation","Are you sure you want to save the changes?",
								"Yes","No",saveOtherLabor,null		
							);
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});
		}catch(e){
			showErrorMessage("validateBeforeSaveOther",e);	
		}
	}
	
	function deleteLaborType(){
		computeOtherLaborAmount("delete");
		var laborType = {};
		laborType.repairDesc = escapeHTML2($F("repairDesc"));
		laborType.amount = unformatNumber($F("amountOther"));
		laborType.updateSw = "N";
		laborType.evalId = selectedMcEvalObj.evalId;
		laborType.repairCd = $F("repairCd");
		laborType.itemNo = $F("itemNoOther");
		laborType.recordStatus = "-1";
		
		addModifiedLaborType(laborType);
		otherLaborGrid.deleteVisibleRowOnly(otherSelectedIndex);
		populateOtherLaborFields(null);
		
		changeTag = 1;
	}
	
	function saveOtherLabor(){
		try{
			var objParameters = {};
			objParameters.giclRepairObj = giclRepairObj;
			objParameters.setRows 	= getAddedAndModifiedJSONObjects(objRepairOtherDtlArr);
			objParameters.deletedRows = getDeletedJSONObjects(objRepairOtherDtlArr);
			objParameters.otherLaborAmt = unformatNumber($F("otherLaborAmtOther"));
			objParameters.dedExist = $F("dedExist");
			objParameters.vatExist = $F("vatExist");
			objParameters.masterReportType = $F("masterReportType");
			objParameters.evalMasterId = selectedMcEvalObj.evalMasterId;
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GICLRepairHdrController", {
				parameters:{
					action: "saveOtherLabor",
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
								genericObjOverlay.close();
								otherLaborOverlay.close(); 
								//showRepairOtherLaborDetails();the otherlabor overlay must be closed and the repair overlay reloaded to refresh the giclRepairObj object
								
								showMcEvalRepairDetails();
							});	
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				}		
			});
			
		}catch(e){
			showErrorMessage("saveOtherLabor",e);	
		}
	}
	$("btnDeleteLabor").observe("click",function(){
		deleteLaborType();
	});
	
	$("btnSaveLabor").observe("click",function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}else{
			validateBeforeSaveOther();
		}
	});
	
	$("btnAddLabor").observe("click", function(){
		if($F("repairDesc") == ""){
			showMessageBox("Labor Type is required.", "I");
		}else if($F("amountOther") == ""){
			showMessageBox("Amount is required.", "I");
		}else{
			addLaborType();
		}
	});
	
	$("repairDescIcon").observe("click",function(){
		var notIn = createCompletedNotInParam(repairGrid, "repairCd");
		getRepairTypeLOV(selectedMcEvalObj.evalId,notIn);
	});
	
/* 	observeReloadForm("reloadForm",function(){
		otherLaborOverlay.close();
		showRepairOtherLaborDetails();
	}); */
	
	observeCancelForm("btnReturn", null, function(){
		otherLaborOverlay.close();
		if(hasSaved == "Y"){
			genericObjOverlay.close();
			showMcEvalRepairDetails();
			hasSaved = "";
		}
	});
	
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeChangeTagBehavior(validateBeforeSaveOther);
	
	// bonok :: 11.08.2013
	if(objCLMGlobal.callingForm == "GICLS260"){
		$("dspCompanyTypeOtherDiv").removeClassName("required");
		$("dspCompanyTypeOther").removeClassName("required");
		$("dspCompanyOtherDiv").removeClassName("required");
		$("dspCompanyOther").removeClassName("required");
		$("repairOtherLaborDiv").hide();
		$("btnSaveLabor").hide();
	}
</script>