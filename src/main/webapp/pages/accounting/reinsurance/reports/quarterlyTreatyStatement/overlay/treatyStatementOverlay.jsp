<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="treatyStmtMainDiv" name="treatyStmtMainDiv">
	<div id="div1" name="div1" class="sectionDiv" style="width: 885px; margin: 10px 5px 5px 5px;">
		<table style="margin: 10px 10px 10px 10px;">
			<tr>
				<td class="rightAligned" style="width:100px;">In account with</td>
				<td>
					<input type="text" id="txtRiCd" name="txtRiCd" style="width: 70px; text-align: right; margin-left:5px;" readonly="readonly" tabindex="101" />
					<input type="text" id="txtRiName" name="txtRiName" style="width: 450px; " readonly="readonly" tabindex="102" />
				</td>
				<td class="rightAligned" style="width:80px;">Year</td>
				<td><input type="text" id="txtYear" name="txtYear" style="width:110px; text-align: right; margin-left:5px;" readonly="readonly" tabindex="103" maxlength="4" /></td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td>
					<input type="text" id="txtLineCd" name="txtLineCd" style="width: 70px; margin-left:5px;" readonly="readonly" tabindex="104" />
					<input type="text" id="txtTreatyYy" name="txtTreatyYy" style="width: 70px; text-align: right;" readonly="readonly" tabindex="105" />
					<input type="text" id="txtShareCd" name="txtShareCd" style="width: 70px; text-align: right;" readonly="readonly" tabindex="106" />
					<input type="text" id="txtTreatyName" name="txtTreatyName" style="width: 286px;" readonly="readonly" tabindex="107" />
				</td>
				<td class="rightAligned">Quarter</td>
				<td>
					<input type="text" id="txtQtrStr" name="txtQtrStr" style="width:110px; margin-left:5px;" readonly="readonly" tabindex="108" />
					<input type="hidden" id="txtQtr" name="txtQtr" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Your Share %</td>
				<td colspan="3">
					<input type="text" id="txtTrtyShrPct" name="txtTrtyShrPct" style="width: 234px; text-align: right; margin-left:5px;" readonly="readonly" tabindex="109" />
				</td>
			</tr>
		</table>
	</div>
	
	<div id="div2" name="div2" class="sectionDiv" style="width: 885px; margin: 0 10px 10px 5px;" changeTagAttr="true" >
		<table style="margin: 10px 20px 10px 10px;">
			<tr>
				<td class="rightAligned" style="width: 170px;">Premium Ceded</td>
				<td><input type="text" id="txtPremiumCededAmt" name="txtPremiumCededAmt" style="width: 190px; text-align: right; margin-left:5px;"  readonly="readonly" /></td>
				<td style="width: 80px;"><input type="button" class="button" id="btnPerilDetail" name="btnPerilDetail" value=">>" style="width: 40px;" readonly="readonly" /></td>
				<td class="rightAligned">Prem Reserve Released</td>
				<td><input type="text" id="txtPremResvRelsdAmt" name="txtPremResvRelsdAmt" class="money" style="width: 190px; text-align: right; margin-left:5px;" errorMsg="Field must be of form 999,999,999,990.90" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Commission</td>
				<td><input type="text" id="txtCommissionAmt" name="txtCommissionAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
				<td><input type="button" class="button" id="btnCommDetail" name="btnCommDetail" value=">>" style="width: 40px;" /></td>
				<td class="rightAligned">Interest on Reserver Released</td>
				<td><input type="text" id="txtReleasedIntAmt" name="txtReleasedIntAmt" class="money" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr style="height: 10px;"></tr>
			<tr>
				<td class="rightAligned">Loss Paid</td>
				<td><input type="text" id="txtClmLossPaidAmt" name="txtClmLossPaidAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
				<td><input type="button" class="button" id="btnClmpDetail" name="btnClmpDetail" value=">>" style="width: 40px;" /></td>
				<td class="rightAligned">Withholding Tax Rate</td>
				<td><input type="text" id="txtWhtTaxRt" name="txtWhtTaxRt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Loss Expense</td>
				<td><input type="text" id="txtClmLossExpenseAmt" name="txtClmLossExpenseAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
				<td><input type="button" class="button" id="btnClmeDetail" name="btnClmeDetail" value=">>" style="width: 40px;" /></td>
				<td class="rightAligned">Withholding Tax Amount</td>
				<td><input type="text" id="txtWhtTaxAmt" name="txtWhtTaxAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr style="height: 10px;"></tr>
			<tr>
				<td class="rightAligned">Prem Reserve Retained</td>
				<td><input type="text" id="txtPremResvdRetndAmt" name="txtPremResvdRetndAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
				<td colspan="2" class="rightAligned">Ending Balance</td>
				<td><input type="text" id="txtEndingBalAmt" name="txtEndingBalAmt" class="money" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Funds Held %</td>
				<td><input type="text" id="txtFundsHeldPct" name="txtFundsHeldPct" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
				<td colspan="2" class="rightAligned">Previous Balance Due</td>
				<td><input type="text" id="txtPrevBalanceDue" name="txtPrevBalanceDue" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr style="height: 10px;"></tr>
			<tr>
				<td class="rightAligned">Outstanding Losses Amount</td>
				<td><input type="text" id="txtOutstandingLossAmt" name="txtOutstandingLossAmt" class="money" errorMsg="Field must be of form 999,999,999,990.90" style="width: 190px; text-align: right; margin-left:5px;" /></td>
				<td colspan="2" class="rightAligned">Previous Ending Balance</td>
				<td><input type="text" id="txtPreviousBalAmt" name="txtPreviousBalAmt" style="width: 190px; text-align: right; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td><input type="text" id="txtTSUserId" name="txtTSUserId" style="width: 190px; margin-left:5px;" readonly="readonly" /></td>
				<td colspan="2" class="rightAligned">Last Update</td>
				<td><input type="text" id="txtTSLastUpdate" name="txtTSLastUpdate" style="width: 190px; margin-left:5px;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<label id="lblChkFinalTag" name="lblChkFinalTag" for="chkFinalTag" style="float:left; margin-left:5px;">Final Tag</label>
					<input type="checkbox" id="chkFinalTag" name="chkFinalTag" style="float:left; margin-left: 5px;" disabled="disabled" />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv" style="width: 885px; margin: 5px 10px 10px 5px;">
		<input type="button" class="button" id="btnAccounts" name="btnAccounts" value="Accounts" style="width: 100px; " />
		<input type="button" class="button" id="btnTSReports" name="btnTSReports" value="Reports" style="width: 100px; " />
		<input type="button" class="button" id="btnTSReturn" name="btnTSReturn" value="Return" style="width: 100px; " />
		<input type="button" class="button" id="btnTSSave" name="btnTSSave" value="Save" style="width: 100px;" />
	</div>
