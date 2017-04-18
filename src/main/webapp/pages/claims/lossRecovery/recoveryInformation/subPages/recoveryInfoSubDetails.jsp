<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>    

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Payor Details</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="recoveryDetailsSectionDiv3" class="sectionDiv">
	<div id="clmRecoveryDetailsGrid1" style="height: 131px; width: 810px; margin: auto; margin-top: 10px; margin-bottom: 30px;"></div>
	<table align="center" border="0">
		<tr>
			<td class="rightAligned">Payor Class</td>
			<td class="leftAligned">
				<input class="required" readonly="readonly" type="text" id="txtPayorClassCd" name="txtPayorClassCd" style="width: 50px; float: left; text-align: right;">
				<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv required">
					<input type="text" id="txtClassDesc" name="txtClassDesc" value="" style="width: 220px;" class="withIcon required" readonly="readonly">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClassDescIcon" name="txtClassDescIcon" alt="Go" />
				</div>
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Payor</td>
			<td class="leftAligned">
				<input type="hidden" id="hidMailAddr1" name="hidMailAddr1" readonly="readonly">
				<input type="hidden" id="hidMailAddr2" name="hidMailAddr2" readonly="readonly">
				<input type="hidden" id="hidMailAddr3" name="hidMailAddr3" readonly="readonly">
				<input class="required" readonly="readonly" type="text" id="txtPayorCd" name="txtPayorCd" style="width: 50px; float: left; text-align: right;">
				<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv required">
					<input type="text" id="txtDspPayorName" name="txtDspPayorName" value="" style="width: 220px;" class="withIcon required" readonly="readonly">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspPayorNameIcon" name="txtDspPayorNameIcon" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>	
			<td class="rightAligned">Recovered Amount</td>
			<td class="leftAligned">
				<input readonly="readonly" type="text" id="txtRecoveredAmt2" name="txtRecoveredAmt2" class="money" style="width: 302px;">
			</td>
		</tr>
	</table>
	<div class="buttonDiv" id="clmButtonDiv" style="float: left; width: 100%;">
		<table align="center" border="0" style="margin-bottom: 10px; margin-top: 7px;">
			<tr>
				<td><input type="button" class="button" id="btnAddPayor" name="btnAddPayor" value="Add" /></td>
				<td><input type="button" class="button" id="btnDeletePayor" name="btnDeletePayor" value="Delete" /></td>
			</tr>
		</table>
	</div>	
