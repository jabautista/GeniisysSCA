<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div class="sectionDiv" style="border-top: none;" id="directTransInputVatDiv" name="directTransInputVatDiv">	
	<jsp:include page="subPages/lossRecoveriesListingTable.jsp"></jsp:include>
	<div>
		<table align="center" border="0" style=" margin:40px auto; margin-top:10px; margin-bottom:20px;">
			<tr>
				<td class="rightAligned" >Transaction Type</td>
				<td class="leftAligned"  >
					<input type="hidden" id="hidTranFlag" name="hidTranFlag" value="${tranFlag}" />	
					<input type="text" id="readOnlyTransactionTypeLossRec" name="readOnlyTransactionTypeLossRec" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selTransactionTypeLossRec" name="selTransactionTypeLossRec" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
							<option value="${transactionType.rvLowValue }" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width:130px">Claim No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspClaimNoLossRec" name="txtDspClaimNoLossRec" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned"> Recovery No.</td>
				<td class="leftAligned"  style="background:none;">
					<div style="float: left;">
					<input type="text" style="width:43px;" id="txtLineCdLossRec"   	name="txtLineCdLossRec"  	value="" maxlength="2" class="required" />
					<input type="text" style="width:43px;" id="txtIssCdLossRec"   	name="txtIssCdLossRec"  	value="" maxlength="2" class="required" />
					<input type="text" style="width:43px;" id="txtRecYearLossRec"   name="txtRecYearLossRec" 	value="" maxlength="4" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 9999."/>
					<input type="text" style="width:43px;" id="txtRecSeqNoLossRec" 	name="txtRecSeqNoLossRec" 	value="" maxlength="3" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 999."/>
					<!-- by bonok - test case 3.14.2012 
					<input readonly="readonly" type="text" style="width:43px;" id="txtLineCdLossRec"   	name="txtLineCdLossRec"  	value="" maxlength="2" class="required" />
					<input readonly="readonly" type="text" style="width:43px;" id="txtIssCdLossRec"   	name="txtIssCdLossRec"  	value="" maxlength="2" class="required" />
					<input readonly="readonly" type="text" style="width:43px;" id="txtRecYearLossRec"   name="txtRecYearLossRec" 	value="" maxlength="4" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 9999."/>
					<input readonly="readonly" type="text" style="width:43px;" id="txtRecSeqNoLossRec" 	name="txtRecSeqNoLossRec" 	value="" maxlength="3" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 999."/> -->
					</div>
					<div style="float:left; margin-left: 4px;"><img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="recoveryNoLossRecDate" name="recoveryNoLossRecDate" alt="Go" /></div>
				</td>
				<td class="rightAligned" > Policy No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspPolicyNoLossRec" name="txtDspPolicyNoLossRec" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Payee Class</td>
				<td class="leftAligned"  >
					<div style="float:left;">
					<input type="text" id="readOnlyPayorClassCdLossRec" name="readOnlyPayorClassCdLossRec" value="" class="required" style="width:208px; float:left;" readonly="readonly"/>
					<select id="selPayorClassCdLossRec" name="selPayorClassCdLossRec" style="width:216px; display: none;" class="required">
						<option value="" payorName="" payorCd=""></option>
					</select>
					</div>
					<div style="float:left; margin-left: 4px;"><img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="payorNameLOV" name="payorNameLOV" alt="Go" /></div>
				</td>
				<td class="rightAligned" >Assured Name</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspAssuredNameLossRec" name="txtDspAssuredNameLossRec" style="width:231px;" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Payee</td>
				<td class="leftAligned"  >
					<input style="width:231px;" type="text" id="txtPayorNameLossRec" name="txtPayorNameLossRec" class="required" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned" >Recovery Type</td>
				<td class="leftAligned"  >
					<input type="text" id="txtRecoveryTypeDescLossRec" name="txtRecoveryTypeDescLossRec" value="" style="width:231px;" readonly="readonly"/>
				</td>
				</tr>
				<tr>
					<td class="rightAligned" >Recovered Amount</td>
					<td class="leftAligned"  >
						<input type="text" id="txtCollectionAmtLossRec" name="txtCollectionAmtLossRec" value="" class="money  required" maxlength="18" style="width:231px;" readonly="readonly"/>
					</td>
				<td class="rightAligned" >Loss Date</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspLossDateLossRec" name="txtDspLossDateLossRec" value="" style="width:231px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" ></td>
				<td class="leftAligned"  >
					<div style="float: left; margin-right: 3px;"><input type="checkbox" id="chkAcctEntTagLossRec" name="chkAcctEntTagLossRec" value="Y" checked="checked"/></div>
					<label for="chkAcctEntTagLossRec" class="rightAligned">Automatic Generation of Accounting Entries</label>
				</td>
				<td class="rightAligned" >Remarks</td>
				<td class="leftAligned"  >
					<div style="border: 1px solid gray; height: 20px; width:237px;"> 
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarksLossRec" name="txtRemarksLossRec" style="width:210px; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarksLossRec" />
					</div>	
				</td>
			</tr>
			<tr>
				<td colspan="2" style="margin:auto;" align="center">
					<input type="button" style="width: 130px;" id="btnForeignCurrLossRec" class="button" value="Foreign Currency" />
					<input type="button" style="width: 80px;" id="btnAddLossRec" 	 	 class="button" value="Add" />
					<input type="button" style="width: 80px;" id="btnDeleteLossRec" 	 class="button" value="Delete" />
				</td>
			</tr>	
		</table>
	</div>
	<div id="currencyLossRecDiv" style="display: none;">
		<table border="0" align="center" style="margin:10px auto;">
			<tr>
				<td class="rightAligned" style="width: 123px;">Currency Code</td>
				<td class="leftAligned"  ><input type="text" style="width: 50px; text-align: left" id="currencyCdLossRec" name="currencyCdLossRec" value="" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Entered currency code is invalid. Valid value is from 1 to 99." maxlength="2"/></td>
				<td class="rightAligned" style="width: 180px;">Convert Rate</td>
				<td class="leftAligned"  ><input type="text" style="width: 100px; text-align: right" class="moneyRate required" id="convertRateLossRec" name="convertRateLossRec" value="" maxlength="13"/></td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency Description</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: left" id="currencyDescLossRec" name="currencyDescLossRec" value="" readonly="readonly"/></td>
				<td class="rightAligned" >Foreign Currency Amount</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: right" class="money required" id="foreignCurrAmtLossRec" name="foreignCurrAmtLossRec" value="" maxlength="18"/></td>
			</tr>
			<tr>
				<td width="100%" style="text-align: center;" colspan="4">
					<input type="button" style="width: 80px;" id="btnHideCurrLossRecDiv" class="button" value="Return"/>
				</td>
			</tr>
		</table>
	</div>	
