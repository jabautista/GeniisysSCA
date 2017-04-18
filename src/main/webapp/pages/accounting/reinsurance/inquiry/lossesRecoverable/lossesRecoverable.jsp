<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="riLossRecovMainDiv" name="riLossRecovMainDiv" style="height: 475px;">
	<div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQueryDisabled">Enter Query</span>
		</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQueryDisabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View RI Loss Recoveries</label>
	   	</div>
	</div>	
	<div id="form" class="sectionDiv">
		<table style="margin: 10px auto;" cellspacing="0">
			<tr>		
				<td class="rightAligned">Line</td>
				<td class="leftAligned" style="width: 350px">
					<span class="lovSpan" style="border: none; width: 45px; height: 21px; margin: 0 0 0 0; float: left;">
						<input type="text" id="txtLineCd" name="txtLineCd" maxlength="2" style="width: 35px; float: left; height: 15px;" tabindex="101" class="allCaps"/>
					</span>
					<span class="lovSpan" style="width: 268px; height: 21px; margin: 2px 2px 0 2px; float: left;">
						<input type="text" id="txtLineName" name="txtLineName" style="width: 231px; float: left; border: none; height: 13px;" readonly="readonly" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLine" name="imgSearchLine" alt="Go" style="float: right;" />
					</span>
				</td>
				<td class="rightAligned">Reinsurer</td>
				<td class="leftAligned" style="width: 450px">
					<span class="lovSpan" style="border: none; width: 45px; height: 21px; margin: 0 0 0 0; float: left;">
						<input type="text" id="txtRiCd" name="txtRiCd" maxlength="5" style="width: 35px; float: left; height: 15px;" tabindex="102" class="integerUnformatted" />
					</span>
					<span class="lovSpan" style="width: 380px; height: 21px; margin: 2px 2px 0 2px; float: left;">
						<input type="text" id="txtRiName" name="txtRiName" style="width: 300px; float: left; border: none; height: 13px;" readonly="readonly"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRi" name="imgSearchRi" alt="Go" style="float: right;" />
					</span>
				</td>
			</tr>
		</table>		
	</div>	
	<div class="sectionDiv" style="padding-bottom: 20px;">
		<div id="riLossesRecoveriesTableDiv" style="padding-top: 15px; padding-left: 15px; float: left;">
			<div id="riLossesRecoveriesTable" style="height: 250px;"></div>
		</div>	
		<div style="float: right; padding-top: 15px; padding-right: 10px;" >
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table class="sectionDiv" cellspacing="0" style="width: 145px; height: 130px;" >
							<tr><td>&nbsp;</td></tr>	
							<tr>
								<td width="20">
									<input type="checkbox" id="chkWithClmPay" name="chkWithClmPay" tabindex="201">
								</td>
								<td align="left" width="60px">
									<label>With Claim Payments Only</label>
								</td>
							</tr>	
							<tr height="25px">
								<td align="center"><input type="radio" id="all" name="status" checked="checked" value="" tabindex="202"></td>
								<td align="left" width="40px">All FLAs</td>
							</tr>
							<tr height="25px" width="50px">
								<td align="center"><input type="radio" id="paid" name="status" value="paid" tabindex="203"></td>
								<td align="left" width="40px">Paid</td>
							</tr>
							<tr height="25px" width="50px">
								<td align="center"><input type="radio" id="unpaid" name="status" value="unpaid" tabindex="204"></td>
								<td align="left" width="40px">Unpaid</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>	
				<tr></tr>
				<tr>
					<td height="50px">
						<input type="button" class="button" id="btnRiLossRecoveries" name="btnRiLossRecoveries" value="RI Loss Recoveries" style="width: 150px;"/>
					</td> 
				</tr>	
			</table>
		</div>						
		<div class="" style="float: left; clear: both; margin-left: 500px; height: 30px; margin-bottom:  0px; margin-top: 0px;">
			<table>
				<tr>
					<td class="rightAligned">Total</td>
					<td class="rightAligned" colspan="1" style="width: 215px;"><b><input type="text" id="txtTotal" name="txtTotal" style="text-align:right; width: 182px;" readonly="readonly" /><b></td>	
				</tr> 
			</table>
		</div>
		<div class="sectionDiv" style="clear: both; margin-left: 15px; width: 890px;height: 60px; margin-bottom: 0px; margin-right: 15px; margin-top: 15px;">
			<table style="margin-left: 20px">
				<tr>
					<td class="rightAligned" width="90px" height="60px">Policy Number</td>
					<td class="leftAligned" height="60px"><input type="text" id="txtPolicyNumber" name="txtPolicyNumber" style="width: 200px;" readonly="readonly"/></td>
					<td class="rightAligned" style="width: 130px;" height="60px">Assured Name</td>
					<td class="rightAligned" height="60px"><input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 375px" readonly="readonly"/></td>
				</tr>
			</table>
		</div >	
	</div>	
		
	<input type="hidden" id="hidWithPay" name="hidWithPay"/> 
	<input type="hidden" id="hidStatus" name="hidStatus"/>
	<input type="hidden" id="hidStatusName" name="hidStatusName"/>
	<input type="hidden" id="hidLineCd" name="hidLineCd"/>
	<input type="hidden" id="hidRiCd" name="hidRiCd"/> 
	<input type="hidden" id="hidLineCd2" name="hidLineCd2"/> 
	<input type="hidden" id="hidLaYy" name="hidLaYy"/> 
	<input type="hidden" id="hidFlaSeqNo" name="hidFlaSeqNo"/> 
	<input type="hidden" id="hidMainPageAmt" name="hidMainPageAmt"/>
	