</div>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Recovery History</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="recoveryDetailsSectionDiv4" class="sectionDiv">
	<div id="clmRecoveryDetailsGrid2" style="height: 131px; margin: 10px;  margin-top: 10px; margin-bottom: 30px;"></div>
	<table align="center" border="0">
		<tr>
			<td class="rightAligned">History No.</td>
			<td class="leftAligned">
				<input readonly="readonly" type="text" id="txtRecHistNo" name="txtRecHistNo" style="width: 302px; text-align: right;">
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Recovery Status</td>
			<td class="leftAligned">
				<input type="text" id="txtRecStatCd" name="txtRecStatCd" style="width: 50px; float: left; text-align: right;" class="required" readonly="readonly">
				<div style="width: 246px; float: left; margin-left: 4px;" class="withIconDiv required">
					<input type="text" id="txtDspRecStatDesc" name="txtDspRecStatDesc" value="" style="width: 220px;" class="withIcon required" readonly="readonly">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspRecStatDescIcon" name="txtDspRecStatDescIcon" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>	
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned">
				<div style="float:left; width: 308px;" class="withIconDiv">
					<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 282px;" class="withIcon"> </textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" />
				</div>
			</td>
		</tr>
	</table>
	<div class="buttonDiv" id="clmButtonDiv" style="float: left; width: 100%;">
		<table align="center" border="0" style="margin-bottom: 10px; margin-top: 7px;">
			<tr>
				<td><input type="button" class="button" id="btnAddHist" name="btnAddHist" value="Add" /></td>
				<!-- <td><input type="button" class="button" id="btnDeleteHist" name="btnDeleteHist" value="Delete" /></td> -->
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
try{
	//Initialize
	initializeAll();
	initializeAccordion();
	
	var claimId = ('${claimId}');
	var recoveryId = ('${recoveryId}');
	
/****************************** Recovery Payor ******************************
 **************************************************************************** 
 */
	objCLM.recPayorGrid = JSON.parse('${recoveryPayorTG}'.replace(/\\/g, '\\\\'));
	objCLM.recPayorRows = objCLM.recPayorGrid.rows || [];
	objCLM.recPayorXX = null;
	objCLM.recPayorYY = null;
	objCLM.recPayorCurrRow = null;
	
	var recPayorTM = {
			url: contextPath+"/GICLClmRecoveryController?action=showRecoveryPayorSubDetails"+
					"&claimId=" + claimId+
					"&recoveryId=" + recoveryId+
					"&pageSize=3"+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){ 
					objCLM.recPayorXX = Number(x);
					objCLM.recPayorYY = Number(y);
					populateRecPayor(objCLM.recPayorTG.getRow(objCLM.recPayorYY));
				}, 
				onRemoveRowFocus: function ( x, y, element) {
					objCLM.recPayorXX = null;
					objCLM.recPayorYY = null; 
					populateRecPayor(null);
				}, 	
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onSave: function(){
						objCLM.recoveryDetailsTG.saveGrid('onCancel');	
					},
					postSave: function(){
						objCLM.recoveryDetailsTG.selectRow(objCLM.recoveryDetailsCurrYY);
						objCLM.recPayorTG.refresh();
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
				    id: 'payorClassCd classDesc',
				    title: 'Payor Class',
				    width : '260px',
				    children : [
			            {
			                id : 'payorClassCd',
			                title: 'Payor Class Code',
			                type: 'number',
			                width: 80,
			                filterOption: true,
			                filterOptionType: 'integer' 
			            },
			            {
			                id : 'classDesc', 
			                title: 'Payor Class Description',
			                width: 180,
			                filterOption: true
			            }
					]
				},
				{
				    id: 'payorCd payorName',
				    title: 'Payor',
				    width : '350px',
				    children : [
			            {
			                id : 'payorCd',
			                title: 'Payor Code',
			                type: 'number',
			                width: 80,
			                filterOption: true,
			                filterOptionType: 'integer'
			            },
			            {
			                id : 'payorName', 
			                title: 'Payor Name',
			                width: 270,
			                filterOption: true
			            } 
					]
				}, 
				{
					id: 'recoveredAmt',
					title: 'Recovered Amount',
					type: 'number',
					geniisysClass: 'money',
					width: '170',
					visible: true,
					filterOption: true,
					filterOptionType: 'number' 		
				}, 
				{
					id: 'recoveryId',
					width: '0',
					visible: false,
					defaultValue: recoveryId
				},
				{
					id: 'claimId',
					width: '0',
					visible: false,
					defaultValue: claimId
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
					id: 'mailAddr1',
					width: '0',
					visible: false 
				},
				{
					id: 'mailAddr2',
					width: '0',
					visible: false 
				},
				{
					id: 'mailAddr3',
					width: '0',
					visible: false 
				}
			], 
			rows: objCLM.recPayorRows,
			id: 2
	};
	
	function populateRecPayor(obj){
		try{
			objCLM.recPayorCurrRow 			= obj;
			$("txtPayorClassCd").value 		= nvl(obj,null) != null ? unescapeHTML2(String(nvl(obj.payorClassCd,""))) :null;
			$("txtClassDesc").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.classDesc,null)) :null;
			$("txtPayorCd").value 			= nvl(obj,null) != null ? unescapeHTML2(String(nvl(obj.payorCd,""))) :null;
			$("txtDspPayorName").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.payorName,null)) :null;
			$("txtRecoveredAmt2").value 	= nvl(obj,null) != null ? nvl(obj.recoveredAmt,null) != "0.00" ? formatCurrency(obj.recoveredAmt) :"0.00" :"0.00";
			$("hidMailAddr1").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.mailAddr1,null)) :null;
			$("hidMailAddr2").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.mailAddr2,null)) :null;
			$("hidMailAddr3").value 		= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.mailAddr3,null)) :null;
			
			if (nvl(obj,null) != null){
				$("btnAddPayor").value = "Update";
				//marco - deletion of record with existing recovered amount is not allowed (GENQA SR 345) - 10.16.2013
				if(parseFloat(nvl(objCLM.recPayorTG.getRow(objCLM.recPayorYY).recoveredAmt, 0)) != 0){
					disableButton("btnDeletePayor");
				}else{
					enableButton("btnDeletePayor");
				}
			}else{
				$("btnAddPayor").value = "Add";
				disableButton("btnDeletePayor");
			}	
			
			observeChangeTagInTableGrid(objCLM.recPayorTG);
			objCLM.recPayorTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("populateRecPayor", e);	
		}
	}	
	
	objCLM.recPayorTG = new MyTableGrid(recPayorTM);
	objCLM.recPayorTG.pager = objCLM.recPayorGrid; 
	objCLM.recPayorTG._mtgId = 2; 
	objCLM.recPayorTG.afterRender = function(){
		populateRecPayor(null);
	};
	objCLM.recPayorTG.render('clmRecoveryDetailsGrid1');
	
	//Observe backspace on input w/ LOV
	deleteOnBackSpace("txtPayorClassCd", "txtClassDesc", "txtClassDescIcon");
	deleteOnBackSpace("txtPayorCd", "txtDspPayorName", "txtDspPayorNameIcon");
	$("txtPayorClassCd").observe("keyup", function(e) {
		if (objKeyCode.BACKSPACE == e.keyCode){
			$("txtPayorCd").clear();
			$("txtDspPayorName").clear();
		}	
	});
	$("txtClassDesc").observe("keyup", function(e) {
		if (objKeyCode.BACKSPACE == e.keyCode){
			$("txtPayorCd").clear();
			$("txtDspPayorName").clear();
		}	
	});
	
	//Observe LOV for Payor Class
	$("txtClassDescIcon").observe("click", function() {
		if (nvl(objCLM.recoveryDetailsCurrRow,null) == null){
			showMessageBox("Please select recovery first.", "I");
			return false;
		}else{	
			showPayorClassLOV("GICLS025");
		}
	});
	
	//Observe LOV for Payor
	$("txtDspPayorNameIcon").observe("click", function() {
		if (nvl(objCLM.recoveryDetailsCurrRow,null) == null){
			showMessageBox("Please select recovery first.", "I");
			return false;
		}else if($F("txtPayorClassCd") == ""){
			customShowMessageBox("Please select payor class first.", "I", "txtPayorClassCd");
			return false;
		}else{	
			showPayorLOV("GICLS025", objCLM.recPayorTG.createNotInParam2("payorClassCd", $F("txtPayorClassCd"), "payorCd"), $("txtPayorClassCd").value, objCLM.recPayorTG, claimId, recoveryId);
		}
	});
	
	function createRecPayor(){
		try{
			var obj 			= new Object();
			obj.payorClassCd	= escapeHTML2($("txtPayorClassCd").value);
			obj.classDesc		= escapeHTML2($("txtClassDesc").value);
			obj.payorCd			= escapeHTML2($("txtPayorCd").value);
			obj.payorName		= escapeHTML2($("txtDspPayorName").value);
			obj.recoveredAmt	= unformatCurrencyValue($("txtRecoveredAmt2").value);
			obj.mailAddr1		= escapeHTML2($("hidMailAddr1").value);
			obj.mailAddr2		= escapeHTML2($("hidMailAddr2").value);
			obj.mailAddr3		= escapeHTML2($("hidMailAddr3").value);
			obj.recoveryId      = recoveryId;
			obj.claimId			= claimId;
			
			return obj;
		}catch(e){
			showErrorMessage("createRecPayor", e);	
		}	
	}	
	
	//Observe Add/Update Payor button
	$("btnAddPayor").observe("click", function(){
		try{
			if (checkAllRequiredFieldsInDiv("recoveryDetailsSectionDiv3")){
				if ($F("btnAddPayor") == "Update"){
					objCLM.recPayorTG.deleteRow(objCLM.recPayorYY);
					objCLM.recPayorTG.createNewRow(createRecPayor());
				}else{
					objCLM.recPayorTG.createNewRow(createRecPayor());
				}	
				objCLM.recoveryDetailsUpdated = objCLM.recoveryDetailsCurrYY;
				populateRecPayor(null);
			}	
		}catch(e){
			showErrorMessage("Add/Update Payor button",e);	
		}	
	});
	
	//Observe Delete Payor button
	$("btnDeletePayor").observe("click", function(){
		try{
			objCLM.recPayorTG.deleteRow(objCLM.recPayorYY);
			objCLM.recoveryDetailsUpdated = objCLM.recoveryDetailsCurrYY;
			populateRecPayor(null);
		}catch(e){
			showErrorMessage("Delete Payor button",e);	
		}
	});	
	
