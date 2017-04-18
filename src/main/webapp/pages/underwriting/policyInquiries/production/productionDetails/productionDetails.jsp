<div id="productionDetails" name="productionDetails" style="float: left; width: 100%;">
	<div id="productionDetailsExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="productionExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Production Details</label>
			<span class="refreshers" style="margin-top: 0;">				
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">		
		<div class="sectionDiv">	
			<div align="center" style="margin: 6px 0 6px 0;padding: 0">
				<table>
					<tr>
						<td class="rightAligned">Line</td>
						<td><input id="txtLineCd" type="text" style="width: 70px" readonly="readonly" maxlength="30"/></td>
						<td><input id="txtLineName" type="text" style="width: 230px" readonly="readonly" maxlength="30"/></td>
						<td class="rightAligned" style="width: 140px" id="lblCredIss">Issue Code</td>
						<td><input id="txtIssCd" type="text" style="width: 70px" readonly="readonly" maxlength="30"/></td>
						<td><input id="txtIssName" type="text" style="width: 230px" readonly="readonly" maxlength="30"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td><input id="txtSublineCd" type="text" style="width: 70px" readonly="readonly" maxlength="30"/></td>
						<td><input id="txtSublineName" type="text" style="width: 230px" readonly="readonly" maxlength="30"/></td>
						<td class="rightAligned" style="width: 140px">Issue Year</td>
						<td><input id="txtIssueYy" type="text" style="width: 70px" readonly="readonly" maxlength="30"/></td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td class="rightAligned" style="width: 140px">Intermediary</td>
						<td><input id="txtIntmNo" type="text" style="width: 70px" readonly="readonly" maxlength="12"/></td>
						<td><input id="txtIntmName" type="text" style="width: 230px" readonly="readonly" maxlength="240"/></td>
					</tr>
				</table>
			</div>			
		</div>
		<div class="sectionDiv" style="margin-bottom: 70px">
			<div style="padding:10px 10px 0 10px;">
				<div id="productionDetailsTableGrid" style="height: 331px;width:900px;"></div>
			</div>	
			<div style="margin:5px 0 5px 382px">
				<table>
					<tr>
						<td>Totals</td>
						<td><input id="txtTSITotal" class="rightAligned" type="text" style="width:225px" readonly="readonly"/></td>
						<td><input id="txtPremiumTotal" class="rightAligned" type="text" style="width:225px" readonly="readonly"/></td>
					</tr>
				</table>
			</div>		
			<div style="margin: 0 0 0 10px">
				<div class="sectionDiv" align="center" style="width:899px;padding:5px 0 5px 0">
					<table>
						<tr>
							<td class="rightAligned" class="rightAligned">Assured</td>
							<td colspan="5"><input id="txtAssured" type="text" style="width:722px" readonly="readonly" maxlength="500"/></td>						
						</tr>
						<tr>
							<td class="rightAligned">Inception Date</td>
							<td><input id="txtInceptionDate" type="text" style="width:150px" readonly="readonly" maxlength="11"/></td>
							<td style="width:120px" class="rightAligned">Expiry Date</td>
							<td><input id="txtExpiryDate" type="text" style="width:150px" readonly="readonly" maxlength="11"/></td>
							<td style="width:120px" class="rightAligned">Issue Date</td>
							<td><input id="txtIssueDate" type="text" style="width:150px" readonly="readonly" maxlength="11"/></td>
						</tr>
					</table>
				</div>
			</div>	
			<div align="center">
				<input id="btnPolicyDetails" type="button" style="width:120px;margin: 10px 0 15px 0;" value="Policy Details">
			</div>		
		</div>		
	</div>		
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	initializeAll();
	initializeAccordion();
	setModuleId("GIPIS202");
	setDocumentTitle("View Production Details");	
	var jsonProductionDetails = JSON.parse('${jsonProductionDetails}');
	productionDetailsTableModel = {
		url : contextPath
				+ "/GIPIPolbasicController?action=getProductionDetails&refresh=1&lineCd="+objGIPIS200.lineCd+
																				"&sublineCd="+objGIPIS200.sublineCd+
																				"&issCd="+objGIPIS200.issCd+						
																				"&issueYy="+objGIPIS200.issueYy+
																				"&intmNo="+objGIPIS200.intmNo+
																				"&credIss="+objGIPIS200.credIss+
																				"&paramDate="+objGIPIS200.paramDate+
																				"&fromDate="+objGIPIS200.fromDate+
																				"&toDate="+objGIPIS200.toDate+
																				"&month="+objGIPIS200.month+
																				"&year="+objGIPIS200.year+
																				"&distFlag="+objGIPIS200.distFlag+
																				"&regPolicySw="+objGIPIS200.regPolicySw,
				options : {
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function() {
							tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
							tbgProductionDetails.keys.releaseKeys();
							setObjProdDetails(null);
							setProductionDetails(null);
							setButton(null);							
						}
					},
					width : '900px',
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
						tbgProductionDetails.keys.releaseKeys();
						setObjProdDetails(tbgProductionDetails.geniisysRows[y]);
						setProductionDetails(tbgProductionDetails.geniisysRows[y]);
						setButton(tbgProductionDetails.geniisysRows[y]);
					},
					prePager : function() {
						tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
						tbgProductionDetails.keys.releaseKeys();
						setObjProdDetails(null);
						setProductionDetails(null);
						setButton(null);
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
						tbgProductionDetails.keys.releaseKeys();
						setProductionDetails(null);
						setButton(null);
					},					
					onSort : function() {
						tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
						tbgProductionDetails.keys.releaseKeys();
						setObjProdDetails(null);
						setProductionDetails(null);
						setButton(null);
					},onRefresh : function() {				
						tbgProductionDetails.keys.removeFocus(tbgProductionDetails.keys._nCurrentFocus, true);
						tbgProductionDetails.keys.releaseKeys();
						setObjProdDetails(null);
						setProductionDetails(null);
						setButton(null);
					},onRowDoubleClick: function(){
						//if(checkUserModule("GIPIS201")){
							viewPolicyDetails();
						//}
					}
				},
				columnModel : [ {
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				}, {
					id : 'divCtrId',
					width : '0',
					visible : false
				}, {
					id : "policyNo",
					title : "Policy No.",
					width : '400px',
					titleAlign : 'left',
					align : 'left',
				}, {
					id : "tsiAmt",
					title : "TSI",
					width : '225px',
					titleAlign : 'right',
					align : 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				}, {
					id : "premAmt",
					title : "Premium",
					width : '225px',					
					titleAlign : 'right',
					align : 'right'		,
					renderer : function(value){
						return formatCurrency(value);
					}
				}, {
					id : "lineCd1",
					title : "Line Code",
					width : '0px',
					filterOption : true,
					visible : false
				}, {
					id : "sublineCd1",
					title : "Subline Code",
					width : '0px',
					filterOption : true,
					visible : false
				}, {
					id : "issCd1",
					title : "Issue Code",
					width : '0px',
					filterOption : true,
					visible : false
				}, {
					id : "issueYy1",
					title : "Issue Year",
					width : '0px',
					filterOption : true,
					visible : false,
					filterOptionType : 'integerNoNegative'
				}, {
					id : "polSeqNo",
					title : "Policy Sequence No.",
					width : '0px',
					filterOption : true,
					visible : false,
					filterOptionType : 'integerNoNegative'
				}, {
					id : "renewNo",
					title : "Renew No.",
					width : '0px',
					filterOption : true,
					visible : false,
					filterOptionType : 'integerNoNegative'
				}, {
					id : "endtIssCd",
					title : 'Endt Iss Cd',
					width : '0px',
					filterOption : true,
					visible : false
				}, {
					id : "endtYy",
					title : 'Endorsement Yr.',
					width : '0px',
					filterOption : true,
					visible : false,
					filterOptionType : 'integerNoNegative'
				}, {
					id : "endtSeqNo",
					title : 'Endorsement Seq No',
					width : '0px',
					filterOption : true,
					visible : false,
					filterOptionType : 'integerNoNegative'
				}],
		rows : jsonProductionDetails.rows
	};

	tbgProductionDetails = new MyTableGrid(productionDetailsTableModel);
	tbgProductionDetails.pager = jsonProductionDetails;
	tbgProductionDetails.render('productionDetailsTableGrid');	
	tbgProductionDetails.afterRender = function(){
		$("txtTSITotal").value = formatCurrency(tbgProductionDetails.geniisysRows[0].tsiTotal);
		$("txtPremiumTotal").value = formatCurrency(tbgProductionDetails.geniisysRows[0].premTotal);
	};	
	
	function validateGIPIS201Access(){
		try{	
			var hasAccess = true;
		 	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
				method : "POST",
				parameters : {
					action : "validateGIPIS201Access",		
					lineCd : objProdDetails.lineCd,
					issCd : objProdDetails.issCd
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (parseInt(res.result) == 0){		
						hasAccess = false;
						showMessageBox("User has no access to the module.", imgMessage.INFO);		
					}				
				}
			}); 	
		 	return hasAccess;
		}catch(e){
			showErrorMessage("validateGIPIS201Access", e);
		}
	}
	
	function setProductionDetails(obj) {	
		try {		
			$("txtAssured").value = obj == null ? "" : (obj.assured == null ?"":unescapeHTML2(obj.assured));
			$("txtInceptionDate").value = obj == null ? "" : (obj.inceptDate == null ?"":obj.inceptDate);
			$("txtExpiryDate").value = obj == null ? "" : (obj.expiryDate == null ?"":obj.expiryDate);
			$("txtIssueDate").value = obj == null ? "" : (obj.issueDate == null ?"":obj.issueDate);
		} catch (e) {
			showErrorMessage("setProductionDetails", e);
		}
	}
	
	function setButton(obj) {	
		if(obj!=null){
			enableButton("btnPolicyDetails");
		}else{
			disableButton("btnPolicyDetails");	
		}
	}
	
	function setFieldsValue() {	
		$("txtLineCd").value=objGIPIS200.lineCd;
		$("txtLineName").value=objGIPIS200.lineName;
		$("txtIssCd").value=objGIPIS200.issCd;
		$("txtIssName").value=objGIPIS200.issName;
		$("txtSublineCd").value=objGIPIS200.sublineCd;
		$("txtSublineName").value=objGIPIS200.sublineName;
		$("txtIssueYy").value=objGIPIS200.issueYy;
		$("txtIntmNo").value=objGIPIS200.intmNo;
		$("txtIntmName").value=objGIPIS200.intmName;
		$("lblCredIss").innerHTML = objGIPIS200.cred;	
	}	
	function setObjProdDetails(obj){
		try {	
			objProdDetails.tsiAmt = obj == null ? "" : (obj.tsiAmt==null?"":obj.tsiAmt);
			objProdDetails.premAmt = obj == null ? "" : (obj.premAmt==null?"":obj.premAmt);	
			objProdDetails.policyId = obj == null ? "" : (obj.policyId==null?"":unescapeHTML2(obj.policyId));
			objProdDetails.lineCd = obj == null ? "" : (obj.lineCd==null?"":unescapeHTML2(obj.lineCd));
			objProdDetails.sublineCd = obj == null ? "" : (obj.sublineCd==null?"":unescapeHTML2(obj.sublineCd));
			objProdDetails.issCd = obj == null ? "" : (obj.issCd==null?"":unescapeHTML2(obj.issCd));
			objProdDetails.issueYy = obj == null ? "" : (obj.issueYy==null?"":unescapeHTML2(obj.issueYy));
			objProdDetails.polSeqNo = obj == null ? "" : (obj.polSeqNo==null?"":unescapeHTML2(obj.polSeqNo));
			objProdDetails.renewNo = obj == null ? "" : (obj.renewNo==null?"":unescapeHTML2(obj.renewNo));
		} catch (e) {
			showErrorMessage("setObjProdDetails", e);
		}
	}
	
	function viewPolicyDetails(){
		objGIPIS200.tsiAmt = objProdDetails.tsiAmt;	
		objGIPIS200.premAmt = objProdDetails.premAmt;	
		objGIPIS200.policyId = objProdDetails.policyId;	
		objGIPIS200.lineCd1 = objProdDetails.lineCd;	
		objGIPIS200.sublineCd1 = objProdDetails.sublineCd;	
		objGIPIS200.issCd1 = objProdDetails.issCd;
		objGIPIS200.issueYy1 = objProdDetails.issueYy;
		objGIPIS200.polSeqNo1 = objProdDetails.polSeqNo;
		objGIPIS200.renewNo1 = objProdDetails.renewNo;	
		if(validateGIPIS201Access()){
			showProdPolicyDetails(objGIPIS200.lineCd1,objGIPIS200.sublineCd1,objGIPIS200.issCd1,objGIPIS200.issueYy1,objGIPIS200.polSeqNo1,objGIPIS200.renewNo1,objGIPIS200.policyId,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag);
		}	
	}
	function initializeGIPIS202(){
		objProdDetails = new Object;		
		setButton(null);
		setFieldsValue();
	}
		
	$("btnPolicyDetails").observe("click", function() {
		viewPolicyDetails();		
	});
	
	observeReloadForm("reloadForm", function(){
		showProductionDetails(objGIPIS200.lineCd,objGIPIS200.sublineCd,objGIPIS200.issCd,objGIPIS200.issueYy,objGIPIS200.intmNo,objGIPIS200.credIss,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag,objGIPIS200.regPolicySw);
	});
	
	$("productionExit").observe("click", function() {
		showViewProduction();		
	});
	
	initializeGIPIS202();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>