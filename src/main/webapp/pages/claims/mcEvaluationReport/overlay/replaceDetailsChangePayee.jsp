<div style=" padding: 10px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Change Payment Payee</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="margin-top: 10px;" align="center">
		<div style="padding: 10px;  height: 255px; margin-top: 10px; width: 500px;" align="center">
			<div id="replacePayeeTgDiv" style="height: 240px; width: 500px;" align="center"></div>
		</div>
		<table align="center">
			<tr>
				<td class="rightAligned" >Change Payee To:</td>  
				<td >
					<div style="width: 120px; float: left;" class="withIconDiv ">
						<input type="hidden" id="paytPayeeTypeCdMan" />
						<input type="text" id="paytPayeeTypeManual" name="paytPayeeTypeManual" value="" style="width: 70%;" class="withIcon"   readonly="readonly">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="paytPayeeTypeManualIcon"  alt="Go" />
					</div>
					<div style="width: 230px; float: left;" class="withIconDiv ">
						<input type="hidden" id="paytPayeeCdMan" />
						<input type="text" id="paytPayeeManual" name="paytPayeeManual" value="" style="width: 80%;" class="withIcon"   readonly="readonly">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspLossDescIcon"  alt="Go" />
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2"  align="center">
					<input type="button" class="button" id="btnClear" value="Clear Payee" style="width:100px; margin-top: 10px;" />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnApply" value="Apply" style="width:100px;"/>
			<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;" />
		</div>
	</div>
</div>	

<script>
	var replacePayeeIndex;
	var itemProperty = '';
	try{
		var objReplacePayeeTg= JSON.parse('${mcReplacePayeeTg}'.replace(/\\/g, '\\\\'));
	//	var objRepairOtherDtlArr = JSON.parse('${repairOtherDtlTg}'.replace(/\\/g, '\\\\')).rows;
	
		var replacePayeeTableModel = {
			id: 11,
			url: contextPath+"/GICLReplaceController?action=getReplacePayeeListing&refresh=1&evalId="+nvl(selectedMcEvalObj.evalId,null),
			options: {
				//width: '600px',
				newRowPosition: 'bottom',
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						//populateRepairLpsDtlFields(null);
						return true;
					}
				},beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						//populateRepairLpsDtlFields(null);
						return true;
					}
				},
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						//otherSelectedIndex= y;
					}						
					replacePayeeGrid.keys.releaseKeys();
				},onRemoveRowFocus : function(){
					//replacePayeeIndex = null;
					replacePayeeGrid.keys.releaseKeys();
			  	},toolbar: {
					elements: [/* MyTableGrid.FILTER_BTN */, MyTableGrid.REFRESH_BTN],// removed filter for now
					onRefresh: function (){
						/*populateRepairLpsDtlFields(null);
						changeTag == 0;
						repairGrid.releaseKeys();*/
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
				},{   
					id: 'paytImpTag',
				    width: '20',
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editable: true,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
				{	
					id: 'dspCompany',
					width: '310',
					title: 'Company',
				  	filterOption: true
				},{	
					id: 'paytPartAmt',
					width: '140',
					title: 'Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				}
			],
			rows: objReplacePayeeTg.rows
		};
		
		replacePayeeGrid = new MyTableGrid(replacePayeeTableModel);
		replacePayeeGrid.pager = objReplacePayeeTg;
		replacePayeeGrid.render('replacePayeeTgDiv');
	}catch (e) {
		showErrorMessage("replacePayeeTG",e);
	}
	
	function getChangePayeeCompanyTypeListLOV(){
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
					$("paytPayeeTypeCdMan").value = row.payeeClassCd;
					$("paytPayeeTypeManual").value = unescapeHTML2(row.classDesc);
					$("paytPayeeCdMan").value = "";
					$("paytPayeeManual").value = "";
					if(row.payeeClassCd == variablesObj.mortgageeClassCd){
						itemProperty = 'M';
					}else if(row.payeeClassCd == variablesObj.assdClassCd){
						$("paytPayeeCdMan").value = mcMainObj.assdNo;
						var payeeFullName = getPayeeFullName(row.payeeClassCd, $F("paytPayeeCdMan"));
						$("paytPayeeManual").value = unescapeHTML2(payeeFullName);
					}else{
						itemProperty='';
					}
					
					
				}
			});	
		}catch(e){
			showErrorMessage("getMcEvalCompanyTypeListLOV2",e);
		}
	}
	
	function getChangeMortgageeListLOV(claimId, itemNo){
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
					$("paytPayeeCdMan").value = row.payeeNo;
					$("paytPayeeManual").value = unescapeHTML2(row.dspCompany);
				}
			});	
		}catch(e){
			showErrorMessage("getChangeMortgageeListLOV",e);
		}
	}
	
	function getChangeCompanyListLOV(claimId, payeeTypeCd){
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
					$("paytPayeeCdMan").value = row.payeeNo;
					$("paytPayeeManual").value = unescapeHTML2(row.dspCompany);
				}
			});	
		}catch(e){
			showErrorMessage("getChangeCompanyListLOV",e);
		}
	}
	
	function countSelected(){
		var ctr = 0;
		for ( var i = 0; i < replacePayeeGrid.rows.length; i++) {
			if($("mtgInput11_2,"+i).checked){
				ctr++;
			}
		}
		return ctr;
	}
	
	function applyChangePayee(){
		try{
			var objParameters = {};
			objParameters.setRows 	= replacePayeeGrid.geniisysRows;
			objParameters.evalId 	= selectedMcEvalObj.evalId;
			objParameters.paytPayeeCdMan = $F("paytPayeeCdMan");
			objParameters.paytPayeeTypeCdMan = $F("paytPayeeTypeCdMan");
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GICLReplaceController", {
				parameters:{
					action: "applyChangePayee",
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
								changePayeeOverlay.close(); 
								
								showMcEvalReplaceDetails();
							});	
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				}		
			});
		}catch(e){
			showErrorMessage("applyChangePayee",e);
		}
	}
	
	$("btnApply").observe("click",function(){
		if(countSelected() == 0){
			showMessageBox("No changes to apply.", "");
		}else{
			applyChangePayee();
		}
	});
	
	$("paytPayeeTypeManualIcon").observe("click",function(){
		getChangePayeeCompanyTypeListLOV();
	});
	
	$("dspLossDescIcon").observe("click",function(){
		if($F("paytPayeeTypeManual") == ""){
			showMessageBox("Please choose company type first.", "I");
		}else{
			if(itemProperty == "M"){
				getChangeMortgageeListLOV(mcMainObj.claimId, mcMainObj.itemNo);
			}else{
				getChangeCompanyListLOV(mcMainObj.claimId, $F("paytPayeeTypeCdMan"));
			}
		}
	});
	
	$("btnClear").observe("click", function(){
		$("paytPayeeTypeCdMan").value = "";
		$("paytPayeeTypeManual").value = "";
		$("paytPayeeCdMan").value = "";
		$("paytPayeeManual").value = "";
	});

	observeReloadForm("reloadForm",function(){
		changePayeeOverlay.close();
		showReplaceChangePayee();
	});
	
	observeCancelForm("btnReturn", null, function(){
		changePayeeOverlay.close();
		if(hasSaved == "Y"){
			genericObjOverlay.close();
			showMcEvalReplaceDetails();
		}
	});
	if(variablesObj.giclReplaceAllowupdate == "N"){
		disableButton("btnClear");
		disableButton("btnApply");
	}
</script>