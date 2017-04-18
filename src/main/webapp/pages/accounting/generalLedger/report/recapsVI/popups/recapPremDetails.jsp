<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="recapPremDetailsMainDiv" name="recapPremDetailsMainDiv" style="float: left; width: 820px;">
	<div class="sectionDiv" style="margin: 10px 2px 5px 2px; float: left; width: 810px;">
		<div id="regionTGDiv" name="regionTGDiv" style="height:230px; margin: 10px 10px 10px 10px; width: 780px;"></div>
	</div>
	
	<div class="sectionDiv" style="margin: 0 2px 10px 2px; float: left; width: 810px;">
		<div id="recapDetailsTGDiv" name="recapDetailsTGDiv" style="height:235px; margin: 10px 10px 0 10px; width: 790px;"></div>
		
		<div id="totalAmtDiv" name="totalAmtDiv" style="width: 790px; margin: 0 10px 10px 10px;">
			<table border="0" style="margin-left:550px; ">
				<tr>
					<td class="rightAligned">Total</td>
					<td><input type="text" id="txtTotalAmt" name="txtTotalAmt" style="margin-left:5px; width: 180px; text-align:right;" /></td>	
				</tr>
			</table>
		</div>
	</div>
	
	<div class="buttonsDiv" style="margin: 5px 5px 5px 5px; float: left; width: 800px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:90px;" />
		<input type="button" class="button" id="btnPrintRecapDtl" name="btnPrintRecapDtl" value="Print" style="width:90px;" />
	</div>
</div>