</div>

<script type="text/javascript">

	var treatyQtrSummary = JSON.parse('${treatyQtrSummary}');
	changeTag = 0;
	
	function setItems(){
		$("txtRiCd").value 					= treatyQtrSummary.riCd;
		$("txtRiName").value 				= unescapeHTML2(nvl(treatyQtrSummary.riName, ""));
		$("txtYear").value 					= treatyQtrSummary.year;
		$("txtLineCd").value 				= treatyQtrSummary.lineCd;
		$("txtTreatyYy").value 				= treatyQtrSummary.treatyYy;
		$("txtShareCd").value 				= treatyQtrSummary.shareCd;
		$("txtTreatyName").value 			= unescapeHTML2(nvl(treatyQtrSummary.treatyName, ""));
		$("txtQtr").value 					= treatyQtrSummary.qtr;
		switch(treatyQtrSummary.qtr){
			case "1" : $("txtQtrStr").value = "1st"; break;
			case "2" : $("txtQtrStr").value = "2nd"; break;
			case "3" : $("txtQtrStr").value = "3rd"; break;
			case "4" : $("txtQtrStr").value = "4th"; break;
		}
		
		$("txtTrtyShrPct").value 			= formatToNineDecimal(treatyQtrSummary.trtyShrPct);
		
		$("txtPremiumCededAmt").value 		= formatCurrency(treatyQtrSummary.premiumCededAmt);
		$("txtCommissionAmt").value 		= formatCurrency(treatyQtrSummary.commissionAmt);
		$("txtClmLossPaidAmt").value 		= formatCurrency(treatyQtrSummary.clmLossPaidAmt);
		$("txtClmLossExpenseAmt").value 	= formatCurrency(treatyQtrSummary.clmLossExpenseAmt);
		$("txtPremResvdRetndAmt").value 	= formatCurrency(treatyQtrSummary.premResvRetndAmt);
		$("txtFundsHeldPct").value 			= formatToNineDecimal(treatyQtrSummary.fundsHeldPct);
		$("txtOutstandingLossAmt").value 	= formatCurrency(treatyQtrSummary.outstandingLossAmt);
		$("txtTSUserId").value 				= treatyQtrSummary.userId;
		$("txtPremResvRelsdAmt").value 		= formatCurrency(treatyQtrSummary.premResvRelsdAmt);
		$("txtReleasedIntAmt").value 		= formatCurrency(treatyQtrSummary.releasedIntAmt);
		$("txtWhtTaxRt").value 				= formatToNineDecimal(treatyQtrSummary.whtTaxRt);
		$("txtWhtTaxAmt").value 			= formatCurrency(treatyQtrSummary.whtTaxAmt);
		$("txtEndingBalAmt").value 			= formatCurrency(treatyQtrSummary.endingBalAmt);
		$("txtPrevBalanceDue").value 		= formatCurrency(treatyQtrSummary.prevBalanceDue);
		$("txtPreviousBalAmt").value		= formatCurrency(treatyQtrSummary.previousBalAmt);
		$("txtTSLastUpdate").value 			= treatyQtrSummary.lastUpdateStr;
		
		$("chkFinalTag").checked = (treatyQtrSummary.finalTag == "Y" ? true : false);
		
		setGlobalVars();
	}
	
	function setGlobalVars(){
		objGtqs.lineCd 		= treatyQtrSummary.lineCd;
		objGtqs.treatyYy 	= treatyQtrSummary.treatyYy;
		objGtqs.shareCd 	= treatyQtrSummary.shareCd;
		objGtqs.riCd 		= treatyQtrSummary.riCd;
		objGtqs.year 		= treatyQtrSummary.year;
		objGtqs.qtr 		= treatyQtrSummary.qtr;
	}
	
	function saveTreatyStatement(){
		try {
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {
					action				: "saveTreatyStatement",
					summaryId			: treatyQtrSummary.summaryId,
					outstandingLossAmt	: unformatCurrency("txtOutstandingLossAmt"),
					releasedIntAmt		: unformatCurrency("txtReleasedIntAmt"),
					premResvRelsdAmt	: unformatCurrency("txtPremResvRelsdAmt"),
					whtTaxAmt			: unformatCurrency("txtWhtTaxAmt"),
					endingBalAmt		: unformatCurrency("txtEndingBalAmt")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("saveTreatyStatement: ",e);
		}
	}
	
	$("btnPerilDetail").observe("click", function(){
		perilBreakdownOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getPerilBreakdownList",
				lineCd		: treatyQtrSummary.lineCd,
				treatyYy	: treatyQtrSummary.treatyYy,
				shareCd		: treatyQtrSummary.shareCd,
				riCd		: treatyQtrSummary.riCd,
				year		: treatyQtrSummary.year,
				qtr			: treatyQtrSummary.qtr
			},
			title : "Peril Breakdown",
			height : 460,
			width : 700,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});	
	});
	
	$("btnCommDetail").observe("click", function(){
		commissionBreakdownOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getCommissionBreakdownList",
				lineCd		: treatyQtrSummary.lineCd,
				treatyYy	: treatyQtrSummary.treatyYy,
				shareCd		: treatyQtrSummary.shareCd,
				riCd		: treatyQtrSummary.riCd,
				year		: treatyQtrSummary.year,
				qtr			: treatyQtrSummary.qtr
			},
			title : "Commission Breakdown by Commission Rate",
			height : 460,
			width : 700,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});	
	});
	
	$("btnClmpDetail").observe("click", function(){
		clmLossPaidBreakdownOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getClmLossPaidBreakdownList",
				lineCd		: treatyQtrSummary.lineCd,
				treatyYy	: treatyQtrSummary.treatyYy,
				shareCd		: treatyQtrSummary.shareCd,
				riCd		: treatyQtrSummary.riCd,
				year		: treatyQtrSummary.year,
				qtr			: treatyQtrSummary.qtr
			},
			title : "Loss Paid with Peril Breakdown",
			height : 460,
			width : 700,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});	
	});
	
	$("btnClmeDetail").observe("click", function(){
		clmLossExpBreakdownOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getClmLossExpBreakdownList",
				lineCd		: treatyQtrSummary.lineCd,
				treatyYy	: treatyQtrSummary.treatyYy,
				shareCd		: treatyQtrSummary.shareCd,
				riCd		: treatyQtrSummary.riCd,
				year		: treatyQtrSummary.year,
				qtr			: treatyQtrSummary.qtr
			},
			title : "Loss Expense with Peril Breakdown",
			height : 460,
			width : 700,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});	
	}); 
	
	$("btnAccounts").observe("click", function(){
		accountsOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "showAccountsOverlay",
				summaryId	: treatyQtrSummary.summaryId,
				year		: treatyQtrSummary.year,
				qtr			: treatyQtrSummary.qtr
			},
			title : "Accounts",
			height : 350,
			width : 910,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
	});
	
	$("btnTSReports").observe("click", function(){
		printTSReportsOverlay = Overlay.show(contextPath + "/GIACReinsuranceReportsController", {
			urlParameters : { 
				action 		: "getReportList",
				fromPage	: "treatyStatement"
			},
			title : "List of Reports",
			height : 310,
			width : 460,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});		
	});
	
	$("btnTSReturn").observe("click", function(){
		if(changeTag == 0){
			treatyStatementOverlay.close();	
		} else {
			// notify user
			showConfirmBox4("Confirmation", "Do you want to save the changes you have made?", "Yes", "No", "Cancel",
							saveTreatyStatement, // Yes
							function(){ treatyStatementOverlay.close();	},
							"", "Yes");
		}		
	});
	
	$("btnTSSave").observe("click", saveTreatyStatement);
	
	$("txtPremResvRelsdAmt").observe("change", function(){
		if(!isNaN($F("txtPremResvRelsdAmt")) && $F("txtPremResvRelsdAmt") != ""){
			var premResvRelsdAmount = parseFloat($F("txtPremResvRelsdAmt"));
			if(premResvRelsdAmount > parseFloat("0")){
				var newReleasedIntAmt = ( premResvRelsdAmount * nvl(treatyQtrSummary.intOnPremPct, 0) ) / 100;
				var newWhtTaxAmt = ( parseFloat(nvl(newReleasedIntAmt, 0)) * parseFloat(nvl($F("txtWhtTaxRt"), 0)) ) / 100 ;
				
				$("txtReleasedIntAmt").value 	= formatCurrency(newReleasedIntAmt);	
				$("txtWhtTaxAmt").value 		= formatCurrency(newWhtTaxAmt);
				$("txtEndingBalAmt").value 		= formatCurrency((	parseFloat(nvl(treatyQtrSummary.premiumCededAmt, 0))
																  - parseFloat(nvl(treatyQtrSummary.commissionAmt, 0))
																  - parseFloat(nvl(treatyQtrSummary.clmLossPaidAmt, 0))
																  - parseFloat(nvl(treatyQtrSummary.clmLossExpenseAmt, 0))
																  - parseFloat(nvl(treatyQtrSummary.premResvRetndAmt, 0))											  
																  + premResvRelsdAmount
																  + parseFloat(newReleasedIntAmt)
																  - parseFloat(newWhtTaxAmt)  ) );
				
				// ilagay ito sa overlay ng cash acct
				objGtqs.premResvRetndAmt = treatyQtrSummary.premResvRetndAmt;
				objGtqs.premResvRelsdAmt = $F("txtPremResvRelsdAmt"); //treatyQtrSummary.premResvRelsdAmt;	
				/*objGtqs.resvBalance = 	parseFloat(nvl(objGtqs.resvBalance, 0))
									  + parseFloat(nvl(objGtqs.premResvRetndAmt, 0))
									  - parseFloat(nvl(objGtqs.premResvRelsdAmt, 0));*/
			} else {
				customShowMessageBox("Invalid Amount!", "I", "txtPremResvRelsdAmt");
			}
		}
	});
	
	initializeAll();
	initializeAllMoneyFields();
	setItems();	
</script>