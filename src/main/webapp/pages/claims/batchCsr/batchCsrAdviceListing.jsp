<div id="batchCsrAdviceListTableGridDiv" name="batchCsrAdviceListTableGridDiv">
	<input type="hidden" id="hidCurrAdviceId" name="hidCurrAdviceId" value=""/>
	<input type="hidden" id="hidCurrClaimId" name="hidCurrClaimId" value=""/>
	<div id="batchCsrAdviceListTableGrid" style="height: 200px;"></div>
</div>


<script type="text/javascript">
	
	try{
		var batchCsrId = '${batchCsrId}';
		var selectedAdvice = null;
		var selectedAdviceIndex = null;
		objGICLAdviceList = [];
		var objAdvice = new Object();
		objAdvice.objAdviceTableGrid = JSON.parse('${jsonGiclAdvice}');
		objAdvice.objAdviceList = objAdvice.objAdviceTableGrid.rows || [];
		
		var refreshTag = 'N';
		
		var adviceModel = {
			url: contextPath+"/GICLAdviceController?action=showGicls043AdviceListing&moduleId=GICLS043&batchCsrId="+nvl(batchCsrId, 0)+"&insertTag="+nvl($F("insertTag"), 0),
			options:{
				title: '',
				width: '880px',
				checkChanges: false,
				onCellFocus: function(element, value, x, y, id){
					//var mtgId = adviceTableGrid._mtgId;
					var record = adviceTableGrid.geniisysRows[y];
					$("hidCurrAdviceId").value = record.adviceId;
					$("hidCurrClaimId").value = record.claimId;
					selectedAdvice = record;
					selectedAdviceIndex = y;
					
					if(x == adviceTableGrid.getColumnIndex("batchCsrId")){
						/*if(!checkBatchCsrReqFields()){
							if(nvl($F("insertTag"), 0) == 0){
								observeBatchCsrGenerateTag(record, x, y, mtgId);
							}
						}else{
							showMessageBox("Please insert payee and particulars " +
									       "before tagging this item.", "I");
							$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
							$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
						}*/ // commented by: Nica 04.27.2013
						//adviceTableGrid.keys.releaseKeys(); // andrew - 12.13.2012
					} else {
						adviceTableGrid.keys.releaseKeys(); // andrew - 12.13.2012
					}
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					$("hidCurrAdviceId").value = "";
					$("hidCurrClaimId").value = "";
					selectedAdvice = null;
					selectedAdviceIndex = null;
				},
				onSort: function(element, value, x, y, id){
					$("hidCurrAdviceId").value = "";
					$("hidCurrClaimId").value = "";
					selectedAdvice = null;
					selectedAdviceIndex = null;
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						$("hidCurrAdviceId").value = "";
						$("hidCurrClaimId").value = "";
						selectedAdvice = null;
						selectedAdviceIndex = null;
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				/*{ id: 'batchCsrId',
				  	sortable: false,
				  	align: 'center',
				  	title: '&#160;&#160;G',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: $F("insertTag") == 1 ? false : true,
				  	defaultValue: false,
				  	otherValue: false,
				  	editor: 'checkbox'	
				},*/
				{
					id: 'batchCsrId',
					width: '23px',
					sortable: false,
				  	align: 'center',
				  	title: '&#160;G',
				  	titleAlign: 'center',
				  	width: '23px',
				  	hideSelectAllBox: true,
				  	editable: $F("insertTag") == 1 ? false : true,
				  	editor: "checkbox"
					/* removed by robert 02.20.2014
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked) {
		            		if(nvl($F("insertTag"), 0) == 0){
		            			if(checked) {	
									includeAdviceForBatchCSR(selectedAdvice);
			            		} else {
			            			removeAdviceForBatchCSR(selectedAdvice);
			            		}
		            		}	
		            	}
		            	
		            }) */
				},
				{	id: 'adviceId',
					width: '0',
					visible: false
				},
				{	id: 'claimId',
					width: '0',
					visible: false
				},
				{	id: 'currencyCode',
					width: '0',
					visible: false
				},
				{	id: 'lineCode',
					title: 'Line Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'issueCode',
					title: 'Issue Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'sublineCode',
					title: 'Subline Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'adviceYear',
					title: 'Advice Year',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'adviceSequenceNumber',
					title: 'Advice Sequence Number',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'adviceNo',
					title: 'Advice Number',
					width: '150px'
				},
				{	id: 'claimNo',
					title: 'Claim Number',
					width: '150px'
				},
				{	id: 'policyNo',
					title: 'Policy Number',
					width: '150px'
				},
				{	id: 'assuredName',
					title: 'Assured Name',
					width: '180px',
					filterOption: true
				},
				{	id: 'adviceDate',
					title: 'Advice Date',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'formattedDate',
					type: 'date'
				},
				{	id: 'strAdviceDate',
					title: 'Advice Date',
					width: '80px',
					type: 'date'
				},
				{	id: 'lossDate',
					title: 'Loss Date',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'formattedDate',
					type: 'date'
				},
				{	id: 'strLossDate',
					title: 'Loss Date',
					width: '80px',
					type: 'date'
				},
				{	id: 'dspLossCatDes',
					title: 'Loss Description',
					width: '150px',
					filterOption: true
				},
				{	id: 'paidAmount',
					title: 'Paid Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'paidForeignCurrencyAmount',
					width: '0',
					visible: false
				},
				{	id: 'netAmount',
					title: 'Net Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'netForeignCurrencyAmount',
					width: '0',
					visible: false
				},
				{	id: 'adviceAmount',
					title: 'Advice Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'advForeignCurrencyAmount',
					width: '0',
					visible: false
				},
				{	id: 'dspCurrency',
					title: 'Currency',
					width: '100px',
					filterOption: true
				},
				{	id: 'convertRate',
				    title: 'Convert Rate',
				    geniisysClass: 'rate',
				    align: 'right',
				    titleAlign: 'right',
					width: '90px',
					visible: true,
					filterOption: true,
					filterOptionType: 'numberNoNegative'
					
				},
			],
			requiredColumns: 'batchCsrId adviceId adviceNo',
			rows: objAdvice.objAdviceList	
		};
	
		adviceTableGrid = new MyTableGrid(adviceModel);
		adviceTableGrid.pager = objAdvice.objAdviceTableGrid;
		adviceTableGrid.render('batchCsrAdviceListTableGrid');
		adviceTableGrid.afterRender = function(){
			var mtgId = adviceTableGrid._mtgId;
			if(nvl($F("insertTag"), 0) == 0 && refreshTag == 'N'){
				//var mtgId = adviceTableGrid._mtgId;
				var rows = adviceTableGrid.geniisysRows;
				var x = adviceTableGrid.getColumnIndex('batchCsrId');
				for(var y=0; y<rows.length; y++){
					for(var i=0; i<objGICLAdviceList.length; i++){
						if(objGICLAdviceList[i].adviceId == rows[y].adviceId && objGICLAdviceList[i].claimId == rows[y].claimId){
							$('mtgInput'+mtgId+'_'+x+','+y).checked = true;
							$('mtgIC'+mtgId+'_'+x+','+y).addClassName('modifiedCell');
						}
					}	
				}
			}
			refreshTag = 'N';
			$$("div#myTableGrid"+mtgId+" .mtgInputCheckbox").each( //added by robert 02.20.2014
					function(obj){
						obj.observe("click", function(){
							if(nvl($F("insertTag"), 0) == 0){
		            			if(this.checked) {
		            				var rowIndex = this.id.substring(this.id.length - 1);
									var row = adviceTableGrid.geniisysRows[rowIndex];
		            				var mtgId = adviceTableGrid._mtgId;
		            				var x = adviceTableGrid.getColumnIndex('batchCsrId');
		            				var y = nvl(selectedAdviceIndex,rowIndex);
		            				if(checkBatchCsrReqFields()){
		            					showMessageBox("Please insert payee and particulars " +
		            						       		"before tagging this item.", "I");
		            					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
		            					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
		            					return false;
		            				}
									includeAdviceForBatchCSR(row);
			            		} else {
			            			var rowIndex = this.id.substring(this.id.length - 1);
									var row = adviceTableGrid.geniisysRows[rowIndex];
			            			removeAdviceForBatchCSR(row);
			            		}
		            		}	
						});
					}
				);
		};
		//added by robert 02.20.2014
		$("mtgRefreshBtn2").stopObserving();
		$("mtgRefreshBtn2").observe("click", function(){
			refreshTag = 'Y';
			disableButton("btnGenerateBatch");
			$("paidAmount").value = formatCurrency(0);
			$("netAmount").value = formatCurrency(0);
			$("adviceAmount").value = formatCurrency(0);
			$("currency").value = null;
			$("convertRate").value = null;
			objGICLAdviceList = [];
			adviceTableGrid._refreshList();
		});
		
	}catch(e){
		showErrorMessage("batchCsrAdviceListing.jsp", e);
	}
	
	function observeBatchCsrGenerateTag(record, x, y, mtgId){
		var objArray = adviceTableGrid.getModifiedRows();
		//objArray = objArray.filter(function(obj){ return obj.batchCsrId == true;});
		
		for(var i=0; i<objArray.length; i++){
			if(objArray[i].batchCsrId != true){
				for(var j=0; j<objGICLAdviceList.length; j++){
					if(objGICLAdviceList[j].adviceId == objArray[i].adviceId && objGICLAdviceList[j].claimId == objArray[i].claimId){
						objGICLAdviceList.splice(j, 1);
					}
				}
			}else{
				if(record.issueCode != objArray[i].issueCode){
					showMessageBox("Record is not allowed to be grouped with the previous record/s. " +
		                     	   "You are currently grouping records generated from " + objArray[i].issueCode+".", "E");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
				}else if(record.currencyCode != objArray[i].currencyCode){
					showMessageBox("Items to be tagged should have the same currency. " +
		                  	   	   "Please check currency of previously tagged item.", "I");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
				}else if(record.convertRate != objArray[i].convertRate){ //edited by steven 08.04.2014
					showMessageBox("Items to be tagged should have the same conversion rate. " +
			              	   	   "Please check the rate of previously tagged item.", "I");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
				}else{
					objGICLAdviceList.push(objArray[i]);
				}
			}
		}
		
		if(objGICLAdviceList.length > 0){
			objBatchCsr.generateTagSw = 1;
			if(!checkBatchCsrReqFields()){
				enableButton("btnGenerateBatch");
			}
		}else{
			objBatchCsr.generateTagSw = 0;
			disableButton("btnGenerateBatch");
		}
		populateBatchCsrForGeneration(objGICLAdviceList);
	}
	
	function includeAdviceForBatchCSR(record){
		var objArray = objGICLAdviceList;
		var mtgId = adviceTableGrid._mtgId;
		var x = adviceTableGrid.getColumnIndex('batchCsrId');
		//var y = selectedAdviceIndex; --marco - 03.25.2014 - replaced with line below
		var y = record.divCtrId;
		
		if(checkBatchCsrReqFields()){
			showMessageBox("Please insert payee and particulars " +
				       		"before tagging this item.", "I");
			$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
			$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
			return false;
		}
		
		if(objArray.length == 0){
			objGICLAdviceList.push(record);
		}else{
			for(var i=0; i<objArray.length; i++){
				if(record.issueCode != objArray[i].issueCode){
					showMessageBox("Record is not allowed to be grouped with the previous record/s. " +
		                     	   "You are currently grouping records generated from " + objArray[i].issueCode+".", "E");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
					return false;
				}else if(record.currencyCode != objArray[i].currencyCode){
					showMessageBox("Items to be tagged should have the same currency. " +
		                  	   	   "Please check currency of previously tagged item.", "I");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
					return false;
				}else if(record.convertRate != objArray[i].convertRate){ //edited by steven 08.04.2014
					showMessageBox("Items to be tagged should have the same conversion rate. " +
			              	   	   "Please check the rate of previously tagged item.", "I");
					$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
					return false;
				}
			}
			objGICLAdviceList.push(record);
		}
		
		if(objGICLAdviceList.length > 0){
			objBatchCsr.generateTagSw = 1;
			if(!checkBatchCsrReqFields()){
				enableButton("btnGenerateBatch");
			}
		}else{
			objBatchCsr.generateTagSw = 0;
			disableButton("btnGenerateBatch");
		}
		populateBatchCsrForGeneration(objGICLAdviceList);
		adviceTableGrid.keys.releaseKeys();
	}
	
	function removeAdviceForBatchCSR(record){
		for(var j=0; j<objGICLAdviceList.length; j++){
			if(objGICLAdviceList[j].adviceId == record.adviceId && objGICLAdviceList[j].claimId == record.claimId){
				objGICLAdviceList.splice(j, 1);
			}
		}
		if(objGICLAdviceList.length > 0){
			objBatchCsr.generateTagSw = 1;
			if(!checkBatchCsrReqFields()){
				enableButton("btnGenerateBatch");
			}
		}else{
			objBatchCsr.generateTagSw = 0;
			disableButton("btnGenerateBatch");
		}
		populateBatchCsrForGeneration(objGICLAdviceList);
		adviceTableGrid.keys.releaseKeys();
	}
	
	function populateBatchCsrForGeneration(objArray){
		var lossAmt = 0;
		var paidAmt = 0;
		var netAmt = 0;
		var adviceAmt = 0;
		var paidFCurrAmt = 0;
		var netFCurrAmt = 0;
		var advFCurrAmt = 0;
		var currencyCd = null;
		var currencyDesc = null;
		var convertRate = null;
		var issueCode = null;
		
		for(var i=0; i<objArray.length; i++){
			lossAmt = parseFloat(nvl(lossAmt, 0)) + (parseFloat(nvl(objArray[i].paidAmount, 0))*parseFloat(nvl(objArray[i].convertRate, 0)));
			paidAmt = parseFloat(nvl(paidAmt, 0)) + parseFloat(nvl(objArray[i].paidAmount, 0));
			netAmt = parseFloat(nvl(netAmt, 0)) + parseFloat(nvl(objArray[i].netAmount, 0));
			adviceAmt = parseFloat(nvl(adviceAmt, 0)) + parseFloat(nvl(objArray[i].adviceAmount, 0));
			paidFCurrAmt = parseFloat(nvl(paidFCurrAmt, 0)) + parseFloat(nvl(objArray[i].paidForeignCurrencyAmount, 0));
			netFCurrAmt = parseFloat(nvl(netFCurrAmt, 0)) + parseFloat(nvl(objArray[i].netForeignCurrencyAmount, 0));
			advFCurrAmt = parseFloat(nvl(advFCurrAmt, 0)) + parseFloat(nvl(objArray[i].advForeignCurrencyAmount, 0));
			currencyCd = objArray[i].currencyCode;
			currencyDesc = objArray[i].dspCurrency;
			convertRate = objArray[i].convertRate;
			issueCode = objArray[i].issueCode;
		}
		
		objBatchCsr.lossAmount = lossAmt;
		objBatchCsr.paidAmount = paidAmt;
		objBatchCsr.netAmount = netAmt;
		objBatchCsr.adviceAmount = adviceAmt;
		objBatchCsr.paidForeignCurrencyAmount = paidFCurrAmt;
		objBatchCsr.netForeignCurrencyAmount = netFCurrAmt;
		objBatchCsr.adviceForeignCurrencyAmount = advFCurrAmt;
		objBatchCsr.currencyCode = currencyCd;
		objBatchCsr.dspCurrency = currencyDesc;
		objBatchCsr.convertRate = convertRate;
		objBatchCsr.issueCode = issueCode;
		
		$("paidAmount").value = formatCurrency(objBatchCsr.paidAmount);
		$("netAmount").value = formatCurrency(objBatchCsr.netAmount);
		$("adviceAmount").value = formatCurrency(objBatchCsr.adviceAmount);
		$("currency").value = objBatchCsr.dspCurrency;
		$("convertRate").value = formatToNineDecimal(objBatchCsr.convertRate);
	}
	
</script>