<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="24thMethodViewMainDiv" name="24thMethodViewMainDiv">
  	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="24thMethodExtractViewExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Unearned Premiums</label>
   			<span class="refreshers" style="margin-top: 0;">
   				<label id="reloadForm" name="reloadForm">Reload Form</label>
   			</span>
	   	</div>
	</div>
	
	<div id="viewRadioDiv" name="viewRadioDiv" class="sectionDiv" style="float: left;">
		<table style=" margin-top: 25px; margin-bottom: 25px; padding-left: 135px;">
			<tr>
				<td><input type="radio" id="rdoGrossPremium" name="rdoView" value="gdGross" tabindex="101"/></td>
				<td align="left" style="width: 220px;"><label for="rdoGrossPremium">Gross Premiums</label></td>
				<td><input type="radio" id="rdoPremiumCeded" name="rdoView" value="gdRiCeded" tabindex="102"/></td>
				<td align="left" style="width: 220px;"><label for="rdoPremiumCeded">Premium Ceded</label></td>
				<td><input type="radio" id="rdoCommIncome" name="rdoView" value="gdInc" tabindex="103"/></td>
				<td align="left" style="width: 200px;"><label for="rdoCommIncome">Commission Income</label></td>
			</tr>
			<tr>
				<td><input type="radio" id="rdoNetPremium" name="rdoView" value="gdNetPrem" tabindex="104"/></td>
				<td align="left" style="width: 220px;"><label for="rdoNetPremium">Net Premiums</label></td>
				<td><input type="radio" id="rdoRetrocedePremium" name="rdoView" value="gdRetrocede" tabindex="105"/></td>
				<td align="left" style="width: 220px;"><label for="rdoRetrocedePremium">Retroceded Premiums</label></td>
				<td><input type="radio" id="rdoCommExpense" name="rdoView" value="gdExp" tabindex="106"/></td>
				<td align="left" style="width: 200px;"><label for="rdoCommExpense">Commission Expense</label></td>
			</tr>
		</table>
	</div>
	
	<div id="viewDetailDiv" name="view24thMethodDetailDiv" class="sectionDiv" style="height: 480px;">
		<div id="viewParamsDiv" style="margin-top: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned">Period</td>
					<td class="leftAligned">
						<input type="text" id="txtPeriodMonth" name="txtPeriodMonth" style="width: 100px;" readonly="readonly" tabindex="201"/>
					</td>
					<td style="width: 130px;">
						<input type="text" id="txtPeriodYear" name="txtPeriodYear" style="width: 70px;" readonly="readonly" tabindex="202"/>
					</td>
					<td class="rightAligned">Method</td>
					<td class="leftAligned" style="width: 220px;">
						<input type="text" id="txtMethod" name="txtMethod" style="width: 160px;" readonly="readonly" tabindex="203"/>
					</td>
					<td class="rightAligned">Factors</td>
					<td class="leftAligned">
						<input type="text" id="txtNumeratorFactor" name="txtNumeratorFactor" style="width: 50px;" readonly="readonly" tabindex="204"/>
					</td>
					<td class="leftAligned" style="width: 5px;">/</td>
					<td class="leftAligned">
						<input type="text" id="txtDenominatorFactor" name="txtDenominatorFactor" style="width: 50px;" readonly="readonly" tabindex="205"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="viewTableGridDiv" name="viewTableGridDiv" style="margin-top: 10px; margin-left: 10px;"></div>
		<div id="viewButtonsDiv" style="margin-top: 10px;">
			<table align="center" border="0" style="margin-bottom: 20px; margin-top: 10px;">
				<tr>
					<td><input type="button" class="button" id="btnReturnView" name="btnReturnView" value="Return" style="width: 100px;" tabindex="301"/></td>
					<td><input type="button" class="button" id="btnCompute" name="btnCompute" value="Compute" style="width: 100px;" tabindex="302"/></td>
					<td><input type="button" class="button" id="btnViewDetails" name="btnViewDetails" value="View Details" style="width: 100px;" tabindex="303"/></td>
					<td><input type="button" class="button" id="btnGenerateAcctEntries" name="btnGenerateAcctEntries" value="Generate Acct Entries" style="" tabindex="304"/></td>
					<td><input type="button" class="button" id="btnViewAcctEntries" name="btnViewAcctEntries" value="View Acct Entries" style="" tabindex="305"/></td>
					<td><input type="button" class="button" id="btnPrintView" name="btnPrintView" value="Print" style="width: 100px;" tabindex="306"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
