<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="distDateMainDiv">
	<div id="distDateDiv" name="statusDiv" style="margin-top: 10px; width: 99.5%; height: 140px;" class="sectionDiv" align="center">
		<div style='margin-top: 10px; margin-bottom:25px; float: left; width: 100%' align="center" >
			<table style="margin-top: 25px;">
				<tr>
					<td><label id="lblMessage" style='width: 120px;; float: left; margin-top: 2px; line-height: 17px;'>Deductible Amount :</label></td>
					<td><input type="text" id="txtXolDed" name="txtXolDed"  style="width: 180px;" value="" class="money" errorMsg ="Field must be of form 99,999,999,999,999.99" maxlength = 18"/></td>
				</tr> 
			</table>
		</div>
		<div align="center" style="margin-bottom: 20px;">
			<input type="button" class="button" id="btnApplyXol" value="Apply XOL Deductible" >
			<input type="button" class="button" id="btnCancelXol" value="Cancel" >
		</div>
	</div>
</div>
<script type="text/javascript">
		initializeAll();
		initializeAllMoneyFields();
		var triggerItem ;
		
		function continueXolDeduc() {
			try {
				new Ajax.Request(
						contextPath + "/GICLReserveDsController",
						{
							method : "GET",
							parameters : {
								action : "continueXolDeduc",
								lineCd : objCurrReserveDS.lineCd,
								grpSeqNo : objCurrReserveDS.grpSeqNo,
								xolDed : objCurrReserveDS.xolDedAmt,
								dspXolDed : nvl(unformatCurrencyValue($F("txtXolDed")),0)
							},
							evalScripts : true,
							asynchronous : true,
							onComplete : function(response) {
								if (checkErrorOnResponse(response)) {
									var res = JSON.parse(response.responseText);
									var msg = res.msg;
									var msgAlert = res.msgAlert;
									if (msg == '1'){
										showMessageBox(msgAlert,"E");
										return false;
									}else if(msg == '2'){
										showConfirmBox("Confirmation", msgAlert, "Yes", "No", 
											function(){
												var sumLossExp = parseFloat(nvl(objCurrReserveDS.shrLossResAmt,0)) + parseFloat(nvl( objCurrReserveDS.shrExpResAmt,0));
												if((sumLossExp - parseFloat($F("txtXolDed").replace(/,/g, ""))) > parseFloat(0)){
													if(objCurrReserveDS.shrLossResAmt != null && $("txtTrtyShrLoss").getAttribute("readonly") == null) {
														var newShrLoss = parseFloat(objCurrReserveDS.shrLossResAmt) - (parseFloat($F("txtXolDed").replace(/,/g, "")) * (parseFloat(objCurrReserveDS.shrLossResAmt)/sumLossExp) );
														$("txtTrtyShrLoss").value = formatCurrency(newShrLoss);
													}else if(objCurrReserveDS.shrExpResAmt != null){
														var newShrExp = parseFloat(objCurrReserveDS.shrExpResAmt) - (parseFloat($F("txtXolDed").replace(/,/g, "")) * (parseFloat(objCurrReserveDS.shrExpResAmt)/sumLossExp) );
														$("txtTrtyShrExp").value = formatCurrency(newShrExp);
													}
													var newXolDed = parseFloat(nvl(objCurrReserveDS.xolDedAmt,0)) + parseFloat(nvl(unformatCurrencyValue($F("txtXolDed")),0));
													$("txtXolDed").value = newXolDed == 0 ? null : formatCurrency(newXolDed);
													objCurrReserveDS.xolDedAmt = newXolDed;
													objGICLS024.vars.dspXolDed = newXolDed;
												}else{
													showMessageBox('Deductible cannot be equal to XOL share amount.', "E");
													return false;
												}
											}, 
											function(){
												$("txtXolDed").value = formatCurrency(objCurrReserveDS.xolDedAmt);
												$("txtXolDed").focus();
												return false;
											});
									}						
								}
							}
						});
			} catch (e) {
				showErrorMessage("continueXolDeduc", e);
			}
		}

		function validateXolDeduc() {
			try {
				new Ajax.Request(
						contextPath + "/GICLReserveDsController",
						{
							method : "GET",
							parameters : {
								action : "validateXolDeduc",
								clmResHistId : objCurrReserveDS.clmResHistId,
								grpSeqNo : objCurrReserveDS.grpSeqNo,
								lineCd : objCurrReserveDS.lineCd,
								shrLossResAmt : nvl(objCurrReserveDS.shrLossResAmt,0),
								shrExpResAmt : nvl(objCurrReserveDS.shrExpResAmt,0),
								xolDed : objCurrReserveDS.xolDedAmt,
								dspXolDed : nvl(unformatCurrencyValue($F("txtXolDed")),0),
								triggerItem : triggerItem
							},
							evalScripts : true,
							asynchronous : true,
							onComplete : function(response) {
								if (checkErrorOnResponse(response)) {
									var res = JSON.parse(response.responseText);
									var msg = res.msg;
									var value = res.newXolDedAmt;
									if (msg != null){
										showWaitingMessageBox(msg,"W", function(){
											$("txtXolDed").value = value;
											$("txtXolDed").focus();
											return false;
										});
									}else if(msg == null && triggerItem == 'XOL_DED_APPLY_BTN'){
										continueXolDeduc();
									}						
								}
							}
						});
			} catch (e) {
				showErrorMessage("validateXolDeduc", e);
			}
		}

	//$("txtXolDed").value = formatCurrency(objGICLS024.vars.dspXolDed);
	
 	$("txtXolDed").observe("change", function(){
 		if(parseFloat($F("txtXolDed").replace(/,/g, "")) > parseFloat(999999999999.99)){
			showWaitingMessageBox("Field must be of form 999,999,999,999.99", "I", function(){
				$("txtXolDed").value 	= null;
				$("txtXolDed").focus();
				return false;
			});
		}
		triggerItem = null;
		validateXolDeduc();
	});
	
	$("btnApplyXol").observe("click", function(){
		triggerItem = 'XOL_DED_APPLY_BTN';
		validateXolDeduc();
	});
	
	$("btnCancelXol").observe("click", function(){
		//giclReserveDsTableGrid._refreshList();
		xolDeducOverlay.close();
		delete xolDeducOverlay;
	});

</script>