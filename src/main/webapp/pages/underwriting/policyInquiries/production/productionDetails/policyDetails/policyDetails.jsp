<div id="policyDetails" name="policyDetails" style="float: left; width: 100%;">
	<div id="policyDetailsExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="productionDetailsExit">Exit</a></li>
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
				<div id="prodPolicyDetailsTableGrid" style="height: 331px;width:900px;"></div>
			</div>	
			<div style="margin:5px 0 5px 374px">
				<table>
					<tr>
						<td>Totals</td>
						<td><input id="txtTSITotal" class="rightAligned" type="text" style="width:150px" readonly="readonly"/></td>
						<td><input id="txtPremiumTotal" class="rightAligned" type="text" style="width:148px" readonly="readonly"/></td>
						<td><input id="txtTaxTotal" class="rightAligned" type="text" style="width:148px" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
			<div style="margin: 0 0 0 10px">
				<div class="sectionDiv" align="center" style="width:899px;padding:5px 0 5px 0">
					<table>
						<tr>
							<td class="rightAligned">Commission</td>
							<td><input id="txtCommission" type="text" class="rightAligned" style="width:200px" readonly="readonly"/></td>
							<td style="width:220px" class="rightAligned">Commission Total</td>
							<td><input id="txtCommissionTotal" class="rightAligned" type="text" style="width:200px" readonly="readonly"/></td>
						</tr>
					</table>
				</div>
			</div>	
			<div align="center" style="height:90px">
				<input id="btnCommissionDetails" type="button" style="width:170px; margin: 10px 0 15px 0;" value="Commission Details">
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
				<input id="btnReturn" type="button" style="width:100px;margin: 10px 0 15px 0;" value="Return">
			</div>		
		</div>		
	</div>		
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIPIS201");
	setDocumentTitle("View Production Details");		
	var jsonProdPolicyDetails = JSON.parse('${jsonProdPolicyDetails}');
	prodPolicyDetailsTableModel = {
		url : contextPath
				+ "/GIPIPolbasicController?action=getProdPolicyDetails&refresh=1&lineCd1="+objGIPIS200.lineCd1+
																				"&sublineCd1="+objGIPIS200.sublineCd1+
																				"&issCd1="+objGIPIS200.issCd1+						
																				"&issueYy1="+objGIPIS200.issueYy1+
																				"&polSeqNo1="+objGIPIS200.polSeqNo1+
																				"&renewNo1="+objGIPIS200.renewNo1+
																				"&policyId="+objGIPIS200.policyId+
																				"&paramDate="+objGIPIS200.paramDate+
																				"&fromDate="+objGIPIS200.fromDate+
																				"&toDate="+objGIPIS200.toDate+
																				"&month="+objGIPIS200.month+
																				"&year="+objGIPIS200.year+
																				"&distFlag="+objGIPIS200.distFlag,
		options : {
			hideColumnChildTitle: true,
			width : '900px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					tbgProdPolicyDetails.keys.removeFocus(tbgProdPolicyDetails.keys._nCurrentFocus, true);
					tbgProdPolicyDetails.keys.releaseKeys();
					setObjProdPolicyDtls(null);
					setProdPolicyDetails(null);
					setButton(null);
				}
			},			
			onCellFocus : function(element, value, x, y, id) {						
				tbgProdPolicyDetails.keys.removeFocus(
						tbgProdPolicyDetails.keys._nCurrentFocus, true);
				tbgProdPolicyDetails.keys.releaseKeys();
				setObjProdPolicyDtls(tbgProdPolicyDetails.geniisysRows[y]);
				setProdPolicyDetails(tbgProdPolicyDetails.geniisysRows[y]);
				setButton(tbgProdPolicyDetails.geniisysRows[y]);
			},
			prePager : function() {
				tbgProdPolicyDetails.keys.removeFocus(tbgProdPolicyDetails.keys._nCurrentFocus, true);
				tbgProdPolicyDetails.keys.releaseKeys();
				setObjProdPolicyDtls(null);
				setProdPolicyDetails(null);
				setButton(null);
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgProdPolicyDetails.keys.removeFocus(
						tbgProdPolicyDetails.keys._nCurrentFocus, true);
				tbgProdPolicyDetails.keys.releaseKeys();
				setObjProdPolicyDtls(null);
				setProdPolicyDetails(null);
				setButton(null);
			},
			onSort : function() {
				tbgProdPolicyDetails.keys.removeFocus(tbgProdPolicyDetails.keys._nCurrentFocus, true);
				tbgProdPolicyDetails.keys.releaseKeys();
				setObjProdPolicyDtls(null);
				setProdPolicyDetails(null);
				setButton(null);
			},onRefresh : function() {				
				tbgProdPolicyDetails.keys.removeFocus(tbgProdPolicyDetails.keys._nCurrentFocus, true);
				tbgProdPolicyDetails.keys.releaseKeys();
				setObjProdPolicyDtls(null);
				setProdPolicyDetails(null);
				setButton(null);
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
			width : '250px',
			titleAlign : 'left',
			align : 'left',
		}, {
			id : "endorsementNo",
			title : 'Endorsement No.',
			width : '150px',
			titleAlign : 'left',
			align : 'left',
		}, {
			id : "tsiAmt",
			title: "TSI",
			width : '155px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatCurrency(value);
			}
		}, {
			id : "premAmt",
			title: "Premium",
			width : '155px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatCurrency(value);
			}
		}, {
			id : "taxAmt",
			title: "Tax",
			width : '155px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true,
			filterOptionType : 'number',
			renderer : function(value){
				return formatCurrency(value);
			}
		},{
			id : "lineCd2",
			title : "Line Code",
			width : '0px',
			filterOption : false,
			visible : false
		}, {
			id : "sublineCd2",
			title : "Subline Code",
			width : '0px',
			filterOption : false,
			visible : false
		}, {
			id : "issCd2",
			title : "Issue Code",
			width : '0px',
			filterOption : false,
			visible : false
		}, {
			id : "issueYy2",
			title : "Issue Year",
			width : '0px',
			filterOption : false,
			visible : false,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "polSeqNo",
			title : "Policy Sequence No.",
			width : '0px',
			filterOption : false,
			visible : false,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "renewNo",
			title : "Renew No.",
			width : '0px',
			filterOption : false,
			visible : false,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "endtIssCd",
			title : 'Endt Iss Cd',
			width : '0px',
			filterOption : false,
			visible : false
		}, {
			id : "endtYy",
			title : 'Endt. Year',
			width : '0px',
			filterOption : true,
			visible : false,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "endtSeqNo",
			title : 'Endt. Seq. No.',
			width : '0px',
			filterOption : true,
			visible : false,
			filterOptionType : 'integerNoNegative'
		}],
		rows : jsonProdPolicyDetails.rows
	};

	tbgProdPolicyDetails = new MyTableGrid(prodPolicyDetailsTableModel);
	tbgProdPolicyDetails.pager = jsonProdPolicyDetails;
	tbgProdPolicyDetails.render('prodPolicyDetailsTableGrid');	
	tbgProdPolicyDetails.afterRender = function(){
		$("txtTSITotal").value = formatCurrency(tbgProdPolicyDetails.geniisysRows[0].tsiTotal);
		$("txtPremiumTotal").value = formatCurrency(tbgProdPolicyDetails.geniisysRows[0].premTotal);
		$("txtTaxTotal").value = formatCurrency(tbgProdPolicyDetails.geniisysRows[0].taxTotal);
		$("txtCommissionTotal").value = formatCurrency(tbgProdPolicyDetails.geniisysRows[0].commTotal);
	};
	
	function setButton(obj) {	
		if(obj!=null){
			enableButton("btnCommissionDetails");			
		}else{
			disableButton("btnCommissionDetails");			
		}		
		enableButton("btnReturn");
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
	
	function setObjProdPolicyDtls(obj){
		try {				
			objProdPolicyDtls.policyId = obj == null ? "" : (obj.policyId==null?"":obj.policyId);	
			objProdPolicyDtls.issCd = obj == null ? "" : (obj.issCd==null?"":obj.issCd);		
			objProdPolicyDtls.lineCd = obj == null ? "" : (obj.lineCd==null?"":obj.lineCd);		
		} catch (e) {
			showErrorMessage("setObjProdPolicyDtls", e);
		}
	}	
	
	function setProdPolicyDetails(obj) {	
		try {		
			$("txtCommission").value = obj == null ? "" : (obj.commission == null ?"":formatCurrency(obj.commission));
			$("txtAssured").value = obj == null ? "" : (obj.assured == null ?"":unescapeHTML2(obj.assured));
			$("txtInceptionDate").value = obj == null ? "" : (obj.inceptDate == null ?"":obj.inceptDate);
			$("txtExpiryDate").value = obj == null ? "" : (obj.expiryDate == null ?"":obj.expiryDate);
			$("txtIssueDate").value = obj == null ? "" : (obj.issueDate == null ?"":obj.issueDate);
		} catch (e) {
			showErrorMessage("setProdPolicyDetails", e);
		}
	}
	
	function validateGIPIS201DisplayORC(){
		try{	
		 	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
				method : "POST",
				parameters : {
					action : "validateGIPIS201DisplayORC"
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (res.result == "N"){		
						$("btnCommissionDetails").hide();
					}				
				}
			}); 	
		}catch(e){
			showErrorMessage("validateGIPIS201DisplayORC", e);
		}
	}
	
	function getGIPIS201CommDtls() {
		try {
			overlayCommissionDetails = Overlay.show(contextPath
					+ "/GIPIPolbasicController", {
				urlContent : true,
				urlParameters : {
					action : "getGIPIS201CommDtls",
					policyId : objProdPolicyDtls.policyId,
					issCd : objProdPolicyDtls.issCd,
				    lineCd: objProdPolicyDtls.lineCd,
				    intmNo : objGIPIS200.intmNo
				},
				title : "Commission Details",
				height : 375,
				width : 725,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function initializeGIPIS201(){
		objProdPolicyDtls = new Object;	
		setFieldsValue();
		setButton(null);
		validateGIPIS201DisplayORC();
	}
	$("btnCommissionDetails").observe("click", function() {
		getGIPIS201CommDtls();
	});
	
	$("btnReturn").observe("click", function() {
		showProductionDetails(objGIPIS200.lineCd,objGIPIS200.sublineCd,objGIPIS200.issCd,objGIPIS200.issueYy,objGIPIS200.intmNo,objGIPIS200.credIss,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag,objGIPIS200.regPolicySw);		
	});

	observeReloadForm("reloadForm", function(){
		showProdPolicyDetails(objGIPIS200.lineCd1,objGIPIS200.sublineCd1,objGIPIS200.issCd1,objGIPIS200.issueYy1,objGIPIS200.polSeqNo1,objGIPIS200.renewNo1,objGIPIS200.policyId,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag);
	});
	
	$("productionDetailsExit").observe("click", function() {
		showProductionDetails(objGIPIS200.lineCd,objGIPIS200.sublineCd,objGIPIS200.issCd,objGIPIS200.issueYy,objGIPIS200.intmNo,objGIPIS200.credIss,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag,objGIPIS200.regPolicySw);	
	});
	
	initializeGIPIS201();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>