var overlayTitle = "";

	function getTableGrid(table) {
		try {	//get records per selected table
			new Ajax.Updater("viewTableGridDiv", contextPath + "/GIACDeferredController", {
				method: "POST",
				parameters: {
					action: "getGdMain",
					year: objGiacs044.year,
					mM: objGiacs044.mM,
					procedureId: objGiacs044.procedureId,
					table: table
					},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Processing data, Please Wait..." + contextPath);
				}, 
				onComplete: function() {
					hideNotice();
				}
			});
		} catch(e) {
			showErrorMessage(e);
		}
	}
	
	function getRdoValue() {	//get selected table
		$$("input[name='rdoView']").each(function(btn) {
			btn.observe("click", function() {
				if (btn.value == "gdGross"){
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;
				}else if (btn.value == "gdRiCeded") {
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;
				}else if (btn.value == "gdInc") {
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;
				}else if (btn.value == "gdNetPrem") {
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;		
				}else if (btn.value == "gdRetrocede") {
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;		
				}else if (btn.value == "gdExp") {
					getTableGrid(btn.value);
					objGiacs044.table = btn.value;
				}
				objGiacs044.lineCd = "";
				objGiacs044.issCd = "";
				objGiacs044.shrType = "";
			});
		});		
	}
	
	function show24thMethodViewDetails(title){	//show details overlay per selected row
		overlayViewDetails = Overlay.show(contextPath + "/GIACDeferredController", {
			urlContent : true,
			urlParameters : {action : "show24thMethodViewDetails",
				table: objGiacs044.table},
			title : title,
			height : '430px',
			width : '680px',
			draggable : true
		});		
	}

	function show24thMethodExtract(){	//return to extract page on click of return/exit
		new Ajax.Request(contextPath + "/GIACDeferredController?action=show24thMethod", {
			onComplete : function(response){
				try { 
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
						objGiacs044.fromMenu = false;
					}
				} catch(e){
						showErrorMessage("show24thMethodExtract - onComplete : ", e);
				}								
			} 
		});			
	}
	
	function checkIfPosted(message, messageBox, func) {	//checks if data has already been posted
		new Ajax.Request(contextPath+"/GIACDeferredController", {	//or if accounting entries have been posted
			parameters: {
				action: "checkGenTag",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'Y') {
						messageBox();
					}else if (response.responseText == null || response.responseText == "") {
						showMessageBox(message, imgMessage.INFO);
					}else{
						func();
					}
				}
			}
		});
	}
	
	function checkIfComputed(yFunc,nFunc) {	//checks if data has already been computed.
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "checkIfComputed",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					objGiacs044.isComputed = response.responseText;
					if (response.responseText == 'Y') {
						yFunc();
					}else {
						nFunc();
					}
				}
			}
		});
	}

	function computeMethod() {	//compute amounts per method
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "computeMethod",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId,
				isComputed: objGiacs044.isComputed
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...computation on progress.");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'Done') {
						showMessageBox("Computation Finished.", imgMessage.INFO);
						fireEvent($("rdoGrossPremium"),"click");
					}
				}
			}
		});
	}
	
	function show24thMethodGenerate() {	//shows Generate overlay
		overlayGenerate = Overlay.show(contextPath + "/GIACDeferredController", {
			urlContent : true,
			urlParameters : {action : "show24thMethodGenerateAcctgEntries"},
			title : "Generation of Accounting Entries",
			height : '225px',
			width : '415px',
			draggable : true
		});	
		showMessageBox("Verify the transaction date before generating the accounting entries.", imgMessage.INFO);
	}
	
	function cancelAccountingEntries() {	//cancel accounting entries, if user wants to regenerate
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "cancelAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...cancelling accounting entries...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if (response.responseText == null || response.responseText == "") {
						show24thMethodGenerate();
					}else {
// 						showWaitingMessageBox(response.responseText, imgMessage.ERROR, show24thMethodGenerate);
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}
		});
	}
	
	function show24thMethodAccountingEntries() {	//shows Accounting Entries overlay
		overlayAccountingEntries = Overlay.show(contextPath + "/GIACDeferredController", {
			urlContent : true,
			urlParameters : {action : "getDeferredAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId,
				table: objGiacs044.table},
			title : "Accounting Entries",
			height : '470px',
			width : '800px',
			draggable : true
		});	
	}
	
	function initializeViewPage() {
		$("rdoGrossPremium").checked = true;
		if ($("rdoGrossPremium").checked) {
			getTableGrid("gdGross");
			objGiacs044.table = "gdGross";
		}
		
		if (objGiacs044.procedureId == 2) {
			disableButton("btnGenerateAcctEntries");
		}
	}
	
	$("24thMethodExtractViewExit").observe("click", show24thMethodExtract);
	
	$("btnReturnView").observe("click", function() {
		show24thMethodExtract();	
		objGiacs044.lineCd = "";
		objGiacs044.issCd = "";
	});
	
	$("btnCompute").observe("click", function() {
		if (objGiacs044.extractCount != 0) {
			checkIfPosted("There is no data to compute.", function() {
				showMessageBox("Data has already been Posted.", imgMessage.INFO);
			}, function() {
				checkIfComputed(function() {
					showConfirmBox("Unearned Premiums", "Data has already been computed.</br>Do you want to compute it again?", 
									"Yes", "No", computeMethod,"","");
				}, computeMethod);
			});
		}else {
			showMessageBox("There is no data to compute.", imgMessage.INFO);
		}

	});
	
	$("btnViewDetails").observe("click", function() {
		if (objGiacs044.table == "gdGross") {	//toggle overlay title per radio button
			overlayTitle = "Details (Gross Premiums)";
		}else if (objGiacs044.table == "gdRiCeded") {
			overlayTitle = "Details (Premium Ceded)";
		}else if (objGiacs044.table == "gdRetrocede") {
			overlayTitle = "Details (Retroceded Premiums)";
		}else if (objGiacs044.table == "gdInc") {
			overlayTitle = "Details (Commission Income)";
		}else if (objGiacs044.table == "gdExp") {
			overlayTitle = "Details (Commission Expense)";
		}
		
		if (objGiacs044.table == "gdNetPrem") {
			showMessageBox("This function is not allowed for net premiums.", imgMessage.INFO);
		}else {
			show24thMethodViewDetails(overlayTitle);
		}
	});
	
	$("btnGenerateAcctEntries").observe("click", function() {
		checkIfPosted("There is no data to generate accounting entries.", function() {
			showConfirmBox("Unearned Premiums", "Accounting Entries for this period has been generated.</br>Do you want to cancel the current accounting entries?",
							"Yes", "No", cancelAccountingEntries,"","");
		}, function() {
			checkIfComputed(function() {
				if (objGiacs044.extractCount != 0) {
					show24thMethodGenerate();
				} else {
					showMessageBox("There is no data to generate accounting entries.", imgMessage.INFO);
				}
			}, function() {
				showMessageBox("Data has not yet been computed.", imgMessage.INFO);
			});
		});
	});
	
	$("btnViewAcctEntries").observe("click", function() {
		if (objGiacs044.table == "gdNetPrem") {
			showMessageBox("This function is not allowed for net premiums.", imgMessage.INFO);
		}else {
			show24thMethodAccountingEntries();
		}
	});
	
	$("btnPrintView").observe("click", function(){
		showGenericPrintDialog("Print Unearned Premiums", objGiacs044.checkReport, objGiacs044.get24thMethodPrintForm, true);
		$(csvOptionDiv).show(); // added by carlo de guzman 3.10.2016 SR 5343
	});
	
	getRdoValue();
	initializeViewPage();
	
	observeReloadForm("reloadForm", function() {
		new Ajax.Request(contextPath + "/GIACDeferredController?action=show24thMethodView", {
			onComplete : function(response){
				try { 
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
						showErrorMessage("show24thMethodView - onComplete : ", e);
				}								
			} 
		});		
	});

</script>