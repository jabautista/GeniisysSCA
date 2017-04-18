<div class="sectionDiv" id="lossExpItemPerilTableGridSectionDiv" style="border-top: 0px; border-left: 0px; border-right: 0px;">
	<div id="lossExpHistItemPerilDiv" name="lossExpHistItemPerilDiv" style="width: 100%;">
		<div id="lossExpHistItemPerilTableGridDiv" style="padding: 10px;">
			<div id="lossExpHistItemPerilGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 880px;"></div>					
		</div>
	</div>
</div>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Payee Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="lossExpPayeeTableGridSectionDiv" style="border-top: 0px; border-left: 0px; border-right: 0px;">
	<div id="lossExpHistPayeeDiv" name="lossExpHistPayeeDiv" style="width: 100%;">
		<div id="lossExpHistPayeeTableGridDiv" style="padding: 10px 100px;">
			<div id="lossExpHistPayeeGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 750px;"></div>					
		</div>
	</div>
</div>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>History Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="clmlossExpTableGridSectionDiv" style="border: 0px;">
	<div id="clmlossExpDiv" name="clmlossExpPayeeDiv" style="width: 50%; float: left;">
		<div id="clmlossExpTableGridDiv" style="padding: 10px;">
			<div id="clmlossExpGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 450px;"></div>					
		</div>
	</div>
	<div id="clmlossExpFormDiv" name="clmlossExpFormDiv" style="width: 50%; float: left;">
		<div id="clmlossExpDiv" style="padding: 10px;">
			<table style="margin: 10px 20px;">
				<tr>
					<td class="rightAligned">Loss Paid Amount</td>
					<td class="leftAligned">
						<input id="txtLELossPaidAmt" name="txtLELossPaidAmt" type="text" style="width: 230px;" value="" readonly="readonly" class="money"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Net Amount</td>
					<td class="leftAligned">
						<input id="txtLELossNetAmt" name="txtLELossNetAmt" type="text" style="width: 230px;" value="" readonly="readonly" class="money"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Advice Amount</td>
					<td class="leftAligned">
						<input id="txtLELossAdviceAmt" name="txtLELossAdviceAmt" type="text" style="width: 230px;" value="" readonly="readonly" class="money"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<input id="txtLEUserId" name="txtLEUserId" type="text" style="width: 230px;" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input id="txtLELastUpdate" name="txtLELastUpdate" type="text" style="width: 230px;" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned">
						<div style="float:left; width: 236px;" class="withIconDiv">
							<textarea class="withIcon" id="txtLERemarks" name="txtLERemarks" style="width: 200px; resize:none;" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editLERemarks" />
						</div>
					</td>
				</tr>
			</table>					
		</div>
	</div>
	<div id="lossExpButtonDiv" class="sectionDiv" style="width: 100%; border: 0;" align="center">
		<table align="center" cellpadding="1" style="margin: 15px;">
			<tr>
				<td><input type="button" id="btnLossDetails"	 name="btnLossDetails"      class="button"	value="Loss Details" /></td>
				<td><input type="button" id="btnViewHistory"	 name="btnViewHistory"      class="button"	value="View History" /></td>
				<td><input type="button" id="btnViewDist"		 name="btnViewDist"   	    class="button"	value="View Distribution" /></td>
				<td><input type="button" id="btnLossTax"		 name="btnLossTax"          class="button"	value="Loss Tax" /></td>
				<td><input type="button" id="btnViewAdvice" 	 name="btnViewAdvice"       class="button"	value="View Advice" /></td>
				<td><input type="button" id="btnCancelledAdvice" name="btnCancelledAdvice"  class="button"	value="Cancelled Advice" /></td>
				<td><input type="button" id="btnBillInformation" name="btnBillInformation"  class="button"	value="Bill Information" /></td>
			</tr>
		</table>
		<input type="hidden" id="hidImplemSw"  name="hidImplemSw"  value="${implemSw}">
	</div>
</div>

