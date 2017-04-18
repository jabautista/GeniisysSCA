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
		<label>Peril Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="perilInfoMainDiv" name="perilInfoMainDiv">
	<div id="perilInfo" name="perilInfo" style="margin: 10px;">
		<div id="perilInfoTableGridSectionDiv" name="perilInfoTableGridSectionDiv">
			<div id="perilInfoTable" name="perilInfoTable" style="height:200px;"></div>
		</div>
		<div style="margin-bottom:15px;">
			<input type="hidden" id="hidPerilFundCd" name="hidPerilFundCd">
			<input type="hidden" id="hidPerilBranchCd" name="hidPerilBranchCd">
			<input type="hidden" id="hidCommRecId" name="hidCommRecId">
			<input type="hidden" id="hidPerilIntmNo" name="hidPerilIntmNo">
			<input type="hidden" id="hidCommPerilId" name="hidCommPerilId">
			<input type="hidden" id="hidPerilCd" name="hidPerilCd">
			<input type="hidden" id="hidPerilDelSw" name="hidPerilDelSw">
			<input type="hidden" id="hidPerilTranFlag" name="hidPerilTranFlag">
			<table>
				<tr>
					<td style="width: 175px; text-align:right; padding-right:5px;">Totals</td>
					<td style="width: 235px;">
						<input type="text" style="width: 145px;" id="txtTotalPerilPremAmt" name="txtTotalPerilPremAmt" readonly="readonly" class="money" value=""/>
					</td>
					<td>
						<input type="text" style="width: 142px; margin-left: 2px;" id="txtTotalPerilCommAmt" name="txtTotalPerilCommAmt"readonly="readonly"  class="money" value=""/>
					</td>
					<td>
						<input type="text" style="width: 140px;" id="txtTotalPerilWithTax" name="txtTotalPerilWithTax" readonly="readonly" class="money" value=""/>
					</td>
					<td>
						<input type="text" style="width: 141px;" id="txtTotalPerilNetCommAmt" name="txtTotalPerilNetCommAmt" readonly="readonly" class="money" value=""/>
					</td>
				</tr>
			</table>
		</div>
		<div id="perilInfoFormDiv" name="perilInfoFormDiv">
			<table align="center" border="0" style="padding: 0 45px 0 15px">
				<tr>
					<td class="rightAligned">Peril Name</td>
					<td class="leftAligned">
						<input type="text" style="width: 195px;" id="txtPerilName" name="txtPerilName" readonly="readonly" value=""/>
					</td>
					<td class="rightAligned" style="width:130px;">Commission</td>
					<td class="leftAligned">
						<input type="text" style="width: 195px;" id="txtPerilCommission" name="txtPerilCommission" class="money" readonly="readonly" value=""/>
					</td>
				</tr>
				
				<tr>
					<td class="rightAligned">Premium Amount</td>
					<td class="leftAligned">
						<input type="text" style="width: 195px; text-align: right;" id="txtPerilPremAmt" name="txtPerilPremAmt" readonly="readonly" value=""/>
					</td>
					<td class="rightAligned" style="width:130px;">Withholding Tax</td>
					<td class="leftAligned">
						<input type="text" style="width: 195px; text-align: right;" id="txtPerilWholdingTax" name="txtPerilWholdingTax" class="money" readonly="readonly" value="" maxlength="13"/>
					</td>
				</tr>
				
				<tr>
					<td class="rightAligned">Rate</td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 195px; text-align: right;" id="txtPerilCommRate" name="txtPerilCommRate" value="" class="applyDecimalRegExp" regexppatt="pDeci0307"/> -->
						<input type="text" style="width: 195px; text-align: right;" id="txtPerilCommRate" name="txtPerilCommRate" value="" maxlength="11"/>
					</td>
					<td class="rightAligned" style="width:130px;">Net Commission</td>
					<td class="leftAligned">
						<input type="text" style="width: 195px; text-align: right;" id="txtPerilNetCommission" name="txtPerilNetCommission" class="money" readonly="readonly" value=""/>
					</td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin:0; padding:10px 0" align="center">
			<input type="button" id="btnUpdatePeril" name="btnUpdatePeril"  style="width: 65px;" class="button hover"   value="Update" />
		</div>
	</div>
