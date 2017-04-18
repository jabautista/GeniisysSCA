<div id="viewRecordsMainDiv" name="viewRecordsMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="tableDiv" class="sectionDiv" style="height: 380px;">
		<div id="viewRecordsTableGridDiv" name="viewRecordsTableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 305px;"></div>
		<table style="margin-bottom: 10px;">
				<tr align="center">
					<td class="rightAligned" style="width:550px; padding-right: 5px;">Tagged Total</td>
					<td class="leftAligned">
						<input type="text" id="txtTaggedTotal" name="txtTaggedTotal" value="0.00" class="text rightAligned" readonly="readonly" style="width: 150px;" tabindex="101"/>
					</td>
				</tr>
				<tr align="center">
					<td class="rightAligned" style="width:550px; padding-right: 5px;">Grand Total</td>
					<td class="leftAligned">
						<input type="text" id="txtGrandTotal" name="txtGrandTotal" class="text rightAligned" readonly="readonly" style="width: 150px;" tabindex="101"/>
					</td>
				</tr>
			</table>
	</div>
	<div id="viewButtonsDiv" style="float: left; width: 100px; padding-left: 160px; margin-top: 10px;">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnViewDetails" name="btnViewDetails" value="View Details" style="width: 150px;" tabindex="201"/></td>
				<td><input type="button" class="button" id="btnGenerateBankFiles" name="btnGenerateBankFiles" value="Generate Bank File" style="width: 150px;" tabindex="202"/></td>
				<td><input type="button" class="button" id="btnReturnViewRecords" name="btnReturnViewRecords" value="Return" style="width: 150px;" tabindex="203"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	generateBankFilesArray = new Array();
	var editable = "";
	if (mode == 2) {
		editable = false;
	}else if (mode == 1) {
		editable = true;
	}
	var action = '${action}';
	var jsonRecords = JSON.parse('${jsonRecordsList}');	
	var row = 0;
	recordsTableModel = {
			url : contextPath+"/GIACGeneralDisbursementReportsController?action="+action+"&refresh=1&asOfDate="+$F("txtAsOfDate")+
							  "&intmType="+$F("txtIntmType")+"&intm="+$F("txtIntmNo")+"&bankFileNo="+objCurrBankFileNo,
			options: {
				width: '730px',
				height: '300px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objCurrParentIntmNo = tbgRecords.geniisysRows[y].parentIntmNo;
					objCurrParentIntmType = tbgRecords.geniisysRows[y].parentIntmType;
					//tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
					//tbgRecords.keys.releaseKeys();
				},
				prePager: function(){
					objCurrParentIntmNo = "";
					objCurrParentIntmType = "";
					tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
					tbgRecords.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
					objCurrParentIntmNo = "";
					objCurrParentIntmType = "";
					tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
					tbgRecords.keys.releaseKeys();
				},
				onSort : function(){
					objCurrParentIntmNo = "";
					objCurrParentIntmType = "";
					tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
					tbgRecords.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						objCurrParentIntmNo = "";
						objCurrParentIntmType = "";
						tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
						tbgRecords.keys.releaseKeys();
					},
					onRefresh: function(){
						objCurrParentIntmNo = "";
						objCurrParentIntmType = "";
						tbgRecords.keys.removeFocus(tbgRecords.keys._nCurrentFocus, true);
						tbgRecords.keys.releaseKeys();
					}
				}
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{	id: 'viewSw',
					titleAlign: 'center',
					altTitle: 'Check/uncheck all records.',
					width: '30px',
					visible: true,
					sortable: false,
					defaultValue: false,
					editable: editable,
					otherValue: false,
			    	editor: new MyTableGrid.CellCheckbox({
			    		onClick : function(value, checked) {
			    			getTaggedTotal();
							if (value == "Y") {
								tbgRecords.geniisysRows[row].viewSw = "Y";
							}else {
								tbgRecords.geniisysRows[row].viewSw = "N";
							}
						},
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
					id : "parentIntmType",
					title: "Type",
					width: '130px',
					sortable: true,
					filterOption: true
				},
				{
					id : "parentIntmName",
					title: "Intermediary",
					width: '370px',
					titleAlign: 'left',
					align: 'left',
					sortable: true,
					filterOption: true
				},
				{
					id : "netCommDue",
					title: "Net Comm Due",
					width: '160px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: jsonRecords.rows
		};
	
	tbgRecords = new MyTableGrid(recordsTableModel);
	tbgRecords.pager = jsonRecords;
	tbgRecords.render('viewRecordsTableGridDiv');
	tbgRecords.afterRender = function() {
		if (mode == 2) {
			for ( var a = 0; a < tbgRecords.rows.length; a++) {
				$("mtgInput"+tbgRecords._mtgId+"_2,"+a).checked = true; 
			}
		}
		getTotalAmount();
	};
	
	function getTaggedTotal() {
		var totTagged = 0.00;
		for ( var i = 0; i < tbgRecords.rows.length; i++) {
			if (tbgRecords.rows[i][tbgRecords.getColumnIndex('viewSw')] == 'Y') {
				var val = tbgRecords.rows[i][tbgRecords.getColumnIndex('netCommDue')];
				totTagged = parseFloat(totTagged) + parseFloat(val);
			}
		}
		$("txtTaggedTotal").value = formatCurrency(totTagged);
	}
	
	function getTotalAmount() {
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
			parameters: {
				action: "getTotal",
				subAct: action,
				bankFileNo: objCurrBankFileNo
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					tempArray = JSON.parse(response.responseText);
					for ( var b = 0; b < tempArray.rec.length; b++) {
						$("txtGrandTotal").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['netCommDue'], "0")));
					}
				}
			}							 
		});	
	}

	function showViewDetails(action){
		overlayViewDetails = Overlay.show(contextPath + "/GIACGeneralDisbursementReportsController", {
			urlContent : true,
			urlParameters : {action : action,
				parentIntmNo: objCurrParentIntmNo,
				parentIntmType: objCurrParentIntmType,
				asOfDate: $F("txtAsOfDate"),
				bankFileNo: objCurrBankFileNo
			},
			title : 'View Details',
			height : '510px',
			width : '910px',
			draggable : true
		});		
	}
	
	function generateBankFile(parentIntmNo,viewSw) {
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController", {
			parameters: {
				action: "generateBankFile",
				asOfDate: $F("txtAsOfDate"),
				intmType: $F("txtIntmType"),
				intm: $F("txtIntmNo"),
				parentIntmNo: parentIntmNo,
				viewSw: viewSw
			},
			asynchronous: true,	// start AFP SR-18481 : shan 05.21.2015
			evalScripts: true,
			onCreate: showNotice("Generating Bank File, please wait..."),
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					objCurrBankFileNo = response.responseText;
					//showGenericPrintDialog("Print Commissions Due", printReport, addPrintForm, true); //placed after calling this function in getTaggedRecordsForGenerate() : shan 05.04.2015	// end AFP SR-18481 : shan 05.21.2015
				}
			}
		});			
	}
	
	fileName = "";
	function generateSummaryForBank() {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {
				action : "generateSummaryForBank",
				bankFileNo : objCurrBankFileNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Generating Summary For Bank file, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var url = response.responseText;
					if ($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined) {
						showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
					} else {
						var message = $("geniisysAppletUtil").copyFileToLocal(url, "ups");
						if (message.include("SUCCESS")) {
							fileName = message.substring(9);
							showMessageBox("File generated to " + message.substring(9), "I");
							overlayGenericPrintDialog.close();	// AFP SR-18481 : shan 05.21.2015
						} else {
							showMessageBox(message, "E");
						}
					}
					deleteUpsFile(url);
				}
			}
		});			
	}

	function deleteUpsFile(url) {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {
				action : "deleteSummaryForBankFile",
				url : url
			}
		});
	}
	
	function printReport(){
		try {
			if ($("commissionVoucher").checked == true) {
				//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
				overlayViewRecords.close();
				if (overlayViewBankFiles != null) overlayViewBankFiles.close();	// AFP SR-18481 : shan 05.21.2015
				try{
					new Ajax.Request(contextPath + "/GIACCommissionVoucherController",{
						parameters: {
							action : "showBatchCommVoucherPrinting",	// AFP SR-18481 : shan 05.21.2015
							bankFileNo : objCurrBankFileNo	// AFP SR-18481 : shan 05.21.2015
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function (){
							showNotice("Loading, please wait...");
						},
						onComplete : function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)){
								//$("dynamicDiv").update(response.responseText);	// start AFP SR-18481 : shan 05.21.2015
								objACGlobal.previousModule = "GIACS158";
								$("GIACS251Div").update(response.responseText);
								$("GIACS251Div").show();
								$("commissionsDueMainDiv").hide();
								mode = 0;
								overlayGenericPrintDialog.close();	// end AFP SR-18481 : shan 05.21.2015
							}
						}
					});
				}catch(e){
					showErrorMessage("showGIACS251", e);
				}
			}else {
				generateSummaryForBank();
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	function addPrintForm(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'><tr><td><input type='radio' id='summaryForBank' name='printRdo' style='float: left; margin-bottom: 3px;'><label style='margin-top: 2px; margin-right: 10px;' for='summaryForBank'>Summary for Bank</label></td>"+
						  "<td><input type='radio' id='commissionVoucher' name='printRdo' style='float: left; padding-bottom: 3px; margin-bottom: 3px;'><label for='commissionVoucher'>Commission Voucher</label></td></tr>";
			$("printDialogFormDiv3").update(content); 
			$("printDialogFormDiv3").show();
			$("printDialogFormDiv").hide();
			$("printDialogMainDiv").up("div",1).style.height = "100px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "130px";
			enableButton("btnPrint");	// AFP SR-18481 : shan 05.21.2015
			
			$("summaryForBank").checked = true;
			
		}catch(e){
			showErrorMessage("addPrintForm", e);	
		}
	}
	
	function getTaggedRecordsForGenerate() {
		if (tbgRecords.rows.length != 0) {
			for ( var a = 0; a < tbgRecords.rows.length; a++) {
				if (tbgRecords.geniisysRows[a].viewSw == "Y") {
					generateBankFile(tbgRecords.geniisysRows[a].parentIntmNo,"Y");
				}else {
					generateBankFile("","N");
				}
			}
		}else {
			generateBankFile("","N");
		}

		showGenericPrintDialog("Print Commissions Due", printReport, addPrintForm, true);	// AFP SR-18481 : shan 05.21.2015
	}
	
	$("btnViewDetails").observe("click", function() {
		if (objCurrParentIntmNo != "" ) {
			if (mode == 1) {
				showViewDetails("viewDetailsViaRecords");
			}else if (mode == 2) {
				showViewDetails("viewDetailsViaBankFiles");
			}
		}else {
			showMessageBox("Please select a record first.", imgMessage.INFO);
		}
	});
	
	$("btnGenerateBankFiles").observe("click", function() {
		if (mode == 1) {
			getTaggedRecordsForGenerate();	
		}else {
			showGenericPrintDialog("Print Commissions Due", printReport, addPrintForm, true);
		}
	});
	
	$("btnReturnViewRecords").observe("click", function() {
		objCurrParentIntmNo = "";
		objCurrParentIntmType = "";
		overlayViewRecords.close();
	});
	
</script>