<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<c:if test="${isCloseClaim eq 'Y'}">
	<div id="batchOsLossMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</c:if>

<div id="flaMainDiv" name="flaMainDiv" style="margin-top: 1px; display: none;">
	<form id="flaMainForm" name="flaMainForm">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Claim Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="groDiv" name="groDiv">
			<div id="claimInfoDiv" name="claimInfoDiv" class="sectionDiv" style="height: 105px; padding-top: 15px;">
				<div id="claimInfoTableDiv" name="claimInfoTableDiv" style=" margin-left: 110px;">
					<table>
						<tr>
							<td align="right">Claim No.</td>
							<td colspan="3"><input type="text" id="claimNo" name="claimNo" readonly="readonly" style="width: 225px;"></td>
							<td align="right"><label style="margin-left: 20px;">Loss Category</label></td>
							<td><input type="text" id="lossCat" name="lossCat" readonly="readonly" style="width: 225px;"></td>
						</tr>
						<tr>
							<td align="right">Policy No.</td>
							<td colspan="3"><input type="text" id="policyNo" name="policyNo" readonly="readonly" style="width: 225px;"></td>
							<td align="right">Loss Date</td>
							<td><input type="text" id="lossDate" name="lossDate" readonly="readonly" style="width: 225px;"></td>
						</tr>
						<tr>
							<td align="right">Assured Name</td>
							<td colspan="5"><input type="text" id="assdName" name="assdName" readonly="readonly" style="width: 225px;"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Advice Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="groDiv2" name="groDiv2">
			<div id="adviceDtlsDiv" name="adviceDtlsDiv" class="sectionDiv" style="height: 170px; padding-top: 15px;">
				<div id="adviceDtlsTGDiv" name="adviceDtlsTGDiv" style="height: 120px; width: 99%; padding-left: 55px;">
					
				</div>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Distribution Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="distDtlsGroDiv" name="distDtlsGroDiv">
		
		</div>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>FLA Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="flaDtlsGroDiv" name="flaDtlsGroDiv">
			
		</div>
		
		<div id="flaButtonsDiv" name="flaButtonsDiv" class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 90px;" id="btnGenerate" name="btnGenerate" value="Generate" disabled="disabled">
						<input type="button" class="button" style="width: 90px;" id="btnPrint" name="btnPrint" value="Print" disabled="disabled">
						<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel FLA" disabled="disabled">
					</td>
				</tr>
			</table>
		</div>
	</form>	
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setDocumentTitle("Final Loss Advice");
	setModuleId("GICLS033");
	observeReloadForm("reloadForm", showGenerateFLAPage);

	objCLM.flaInfo = JSON.parse('${flaInfoJSON}'.replace(/\\/g, '\\\\'));
	populateFlaInfo();
	var arrGICLS033Buttons = [MyTableGrid.REFRESH_BTN];

	objCLM.fla = new Object();
	objCLM.fla.claimId = '${claimId}';
	objCLM.fla.lineCd = objCLM.flaInfo.lineCd;
	objCLM.fla.clmYy = objCLM.flaInfo.claimYy;
	objCLM.fla.adviceId = null;
	objCLM.fla.grpSeqNo = null;
	objCLM.fla.shareType = null;
	objCLM.fla.laYy = null;
	objCLM.fla.advFlaId = null;
	objCLM.fla.currencyCd = null;
	objCLM.fla.selectedIndexAdv = 0;
	
	var objFlaAdviceDtls = new Object();
	objFlaAdviceDtls.objFlaAdviceDtlsTableGrid = JSON.parse('${adviceDtlsTableGrid}');
	objFlaAdviceDtls.objFlaAdviceDtlsRows = objFlaAdviceDtls.objFlaAdviceDtlsTableGrid.rows || [];
	
	try{
		var adviceDtlsTableModel = {
			url: contextPath+"/GICLAdvsFlaController?action=showGenerateFLAPage&refresh=1&claimId="+objCLM.fla.claimId,
			options: {
				title: '',
              	height: '132px',
	          	width: '810px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = adviceDtlsTableGrid._mtgId;
                	objCLM.fla.selectedIndexAdv = -1;
                	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
                		objCLM.fla.selectedIndexAdv = y;
                		generate();
                		objCLM.fla.adviceId = adviceDtlsTableGrid.geniisysRows[y].adviceId;
                		objCLM.fla.lineCd = adviceDtlsTableGrid.geniisysRows[y].lineCode;
                		showFlaDistDtls(objCLM.fla.claimId, objCLM.fla.adviceId, objCLM.fla.lineCd);
                	}
                	/*
                	** removed by jdiago | 03.25.2014
                	** transferred to observe of all text editor | this causes the onClick on checkbox editor to not function
                	adviceDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
                	*/
                },
                onRemoveRowFocus: function(){
                	adviceDtlsTableGrid.keys.removeFocus(adviceDtlsTableGrid.keys._nCurrentFocus, true);
                	adviceDtlsTableGrid.keys.releaseKeys();
                	showFlaDistDtls(null, null, null);
                	showFlaDtls(null, null, null, null);
                	disableFlaButtons();
                	objCLM.fla.selectedIndexAdv = -1;
                	adviceDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
                },
                onSort: function() {
	            	objCLM.fla.selectedIndexAdv = -1;
	            },
	            onRefresh: function() {
	            	objCLM.fla.selectedIndexAdv = -1;
	            },
                toolbar: {
                	elements: (arrGICLS033Buttons)
                }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{   id: 'adviceId',
						    width: '0px',
						    visible: false
						},
						{   id: 'lineCode',
						    width: '0px',
						    visible: false
						},
						{   id: 'generateSw',
						    width: '0px',
						    visible: false
						},
						{
							id: 'generateFla',
							title: '&nbsp;&nbsp;G',
						    width: '25',
						    visible: true,
						    titleAlign: 'left',
						    align: 'left',
						    editable:true,
						    hideSelectAllBox: true,
						    sortable: false,
						    altTitle : 'Generate FLA',
						    editor: new MyTableGrid.CellCheckbox({
								getValueOf: function(value){
				            		if (value){
										return "Y";
				            		}else{
										return "N";
				            		}
				            	},
				            	onClick: function(value){
				            		checkCurrency(value);
				            	}
				            })
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'adviceNo',
							title: 'Advice No.',
			            	width: '173px',
			            	titleAlign: 'center'
						},
						{	id: 'dspCurrency',
							title: 'Currency',
			            	width: '138px',
			            	titleAlign: 'center'
						},
						{	id: 'paidAmount',
							title: 'Paid Amount',
			            	width: '142px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'netAmount',
							title: 'Net Amount',
			            	width: '142px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'adviceAmount',
							title: 'Advice Amount',
			            	width: '142px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'currencyCode',
							width: '0px',
							visible: false
						},
						{   id: 'advFlaId',
						    width: '0px',
						    visible: false
						}
  					],  				
  				rows: objFlaAdviceDtls.objFlaAdviceDtlsRows,
  				id: 1
		};
		adviceDtlsTableGrid = new MyTableGrid(adviceDtlsTableModel);
		adviceDtlsTableGrid.pager = objFlaAdviceDtls.objFlaAdviceDtlsTableGrid;
		adviceDtlsTableGrid.render('adviceDtlsTGDiv');
		adviceDtlsTableGrid.afterRender = function(){
			try{
				// bonok :: 7.8.2015 :: UCPB SR 19733
        		var result = $("mtgPagerMsg1").innerHTML.split(",");
        		$("mtgPagerMsg1").innerHTML = result[0];
				$("pagerDiv1").down("table",0).hide();
				if (objFlaAdviceDtls.objFlaAdviceDtlsRows.length > 0){
					adviceDtlsTableGrid.selectRow('0');
					objCLM.fla.adviceId = adviceDtlsTableGrid.geniisysRows[0].adviceId;
	        		objCLM.fla.lineCd = adviceDtlsTableGrid.geniisysRows[0].lineCode;
	        		showFlaDistDtls(objCLM.fla.claimId, objCLM.fla.adviceId, objCLM.fla.lineCd);
	        		generate();
				}else{
					showFlaDistDtls(null, null, null);
				}	
			}catch(e){
				showErrorMessage("adviceDtlsTableGrid.afterRender ", e);
			}
		};
	}catch(e){
		showMessageBox("Error in Generate FLA Advice Details: " + e, imgMessage.ERROR);
	}
	
	function populateFlaInfo(){
		$("claimNo").value = unescapeHTML2(objCLM.flaInfo.claimNo == null ? "" : objCLM.flaInfo.claimNo);
		$("policyNo").value = unescapeHTML2(objCLM.flaInfo.policyNo == null ? "" : objCLM.flaInfo.policyNo);
		$("assdName").value = unescapeHTML2(objCLM.flaInfo.assuredName == null ? "" : objCLM.flaInfo.assuredName);
		$("lossCat").value = unescapeHTML2(objCLM.flaInfo.lossCatCd == null || objCLM.flaInfo.dspLossCatDesc == null ? "" : objCLM.flaInfo.lossCatCd+"-"+objCLM.flaInfo.dspLossCatDesc);
		$("lossDate").value = dateFormat(unescapeHTML2(objCLM.flaInfo.dspLossDate == null ? "" : objCLM.flaInfo.dspLossDate), "mm-dd-yyyy");
	}
	
	$("btnGenerate").observe("click", function(){
		flaArr = [];
		for(var i = 0; i < objFlaAdviceDtls.objFlaAdviceDtlsRows.length; i++){
			if($("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+i).checked){
				flaArr.push(adviceDtlsTableGrid.getRow(i));
			}
		}
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action  : "generateFla",
				claimId : objCLM.fla.claimId,
				lineCd  : objCLM.fla.lineCd,
				clmYy   : objCLM.fla.clmYy,
				rows    : prepareJsonAsParameter(flaArr)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						adviceDtlsTableGrid._refreshList();
						showMessageBox("Generating FLA Successful.", "S");
					}else{
						showMessageBox(response.responseText, "I");	
					}
				}
			}
		});
	});
	
	$("btnCancel").observe("click", function(){
		showConfirmBox("", "Do you want to continue the cancellation of FLA?", "Yes", "No", cancelFla, "");
	});
	
	$("btnPrint").observe("click", function(){
		if(objCLM.objFlaDtlsRows == 0){
			showMessageBox("Please select FLA.", "I");
		}else if(changeTag == 1){
			showMessageBox("Please save changes.", "I");
		}else{ 
			proceedPrint();//show Print canvass before showing confirmation message by MAC 05/09/2013
		}
	});
	
	function proceedPrint(){
		showGenericPrintDialog("Print Final Loss Advice", validatePrintSwitch, loadPrintFla); //used validatePrintSwitch instead of printFla before printing by MAC 05/09/2013
	}
	
	function validatePrintSwitch(){
		/*
		Created a function to show confirmation message only if tagged record(s) are not yet printed or
		at least one record is not yet printed (applied only if all FLA are going to be printed) 
		otherwise proceed in printing without showing confirmation message by MAC 05/09/2012.
		*/
		var v_ctr = 0; //count all FLA not yet printed
		var v_ctr2 = 0; //count all FLA tagged for printing and not yet printed
		
		for(var i = 0; i < objCLM.objFlaDtlsRows.length; i++){
			if (objCLM.objFlaDtlsRows[i].printSw != "true" && $("printAllFla").checked){
				v_ctr++;
				break;
			}
			if($("mtgInput"+flaDtlsTableGrid._mtgId+"_4,"+i).checked && objCLM.objFlaDtlsRows[i].printSw != "true" && $("printSelectedFla").checked){
				v_ctr2++;
				break;
			}
		}
		//show message if at least one FLA tagged for printing are not yet printed or at least one FLA are not yet printed and all FLA are for printing
		if (((v_ctr2 > 0) || (v_ctr > 0)) && $F("selDestination") == "screen"){ 
			v_ctr = 0;
			v_ctr2 = 0;
			showConfirmBox("", "Printing to screen will automatically tag the FLA(s) as printed.", "Ok", "Cancel", printFla, "", "");
		}else{ //proceed in printing without showing confirmation message if all records are fro reprinting
			printFla();
		}
	}
	
	function printFla(){
		if($("netRecovery").checked){
			getRecovery();
		}

		printFlaArr = [];
		printXolArr = [];
		var ctr = 1;
		populatePrintArr(ctr);
		
		if(printFlaArr.size() > 0){
			proceedPrintFla(printFlaArr);
		}
		if(printXolArr.size() > 0){
			printXol(printXolArr);
		}
		fireEvent($("btnPrintCancel"), "click");
		adviceDtlsTableGrid.refresh(); //refresh GICLS033 after printing by MAC 05/10/2013.
	}
	
	function proceedPrintFla(obj){
		try{
			var reports = [];
			for(var i = 1; i <= obj.length; i++){
				var content = contextPath+"/PrintFinalLossAdviceController?action=printFla"+
						"&claimId="+objCLM.fla.claimId+
						"&riCd="+obj[i-1].riCd+
						"&lineCd="+objCLM.fla.lineCd+
						"&laYy="+obj[i-1].laYy+
						"&flaId="+obj[i-1].flaId+ //added by: Nica 04.05.2013
						"&flaSeqNo="+formatNumberDigits(obj[i-1].flaSeqNo,7)+
						"&noOfCopies="+$F("txtNoOfCopies")+
						"&printerName="+$F("selPrinter")+
						"&destination="+$F("selDestination")+
						"&adviceId="+objCLM.fla.adviceId+
						"&grpSeqNo="+objCLM.fla.grpSeqNo+
						"&shareType="+objCLM.fla.shareType+
						"&advFlaId="+objCLM.fla.advFlaId+
						"&flaTitle="+encodeURIComponent($F("flaTitle"))+               //).replace(/\n/g, "<br/>")+
						"&flaHeader="+encodeURIComponent($F("flaHeader"))+
						"&flaFooter="+encodeURIComponent($F("flaFooter"));
						"&withRecovery="+($("netRecovery").checked == true ? "Y": "N");
				
				reports.push({reportUrl : content, reportTitle : "FLA-"+objCLM.fla.lineCd+"-"+obj[i-1].laYy+"-"+formatNumberDigits(obj[i-1].flaSeqNo,7)});
				
				if("printer" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: false,
						onComplete: function(response){
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing Completed.", "I");
							}
						}
					});	
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}
				
				if (i == obj.length){
					if("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
				}
				
				updateFlaPrintSw(obj[i-1].shareType, obj[i-1].riCd, obj[i-1].flaSeqNo, obj[i-1].laYy);
				flaDtlsTableGrid._refreshList();
			}
		}catch(e){
			showErrorMessage("proceedPrintFla", e);
		}
	}
	
	function printXol(obj){
		try{
			var reports = [];
			for(var i = 1; i <= obj.length; i++){
				var content = contextPath+"/PrintFinalLossAdviceController?action=printFlaXol&claimId="+
						objCLM.fla.claimId+"&grpSeqNo="+obj[i-1].grpSeqNo+"&lineCd="+objCLM.fla.lineCd+"&laYy="+
						obj[i-1].laYy+"&flaSeqNo="+formatNumberDigits(obj[i-1].flaSeqNo,7)+"&noOfCopies="+$F("txtNoOfCopies")+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+"&flaId="+obj[i-1].flaId
						+"&adviceId="+objCLM.fla.adviceId // andrew - 07.19.2012 - added adviceId as parameter
						+"&flaTitle="+$F("flaTitle")	//added by steven 09.06.2012 -flaTitle,flaHeader and flaFooter as parameter
						+"&flaHeader="+$F("flaHeader")
						+"&riCd="+obj[i-1].riCd
						+"&flaFooter="+$F("flaFooter");
				reports.push({reportUrl : content, reportTitle : "FLA-"+objCLM.fla.lineCd+"-"+obj[i-1].laYy+"-"+formatNumberDigits(obj[i-1].flaSeqNo,7)});
				
				if("printer" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: false,
						onComplete: function(response){
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing Completed.", "I");
							}
						}
					});	
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}
				
				if (i == obj.length){
					if("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
				}
				
				updateFlaPrintSw(obj[i-1].shareType, obj[i-1].riCd, obj[i-1].flaSeqNo, obj[i-1].laYy);
				flaDtlsTableGrid._refreshList();
			}
		}catch(e){
			showErrorMessage("printXol", e);
		}
	}
	
	function updateFlaPrintSw(shareType, riCd, flaSeqNo, laYy){
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action    : "updateFlaPrintSw",
				claimId   : objCLM.fla.claimId,
				shareType : shareType,
				riCd      : riCd,
				flaSeqNo  : flaSeqNo,
				lineCd    : objCLM.fla.lineCd,
				laYy      : laYy
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					
				}
			}
		});
	}
	
	function getRecovery(){
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action   : "getRecovery",
				claimId  : objCLM.fla.claimId,
				advFlaId : objCLM.fla.advFlaId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					objCLM.flaRecovery = JSON.parse('${flaRecoveryJSON}'.replace(/\\/g, '\\\\'));
				}
			}
		});
	}
	
	function populatePrintArr(ctr){
		if($('printAllFla').checked){
			for(var i = ctr; i <= objCLM.objFlaDtlsRows.length; i++){
				validatePdFla(flaDtlsTableGrid.getRow(i-1).laYy, flaDtlsTableGrid.getRow(i-1).flaSeqNo, flaDtlsTableGrid.getRow(i-1).riCd, ctr);
				if(flaDtlsTableGrid.getRow(i-1).shareType == 4){
					printXolArr.push(flaDtlsTableGrid.getRow(i-1));
				}else{
					printFlaArr.push(flaDtlsTableGrid.getRow(i-1));
				}
				break;
			}
		}else{
			for(var i = ctr; i <= printArr.size(); i++){
				validatePdFla(printArr[i-1].laYy, printArr[i-1].flaSeqNo, printArr[i-1].riCd, ctr);
				if(flaDtlsTableGrid.getRow(i-1).shareType == 4){
					printXolArr.push(printArr[i-1]);
				}else{
					printFlaArr.push(printArr[i-1]);
				}
				break;
			}
		}
	}
	
	function validatePdFla(laYy, flaSeqNo, riCd, ctr){
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action   : "validatePdFla",
				lineCd   : objCLM.fla.lineCd,
				laYy	 : laYy,
				flaSeqNo : flaSeqNo,
				riCd     : riCd
			},
			asynchronous: false,
			evalScripts: false,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'Y'){
						showWaitingMessageBox("There is existing payment for FLA " + objCLM.fla.lineCd + "-" + laYy + "-" + flaSeqNo + ".", "I", function(){
							ctr++;
							populatePrintArr(ctr);
						});
					}else if(response.responseText == 'N'){
						showConfirmBox("", "There is existing payment for FLA " + objCLM.fla.lineCd + "-" + laYy + "-" + flaSeqNo + ". Do you wish to continue?" , "Ok", "Cancel", function(){
							ctr++;
							populatePrintArr(ctr);
						}, "", "");
					}else if(response.responseText == 'O'){
						showConfirmBox("", "There is existing payment for FLA " + objCLM.fla.lineCd + "-" + laYy + "-" + flaSeqNo + ". Would you like to override?" , "Ok", "Cancel", function(){
							ctr++;
							populatePrintArr(ctr);
						}, "", "");
					}else if(response.responseText == 'X'){
						ctr++;
						populatePrintArr(ctr);
					}
				}
			}
		});
	}
	
	function showFlaOverride(){
		overrideWindow = Overlay.show(contextPath+"/GICLAdvsFlaController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "showOverrideWindow"},
		    title: "Override User",
		    height: 150,
		    width: 400
		});
	}
	
	function loadPrintFla(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'><tr><td><input type='radio' id='printSelectedFla' name='printRangeFla' value='S' style='float: left; margin-bottom: 5px;'><label style='margin-top: 2px; margin-right: 20px;' for='printSelectedFla'>Print Selected FLA(s)</label></td>"+
						  "<td><input type='checkbox' id='netRecovery' name='netRecovery' value='N' style='float: left; padding-bottom: 3px;'><label for='netRecovery'>Net of Recoveries</label></td></tr>"+
						  "<tr><td><input type='radio' id='printAllFla' name='printRangeFla' value='A' style='float: left'><label style='margin-top: 1px;' for='printAllFla' style='margin-top: 6px;'>Print all FLA(s)</label></td></tr></table>"; 
			$("printDialogFormDiv2").update(content); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "215px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "247px";
			
			var vRiCd = "";
			var vFlaSeqNo = "";
			var vFlaId = "";
			
			printArr = [];
			for(var i = 0; i < objCLM.objFlaDtlsRows.length; i++){
				if($("mtgInput"+flaDtlsTableGrid._mtgId+"_4,"+i).checked){
					printArr.push(flaDtlsTableGrid.getRow(i));
				}
			}
			
			for (var a1 = 1; a1 <= printArr.size(); a1++){
				if ((a1 != 1) && (vRiCd != "" || vFlaSeqNo != "" || vFlaId != "")){
					vRiCd = vRiCd + ", ";
					vFlaSeqNo = vFlaSeqNo + ", ";
					vFlaId = vFlaId + ", ";  
				}
				vRiCd = vRiCd + " " + printArr[a1-1].riCd;       
				vFlaSeqNo = vFlaSeqNo + " " + printArr[a1-1].flaSeqNo;       
				vFlaId = vFlaId + " " + printArr[a1-1].flaId;
			}
			
			if (printArr.size() == 0){
			   	$("printSelectedFla").disable();
			   	$("printAllFla").checked = true;
			}else{
				$("printAllFla").enable();
				$("printAllFla").enable();
				$("printSelectedFla").checked = true;
			}
			
			if(objCLM.fla.shareType == 4){
				$("netRecovery").disable();
			}else{
				$("netRecovery").enable();
			}
			
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("selDestination").observe("change", function(){
				if($F("selDestination") != "printer"){
					$("selPrinter").removeClassName("required");
					$("txtNoOfCopies").removeClassName("required");
				}else{
					$("selPrinter").addClassName("required");
					$("txtNoOfCopies").addClassName("required");
				}
			});
		}catch(e){
			showErrorMessage("loadPrintFla", e);	
		}
	}
	
	function cancelFla(){
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action    : "cancelFla",
				claimId   : objCLM.fla.claimId,
				lineCd    : objCLM.fla.lineCd,
				laYy      : objCLM.fla.laYy,
				advFlaId  : objCLM.fla.advFlaId,
				shareType : objCLM.fla.shareType
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					showMessageBox(obj.message, obj.message == 'Cancellation Successful.' ? imgMessage.SUCCESS : imgMessage.INFO);
					adviceDtlsTableGrid._refreshList();
				}
			}
		});
	}
	
	function generate(){
		var chkExists = false;
		if(objCLM.fla.selectedIndexAdv === -1) objCLM.fla.selectedIndexAdv = 0; // bonok :: 7.8.2015 :: UCPB SR 19733 for javascript error on removefocus then sort or refresh
	
		if(objFlaAdviceDtls.objFlaAdviceDtlsRows.length > 0){
			if(adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].generateSw == 'Y'){
				disableButton("btnGenerate");
				enableButton("btnCancel");
				enableButton("btnPrint");
			}else{
				for(var i = 0; i < objFlaAdviceDtls.objFlaAdviceDtlsRows.length; i++){
					if($("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+i).checked){
						chkExists = true;
						break;
					}
				}
				if(chkExists){
// 					enableButton("btnGenerate");
					checkFLAExist(); //added by steven 12/07/2012
				}else{
					disableButton("btnGenerate");
				}
				disableButton("btnCancel");
				disableButton("btnPrint");	
			}
		}
	}
	
	function disableFlaButtons(){
		disableButton("btnGenerate");
		disableButton("btnCancel");
		disableButton("btnPrint");
		
		disableButton("btnUpdate");
		$("flaTitle").disable();
		$("flaHeader").disable();
		$("flaFooter").disable();
	}
	
	function checkCurrency(value){
		if(adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].generateSw == 'Y'){
			showMessageBox("FLA is already generated for this advice.", imgMessage.INFO);
			$("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+objCLM.fla.selectedIndexAdv).checked = false;
		}else{
			if(value == 'Y' && objCLM.fla.currencyCd == null){
				objCLM.fla.currencyCd = adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].currencyCd;
			}else if(value == 'Y' && objCLM.fla.currencyCd != null){
				if(objCLM.fla.currencyCd != adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].currencyCd){
					showMessageBox("Tagging of records with different currency is not allowed.", imgMessage.INFO);
					$("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+objCLM.fla.selectedIndexAdv).checked = false;
				}else{
					objCLM.fla.currencyCd = adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].currencyCd;
				}
			}else{
    			var chkCnt = true;
    			for(var i = 0; i < objFlaAdviceDtls.objFlaAdviceDtlsRows.length; i++){
					if($("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+i).checked){
						chkCnt = false;
					}
				}
    			if(chkCnt){
    				objCLM.fla.currencyCd = null;
    			}
    		}
		}
	    
	    if(value == 'Y'){ // added by jdiago | 03.25.2014 | fix validation for different currency
	    	for(var i=0; i<adviceDtlsTableGrid.geniisysRows.length; i++){
	    		if($("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+i).checked){
	    			if(adviceDtlsTableGrid.geniisysRows[i].currencyCode != adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].currencyCode){
	    				showMessageBox("Tagging of records with different currency is not allowed.", imgMessage.INFO);
						$("mtgInput"+adviceDtlsTableGrid._mtgId+"_4,"+objCLM.fla.selectedIndexAdv).checked = false;
	    			}
	    		}
	    	}
	    }
		adviceDtlsTableGrid.keys.removeFocus(adviceDtlsTableGrid.keys._nCurrentFocus, true); // andrew - 12.14.2012
    	adviceDtlsTableGrid.keys.releaseKeys();
	}

	function checkFLAExist() { //added by steven 12/07/2012 to enable Generate button
		if( objCLM.fla.grpSeqNo== null && objCLM.fla.shareType== null ){
			disableButton("btnGenerate");
		}else{
			enableButton("btnGenerate");
		}
	}
	
	if("${isCloseClaim}" == "Y" && $("btnExit") != null){
		$("btnExit").observe("click", function(){
			showBatchClaimClosing(2);
		});
	}
	
	// Kris 08.06.2013
	if (objGICLS051.previousModule == "GICLS051") {
		objGICLS051.currentView = (objGICLS051.currentView == "P" || objGICLS051.currentView == "PP") ? "PP" : ((objGICLS051.currentView == "F" || objGICLS051.currentView == "FF") ? "FF" : "");
	}
</script>