<script type="text/javascript">
	try{
		initializeAccordion();
		
		var objLossExpItemPeril = JSON.parse('${jsonGiclItemPeril}');
		var currItemPeril = null;
		var currLossExpPayee = null;
		var currClmLossExp = null;
		
		var lossExpItemPerilTableModel = {
			id : 'LEIP',
			url : contextPath + "/GICLItemPerilController?action=getItemPerilGrid3&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '880px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						getLossExpPayeesListing(null);
						lossExpItemPerilTableGrid.keys.removeFocus(lossExpItemPerilTableGrid.keys._nCurrentFocus, true);
						lossExpItemPerilTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var itemPeril = lossExpItemPerilTableGrid.geniisysRows[y];
					getLossExpPayeesListing(itemPeril);
					lossExpItemPerilTableGrid.keys.removeFocus(lossExpItemPerilTableGrid.keys._nCurrentFocus, true);
					lossExpItemPerilTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					getLossExpPayeesListing(null);
					lossExpItemPerilTableGrid.keys.removeFocus(lossExpItemPerilTableGrid.keys._nCurrentFocus, true);
					lossExpItemPerilTableGrid.keys.releaseKeys();
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
				{ 	id: 'groupedItemNo',
					width: '0',
				  	visible:false
				},
				{	id: 'itemNo',
					width: '0',
					title: 'Item No',
					visible: false
				},
				{
					id : 'dspItemNo dspItemTitle',
					title : 'Item Title',
					width : '250px',
					titleAlign: 'center',
					sortable : false,					
					children : [
						{
							id : 'dspItemNo',			
							title : 'Item No.',
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id : 'dspItemTitle',
							title: 'Item Title',
							width : 200,
							sortable : false,
							editable : false,
							filterOption: true
						}
					]					
				},
				{
					id : 'perilCd dspPerilName',
					title : 'Peril Name',
					width : '250px',
					titleAlign: 'center',
					sortable : false,					
					children : [
						{
							id : 'perilCd',
							title : 'Peril Cd',
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id : 'dspPerilName',
							title : 'Peril Name',
							width : 200,
							sortable : false,
							editable : false,
							filterOption: true
						}
					]					
				},
				{ 	id: 'dspCurrDesc',
					align : 'left',
					title : 'Currency',
					width : '175px',
					editable: false,
					sortable: false,
					filterOption: true
				},
				{
				   	id: 'annTsiAmt',
				   	title: 'Total Sum Insured',
				   	type : 'number',
				  	width: '180px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objLossExpItemPeril.rows,
			requiredColumns: ''
		};
		
		lossExpItemPerilTableGrid = new MyTableGrid(lossExpItemPerilTableModel);
		lossExpItemPerilTableGrid.pager = objLossExpItemPeril;
		lossExpItemPerilTableGrid.render('lossExpHistItemPerilGrid');
		lossExpItemPerilTableGrid.afterRender = function(){
			try{
				/* getLossExpPayeesListing(null);
				lossExpItemPerilTableGrid.keys.removeFocus(lossExpItemPerilTableGrid.keys._nCurrentFocus, true);
				lossExpItemPerilTableGrid.keys.releaseKeys(); */
			}catch(e){
				showErrorMessage("lossExpItemPerilTableGrid.afterRender", e);
			}
		};
		
		var lossExpPayeesTableModel = {
			id : 'LEP',
			url : contextPath + "/GICLLossExpPayeesController?action=getGiclLossExpPayeesList&claimId="+ nvl(objCLMGlobal.claimId, 0)+
			                    "&itemNo=0&perilCd=0&groupedItemNo=0&polIssCd="+objCLMGlobal.policyIssueCode,
			options:{
				title: '',
				pager: { },
				hideColumnChildTitle: true,
				width: '700px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						getClmLossExpListing(null);
						lossExpPayeesTableGrid.keys.removeFocus(lossExpPayeesTableGrid.keys._nCurrentFocus, true);
						lossExpPayeesTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var lossExpPayees = lossExpPayeesTableGrid.geniisysRows[y];
					getClmLossExpListing(lossExpPayees);
					lossExpPayeesTableGrid.keys.removeFocus(lossExpPayeesTableGrid.keys._nCurrentFocus, true);
					lossExpPayeesTableGrid.keys.releaseKeys();
					
				},
				onRemoveRowFocus: function() {
					getClmLossExpListing(null);
					lossExpPayeesTableGrid.keys.removeFocus(lossExpPayeesTableGrid.keys._nCurrentFocus, true);
					lossExpPayeesTableGrid.keys.releaseKeys();
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
				{	id: 'payeeType',
					width: '0',
					visible: false
				},
				{	id: 'payeeTypeDesc',
					align: 'left',
				  	title: 'Payee Type',
				  	titleAlign: 'center',
				  	width: '130px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
					id : 'payeeClassCd className',
					title : 'Payee Class',
					width : '200px',
					titleAlign: 'center',
					sortable : false,					
					children : [
						{
							id : 'payeeClassCd',
							title : 'Payee Class Cd',
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right',
							filterOption: true
						},
						{
							id : 'className',
							title : 'Class Desc',
							width : 150,
							sortable : false,
							editable : false,
							filterOption : true
						}
					]					
				},
				{
					id : 'payeeCd dspPayeeName',
					title : 'Payee',
					width : '350px',
					titleAlign: 'center',
					sortable : false,					
					children : [
						{
							id : 'payeeCd',
							title : 'Payee Cd',
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right',
							filterOption : true,
							fitlerOptionType : 'integerNoNegative'
						},
						{
							id : 'dspPayeeName',
							title : 'Payee Name',
							width : 300,
							sortable : false,
							editable : false,
							filterOption : true
						}
					]					
				},
			],
			rows : [],
			requiredColumns: ''
		};
		
		lossExpPayeesTableGrid = new MyTableGrid(lossExpPayeesTableModel);
		lossExpPayeesTableGrid.render('lossExpHistPayeeGrid');
		lossExpPayeesTableGrid.afterRender = function(){
			try{
				/* getClmLossExpListing(null);
				lossExpPayeesTableGrid.keys.removeFocus(lossExpPayeesTableGrid.keys._nCurrentFocus, true);
				lossExpPayeesTableGrid.keys.releaseKeys(); */	
			}catch(e){
				showErrorMessage("lossExpPayeesTableGrid.afterRender", e);
			}
		};
		
		var clmLossExpenseTableModel = {
			id : 'CLE',
			url : contextPath + "/GICLClaimLossExpenseController?action=getClmLossExpList&claimId="+ nvl(objCLMGlobal.claimId, 0) +
			  					"&payeeType=&payeeClassCd=0&payeeCd=0&itemNo=0&perilCd=0&clmClmntNo=0&groupedItemNo=0",
			options:{
				title: '',
				pager: { },
				width: '420px',
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						populateClmLossExpFields(null);
						clmLossExpenseTableGrid.keys.removeFocus(clmLossExpenseTableGrid.keys._nCurrentFocus, true);
						clmLossExpenseTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var clmLossExp = clmLossExpenseTableGrid.geniisysRows[y];
					populateClmLossExpFields(clmLossExp);
					clmLossExpenseTableGrid.keys.removeFocus(clmLossExpenseTableGrid.keys._nCurrentFocus, true);
					clmLossExpenseTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					populateClmLossExpFields(null);
					clmLossExpenseTableGrid.keys.removeFocus(clmLossExpenseTableGrid.keys._nCurrentFocus, true);
					clmLossExpenseTableGrid.keys.releaseKeys();
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
				{	id: 'historySequenceNumber',
					align: 'right',
				  	title: 'Hist. Seq. No.',
				  	titleAlign: 'center',
				  	width: '100px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				  	filterOptionType: 'integerNoNegative',
				  	renderer : function(value){
						return lpad(value.toString(), 3, "0");					
					}
				},
				{	id: 'clmLossExpStatDesc',
					align: 'left',
				  	title: 'History Status',
				  	titleAlign: 'center',
				  	width: '250px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
					id: 'exGratiaSw',
					title: 'EG',
					altTitle: 'Ex-Gratia',
					width: '27px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
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
					id: 'finalTag',
					title: '&#160;&#160;F',
					altTitle: 'Final Tag',
					width: '27px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				}
				
			],
			rows : [],
			requiredColumns: ''
		};
		
		clmLossExpenseTableGrid = new MyTableGrid(clmLossExpenseTableModel);
		clmLossExpenseTableGrid.render('clmlossExpGrid');
		clmLossExpenseTableGrid.afterRender = function(){
			populateClmLossExpFields(null);
			clmLossExpenseTableGrid.keys.removeFocus(clmLossExpenseTableGrid.keys._nCurrentFocus, true);
			clmLossExpenseTableGrid.keys.releaseKeys();
		};
		
		function getLossExpPayeesListing(itemPeril){
			if(itemPeril != null){
				currItemPeril = itemPeril;
				lossExpPayeesTableGrid.url = contextPath + "/GICLLossExpPayeesController?action=getGiclLossExpPayeesList&claimId="+ nvl(objCLMGlobal.claimId, 0)+
											 "&itemNo="+itemPeril.itemNo+"&perilCd="+itemPeril.perilCd+"&groupedItemNo="+itemPeril.groupedItemNo+"&polIssCd="+objCLMGlobal.policyIssueCode;
				lossExpPayeesTableGrid._refreshList();
			}else{
				currItemPeril = null;
				lossExpPayeesTableGrid.url = contextPath + "/GICLLossExpPayeesController?action=getGiclLossExpPayeesList&claimId="+ nvl(objCLMGlobal.claimId, 0)+
                							"&itemNo=0&perilCd=0&groupedItemNo=0&polIssCd="+objCLMGlobal.policyIssueCode;
				lossExpPayeesTableGrid._refreshList();
			}
			getClmLossExpListing(null);
		}
		
		function getClmLossExpListing(lossExpPayees){
			if(lossExpPayees != null){
				currLossExpPayee = lossExpPayees;
				clmLossExpenseTableGrid.url = contextPath + "/GICLClaimLossExpenseController?action=getClmLossExpList&claimId="+ nvl(objCLMGlobal.claimId, 0) +
				  							"&payeeType="+lossExpPayees.payeeType+"&payeeClassCd="+lossExpPayees.payeeClassCd+"&payeeCd="+lossExpPayees.payeeCd+"&itemNo="+lossExpPayees.itemNo+
				  							"&perilCd="+lossExpPayees.perilCd+"&clmClmntNo="+lossExpPayees.clmClmntNo+"&groupedItemNo="+lossExpPayees.groupedItemNo;
				clmLossExpenseTableGrid._refreshList();
			}else{
				currLossExpPayee = null;
				clmLossExpenseTableGrid.url = contextPath + "/GICLClaimLossExpenseController?action=getClmLossExpList&claimId="+ nvl(objCLMGlobal.claimId, 0) +
											 "&payeeType=&payeeClassCd=0&payeeCd=0&itemNo=0&perilCd=0&clmClmntNo=0&groupedItemNo=0";
				clmLossExpenseTableGrid._refreshList();
			}
			populateClmLossExpFields(null);
		}
		
		function populateClmLossExpFields(clmLossExp){
			currClmLossExp 				  = clmLossExp == null ? null : clmLossExp;
			$("txtLELossPaidAmt").value   = clmLossExp == null ? "" : formatCurrency(clmLossExp.paidAmount);
			$("txtLELossNetAmt").value 	  = clmLossExp == null ? "" : formatCurrency(clmLossExp.netAmount);
			$("txtLELossAdviceAmt").value = clmLossExp == null ? "" : formatCurrency(clmLossExp.adviceAmount);
			$("txtLEUserId").value 		  = clmLossExp == null ? "" : unescapeHTML2(clmLossExp.userId);
			$("txtLELastUpdate").value 	  = clmLossExp == null ? "" : (nvl(clmLossExp.lastUpdate, null) != null ? dateFormat(clmLossExp.lastUpdate, "mm-dd-yyyy hh:MM:ss TT") : "");
			$("txtLERemarks").value 	  = clmLossExp == null ? "" : unescapeHTML2(clmLossExp.remarks);
			
			if(currClmLossExp == null){
				disableButton("btnLossDetails");
				disableButton("btnViewHistory");
				disableButton("btnViewDist");
				disableButton("btnLossTax");
				disableButton("btnViewAdvice");
				disableButton("btnBillInformation");
			}else{
				enableButton("btnLossDetails");
				enableButton("btnViewHistory");
				enableButton("btnViewDist");
				enableButton("btnLossTax");
				enableButton("btnViewAdvice");
				enableButton("btnBillInformation");
			}
		}
		
		$("editLERemarks").observe("click", function(){showEditor("txtLERemarks", 4000, 'true');});
		
		function showPopupLossExpenseHistListing(url,title,width,height){
			if(currItemPeril == null){
				showMessageBox("Please select an item first.", "I");
				return false;
			}else if(currLossExpPayee == null){
				showMessageBox("Please select a payee first.", "I");
				return false;
			}else if(currClmLossExp == null){
				showMessageBox("Please select a history record first.", "I");
				return false;
			}				
			
			var contentDiv = new Element("div", {id : "modal_content_lov"});
		    var contentHTML = '<div id="modal_content_lov"></div>';
		    lossExpHistPopupGrid = Overlay.show(contentHTML, {
								id: 'modal_dialog_lov',
								title: nvl(title,""),
								width: nvl(width,700),
								height: nvl(height,340),
								draggable: false,
								closable: true
							});
		    
		    new Ajax.Updater("modal_content_lov", url, {
				evalScripts: true,
				asynchronous: false,
				parameters:{
					claimId: objCLMGlobal.claimId,
					lineCd: objCLMGlobal.lineCode,
					itemNo: currItemPeril.itemNo,
					perilCd: currItemPeril.perilCd,
					payeeType: currLossExpPayee.payeeType,
					payeeClassCd: currLossExpPayee.payeeClassCd,
					payeeCd: currLossExpPayee.payeeCd,
					clmLossId: currClmLossExp.claimLossId,
					issCd: objCLMGlobal.issueCode,
					ajax: 1
				},
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response) {
					hideNotice();
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		// Loss Details
		$("btnLossDetails").observe("click", function(){
			if($("hidImplemSw").value == "N"){ 
				showPopupLossExpenseHistListing(contextPath + "/GICLLossExpDtlController?action=showGICLS260LossExpDtls&action1=getAllGiclLossExpDtlList", "Loss Details", 520, 370);
			}else{
				showPopupLossExpenseHistListing(contextPath + "/GICLLossExpDtlController?action=showGICLS260LossExpDtls&action1=getGiclLossExpDtlList", "Loss/Expense Details", 925, 345);
			}
		});
		
		// View History
		$("btnViewHistory").observe("click", function(){
			showPopupLossExpenseHistListing(contextPath + "/GICLClaimLossExpenseController?action=showGICLS260LossExpViewHist", "View History Details", 925, 300);
		});
		
		// View Distribution
		$("btnViewDist").observe("click", function(){
			showPopupLossExpenseHistListing(contextPath + "/GICLLossExpDsController?action=showGICLS260LossExpDist", "View Distribution Details", 800, 450);
		});
		
		// Loss Tax
		$("btnLossTax").observe("click", function(){
			showPopupLossExpenseHistListing(contextPath + "/GICLLossExpTaxController?action=showGICLS260LossExpTax", "Loss/Expense Tax", 985, 340);
		});
		
		//View Advice
		$("btnViewAdvice").observe("click", function () {
			if(currItemPeril == null){
				showMessageBox("Please select an item first.", "I");
				return false;
			}else if(currLossExpPayee == null){
				showMessageBox("Please select a payee first.", "I");
				return false;
			}else if(currClmLossExp == null){
				showMessageBox("Please select a history record first.", "I");
				return false;
			}
			
			overlayAdvice = Overlay.show(contextPath+"/GICLAdviceController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260LEAdvicePage",
								claimId : objCLMGlobal.claimId,
								issCd: objCLMGlobal.issueCode,
								adviceId: currClmLossExp.adviceId,
								clmLossId: currClmLossExp.claimLossId,
								histSeqNo: currClmLossExp.historySequenceNumber},
				title: "Advice/Claim Settlement Request",	
				id: "view_advice_canvas",
				width: 350,
				height: 120,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
		});
		
		// Cancelled Advice
		$("btnCancelledAdvice").observe("click", function(){
			overlayAdvice = Overlay.show(contextPath+"/GICLAdviceController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260CancelledAdvice",
								claimId : objCLMGlobal.claimId,
								ajax: 1},
				title: "List of Cancelled Advice",	
				id: "cancelled_advice_canvas",
				width: 535,
				height: 275,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
		});
		
		// Bill Information
		$("btnBillInformation").observe("click", function(){
			showPopupLossExpenseHistListing(contextPath + "/GICLLossExpBillController?action=showGICLS260LossExpBill", "Bill Information", 837, 345);
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense History", e);
	}
</script>