<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Invoice Commission Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="invCommInfoMainDiv" name="invCommInfoMainDiv">
	<div id="invCommInfo" name="invCommInfo" style="margin: 10px;">
		<div id="invCommInfoTableGridSectionDiv" name="invCommInfoTableGridSectionDiv">
			<div id="invCommInfoTable" name="invCommInfoTable" style="height:220px;"></div>
		</div>
		<div id="invCommInfoFormDiv" name="invCommInfoFormDiv">
			<input type="hidden" id="hidInvCommFundCd" name="hidInvCommFundCd"/>
			<input type="hidden" id="hidInvCommBranchCd" name="hidInvCommBranchCd"/>
			<input type="hidden" id="hidInvCommRecId" name="hidInvCommRecId"/>
			<input type="hidden" id="hidInvIntmNo" name="hidInvIntmNo"/>
			<input type="hidden" id="hidInvWtaxRate" name="hidInvWtaxRate"/>
			<input type="hidden" id="hidDeleteSw" name="hidDeleteSw" value="N"/>
			<input type="hidden" id="hidInvTranFlag" name="hidInvTranFlag" value="U"/>
			<input type="hidden" id="hidInvTranNo" name="hidInvTranNo"/>
			
			<table align="center" border="0" style="padding: 0 45px 0">
				<tr>
					<td class="rightAligned" style="width:118px;">Intermediary</td>
					<td class="leftAligned" style="width:520px;" colspan="3">
						<div id="intrmdryDiv" class="required" style="margin-left: 1px; border: 1px solid gray; width: 505px; height: 19px;">
							<input type="hidden" id="hidIntmNo" name="hidIntmNo"/>
							<input type="hidden" id="hidWtaxRate" name="hidWtaxRate"/>
							<input type="hidden" id="hidIntmType" name="hidIntmType"/>
							<input type="text" class="required" style="width: 95%; height: 12px; border:none; margin:0px; padding:3px 2px;" id="txtDspIntmName" name="txtDspIntmName" readonly="readonly" value=""/>
							<img id="imgSearchIntrmdry" name="imgSearchIntrmdry" alt="Go" src="/Geniisys/images/misc/searchIcon.png" style="float: right;">
						</div>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Parent Intermediary</td>
					<td class="leftAligned" colspan="3">
						<input type="text" style="width: 500px;" id="txtPrntIntmdry" name="txtPrntIntmdry" readonly="readonly" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" style="border: 1px solid gray; width: 505px; height: 21px; float: left;">
							<textarea onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);" id="txtRemarks" maxlength="4000" style="width: 95%; border: medium none; height: 13px; float: left; resize: none;"></textarea>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editTxtRemarks" name="editTxtRemarks" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Share Percentage</td>
					<td class="leftAligned">
						<!-- <input type="text" class="required applyDecimalRegExp" style="width: 160px;" id="txtSharePercentage" name="txtSharePercentage" regexppatt="pDeci0309" value=""/> -->
						<input type="text" class="required" style="width: 160px; text-align: right;" id="txtSharePercentage" name="txtSharePercentage" value="" maxlength="13"/>
					</td>
					<td class="rightAligned" style="width:150px;">Total Commission</td>
					<td class="leftAligned">
						<input type="text" style="width: 160px;" id="txtCommissionAmt" name="txtCommissionAmt" readonly="readonly" class="money" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Share of Premium</td>
					<td class="leftAligned">
						<input type="text" style="width: 160px;" id="txtPremAmt" name="txtPremAmt" readonly="readonly" class="money" value=""/>
					</td>
					<td class="rightAligned"  style="width:150px;">Total Withholding Tax</td>
					<td class="leftAligned">
						<input type="text" style="width: 160px;" id="txtWholdtingTax" name="txtWholdtingTax" readonly="readonly" class="money" value=""/>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="rightAligned">
						<input type="button" id="btnBancAssrnceDtls" name="btnBancAssrnceDtls"  style="width: 170px; margin-right:10px;" class="button hover"   value="Bancassurance Details" />
					</td>
					<td class="rightAligned">Total Net Commission</td>
					<td class="leftAligned">
						<input type="text" style="width: 160px;" id="txtNetCommAmt" name="txtNetCommAmt" readonly="readonly" class="money" value=""/>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin:10px 0;" align="center">
			<input type="button" id="btnAddInvComm" name="btnAddInvComm"  style="width: 65px;" class="button hover"   value="Add" />
			<input type="button" id="btnDelInvComm" name="btnDelInvComm"  style="width: 65px;" class="button hover"   value="Delete" />
		</div>
		<div class="buttonsDiv" style="margin-bottom:15px; border:1px solid #E0E0E0; padding:10px 0" align="center">
			<input type="button" id="btnRecomputeCommRt" name="btnCancel"  style="width: 200px;" class="button hover"   value="Recompute Commission Rate" />
			<input type="button" id="btnRecomputeWithTax" name="btnCancel"  style="width: 200px;" class="button hover"   value="Recompute Withholding Tax" />
		</div>
	</div>
</div>
<div>
	<input type="hidden" id="hidVModBtyp" value="N"/>
	<input type="hidden" id="hidVModIntm" value="N"/>
	<input type="hidden" id="hidVLovIntm" value="N"/>
	<input type="hidden" id="hidVPrvIntm" />
	<input type="hidden" id="hidBancaBModTag" />
	<input type="hidden" id="hidParamIntmType"/>
	<input type="hidden" id="hidBancassuranceSw"/>
	<input type="hidden" id="hidVSharePercentage"/>
	<input type="hidden" id="hidVCommRecId"/>
	<input type="hidden" id="hidTempFundCd"/>
	<input type="hidden" id="hidTempBranchCd"/>
	<input type="hidden" id="hidTempCommRecId"/>
	<input type="hidden" id="hidTempTranNo"/>
	<input type="hidden" id="hidTotSharePercentage"/>
	<input type="hidden" id="hidUpdShrPercentage"/>
