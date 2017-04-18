<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="mainViewJournalEntriesDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Accounting Transactions</label>
		</div>
	</div>
	
	<div id="viewJournalEntriesDiv">
		<div id="fieldsDiv" class="sectionDiv" style="width: 920px; height: 50px;">
			<table align="center" style="width: 750px; margin-top: 5px;">
				<tr>
					<td class="rightAligned">Company</td>
					<td>
						<input id="hidGfunFundCd" type="hidden">
						<span class="required lovSpan" style="width:310px; height: 21px; float: left; margin-top: 1px;">
							<input type="text" id="txtCompany" name="txtCompany" class="required upper" maxlength="50" style="width: 280px; float: left; margin-right: 4px; border: none; height: 13px; " tabindex="101"/>	
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompanyLOV" name="searchCompanyLOV" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td style="padding-left: 15px;">Branch</td>
					<td>
						<input id="hidBranchCd" type="hidden">
						<span class="required lovSpan" style="width: 310px; height: 21px; float: left; margin-top: 1px;">
							<input type="text" id="txtBranch" name="txtBranch" class="required upper" maxlength="50" style="width: 280px; float: left; margin-right: 4px; border: none; height: 13px; " tabindex="104"/>	
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchLOV" name="searchBranchLOV" alt="Go" style="float: right;" tabindex="105"/>
						</span>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" style="width: 920px; height: 450px;" >
			<div id="journalEntriesTGDiv" style="width: 900px; height: 240px; margin: 10px 20px 10px 65px;"></div>
		
			<table cellspacing="0" width="80%" align="center" style="margin: 20px 15px 10px 105px;">				
				<tr>
					<td class="rightAligned">Particulars</td>
					<td class="leftAligned" colspan="3" style="padding-top:3px;">
						<textarea class="disableDelKey" id="txtParticulars" name="txtParticulars" readonly="readonly" style="width: 88%; height: 80px; resize: none;" maxlength="2000" tabIndex = "120"></textarea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<input type="text" id="txtUserId" name="txtUserId" style="width: 200px;" readonly="readonly" tabIndex = "121"/>
					</td>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 200px;" readonly="readonly" tabIndex = "122"/>
					</td>
					</tr>
			</table>
			
			<div id="journalEntriesButtonsDiv" class="buttonsDiv">
				<input id="btnDetails" name="btnDetails" type="button" class="button" value="Details" style="width: 90px;" tabindex="124">
				<input id="btnAcctgEntries" name="btnAcctgEntries" type="button" class="button" value="Accounting Entries" style="width: 120px;" tabindex="125">
				<input id="btnOPInfo" name="btnOPInfo" type="button" class="button" value="OP Info" style="width: 90px;" tabindex="126">
				<input id="btnDVInfo" name="btnDVInfo" type="button" class="button" value="DV Info" style="width: 90px;" tabindex="127">
				<input id="btnDummy" name="btnDummy" type="button" class="button" value="Print" style="width: 90px;" tabindex="128">
			</div>
		</div>
		
	</div>
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS070");
	setDocumentTitle("View Accounting Transactions");
	initializeAll();
	makeInputFieldUpperCase();
	
	$("txtCompany").focus();
	$("txtBranch").readOnly = true;
	disableSearch("searchBranchLOV");
	
	disableButton("btnDetails");
	disableButton("btnAcctgEntries");
	disableButton("btnOPInfo");
	disableButton("btnDVInfo");
	disableButton("btnDummy");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	$("btnToolbarPrint").hide();
	
	objACGlobal.previousModule = "GIACS070";
	objACGlobal.hidObjGIACS003 = {};
	
	var paramLabel = "PRINT";
	var paramFormCall = "";
	var reportId = null;
	
	var selectedRow = null;
	var selectedIndex = null;
	
	
	var objJournalEnt = new Object();
	objJournalEnt.journalEntTG = JSON.parse('${jsonViewJournalEntries}'.replace(/\\/g, '\\\\'));
	objJournalEnt.journalEntObjRows = objJournalEnt.journalEntTG.rows || [];
	objJournalEnt.journalEntList = [];
	
	try{
		var journalEntTableModel = {
			url: contextPath+"/GIACInquiryController?action=showViewJournalEntriesPage&moduleId=GIACS070&refresh=1",
			options: {
				width: '800px',
				height: '220px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					selectedRow = journalEntTG.geniisysRows[y];
					selectedIndex = y;
					setDtlFields(selectedRow);
					journalEntTG.keys.releaseKeys();
					objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
				},
				onRemoveRowFocus: function(){
					selectedRow = null;
					selectedIndex = null;
					journalEntTG.keys.releaseKeys();
					setDtlFields(null);
				},
				onRefresh: function(){
					journalEntTG.onRemoveRowFocus();
				},
				prePager: function(){
					journalEntTG.onRemoveRowFocus();
				},
				beforeSort: function(){
					journalEntTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					journalEntTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						journalEntTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},       
				{
					id: 'fundCd',
					width: '0px',
					visible: false
				},       
				{
					id: 'branchCd',
					width: '0px',
					visible: false
				},       
				{
					id: 'tranId',
					width: '0px',
					visible: false
				}, 
				{
					id: 'jvNo',
					width: '0px',
					visible: false
				},       
				{
					id: 'jvPrefSuff',
					width: '0px',
					visible: false
				},       
				{
					id: 'particulars',
					width: '0px',
					visible: false
				}, 
				{
					id: 'userId',
					width: '0px',
					visible: false
				},       
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				},
				{
					id: 'tranYy tranMm tranSeqNo',
					title: 'Transaction No.',
					width: '200px',
					children: [
						{
							id: 'tranYy',
							title: 'Tran Year',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							sortable: true,
							editable: false
						},     
						{
							id: 'tranMm',
							title: 'Tran Month',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							sortable: true,
							editable: false
						},     
						{
							id: 'tranSeqNo',
							title: 'Tran Seq No',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							sortable: true,
							editable: false
						}                  
					]					
				},     
				{
					id: 'strTrandate',
					title: 'Transaction Date',
					titleAlign: 'center',
					align: 'center',
					width: '120px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},     
				{
					id: 'postingDate',
					title: 'Posting Date',
					titleAlign: 'center',
					align: 'center',
					width: '100px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{
					id: 'tranClass meanTranClass',
					title: 'Transaction Class',
					width: '220px',
					children: [
						{
							id: 'tranClass',
							title: 'Tran Class',
							width: 50,
							filterOption: true,
							sortable: true,
							editable: false
						},     
						{
							id: 'meanTranClass',
							title: 'Mean Tran Class',
							width: 145,
							sortable: true,
							editable: false
						}               
					]					
				},
				{
					id: 'tranFlag meanTranFlag',
					title: 'Status',
					width: '220px',
					children: [
						{
							id: 'tranFlag',
							title: 'Tran Flag',
							width: 50,
							filterOption: true,
							sortable: true,
							editable: false
						},     
						{
							id: 'meanTranFlag',
							title: 'Mean Tran Flag',
							width: 135,
							sortable: true,
							editable: false
						}               
					]					
				}			
			],
			rows: objJournalEnt.journalEntObjRows
		};
		
		journalEntTG = new MyTableGrid(journalEntTableModel);
		journalEntTG.pager = objJournalEnt.journalEntTG;
		journalEntTG.render('journalEntriesTGDiv');
	}catch(e){
		showErrorMessage("viewJournalEntTG", e);
	}
	
	function opInfo(tranId){
		try{
			new Ajax.Request(contextPath+"/GIACInquiryController", {
				method: "POST",
				parameters: {
					action:		"getOpInfo",
					tranId:		tranId
				},
				onComplete: function(response){
					if (response.responseText != ""){
						enableButton("btnOPInfo");
						disableButton("btnDVInfo");
					}else{
						disableButton("btnOPInfo");
						disableButton("btnDVInfo");
					}
				}
			});
		}catch(e){
			showErrorMessage("opInfo", e);
		}
	}
	
	function whenNewRecordInstanceGACC(row){
		if (row != null){
			 /*IF :gacc.tran_class = 'JV' AND :gacc.jv_no Is Null AND :parameter.label = 'PRINT' 
		     THEN
		        IF :gacc.tran_flag in ('C','P','D') 
		        THEN
		           Set_Block_Property('GACC',UPDATE_ALLOWED,PROPERTY_FALSE);
		        ELSE
		           Set_Block_Property('GACC',UPDATE_ALLOWED,PROPERTY_TRUE);
		        END IF;
		     ELSE
		        Set_Block_Property('GACC',UPDATE_ALLOWED,PROPERTY_FALSE);
		     END IF;*/
		     
			/* Button behavior */
			if (row.tranClass == "COL" || row.tranClass == "JV" || row.tranClass == "DV" || row.tranClass == "CP" || row.tranClass == "CPR"){ //added CP/CPR by robert SR 5239 01.05.16
				enableButton("btnDetails");
		  	}else{
			  	disableButton("btnDetails");
		  	};
			
		  	if (row.tranClass == "COL"){
		  		opInfo(row.tranId);
		  		enableButton("btnOPInfo");
		  		disableButton("btnDVInfo");
		  	}else if (row.tranClass == "DV"){
		  		disableButton("btnOPInfo");
		  		enableButton("btnDVInfo");
		  		
		  		if (row.tranSeqNo != null && (row.tranFlag == "C" || row.tranFlag == "P")){
		  			if(objACGlobal.callingForm == "GIACS230" && paramLabel == "PRINT"){
		  				disableButton("btnDummy");
		  			}
		  		}
		  	}else{
		  		disableButton("btnOPInfo");
		  		disableButton("btnDVInfo");		  		
		  	}
		  	//added by robert SR 5239 01.05.16
		  	if(row.tranClass == "CP" || row.tranClass == "CPR"){
		  		disableButton("btnAcctgEntries");
		  	}
		  	//end of codes by robert SR 5239 01.05.16
		  	if(paramLabel == "PRINT"){
		  		if (row.tranFlag == "C" || row.tranFlag == "P"){
		  			enableButton("btnDummy");
		  		}else{
		  			disableButton("btnDummy");
		  		}
		  	}
		}
	}
	
	function setDtlFields(row){
		$("txtCompany").value = row == null ? $F("txtCompany") : unescapeHTML2(row.fundCd) + " - " + unescapeHTML2(row.fundDesc);
		$("txtBranch").value = row == null ? $F("txtBranch") : unescapeHTML2(row.branchCd) + " - " + unescapeHTML2(row.branchName);
		$("txtParticulars").value = row == null ? null : unescapeHTML2(row.particulars);
		$("txtUserId").value = row == null ? null : unescapeHTML2(row.userId);
		$("txtLastUpdate").value = row == null ? null : unescapeHTML2(row.lastUpdate);
		
		if(row == null){
			disableButton("btnDetails");
			disableButton("btnAcctgEntries");
			disableButton("btnOPInfo");
			disableButton("btnDVInfo");
			disableButton("btnDummy");
		}else{
			enableButton("btnDetails");
			enableButton("btnAcctgEntries");
		}
		whenNewRecordInstanceGACC(row);
	}
	
	
	function resetGlobalVars(){
		objGIACS070.company = null;
		objGIACS070.branch = null;
		
		objACGlobal.callingForm = null;
		objACGlobal.withOp = null;
		objACGlobal.tranId = null;
		objACGlobal.fundCd = null;
		objACGlobal.branchCd = null;
		objACGlobal.opReqTag = null;
		objACGlobal.opTag = null;
		objACGlobal.orTag = null;
		objACGlobal.tranSource = null;
		objACGlobal.tranClass = null;
		objACGlobal.queryOnly = null;
		objACGlobal.hidObjGIACS070 = {};
	}
	
	function toggleFields(action){
		if (action == "enterQuery"){
			$("hidGfunFundCd").clear();
			$("hidBranchCd").clear();
			$("txtCompany").clear();
			$("txtBranch").clear();
			$("txtCompany").readOnly = false;
			$("txtBranch").readOnly = true;
			enableSearch("searchCompanyLOV");
			disableSearch("searchBranchLOV");
			disableButton("btnDetails");
			disableButton("btnAcctgEntries");
			disableButton("btnOPInfo");
			disableButton("btnDVInfo");
			disableButton("btnDummy");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtCompany").focus();
			journalEntTG._refreshList();
			resetGlobalVars();
		}else if(action == "executeQuery"){
			objGIACS070.company = $F("txtCompany");
			objGIACS070.branch = $F("txtBranch");
			$("txtCompany").readOnly = true;
			$("txtBranch").readOnly = true;
			disableSearch("searchCompanyLOV");
			disableSearch("searchBranchLOV");
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function printOpt(){
		if (selectedRow != null){
			if (selectedRow.tranFlag == "C" || selectedRow.tranFlag == "P"){
				objACGlobal.callingForm = "GIACS070";
				/*objACGlobal.gaccTranId = selectedRow.tranId;
				objACGlobal.fundCd = selectedRow.fundCd;
				objACGlobal.branchCd = selectedRow.branchCd;*/
				objACGlobal.hidObjGIACS070.gaccTranId = selectedRow.tranId;
				objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
				objACGlobal.hidObjGIACS070.giopGaccFundCd = selectedRow.fundCd;
				objACGlobal.hidObjGIACS070.giopGaccBranchCd = selectedRow.branchCd;
				
				objACGlobal.tranClass = selectedRow.tranClass;
				
				showGenericPrintDialog("JV Printing",printReport, addCheckbox, true); 
			}else{
				showMessageBox("This facility is for closed and posted transactions only!", "E");
				return false;
			}
		}	
	}
	
	function addCheckbox(){
		var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td style='padding-right: 25px;'>Type of report</td><td><input type='radio' id='rdoSlCode' name='byCode' checked='checked' style='float: left; margin-top: 1px;'/><label for='rdoSlCode'>PER_SL_CODE</label></td></tr><tr><td></td><td><input type='radio' id='rdoGlAcctId' name='byCode' style='float: left; margin-top: 1px;'/><label for='rdoGlAcctId'>PER_GL_ACCT_ID</label></td></tr></table>"; 
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "250px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
			
	}
	
	function printReport() {
		try {
			if ($("rdoSlCode").checked){
				reportId = "GIAGR02A";
			}else if ($("rdoGlAcctId").checked){
				reportId = "GIAGR03A";
			}
			
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			
			var content = contextPath+"/GeneralLedgerPrintController?action=printReport"+"&fileType="+fileType
						+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
						+"&reportId="+reportId+"&fileType=PDF&reportTitle=JOURNAL VOUCHER"
						+"&tranId="+selectedRow.tranId+"&branchCd="+selectedRow.branchCd
						+"&tranClass="+selectedRow.tranClass;	
			
			printGenericReport(content, "JOURNAL VOUCHER", 
								function(){
									if(objGIACS070.dest == "printer"){
										showWaitingMessageBox("Printing complete.", "I", function(){
											objGIACS070.dest = null;
										});
									}
			});
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
		
	
	/*** CGRI$CHK_GIAC_ACCTRANS program unit not created here 
	 *** because the block's delete_allowed is set to false
	 *** MAKE_BLK_NON_QUERY/MAKE_BLOCK_QUERY_ONLY is not created here 
	 *** because cancelOpt will not be called
	 ***/
	
	function cancelOpt(){
		/* not created because :PARAMETER.label is not being changed to 'CANCEL',
		** items' properties (insert_allowed and update_allowed) are set to false
		** and block's [GACC] delete_allowed is set to false
		*/
	}
	
	function showGIACS070CompanyLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtCompany").trim() == "" ? "%" : $F("txtCompany"));	
		
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS003CompanyLOV",
				searchString: searchString
			},
			title: "Valid Values for Fund",
			width: 455,
			height: 388,
			autoSelectOneRecord: true, 
			columnModel : [
               {
            	   id : "fundCd",
            	   title: "Code",
            	   width: '120px'
               },
               {
            	   id: "fundDesc",
            	   title: "Description",
            	   width: '319px'
               }
              ],
			draggable: true,
			filterText: escapeHTML2(searchString),
			onSelect: function(row) {
				 if(row != null || row != undefined){ 
					$("hidGfunFundCd").value = unescapeHTML2(row.fundCd);
					$("txtCompany").value = unescapeHTML2(row.fundCd)+" - "+unescapeHTML2(row.fundDesc);
					enableToolbarButton("btnToolbarEnterQuery");
					$("txtBranch").readOnly = false;
					$("txtBranch").clear();
					$("txtBranch").focus();
					enableSearch("searchBranchLOV");
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			},

			onCancel: function(){
				$("txtCompany").focus();
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtCompany").value = $("txtCompany").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtCompany");
			} 
		});
	}
	
	function showGIACS070BranchLOV(isIconClicked){		
		var searchString = isIconClicked ? "%" : ($F("txtBranch").trim() == "" ? "%" : $F("txtBranch"));	
			
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS003BranchLOV",
				fundCd: $F("hidGfunFundCd"),
				moduleId: 'GIACS070',
				searchString: searchString
			},
			title: "Valid Values for Branch",
			width: 455,
			height: 388,
			filterText:	escapeHTML2(searchString),
			autoSelectOneRecord: true,
			columnModel : [
			               {
			            	   id : "branchCd",
			            	   title: "Code",
			            	   width: '50px'
			               },
			               {
			            	   id : "fundDesc",
			            	   title: "Fund",
			            	   width:   '200px',
			            	   visible: true  
			               },
			               {
			            	   id: "branchName",
			            	   title: "Branch",
			            	   width: '200px'
			               }
			              ],
			draggable: true,
			onSelect: function(row)  {	
				if (row != null || row != undefined){
					$("hidBranchCd").value = unescapeHTML2(row.branchCd);;
					$("txtBranch").value = unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName);
					$("txtBranch").setAttribute("lastValidValue", unescapeHTML2(row.branchCd)+" - "+unescapeHTML2(row.branchName));
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				}				
			},
			onCancel: function(){
				$("txtBranch").focus();
				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				$("txtBranch").value = $("txtBranch").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranch");
			} 
		});
	}
	
	if (objACGlobal.callingForm == "GIACS230"){
		$("btnOPInfo").value = "OR Info";
		//set where tran_id = objACGlobal.gaccTranId
		journalEntTG.url = contextPath+"/GIACInquiryController?action=showViewJournalEntriesPage&refresh=1&objFilter={\"tranId\":\""
						  +objACGlobal.hidObjGIACS070.giopGaccTranId+"\"}";
		journalEntTG._refreshList();
	}else{
		objACGlobal.withOp = '${globalWithOp}';
		objACGlobal.orFlag = "";	//added to match ':GLOBAL.or_flag does not exist' in CS
		if(objACGlobal.withOp == "Y"){
			objACGlobal.opReqTag = 'Y';
			objACGlobal.opTag = 'S';
			objACGlobal.orTag = null;
		}else{
			objACGlobal.opReqTag = 'N';
			objACGlobal.opTag = null;
			objACGlobal.orTag = 'S';
			$("btnOPInfo").value = "OR Info";
		}
	}
	
	if (objGIACS070.fromMainMenu == false){
		$("txtCompany").value = objGIACS070.company;
		$("txtBranch").value = objGIACS070.branch;
		$("hidGfunFundCd").value = objACGlobal.hidObjGIACS070.giopGaccFundCd;
		$("hidBranchCd").value = objACGlobal.hidObjGIACS070.giopGaccBranchCd;
		journalEntTG.url = contextPath+"/GIACInquiryController?action=showViewJournalEntriesPage&refresh=1&gfunFundCd="
				   			+$F("hidGfunFundCd")+"&gibrBranchCd="+$F("hidBranchCd");
		$("acExit").hide();
		toggleFields("executeQuery");
	}
	
	$("searchCompanyLOV").observe("click", function(){
		/*var findText2 = $F("txtCompany").trim() == "" ? "%" : $F("txtCompany");
		showGIACS003CompanyLOV(findText2, "GIACS070");*/
		showGIACS070CompanyLOV(true);
	});
	
	
	$("txtCompany").observe("change", function(){
		/*var findText2 = $F("txtCompany").trim() == "" ? "%" : $F("txtCompany");
		var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIACS003CompanyLOV",findText2,"Searching Fund, please wait...");
		if (cond == 2) {
			showGIACS003CompanyLOV(findText2,'GIACS070');
			disableToolbarButton("btnToolbarExecuteQuery");	
		} else if(cond == 0) {
			/*this.clear();
			showMessageBox("There is no record found.", imgMessage.INFO);* /
			showGIACS003CompanyLOV(findText2,'GIACS070');
			$("txtCompany").focus();
			disableToolbarButton("btnToolbarExecuteQuery");	
		}else{
			this.value = cond.rows[0].fundCd+" - "+unescapeHTML2(cond.rows[0].fundDesc);
			$("hidGfunFundCd").value = cond.rows[0].fundCd;
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtBranch").readOnly = false;
			$("txtBranch").clear();
			$("txtBranch").focus();
			enableSearch("searchBranchLOV");
		}*/
		
		if(this.value != ""){
			showGIACS070CompanyLOV(false);
		}else{
			$("hidGfunFundCd").clear();	
		}
	});
	
	$("searchBranchLOV").observe("click", function(){
		/*var findText2 = $F("txtBranch").trim() == "" ? "%" : $F("txtBranch");
		showGIACS003BranchLOV('GIACS070', $F("hidGfunFundCd"), findText2);*/
		showGIACS070BranchLOV(true);
	});
	
	
	$("txtBranch").observe("change", function(){
		/*$("hidBranchCd").value = $F("txtBranch");
		var findText2 = $F("txtBranch").trim() == "" ? "%" : $F("txtBranch");
		var cond = validateTextFieldLOV("/AccountingLOVController?action=getGIACS003BranchLOV&moduleId=GIACS070&fundCd="+$F("hidGfunFundCd"),findText2,"Searching Branch, please wait...");
		if (cond == 0){
			/*this.clear();
			showMessageBox("There is no record found.", imgMessage.INFO);* /
			showGIACS003BranchLOV('GIACS070', $F("hidGfunFundCd"), findText2);
			$("txtBranch").focus();
			disableToolbarButton("btnToolbarExecuteQuery");	
		}else if(cond == 2){
			showGIACS003BranchLOV('GIACS070', $F("hidGfunFundCd"), findText2);
			disableToolbarButton("btnToolbarExecuteQuery");	
		}else{
			this.value = cond.rows[0].branchCd+" - "+unescapeHTML2(cond.rows[0].branchName);
			$("hidBranchCd").value = cond.rows[0].branchCd;enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}*/
		if(this.value != ""){
			showGIACS070BranchLOV(false);
		}else{
			$("hidBranchCd").clear();	
		}
	});
	
	function getDVInfo(btnId){
		new Ajax.Request(contextPath+"/GIACInquiryController", {
			parameters: {
				action:		"getDvInfoGiacs070",
				tranId:		selectedRow.tranId
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var json = JSON.parse(response.responseText);
					var docCd = null;
					
					objACGlobal.gaccTranId = json.gaccTranId;
					objACGlobal.dvTag = json.dvTag;
					objACGlobal.cancelDv = json.cancelDv;
					objACGlobal.hidObjGIACS070.giopGaccTranId = json.gaccTranId;
					paramFormCall = json.formCall;
					objACGlobal.refId = json.gprqRefId;
					objACGlobal.paytRequestMenu = json.paytReqMenu;
					objACGlobal.cancelReq = json.cancelReq;

					objGIACS070.fromMainMenu = false;
					
					if (objACGlobal.paytRequestMenu == "CLM_PAYT_REQ_DOC"){
						docCd = "CPR";
					}else if (objACGlobal.paytRequestMenu == "FACUL_RI_PREM_PAYT_DOC"){
						docCd = "FPP";
					}else if (objACGlobal.paytRequestMenu == "COMM_PAYT_DOC"){
						docCd = "CP";
					}/*else if (objACGlobal.paytRequestMenu == "OTHER"){
						docCd = "OP";
					}else if (objACGlobal.paytRequestMenu == "CANCEL"){
						docCd = "CR";
					}*/else{
						docCd = "OP";
					}
					
					if (btnId == "btnDVInfo"){
						if (paramFormCall == "GIACS002"){
							objGIACS002.fundCd = selectedRow.fundCd;
							objGIACS002.branchCd = selectedRow.branchCd;
							showDisbursementVoucherPage(null, "getDisbVoucherInfo", "Y");
							$("acExit").show();
						}else if (paramFormCall == "GIACS016"){
							showDisbursementRequests(docCd);  //, selectedRow.branchCd);
							$("acExit").show();
						}
						journalEntTG.onRemoveRowFocus();
					}else if(btnId == "btnDetails"){
						new Ajax.Request(contextPath+"/GIACPaytRequestsController", {
							parameters: {
								action:		"showMainDisbursementPage",
								moduleId:	"GIACS070",
								disbursement : docCd,
								refId:		objACGlobal.refId
							},
							onComplete: function(response){
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									var json = JSON.parse(response.responseText);
									objGIACS070.taxFieldInfo = json;
									setGlobalVarForDetailsBtn();
								}
							}
						});
						
					}
										
				}
			}
		});
	}
	
	function getTaxInfoForDetailsDV(callingForm){
		if (callingForm == "DETAILS"){
			new Ajax.Request(contextPath + "/GIACDisbVouchersController", {
				parameters : {
					action : 	"getDisbVoucherInfo",
					fundCd:		selectedRow.fundCd,
					branchCd:	selectedRow.branchCd,
					gaccTranId : selectedRow.tranId,
					moduleId:	"GIACS070"
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function() {
				},
				onComplete : function(response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						objGIACS070.taxFieldInfo = JSON.parse(response.responseText);
						setGlobalVarForDetailsBtn();
					}
				}
			});
		}else if(callingForm == "DISB_REQ"){
			getDVInfo("btnDetails");
		}
	}
	
	function setGlobalVarForDetailsBtn(){
		objACGlobal.calledForm = null;
		objACGlobal.gaccTranId = selectedRow.tranId;
		objACGlobal.fundCd = selectedRow.fundCd;
		objACGlobal.branchCd = selectedRow.branchCd;
		objACGlobal.hidObjGIACS070.gaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccFundCd = selectedRow.fundCd;
		objACGlobal.hidObjGIACS070.giopGaccBranchCd = selectedRow.branchCd;
		if (selectedRow.tranFlag == "O" && selectedRow.tranClass == "JV"){
			objACGlobal.queryOnly = "N";
		}else{
			objACGlobal.queryOnly = "Y";	
		}					
		objGIACS070.fromMainMenu = false;
		journalEntTG.onRemoveRowFocus();
		
		if (/*objACGlobal.tranSource == "OP" || */objACGlobal.tranSource == "DV"){
			// call the details and avoid calling function loadDirectPremCollnsForm() 
			new Ajax.Updater("mainContents", contextPath+"/GIACOrderOfPaymentController?action=showORDetails&" ,{
				method: "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Loading Transaction Basic Information. Please wait...");
				},
				onComplete: function() {
					hideNotice("");	
				}
			}); 
		}else{
			showORInfo();			
		}
		$("acExit").show();
	}
	
	$("btnDetails").observe("click", function(){
		objGIACS070.selectedRow = selectedRow;
		objACGlobal.hidObjGIACS003.journalEntriesRow = selectedRow;
		
		if (selectedRow != null){
			if (selectedRow.tranClass == "COL"){
				objACGlobal.tranSource = "OP";
				objACGlobal.callingForm = "DETAILS";
				setGlobalVarForDetailsBtn();
			}else if (selectedRow.tranClass == "DV"){
				objACGlobal.tranSource = "DV";

				new Ajax.Request(contextPath+"/GIACInquiryController", {
					parameters: {
						action:		"chkPaytReqDtl",
						tranId:		selectedRow.tranId
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							objACGlobal.callingForm = unescapeHTML2(response.responseText);
							getTaxInfoForDetailsDV(objACGlobal.callingForm);
						}
					}
				});
			}else{
				objACGlobal.tranSource = "JV";
				objACGlobal.callingForm = "DETAILS";
				setGlobalVarForDetailsBtn();
			}			
		}
	});
	
	
	$("btnAcctgEntries").observe("click", function(){
		objACGlobal.hidObjGIACS003.journalEntriesRow = selectedRow;
		objACGlobal.tranSource = "JV";
		objACGlobal.callingForm = "ACCT_ENTRIES";
		objACGlobal.gaccTranId = selectedRow.tranId;
		objACGlobal.fundCd = selectedRow.fundCd;
		objACGlobal.branchCd = selectedRow.branchCd;
		objACGlobal.hidObjGIACS070.gaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccFundCd = selectedRow.fundCd;
		objACGlobal.hidObjGIACS070.giopGaccBranchCd = selectedRow.branchCd;
		if (selectedRow.tranFlag == "O" && selectedRow.tranClass == "JV"){
			objACGlobal.queryOnly = "N";
		}else{
			objACGlobal.queryOnly = "Y";	
		}					
		objGIACS070.fromMainMenu = false;
		journalEntTG.onRemoveRowFocus();
		try{
			showORInfoWithAcctEntries();
			
			$$("div[name='subMenuDiv']").each(function(row){
				row.hide();
			});
			$$("div.tabComponents1 a").each(function(a){
				if(a.id == "acctEntries") {
					$("acctEntries").up("li").addClassName("selectedTab1");					
				}else{
					a.up("li").removeClassName("selectedTab1");	
				}	
			});
			$("acExit").show();

		}catch(e){
			showErrorMessage("btnAcctgEntries - click", e);
		}
		
	});
	
	
	$("btnOPInfo").observe("click", function(){
		objGIACS070.fromMainMenu = false;
		objACGlobal.queryOnly = "Y";
		objACGlobal.tranSource = 'OP';
		objACGlobal.calledForm = null; 
		objACGlobal.callingForm = 'ACCT_ENTRIES';
		objACGlobal.gaccTranId = selectedRow.tranId;
		objACGlobal.fundCd = selectedRow.fundCd;
		objACGlobal.branchCd = selectedRow.branchCd;
		objACGlobal.hidObjGIACS070.gaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccFundCd = selectedRow.fundCd;
		objACGlobal.hidObjGIACS070.giopGaccBranchCd = selectedRow.branchCd;
		
		editORInformation();
		$("acExit").show();
		journalEntTG.onRemoveRowFocus();
	});
	
	
	$("btnDVInfo").observe("click", function(){
		objACGlobal.queryOnly = "Y";
		objACGlobal.tranSource = 'DV';
		objACGlobal.calledForm = null; 
		objACGlobal.callingForm = 'ACCT_ENTRIES';
		/*objACGlobal.gaccTranId = selectedRow.tranId;
		objACGlobal.fundCd = selectedRow.fundCd;
		objACGlobal.branchCd = selectedRow.branchCd;*/
		objACGlobal.hidObjGIACS070.gaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccTranId = selectedRow.tranId;
		objACGlobal.hidObjGIACS070.giopGaccFundCd = selectedRow.fundCd;
		objACGlobal.hidObjGIACS070.giopGaccBranchCd = selectedRow.branchCd;
		
		getDVInfo("btnDVInfo");
	});

	
	$("btnDummy").observe("click", function(){
		if (paramLabel == "PRINT"){
			printOpt();
		}else{
			cancelOpt();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		journalEntTG.onRemoveRowFocus();
		journalEntTG.url = contextPath+"/GIACInquiryController?action=showViewJournalEntriesPage&refresh=1";
		journalEntTG._refreshList();
		toggleFields("enterQuery");
		/*objGIACS070.fromMainMenu = null;
		resetGlobalVars();
		showGIACS070Page();*/
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv('fieldsDiv')){
			journalEntTG.url = contextPath+"/GIACInquiryController?action=showViewJournalEntriesPage&refresh=1&gfunFundCd="
						   +$F("hidGfunFundCd")+"&gibrBranchCd="+$F("hidBranchCd");
			journalEntTG._refreshList();
			toggleFields("executeQuery");
			
			if (journalEntTG.rows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtCompany");	
			}
		}		
	});
	
	$("btnToolbarExit").observe("click", function(){
		objACGlobal.gaccTranId = selectedRow == null ? null : selectedRow.tranId;
		objACGlobal.previousModule = null;
		objGIACS070.fromMainMenu = null;
		resetGlobalVars();
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>