</div>
<script>
	//Show Table Grid
	try {
		var jsonPerilInfoList = JSON.parse('${jsonPerilInfoList}');
		objACGlobal.objGIACS408.allowUpdatePeril = false;
		objACGlobal.objGIACS408.tempObjPerilInfoArray = [];
		objACGlobal.objGIACS408.objPerilInfoArray = [];
		objACGlobal.objGIACS408.origCommRate = null; //added by steven 10.21.2014
		var objPerilInfoArray = [];
		
		perilInfoTableModel = {
			url : contextPath+ "/GIACDisbursementUtilitiesController?action=showPerilInfoListing&refresh=1",
			options : {
				width : '900px',
				height : '200px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgPerilInfo.geniisysRows[y];
					populatePerilInfoDtls(obj);
					//added by steven 10.21.2014
					if (objACGlobal.objGIACS408.origCommRate == null) {
						objACGlobal.objGIACS408.origCommRate = formatToNthDecimal(nvl(obj.commissionRt, 0), 7);
					}
					tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgPerilInfo.keys.releaseKeys();
				},
				postPager : function() {
					populatePerilInfoDtls(null);
					tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgPerilInfo.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populatePerilInfoDtls(null);
					tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgPerilInfo.keys.releaseKeys();
				},
				onSort : function(){
					populatePerilInfoDtls(null);
					tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
					tbgPerilInfo.keys.releaseKeys();
				},
				beforeSort: function(){
					if(objACGlobal.objGIACS408.piChangeTag == 1){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				prePager: function(){
					if(objACGlobal.objGIACS408.piChangeTag == 1){
						showMessageBox("Please save your changes first.", imgMessage.INFO);
						return false;
					}
				},
				checkChanges: function(){
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (objACGlobal.objGIACS408.piChangeTag == 1 ? true : false);
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function(){
						populatePerilInfoDtls(null);
						tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
						tbgPerilInfo.keys.releaseKeys();
					},
					onRefresh : function(){
						populatePerilInfoDtls(null);
						tbgPerilInfo.keys.removeFocus(tbgInvCommInfo.keys._nCurrentFocus, true);
						tbgPerilInfo.keys.releaseKeys();
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
					id: 'fundCd',
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
				{
					id: 'commPerilId',
					width: '0',
					visible: false 
				},
				{
					id : "perilCd",
					width : '0',
					visible : false
				},
				{
					id : "deleteSw",
					width : '0',
					visible : false
				},
				{
					id : "perilName",
					title : "Peril Name",
					width : '180px',
					filterOption : true
				},
				{
					id : "premiumAmt",
					title : "Premium Amount",
					titleAlign : "right",
					width : '146px',
					filterOption : true,
					type : 'number',					
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "commissionRt",
					title : "Rate",
					titleAlign : "right",
					width : '85px',
					type : 'number',
					align: 'right',
					geniisysClass : 'rate',
					filterOptionType : 'number',
					renderer:function(value){
						return formatToNthDecimal(value, 7);
					}
				},
				{
					id : "commissionAmt",
					title : "Commission Amount",
					titleAlign : "right",
					width : '146px',
					filterOption : true,
					type : 'number',					
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "wholdingTax",
					title : "Withholding Tax",
					titleAlign : "right",
					width : '146px',
					filterOption : true,
					type : 'number',					
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "netCommAmt",
					title : "Net Commission",
					titleAlign : "right",
					width : '146px',
					filterOption : true,
					type : 'number',					
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id: 'tranFlag',
					width: '0',
					visible: false 
				}
			],
			rows : jsonPerilInfoList.rows
		};
		tbgPerilInfo = new MyTableGrid(perilInfoTableModel);
		tbgPerilInfo.pager = jsonPerilInfoList;
		tbgPerilInfo.render('perilInfoTable');
		tbgPerilInfo.afterRender = function(){
			objPerilInfoArray = tbgPerilInfo.geniisysRows;
			var totalPremiumAmt = 0;
			var totalCommissionAmt = 0;
			var totalWholdingTax = 0;
			var totalNetCommAmt = 0;
			populatePerilInfoDtls(null);

			if(objPerilInfoArray.length != 0){
				totalPremiumAmt = objPerilInfoArray[0].totalPremiumAmt;
				totalCommissionAmt = objPerilInfoArray[0].totalCommissionAmt;
				totalWholdingTax = objPerilInfoArray[0].totalWholdingTax;
				totalNetCommAmt = objPerilInfoArray[0].totalNetCommAmt;
			}
			
			$("txtTotalPerilPremAmt").value = formatCurrency(totalPremiumAmt);
			$("txtTotalPerilCommAmt").value = formatCurrency(totalCommissionAmt);
			$("txtTotalPerilWithTax").value = formatCurrency(totalWholdingTax);
			$("txtTotalPerilNetCommAmt").value = formatCurrency(totalNetCommAmt);
			
			tbgPerilInfo.keys.removeFocus(tbgPerilInfo.keys._nCurrentFocus, true);
			tbgPerilInfo.keys.releaseKeys();
			
			//objACGlobal.objGIACS408.objPerilInfoArray = objPerilInfoArray;
			/* for autoselect
				if(tbgPerilInfo.geniisysRows.length > 0){
				var obj = tbgPerilInfo.geniisysRows[0];
				tbgPerilInfo.selectRow('0');
				populatePerilInfoDtls(obj);
			} */
			if(objACGlobal.objGIACS408.tempObjPerilInfoArray.length != 0){
				for(var i=0; i<objACGlobal.objGIACS408.tempObjPerilInfoArray.length; i++){
					for(var j=0; j<objPerilInfoArray.length; j++){
						if(objACGlobal.objGIACS408.tempObjPerilInfoArray[i].fundCd == objPerilInfoArray[j].fundCd &&
						   objACGlobal.objGIACS408.tempObjPerilInfoArray[i].branchCd == objPerilInfoArray[j].branchCd &&
						   objACGlobal.objGIACS408.tempObjPerilInfoArray[i].commRecId == objPerilInfoArray[j].commRecId &&
						   objACGlobal.objGIACS408.tempObjPerilInfoArray[i].intmNo == objPerilInfoArray[j].intmNo &&
						   objACGlobal.objGIACS408.tempObjPerilInfoArray[i].commPerilId == objPerilInfoArray[j].commPerilId){
							objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, objACGlobal.objGIACS408.tempObjPerilInfoArray[i]);
							tbgPerilInfo.updateVisibleRowOnly(objACGlobal.objGIACS408.tempObjPerilInfoArray[i], j);
						}	
					}
				}
			}
		};
	} catch (e) {
		showErrorMessage("perilInfoTableModel", e);
	}
	
	$("btnRecomputeWithTax").observe("click", function(){
		recomputeWtaxRate();
	});
	
	$("txtPerilCommRate").observe("change", function(){
		if(isNaN($F("txtPerilCommRate"))){
			customShowMessageBox("Field must be of form 999.000000000.", "E", "txtPerilCommRate");
			$("txtPerilCommRate").clear();
		}else{
			if($F("txtPerilCommRate") < 0.0 || $F("txtPerilCommRate") > 100.0) {
				 customShowMessageBox('You entered an invalid rate. Please try again.','I',"txtPerilCommRate");
				 $("txtPerilCommRate").value = 0; //formatToNthDecimal(0, 7);
				 return false;
			/*}else if (objACGlobal.objGIACS408.commPaid == "Y" && parseFloat($F("txtPerilCommRate")) < parseFloat(objACGlobal.objGIACS408.origCommRate)){ //added by steven 10.21.2014
				customShowMessageBox('New rate for invoice with existing commission payment transactions must not be less than the original rate.','I',"txtPerilCommRate");
				$("txtPerilCommRate").value = objACGlobal.objGIACS408.origCommRate;
				return false;*/
			}else{
				if($F("txtPerilCommRate") == ""){
					$("txtPerilCommRate").value = 0; //formatToNthDecimal(0, 7);
				}else if(validatePerilCommRt()){
					var perilCommission  = unformatCurrency("txtPerilPremAmt") * ($F("txtPerilCommRate") / 100.0);
					var perilWholdingTax =  perilCommission * $F("hidInvWtaxRate");
					var perilNetCommission = perilCommission - perilWholdingTax;
					
					$("txtPerilCommission").value = formatCurrency(perilCommission);
					$("txtPerilWholdingTax").value =  formatCurrency(perilWholdingTax);
					$("txtPerilNetCommission").value = formatCurrency(perilNetCommission);
					
					$("txtCommissionAmt").value = formatCurrency(perilCommission);
					$("txtWholdtingTax").value =  formatCurrency(perilWholdingTax);
					$("txtNetCommAmt").value = formatCurrency(perilNetCommission);
					
					$("txtPerilCommRate").value = formatToNthDecimal($("txtPerilCommRate").value, 7);
				}
			}
		}
	});
	
	function setCommInvPerilInformation(){
		try{
			var newObj = new Object();
			
            newObj.fundCd			= $F("hidPerilFundCd");
            newObj.branchCd			= $F("hidPerilBranchCd");
            newObj.commRecId		= $F("hidCommRecId");
            newObj.intmNo			= $F("hidPerilIntmNo");
            newObj.commPerilId		= $F("hidCommPerilId");         
            
            newObj.commissionRt		= $F("txtPerilCommRate");
            newObj.premiumAmt		= unformatCurrency("txtPerilPremAmt");
            newObj.commissionAmt	= unformatCurrency("txtPerilCommission");
            newObj.wholdingTax		= unformatCurrency("txtPerilWholdingTax");
            newObj.netCommAmt		= unformatCurrency("txtPerilNetCommission");
            
            return newObj;
		}catch(e){
			showErrorMessage("setCommInvPerilInformation",e);
		}
	}
	
	$("btnUpdatePeril").observe("click", function(){
		var newObj = setCommInvPerilInformation();
		var totalPerilCommAmt = 0;
		var totalPerilWithTax = 0;
		var totalPerilNetCommAmt = 0;
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
		objACGlobal.objGIACS408.piChangeTag = 1;
		var perils = objACGlobal.objGIACS408.allPerils;
		
		for(var i=0; i<perils.length; i++){	// replace all objPerilInfoArray to perils
			if((perils[i].recordStatus != -1) &&
			   (perils[i].fundCd == newObj.fundCd) &&
			   (perils[i].branchCd == newObj.branchCd) &&
			   (perils[i].commRecId == newObj.commRecId) &&
			   (perils[i].intmNo == newObj.intmNo) &&
			   (perils[i].commPerilId == newObj.commPerilId)){
			
				perils[i].commissionRt = newObj.commissionRt;
				perils[i].premiumAmt = newObj.premiumAmt;
				perils[i].commissionAmt = newObj.commissionAmt;
				perils[i].wholdingTax = newObj.wholdingTax;
				perils[i].netCommAmt = newObj.netCommAmt;
				perils[i].recordStatus = 1;
				
				objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, perils[i]);
				objACGlobal.objGIACS408.allPerils.splice(i, 1, perils[i]);
				tbgPerilInfo.updateVisibleRowOnly(perils[i], tbgPerilInfo.getCurrentPosition()[1]);
			}
			
			totalPerilCommAmt = totalPerilCommAmt + nvl(parseFloat(perils[i].commissionAmt), 0);
			totalPerilWithTax = totalPerilWithTax + nvl(parseFloat(perils[i].wholdingTax), 0);
			//totalPerilNetCommAmt = totalPerilNetCommAmt + nvl(parseFloat(objPerilInfoArray[i].netCommAmt), 0);
		}
		
		totalPerilNetCommAmt = totalPerilCommAmt - totalPerilWithTax;
		//peril
		$("txtTotalPerilCommAmt").value = formatCurrency(totalPerilCommAmt);
		$("txtTotalPerilWithTax").value = formatCurrency(totalPerilWithTax);
		$("txtTotalPerilNetCommAmt").value = formatCurrency(totalPerilNetCommAmt);
		//invoice comm
		$("txtCommissionAmt").value = formatCurrency(totalPerilCommAmt);
		$("txtWholdtingTax").value = formatCurrency(totalPerilWithTax);
		$("txtNetCommAmt").value = formatCurrency(totalPerilNetCommAmt);
		//update master table
		objACGlobal.objGIACS408.updateInvCommByPeril();
		
		populatePerilInfoDtls(null);
	});
	
	function executeQueryPerilInfo(fundCd, branchCd, commRecId, intmNo, lineCd){
		try{
			tbgPerilInfo.url = contextPath+ "/GIACDisbursementUtilitiesController?action=showPerilInfoListing&refresh=1&fundCd="+fundCd+"&branchCd="+branchCd
				+"&commRecId="+commRecId+"&intmNo="+intmNo+"&lineCd="+$F("hidLineCd");
			tbgPerilInfo._refreshList();
			
			// to retrieve all perils, used for computing totals when updating a peril record : shan 01.12.2015
			new Ajax.Request(contextPath+ "/GIACDisbursementUtilitiesController?action=getGiacs408PerilList", {
				method: "POST",
				parameters: {
					fundCd:		fundCd,
					branchCd:	branchCd,
					commRecId:	commRecId,
					intmNo:		intmNo,
					lineCd:		$F("hidLineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						objACGlobal.objGIACS408.allPerils = JSON.parse(response.responseText);
					}
				}
			});
		}catch(e){
			showErrorMessage("executeQueryInvCommInfo", e);
		}
	}
	objACGlobal.objGIACS408.executeQueryPerilInfo = executeQueryPerilInfo;
	
	function enterQueryPerilInfo(){
		try{
			tbgPerilInfo.url = contextPath+ "/GIACDisbursementUtilitiesController?action=showPerilInfoListing&refresh=1";
			tbgPerilInfo._refreshList();
		}catch(e){
			showErrorMessage("executeQueryInvCommInfo", e);
		}
	}
	objACGlobal.objGIACS408.enterQueryPerilInfo = enterQueryPerilInfo;
	
	function populatePerilInfoDtls(obj){
		try{
			$("txtPerilName").value 			= obj == null? "" : unescapeHTML2(obj.perilName);
			$("txtPerilPremAmt").value 			= obj == null? "" : formatCurrency(nvl(obj.premiumAmt, 0));
			$("txtPerilCommRate").value 		= obj == null? "" : formatToNthDecimal(nvl(obj.commissionRt, 0), 7);
			$("txtPerilCommission").value 		= obj == null? "" : formatCurrency(nvl(obj.commissionAmt, 0));
			$("txtPerilWholdingTax").value		= obj == null? "" : formatCurrency(nvl(obj.wholdingTax, 0));
			$("txtPerilNetCommission").value 	= obj == null? "" : formatCurrency(nvl(obj.netCommAmt, 0));

			$("hidPerilFundCd").value 			= obj == null? "" : obj.fundCd;
			$("hidPerilBranchCd").value 		= obj == null? "" : obj.branchCd;
			$("hidCommRecId").value 			= obj == null? "" : obj.commRecId;
			$("hidPerilIntmNo").value 			= obj == null? "" : obj.intmNo;
			$("hidCommPerilId").value 			= obj == null? "" : obj.commPerilId;
			$("hidPerilCd").value 				= obj == null? "" : obj.perilCd;
			$("hidPerilDelSw").value 			= obj == null? "" : obj.deleteSw;
			$("hidPerilTranFlag").value 		= obj == null? "" : obj.tranFlag;
			if(obj == null){
				disableButton("btnUpdatePeril");
				$("txtPerilCommRate").readOnly = true;
			}else{
				if(objACGlobal.objGIACS408.allowUpdatePeril){
					$("txtPerilCommRate").readOnly = false;
					//$("txtPerilWholdingTax").readOnly = false;
					enableButton("btnUpdatePeril");
				}else{
					$("txtPerilCommRate").readOnly = true;
					$("txtPerilWholdingTax").readOnly = true;
					disableButton("btnUpdatePeril");
				}
			}
		}catch(e){
			showErrorMessage("populatePerilInfoDtls", e);			
		}
	}
	objACGlobal.objGIACS408.populatePerilInfoDtls = populatePerilInfoDtls;
	
	function validatePerilCommRt(){
		try{
			var isValid = false;
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=validatePerilCommRt", {
				method: "POST",
				parameters: {
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd,
					commRecId: $F("hidInvCommRecId"),
					intmNo: $F("hidInvIntmNo"),
					commPerilId: $F("hidCommPerilId"),
					commPaid: objACGlobal.objGIACS408.commPaid, 
					commissionRt: unformatCurrency("txtPerilCommRate"),
					lineCd : $F("hidLineCd"),   //Deo [03.07.2017]: add start (SR-5944)
					sublineCd : $F("hidSublineCd"),
					issCd : $F("txtIssCd"),
					perilCd : $F("hidPerilCd")  //Deo [03.07.2017]: add ends (SR-5944)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						if(json.message != null){
							if (json.message.include("Error")) {  //Deo [03.07.2017]: add start (SR-5944)
								var message = json.message.split("#");
								showWaitingMessageBox(message[1], "E", function(){
									$("txtPerilCommRate").value = formatToNthDecimal(nvl($("txtPerilCommRate").readAttribute("lastValidValue"), 0), 7);
								});
							} else {  //Deo [03.07.2017]: add ends (SR-5944)
							showMessageBox(json.message,'I');
							$("txtPerilCommRate").value = formatToNthDecimal(json.commissionRt, 7);
							isValid = false;
							}  //Deo [03.07.2017]: close else (SR-5944)
						}else{
							 $("txtPerilCommRate").value = formatToNthDecimal($F("txtPerilCommRate"), 7);
							 isValid = true;
						}
					}
				}
			});
			return isValid;
		}catch(e){
			showErrorMessage("validateInvCommShare", e);
		}
	}
	
	var perilObj = new Object();
	var commissionRate;
	
	// sorry mejo nde maganda ung approach :s
	/* $("btnRecomputeCommRt").observe("click", function(){
		if($F("txtDspTranFlag") == "POSTED"){
			showMessageBox("You cannot update this record.", "E");
			return false;
		}
		var tgLength = tbgPerilInfo.geniisysRows.length;
		for(var i = 0; i < tgLength; i++){
			recomputeCommRate(tbgPerilInfo.geniisysRows[i].perilCd, i);
		}
		rgComputePerilInv();
		populatePerilInfoDtls(null);
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
		objACGlobal.objGIACS408.piChangeTag = 1;
		objACGlobal.objGIACS408.objPerilInfoArray = tbgPerilInfo.geniisysRows;
	}); */
	
	// bonok :: 04.15.2014 :: modified Recompute Commission Rate
	$("btnRecomputeCommRt").observe("click", function(){
		tbgPerilInfo.url = contextPath+ "/GIACDisbursementUtilitiesController?action=recomputeCommRate2&fundCd="+selectedRecord.fundCd+"&branchCd="+selectedRecord.branchCd
									+"&commRecId="+selectedRecord.commRecId+"&intmNo="+selectedRecord.intmNo+"&lineCd="+$F("hidLineCd")+"&issCd="+$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo");
		tbgPerilInfo._refreshList();
		
		objACGlobal.objGIACS408.updateInvCommByPeril();
		populatePerilInfoDtls(null);
		changeTag = 1;
		objACGlobal.objGIACS408.piChangeTag = 1;
		objACGlobal.objGIACS408.objPerilInfoArray = tbgPerilInfo.geniisysRows;
	});
	
	function recomputeCommRate(perilCd, index){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=recomputeCommRate", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					policyId: $F("hidPolicyId"),
					intmNo: $F("hidInvIntmNo"),
					lineCd: $F("hidLineCd"),
					sublineCd: $F("hidSublineCd"),
					perilCd: perilCd//$F("hidPerilCd"),
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var commissionRate = response.responseText;
						
						tbgPerilInfo.geniisysRows[index].commissionRt = commissionRate;
						tbgPerilInfo.geniisysRows[index].commissionAmt = roundNumber(tbgPerilInfo.geniisysRows[index].premiumAmt * (commissionRate / 100),2);
						tbgPerilInfo.geniisysRows[index].wholdingTax = roundNumber(tbgPerilInfo.geniisysRows[index].commissionAmt * parseFloat($F("hidInvWtaxRate")),2);
						tbgPerilInfo.geniisysRows[index].netCommAmt = tbgPerilInfo.geniisysRows[index].commissionAmt - tbgPerilInfo.geniisysRows[index].wholdingTax;
						tbgPerilInfo.geniisysRows[index].recordStatus = 1;
						
						$("txtPerilCommission").value = formatCurrency(roundNumber((unformatCurrency("txtPerilPremAmt") * (parseFloat($F("txtPerilCommRate")) / 100.0)), 2));
						$("txtPerilWholdingTax").value =  formatCurrency(roundNumber((unformatCurrency("txtPerilCommission") *  parseFloat($F("hidInvWtaxRate"))), 2));
						$("txtPerilNetCommission").value = formatCurrency(unformatCurrency("txtPerilCommission") - unformatCurrency("txtPerilWholdingTax"));
						
						updatePerilTG(tbgPerilInfo.geniisysRows[index], index);
					}
				}
			});
		}catch(e){
			showErrorMessage("recomputeCommRate", e);
		}
	}
	
	function updatePerilTG(obj, index){
		objPerilInfoArray.splice(index, 1, obj);
		tbgPerilInfo.updateVisibleRowOnly(obj, index);
	}
	
	function rgComputePerilInv(wTaxRate){
		var vTotalPrm = 0;
		var vTotalCom = 0;
		var vTotalTax = 0;
		var vTotalNet = 0;
		
		/*var tgLength = tbgPerilInfo.geniisysRows.length;
		for(var i = 0; i < tgLength; i++){
			vTotalPrm = parseFloat(vTotalPrm) + parseFloat(tbgPerilInfo.geniisysRows[i].premiumAmt);
			vTotalCom = parseFloat(vTotalCom) + parseFloat(tbgPerilInfo.geniisysRows[i].commissionAmt);
			vTotalTax = parseFloat(vTotalTax) + parseFloat(tbgPerilInfo.geniisysRows[i].wholdingTax);
			vTotalNet = parseFloat(vTotalNet) + parseFloat(tbgPerilInfo.geniisysRows[i].netCommAmt);
			tbgPerilInfo.geniisysRows[i].totalPremiumAmt = vTotalPrm;
			tbgPerilInfo.geniisysRows[i].totalCommissionAmt = vTotalCom;
			tbgPerilInfo.geniisysRows[i].wholdingTax = vTotalTax;
			tbgPerilInfo.geniisysRows[i].netCommAmt = vTotalNet;
		}*/ // replaced with codes below : shan 02.17.2015
		
		var perils = objACGlobal.objGIACS408.allPerils;	// added to update all perils
		for(var i=0; i<perils.length; i++){
			if((perils[i].recordStatus != -1)){
				perils[i].wholdingTax = roundNumber(parseFloat(perils[i].commissionAmt) * parseFloat(wTaxRate),2);
				perils[i].netCommAmt = perils[i].commissionAmt - perils[i].wholdingTax;
				
				vTotalPrm = parseFloat(vTotalPrm) + parseFloat(perils[i].premiumAmt);
				vTotalCom = parseFloat(vTotalCom) + parseFloat(perils[i].commissionAmt);
				vTotalTax = parseFloat(vTotalTax) + parseFloat(perils[i].wholdingTax);
				vTotalNet = parseFloat(vTotalNet) + parseFloat(perils[i].netCommAmt);

				perils[i].recordStatus = 1;
				
				objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, perils[i]);
				objACGlobal.objGIACS408.allPerils.splice(i, 1, perils[i]);
			}
		}
		$("txtTotalPerilPremAmt").value = formatCurrency(vTotalPrm); 
		$("txtTotalPerilCommAmt").value = formatCurrency(vTotalCom); 
		$("txtTotalPerilWithTax").value = formatCurrency(vTotalTax); 
		$("txtTotalPerilNetCommAmt").value = formatCurrency(vTotalNet);
		
		$("txtCommissionAmt").value = formatCurrency(vTotalCom);
		$("txtWholdtingTax").value = formatCurrency(vTotalTax);
		$("txtNetCommAmt").value = formatCurrency(vTotalNet);
		
		objACGlobal.objGIACS408.updateInvCommByPeril();
	}
	
	function recomputeWtaxRate(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=recomputeWtaxRate", {
				method: "POST",
				parameters: {
					intmNo: $F("hidInvIntmNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var wTaxRate = response.responseText;
						for(var i = 0 ; i < tbgPerilInfo.geniisysRows.length; i++){
							tbgPerilInfo.geniisysRows[i].wholdingTax = roundNumber(parseFloat(tbgPerilInfo.geniisysRows[i].commissionAmt) * parseFloat(wTaxRate),2);
							tbgPerilInfo.geniisysRows[i].netCommAmt = tbgPerilInfo.geniisysRows[i].commissionAmt - tbgPerilInfo.geniisysRows[i].wholdingTax;			

							tbgPerilInfo.setValueAt(tbgPerilInfo.geniisysRows[i].wholdingTax, tbgPerilInfo.getColumnIndex('wholdingTax'), i);
							tbgPerilInfo.setValueAt(tbgPerilInfo.geniisysRows[i].netCommAmt, tbgPerilInfo.getColumnIndex('netCommAmt'), i);							
						}
						rgComputePerilInv(wTaxRate);
						populatePerilInfoDtls(null);
						changeTag = 1;
						changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
						objACGlobal.objGIACS408.piChangeTag = 1;
						//objACGlobal.objGIACS408.objPerilInfoArray = tbgPerilInfo.geniisysRows;
					}
				}
			});
		}catch(e){
			showErrorMessage("recomputeCommRate", e);
		}
	}
	
	function addChildCommInvPeril(objArray){
		try{
			var totalPerilPremAmt = 0;
			var totalPerilCommAmt = 0;
			var totalPerilWithTax = 0;
			var totalPerilNetCommAmt = 0;
			
			for(var i=0; i<objArray.length; i++){
				var premiumAmt = nvl(objArray[i].premiumAmt, 0);
				var commissionAmt = premiumAmt * (nvl(objArray[i].commissionRt, 0) / 100);
				var wholdingTax = commissionAmt * nvl($F("hidInvWtaxRate"),0);
				var netCommAmt = commissionAmt - wholdingTax;
				
				objArray[i].premiumAmt = roundNumber(premiumAmt, 2);
				objArray[i].commissionAmt = roundNumber(commissionAmt, 2);
				objArray[i].wholdingTax = roundNumber(wholdingTax, 2);
				objArray[i].netCommAmt = roundNumber(netCommAmt, 2);
				objArray[i].recordStatus = 0;
				objArray[i].issCd = $F("txtIssCd");
				objArray[i].premSeqNo = $F("txtPremSeqNo");
				objArray[i].tranNo = $F("hidInvTranNo");
				objArray[i].tranFlag = $F("hidInvTranFlag");
				objArray[i].intmNo = $F("hidInvIntmNo");
				objArray[i].commRecId = $F("hidInvCommRecId");
				objArray[i].deleteSw = $F("hidDeleteSw");
				objArray[i].commRecId = $F("hidVCommRecId");
				objArray[i].branchCd = objACGlobal.objGIACS408.branchCd;
				objArray[i].fundCd = objACGlobal.objGIACS408.fundCd;
				
				objACGlobal.objGIACS408.objPerilInfoArray.push(objArray[i]);
				
				totalPerilPremAmt = totalPerilPremAmt + parseFloat(premiumAmt);
				totalPerilCommAmt = totalPerilCommAmt + parseFloat(commissionAmt);
				totalPerilWithTax = totalPerilWithTax + parseFloat(wholdingTax);
				totalPerilNetCommAmt = totalPerilNetCommAmt + parseFloat(netCommAmt);
			}
			//invoice comm
			$("txtPremAmt").value = formatCurrency(totalPerilPremAmt);
			$("txtCommissionAmt").value = formatCurrency(totalPerilCommAmt);
			$("txtWholdtingTax").value = formatCurrency(totalPerilWithTax);
			$("txtNetCommAmt").value = formatCurrency(totalPerilNetCommAmt);
		}catch(e){
			showErrorMessage("addChildCommInvPeril ",e);
		}
	}
	objACGlobal.objGIACS408.addChildCommInvPeril = addChildCommInvPeril;
	
	function updateChildCommInvPeril(objArray){
		
		try{
			var totalPerilPremAmt = 0;
			var totalPerilCommAmt = 0;
			var totalPerilWithTax = 0;
			var totalPerilNetCommAmt = 0;
				
			for(var i=0; i<objPerilInfoArray.length; i++){
				for(var j=0; j<objArray.length; j++){
					if(objPerilInfoArray[i].perilCd == objArray[j].perilCd){
						var premiumAmt = nvl(objArray[j].premiumAmt, 0);
						var commissionAmt = premiumAmt * (nvl(objPerilInfoArray[i].commissionRt, 0) / 100);
						var wholdingTax = commissionAmt * nvl($F("hidInvWtaxRate"),0);
						var netCommAmt = commissionAmt - wholdingTax;
						
						objPerilInfoArray[i].premiumAmt = (premiumAmt);
						objPerilInfoArray[i].commissionAmt = (commissionAmt);
						objPerilInfoArray[i].wholdingTax = (wholdingTax);
						objPerilInfoArray[i].netCommAmt = (netCommAmt);
						objPerilInfoArray[i].recordStatus = 1;
						
						objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
						objACGlobal.objGIACS408.tempObjPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
						tbgPerilInfo.updateVisibleRowOnly(objPerilInfoArray[i], i);
						
						totalPerilPremAmt = totalPerilPremAmt + parseFloat(premiumAmt);
						totalPerilCommAmt = totalPerilCommAmt + parseFloat(commissionAmt);
						totalPerilWithTax = totalPerilWithTax + parseFloat(wholdingTax);
						totalPerilNetCommAmt = totalPerilNetCommAmt + parseFloat(netCommAmt);
					}
				}
			}
			//peril
			$("txtTotalPerilPremAmt").value = formatCurrency(totalPerilPremAmt);
			$("txtTotalPerilCommAmt").value = formatCurrency(totalPerilCommAmt);
			$("txtTotalPerilWithTax").value = formatCurrency(totalPerilWithTax);
			$("txtTotalPerilNetCommAmt").value = formatCurrency(totalPerilNetCommAmt);
			//invoice comm
			$("txtPremAmt").value = formatCurrency(totalPerilPremAmt);
			$("txtCommissionAmt").value = formatCurrency(totalPerilCommAmt);
			$("txtWholdtingTax").value = formatCurrency(totalPerilWithTax);
			$("txtNetCommAmt").value = formatCurrency(totalPerilNetCommAmt);
			//update master table
			objACGlobal.objGIACS408.updateInvCommByPeril();
		}catch(e){
			showErrorMessage("updateChildCommInvPeril", e);
		}
	}
	objACGlobal.objGIACS408.updateChildCommInvPeril = updateChildCommInvPeril;
	
	function deleteChildCommInvPeril(){
		try{
			for(var i=0; i<objPerilInfoArray.length; i++){
				if((objPerilInfoArray[i].recordStatus != -1) &&
				   (objPerilInfoArray[i].deleteSw != "Y")){

					objPerilInfoArray[i].deleteSw = "Y";
					objPerilInfoArray[i].recordStatus = -1;
					
					objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
					objACGlobal.objGIACS408.tempObjPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
					//tbgPerilInfo.updateVisibleRowOnly(objPerilInfoArray[i], tbgPerilInfo.getCurrentPosition()[1]);
					tbgPerilInfo.deleteVisibleRowOnly(tbgPerilInfo.getCurrentPosition()[1]);
				}
			}
		}catch(e){
			showErrorMessage("deleteChildCommInvPeril", e);
		}
	}
	objACGlobal.objGIACS408.deleteChildCommInvPeril = deleteChildCommInvPeril;
	
	function updatePostedPeril(){
		try{		
			for(var i=0; i<objPerilInfoArray.length; i++){
				objPerilInfoArray[i].tranFlag = 'P';
				
				objACGlobal.objGIACS408.objPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
				objACGlobal.objGIACS408.tempObjPerilInfoArray.splice(i, 1, objPerilInfoArray[i]);
				tbgPerilInfo.updateVisibleRowOnly(objPerilInfoArray[i], i);
			}
			
			var obj = tbgInvCommInfo.geniisysRows[0];
			tbgInvCommInfo.selectRow('0');
			populateInvCommInfoDtls(obj);
			objACGlobal.objGIACS408.executeQueryPerilInfo(obj.fundCd, obj.branchCd, obj.commRecId, obj.intmNo, obj.lineCd);
		}catch(e){
			showErrorMessage("updatePostedPeril", e);
		}
	}
	objACGlobal.objGIACS408.updatePostedPeril = updatePostedPeril;
	
	var perilObj = new Object();
	var perilArray = new Array();
	function recomputeCommRateGiacs408(){
		try{
			for(var i = 0; i<objPerilInfoArray.length; i++){
				perilArray.push(objPerilInfoArray[i]);
			}
			perilObj.perils = perilArray;
			
			var perilParameters = JSON.stringify(perilObj);
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=recomputeCommRateGiacs408", {
				method: "POST",
				parameters: {
					parameters : perilParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					
				}
			});
		}catch(e){
			showErrorMessage("recomputeCommRate", e);
		}
		/* try{
			var objParams = new Object();
			objParams.setReCommRt = objPerilInfoArray;
			objParams.lineCd = $F("hidLineCd");
			objParams.sublineCd = $F("hidSublineCd");
			objParams.b140IssCd = $F("txtIssCd");
			objParams.b140PremSeqNo = $F("txtPremSeqNo");
			objParams.b140PolicyId = $F("hidPolicyId");
			objParams.wTaxRate = $F("hidInvWtaxRate");
			
			var strObjParameters = JSON.stringify(objParams);
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=recomputeCommRateGiacs408", {
				method: "POST",
				parameters: {
					parameters : strObjParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText.include("RAE")){
						showMessageBox(response.responseText.substring(5), response.responseText.substring(4,5));
					}else{
						var res = JSON.parse(response.responseText);
						for(var i = 0;i < res.length; i++){
							updatePerilTG(res, i);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("recomputeCommRt ", e);
		} */
		//recomputeCommRateGiacs408();
	}

	$("txtPerilWholdingTax").observe("focus", function(){
		$("txtPerilWholdingTax").writeAttribute("lastValidValue", this.value);
	});

	$("txtPerilCommRate").observe("focus", function(){
		$("txtPerilCommRate").writeAttribute("lastValidValue", this.value);
	});
	
	$("txtPerilWholdingTax").observe("change", function(){
		var tempWholdingTax = parseFloat(this.value.replace(/,/g, ""));
		if(tempWholdingTax < 0.00 || $F("txtPerilWholdingTax").trim() == "" || tempWholdingTax > 9999999999.99){
			showWaitingMessageBox("Invalid Withholding Tax. Valid value should be from 0.00 to 9,999,999,999.99.", imgMessage.ERROR, 
					function (){
						$("txtPerilWholdingTax").value = formatCurrency(nvl($("txtPerilWholdingTax").readAttribute("lastValidValue"), 0));
						$("txtPerilWholdingTax").select();
						$("txtPerilWholdingTax").focus();
					});
		}
	});

	$("txtPerilWholdingTax").observe("keyup", function(e) {
		if(isNaN($F("txtPerilWholdingTax"))) {
			$("txtPerilWholdingTax").value = nvl($("txtPerilWholdingTax").readAttribute("lastValidValue"), "0.00");
		}
	});

	$("txtPerilCommRate").observe("keyup", function(e) {
		if(isNaN($F("txtPerilCommRate"))) {
			$("txtPerilCommRate").value = formatToNthDecimal(nvl($("txtPerilCommRate").readAttribute("lastValidValue"), 0), 7);
		}
	});	

	$("txtPerilCommRate").observe("change", function(){
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
	});

	$("txtPerilWholdingTax").observe("change", function(){
		changeTag = 1;
		changeTagFunc = objACGlobal.objGIACS408.saveInvoiceCommission;
	});	
</script>
