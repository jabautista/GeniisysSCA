<div id="claimAdviceListingMainDiv" class="sectionDiv" style="height: 300px;">
	<div id="claimAdviceTableGridDiv" style="padding: 5px; margin-left: 15px; margin-top: 5px;">
		<div id="claimAdviceTableGrid" style="height: 240px; width: 450px;"></div>
	</div>
</div>
<div class="buttonsDiv" style="margin-bottom: 0;">
	<input type="button" id="btnSaveAdvice" 		name="btnSaveAdvice" 		class="button" value="Ok" style="margin-left: 1px;" />
	<input type="button" id="btnExitAdvice" 		name="btnExitAdvice"" 		class="button" value="Cancel" style="margin-left: 8px;" />
</div>

<script>
	var selectedAdvice = null;
	var addedAdvice = [];
	
	$("btnSaveAdvice").observe("click", function() {
		new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
			method: "GET",
			parameters: {
				action: "getDCPDetailsFromAdvice",
				addedAdvice: prepareJsonAsParameter(addedAdvice)
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					var gdcp = eval(response.responseText);
					for(var i=0; i<gdcp.length; i++) {
						var exists = false;
						var newDCP = gdcp[i];
						for(var j=0; j<objDCPArr.length; j++) {
							var currDCP = objDCPArr[i];
							if(currDCP.transactionType == newDCP.transactionType &&
								currDCP.claimId == newDCP.claimId && 
								currDCP.claimLossId == newDCP.claimLossId) {
								if(currDCP.recordStatus == "-1") {
									objDCPArr.splice(i, 1);
								} else {
									exists = true;
								}
							} 
						}
						if(!exists) {
							newDCP.orPrintTag = "N";
							newDCP.recordStatus = "0";
							gdcpGrid.addBottomRow(newDCP);
							objDCPArr.push(newDCP);
							changeTag = 1;
							disableButton("btnClaimAdvice");//added by reymon 04262013
							disableButton("btnBatchClaim");//added by reymon 04262013
							
							var netDisbAmt = parseFloat(newDCP.netDisbursementAmount==null ? "0" : newDCP.netDisbursementAmount);
							$("sumDspNetAmt").value = formatCurrency(unformatCurrency("sumDspNetAmt")+netDisbAmt);
						}
						populateGDCPFields(null);
					}
				}
				adviceOverlay.close();
			}
		});
	});
	
	/* commented and changed by reymon 04262013
	observeCancelForm("btnExitAdvice", null, function() {
		adviceOverlay.close();
	});
	*/
	
	$("btnExitAdvice").observe("click", function() {
		adviceOverlay.close();
	});
	
	function includeAdviceForAdd(obj) {
		var exists = false;
		for(var i=0; i<addedAdvice.length; i++) {
			if(obj.linecd == addedAdvice[i].linecd &&
				obj.issCd == addedAdvice[i].issCd &&
				obj.adviceYear == addedAdvice[i].adviceYear &&
				obj.adviceSeqNo == addedAdvice[i].adviceSeqNo &&
				obj.clmLossId == addedAdvice[i].clmLossId) {
				exists = true;
			}
		}
		if(!exists) {
			obj.transactionType = $F("selTransactionType");
			obj.gaccTranId = objACGlobal.gaccTranId;
			obj.riIssCd = $F("varIssCd");
			addedAdvice.push(obj);
		}
	}
	
	function removeAdvice(obj) {
		for(var i=0; i<addedAdvice.length; i++) {
			if(obj.linecd == addedAdvice[i].linecd &&
				obj.issCd == addedAdvice[i].issCd &&
				obj.adviceYear == addedAdvice[i].adviceYear &&
				obj.adviceSeqNo == addedAdvice[i].adviceSeqNo) {
				addedAdvice.splice(i,1);
			}
		}
	}

	//created by reymon 04252013
	function getAdviceLossId(tableGrid, swtch){
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		var exist = new Array();
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				if (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')],null) != null
						&& 	exist.indexOf(tableGrid.rows[i].adviceId)){
					if (swtch == 0){
						notIn = notIn + "OR (x.advice_id = " + (tableGrid.rows[i].adviceId
								+" AND y.clm_loss_id NOT IN (");
					}else if(swtch == 1){
						notIn = notIn + "OR (advice_id = " + (tableGrid.rows[i].adviceId
								+" AND clm_loss_id NOT IN (");
					}
					exist.push(tableGrid.rows[i].adviceId);
					for (var x=0; x<tableGrid.rows.length; x++){
						if (arr.indexOf(tableGrid.rows[x][tableGrid.getColumnIndex('divCtrId')]) == -1){
							if (nvl(tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')],null) != null
								&& nvl(tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')],null) == nvl(tableGrid.rows[x][tableGrid.getColumnIndex('adviceId')],null)){
								notIn = notIn + (tableGrid.rows[x].claimLossId +", ");
							}
						}
					}
					notIn = notIn.substr(0, notIn.length-2) + ")) ";
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				if (nvl(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('adviceId')],null) != null
						&& exist.indexOf(tableGrid.rows[i].adviceId)){
					if (swtch == 0){
						notIn = notIn + "OR (x.advice_id = " + (tableGrid.rows[i].adviceId
								+" AND y.clm_loss_id NOT IN (");
					}else if(swtch == 1){
						notIn = notIn + "OR (advice_id = " + (tableGrid.rows[i].adviceId
								+" AND clm_loss_id NOT IN (");
					}
					for (var x=0; x<tableGrid.newRowsAdded.length; x++){
						if (tableGrid.newRowsAdded[x] != null){
							if (nvl(tableGrid.newRowsAdded[x][tableGrid.getColumnIndex('adviceId')],null) != null
									&& nvl(tableGrid.newRowsAdded[x][tableGrid.getColumnIndex('adviceId')],null) == nvl(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('adviceId')],null)){
								notIn = notIn + (tableGrid.rows[x].claimLossId +", ");
							}
						}
					}
					notIn = notIn.substr(0, notIn.length-2) + ")) ";
				}
			}
		}
		return notIn.length>0 ? notIn.substr(3) :notIn;
	}
	
	try {
		var objAdvice = JSON.parse('${claimAdviceTG}');
		var notIn = gdcpGrid.createNotInParam("adviceId");//added by reymon 04262013
		var notIn2 = getAdviceLossId(gdcpGrid, 1);//added by reymon 04262013
		
		var adviceTable = {
				url: contextPath+"/GIACDirectClaimPaymentController?action=showClaimAdviceModal&refresh=1&lineCd="+
						$F("txtLineCd")+"&issCd="+$F("txtIssCd")+"&adviceYear="+$F("txtAdviceYear")+"&adviceSeqNo="+$F("txtAdvSeqNo")+
						"&riIssCd="+$F("varIssCd")+"&tranType="+$F("selTransactionType")+"&notIn="+notIn+"&notIn2="+notIn2,//added notIn and notIn2 reymon 02262013
				options: {
					title: '',
					height: '240',
					width: '460',
					onCellFocus: function(element, value, x, y, id) {
						selectedAdvice = adviceGrid.geniisysRows[y];
					},
					onRemoveRowFocus: function() {
						selectedAdvice = null;
					}
				},
				columnModel: [
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
						id: 'addTag',
						title: '',
						width: '20px',
						titleAlign: 'left',
						editable: true,
						editor: new MyTableGrid.CellCheckbox({
				            getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
			            		if(value == "Y") {
			            			includeAdviceForAdd(selectedAdvice);
			            		} else {
			            			removeAdvice(selectedAdvice);
			            		}
			            	}
			            })
					},
					{
						id: 'dspAdviceNo',
						title: 'Advice Number',
						width: '110px',
						titleAlign: 'left',
						editable: false
					},
					{
						id: 'dspPayee',
						title: 'Payee',
						width: '160px',
						titleAlign: 'left',
						editable: false
					},
					{
						id: 'paidAmt',
						title: 'Net Disbursement',
						width: '110px',
						geniisysClass : 'money',
						titleAlign: 'right',
						align: 'right',
						editable: false
					},
					{
						id: 'issCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'adviceYear',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'linecd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'adviceSeqNo',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'dspPType',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'payeeClassCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'perilSname',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'netAmt',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'netDisbAmt',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'payeeCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'claimId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'clmLossId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'payeeType',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					}
				],
				rows: objAdvice.rows
		};
		
		adviceGrid = new MyTableGrid(adviceTable);
		adviceGrid.pager = objAdvice;
		adviceGrid.render('claimAdviceTableGrid');
		
	} catch(e) {
		showErrorMessage("prepareAdviceTG", e);
	}

</script>