<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="recoveryInfoMainDiv" name="recoveryInfoMainDiv" style="margin-top: 1px;">
	<form id="recoveryInfoForm" name="recoveryInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Recovery Details</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>
		   		</span>
		   	</div>
		</div>
		<div id="recoveryDetailsSectionDiv" class="sectionDiv">
			<div id="recoveryDetailsGrid" style="height: 131px; margin: 10px; margin-bottom: 35px;"></div>
			<table align="center" border="0">
				<tr>
					<td class="rightAligned">Recovery No.</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtLineCd" name="txtLineCd" style="width: 50px;">
						<input readonly="readonly" type="text" id="txtIssCd" name="txtIssCd" style="width: 50px;">
						<input readonly="readonly" type="text" id="txtRecYear" name="txtRecYear" style="width: 83px; text-align: right">
						<input readonly="readonly" type="text" id="txtRecSeqNo" name="txtRecSeqNo" style="width: 83px; text-align: right">
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned"><label style="float: right; margin-right: 7px; font-weight: bolder;" id="lblClmRecStatus"></label></td>
				</tr>
				<tr>
					<td class="rightAligned">Recovery Type</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtRecTypeCd" name="txtRecTypeCd" style="width: 50px; float: left;">
						<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv">
							<input type="text" id="txtDspRecTypeDesc" name="txtDspRecTypeDesc" value="" style="width: 220px;" class="withIcon" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspRecTypeDescIcon" name="txtDspRecTypeDescIcon" alt="Go" />
						</div>
					</td>
					<td class="rightAligned" style="width: 132px;">Recoverable Amount</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtRecoverableAmt" name="txtRecoverableAmt" class="money" style="width: 247px; display: none;" maxlength="18">
						<div style="width: 253px; float: left; margin: 0px;" class="withIconDiv">
							<input type="text" id="txtRecoverableAmt2" name="txtRecoverableAmt2" value="" style="width: 225px;" class="money withIcon" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRecoverableAmt2Icon" name="txtRecoverableAmt2Icon" alt="Go" />
						</div>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Currency</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtCurrencyCd" name=""txtCurrencyCd style="width: 50px; text-align: right; float: left;">
						<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv">
							<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 220px;" class="withIcon" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspCurrencyDescIcon" name="txtDspCurrencyDescIcon" alt="Go" />
						</div>
					</td>
					<td class="rightAligned">Recovered Amount</td>
					<td class="leftAligned"><input readonly="readonly" type="text" id="txtRecoveredAmt" name="txtRecoveredAmt" class="money" style="width: 247px;" maxlength="18"></td>
				</tr>
				<tr>
					<td class="rightAligned">Currency Rate</td>
					<td class="leftAligned"><input readonly="readonly" type="text" id="txtConvertRate" name="txtConvertRate" style="width: 302px; text-align: right;" maxlength="13" class="moneyRate"></td>
					<td class="rightAligned">Plate Number</td>
					<td class="leftAligned"><input type="text" id="txtPlateNo" name="txtPlateNo" style="width: 247px;" class="allCaps" maxlength="11"></td>
				</tr>
				<tr>
					<td class="rightAligned">Lawyer</td>
					<td class="leftAligned">
						<input type="hidden" id="hidLawyerClassCd" name="hidLawyerClassCd" value="" readonly="readonly">
						<input readonly="readonly" type="text" id="txtLawyerCd" name="txtLawyerCd" style="width: 50px; text-align: right; float: left;">
						<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv">
							<input type="text" id="txtDspLawyerName" name="txtDspLawyerName" value="" style="width: 220px;" class="withIcon" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspLawyerNameIcon" name="txtDspLawyerNameIcon" alt="Go" />
						</div>
					</td>
					<td class="rightAligned">AP Plate Number</td>
					<td class="leftAligned"><input type="text" id="txtTpPlateNo" name="txtTpPlateNo" style="width: 247px;" class="allCaps" maxlength="10"></td>
				</tr>
				<tr>
					<td class="rightAligned">Case No.</td>
					<td class="leftAligned"><input type="text" id="txtCaseNo" name="txtCaseNo" style="width: 302px;" maxlength="100"></td>
					<td class="rightAligned">AP Driver Name</td>
					<td class="leftAligned"><input type="text" id="txtTpDriverName" name="txtTpDriverName" style="width: 247px;" class="allCaps" maxlength="100"></td>
				</tr>
				<tr>
					<td class="rightAligned">Court</td>
					<td class="leftAligned"><input type="text" id="txtCourt" name="txtCourt" style="width: 302px;" maxlength="200"></td>
					<td class="rightAligned">AP Driver Address</td>
					<td class="leftAligned"><input type="text" id="txtTpDrvrAdd" name="txtTpDrvrAdd" style="width: 247px;" maxlength="1000"></td>
				</tr>
				<tr>
					<td class="rightAligned">AP Item Description</td>
					<td class="leftAligned" colspan="3">
						<div style="float:left; width: 715px;" class="withIconDiv">
							<textarea onKeyDown="limitText(this,500);" onKeyUp="limitText(this,500);" id="txtTpItemDesc" name="txtTpItemDesc" style="width: 684px;" class="withIcon allCaps"> </textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtTpItemDesc" />
						</div>
					</td>
				</tr>
			</table>
			<div class="buttonDiv" style="float: left; width: 100%;">
				<table align="center" border="0" style="margin-bottom: 10px; margin-top: 7px;">
					<tr>
						<td><input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" /></td>
						<!-- <td><input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" /></td> -->
					</tr>
				</table>
			</div>	
		</div>
		<div id="recoveryDetailsSectionDiv2" class="sectionDiv" style="border: 0px solid;"></div>
		<div class="buttonsDiv">
			<input type="button" id="btnCloseRecov" name="btnCloseRecov" class="button"	value="Close" />			
			<input type="button" id="btnCancelRecov" name="btnCancelRecov" class="button"	value="Cancel Recovery" />			
			<input type="button" id="btnWriteofRecov" name="btnWriteofRecov" class="button"	value="Write Off" />			
			<input type="button" id="btnReopenRecov" name="btnReopenRecov" class="button"	value="Re-open" />
			<input type="button" id="btnDetail" name="btnDetail" class="button"	value="Distribution Details" />			
			<input type="button" id="btnRecoveryDetail" name="btnRecoveryDetail" class="button"	value="Recovery Details" />			
			<input type="button" id="btnMaintenance" 	name="btnMaintenance" 	 class="button"	value="Maintenance" />
			<input type="button" id="btnPrint"	name="btnPrint" class="button"	value="Print" style="width: 80px; display: none;"/>			
			<input type="button" id="btnCancel"	name="btnCancel" class="button"	value="Cancel" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	value="Save" />	
		</div>
	</form>	