</div>	
<div class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" style="width: 80px;" id="btnCancelDirectTransLossRec"  name="btnCancelDirectTransLossRec"	class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnSaveDirectTransLossRec" 	name="btnSaveDirectTransLossRec"	class="button" value="Save" />
</div> 
<script type="text/javascript">
try{
	//var res = new Object();
	var objSearchRecoveryNo = new Object();
	objAC.objLossRecAC010 = JSON.parse('${giacLossRecoveriesJSON}'.replace(/\\/g, '\\\\'));
	objAC.hidObjGIACS010 = {};
	objAC.hidObjGIACS010.payeeListJSON = JSON.parse('${payeeListJSON}'.replace(/\\/g, '\\\\'));
	
	setModuleId("GIACS010");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");

	//to show/generate the table listing
	showDirectTransLossRecoveriesList(objAC.objLossRecAC010);

	//create observe on list
	$$("div#directTransLossRecoveriesTable div[name=rowDirectTransLossRecoveries]").each(function(row){
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div#directTransLossRecoveriesTable div[name=rowDirectTransLossRecoveries]").each(function(r){
					if (row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}else{
						getDefaults();
						var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
						for(var a=0; a<objAC.objLossRecAC010.length; a++){
							if (objAC.objLossRecAC010[a].divCtrId == id){
								supplyDirectTransLossRecoveries(objAC.objLossRecAC010[a]);
								disableSearch("recoveryNoLossRecDate");
								disableSearch("payorNameLOV");
							}
						}
					}	
				});
			}else{
				clearForm();
				enableSearch("recoveryNoLossRecDate");
				enableSearch("payorNameLOV");
			}		
		});	
	});	

	//foreign currency info DIV
	$("btnForeignCurrLossRec").observe("click",function(){
		if ($("currencyLossRecDiv").getStyle("display") == "none"){
			Effect.Appear($("currencyLossRecDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("currencyLossRecDiv"), {
				duration: .2
			});
		}
		//by bonok :: test case :: 03.19.2012
		if($("currencyCdLossRec").value == 1){
			$("convertRateLossRec").disable();
		}
	});
	
	//by bonok :: test case :: 03.19.2012
	$("currencyCdLossRec").observe("change", function(){
		if($("currencyCdLossRec").value == 1){
			$("convertRateLossRec").disable();
		}else{
			$("convertRateLossRec").enable();
		}
	});

	$("btnHideCurrLossRecDiv").observe("click",function(){
		Effect.Fade($("currencyLossRecDiv"), {
			duration: .2
		});	
	});

	//for transaction type
	$("selTransactionTypeLossRec").observe("change",function(){
		$("txtLineCdLossRec").clear();
		$("txtIssCdLossRec").clear();
		$("txtRecYearLossRec").clear();
		$("txtRecSeqNoLossRec").clear();
		objAC.hidObjGIACS010.hidClaimId		= "";
		objAC.hidObjGIACS010.hidRecoveryId	= "";
		//$("payorNameLOV").hide();
		$w("selPayorClassCdLossRec txtPayorNameLossRec txtCollectionAmtLossRec txtDspClaimNoLossRec txtDspPolicyNoLossRec txtDspAssuredNameLossRec txtRecoveryTypeDescLossRec txtDspLossDateLossRec txtRemarksLossRec").each(function(e){
			$(e).value = "";
		}); //marco - 10.01.2014
	});
	
	//remarks
	$("editTxtRemarksLossRec").observe("click", function () {
		//showEditor("txtRemarksLossRec", 4000);
		showOverlayEditor("txtRemarksLossRec", 4000, $("txtRemarksLossRec").hasAttribute("readonly")); // andrew - 08.15.2012
		if (objAC.hidObjGIACS010.hidUpdateable == "N"){
			disableButton("btnSubmitText");
			$("textarea1").readOnly = true;
		}else{
			enableButton("btnSubmitText");
			$("textarea1").readOnly = false;
		}		
	});

	//when recovery no. icon click
	$("recoveryNoLossRecDate").observe("click",function(){
		if (objAC.hidObjGIACS010.hidUpdateable == "N"){ //to have a disable effect on the icon
			return false;
		}	
		if ($F("selTransactionTypeLossRec").blank()){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeLossRec");
			return false;
		}else{
			openSearchRecoveryNo();
		}
	});

	//when payee class change
	$("selPayorClassCdLossRec").observe("change", function(){
		objAC.hidObjGIACS010.hidPayorCd = $("selPayorClassCdLossRec").options[$("selPayorClassCdLossRec").selectedIndex].getAttribute("payorCd");
		$("txtPayorNameLossRec").value = $("selPayorClassCdLossRec").options[$("selPayorClassCdLossRec").selectedIndex].getAttribute("payorName");
	});

	var varTxtCollectionAmtLossRec = "";
	$("txtCollectionAmtLossRec").observe("focus", function(){
		varTxtCollectionAmtLossRec = $F("txtCollectionAmtLossRec");
	});	
	
	//$("payorNameLOV").hide();
	$("payorNameLOV").observe("click", function(){
		if($F("txtLineCdLossRec") == "" || $F("txtIssCdLossRec") == "" || $F("txtRecYearLossRec") == "" || $F("txtRecSeqNoLossRec") == ""){
			showMessageBox("Please select a Recovery first.", "E");
		}else{
			showPayorNameLOV();
		}
	});
	
	/**
	 * Shows Payor Name for manual input of Recovery No.
	 * @author bonok
	 * @date 04.03.2012
	 */	

	function showPayorNameLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action	: "getPayorNameLOV",
					lineCd	: $("txtLineCdLossRec").value,
					issCd	: $("txtIssCdLossRec").value,
					recYear	: $("txtRecYearLossRec").value,
					recSeqNo: $("txtRecSeqNoLossRec").value,
					transactionType: $("selTransactionTypeLossRec").value
				},
				title: "Payor Name List",
				width: 539,
				height: 300,
				columnModel: [
				        {
				          	id: "payorClassCd",
				          	title: "Class Cd",
				          	width: "60px",
				          	align: "right",
							titleAlign: "right"
				        },
				        {
				        	id: "payorClassDesc",
				          	title: "Class Desc.",
				          	width: "200px",
				          	align: "left",
							titleAlign: "left"
				        },
				        {
				        	id: "payorCd",
				          	title: "PayorCd",
				          	width: "60px",
				          	align: "right",
							titleAlign: "right"
				        },
				        {
				        	id: "payorName",
				        	title: "Payor Name",
				        	width: "200px",
							align: "left",
							titleAlign: "left"
				        }
				],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						getManualRecoveryList(row.payorCd, row.payorClassCd);
					}
				}
			});
		}catch(e){
			showErrorMessage("showPayorNameLOV",e);
		}
	}
	
	// bonok :: checks if recovery no. exists :: 04.03.2012
	function checkPayorNameLOV(){
		try{
			new Ajax.Request(contextPath+"/GIACLossRecoveriesController",{
				method: "GET",
				parameters: {
					action	: "checkPayorNameExist",
					lineCd	: $("txtLineCdLossRec").value,
					issCd	: $("txtIssCdLossRec").value,
					recYear	: $("txtRecYearLossRec").value,
					recSeqNo: $("txtRecSeqNoLossRec").value,
					transactionType: $("selTransactionTypeLossRec").value
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(response) {
					var res = JSON.parse(response.responseText);
					if(res != ""){
						$("payorNameLOV").show();
					}else{
						showMessageBox("Recovery Number does not exist.", imgMessage.ERROR);
					}
					clearFields();
				}
			});
		}catch(e){
			showErrorMessage("checkPayorNameLOV",e);
		}
	}
	
	// bonok :: for manual input of recovery no. :: 04.02.2012
	function getManualRecoveryList(payorCd, payorClassCd){
		try{
			new Ajax.Request(contextPath+"/GIACLossRecoveriesController",{
				method: "GET",
				parameters: {
					action: "getManualRecoveryList",
					lineCd	: $("txtLineCdLossRec").value,
					issCd	: $("txtIssCdLossRec").value,
					recYear	: $("txtRecYearLossRec").value,
					recSeqNo: $("txtRecSeqNoLossRec").value,
					payorCd : payorCd,
					payorClassCd : payorClassCd,
					transactionType : $("selTransactionTypeLossRec").value
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(response) {
					var res = JSON.parse(response.responseText);
					for(var a=0; a<res.length; a++){
						for (var b=0; b<objAC.objLossRecAC010.length; b++){
							if (res[a].lineCd == objAC.objLossRecAC010[b].lineCd
									&& res[a].issCd == objAC.objLossRecAC010[b].issCd
									&& res[a].recYear == objAC.objLossRecAC010[b].recYear
									&& res[a].recSeqNo == objAC.objLossRecAC010[b].recSeqNo
									&& res[a].payorClassCd == objAC.objLossRecAC010[b].payorClassCd
									&& objAC.objLossRecAC010[b].recordStatus != -1){
								showMessageBox("Recovery Number should be unique.", imgMessage.ERROR);
								return false;
							}
						}
						$("txtDspClaimNoLossRec").value			= res[a].dspClaimNo;
						objAC.hidObjGIACS010.hidClaimId			= (res[a].claimId == null ? "" :nvl(res[a].claimId,""));
						$("txtDspClaimNoLossRec").value			= (res[a].dspClaimNo == null ? "" :nvl(res[a].dspClaimNo,""));
						$("txtDspPolicyNoLossRec").value		= (res[a].dspPolicyNo == null ? "" :nvl(res[a].dspPolicyNo,""));
						$("txtDspLossDateLossRec").value		= (res[a].dspLossDate == null ? "" :nvl(dateFormat(res[a].dspLossDate.replace(/-/g,"/"),"mm-dd-yyyy"),""));
						$("txtDspAssuredNameLossRec").value		= (res[a].dspAssuredName == null ? "" :nvl(res[a].dspAssuredName,""));
						objAC.hidObjGIACS010.hidRecoveryId		= (res[a].recoveryId == null ? "" :nvl(res[a].recoveryId,""));
						objAC.hidObjGIACS010.hidRecTypeCd		= (res[a].recTypeCd == null ? "" :nvl(res[a].recTypeCd,""));
						$("txtRecoveryTypeDescLossRec").value	= (res[a].recTypeDesc == null ? "" :nvl(res[a].recTypeDesc,""));
						updatePayeeLossRecLOV();
						$("selPayorClassCdLossRec").value 		= (res[a].payorClassCd == null ? "" :nvl(res[a].payorClassCd,""));
						objAC.hidObjGIACS010.hidPayorCd			= (res[a].payorCd == null ? "" :nvl(res[a].payorCd,""));
						$("txtPayorNameLossRec").value 			= (res[a].payorName == null ? "" :nvl(res[a].payorName,""));
						$("readOnlyPayorClassCdLossRec").value = unescapeHTML2(res[a].payorClassDesc == null ? "" :nvl(res[a].payorClassDesc,""));
						$("txtCollectionAmtLossRec").readOnly 	= false;
						$("foreignCurrAmtLossRec").readOnly 	= false;
						$("currencyCdLossRec").readOnly 		= false;
						$("convertRateLossRec").readOnly 		= false;
						if ($F("txtCollectionAmtLossRec") != ""){
							getCurrencyLossRec();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getManualRecoveryList",e);
		}
	}
	
	//marco - 09.30.2014
	function checkCollectionAmt(){
		new Ajax.Request(contextPath+"/GIACLossRecoveriesController",{
			parameters:{
				action: "checkCollectionAmt",
				recoveryId: objAC.hidObjGIACS010.hidRecoveryId,
				claimId: objAC.hidObjGIACS010.hidClaimId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				if(checkErrorOnResponse(response)){
					if(parseFloat(unformatCurrencyValue($F("txtCollectionAmtLossRec"))) > parseFloat(response.responseText)){
						showWaitingMessageBox("Collection cannot be more than the recoverable amount of " + formatCurrency(response.responseText) + ".", "E", function(){
							$("txtCollectionAmtLossRec").value = "";
							$("txtCollectionAmtLossRec").focus();
						});
					}
				}	
			}
		});
	}
	
	//by bonok :: test case :: 03.14.2012
	$("txtCollectionAmtLossRec").observe("change", function(){
		if($("txtCollectionAmtLossRec").value == 0){
			customShowMessageBox("Recovered amount should not be equal to zero.", imgMessage.ERROR, "txtCollectionAmtLossRec");
			$("txtCollectionAmtLossRec").clear();
		}else if($F("selTransactionTypeLossRec") == "1" && $("txtCollectionAmtLossRec").value > 99999999999999.99 || $("txtCollectionAmtLossRec").value < -99999999999999.99){
			customShowMessageBox("Entered collection amount is invalid. Valid value is from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossRec");
			$("txtCollectionAmtLossRec").clear();
		}
		//marco - SR-21903 - 03.16.2016 - validation is no longer needed
		//else if($F("txtCollectionAmtLossRec") != "" && $F("selTransactionTypeLossRec") == "1"){
    	//	checkCollectionAmt(); //marco - 09.30.2014
    	//}
	});
	
	//onblur on collection amount
	$("txtCollectionAmtLossRec").observe("blur", function(){
		
		/* by bonok :: test case :: 03.14.2012
		if (unformatCurrency("txtCollectionAmtLossRec") > 99999999999999.99 || unformatCurrency("txtCollectionAmtLossRec") < -99999999999999.99){
			customShowMessageBox("Entered collection amount is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossRec");
			$("txtCollectionAmtLossRec").clear();
			return false;
		} else if (unformatCurrency("txtCollectionAmtLossRec") == 0 && unformatCurrency("txtCollectionAmtLossRec") != ""){
			customShowMessageBox("Recovered amount should not be equal to zero.", imgMessage.ERROR, "txtCollectionAmtLossRec");
			$("txtCollectionAmtLossRec").clear();
			return false;
		} */ 

		if ($F("selTransactionTypeLossRec") == "1"){
	    	if (unformatCurrency("txtCollectionAmtLossRec") < 0){
	    		$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
	    		customShowMessageBox("Please enter positive value for tran type 1.", imgMessage.ERROR, "txtCollectionAmtLossRec");
	    		return false;
	    	}else if (unformatCurrency("txtCollectionAmtLossRec") > objAC.hidObjGIACS010.dspRecAmt){
	    		$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
	    		customShowMessageBox("Collection cannot be more than the recoverable amount of "+formatCurrency(objAC.hidObjGIACS010.dspRecAmt.toString())+".", imgMessage.ERROR, "txtCollectionAmtLossRec");
	    		return false;
	    	}
		}else if ($F("selTransactionTypeLossRec") == "2"){
			if (unformatCurrency("txtCollectionAmtLossRec") > 0){
				$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
				customShowMessageBox("Please enter negative value for tran type 2.", imgMessage.ERROR, "txtCollectionAmtLossRec");
				return false;
			}else{
				//getting sum of collection amount
				if ($F("txtCollectionAmtLossRec").replace(/,/g, "") != "" 
						&& objAC.hidObjGIACS010.hidRecoveryId != ""
						&& objAC.hidObjGIACS010.hidClaimId != ""
						&& $F("selPayorClassCdLossRec") != ""	
						&& objAC.hidObjGIACS010.hidPayorCd != ""){
					validateCollnAmt();
				}
			}	 
		}	   

		if (objAC.hidObjGIACS010.hidRecoveryId != "" && objAC.hidObjGIACS010.hidClaimId != ""){
			if (varTxtCollectionAmtLossRec != unformatCurrency("txtCollectionAmtLossRec") && $F("txtCollectionAmtLossRec").replace(/,/g, "") != "" && $F("txtDspLossDateLossRec") != ""){
				//compute foreign amount
				$("foreignCurrAmtLossRec").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossRec"),0) / nvl(unformatCurrency("convertRateLossRec"),1));
				getCurrencyLossRec();
			}	
		}	
	});	

	//function to validate recovered amount
	function validateCollnAmt(){
		ok = true;
		new Ajax.Request(contextPath+"/GIACLossRecoveriesController?action=getSumCollnAmt",{
			parameters:{
				collectionAmt: $F("txtCollectionAmtLossRec").replace(/,/g, ""),
				recoveryId: objAC.hidObjGIACS010.hidRecoveryId.toString(),
				claimId: objAC.hidObjGIACS010.hidClaimId.toString(),
				payorClassCd: $F("selPayorClassCdLossRec"),
				payorCd: objAC.hidObjGIACS010.hidPayorCd.toString()
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				if (isNaN(response.responseText)){
					$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
					customShowMessageBox(response.responseText, imgMessage.ERROR, "txtCollectionAmtLossRec");
					ok = false;
				}	
			}						
		});
		return ok;
	}	

	//for currency code
	var varCurrencyCdLossRec = "";
	$("currencyCdLossRec").observe("focus", function(){
		varCurrencyCdLossRec = $F("currencyCdLossRec");
	});	 
	$("currencyCdLossRec").observe("blur", function(){
		if ($F("currencyCdLossRec").blank()){
			return false;	
		}else{
			if (parseInt($F("currencyCdLossRec")) < 1 || parseInt($F("currencyCdLossRec")) > 99){
				showMessageBox("Entered currency code is invalid. Valid value is from 1 to 99.", imgMessage.ERROR);
				$("currencyCdLossRec").value = varCurrencyCdLossRec;
				return false;
			}	
		}	
		if (varCurrencyCdLossRec != $F("currencyCdLossRec") && !$F("txtCollectionAmtLossRec").blank()){
			new Ajax.Request(contextPath+"/GIACLossRecoveriesController?action=validateCurrencyCode",{
				parameters:{
					dspLossDate: $F("txtDspLossDateLossRec"),
					collectionAmt: unformatCurrency("txtCollectionAmtLossRec"),
					currencyCd: $F("currencyCdLossRec")
				},
				asynchronous:false,
				evalScripts:true,
				onComplete:function(response){
					var currJSON = response.responseText.evalJSON();
					if (currJSON.vMsgAlert == null || currJSON.vMsgAlert == ""){
						$("currencyDescLossRec").value = currJSON.dspCurrencyDesc;
						$("convertRateLossRec").value = formatToNineDecimal(currJSON.convertRate);
						$("currencyCdLossRec").value = currJSON.currencyCd;
						$("foreignCurrAmtLossRec").value = formatCurrency(currJSON.foreignCurrAmt);
					}else{
						showMessageBox(currJSON.vMsgAlert, imgMessage.ERROR);
						$("currencyCdLossRec").value = varCurrencyCdLossRec;
					}	
				}
			});
		}	
	});

	//for convert rate
	$("convertRateLossRec").observe("change",function(){
		
		if ($("convertRateLossRec").value < 0.000000001 || $("convertRateLossRec").value > 999.999999999 && ($("convertRateLossRec").value) != 0){
			if($("convertRateLossRec").value == 0 || parseInt($("convertRateLossRec").value) < 0){
				customShowMessageBox("Currency rate cannot be less than or equal to zero", imgMessage.ERROR, "convertRateLossRec");
				$("convertRateLossRec").clear();	
			}else{
				customShowMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR, "convertRateLossRec");
				$("convertRateLossRec").clear();	
			}			
		}else if (isNaN($("convertRateLossRec").value)){
			$("convertRateLossRec").clear();
			$("convertRateLossRec").focus();
		}
		if (!$F("convertRateLossRec").blank()){	
			$("foreignCurrAmtLossRec").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossRec"),0) / nvl(unformatCurrency("convertRateLossRec"),1));
		}	
	});

	//for foreign amount
	var varForeignCurrAmtLossRec = "";
	$("foreignCurrAmtLossRec").observe("focus",function(){
		varForeignCurrAmtLossRec = unformatCurrency("foreignCurrAmtLossRec");
	});
	$("foreignCurrAmtLossRec").observe("blur",function(){
		if ($F("foreignCurrAmtLossRec").blank()){
			return false;
		}	
		var vFcAmt =  nvl(unformatCurrency("txtCollectionAmtLossRec"),0) / nvl(unformatCurrency("convertRateLossRec"),1);
		if (unformatCurrency("foreignCurrAmtLossRec") > 99999999999999.99 || unformatCurrency("foreignCurrAmtLossRec") < -99999999999999.99){
			customShowMessageBox("Entered foreign amount is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtLossRec");
			$("foreignCurrAmtLossRec").clear();
			return false;
		}	
		
		if ($F("selTransactionTypeLossRec") == "1"){
	    	if (unformatCurrency("foreignCurrAmtLossRec") <= 0){
	    		$("foreignCurrAmtLossRec").value = formatCurrency(varForeignCurrAmtLossRec);
	    		customShowMessageBox("Zero or negative amount is not allowed.", imgMessage.ERROR, "foreignCurrAmtLossRec");
	    		return false;
	    	}
	    	if (unformatCurrency("foreignCurrAmtLossRec") > vFcAmt){
	    		$("foreignCurrAmtLossRec").value = formatCurrency(vFcAmt);
				showMessageBox("Foreign currency amount cannot be greater than "+formatCurrency(vFcAmt)+".", imgMessage.ERROR);
				return false;
			}
		}else if ($F("selTransactionTypeLossRec") == "2"){
			if (unformatCurrency("foreignCurrAmtLossRec") >= 0){
				$("foreignCurrAmtLossRec").value = formatCurrency(varForeignCurrAmtLossRec);
				customShowMessageBox("Zero or positive amount is not allowed.", imgMessage.ERROR, "foreignCurrAmtLossRec");
				return false;
			}
			if (Math.abs(unformatCurrency("foreignCurrAmtLossRec")) > Math.abs(vFcAmt)){
	    		$("foreignCurrAmtLossRec").value = formatCurrency(vFcAmt);
				showMessageBox("Foreign currency amount cannot be less than "+formatCurrency(vFcAmt)+".", imgMessage.ERROR);
				return false;
			}
		}	 
		if (varForeignCurrAmtLossRec != $F("foreignCurrAmtLossRec")){
			$("txtCollectionAmtLossRec").value = formatCurrency(unformatCurrency("foreignCurrAmtLossRec") * unformatCurrency("convertRateLossRec"));
		}	 
	});
	
	function clearFields(){
		$("selPayorClassCdLossRec").value = "";
		$("txtPayorNameLossRec").value = "";
		$("txtCollectionAmtLossRec").value = "";
		$("txtDspClaimNoLossRec").value = "";
		$("txtDspPolicyNoLossRec").value = "";
		$("txtDspAssuredNameLossRec").value = "";
		$("txtRecoveryTypeDescLossRec").value = "";
		$("txtDspLossDateLossRec").value = "";
		$("txtRemarksLossRec").value = "";
		$("readOnlyPayorClassCdLossRec").value = "";
	}
	
	//by bonok :: test case :: 03/30/2012 :: manual input of recovery no.
	$("txtRecSeqNoLossRec").observe("change", function(){
		if($F("txtRecSeqNoLossRec") == ""){
			clearFields();
		}else{
			if($("txtLineCdLossRec").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtLineCdLossRec");
			}else if($("txtIssCdLossRec").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtIssCdLossRec");
			}else if($("txtRecYearLossRec").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtRecYearLossRec");
			}else{
				$("txtRecSeqNoLossRec").value = $F("txtRecSeqNoLossRec") != "" ? Number($F("txtRecSeqNoLossRec")).toPaddedString(3) : "";
				checkPayorNameLOV();
			}
		}
	});
	
	$("txtLineCdLossRec").disable();
	$("txtIssCdLossRec").disable();
	$("txtRecYearLossRec").disable();
	$("txtRecSeqNoLossRec").disable();

	//for line cd in Recovery no.
	$("txtLineCdLossRec").observe("change",function(){
		if($F("txtLineCdLossRec") != ""){
			$("txtLineCdLossRec").value = $("txtLineCdLossRec").value.toUpperCase();
		} else {
			$("txtIssCdLossRec").value = "";
			$("txtRecYearLossRec").value = "";
			$("txtRecSeqNoLossRec").value = "";
			$("selPayorClassCdLossRec").value = "";
			$("txtPayorNameLossRec").value = "";
			$("txtCollectionAmtLossRec").value = "";
			
			$("txtDspClaimNoLossRec").value = "";
			$("txtDspPolicyNoLossRec").value = "";
			$("txtDspAssuredNameLossRec").value = "";
			$("txtRecoveryTypeDescLossRec").value = "";
			$("txtDspLossDateLossRec").value = "";
			$("txtRemarksLossRec").value = "";
			$("readOnlyPayorClassCdLossRec").value = "";
		}
	});
	
	//for iss cd in Recovery no.
	$("txtIssCdLossRec").observe("change",function(){
		if($F("txtIssCdLossRec") != ""){
			$("txtIssCdLossRec").value = $("txtIssCdLossRec").value.toUpperCase();
		} else {
			$("txtRecYearLossRec").value = "";
			$("txtRecSeqNoLossRec").value = "";
			$("selPayorClassCdLossRec").value = "";
			$("txtPayorNameLossRec").value = "";
			$("txtCollectionAmtLossRec").value = "";
			
			$("txtDspClaimNoLossRec").value = "";
			$("txtDspPolicyNoLossRec").value = "";
			$("txtDspAssuredNameLossRec").value = "";
			$("txtRecoveryTypeDescLossRec").value = "";
			$("txtDspLossDateLossRec").value = "";
			$("txtRemarksLossRec").value = "";
			$("readOnlyPayorClassCdLossRec").value = "";
		}
	});
	
	//for loss year in Recovery no.
	$("txtRecYearLossRec").observe("change",function(){
		if($F("txtRecYearLossRec") == ""){
			$("txtRecSeqNoLossRec").value = "";
			$("selPayorClassCdLossRec").value = "";
			$("txtPayorNameLossRec").value = "";
			$("txtCollectionAmtLossRec").value = "";
			
			$("txtDspClaimNoLossRec").value = "";
			$("txtDspPolicyNoLossRec").value = "";
			$("txtDspAssuredNameLossRec").value = "";
			$("txtRecoveryTypeDescLossRec").value = "";
			$("txtDspLossDateLossRec").value = "";
			$("txtRemarksLossRec").value = "";
			$("readOnlyPayorClassCdLossRec").value = "";
		}
	});
	
	//for seq no in Recovery no.
	/* $("txtRecSeqNoLossRec").observe("change",function(){
		if($F("txtRecSeqNoLossRec") == ""){
			$("selPayorClassCdLossRec").value = "";
			$("txtPayorNameLossRec").value = "";
			$("txtCollectionAmtLossRec").value = "";
			
			$("txtDspClaimNoLossRec").value = "";
			$("txtDspPolicyNoLossRec").value = "";
			$("txtDspAssuredNameLossRec").value = "";
			$("txtRecoveryTypeDescLossRec").value = "";
			$("txtDspLossDateLossRec").value = "";
			$("txtRemarksLossRec").value = "";
		}
	}); */
	
	//get the default value
	function getDefaults(){
		$("btnAddLossRec").value = "Update";
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
			enableButton("btnDeleteLossRec");
		}
	}

	//to clear the form inputs
	function clearForm(){
		$("selTransactionTypeLossRec").clear();
		$("txtLineCdLossRec").clear();
		$("txtIssCdLossRec").clear();
		$("txtRecYearLossRec").clear();
		$("txtRecSeqNoLossRec").clear();
		objAC.hidObjGIACS010.hidClaimId			= "";
		$("txtDspClaimNoLossRec").clear();
		$("txtDspPolicyNoLossRec").clear();
		$("txtDspLossDateLossRec").clear();
		$("txtDspAssuredNameLossRec").clear();
		objAC.hidObjGIACS010.hidRecoveryId		= "";
		objAC.hidObjGIACS010.hidRecTypeCd		= "";
		$("txtRecoveryTypeDescLossRec").clear();
		//updatePayeeLossRecLOV();
		//$("selPayorClassCdLossRec").disable();
		$("selPayorClassCdLossRec").clear();
		objAC.hidObjGIACS010.hidPayorCd			= "";
		$("txtPayorNameLossRec").clear();
		$("txtRemarksLossRec").clear();
		$("txtCollectionAmtLossRec").clear();
		objAC.hidObjGIACS010.hidOrPrintTag 		= "N";
		objAC.hidObjGIACS010.hidCpiRecNo 		= "";
		objAC.hidObjGIACS010.hidCpiBranchCd 	= "";
		objAC.hidObjGIACS010.hidAcctEntTag		= "";
		$("chkAcctEntTagLossRec").checked = true;
		$("currencyCdLossRec").clear();
		$("currencyDescLossRec").clear();
		$("convertRateLossRec").clear();
		$("foreignCurrAmtLossRec").clear();
		//objAC.hidObjGIACS010.dspRecAmt		= "";
		$("txtCollectionAmtLossRec").readOnly 		= true;
		$("foreignCurrAmtLossRec").readOnly 		= true;
		$("currencyCdLossRec").readOnly 			= true;
		$("convertRateLossRec").readOnly 			= true;
		//$("selPayorClassCdLossRec").show();
		$("readOnlyPayorClassCdLossRec").clear();
		$("selTransactionTypeLossRec").show();
		$("readOnlyTransactionTypeLossRec").hide();
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
			$("chkAcctEntTagLossRec").enable();
			$("txtRemarksLossRec").readOnly 			= false;
			enableButton("btnAddLossRec");
		}

		objAC.hidObjGIACS010.hidUpdateable		= "Y";
		enableSearch("payorNameLOV");
		enableSearch("recoveryNoLossRecDate");
		deselectRows("directTransLossRecoveriesTable","rowDirectTransLossRecoveries");	
		$("btnAddLossRec").value = "Add";
		
		if (objACGlobal.tranFlagState != 'O'){
			disableButton("btnAddLossRec");
			disableButton("btnSaveDirectTransLossRec");
			$("selTransactionTypeLossRec").disable();
		}
		disableButton("btnDeleteLossRec");
		computeTotalAmountInTable();
	}	

	//create new Object to be added on Object Array
	function setLossRecObject() {
		try {
			var newObj = new Object();
			newObj.recordStatus			= objAC.hidObjGIACS010.recordStatus;
			newObj.gaccTranId			= objACGlobal.gaccTranId;
			newObj.transactionType		= changeSingleAndDoubleQuotes2($F("selTransactionTypeLossRec"));
			newObj.claimId				= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidClaimId.toString());
			newObj.recoveryId			= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidRecoveryId.toString());	
			newObj.payorClassCd			= changeSingleAndDoubleQuotes2($F("selPayorClassCdLossRec"));
			newObj.payorCd				= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidPayorCd.toString());
			newObj.collectionAmt		= changeSingleAndDoubleQuotes2($F("txtCollectionAmtLossRec").replace(/,/g, ""));
			newObj.currencyCd			= changeSingleAndDoubleQuotes2($F("currencyCdLossRec"));
			newObj.convertRate			= changeSingleAndDoubleQuotes2($F("convertRateLossRec").replace(/,/g, ""));	
			newObj.foreignCurrAmt		= changeSingleAndDoubleQuotes2($F("foreignCurrAmtLossRec").replace(/,/g, ""));
			newObj.orPrintTag			= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidOrPrintTag.toString());
			newObj.remarks				= changeSingleAndDoubleQuotes2($F("txtRemarksLossRec"));
			newObj.cpiRecNo				= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidCpiRecNo.toString());
			newObj.cpiBranchCd			= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidCpiBranchCd.toString());
			newObj.acctEntTag			= changeSingleAndDoubleQuotes2($("chkAcctEntTagLossRec").checked ? "Y" :"N");
			newObj.transactionTypeDesc	= changeSingleAndDoubleQuotes2(getListAttributeValue("selTransactionTypeLossRec","typeDesc"));
			newObj.lineCd				= changeSingleAndDoubleQuotes2($F("txtLineCdLossRec"));
			newObj.issCd				= changeSingleAndDoubleQuotes2($F("txtIssCdLossRec"));
			newObj.recYear				= changeSingleAndDoubleQuotes2($F("txtRecYearLossRec"));
			newObj.recSeqNo				= changeSingleAndDoubleQuotes2($F("txtRecSeqNoLossRec"));
			newObj.dspClaimNo			= changeSingleAndDoubleQuotes2($F("txtDspClaimNoLossRec"));	
			newObj.dspPolicyNo			= changeSingleAndDoubleQuotes2($F("txtDspPolicyNoLossRec"));
			newObj.dspLossDate			= makeDate(changeSingleAndDoubleQuotes2($F("txtDspLossDateLossRec")));
			newObj.dspAssuredName		= changeSingleAndDoubleQuotes2($F("txtDspAssuredNameLossRec"));	
			newObj.recTypeCd			= changeSingleAndDoubleQuotes2(objAC.hidObjGIACS010.hidRecTypeCd.toString());
			newObj.recTypeDesc			= changeSingleAndDoubleQuotes2($F("txtRecoveryTypeDescLossRec"));
			newObj.payorName			= changeSingleAndDoubleQuotes2($F("txtPayorNameLossRec"));
			newObj.payorClassDesc		= changeSingleAndDoubleQuotes2(getListTextValue("selPayorClassCdLossRec"));
			newObj.dspCurrencyDesc		= changeSingleAndDoubleQuotes2($F("currencyDescLossRec"));
						
			return newObj; 
		}catch(e){
			showErrorMessage("setLossRecObject", e);
			//showMessageBox("Error setting loss recoveries, "+e.message ,imgMessage.ERROR);
		}
	}		

	//when Add/Update button click
	$("btnAddLossRec").observe("click", function(){
		addLossRec();
	});
	
	function checkDuplicate(){
		var rows = objAC.objLossRecAC010;
		for(var i = 0; i < rows.length; i++){
			if(rows[i].lineCd == $F("txtLineCdLossRec") && rows[i].issCd == $F("txtIssCdLossRec") &&
				rows[i].recYear == $F("txtRecYearLossRec") && removeLeadingZero(rows[i].recSeqNo) == $F("txtRecSeqNoLossRec") &&
				rows[i].recordStatus != -1 && $F("btnAddLossRec") != "Update" &&
				rows[i].payorClassCd == $F("selPayorClassCdLossRec")){ //marco - 12.19.2014 - added payorClassCd condition
				return true;
			}
		}
		return false;
	}
	
	//function add record
	function addLossRec(){
		try{
			if (objAC.hidObjGIACS010.hidUpdateable == "N"){ //to have a disable effect on the add/update
				return false;
			}
			//check required fields first
			var exists = false;
			var varTxtCollectionAmtLossRec = $F("txtCollectionAmtLossRec");
			
			if ($F("selTransactionTypeLossRec").blank()){
				//customShowMessageBox("Transaction type is required.", imgMessage.ERROR , "selTransactionTypeLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selTransactionTypeLossRec");
				exists = true;
			}else if ($F("txtLineCdLossRec").blank() || $F("txtIssCdLossRec").blank() || $F("txtRecYearLossRec").blank() || $F("txtRecSeqNoLossRec").blank()){
				//customShowMessageBox("Recovery no. is required.", imgMessage.ERROR , "txtLineCdLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtLineCdLossRec");
				exists = true;	
			}else if (objAC.hidObjGIACS010.hidRecoveryId == ""){
				//customShowMessageBox("Recovery id is required.", imgMessage.ERROR , "txtLineCdLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtLineCdLossRec");
				exists = true;	
			}else if (objAC.hidObjGIACS010.hidClaimId == ""){
				//customShowMessageBox("Claim id is required.", imgMessage.ERROR , "txtLineCdLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtLineCdLossRec");
				exists = true;	
			}else if ($F("selPayorClassCdLossRec").blank()){
				//customShowMessageBox("Payee class is required.", imgMessage.ERROR , "selPayorClassCdLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selPayorClassCdLossRec");
				exists = true;
			}else if ($F("txtPayorNameLossRec").blank() || objAC.hidObjGIACS010.hidPayorCd == ""){
				//customShowMessageBox("Payee name is required.", imgMessage.ERROR , "txtPayorNameLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtPayorNameLossRec");
				exists = true;
			}else if ($F("txtCollectionAmtLossRec").blank()){
				//customShowMessageBox("Recovered amount is required.", imgMessage.ERROR , "txtCollectionAmtLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtCollectionAmtLossRec");
				exists = true;
			}/* by bonok :: test case :: 03.14.2012
				else if (unformatCurrency("txtCollectionAmtLossRec") == 0){
				customShowMessageBox("Recovered amount should not be equal to zero.", imgMessage.ERROR , "txtCollectionAmtLossRec");
				exists = true; 
			} */else if ($F("foreignCurrAmtLossRec").blank()){
				//customShowMessageBox("Foreign amount is required.", imgMessage.ERROR , "foreignCurrAmtLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "foreignCurrAmtLossRec");
				exists = true;
			}else if ($F("currencyCdLossRec").blank()){
				//customShowMessageBox("Currency code is required.", imgMessage.ERROR , "currencyCdLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "currencyCdLossRec");
				exists = true;
			}else if ($F("convertRateLossRec").blank()){
				//customShowMessageBox("Convert rate is required.", imgMessage.ERROR , "convertRateLossRec"); by bonok :: test case :: 03.15.2012
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "convertRateLossRec");
				exists = true;
			}else if(checkDuplicate()){ //marco - 10.02.2014
				showMessageBox("Record already exists with the same Recovery No.", "E");
				exists = true;
			}else if ($F("selTransactionTypeLossRec") == "2"){
				if (unformatCurrency("txtCollectionAmtLossRec") > 0){
					$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
					customShowMessageBox("Please enter negative value for tran type 2.", imgMessage.ERROR, "txtCollectionAmtLossRec");
					exists = true;
				}else{
					//getting sum of collection amount
					if ($F("txtCollectionAmtLossRec").replace(/,/g, "") != "" 
							&& objAC.hidObjGIACS010.hidRecoveryId != ""
							&& objAC.hidObjGIACS010.hidClaimId != ""
							&& $F("selPayorClassCdLossRec") != ""	
							&& objAC.hidObjGIACS010.hidPayorCd != ""){
						exists = !validateCollnAmt() ? true :false;
					}
				}
			}else if ($F("selTransactionTypeLossRec") == "1"){
		    	if (unformatCurrency("txtCollectionAmtLossRec") < 0){
		    		$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
		    		customShowMessageBox("Please enter positive value for tran type 1.", imgMessage.ERROR, "txtCollectionAmtLossRec");
		    		exists = true;
		    	}//else if (unformatCurrency("txtCollectionAmtLossRec") > objAC.hidObjGIACS010.dspRecAmt){
		    	//	$("txtCollectionAmtLossRec").value = formatCurrency(varTxtCollectionAmtLossRec);
		    	//	customShowMessageBox("Collection cannot be more than the recoverable amount of "+formatCurrency(objAC.hidObjGIACS010.dspRecAmt.toString())+".", imgMessage.ERROR, "txtCollectionAmtLossRec");
		    	//	exists = true;
		    	//}	
			}		

			if (!exists){
				var newObj  = setLossRecObject();
				var content = prepareDirectTransLossRecoveries(newObj);
				if ($F("btnAddLossRec") == "Update"){
					//on UPDATE records
					newObj.divCtrId = getSelectedRowId("rowDirectTransLossRecoveries");
					$("rowDirectTransLossRecoveries"+newObj.divCtrId).update(content);	
					addModifiedJSONObjectAccounting(objAC.objLossRecAC010, newObj);
					changeTag = 1;
					//$("payorNameLOV").hide();
				}else{
					//on ADD records
					var tableContainer = $("directTransLossRecoveriesListing");
					var newDiv = new Element("div");
					newObj.divCtrId = generateDivCtrId(objAC.objLossRecAC010);
					addNewJSONObject(objAC.objLossRecAC010, newObj);
					newDiv.setAttribute("id", "rowDirectTransLossRecoveries"+newObj.divCtrId);
					newDiv.setAttribute("name", "rowDirectTransLossRecoveries");
					newDiv.addClassName("tableRow");
					newDiv.update(content);
					tableContainer.insert({bottom : newDiv});
					changeTag = 1;	
					//$("payorNameLOV").hide();
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});

					newDiv.observe("click", function(){
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow")){
							$$("div#directTransLossRecoveriesTable div[name=rowDirectTransLossRecoveries]").each(function(r){
								if (newDiv.getAttribute("id") != r.getAttribute("id")){
									r.removeClassName("selectedRow");
								}else{
									getDefaults();
									var id = (newDiv.readAttribute("id")).substring(newDiv.readAttribute("name").length);
									for(var a=0; a<objAC.objLossRecAC010.length; a++){
										if (objAC.objLossRecAC010[a].divCtrId == id){
											supplyDirectTransLossRecoveries(objAC.objLossRecAC010[a]);
											$("selPayorClassCdLossRec").hide();
											$("readOnlyPayorClassCdLossRec").show();
										}
									}
								}
							});
						}else{
							clearForm();
						}	
					});

					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function(){
							checkTableItemInfo("directTransLossRecoveriesTable","directTransLossRecoveriesListing","rowDirectTransLossRecoveries");
						}
					});
				}
				clearForm();
			}
		}catch(e){
			showErrorMessage("addLossRec", e);
			//showMessageBox("Error adding loss recoveries, "+e.message, imgMessage.ERROR);
		}		
	}	

	//when DELETE button click
	$("btnDeleteLossRec").observe("click",function(){
		deleteLossRec();
	});

	//function delete record
	function deleteLossRec(){
		$$("div[name='rowDirectTransLossRecoveries']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				for(var a=0; a<objAC.objLossRecAC010.length; a++){
					if (objAC.objLossRecAC010[a].divCtrId == id){
						var delObj = objAC.objLossRecAC010[a];
						if (delObj.orPrintTag == "Y"){
							showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
							return false;
						}else{
							var delOk = true;
							if ($F("selTransactionTypeLossRec") == "1"){
								new Ajax.Request(contextPath+"/GIACLossRecoveriesController?action=validateDelete",{
									parameters:{
										claimId: objAC.hidObjGIACS010.hidClaimId.toString(),
										gaccTranId: objACGlobal.gaccTranId
									},
									asynchronous:false,
									evalScripts:true,
									onComplete:function(response){
										if (response.responseText != ""){
											showMessageBox(response.responseText, imgMessage.ERROR);
											delOk = false;
										}	
									}	
								});
							}	
							if (delOk){
								changeTag = 1;
								Effect.Fade(row,{
									duration: .5,
									afterFinish: function(){
										addDeletedJSONObjectAccounting(objAC.objLossRecAC010, delObj);
										row.remove();
										clearForm();
										checkTableItemInfo("directTransLossRecoveriesTable","directTransLossRecoveriesListing","rowDirectTransLossRecoveries");
									}
								});	
							}
						}
					}
				}
			}
		});	
	}	

	//when SAVE button click
	$("btnSaveDirectTransLossRec").observe("click",function(){
		saveDirectTransLossRec();
	});
	
	function saveDirectTransLossRec(){ 
		try{
			if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS010")){ //marco - SR-5727 - 03.10.2017
				return;
			}
			
			if (checkObjectIfChangesExist(objAC.objLossRecAC010)){
				var addedRows 	 = getAddedJSONObjects(objAC.objLossRecAC010);
				var modifiedRows = getModifiedJSONObjects(objAC.objLossRecAC010);
				var delRows 	 = getDeletedJSONObjects(objAC.objLossRecAC010);
				var setRows		 = addedRows.concat(modifiedRows);
				new Ajax.Request(contextPath+"/GIACLossRecoveriesController?action=saveLossRec",{
					method: "POST",
					parameters:{
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						globalTranSource: objACGlobal.tranSource,
						globalOrFlag: objACGlobal.orFlag,
						setRows: prepareJsonAsParameter(setRows),
					 	delRows: prepareJsonAsParameter(delRows)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice("Saving Loss Recoveries, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								changeTag = 0;
								clearObjectRecordStatus(objAC.objLossRecAC010); //to clear the record status on JSON Array
								clearForm();
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}		
						}	
					}	 
				});	
			}else{
				showMessageBox("No changes to save." ,imgMessage.INFO);
			}		
		}catch (e) {
			showErrorMessage("lossRecoveries.jsp - btnSaveDirectTransLossRec", e);
			//showMessageBox("Error while saving, "+e.message ,imgMessage.ERROR);
		}	
	}
	
	// for manual input of recovery no. - by bonok :: 04.02.2012
	$("selTransactionTypeLossRec").observe("change", function(){
		if($("selTransactionTypeLossRec").value != ""){
			$("txtLineCdLossRec").enable();
			$("txtIssCdLossRec").enable();
			$("txtRecYearLossRec").enable();
			$("txtRecSeqNoLossRec").enable();
		}else{
			$("txtLineCdLossRec").disable();
			$("txtIssCdLossRec").disable();
			$("txtRecYearLossRec").disable();
			$("txtRecSeqNoLossRec").disable();
		}
	});
	
	//when CANCEL button click - by bonok :: test case :: 03.15.2012
	$("btnCancelDirectTransLossRec").observe("click", function(){
		if (checkObjectIfChangesExist(objAC.objLossRecAC010) || changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						saveDirectTransLossRec();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS003"){
							if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
								showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}else{
								showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}
							objACGlobal.previousModule = null;							
						}else if(objACGlobal.previousModule == "GIACS071"){
							updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					},
					function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS003"){
							if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
								showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}else{
								showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
							}
							objACGlobal.previousModule = null;							
						}else if(objACGlobal.previousModule == "GIACS071"){
							updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					},"");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});

	//compute the total amount in table
	function computeTotalAmountInTable(){
		var total = 0;
		var ctr = 0;
		for(var a=0; a<objAC.objLossRecAC010.length; a++){
			if (objAC.objLossRecAC010[a].recordStatus != -1){
				ctr++;
				var collectionAmt = objAC.objLossRecAC010[a].collectionAmt.replace(/,/g, "");	
				total = parseFloat(total) + parseFloat((collectionAmt == "" || collectionAmt == null ? 0 :collectionAmt));
			}
		}	
		if (parseInt(ctr) <= 5){
			$("lossRecoveriesTotalAmtMainDiv").setStyle("padding-right:2px");
		}else{
			$("lossRecoveriesTotalAmtMainDiv").setStyle("padding-right:19px");
		}	
		if (parseInt(ctr) > 0){
			$("lossRecoveriesTotalAmtMainDiv").show();
		}else{
			$("lossRecoveriesTotalAmtMainDiv").hide();
		}
		$("lossRecoveriesTotalAmtMainDiv").down("label",1).update(formatCurrency(total).truncate(30, "..."));
	}	
	
	clearForm();
	checkTableItemInfo("directTransLossRecoveriesTable","directTransLossRecoveriesListing","rowDirectTransLossRecoveries");
	setDocumentTitle("Collections on Loss Recoveries");
	window.scrollTo(0,0); 	
	hideNotice("");
	initializeChangeTagBehavior(saveDirectTransLossRec);
}catch(e){
	showErrorMessage("computeTotalAmountInTable", e);
}

	function disableGIACS010(){
		try {
			$("selTransactionTypeLossRec").disable();
			$("selTransactionTypeLossRec").removeClassName("required");
			$("txtLineCdLossRec").removeClassName("required");
			$("txtIssCdLossRec").removeClassName("required");
			$("txtRecYearLossRec").removeClassName("required");
			$("txtRecSeqNoLossRec").removeClassName("required");
			disableSearch("recoveryNoLossRecDate");
			disableSearch("payorNameLOV");
			$("selPayorClassCdLossRec").removeClassName("required");
			$("txtPayorNameLossRec").removeClassName("required");
			$("txtCollectionAmtLossRec").removeClassName("required");
			$("chkAcctEntTagLossRec").disable();
			$("txtRemarksLossRec").readOnly = true;
			$("readOnlyPayorClassCdLossRec").removeClassName("required");
			$("readOnlyTransactionTypeLossRec").removeClassName("required");
			disableButton("btnAddLossRec");
			disableButton("btnSaveDirectTransLossRec");
			$("currencyCdLossRec").removeClassName("required");
			$("convertRateLossRec").removeClassName("required");
			$("foreignCurrAmtLossRec").removeClassName("required");		
		} catch(e){
			showErrorMessage("disableGIACS010", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS010();
	}
	
	$("acExit").stopObserving("click"); 
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveOutFaculPremPayts();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;
				
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
</script>
