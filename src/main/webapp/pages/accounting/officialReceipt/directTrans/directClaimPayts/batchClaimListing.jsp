<div id="batchClaimListingMainDiv" class="sectionDiv" style="height: 300px;">
	<div id="batchClaimTableGridDiv" style="padding: 5px; margin-left: 15px; margin-top: 5px;">
		<div id="batchClaimTableGrid" style="height: 240px; width: 450px;"></div>
	</div>
</div>
<div class="buttonsDiv" style="margin-bottom: 0;">
	<input type="button" id="btnSaveBatch" 		name="btnSaveBatch" 		class="button" value="Ok" style="margin-left: 1px;" />
	<input type="button" id="btnExitBatch" 		name="btnExitBatch"" 		class="button" value="Cancel" style="margin-left: 8px;" />
</div>

<script>
	var selectedBatch = null;
	var addedBatch = [];
	
	$("btnSaveBatch").observe("click", function() {
		new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
			method: "GET",
			parameters: {
				action: "getDCPDetailsFromBatch",
				batchClaims: prepareJsonAsParameter(addedBatch)
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
							disableButton("btnDelDCP");//added by reymon 04262013
							
							var netDisbAmt = parseFloat(newDCP.netDisbursementAmount==null ? "0" : newDCP.netDisbursementAmount);
							$("sumDspNetAmt").value = formatCurrency(unformatCurrency("sumDspNetAmt")+netDisbAmt); 
						}
						populateGDCPFields(null);
					}
				}
				batchOverlay.close();
			}
		});
	});
	
	/* commented and changed by reymon 04262013
	observeCancelForm("btnExitBatch", null, function() {
		batchOverlay.close();
	});
	*/
	
	$("btnExitBatch").observe("click", function() {
		batchOverlay.close();
	});
	
	function includeBatchForAdd(obj) {
		var exists = false;
		for(var i=0; i<addedBatch.length; i++) {
			if(obj.batchCsrId == addedBatch[i].batchCsrId) {
				exists = true;
			}
		}
		if(!exists) {
			obj.transactionType = $F("selTransactionType");
			obj.gaccTranId = objACGlobal.gaccTranId;
			obj.riIssCd = $F("varIssCd");
			addedBatch.push(selectedBatch);
		}
	}
	
	function removeBatchFromAdd() {
		for(var i=0; i<addedBatch.length; i++) {
			if(selectedBatch.batchCsrId == addedBatch[i].batchCsrId) {
				addedBatch.splice(i,1);
			}
		}
	}
	
	try {
		var objBatch = JSON.parse('${batchClaimTG}');
		var batchTable = {
				url: contextPath+"/GIACDirectClaimPaymentController?action=showBatchClaimModal&refresh=1&lineCd="+
				$F("txtLineCd")+"&issCd="+$F("txtIssCd")+"&adviceYear="+$F("txtAdviceYear")+"&adviceSeqNo="+$F("txtAdvSeqNo")+
				"&riIssCd="+$F("varIssCd")+"&tranType="+$F("selTransactionType"),
				options: {
					title: '',
					height: '240',
					width: '460',
					onCellFocus: function(element, value, x, y, id) {
						selectedBatch = batchGrid.geniisysRows[y];
					},
					onRemoveRowFocus: function() {
						selectedBatch = null;
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
			            			includeBatchForAdd(selectedBatch);
			            		} else {
			            			removeBatchFromAdd();
			            		}
			            	}
			            })
					},
					{
						id: 'batchNumber',
						title: 'Batch Number',
						width: '120px',
						titleAlign: 'left',
						editable: false
					},
					{
						id: 'batchPayee',
						title: 'Payee',
						width: '170px',
						titleAlign: 'left',
						editable: false
					},
					{
						id: 'batchPaidAmt',
						title: 'Net Disbursement',
						width: '122px',
						geniisysClass : 'money',
						titleAlign: 'right',
						align: 'right',
						editable: false
					},
					{
						id: 'batchIssCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'batchYear',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'batchFundCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'batchSeqNo',
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
						id: 'payeeCd',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					},
					{
						id: 'batchCsrId',
						title: '',
						width: '0',
						filterOption: false,
						visible: false
					}
				],
				rows: objBatch.rows
		};
		
		batchGrid = new MyTableGrid(batchTable);
		batchGrid.pager = objBatch;
		batchGrid.render('batchClaimTableGrid');
	} catch(e) {
		showErrorMessage("prepareBatchTG", e);
	}
</script>