</div>
<script type="text/javascript">
try{
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	 
	objCLM.recoveryDetailsGrid = JSON.parse('${recoveryTG}');
	objCLM.recoveryDetailsRows = objCLM.recoveryDetailsGrid.rows || [];
 
	objCLM.recoveryDetailsCurrXX = null;
	objCLM.recoveryDetailsCurrYY = null;
	objCLM.recoveryDetailsCurrRow = null;
	objCLM.recoveryDetailsUpdated = null;
	objCLM.recoveryDetailsLOV = null;		
	objCLM.gicls025vars = JSON.parse('${variables}'); //'${variables}'.toQueryParams(); replaced by: Nica 09.26.2012
	
	var recoveryTM = {
		url: contextPath+"/GICLClmRecoveryController?action=showRecoveryInformation"+
				"&claimId=" + objCLMGlobal.claimId +
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			newRowPosition: 'bottom',
			onCellFocus: function(element, value, x, y, id){
				if (objCLM.recoveryDetailsUpdated != null && checkChangeTagOnGICLS025() != 0 && objCLM.recoveryDetailsUpdated !=  Number(y)){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objCLM.recoveryDetailsTG.unselectRows();
						if (objCLM.recoveryDetailsCurrRow != null) objCLM.recoveryDetailsTG.selectRow(String(objCLM.recoveryDetailsUpdated));
						});
					return false;
				}	
				objCLM.recoveryDetailsCurrXX = Number(x);
				objCLM.recoveryDetailsCurrYY = Number(y);
				populateRecovery(objCLM.recoveryDetailsTG.getRow(objCLM.recoveryDetailsCurrYY));
				
			}, 
			onRemoveRowFocus: function ( x, y, element) {
				if (objCLM.recoveryDetailsUpdated != null && checkChangeTagOnGICLS025() != 0 && objCLM.recoveryDetailsUpdated !=  Number(y)){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objCLM.recoveryDetailsTG.unselectRows();
						if (objCLM.recoveryDetailsCurrRow != null) objCLM.recoveryDetailsTG.selectRow(String(objCLM.recoveryDetailsUpdated));
						});
					return false;
				}
				objCLM.recoveryDetailsCurrXX = null;
				objCLM.recoveryDetailsCurrYY = null;  
				populateRecovery(null);
			},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onSave: function() {
					var ok = true;
					var objParameters 			= new Object();
					
					//Main Recovery Parameters
				 	var addedRecovs 	= objCLM.recoveryDetailsTG.getNewRowsAdded();
					var modifiedRecovs 	= objCLM.recoveryDetailsTG.getModifiedRows();
					var delRecovs  	 	= objCLM.recoveryDetailsTG.getDeletedRows();
					var setRecovs		= addedRecovs.concat(modifiedRecovs);
					objParameters.delRecovs 	= delRecovs;
					objParameters.setRecovs 	= setRecovs;
					objParameters.recoverable 	= nvl(objCLM.recoveryDetailsLOV, '[]');
					
					//Payor Parameters
					var addedPayors				= objCLM.recPayorTG.getNewRowsAdded();
					var modifiedPayors 			= objCLM.recPayorTG.getModifiedRows();
					var delPayors  	 			= objCLM.recPayorTG.getDeletedRows();
					var setPayors				= addedPayors.concat(modifiedPayors);
					objParameters.delPayors 	= delPayors;
					objParameters.setPayors 	= setPayors;

					//History Parameters
					//var addedHist				= objCLM.recHistTG.getNewRowsAdded();
					//var modifiedHist 			= objCLM.recHistTG.getModifiedRows();
					var delHist  	 			= objCLM.recHistTG.getDeletedRows();
					//var setHist					= addedHist.concat(modifiedHist);
					var setHist					= getAddedAndModifiedJSONObjects(objCLM.recHistTG.geniisysRows);
					objParameters.delHist 		= delHist;
					objParameters.setHist 		= setHist;
					
					new Ajax.Request(contextPath+"/GICLClmRecoveryController?action=saveRecoveryInfo",{
						method: "POST",
						parameters:{
							claimId: objCLMGlobal.claimId,
							lineCd: objCLMGlobal.lineCd,
							issCd: objCLMGlobal.issueCode,
							parameters: JSON.stringify(objParameters)
						},
						asynchronous: false,
						evalJS: true,
						onCreate: function(){
							showNotice("Saving, please wait...");
						},
						onComplete: function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS"){
									objCLM.recoveryDetailsTG.keys.releaseKeys();
									showMessageBox(objCommonMessage.SUCCESS, "S");
									changeTag = 0;
									ok = true;
								}
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								ok = false;
							}
						}	 
					});	
					return ok; 	
				},
				postSave: function(){
					/*hideNotice("");
					objCLM.recoveryDetailsTG.clear();
					objCLM.recoveryDetailsTG.refresh();
					objCLM.recoveryDetailsTG.keys.releaseKeys();
					objCLM.recoveryDetailsLOV = null;*/
					showRecoveryInformation();
				}	
			}	
		},
		columnModel: [
			{
			    id: 'recordStatus',
			    title : '',
	            width: '0',
	            visible: false,
	            editor: "checkbox"
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			},
        	{
        		id: 'recoveryId',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'claimId',
        		width: '0',
        		visible: false,
        		defaultValue: objCLMGlobal.claimId
        	},
        	{
        		id: 'tpItemDesc',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'plateNo',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'currencyCd',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'lawyerClassCd',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'lawyerCd',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'cpiRecNo',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'cpiBranchCd',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'cancelTag',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'recFileDate',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'demandLetterDate',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'demandLetterDate2',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'demandLetterDate3',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'tpDriverName',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'tpDrvrAdd',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'tpPlateNo',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'caseNo',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'court',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'dspLawyerName',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'msgAlert',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'issCd',
        		width: '0',
        		visible: false,
        		defaultValue: objCLMGlobal.issueCode
        	},
        	{
    		    id: 'lineCd issCd recYear recSeqNo',
    		    title: 'Recovery Number',
    		    width : '260px',
    		    children : [
    	            {
    	                id : 'lineCd',
    	                title: 'Line Code',
    	                width: 30,
    	                filterOption: true,
    	                defaultValue: objCLMGlobal.lineCd
    	            },
    	            {
    	                id : 'issCd', 
    	                title: 'Issue Code',
    	                width: 45,
    	                filterOption: true,
    	                defaultValue: objCLMGlobal.issueCode
    	            }, 
    	            {
    	                id : 'recYear',
    	                title: 'Recovery Year',
    	                type: "number",
    	                align: "right",
    	                width: 40,
    	                filterOption: true,
    		            filterOptionType: 'integerNoNegative' 
    	            },
    	            {
    	                id : 'recSeqNo',
    	                title: 'Recovery Sequence Number',
    	                type: "number",
    	                align: "right",
    	                width: 64,
    	                filterOption: true,
    		            filterOptionType: 'integerNoNegative',
    	                renderer: function (value){
    						return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
    					}
    	            }
    	    	]        
    		},
        	{
    		    id: 'recTypeCd dspRecTypeDesc',
    		    title: 'Recovery Type',
    		    width : '116px',
    		    children : [
    	            {
    	                id : 'recTypeCd',
    	                title: 'Recovery Type Code',
    	                width: 30,
    	                filterOption: true
    	            },
    	            {
    	                id : 'dspRecTypeDesc', 
    	                title: 'Recovery Type Desc',
    	                width: 96,
    	                filterOption: true
    	            }
    	        ]
        	},
        	{
        		id: 'dspCurrencyDesc',
        		title: 'Currency',
        		width: '110',
        		filterOption: true
        	},
        	{
        		id: 'convertRate',
        		title: 'Rate',
        		titleAlign: 'right',
        		align: 'right',
        		width: '90',
        		geniisysClass: 'rate',
	            deciRate: 9,
	            filterOption: true,
	            filterOptionType: 'numberNoNegative' 	
        	},
        	{
        		id: 'recoverableAmt',
        		title: 'Recoverable Amt.',
        		titleAlign: 'right',
        		align: 'right',
        		width: '120',
        		geniisysClass: 'money',
        		filterOption: true,
        		filterOptionType: 'numberNoNegative'
        	},
        	{
        		id: 'recoveredAmt',
        		title: 'Recovered Amt.',
        		titleAlign: 'right',
        		align: 'right',
        		width: '120',
        		geniisysClass: 'money',
        		filterOption: true,
        		filterOptionType: 'numberNoNegative'
        	},
        	{
        		id: 'dspRecStatDesc',
        		title: 'Status',
        		width: '80',
        		filterOption: true
        	},
        	{
        		id: 'dspCheckValid',
        		width: '0',
        		visible: false
        	},
        	{
        		id: 'dspCheckAll',
        		width: '0',
        		visible: false
        	}	
		], 
		rows: objCLM.recoveryDetailsRows,
		resetChangeTag: true,
		checkChangeTag: true,
		id: 70
	};
	
	//Will show Recover Details subpages
	function showRecoverySubDetails(claimId, recoveryId){
		try{
			new Ajax.Updater("recoveryDetailsSectionDiv2", contextPath+"/GICLClmRecoveryController",{
				parameters: {
					action: "showRecoveryInformationSubDetails",
					claimId: claimId,
					recoveryId: recoveryId,
					pageSize: 3
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						 null;
					}
				}	
			});
		}catch(e){
			showErrorMessage("showRecoverySubDetails", e);	
		}	
	}		
	
	function setFieldProperties(obj){
		try{
			if (nvl(obj,null) != null){
				enableButton("btnCloseRecov");
				enableButton("btnCancelRecov");
				enableButton("btnWriteofRecov");
				//enableButton("btnReopenRecov");
				enableButton("btnDetail");
				enableButton("btnRecoveryDetail");
				enableButton("btnPrint");
				
				if (nvl(obj.cancelTag,"N") == "Y"){
					disableButton("btnCloseRecov");
					disableButton("btnCancelRecov");
					disableButton("btnWriteofRecov");
					if (nvl(obj.dspCheckAll,"") == "1"){
						enableButton("btnDetail");
					}else{
						disableButton("btnDetail");
					}	
				}else if (nvl(obj.dspCheckValid,"") == "1"){
					
				}else{
					if (nvl(obj.dspCheckAll,"") == "1"){
						enableButton("btnDetail");
					}else{
						disableButton("btnDetail");
					}
				}	
				
				if (parseFloat(nvl(obj.recoverableAmt,0)) == parseFloat(0)){	
					disableButton("btnRecoveryDetail");
				}else{
					enableButton("btnRecoveryDetail");	
				}
				
				if (objCLMGlobal.lineCd != "MC"){
					$("txtTpDriverName").readOnly = true;
					$("txtTpItemDesc").readOnly = true;
					//Observe Edit AP Item Description
					$("editTxtTpItemDesc").stopObserving("click");
					$("editTxtTpItemDesc").observe("click", function () {
						showEditor("txtTpItemDesc", 500, 'true');
					});
				}else{	
					$("txtTpDriverName").readOnly = false;
					$("txtTpItemDesc").readOnly = false;
					//Observe Edit AP Item Description
					$("editTxtTpItemDesc").stopObserving("click");
					$("editTxtTpItemDesc").observe("click", function () {
						showEditor("txtTpItemDesc", 500);
					});
				}
			}else{
				disableButton("btnCloseRecov");
				disableButton("btnCancelRecov");
				disableButton("btnWriteofRecov");
				//disableButton("btnReopenRecov");
				disableButton("btnDetail");
				disableButton("btnRecoveryDetail");
				disableButton("btnPrint");
			}	
		}catch(e){
			showErrorMessage("setFieldProperties", e);			
		}	
	}	
	
	//Populate Recovery Details
	function populateRecovery(obj){
		try{
			objCLM.recoveryDetailsCurrRow   = obj;
			if (nvl(obj,null) != null){if (nvl(obj.msgAlert,null) != null){showMessageBox(obj.msgAlert, "E");populateRecovery(null);return false;}};
			$("txtLineCd").value 			= nvl(obj,null) != null ? nvl(obj.lineCd,null) :null;
			$("txtIssCd").value 			= nvl(obj,null) != null ? nvl(obj.issCd,null) :null;
			$("txtRecYear").value 			= nvl(obj,null) != null ? nvl(obj.recYear,null) :null;
			$("txtRecSeqNo").value 			= nvl(obj,null) != null ? formatNumberDigits(nvl(obj.recSeqNo,""),3) :null;
			$("lblClmRecStatus").innerHTML 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.dspRecStatDesc,"")) :null;
			$("txtRecTypeCd").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.recTypeCd,null)) :null;
			$("txtDspRecTypeDesc").value 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.dspRecTypeDesc,null)) :null;
			$("txtCurrencyCd").value 		= nvl(obj,null) != null ? formatNumberDigits(nvl(obj.currencyCd,""),2) :null; 
			$("txtDspCurrencyDesc").value 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.dspCurrencyDesc,null)) :null;
			$("txtConvertRate").value 		= nvl(obj,null) != null ? formatToNthDecimal(nvl(obj.convertRate,""),9) :null; //lara 02/05/2014
			$("txtPlateNo").value 			= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.plateNo,null)) : unescapeHTML2(nvl(objCLM.gicls025vars.plateNo, null));
			$("txtLawyerCd").value 			= nvl(obj,null) != null ? nvl(obj.lawyerCd,"") :null; 
			$("hidLawyerClassCd").value 	= nvl(obj,null) != null ? nvl(obj.lawyerClassCd,"") :null; 
			$("txtDspLawyerName").value 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.dspLawyerName,null)) :null;
			$("txtCaseNo").value 			= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.caseNo,null)) :null;
			$("txtCourt").value 			= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.court,null)) :null;
			$("txtTpItemDesc").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.tpItemDesc,null)) :null;
			$("txtRecoverableAmt").value 	= nvl(obj,null) != null ? nvl(obj.recoverableAmt,null) != null ? formatCurrency(obj.recoverableAmt) :null :null;
			$("txtRecoverableAmt2").value 	= nvl(obj,null) != null ? nvl(obj.recoverableAmt,null) != null ? formatCurrency(obj.recoverableAmt) :null :null;
			$("txtRecoveredAmt").value 		= nvl(obj,null) != null ? nvl(obj.recoveredAmt,null) != null ? formatCurrency(obj.recoveredAmt) :"0.00" :"0.00";
			$("txtTpPlateNo").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.tpPlateNo,null)) :null;
			$("txtTpDriverName").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.tpDriverName,null)) :null;
			$("txtTpDrvrAdd").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.tpDrvrAdd,null)) :null;
			
			if (nvl(obj,null) != null){
				//disableButton("btnAdd");
				//disableButton("btnDelete");//enableButton("btnDelete");
				$("btnAdd").value = "Update";
				disableSearch("txtDspRecTypeDescIcon");
				disableSearch("txtDspCurrencyDescIcon");
				//marco - added conditions for GENQA SR #345 - 10.16.2013
				if(parseFloat(objCLM.recoveryDetailsTG.getRow(objCLM.recoveryDetailsCurrYY).recoveredAmt) != 0){
					disableSearch("txtDspLawyerNameIcon");
				}else{
					enableSearch("txtDspLawyerNameIcon");
				}
				$("txtRecoverableAmt2").removeClassName("required");
				$("txtRecoverableAmt2").up("div", 0).removeClassName("required");
				if (parseFloat(nvl(obj.recoveredAmt,0)) == parseFloat(0)){
					enableSearch("txtRecoverableAmt2Icon");
					$("txtRecoverableAmt2").addClassName("required");
					$("txtRecoverableAmt2").up("div", 0).addClassName("required");
				}else{
					disableSearch("txtRecoverableAmt2Icon");
					$("txtRecoverableAmt2").removeClassName("required");
					$("txtRecoverableAmt2").up("div", 0).removeClassName("required");
				}
				$("txtRecTypeCd").removeClassName("required");
				$("txtCurrencyCd").removeClassName("required");
				$("txtLawyerCd").removeClassName("required");
				$("txtDspRecTypeDesc").removeClassName("required");
				$("txtDspCurrencyDesc").removeClassName("required");
				$("txtDspRecTypeDesc").up("div", 0).removeClassName("required");
				$("txtDspCurrencyDesc").up("div", 0).removeClassName("required");
				$("txtConvertRate").readOnly = true; 
			}else{
				enableButton("btnAdd");
				//disableButton("btnDelete");
				$("btnAdd").value = "Add";
				enableSearch("txtDspRecTypeDescIcon");
				enableSearch("txtDspCurrencyDescIcon");
				enableSearch("txtDspLawyerNameIcon");
				enableSearch("txtRecoverableAmt2Icon");
				$("txtRecTypeCd").addClassName("required");
				$("txtCurrencyCd").addClassName("required");
				$("txtDspRecTypeDesc").addClassName("required");
				$("txtDspCurrencyDesc").addClassName("required");
				$("txtRecoverableAmt2").addClassName("required");
				$("txtDspRecTypeDesc").up("div", 0).addClassName("required");
				$("txtDspCurrencyDesc").up("div", 0).addClassName("required");
				$("txtRecoverableAmt2").up("div", 0).addClassName("required");
				$("txtConvertRate").readOnly = false; 
			}	
			
			setFieldProperties(obj);
			
			if (nvl(obj,null) != null){
				showRecoverySubDetails(obj.claimId, obj.recoveryId);
			}else{
				showRecoverySubDetails('','');
				objCLM.recoveryDetailsTG.unselectRows();
			}
			
			observeChangeTagInTableGrid(objCLM.recoveryDetailsTG);
			objCLM.recoveryDetailsTG.keys.releaseKeys();
			$("txtRecTypeCd").focus();
		}catch(e){
			showErrorMessage("populateRecovery", e);	
		}
	}
	
	objCLM.recoveryDetailsTG = new MyTableGrid(recoveryTM);
	objCLM.recoveryDetailsTG.pager = objCLM.recoveryDetailsGrid; 
	objCLM.recoveryDetailsTG._mtgId = 70;
	objCLM.recoveryDetailsTG.afterRender = function(){
		if (objCLM.recoveryDetailsTG.rows.length > 0){
			objCLM.recoveryDetailsCurrYY = Number(0);
			objCLM.recoveryDetailsTG.selectRow('0');
			populateRecovery(objCLM.recoveryDetailsTG.getRow(objCLM.recoveryDetailsCurrYY));
		}else{
			populateRecovery(null);
			changeTag = 0;
		}	
	};
	objCLM.recoveryDetailsTG.render('recoveryDetailsGrid');
	
	//Observe Edit AP Item Description
	if (objCLMGlobal.lineCd != "MC"){
		$("editTxtTpItemDesc").observe("click", function () {
			showEditor("txtTpItemDesc", 500, 'true');
		});
	}else{	
		$("editTxtTpItemDesc").observe("click", function () {
			showEditor("txtTpItemDesc", 500);
		});
	}
	
	
	//Observe backspace on input w/ LOV
	deleteOnBackSpace("txtRecTypeCd", "txtDspRecTypeDesc", "txtDspRecTypeDescIcon");
	deleteOnBackSpace("txtCurrencyCd", "txtDspCurrencyDesc", "txtDspCurrencyDescIcon");
	deleteOnBackSpace("txtLawyerCd", "txtDspLawyerName", "txtDspLawyerNameIcon");
	
	//Observe LOV for Recovery Type
	$("txtDspRecTypeDescIcon").observe("click", function(){
		showRecoveryTypeLOV("GICLS025");
	});
	
	//Observe LOV for Lawyer
	$("txtDspLawyerNameIcon").observe("click", function(){
		showLawyerLOV("GICLS025");
	});
	
	//Observe Currency
	function checkReqFirst(id){
		var ok = true;
		if ($F(id) == ""){
			customShowMessageBox("Field must be entered.", "I", id);
			return false;
		}
		return ok;
	}	
	$("txtCurrencyCd").observe("focus", function(){
		if (checkReqFirst("txtRecTypeCd")){
			
		}	
	});
	$("txtDspCurrencyDesc").observe("focus", function(){
		if (checkReqFirst("txtRecTypeCd")){
			
		}
	});
	$("txtDspCurrencyDescIcon").observe("click", function(){
		if (checkReqFirst("txtRecTypeCd")){
			showClmItemCurrencyLOV("GICLS025");
		}
	});
	
	//Observe Recoverable Amount
	$("txtRecoverableAmt2").observe("focus", function(){
		if (checkReqFirst("txtRecTypeCd")){
			if (checkReqFirst("txtCurrencyCd")){
				
			}	
		}	 
	});
	
	$("txtRecoverableAmt2Icon").observe("click", function(){
		try{
			if (checkReqFirst("txtRecTypeCd")){
				if (checkReqFirst("txtCurrencyCd")){
					if (nvl($("lblClmRecStatus").innerHTML,"") == "CLOSED" || 
							nvl($("lblClmRecStatus").innerHTML,"") == "CANCELLED" || 
							nvl($("lblClmRecStatus").innerHTML,"") == "WRITTEN OFF"){
						showMessageBox("Recoverable amount of claim recoveries with "+$("lblClmRecStatus").innerHTML+" recovery status can no longer be updated.", "I");
						return false;
					}else if (nvl(unformatCurrencyValue($F("txtRecoveredAmt")),"") != "" && nvl(unformatCurrencyValue($F("txtRecoveredAmt")),0) != 0){
						showMessageBox("Recoverable amount of claim recoveries with recovered amount can no longer be updated.", "I");
						return false;
					}else{
						var recoveryId = (objCLM.recoveryDetailsCurrRow == null ? "" :objCLM.recoveryDetailsCurrRow.recoveryId);
						new Ajax.Request(contextPath+"/GICLRecoveryPaytController",{
							parameters: {
								action: "checkRecoveryValidPayt",
								claimId: objCLMGlobal.claimId,
								recoveryId: recoveryId
							},
							asynchronous: false,
							evalScripts: true,
							onComplete: function(response){
								if (checkErrorOnResponse(response)) { 
									/*var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
									if (res.checkValid == "1"){
										null;
									}else{
									showClmRecoverableDetails(objCLMGlobal.claimId, objCLMGlobal.lineCd, recoveryId, "GICLS025");
									}*/ // temporarily replaced by: Nica 07.06.2012
									//showClmRecoverableDetails(objCLMGlobal.claimId, objCLMGlobal.lineCd, recoveryId, "GICLS025"); //Removed by Joms Diago 04192013
									showClmRecoverableDetailsOverlay(objCLMGlobal.claimId, objCLMGlobal.lineCd, recoveryId); // Added by Joms Diago 04192013
								}else{
									showErrorMessage(response.responseText, "E");
								}
							}
						});
					}	
				}	
			}	 
		}catch(e){
			showErrorMessage("Recoverable Amount LOV",e);	
		}	
	});
	
	/* Created by : Joms Diago 04192013 */
	function showClmRecoverableDetailsOverlay(claimId, lineCd, recoveryId){
        recoveryAmountOverlay = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
                urlContent: true,
                draggable: true,
                urlParameters: {
                        action		: "showRecovAmtOverlay",
                        claimId     : claimId,
                        lineCd      : lineCd,
                        recoveryId  : recoveryId
                },
                title: "Recoverable Amount",
            	height: 350, // apollo cruz 07.10.2015 UCPB SR 19584 - changed from 290 to 350 to accommodate new fields in the overlay
            	width: 725
        	}); 
		}
	
	//Observe Add/Update button
	$("btnAdd").observe("click", function(){
		try{
			if (checkAllRequiredFieldsInDiv("recoveryDetailsSectionDiv")){
				var y = nvl(String(objCLM.recoveryDetailsCurrYY),null);
				if ($("btnAdd").value == "Update" && y != null){
					objCLM.recoveryDetailsUpdated = objCLM.recoveryDetailsCurrYY;
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtCaseNo")),objCLM.recoveryDetailsTG.getIndexOf('caseNo'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtCourt")),objCLM.recoveryDetailsTG.getIndexOf('court'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtPlateNo")),objCLM.recoveryDetailsTG.getIndexOf('plateNo'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtTpPlateNo")),objCLM.recoveryDetailsTG.getIndexOf('tpPlateNo'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtTpDriverName")),objCLM.recoveryDetailsTG.getIndexOf('tpDriverName'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtTpDrvrAdd")),objCLM.recoveryDetailsTG.getIndexOf('tpDrvrAdd'), y, true);
					objCLM.recoveryDetailsTG.setValueAt(escapeHTML2($F("txtTpItemDesc")),objCLM.recoveryDetailsTG.getIndexOf('tpItemDesc'), y, true);
					objCLM.recoveryDetailsTG.setValueAt($F("txtRecoverableAmt"),objCLM.recoveryDetailsTG.getIndexOf('recoverableAmt'), y, true);
					//marco - added 10.16.2013
					objCLM.recoveryDetailsTG.setValueAt($F("txtLawyerCd"), objCLM.recoveryDetailsTG.getIndexOf('lawyerCd'), y, true);
					objCLM.recoveryDetailsTG.setValueAt($F("hidLawyerClassCd"), objCLM.recoveryDetailsTG.getIndexOf('lawyerClassCd'), y, true);
					objCLM.recoveryDetailsTG.setValueAt($F("txtDspLawyerName"), objCLM.recoveryDetailsTG.getIndexOf('dspLawyerName'), y, true);
				}else{
					addClmNewRecoveryInfo();
				}	
				populateRecovery(null);
			}
		}catch(e){
			showErrorMessage("Add/Update Recovery Info.",e);	
		}	
	});
	
	//Check changeTag
	function checkChangeTagOnGICLS025(){
		try{
			if (nvl(objCLM.recoveryDetailsTG,null) instanceof MyTableGrid) observeChangeTagInTableGrid(objCLM.recoveryDetailsTG);
			if (nvl(objCLM.recPayorTG,null) instanceof MyTableGrid) observeChangeTagInTableGrid(objCLM.recPayorTG);
			if (nvl(objCLM.recHistTG,null) instanceof MyTableGrid) observeChangeTagInTableGrid(objCLM.recHistTG);
			return changeTag;
		}catch(e){
			showErrorMessage("checkChangeTagOnGICLS025", e);	
		}	
	}	
	
	//Observe Maintenance button
	$("btnMaintenance").observe("click", function(){
		//marco - call GICLS150 - 10.16.2013
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			objCLMGlobal.callingForm = "GICLS025";
			showMenuClaimPayeeClass(null, null);
		}
	});
	
	//Observe Print button
	$("btnPrint").observe("click", function(){
		if(objCLM.recPayorCurrRow != null){
			overlayPrintRecoveryLetter = Overlay.show(contextPath+"/GICLClmRecoveryController", {
				urlContent : true,
				urlParameters: {action : "showPrintRecoveryLetterDialog",
								demandLetterDate : objCLM.recoveryDetailsCurrRow.demandLetterDate,  //added by steven 8/29/2012
								demandLetterDate2 : objCLM.recoveryDetailsCurrRow.demandLetterDate2,
								demandLetterDate3 : objCLM.recoveryDetailsCurrRow.demandLetterDate3},
			    title: "Claim Recovery Letter",
			    height: 350,
			    width: 400,
			    draggable: true
			});
		} else {
			showMessageBox("Please select a payor record first.", imgMessage.INFO);
		}
	});
	
	//Show Recovery Details overlay
	$("btnRecoveryDetail").observe("click", function(){
		if (nvl(objCLM.recoveryDetailsCurrRow.recoveryId,null) == null) return;
		overlayPremWarr = Overlay.show(contextPath+"/GICLClmRecoveryDtlController", {
			urlContent: true,
			urlParameters: {action : "showRecoveryDtl",
							claimId : objCLMGlobal.claimId,
							recoveryId: objCLM.recoveryDetailsCurrRow.recoveryId,
							lineCd: objCLMGlobal.lineCd
							},
			title: "Recovery Detail",	
			id: "recovery_detail_view",
			width: 810,
			height: 270,
		    draggable: true
		});		
	});
	
	//Show Distribution Details overlay
	$("btnDetail").observe("click", function(){
		if (nvl(objCLM.recoveryDetailsCurrRow.recoveryId,null) == null) return;
		overlayPremWarr = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
			urlContent: true,
			urlParameters: {action : "getGiclRecoveryPaytGrid",
							claimId : objCLMGlobal.claimId,
							recoveryId: objCLM.recoveryDetailsCurrRow.recoveryId
							},
			title: "Loss Recovery Information",	
			id: "distribution_detail_view",
			width: 810,
			height: 470,
		    draggable: false,
		    closable: true
		});		
	});
	
	//Observe Re-open button
	//$("btnReopenRecov").observe("click", function(){
		/* showMessageBox("Page cannot be displayed right now, GICLS150 is not yet available.", "I");
		return false; */
		//showReOpenRecovery();
		/* showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		return false; */
	//});
	
	function checkRecoveredAmtPerRecovery(){
		try{
			var ctr = new Object();
			var recoveryId = (objCLM.recoveryDetailsCurrRow == null ? "" :objCLM.recoveryDetailsCurrRow.recoveryId);
			new Ajax.Request(contextPath+"/GICLClmRecoveryController",{
				parameters: {
					action: "checkRecoveredAmtPerRecovery",
					claimId: objCLMGlobal.claimId,
					recoveryId: recoveryId
				},
				asynchronous: false,
				evalJS: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)) { 
						ctr = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						return ctr;
					}
				}
			});
			return ctr;
		}catch(e){
			showErrorMessage("checkRecoveredAmtPerRecovery", e);	
		}	
	}	
	
	function closeCancelWriteoff(action, button){
		try{
			var recoveryId = (objCLM.recoveryDetailsCurrRow == null ? "" :objCLM.recoveryDetailsCurrRow.recoveryId);
			new Ajax.Request(contextPath+"/GICLClmRecoveryController",{
				parameters: {
					action: action,
					claimId: objCLMGlobal.claimId,
					recoveryId: recoveryId,
					button: button
				},
				asynchronous: false,
				evalJS: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)) { 
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, "S");
							objCLM.recoveryDetailsTG.options.toolbar.postSave.call();
						}	 
					}
				}
			});
		}catch(e){
			showErrorMessage("closeCancelWriteoff", e);	
		}
	}
	
	//Observe Write Off button
	$("btnWriteofRecov").observe("click", function(){
		if (nvl(objCLM.recoveryDetailsCurrRow.recoveryId,null) == null) return;
		if (objCLM.recoveryDetailsUpdated != null && checkChangeTagOnGICLS025() != 0){
			showMessageBox("Please save changes first before pressing WRITE OFF button.", "I");
			return false;	
		}	
		
		var ctr = checkRecoveredAmtPerRecovery();
		if (ctr.count1 == 0){
			showConfirmBox("Confirm","Are you sure you want to write off this recovery?","Yes","No",
				function(){
					if (ctr.count2 > 1){
						showConfirmBox("Confirm","Would you like to write off all recoveries without recovered amount?","Yes","No",
								function(){closeCancelWriteoff("writeOffRecovery", "Y");},function(){closeCancelWriteoff("writeOffRecovery", "N");},2);
					}else{	
						closeCancelWriteoff("writeOffRecovery", "N");
					}
				}, "", 2);
		}else{
			showMessageBox("Cannot write off a recovery record with recovered amount.", "E");
			return false;
		}	
	});
	
	//Observe Cancel Recovery button
	$("btnCancelRecov").observe("click", function(){
		if (nvl(objCLM.recoveryDetailsCurrRow.recoveryId,null) == null) return;
		if (objCLM.recoveryDetailsUpdated != null && checkChangeTagOnGICLS025() != 0){
			showMessageBox("Please save changes first before pressing CANCEL button.", "I");
			return false;	
		}
		
		var ctr = checkRecoveredAmtPerRecovery();
		if (ctr.count1 == 0){
			showConfirmBox("Confirm","Are you sure you want to cancel this recovery?","Yes","No",
				function(){
					if (ctr.count2 > 1){
						showConfirmBox("Confirm","Would you like to cancel all recoveries without recovered amount?","Yes","No",
								function(){closeCancelWriteoff("cancelRecovery", "Y");},function(){closeCancelWriteoff("cancelRecovery", "N");},2);
					}else{	
						closeCancelWriteoff("cancelRecovery", "N");
					}
				}, "", 2);
		}else{
			showMessageBox("Cannot cancel a recovery record with recovered amount.", "E");
			return false;
		}	
	});
	
	//Observe Close Recovery button
	$("btnCloseRecov").observe("click", function(){
		if (nvl(objCLM.recoveryDetailsCurrRow.recoveryId,null) == null) return;
		if (objCLM.recoveryDetailsUpdated != null && checkChangeTagOnGICLS025() != 0){
			showMessageBox("Please save changes first before pressing CLOSE button.", "I");
			return false;	
		}
		
		var ctr = checkRecoveredAmtPerRecovery();
		if (ctr.count1 >= 1){
			showConfirmBox("Confirm","Are you sure you want to close this recovery?","Yes","No",
				function(){
					if (ctr.count3 > 1){
						showConfirmBox("Confirm","Would you like to close all recoveries without recovered amount?","Yes","No",
								function(){closeCancelWriteoff("closeRecovery", "Y");},function(){closeCancelWriteoff("closeRecovery", "N");},2);
					}else{	
						closeCancelWriteoff("closeRecovery", "N");
					}
				}, "", 2);
		}else{
			showMessageBox("There should be a recovered amount before closing the recovery record.", "E");
			return false;
		}	
	});
	
	//Observe Main Form Button's
	if(objCLMGlobal.callingForm != "GICLS052" && objCLMGlobal.callingForm != "GICLS053" && objCLMGlobal.callingForm != "GICLS055"){
		observeCancelForm("btnCancel", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');},function(){fireEvent($("clmExit"), "click");}); // andrew 04.24.2012 - added condition
		//observeCancelForm("clmExit", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');}, showClaimListing); // andrew 04.24.2012 - added condition
		//commented out by Kris 08.07.2013 and replaced with the ff:
		observeCancelForm("clmExit", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');}, function(){
			if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){
				objGICLS051.previousModule = null;
				showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
			} else {
				showClaimListing();
			}
		});
	}else{
		function onExit(){
			if($("recoveryInfoDiv").innerHTML.trim() == ""){
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			} else {
				if(objCLMGlobal.callingForm == "GICLS052" || objCLMGlobal.callingForm == "GICLS055"){
					$("recoveryInfoDiv").innerHTML = "";
					$("recoveryInfoDiv").hide();
					$("lossRecoveryListingDiv").show();
					lossRecoveryListTableGrid._refreshList();
					disableMenu("recoveryDistribution");
					disableMenu("generateRecoveryAcctEnt");
					setModuleId("GICLS052");
				}else if(objCLMGlobal.callingForm == "GICLS053"){ // added by: Nica 07.06.2012
					showUpdateLossRecoveryTagListing(objCLMGlobal.lineCd);
				}else if(objCLMGlobal.callingForm == "GICLS055"){ // added by jdiago 05.19.2014
					showLossRecoveryListing(objCLMGlobal.lineCd);
				}
			}
		}
		observeCancelForm("btnCancel", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');},onExit);
		observeCancelForm("lossRecoveryExit", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');}, onExit);
	}
	
	observeSaveForm("btnSave", function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid(true);});
	
	observeReloadForm("reloadForm", showRecoveryInformation);
	changeTag = 0;
	initializeChangeTagBehavior(function(){checkChangeTagOnGICLS025(); objCLM.recoveryDetailsTG.saveGrid('onCancel');});
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GICLS025");
	setDocumentTitle("Enter Loss Recovery Details");
	
	if(objCLMGlobal.menuLineCd == "MC" || objCLMGlobal.lineCd == "MC"){
		$("btnPrint").show();
	}
	
	observeAccessibleModule(accessType.BUTTON, "GICLS125", "btnReopenRecov",showReOpenRecovery);
	if(!checkUserModule("GICLS150")){
		disableButton("btnMaintenance");
	}
}catch(e){
	showErrorMessage("Recovery Information" ,e);
}
</script>