</div>
<script>
	//Show Table Grid
	try {
		var jsonInvCommInfoList = JSON.parse('${jsonInvCommInfoList}');
		var allowEdit = 'true';
		objACGlobal.objGIACS408.objInvCommArray = [];
		 
		
		var objInvCommArray = [];
		var objInvCommArrayTemp = [];
		invCommInfoTableModel = {
			url : contextPath+ "/GIACDisbursementUtilitiesController?action=showInvoiceCommInfoListing&refresh=1",
			options : {
				width : '900px',
				height : '200px',
				pager : {}, 
				onCellFocus : function(element, value, x, y, id) {
					selectedRecord = tbgInvCommInfo.geniisysRows[y]; //koks
					tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgInvCommInfo.keys.releaseKeys();
					
					$("hidUpdShrPercentage").value = tbgInvCommInfo.geniisysRows[y].sharePercentage;
					
					var obj = tbgInvCommInfo.geniisysRows[y];
					populateInvCommInfoDtls(obj);
					objACGlobal.objGIACS408.executeQueryPerilInfo(obj.fundCd, obj.branchCd, obj.commRecId, obj.intmNo, obj.lineCd);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					selectedRecord = null; //koks
					tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgInvCommInfo.keys.releaseKeys();
					
					$("hidUpdShrPercentage").value = 0;
					
					populateInvCommInfoDtls(null);
					objACGlobal.objGIACS408.enterQueryPerilInfo();
				},
				onSort : function(){
					selectedRecord = null; //koks
					tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgInvCommInfo.keys.releaseKeys();
					
					if(tbgInvCommInfo.geniisysRows.length > 0){			
						populateInvCommInfoDtls(null);
						objACGlobal.objGIACS408.enterQueryPerilInfo();
						$$('.mtgRow'+tbgInvCommInfo._mtgId).each(function(r){
							r.removeClassName('selectedRow');
						});
					}
				},
				beforeClick: function(){
					if(objACGlobal.objGIACS408.piChangeTag == 1 /*|| objACGlobal.objGIACS408.icChangeTag == 1*/){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				beforeSort: function(){
					if(objACGlobal.objGIACS408.piChangeTag == 1 || objACGlobal.objGIACS408.icChangeTag == 1){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				prePager: function(){
					if(objACGlobal.objGIACS408.piChangeTag == 1 || objACGlobal.objGIACS408.icChangeTag == 1){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				toolbar : {
					elements : [MyTableGrid.HISTORY_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onHistory: function(){
						if(tbgInvCommInfo.geniisysRows.length > 0){
							invCommHistoryOverlay();
						}						
					},onFilter : function(){
						tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
						tbgInvCommInfo.keys.releaseKeys();
						
						populateInvCommInfoDtls(null);
						objACGlobal.objGIACS408.enterQueryPerilInfo();
						if(tbgInvCommInfo.geniisysRows.length > 0){			
							$$('.mtgRow'+tbgInvCommInfo._mtgId).each(function(r){
								r.removeClassName('selectedRow');
							});
						}
					},
					onRefresh : function(){
						selectedRecord = null; //koks
						tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
						tbgInvCommInfo.keys.releaseKeys();
						
						if(tbgInvCommInfo.geniisysRows.length > 0){		
							populateInvCommInfoDtls(null);
							objACGlobal.objGIACS408.enterQueryPerilInfo();	
							$$('.mtgRow'+tbgInvCommInfo._mtgId).each(function(r){
								r.removeClassName('selectedRow');
							});
						}
					}
				}
			},
			columnModel : [ 
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
				{
					id: 'funcdCd',
					width: '0',
					visible: false 
				},
				{
					id: 'branchCd',
					width: '0',
					visible: false 
				},
				{
					id: 'commRecId',
					width: '0',
					visible: false 
				},
				{
					id: 'intmNo',
					width: '0',
					visible: false 
				},
/* 				{
					id : "deleteSw",
					title : "D",
					altTitle: 'Record Deleted',
					width : '25px',
					sortable: false,
					editable: false,
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
				    	getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				    })
				},  */
				{
					id : "intmName",
					title : "Intermediary",
					width : '275px',
					filterOption : true
				},
				{
					id : "prntIntmdry",
					title : "Parent Intermediary",
					width : '265px',
					filterOption : true
				},
				{
					id : "sharePercentage",
					title : "Share Percentage",
					titleAlign : "right",
					width : '150px',
					filterOption : true,
					//type : 'number',
					filterOptionType : 'number',
					geniisysClass : 'rate'
				},
				{
					id : "premiumAmt",
					title : "Share of Premium",
					titleAlign : "right",
					width : '150px',
					filterOption : true,
					//type : 'number',
					filterOptionType : 'number',
					geniisysClass : 'money'
				},
				{
					id: 'commissionAmt',
					width: '0',
					visible: false 
				},
				{
					id: 'wholdingTax',
					width: '0',
					visible: false 
				},
				{
					id: 'remarks',
					width: '0',
					visible: false 
				},
				{
					id: 'tranNo',
					width: '0',
					visible: false 
				},
				{
					id: 'tranFlag',
					width: '0',
					visible: false 
				},
				{
					id: 'issCd',
					width: '0',
					visible: false 
				},
				{
					id: 'premSeqNo',
					width: '0',
					visible: false 
				},
				{
					id: 'policyId',
					width: '0',
					visible: false 
				}
			],
			rows : jsonInvCommInfoList.rows
		};
		tbgInvCommInfo = new MyTableGrid(invCommInfoTableModel);
		tbgInvCommInfo.pager = jsonInvCommInfoList;
		tbgInvCommInfo.render('invCommInfoTable');
		tbgInvCommInfo.afterRender = function(){
			try{
				objInvCommArray = tbgInvCommInfo.geniisysRows;
				objInvCommArrayTemp = tbgInvCommInfo.geniisysRows;
				tbgInvCommInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
				tbgInvCommInfo.keys.releaseKeys();
				
				objACGlobal.objGIACS408.objInvCommArray = objInvCommArray;
				if(tbgInvCommInfo.geniisysRows.length > 0){
					var obj = tbgInvCommInfo.geniisysRows[0];
					selectedRecord = tbgInvCommInfo.geniisysRows[0];
					tbgInvCommInfo.selectRow(0);											
					populateInvCommInfoDtls(obj);
					
					objACGlobal.objGIACS408.executeQueryPerilInfo(obj.fundCd, obj.branchCd, obj.commRecId, obj.intmNo, obj.lineCd);
					
					$("hidInvTranNo").value = tbgInvCommInfo.geniisysRows[0].tranNo;
					$("hidVCommRecId").value = tbgInvCommInfo.geniisysRows[0].commRecId;
					$("hidTempFundCd").value = tbgInvCommInfo.geniisysRows[0].fundCd;
					$("hidTempBranchCd").value = tbgInvCommInfo.geniisysRows[0].branchCd;
					$("hidTempCommRecId").value = tbgInvCommInfo.geniisysRows[0].commRecId;
					$("hidTempTranNo").value = tbgInvCommInfo.geniisysRows[0].tranNo;
					
					$("hidTotSharePercentage").value = tbgInvCommInfo.geniisysRows[0].totSharePercentage;
					$("hidUpdShrPercentage").value = tbgInvCommInfo.geniisysRows[0].sharePercentage;
				}
				
				if(objACGlobal.objGIACS408.objInvCommArray.length != 0){
					for(var i=0; i<objACGlobal.objGIACS408.objInvCommArray.length; i++){
						for(var j=0; j<objInvCommArray.length; j++){
							if(objACGlobal.objGIACS408.objInvCommArray[i].fundCd == objInvCommArray[j].fundCd &&
							   objACGlobal.objGIACS408.objInvCommArray[i].branchCd == objInvCommArray[j].branchCd &&
							   objACGlobal.objGIACS408.objInvCommArray[i].commRecId == objInvCommArray[j].commRecId &&
							   objACGlobal.objGIACS408.objInvCommArray[i].intmNo == objInvCommArray[j].intmNo){

								tbgInvCommInfo.updateVisibleRowOnly(objACGlobal.objGIACS408.objInvCommArray[i], j);
							}	
						}
					}
				}

				if(tbgInvCommInfo.geniisysRows.length > 0){			
					$('mtgRow'+tbgInvCommInfo._mtgId+'_0').addClassName('selectedRow');
				}
				getInvoiceCommList();
			}catch(e){
				showErrorMessage("tbgInvCommInfo.afterRender", e);
			}
		};
	} catch (e) {
		showErrorMessage("invCommInfoTableModel", e);
	}
	disableButton("btnBancAssrnceDtls");
	
	$("txtSharePercentage").observe("focus", function(){
		$("txtSharePercentage").setAttribute("lastValidValue", this.value);
	});
	
	$("txtSharePercentage").observe("change", function(){
		if(isNaN($F("txtSharePercentage")) || $F("txtSharePercentage") <= 0 || $F("txtSharePercentage") > 100){
			showWaitingMessageBox("Invalid Share Precentage. Valid value should be from 0.000000001 to 100.000000000.", "E",  function(){
					$("txtSharePercentage").value = $("txtSharePercentage").getAttribute("lastValidValue");
					$("txtSharePercentage").focus();
				});
			/* $("txtSharePercentage").value = $("txtSharePercentage").getAttribute("lastValidValue");
			customShowMessageBox("Field must be of form 999.000000000.", "E", "txtSharePercentage"); */
		}else{
			/* if($F("txtSharePercentage") == 0){
				customShowMessageBox('Share percentage cannot be equal to zero. Please enter a valid value.', 'I', "txtSharePercentage");
				$("txtSharePercentage").value = $("txtSharePercentage").getAttribute("lastValidValue");
				return false;
			} */
			validateInvCommShare();	
		}
	});
	
	$("imgSearchIntrmdry").observe("click", function(){
		if($F("hidBancassuranceSw") == "TRUE"){
			showMessageBox("Intermediary cannot be changed. Please click on Bancassurance Details button.", "I");
		}else{
			var totalSharePercentage = 0;
			for(var i = 0; i < objInvCommArray.length ; i++){
				totalSharePercentage = parseFloat(totalSharePercentage) + parseFloat(objInvCommArray[i].sharePercentage);
			}
			//if(totalSharePercentage == 100){
			if($F("hidTotSharePercentage") == 100){
				showMessageBox("Sum of Share Percentage is 100%. Cannot insert another Intermediary.", "I");
			}else{
				$("hidVSharePercentage").value = 100 - totalSharePercentage; 
				showGIACSIntmNoLOV();	
			}
		}
	});
	
	$("editTxtRemarks").observe("click", function() {
		showEditor("txtRemarks", 4000, allowEdit);
	});

	$("txtRemarks").observe("change", function(){
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
	});

	$("txtSharePercentage").observe("change", function(){
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
	});
	
	$("btnAddInvComm").observe("click", function(){
		try{
			var totSharePercentage = 0;
			if($("btnAddInvComm").value == "Add"){
				totSharePercentage = parseFloat($F("hidTotSharePercentage")) + parseFloat($F("txtSharePercentage"));
			}else{
				totSharePercentage = (parseFloat($F("hidTotSharePercentage")) - parseFloat($F("hidUpdShrPercentage"))) + parseFloat($F("txtSharePercentage"));
			}
			if(checkPiChangeTag()){
				if($F("txtDspIntmName") == "" || $F("txtSharePercentage") == ""){
					showMessageBox(objCommonMessage.REQUIRED, "E");
				}else if(parseFloat(totSharePercentage) > 100){
					customShowMessageBox("Share Percentage should not exceed 100%.", "I", "txtSharePercentage");
					$("txtSharePercentage").clear();
					return false;
				}else{
					var billPremAmt = $F("hidPremAmt");
					var invSharePercentage = $F("txtSharePercentage");
					if(billPremAmt * (invSharePercentage / 100) == 0){
						showMessageBox("Cannot compute amounts. Share of premium is equal to zero.","I");
					}else{
						addUpdateInvoiceComm(totSharePercentage);
					}	
				}
			}
		}catch(e){
			showErrorMessage("btnAddInvComm", e);			
		}
	});
	
	$("btnDelInvComm").observe("click", function(){
		if(checkPiChangeTag()){
			if(checkInvoicePayt()){
				checkRecord();//){
					/* if(keyDelRecGIACS408()){
						$("hidDeleteSw").value = "Y";
						deleteInvComm();
						populateInvCommInfoDtls(null);
						changeTag = 1;
						objACGlobal.objGIACS408.icChangeTag = 1;
					} */
				//}
			}
		}
	});
	
	if(objACGlobal.objGIACS408.ORA2010SW == 'Y'){
		$("btnBancAssrnceDtls").show();
	}else{
		$("btnBancAssrnceDtls").hide();
	}

	function executeQueryInvCommInfo(){
		try{
			//tbgInvCommInfo.url = contextPath+ "/GIACDisbursementUtilitiesController?action=showInvoiceCommInfoListing&refresh=1&issCd="+
			//$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo")+"&nbtShowAll="+objACGlobal.objGIACS408.nbtShowAll;
			
			tbgInvCommInfo.url = contextPath+ "/GIACDisbursementUtilitiesController?action=showInvoiceCommInfoListing&refresh=1&issCd="+
			$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo")+"&nbtShowAll="+objACGlobal.objGIACS408.nbtShowAll+"&posted="+
			objACGlobal.objGIACS408.posted+"&commRecId="+$F("hidInvCommRecId");
			tbgInvCommInfo._refreshList();
		}catch(e){
			showErrorMessage("executeQueryInvCommInfo", e);
		}
	}
	
	objACGlobal.objGIACS408.executeQueryInvCommInfo = executeQueryInvCommInfo;
	
	function getInvoiceCommList(){
		new Ajax.Request(contextPath+ "/GIACDisbursementUtilitiesController?action=getGiacs408InvoiceCommList", {
			method: "POST",
			parameters: {
				issCd:		$F("txtIssCd"),
				premSeqNo:	$F("txtPremSeqNo"),
				nbtShowAll:	objACGlobal.objGIACS408.nbtShowAll,
				posted:		objACGlobal.objGIACS408.posted,
				commRecId:	$F("hidInvCommRecId")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					objACGlobal.objGIACS408.invCommList = JSON.parse(response.responseText);
				}
			}
		});
	}
	
	function populateInvCommInfoDtls(obj){
		try{
			$("txtDspIntmName").value 			= obj == null? "" : unescapeHTML2(obj.intmName);
			$("txtPrntIntmdry").value 			= obj == null? "" : unescapeHTML2(obj.prntIntmdry);
			$("txtSharePercentage").value 		= obj == null? "" : formatToNineDecimal(obj.sharePercentage);
			$("txtPremAmt").value 				= obj == null? "" : formatCurrency(obj.premiumAmt);
			$("txtCommissionAmt").value			= obj == null? "" : formatCurrency(obj.commissionAmt);
			$("txtWholdtingTax").value 			= obj == null? "" : formatCurrency(obj.wholdingTax);
			$("txtNetCommAmt").value 			= obj == null? "" : formatCurrency(obj.netCommAmt);
			//$("txtTranNo").value 				= obj == null? "" : obj.tranNo;
			$("txtRemarks").value 				= obj == null? "" : unescapeHTML2(obj.remarks);
			//$("txtDspTranFlag").value 			= obj == null? "" : obj.dspTranFlag;
			//$("txtTranDate").value 				= obj == null? "" : obj.tranDate;
			
			$("hidInvCommFundCd").value 		= obj == null? "" : obj.fundCd;
			$("hidInvCommBranchCd").value 		= obj == null? "" : obj.branchCd;
			$("hidInvCommRecId").value 			= obj == null? "" : obj.commRecId;
			$("hidInvIntmNo").value 			= obj == null? "" : obj.intmNo;
			$("hidInvWtaxRate").value 			= obj == null? "" : obj.wtaxRate;
			//$("hidInvTranFlag").value 			= obj == null? "" : obj.tranFlag;
			if(obj == null){
				enableSearch("imgSearchIntrmdry");
				$("btnAddInvComm").value = "Add";
				enableButton("btnAddInvComm");
				disableButton("btnDelInvComm");
				disableButton("btnRecomputeCommRt");
				disableButton("btnRecomputeWithTax");
				allowEdit = 'true';
				if(objACGlobal.objGIACS408.cancelTag == "Y") disableButton("btnAddInvComm");;
			}else{
				enableButton("btnRecomputeCommRt");
				enableButton("btnRecomputeWithTax");
				disableSearch("imgSearchIntrmdry");
				$("btnAddInvComm").value = "Update";
				enableButton("btnDelInvComm");
				formatAppearanceInvComm(obj);				
			}
		}catch(e){
			showErrorMessage("populateInvCommInfoDtls", e);			
		}
	}
	objACGlobal.objGIACS408.populateInvCommInfoDtls = populateInvCommInfoDtls;
	
	function formatAppearanceInvComm(obj){
		try{
			if(obj.deleteSw == "Y"){
				disableButton("btnAddInvComm");
				disableButton("btnDelInvComm");
			}
			if(obj.tranFlag == 'P' && nvl(obj.deleteSw, 'N') == 'N'){
			     disableButton("btnPostBill");
			     disableButton("btnCancelBill");
			     enableButton("btnPrintReport");
			     enableToolbarButton("btnToolbarPrint");

			     updateAllowedInvComm(false);
			     objACGlobal.objGIACS408.allowUpdatePeril = false;
			    if(objACGlobal.objGIACS408.ORA2010SW == 'Y'){
			    	if($("btnBancAssrnceDtls").disabled == false){
			    		disableButton("btnBancAssrnceDtls");
			    	}
			    }
			}else if(nvl(obj.deleteSw, 'N') == 'Y'){
				disableButton("btnPostBill");
			    enableButton("btnCancelBill");
			    disableButton("btnPrintReport");
			    
			    updateAllowedInvComm(false);
			    objACGlobal.objGIACS408.allowUpdatePeril = false;
			}else if(obj.tranFlag == 'C'){
				disableButton("btnPostBill");
			    disableButton("btnCancelBill");
			    disableButton("btnPrintReport");
			    
			    updateAllowedInvComm(false);
			    objACGlobal.objGIACS408.allowUpdatePeril = false;
			}else if(obj.tranFlag == 'U' && nvl(obj.deleteSw, 'N') == 'N'){
				//enableButton("btnPostBill"); //remove by steven 11.14.2014 base on the Business Process design by the SA
			    enableButton("btnCancelBill");
			    disableButton("btnPrintReport");
			    
			    updateAllowedInvComm(true);
			    objACGlobal.objGIACS408.allowUpdatePeril = true;
			}else{
				showMessageBox('Unhandled condition on tran_flag and delete_sw.','I');
			}
		}catch(e){
			
		}	
	}
	
	function updateAllowedInvComm(property){
		try{
			if(property){
				enableButton("btnAddInvComm");
				enableButton("btnDelInvComm");
				enableButton("btnRecomputeCommRt");
				enableButton("btnRecomputeWithTax");
				$("txtRemarks").readOnly = false;
				$("txtSharePercentage").readOnly = false;
				allowEdit = 'false';
			}else{
				disableButton("btnAddInvComm");
				disableButton("btnDelInvComm");
				disableButton("btnRecomputeCommRt");
				disableButton("btnRecomputeWithTax");
				$("txtRemarks").readOnly = true;
				$("txtSharePercentage").readOnly = true;
				allowEdit = 'true';
			}

			if($F("hidCommAmt") != 0){
				disableButton("btnRecomputeCommRt");
				disableButton("btnRecomputeWithTax");
				$("txtSharePercentage").setAttribute("readonly", "readonly");
				$("txtRemarks").readOnly = true;
				disableButton("btnAddInvComm");
				disableButton("btnDelInvComm");
			}
		}catch(e){
			showErrorMessage('updateAllowedInvComm', e);
		}
	}
	
	function addInvCommByPeril(){
		try{
			var invCommObj = new Object();
			
			invCommObj.fundCd	= $F("hidInvCommFundCd");
			invCommObj.branchCd = $F("hidInvCommBranchCd");
			invCommObj.commRecId = $F("hidInvCommRecId");
			invCommObj.intmNo = $F("hidInvIntmNo");
			invCommObj.deleteSw = $F("hidDeleteSw");
			
			for(var i=0; i<objInvCommArray.length; i++){
				objInvCommArray[i].remarks = $F("txtRemarks");
				objInvCommArray[i].sharePercentage = $F("txtSharePercentage");
				objInvCommArray[i].premiumAmt = unformatCurrency("txtTotalPerilPremAmt");
				objInvCommArray[i].commissionAmt =  unformatCurrency("txtTotalPerilCommAmt");
				objInvCommArray[i].wholdingTax = unformatCurrency("txtTotalPerilWithTax");
				objInvCommArray[i].netCommAmt = unformatCurrency("txtTotalPerilNetCommAmt");
				objInvCommArray[i].recordStatus = 1;
				objACGlobal.objGIACS408.objInvCommArray.splice(i, 1, objInvCommArray[i]);
				tbgInvCommInfo.updateVisibleRowOnly(objInvCommArray[i], tbgInvCommInfo.getCurrentPosition()[1]);
			}
		}catch(e){
			showErrorMessage("addInvCommByPeril", e);
		}
	}
	
	function updateInvCommByPeril(){
		try{
			var invCommObj = new Object();
			
			invCommObj.fundCd	= $F("hidInvCommFundCd");
			invCommObj.branchCd = $F("hidInvCommBranchCd");
			invCommObj.commRecId = $F("hidInvCommRecId");
			invCommObj.intmNo = $F("hidInvIntmNo");
			invCommObj.deleteSw = $F("hidDeleteSw");
			
			for(var i=0; i<objInvCommArray.length; i++){
				if((objInvCommArray[i].recordStatus != -1) &&
				   (objInvCommArray[i].fundCd == invCommObj.fundCd) &&
				   (objInvCommArray[i].branchCd == invCommObj.branchCd) &&
				   (objInvCommArray[i].commRecId == invCommObj.commRecId) &&
				   (objInvCommArray[i].intmNo == invCommObj.intmNo)){
					
					objInvCommArray[i].remarks = $F("txtRemarks");
					objInvCommArray[i].sharePercentage = $F("txtSharePercentage");
					objInvCommArray[i].premiumAmt = unformatCurrency("txtTotalPerilPremAmt");
					objInvCommArray[i].commissionAmt =  unformatCurrency("txtTotalPerilCommAmt");
					objInvCommArray[i].wholdingTax = unformatCurrency("txtTotalPerilWithTax");
					objInvCommArray[i].netCommAmt = unformatCurrency("txtTotalPerilNetCommAmt");
					objInvCommArray[i].recordStatus = 1;
					objACGlobal.objGIACS408.objInvCommArray.splice(i, 1, objInvCommArray[i]);
					if(objACGlobal.objGIACS408.piChangeTag == 0){
						tbgInvCommInfo.updateVisibleRowOnly(objInvCommArray[i], tbgInvCommInfo.getCurrentPosition()[1]);	
					}
				}
			}
		}catch(e){
			showErrorMessage("updateInvCommByPeril", e);
		}
	}	
	objACGlobal.objGIACS408.updateInvCommByPeril = updateInvCommByPeril;
	
	function deleteInvComm(){
		try{
			var invCommObj = new Object();
			
			invCommObj.fundCd	= $F("hidInvCommFundCd");
			invCommObj.branchCd = $F("hidInvCommBranchCd");
			invCommObj.commRecId = $F("hidInvCommRecId");
			invCommObj.intmNo = $F("hidInvIntmNo");
			
			for(var i=0; i<objInvCommArray.length; i++){
				if((objInvCommArray[i].recordStatus != -1) &&
				   (objInvCommArray[i].fundCd == invCommObj.fundCd) &&
				   (objInvCommArray[i].branchCd == invCommObj.branchCd) &&
				   (objInvCommArray[i].commRecId == invCommObj.commRecId) &&
				   (objInvCommArray[i].intmNo == invCommObj.intmNo)){
					
					objInvCommArray[i].deleteSw	= "Y";
					objInvCommArray[i].sharePercentage = $F("txtSharePercentage");
					objInvCommArray[i].premiumAmt = unformatCurrency("txtTotalPerilPremAmt");
					objInvCommArray[i].commissionAmt =  unformatCurrency("txtTotalPerilCommAmt");
					objInvCommArray[i].wholdingTax = unformatCurrency("txtTotalPerilWithTax");
					objInvCommArray[i].netCommAmt = unformatCurrency("txtTotalPerilNetCommAmt");
					objInvCommArray[i].recordStatus = -1;
					
					$("hidTotSharePercentage").value = parseFloat($("hidTotSharePercentage").value) - objInvCommArray[i].sharePercentage;  

					objACGlobal.objGIACS408.objInvCommArray.splice(i, 1, objInvCommArray[i]);
					//tbgInvCommInfo.deleteVisibleRowOnly(tbgInvCommInfo.getCurrentPosition()[1]);
					tbgInvCommInfo.deleteVisibleRowOnly(i);
					objACGlobal.objGIACS408.enterQueryPerilInfo();
					objACGlobal.objGIACS408.populatePerilInfoDtls(null);
					objACGlobal.objGIACS408.invCommList.splice(i, 1, objInvCommArray[i]);
				}
			}
		}catch(e){
			showErrorMessage("deleteInvComm", e);
		}
	}
	
	function populateInvoiceCommPeril(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=populateInvoiceCommPeril", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd,
					policyId: $F("hidPolicyId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					checkErrorOnResponse(response);
				}
			});
		}catch(e){
			showErrorMessage("populateInvoiceCommPeril", e);
		}
	}
	objACGlobal.objGIACS408.populateInvoiceCommPeril = populateInvoiceCommPeril;
	
	function validateInvCommShare(){
		try{
			var currentTotalShare = $F("hidTotSharePercentage");
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=validateInvCommShare", {
				method: "POST",
				parameters: {
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd,
					commRecId: $F("hidInvCommRecId"),
					intmNo: $F("hidInvIntmNo"),
					premSeqNo: $F("txtPremSeqNo"),
					issCd: $F("txtIssCd"), //from billInformation
					sharePercentage: $F("txtSharePercentage"),
					currentTotalShare:	currentTotalShare
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){					
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						if(json.message != null){
							showMessageBox(json.message,'I');
							if(json.sharePercentage != null){
								$("txtSharePercentage").value = formatToNineDecimal(json.sharePercentage);
							}else{
								$("txtSharePercentage").value = $("txtSharePercentage").getAttribute("lastValidValue");
							}
						}else{
							$("txtSharePercentage").value = formatToNineDecimal($("txtSharePercentage").value);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateInvCommShare", e);
		}
	}
	
	function updateCancelledInvoice(){
		try{		
			for(var i=0; i<objInvCommArray.length; i++){
				objInvCommArray[i].tranFlag = 'C';
				objInvCommArray[i].dspTranFlag = 'CANCELLED';
				
				objInvCommArray.splice(i, 1, objInvCommArray[i]);
				//tbgInvCommInfo.updateVisibleRowOnly(objInvCommArray[i], tbgInvCommInfo.getCurrentPosition()[1]);
			}
			
			allowEdit = 'true'; //for txtRemarks editor
			
			var obj = tbgInvCommInfo.geniisysRows[0];
			tbgInvCommInfo.selectRow('0');
			populateInvCommInfoDtls(obj);
			objACGlobal.objGIACS408.executeQueryPerilInfo(obj.fundCd, obj.branchCd, obj.commRecId, obj.intmNo, obj.lineCd);
		}catch(e){
			showErrorMessage("updateCancelledInvoice", e);
		}
	}
	objACGlobal.objGIACS408.updateCancelledInvoice = updateCancelledInvoice;
	
	function updatePostedInvoice(){
		try{		
			for(var i=0; i<objInvCommArray.length; i++){
				objInvCommArray[i].tranFlag = 'P';
				objInvCommArray[i].dspTranFlag = 'POSTED';
				
				objInvCommArray.splice(i, 1, objInvCommArray[i]);
				objACGlobal.objGIACS408.objInvCommArray.splice(i, 1, objInvCommArray[i]);
				//tbgInvCommInfo.updateVisibleRowOnly(objInvCommArray[i], tbgInvCommInfo.getCurrentPosition()[1]);
				
				//objACGlobal.objGIACS408.executeQueryPerilInfo
				//objACGlobal.objGIACS408.updatePostedPeril(); //update Peril TG
			}

			var obj = tbgInvCommInfo.geniisysRows[0];
			tbgInvCommInfo.selectRow('0');
			populateInvCommInfoDtls(obj);
			objACGlobal.objGIACS408.executeQueryPerilInfo(obj.fundCd, obj.branchCd, obj.commRecId, obj.intmNo, obj.lineCd);
		}catch(e){
			showErrorMessage("updatePostedInvoice", e);
		}
	}
	objACGlobal.objGIACS408.updatePostedInvoice = updatePostedInvoice;
	
	function invCommHistoryOverlay() {
		try{
			overlayInvCommHistoryDtl = Overlay.show(contextPath+"/GIACDisbursementUtilitiesController?action=showInvCommHistoryListing&issCd="+
												$F("txtIssCd")+"&premSeqNo=" +$F("txtPremSeqNo"), 
					{urlContent: true,
					 title: "History",
					 height: 300,
					 width: 835,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("invCommHistoryOverlay",e);
		}
	}

	function bancAssuranceOverlay() {
		try{
			overlayBancAssuranceDtl = Overlay.show(contextPath+"/GIACDisbursementUtilitiesController?action=showBancAssurance&issCd="+
												$F("txtIssCd")+"&premSeqNo=" +$F("txtPremSeqNo"), 
					{urlContent: true,
					 title: "History",
					 height: 300,
					 width: 835,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("bancAssuranceOverlay",e);
		}
	}
	
	function createNotInParam(){
		try{
			var notIn = '';
			var list = objACGlobal.objGIACS408.invCommList;
			
			for (var j = 0; j < list.length; j++){
				if (list[j].recordStatus != -1){
					notIn = notIn + "'" + list[j].intmNo + "'" + ((j+1) == list.length ? "" : ",");
				}
			}

			if (notIn.substring(notIn.length-1, notIn.length) == ",") notIn = notIn.substring(0, notIn.length-1);
			
			if (notIn != '') notIn = "("+notIn+")";
			return notIn;
		}catch(e){
			showErrorMessage("createNotInParam",e);
		}
	}
	
	function showGIACSIntmNoLOV(){
		try{
			var notIn = createNotInParam(); //createCompletedNotInParam(tbgInvCommInfo, "intmNo");
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS408IntmNoLOV",
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd,
					notIn : nvl(notIn, "")
				},
				title: "Intermediary",
				width: 400,
				height: 400,
				columnModel : [
				               {
				            	   id : "intmNo",
				            	   title: "Intm No",
				            	   width: "60px",
				            	   align: "right"
				               },
				               {
				            	   id : "intmName",
				            	   title: "Intm Name",
				            	   width: "310px",
				            	   align: "left"
				               }
				              ],
				draggable: true,
				onSelect: function(row) {
					$("txtDspIntmName").value = unescapeHTML2(row.intmName);
					$("txtPrntIntmdry").value = unescapeHTML2(row.parentIntmdry);
					$("hidIntmNo").value = row.intmNo;
					$("hidInvIntmNo").value = row.intmNo;
					$("hidIntmType").value = unescapeHTML2(row.intmType);
					$("hidWtaxRate").value = row.wtaxRate;
					//$("txtSharePercentage").value = formatToNineDecimal($F("hidVSharePercentage"));
					$("txtSharePercentage").value = formatToNineDecimal(100 - $F("hidTotSharePercentage"));
					$("hidVSharePercentage").value = 0;
				},
		  		onCancel: function(){
		  			$("txtDspIntmName").focus();
		  		}
		  	});
		}catch(e){
			showErrorMessage("showGIACSIntmNoLOV ",e);
		}		
	}
	//added by steven 10.21.2014
	function getAdjustedPremAmt() {
		try{
			var obj = new Object();
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=getAdjustedPremAmt", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"), 
					premSeqNo: $F("txtPremSeqNo"),
					intmNo: $F("hidInvIntmNo"),
					sharePercentage: $F("txtSharePercentage"), 
					policyId : $F("hidPolicyId"),
					premAmt: roundNumber($F("hidPremAmt") * ($F("txtSharePercentage") / 100), 2)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						obj = JSON.parse(response.responseText);
					}
				}
			});
			return obj;
		}catch(e){
			showErrorMessage("getAdjustedPremAmt", e);
		}
	}
	
	function addUpdateInvoiceComm(totSharePercentage){
		try{
			var objParam = getAdjustedPremAmt();
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=getObjInsertUpdateInvperl", {
				method: "POST",
				parameters: {
					recordStatus: $("btnAddInvComm").value == "Add" ? "0" : "1",
					lineCd: $F("hidLineCd"),
					sublineCd: $F("hidSublineCd"), 
					issCd: $F("txtIssCd"), //from billInformation
					premSeqNo: $F("txtPremSeqNo"),
					premAmt: $F("hidPremAmt"),
				    premiumAmt: objParam.premAmt,//roundNumber($F("hidPremAmt") * ($F("txtSharePercentage") / 100), 2), //unformatCurrency("txtPremAmt"), //added by steven 10.21.2014
					intmNo: $F("hidInvIntmNo"),
					policyId : $F("hidPolicyId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var objArray = eval(response.responseText);
						if($("btnAddInvComm").value == "Add"){
							if(parseFloat($F("hidPremAmt")) * (parseFloat($F("txtSharePercentage")) / 100) == 0){
								showMessageBox("Cannot compute amounts. Share of premium is equal to zero.", "I");
								return false;
							}
							objACGlobal.objGIACS408.addChildCommInvPeril(objArray);
							var obj = setInvComm($("btnAddInvComm").value,objParam);
							objInvCommArray.push(obj);
							objACGlobal.objGIACS408.objInvCommArray.push(obj);
							tbgInvCommInfo.addBottomRow(obj);
							objACGlobal.objGIACS408.invCommList.push(obj);
							$("hidTotSharePercentage").value = roundNumber(totSharePercentage, 9);
						}else{
							objACGlobal.objGIACS408.updateChildCommInvPeril(objArray);
							objACGlobal.objGIACS408.enterQueryPerilInfo();
							$("hidTotSharePercentage").value = roundNumber(totSharePercentage, 9);
						}
						populateInvCommInfoDtls(null);
						changeTag = 1;
						changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
						objACGlobal.objGIACS408.icChangeTag = 1;
						//fireEvent($("btnSave"), "click");	// commented out to allow deletion/addition of multiple records at a time : shan 02.09.2015
					}
				}
			});
		}catch(e){
			showErrorMessage("addUpdateInvoiceComm", e);
		}
	}
	
	function setInvComm(func,objParam){
		try{
			var obj = new Object();
			obj.fundCd	= $F("hidTempFundCd");//objInvCommArrayTemp[0].fundCd;
			obj.branchCd = $F("hidTempBranchCd");//objInvCommArrayTemp[0].branchCd;
			obj.commRecId = $F("hidTempCommRecId");//objInvCommArrayTemp[0].commRecId;
			obj.tranNo = $F("hidTempTranNo");//objInvCommArrayTemp[0].tranNo;
			obj.tranFlag = $F("hidInvTranFlag");
			obj.policyId = $F("hidPolicyId");
			obj.intmNo = $F("hidInvIntmNo");
			obj.deleteSw = $F("hidDeleteSw");
			obj.intmName = $F("txtDspIntmName");
			obj.prntIntmdry = $F("txtPrntIntmdry");
			obj.sharePercentage = $F("txtSharePercentage");
			obj.premiumAmt = objParam.premAmt;//parseFloat($F("hidPremAmt")) * (parseFloat($F("txtSharePercentage")) / 100); //added by steven 10.21.2014
			obj.commissionAmt = unformatCurrencyValue($F("txtCommissionAmt"));
			obj.wholdingTax = $F("txtWholdtingTax");
			obj.remarks = $F("txtRemarks");
			obj.issCd = $F("txtIssCd");
			obj.premSeqNo = $F("txtPremSeqNo");
			obj.netCommAmt = $F("txtNetCommAmt");
			obj.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			
			return obj;
		}catch(e){
			showErrorMessage("setInvComm: ",e);
		}
	}
	
	function checkInvoicePayt(){
		try{
			var isValid = true;
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=checkInvoicePayt", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					intmNo: $F("hidInvIntmNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var msg = response.responseText;
						if(msg != ""){
							showMessageBox(msg, 'E');
							isValid = false;
						}
					}
				}
			});
			return isValid;
		}catch(e){
			showErrorMessage("checkInvoicePayt", e);
		}
	}
	
	function checkRecord(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=checkRecord", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						if(json.vRecord != null){
							if(json.allowCOI == "Y"){
								showConfirmBox3("CONFIRMATION", "Policy has an existing open claim (Claim Number: "+ 
										json.vRecord +").  Would you like to continue changing the intermediary of the policy?",
												"Yes", "No", 
												function(){
													//return true;
													if(keyDelRecGIACS408()){
															deleteInvComm();
														objACGlobal.objGIACS408.deleteChildCommInvPeril();
														populateInvCommInfoDtls(null);
														changeTag = 1;
														changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
														objACGlobal.objGIACS408.icChangeTag = 1;
													}
												}, 
												function(){
													//v_continue = N;
													return false;
												}
										);
							}else if(json.allowCOI == "N"){
								showMessageBox("Policy has an existing open claim (Claim Number: "+ json.vRecord +
										"). Cancel the claim before change of intermediary can be done.", "I");
									//v_continue = N;
									return false;
							}
						}else{
							//return true;
							if(keyDelRecGIACS408()){
								deleteInvComm();
								populateInvCommInfoDtls(null);
								changeTag = 1;
								changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
								objACGlobal.objGIACS408.icChangeTag = 1;
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkInvoicePayt", e);
		}
	}
	
	function keyDelRecGIACS408(){
		try{
			var isValid = true;
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=keyDelRecGIACS408", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					intmNo: $F("hidInvIntmNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var msg = response.responseText;
						if(msg != ""){
							showMessageBox(msg, 'E');
							isValid = false;
						}
					}
				}
			});
			return isValid;
		}catch(e){
			showErrorMessage("checkInvoicePayt", e);
		}
	}
	
	function checkPiChangeTag(){
		if(objACGlobal.objGIACS408.piChangeTag == 1){
			showMessageBox("Please save your changes first.", imgMessage.INFO);
			return false;
		}else{
			return true;
		}
	}
	
	$("btnBancAssrnceDtls").observe("click", function(){
		try{
			overlayBancAssrnceDtls = Overlay.show(contextPath+"/GIACDisbursementUtilitiesController?action=showBancAssurance&policyId="+$F("hidPolicyId")+"&vModBtyp="+$F("hidVModBtyp")
									 +"&issCd="+$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo"), 
			{
				urlContent: true,
				title: "Bancassurance",
				height: 400,
				width: 596,
				draggable: false
			});
		}catch (e) {
			showErrorMessage("show bancassurance overlay ",e);
		}
	});

	$("txtSharePercentage").observe("keyup", function(e) {
		if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("txtSharePercentage"))) {
			$("txtSharePercentage").value = formatToNineDecimal(nvl($("txtSharePercentage").readAttribute("lastValidValue"), 0));
		}
	});	

	$("txtIssCd").focus();
</script>