/***************************** Recovery History *****************************
 **************************************************************************** 
 */
	objCLM.recHistGrid = JSON.parse('${recoveryHistTG}'.replace(/\\/g, '\\\\'));
	objCLM.recHistRows = objCLM.recHistGrid.rows || [];
	objCLM.recHistXX = null;
	objCLM.recHistYY = null;
	objCLM.recHistCurrRow = null;
	
	var recHistTM = {
			url: contextPath+"/GICLClmRecoveryController?action=showRecoveryHistSubDetails"+
					"&claimId=" + claimId+
					"&recoveryId=" + recoveryId+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){ 
					objCLM.recHistXX = Number(x);
					objCLM.recHistYY = Number(y);  
					//populateRecHist(objCLM.recHistTG.getRow(objCLM.recHistYY));
					populateRecHist(objCLM.recHistTG.geniisysRows[y]);
				}, 
				onRemoveRowFocus: function ( x, y, element) {
					objCLM.recHistXX = null;
					objCLM.recHistYY = null;
					populateRecHist(null);
				} 	, 	
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onSave: function(){
						objCLM.recoveryDetailsTG.saveGrid('onCancel');	
					},
					postSave: function(){
						objCLM.recoveryDetailsTG.selectRow(objCLM.recoveryDetailsCurrYY);
						objCLM.recHistTG.refresh();
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
					visible: false,
					defaultValue: recoveryId
				},
				{
					id: 'recHistNo',
					title: 'History',
					width: '80',
					type: 'number',
					align: 'right',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
						//return value == 0 ? "" : formatNumberDigits(value,3);
					},
					visible: true,
					filterOption: true,
					filterOptionType: 'integer' 
				},	
				{
				    id: 'recStatCd dspRecStatDesc',
				    title: 'Recovery Staus',
				    width : '245px',
				    children : [
			            {
			                id : 'recStatCd',
			                title: 'Recovery Status Code',
			                width: 65,
			                filterOption: true
			            },
			            {
			                id : 'dspRecStatDesc', 
			                title: 'Recovery Status Description',
			                width: 180,
			                filterOption: true
			            }
					]
				},
				{
					id: 'remarks',
					title: 'Remarks',
					width: '314',
					visible: true,
					filterOption: true
				},
				{
					id: 'userId',
					title: 'User Id',
					width: '101',
					visible: true
				},
				{
					id: 'lastUpdate',
					width: '0',
					visible: false 
				},
				{
					id: 'strLastUpdate',
					title: 'Last Update',
					width: '135', 
					visible: true
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
				}
			], 
			rows: objCLM.recHistRows,
			id: 3
	};
	
	function populateRecHist(obj){
		try{
			objCLM.recHistCurrRow 			= obj;
			//$("txtRecHistNo").value 		= nvl(obj,null) != null ? formatNumberDigits(String(nvl(obj.recHistNo,"")),3) :null;
			$("txtRecHistNo").value 		= obj == null ? "" : obj.recHistNo != null ? formatNumberDigits(obj.recHistNo, 3) : "";
			$("txtDspRecStatDesc").value 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.dspRecStatDesc,null)) :null;
			$("txtRecStatCd").value 		= nvl(obj,null) != null ? unescapeHTML2(String(nvl(obj.recStatCd,""))) :null;
			$("txtRemarks").value 			= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.remarks,null)) :null;
			
			//disableButton("btnDeleteHist");
			if (nvl(obj,null) != null){
				$("btnAddHist").value = "Update";
				disableSearch("txtDspRecStatDescIcon");
			}else{
				$("btnAddHist").value = "Add";
				enableSearch("txtDspRecStatDescIcon");
			}	
			
			observeChangeTagInTableGrid(objCLM.recHistTG);
			objCLM.recHistTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("populateRecHist", e);	
		}
	}	
	
	objCLM.recHistTG = new MyTableGrid(recHistTM);
	objCLM.recHistTG.pager = objCLM.recHistGrid; 
	objCLM.recHistTG._mtgId = 3; 
	objCLM.recHistTG.afterRender = function(){
		populateRecHist(null);
	};
	objCLM.recHistTG.render('clmRecoveryDetailsGrid2');
	
	//Observe backspace on input w/ LOV
	deleteOnBackSpace("txtRecStatCd", "txtDspRecStatDesc", "txtDspRecStatDescIcon");
	
	//Observe Edit Remarks
	$("editTxtRemarks").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	//Observe LOV for Recovery Status 
	$("txtDspRecStatDescIcon").observe("click", function () {
		if (nvl(objCLM.recoveryDetailsCurrRow,null) == null){ //marco - added condition - 10.16.2013
			showMessageBox("Please select recovery first.", "I");
			return false;
		}else{	
			showRecoveryStatusLOV("GICLS025");
		}
	});
	
	function createRecHist(maxRecHistNo){
		try{
			var obj = new Object();
			obj.recoveryId			= recoveryId;	
			obj.recHistNo			= maxRecHistNo;
			obj.recStatCd			= unescapeHTML2($("txtRecStatCd").value);
			obj.remarks				= unescapeHTML2($("txtRemarks").value);;
			obj.dspRecStatDesc		= unescapeHTML2($("txtDspRecStatDesc").value);;
			obj.strLastUpdate		= getCurrentDateTime(true);
			obj.lastUpdate			= obj.strLastUpdate;
			obj.userId				= ("${PARAMETERS['USER'].userId}");
			return obj;
		}catch(e){
			showErrorMessage("createRecHist", e);	
		}	
	}	
	
	//Observe Add/Update button on Recovery History
	$("btnAddHist").observe("click", function(){
		try{
			if (checkAllRequiredFieldsInDiv("recoveryDetailsSectionDiv4")){
				//Will get the max rec_hist_no first
				var maxRecHistNo = null;
				new Ajax.Request(contextPath+"/GICLClmRecoveryController?action=genRecHistNo",{
					method: "POST",
					parameters:{
						recoveryId: recoveryId	
					},
					asynchronous: false, 
					evalJS: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){ 
							maxRecHistNo = response.responseText;
							maxRecHistNo = parseInt(maxRecHistNo) - 1;
							maxRecHistNo = generateTableGridSequenceNo3(objCLM.recHistTG, 'recHistNo', 'recoveryId', recoveryId, maxRecHistNo);
						} 
					}	 
				});	
				
				if ($F("btnAddHist") == "Update"){
					//objCLM.recHistTG.deleteRow(objCLM.recHistYY);
					//objCLM.recHistTG.createNewRow(createRecHist(maxRecHistNo));
					//objCLM.recHistTG.createNewRow(createRecHist(removeLeadingZero($F("txtRecHistNo"))));
					objCLM.recHistTG.updateVisibleRowOnly(
							createRecHist(removeLeadingZero($F("txtRecHistNo"))),
							objCLM.recHistYY, false);
				}else{
					//objCLM.recHistTG.createNewRow(createRecHist(maxRecHistNo));
					objCLM.recHistTG.addBottomRow(createRecHist());
				}	
				objCLM.recoveryDetailsUpdated = objCLM.recoveryDetailsCurrYY;
				populateRecHist(null);
			}	
		}catch(e){
			showErrorMessage("Add/Update History button", e);	
		}
	});
	
}catch(e){
	showErrorMessage("Recovery Info Sub Details", e);	
}	
</script>