<script type="text/javascript">	
	objRecapsVI.recapDtlType = ('${recapDtlType}');
	objRecapsVI.regionTableGrid = JSON.parse('${recapRegionList}');
	objRecapsVI.regionDtlRows = objRecapsVI.regionTableGrid.rows || [];
	objRecapsVI.regionSelectedRow = null;

	try {
		regionTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showRecapRegionDetails&refresh=1&type="+objRecapsVI.recapDtlType,
				id: 1,
				options: {
					id: 1,
		          	height: '208px',
		          	width: '790px',
		          	onCellFocus: function(element, value, x, y, id){
		          		objRecapsVI.regionSelectedRow = regionTableGrid.geniisysRows[y];
		          		refreshCurrentTableGrid(objRecapsVI.regionSelectedRow.regionCd, objRecapsVI.regionSelectedRow.indGrpCd, objRecapsVI.recapDtlType);
		          		regionTableGrid.keys.removeFocus(regionTableGrid.keys._nCurrentFocus, true);
		          		regionTableGrid.keys.releaseKeys();
		            },
		            onRemoveRowFocus: function(){
		            	objRecapsVI.regionSelectedRow = null;
		            	refreshCurrentTableGrid(null, null, objRecapsVI.recapDtlType);
		            	$("txtTotalAmt").value = "";
		            	regionTableGrid.keys.removeFocus(regionTableGrid.keys._nCurrentFocus, true);
		            	regionTableGrid.keys.releaseKeys();
		            },
		            toolbar: {
		            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            	onRefresh: function(){
		            		refreshCurrentTableGrid(null, null, objRecapsVI.recapDtlType);
		            	}
		            }
				},
				columnModel:[
							{   id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id: 'regionCd',
								title: 'Region Code',
								visible: false,
								width: '0px'
							},
							{	id: 'indGrpCd',
								title: 'Ind Grp Cd',
								width: '0px',
								visible: false
							},
							{	id: 'regionDesc',
								title: 'Region',
								width: '265px',
								filterOption: true
							},
							{	id: 'indGrpNm',
								title: 'Industry',
								width: '490px',
								filterOption: true
							}
							],
				rows: objRecapsVI.regionDtlRows
			};
			regionTableGrid = new MyTableGrid(regionTableModel);
			regionTableGrid.pager = objRecapsVI.regionTableGrid;
			regionTableGrid.render('regionTGDiv');
	} catch(e){
		showErrorMessage("region table grid: ", e);
	}
	
	/*
	 * For recapDtlType = premium
	 *
	 */
	if(objRecapsVI.recapDtlType == "premium"){
		objRecapsVI.premDtlsTableGrid = JSON.parse('${recapDtlList}');
		objRecapsVI.premDtlRows = objRecapsVI.premDtlsTableGrid.rows || [];
		objRecapsVI.premSelectedRow = null;
		
		try {
			var regionCode = objRecapsVI.regionSelectedRow == null ? "" : nvl(objRecapsVI.regionSelectedRow.regionCd, "");
			var industryCode = objRecapsVI.regionSelectedRow == null ? "" : nvl(objRecapsVI.regionSelectedRow.indGrpCd, "");
			
			premTableModel = {
					url: contextPath+"/GIPIPolbasicController?action=showRecapDetails&refresh=1&type=premium"
								+ "&regionCd="	+ regionCode 
								+ "&indGrpCd="	+ industryCode,
					id: 2,
					options: {
						id: 2,
			          	height: '208px',
			          	width: '790px',
			          	onCellFocus: function(element, value, x, y, id){
			          		objRecapsVI.premSelectedRow = premTableGrid.geniisysRows[y];
			          		premTableGrid.keys.removeFocus(premTableGrid.keys._nCurrentFocus, true);
			          		premTableGrid.keys.releaseKeys();
			            },
			            onRemoveRowFocus: function(){
			            	objRecapsVI.premSelectedRow = null;
			            	premTableGrid.keys.removeFocus(premTableGrid.keys._nCurrentFocus, true);
			            	premTableGrid.keys.releaseKeys();
			            },
			            toolbar: {
			            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			            }
					},
					columnModel:[
								{   id: 'recordStatus',
								    width: '0px',
								    visible: false,
								    editor: 'checkbox'
								},
								{	id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{	id: 'regionCd',
									title: 'Region Code',
									visible: false,
									width: '0px'
								},
								{	id: 'indGrpCd',
									title: 'Ind Grp Cd',
									width: '0px',
									visible: false
								},
								{	id: 'sumPremAmt',
									title: 'Sum Premium Amount',
									visible: false,
									geniisysClass: 'money',
									width: '0px'
								},
								{	id: 'policyId',
									title: 'Policy Id',
									visible: false,
									width: '0px'
								},
								{	id: 'assdNo',
									title: 'Assd No',
									visible: false,
									width: '0px'
								},
								{	id: 'policyNo',
									title: 'Policy No',
									width: '270px',
									filterOption: true
								},
								{	id: 'assdName',
									title: 'Assured Name',
									width: '300px',
									filterOption: true
								},
								{	id: 'premiumAmt',
									title: 'Premium Amount',
									titleAlign: 'right',
									align: 'right',
									geniisysClass: 'money',
									width: '180px',
									filterOption: true,
									filterOptionType: 'number'
								}						
								],
					rows: objRecapsVI.premDtlRows
				};
				premTableGrid = new MyTableGrid(premTableModel);
				premTableGrid.pager = objRecapsVI.premDtlsTableGrid;
				premTableGrid.render('recapDetailsTGDiv');
				premTableGrid.afterRender = function(){
					for ( var i = 0; i < premTableGrid.geniisysRows.length; i++) {
						$("txtTotalAmt").value = formatCurrency(premTableGrid.geniisysRows[i].sumPremAmt);
						break;
					}					
				};
		} catch(e){
			showErrorMessage("prem details table grid: ", e);
		}
	} // end if: recapDtlType = premium
	
	/*
	 * For recapDtlType = losses
	 *
	 */
	if(objRecapsVI.recapDtlType == "losses"){
			objRecapsVI.lossDtlsTableGrid = JSON.parse('${recapDtlList}');
			objRecapsVI.lossDtlRows = objRecapsVI.lossDtlsTableGrid.rows || [];
			objRecapsVI.lossSelectedRow = null;
			
			try {
				var regionCode = objRecapsVI.regionSelectedRow == null ? "" : nvl(objRecapsVI.regionSelectedRow.regionCd, "");
				var industryCode = objRecapsVI.regionSelectedRow == null ? "" : nvl(objRecapsVI.regionSelectedRow.indGrpCd, "");
				
				lossTableModel = {
						url: contextPath+"/GIPIPolbasicController?action=showRecapDetails&refresh=1"
									+ "&type="		+ objRecapsVI.recapDtlType
									+ "&regionCd="	+ regionCode 
									+ "&indGrpCd="	+ industryCode,
						id: 3,
						options: {
							id: 3,
				          	height: '208px',
				          	width: '790px',
				          	onCellFocus: function(element, value, x, y, id){
				          		objRecapsVI.lossSelectedRow = lossTableGrid.geniisysRows[y];
				          		lossTableGrid.keys.removeFocus(lossTableGrid.keys._nCurrentFocus, true);
				          		lossTableGrid.keys.releaseKeys();
				            },
				            onRemoveRowFocus: function(){
				            	objRecapsVI.lossSelectedRow = null;
				            	lossTableGrid.keys.removeFocus(lossTableGrid.keys._nCurrentFocus, true);
				            	lossTableGrid.keys.releaseKeys();
				            },
				            toolbar: {
				            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				            }
						},
						columnModel:[
									{   id: 'recordStatus',
									    width: '0px',
									    visible: false,
									    editor: 'checkbox'
									},
									{	id: 'divCtrId',
										width: '0px',
										visible: false
									},
									{	id: 'regionCd',
										title: 'Region Code',
										visible: false,
										width: '0px'
									},
									{	id: 'indGrpCd',
										title: 'Ind Grp Cd',
										width: '0px',
										visible: false
									},
									{	id: 'totalLossAmt',
										title: 'Total Loss Amount',
										visible: false,
										geniisysClass: 'money',
										width: '0px'
									},
									{	id: 'policyId',
										title: 'Policy Id',
										visible: false,
										width: '0px'
									},
									{	id: 'assdNo',
										title: 'Assd No',
										visible: false,
										width: '0px'
									},
									{	id: 'policyNo',
										title: 'Policy No',
										width: '220px',
										filterOption: true
									},
									{	id: 'claimNo',
										title: 'Claim No',
										width: '150px',
										filterOption: true
									},
									{	id: 'assdName',
										title: 'Assured Name',
										width: '250px',
										filterOption: true
									},
									{	id: 'lossAmt',
										title: 'Loss Amount',
										titleAlign: 'right',
										align: 'right',
										geniisysClass: 'money',
										width: '128px',
										filterOption: true,
										filterOptionType: 'number'
									}						
									],
						rows: objRecapsVI.lossDtlRows
					};
					lossTableGrid = new MyTableGrid(lossTableModel);
					lossTableGrid.pager = objRecapsVI.lossDtlsTableGrid;
					lossTableGrid.render('recapDetailsTGDiv');
					lossTableGrid.afterRender = function(){
						for ( var i = 0; i < lossTableGrid.geniisysRows.length; i++) {
							$("txtTotalAmt").value = formatCurrency(lossTableGrid.geniisysRows[i].totalLossAmt);
							break;
						}
					};
			} catch(e){
				showErrorMessage("loss details table grid: ", e);
			}
		} // end if: recapDtlType = losses
	
	
	function refreshCurrentTableGrid(region, industry, type){
		if(type == "premium"){
			premTableGrid.url = contextPath+"/GIPIPolbasicController?action=showRecapDetails&refresh=1"
								+ "&type="		+ type
								+ "&regionCd="	+ nvl(region, "")
								+ "&indGrpCd="	+ nvl(industry, "");
			premTableGrid.refresh();
		} else if(type == "losses"){
			lossTableGrid.url = contextPath+"/GIPIPolbasicController?action=showRecapDetails&refresh=1"
								+ "&type="		+ type
								+ "&regionCd="	+ nvl(region, "")
								+ "&indGrpCd="	+ nvl(industry, "");	          		
			lossTableGrid.refresh();
		}
		
	}
	
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try { 
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				var noOfCopies = parseInt($F("txtNoOfCopies"));
				
				if(noOfCopies < 1){
					noOfCopies = 1;
					$("txtNoOfCopies").value = "1";
				}
				
				var includeEndt = ""; //Dren Niebres 07.18.2016 SR-5336 - Start
				
				 if ($("rdoSummarizedPol").checked == true) {
					includeEndt = "N";
				} else {
					includeEndt = "Y";
				} //Dren Niebres 07.18.2016 SR-5336 - End
				
				if (reportId == "GIPIR203A") {
					if ($("rdoPdf").disabled == false && $("rdoCsv").disabled == false) {
						if ($("rdoPdf").checked == true) {
							fileType = "PDF";
						} else {
							fileType = "CSV2";
							reportId = "GIPIR203A_CSV"							
						}
					} 
				} else {
					if ($("rdoPdf").disabled == false && $("rdoCsv").disabled == false) {
						fileType = $("rdoPdf").checked ? "PDF" : "CSV";
					} 
				}				
				
				var content = contextPath+"/GeneralLedgerPrintController?action=printReport"
							+ "&noOfCopies=" 	+ noOfCopies
							+ "&printerName=" 	+ $F("selPrinter")
							+ "&destination=" 	+ $F("selDestination")
							+ "&reportId=" 		+ reportId
							+ "&reportTitle=" 	+ reportTitle
							+ "&fileType=" 		+ fileType
							+ "&includeEndt="   + includeEndt;	//Dren Niebres 07.18.2016 SR-5336
							
				var withCsv = ""; // added by carlo de guzman 3.14.2016
				if(fileType ==  "CSV" || fileType ==  "CSV2"){withCsv = "Y"} //Dren Niebres 07.18.2016 SR-5336
				else{withCsv = ""}							
							
				printGenericReport(content, reportTitle, null, withCsv); //Dren Niebres 09.30.2016 SR-5336
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	// Executes when-button-pressed trigger for btn_print: Checks if records exist before printing
	function checkGipis203ExtractedRecordsBeforePrint(rdoGroup1, rdoGroup2){
		try {
			new Ajax.Request(contextPath + "/GIPIPolbasicController",{
				method: "POST",
				parameters: {
					action: "checkExtractedRecordsBeforePrint",
					rdoGroup1: rdoGroup1,
					rdoGroup2: rdoGroup2
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Checking extracted records, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(response.responseText == "FALSE"){
							// if(rdoGroup1 == "summary"){
							//validateReportId("GIPIR203", "Recapitulation Report");
							//} else {
								if(rdoGroup2 == "premium"){
									validateReportId("GIPIR203A", "Recapitulation Report Detail");
								} else {
									validateReportId("GIPIR203B", "Recapitulation Report Detail");
								}
							//}
						} else {
							showMessageBox("No records to print. Please extract the records first.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("checkGipis203ExtractedRecordsBeforePrint: ", e);
		}
	}
	
	function printFunc(){
		checkGipis203ExtractedRecordsBeforePrint(objRecapsVI.rdoGroup1, objRecapsVI.rdoGroup2);
		/*if(objRecapsVI.rdoGroup1 == "summary"){
			checkGipis203ExtractedRecordsBeforePrint(objRecapsVI.rdoGroup1, "");
		} else if(objRecapsVI.rdoGroup1 == "detail"){
			checkGipis203ExtractedRecordsBeforePrint("", objRecapsVI.rdoGroup2);	
		}*/
	}
	
	$("btnReturn").observe("click", function(){
		$("rdoPdf").checked = true; //Dren Niebres 12.09.2016 SR-5336
		recapDetailsOverlay.close();
	});
	
	$("btnPrintRecapDtl").observe("click", function(){
		showGenericPrintDialog("Print Recapitulation", printFunc, function(){$("csvOptionDiv").show();}, true);  //Dren Niebres 09.30.2016 SR-5336
	});
</script>