</div>

<script type="text/javascript">
	
	setModuleId("GIACS278");
	setDocumentTitle("RI Loss Recoveries");
	exec = false;
	initializeAll();
	var selectedObjRow = null;
	objPrintOr = new Object();
	$("txtLineCd").focus();
	
	var jsonriLossesRecoveries = JSON.parse('${jsonriLossesRecoveries}');
	riLossesRecoveriesTableModel = {
		url : contextPath + "/GIACReinsuranceInquiryController?action=viewRiLossRecoveries&refresh=1",
		 options : {
			 toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					setDetailsForm(null);
					tbgAccRiLossRecov.keys.removeFocus(tbgAccRiLossRecov.keys._nCurrentFocus, true);
					tbgAccRiLossRecov.keys.releaseKeys();
					//disableFormButton();
					enableToolbarButton("btnToolbarEnterQuery");
				}
			},   
			height : '250px',
			width : '735px',
			pager : {},
			
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgAccRiLossRecov.geniisysRows[y]);
				prepareParams(tbgAccRiLossRecov.geniisysRows[y]);
				tbgAccRiLossRecov.keys.removeFocus(tbgAccRiLossRecov.keys._nCurrentFocus, true);
				tbgAccRiLossRecov.keys.releaseKeys(); 
				/*if($("hidStatus").value == 'paid'){
					enableButton("btnRiLossRecoveries");
				}else{
					disableButton("btnRiLossRecoveries");
				}*/
			},
		
		   prePager : function() {
				getTotal();
				setDetailsForm(null);
				tbgAccRiLossRecov.keys.removeFocus(tbgAccRiLossRecov.keys._nCurrentFocus, true);
				tbgAccRiLossRecov.keys.releaseKeys(); 
		    },
		
			onRemoveRowFocus : function(element, value, x, y, id) {
				setDetailsForm(null);
				disableButton("btnRiLossRecoveries");
				prepareParams(null);
			},
		
		
			afterRender : function() {
				getTotal();
				setDetailsForm(null);
				tbgAccRiLossRecov.keys.removeFocus(tbgAccRiLossRecov.keys._nCurrentFocus, true);
				tbgAccRiLossRecov.keys.releaseKeys(); 
			}, 
			
			onSort : function() {
				setDetailsForm(null);
				tbgAccRiLossRecov.keys.removeFocus(tbgAccRiLossRecov.keys._nCurrentFocus, true);
				enableToolbarButton("btnToolbarEnterQuery");
				tbgAccRiLossRecov.keys.releaseKeys();
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
		},{
			id : 'claimId',
			title : '',
			width : '0',
			visible : false
		}, {
			id : "flaNumber",
			title : "FLA Number",
			width : '200px',
			titleAlign : 'left',
			align : 'left',
			filterOption : true
		},  {
			id : "claimNumber",
			title : "Claim Number",
			width : '200px',
			align : 'left',
			titleAlign : 'left',
			filterOption : true
		},  {
			id : "payeeType",
			title : "Payee Type",
			width : '97px',
			titleAlign : 'center',
			align : 'left',
			filterOption : true
		}, {
			id : "expShrAmt",
			title : "FLA Amount",
			width : '160px',
			titleAlign : 'right',
			align : 'right',
			geniisysClass: 'money',
			filterOption : true
		}, {
			id : "printSw",
			title : "P",
			altTitle: "Print SW",
			width : '58px',
			titleAlign : 'center',
			//align : 'left',
			filterOption : true,
			filterOptionType : 'checkbox'
		}
		],
		rows: []
	}; 
	
	 tbgAccRiLossRecov = new MyTableGrid(riLossesRecoveriesTableModel);
	 tbgAccRiLossRecov.render('riLossesRecoveriesTable');  
	
	 function setDetailsForm(rec) {
		try {
			$("txtPolicyNumber").value = rec == null ? "" : rec.policyNumber;
			$("txtAssuredName").value = rec == null ? "" : unescapeHTML2(rec.assuredName);
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	 };
	 
	  function getTotal() {
			try {
				var rec = tbgAccRiLossRecov.geniisysRows[0];
				$("txtTotal").value = rec == null ? "" : formatCurrency(rec.total);
			} catch (e) {
				showErrorMessage("getTotal", e);
			}
		 }; 
		 
	  function prepareParams(rec) {
			try {
				$("hidLineCd2").value = rec == null ? "" : rec.lineCd;
				$("hidLaYy").value = rec == null ? "" :    rec.laYy;
				$("hidFlaSeqNo").value = rec == null ? "" :  rec.flaSeqNo;
				$("hidMainPageAmt").value = rec == null ? "" :  rec.expShrAmt;
				
				new Ajax.Request(contextPath + "/GIACReinsuranceInquiryController?action=showRiLossOverlay&refresh=1", {
					method: "POST",
					parameters: {
						lineCd2:		$F("hidLineCd2"),
						laYy:			$F("hidLaYy"),
						flaSeqNo:		$F("hidFlaSeqNo") ,
						mainPageAmt:	 $F("hidMainPageAmt")
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var res = JSON.parse(response.responseText);
							
							if (res.rows.length == 0){
								disableButton("btnRiLossRecoveries");
							}else{
								enableButton("btnRiLossRecoveries");
							}
						}
					}
				});
			} catch (e) {
				showErrorMessage("setDetailsForm", e);
			}
		 };
		 
	  function showRiLossOverlay() {
				try{
					overlayPremiumInfo = Overlay.show(contextPath+"/GIACReinsuranceInquiryController?action=showRiLossOverlay"
							+ "&lineCd2=" + $F("hidLineCd2") + "&laYy=" + $F("hidLaYy") + "&flaSeqNo=" + $F("hidFlaSeqNo") 
							+ "&mainPageAmt="   +  $F("hidMainPageAmt"), 
							{urlContent: true,
							 title: "RI Loss Recoveries",
							 height: 320,
							 width: 605,
							 draggable: false
							});
				}catch (e) {
					showErrorMessage("showRiLossOverlay",e);
				}
		};
		
		$("btnRiLossRecoveries").observe("click", function(){
			try{
				showRiLossOverlay();	
			}catch(e){
				showErrorMessage("btnRiLossRecoveries",e);
			}
		});
		
 	function disableFormButton(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
	};
	
	$$("input[name='status']").each(function(btn) {
		btn.observe("click", function() {
			$("hidStatus").value = $F(btn); 
			$("hidStatusName").value = $F(btn);
			if ($("txtLineCd").value != "" && $("txtRiCd").value != "" && exec == true) {
				execute();
			}
		});
	});

	function execute() {
		tbgAccRiLossRecov.url = contextPath + "/GIACReinsuranceInquiryController?action=viewRiLossRecoveries&refresh=1&lineCd="
	    		+ $F("hidLineCd") + "&riCd=" + $F("hidRiCd") + "&paidFlag=" + $F("hidStatus")  + "&withClmPay=" + $F("hidWithPay");
		tbgAccRiLossRecov._refreshList();
		if (tbgAccRiLossRecov.geniisysRows.length == 0) {
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtLineCd");
			return false;
		}
		getTotal();
		exec = true;
		$("txtRiCd").readOnly = true;
		$("txtLineCd").readOnly = true;
	}; 
	
 	function resetGlobal(){
		objACGlobal.gaccTranId = null;
		objACGlobal.branchCd = null;
		objACGlobal.fundCd = null;
		objAC.fromMenu = null;
		objAC.showOrDetailsTag = null;
		objAC.butLabel = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}
 	
 	function resetForm(){
 		$$("input[type='text']").each(
				function(a) {
					$(a).value = "";
		});
 		$("txtRiCd").readOnly = false;
		$("txtLineCd").readOnly = false;
		$("all").checked = true;
		exec = false;
		$("txtLineCd").focus();
		disableButton("btnRiLossRecoveries");
 		enableSearch("imgSearchLine");
		enableSearch("imgSearchRi");
 	}

	$$("input[type='text']").each(function(a) {
		a.observe("change", function() {
			if($(a).value != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	}); 
	
	$("chkWithClmPay").observe("change", function(){
		if($("chkWithClmPay").checked == true){
			$("hidWithPay").value = "checked";
		} else {
			$("hidWithPay").value = '';
		}
		if ($("txtLineCd").value != null && $("txtRiCd").value != "" && exec == true) {
			execute();
		}
	}); 
	 
 	$("btnToolbarEnterQuery").observe("click", function() {
		tbgAccRiLossRecov.url = contextPath + "/GIACReinsuranceInquiryController?action=viewRiLossRecoveries&refresh=1";
		tbgAccRiLossRecov._refreshList();
		disableFormButton();
		resetForm();
	});  
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("imgSearchLine");
		disableSearch("imgSearchRi");
		execute();
	});   

	$("btnToolbarExit").observe("click", function() {
		resetGlobal();
	});

	$("imgSearchLine").observe("click", function() {
		showGiisLineLOV();
	});
	
	$("imgSearchRi").observe("click", function() {
		showReinsurerNamesLOV();
	});
	
	$("txtLineCd").observe("change", function() {
		$("txtLineName").value = "";
		if($("txtLineCd").value != "") {
			showGiisLineLOV();
		}
	}); 
	
	$("txtRiCd").observe("change", function() {
		$("txtRiName").value = "";
		if($("txtRiCd").value != "") {
			showReinsurerNamesLOV();
		}
	}); 
	
	function showGiisLineLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getLineList",
					page :	1 ,
					lineCd : $("txtLineCd").value,
				},
				title: "Line",
				width: 425,
				height: 386,
				columnModel:[
				             	{	id : "lineCd",
									title: "Line Code",
									width: '80px'
								},
								{	id : "lineName",
									title: "Line Name",
									width: '310px'
								}
							],
				draggable: true,
				autoSelectOneRecord: true,
				onSelect : function(row){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("hidLineCd").value = unescapeHTML2(row.lineCd);
		  				$("txtLineName").value = unescapeHTML2(row.lineName);
		  				$("txtRiCd").focus();
		  				enableToolbarButton("btnToolbarEnterQuery");
		  				if($("txtRiName").value!=""){
							enableToolbarButton("btnToolbarExecuteQuery");
						}
				},
		  		onCancel: function(){
		  		}
			});
		}catch(e){
			showErrorMessage("showGiisLineLOV",e);
		}
	}    
	
	function showReinsurerNamesLOV(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {action : "getRiList",
							 riCd : $("txtRiCd").value,
							},
			title: "Reinsurer",
			width: 470,
			height: 400,
			columnModel: [
	 			{
					id : 'riCd',
					title: 'RI Code',
					width : '70px',
					align: 'right'
				},
				{
					id : 'riName',
					title: 'Reinsurer',
				    width: '350px',
				    align: 'left'
				}
			],
			draggable: true,
			autoSelectOneRecord: true,
			onSelect: function(row) {
				$("txtRiCd").value = unescapeHTML2(row.riCd);
				$("hidRiCd").value = unescapeHTML2(row.riCd);
				$("txtRiName").value = unescapeHTML2(row.riName);
				enableToolbarButton("btnToolbarEnterQuery");
				if($("txtLineName").value!=""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			}
		});
	}
	
	$("hidWithPay").observe("change", function() {
		if($("hidWithPay").value != ""){
			enableButton("btnRiLossRecoveries");	
		}
		else{
			disableButton("btnRiLossRecoveries");
		}
	}); 
	
	$$("input[type='radio']").each(function(a) {
		a.observe("change", function() {
			if($(a).value == "paid"){
				if($(a).checked == true  && exec == true){
					disableButton("btnRiLossRecoveries");
				}
			}
			else {
				disableButton("btnRiLossRecoveries");
			}
		});
	}); 
	
	$$("div#form input[type='text']").each(function(a){
		$(a).observe("change",function(){
			if($(a).value == ""){
				disableToolbarButton("btnToolbarExecuteQuery");
			}
			if($("txtLineCd").value =="" && $("txtRiCd").value =="" ){
				disableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
	$("txtLineCd").focus();
	disableButton("btnRiLossRecoveries");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
</script>
