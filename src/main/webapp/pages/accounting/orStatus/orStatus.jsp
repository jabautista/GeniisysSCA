<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="orStatusMainDiv" name="orStatusMainDiv">

	<!-- <div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="orStatusExit">Exit</a></li>
			</ul>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View OR Status</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
		   		<label id="reloadOrStatus" name="reloadOrStatus">Reload Form</label>
	   		</span>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>		
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 300px; margin-right: 60px;">
						<input type="text" id="txtFundDesc" name="txtFundDesc" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="" ignoreDelKey=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" name="imgSearchFund" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td></td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 240px;">
						<input type="text" id="txtBranchName" name="txtBranchName" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" class="" ignoreDelKey=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
		</table>		
	</div>	
	
	<div class="sectionDiv" style="padding-bottom: 30px;">
	
		<div id="orStatusTableDiv" style="padding-top: 15px; padding-left: 80px; float: left;">
			<div id="orStatusTable" style="height: 300px;"></div>
		</div>	
		
		<div class="" style="float: right; margin-top: 15px; width: 130px; height: 287px; padding-right: 70px;" >
			<table style="margin-top: 5px;">
				<tr>
					<td>Status</td>
				</tr>
				<tr>
					<td style="padding-top: 10px;">
						<table class="sectionDiv" style="padding-top:15px; padding-bottom:15px; width: 130px;">	
							<tr height="25px">
								<td><input type="radio" id="all" name="status" checked="checked" value=""></td>
								<td align="left"><label for="all">All</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="new" name="status" value="New"></td>
								<td align="left"><label for="new">New</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="printed" name="status" value="Printed"></td>
								<td align="left"><label for="printed">Printed</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="cancelled" name="status" value="Cacncelled"></td>
								<td align="left"><label for="cancelled">Cancelled</label></td>
							</tr>
							<tr height="25px">
								<td><input type="radio" id="replaced" name="status" value="Replaced"></td>
								<td align="left"><label for="replaced">Replaced</label></td>
							</tr>
						</table>
					</td>
				</tr>		
			</table>
		</div>						
		
		<div class="" style="float: left; clear: both; margin-left: 10px; width: 899px; height: 60px; margin-bottom:  0px; margin-top: 10px;">
			<table style="padding-left: 75px; float: left;">
				<tr>
					<td class="rightAligned">Particulars</td>
					<td class="leftAligned" colspan="3" style="width: 510px;"><input type="text" id="txtParticulars" name="txtParticulars" style="width: 510px" readonly="readonly"/></td>	
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" style="width: 150px;" readonly="readonly"/></td>
					<td class="rightAligned">Last Update</td>
					<td class="rightAligned" style="width: 195px;"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 195px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div >
		
		<div style="padding-left: 40px; float: left; clear: both; width: 100%; margin: 30px auto; width: 688px;">
			<input type="button" class="button" id="btnHistory" name="history" value="History" style="width: 100px"/>
			<input type="button" class="button" id="btnPrint" name="print" value="Print" style="width: 100px"/>
			<input type="button" class="button" id="btnReprint" name="reprint" value="Reprint" style="width: 100px"/>
		</div>
	</div>
	<input type="hidden" id="hidTranId" name="hidTranId"/>
	<input type="hidden" id="hidStatus" name="hidStatus"/>
	<input type="hidden" id="hidStatusName" name="hidStatusName"/>
	<input type="hidden" id="hidOrPref" name="hidOrPref"/>
	<input type="hidden" id="hidOrPrefNo" name="hidOrPrefNo"/>
	<input type="hidden" id="hidBranchCd" name="hidBranchCd"/>
	<input type="hidden" id="hidFundCd" name="hidFundCd"/>
	<input type="hidden" id="hidFundDesc" name="hidFundDesc"/>
</div>

<script type="text/javascript">
	setModuleId("GIACS235");
	setDocumentTitle("View OR Status");
	exec = false;
	initializeAll();
	initializeAccordion();
	var selectedObjRow = null;
	//$("acExit").show();
	$("mainNav").hide(); // Kenneth L. 01.16.2013
	objPrintOr = new Object();
	objGiacs235 = new Object();
	//objGiacs235.statusOrFlag = null;
	objGiacs235.branchName = null;
	objGiacs235.fundDesc = null;

	var jsonOrStatus = JSON.parse('${jsonOrStatus}');
	orStatusTableModel = {
		url : contextPath + "/GIACInquiryController?action=showOrStatus&refresh=1&fundCd=" + $F("hidFundCd")
						  + "&branchCd=" + $F("hidBranchCd") + "&statusOrFlag=" + $F("hidStatus"),
		options : {
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					setDetailsForm(null);
					tbgAccOrStatus.keys.removeFocus(tbgAccOrStatus.keys._nCurrentFocus, true);
					tbgAccOrStatus.keys.releaseKeys();
					if (exec) {		//added by Gzelle 08122014
						disableFormButton();
					}
				}
			},
			width : '600px',
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				setDetailsForm(tbgAccOrStatus.geniisysRows[y]);
				tbgAccOrStatus.keys.removeFocus(tbgAccOrStatus.keys._nCurrentFocus, true);
				tbgAccOrStatus.keys.releaseKeys();
				enableButton("btnHistory");
				enableButton("btnPrint");
				enableToolbarButton("btnToolbarPrint");
			},
			prePager : function() {
				setDetailsForm(null);
				tbgAccOrStatus.keys.removeFocus(tbgAccOrStatus.keys._nCurrentFocus, true);
				tbgAccOrStatus.keys.releaseKeys();
				disableFormButton();
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				setDetailsForm(null);
				disableFormButton();
			},
			afterRender : function() {
				setDetailsForm(null);
				tbgAccOrStatus.keys.removeFocus(tbgAccOrStatus.keys._nCurrentFocus, true);
				tbgAccOrStatus.keys.releaseKeys();
				if (exec) {		//added by Gzelle 08122014
					disableFormButton();
				}
			},
			onSort : function() {
				setDetailsForm(null);
				tbgAccOrStatus.keys.removeFocus(tbgAccOrStatus.keys._nCurrentFocus, true);
				tbgAccOrStatus.keys.releaseKeys();
				if (exec) {		//added by Gzelle 08122014
					disableFormButton();
				}
			},
			onRowDoubleClick: function(y){
				var row = tbgAccOrStatus.geniisysRows[y];
				objGiacs235.statusOrFlag = row.rvLowValue;	//Kenneth 01.14.2014
				objGiacs235.branchName = $F("txtBranchName");	//Kenneth 01.14.2014
				objGiacs235.fundDesc = $F("txtFundDesc");	//Kenneth 01.14.2014
				objAC.orDetailsFlag = true;
				objACGlobal.gaccTranId = row.tranId;
				objACGlobal.branchCd = $F("hidBranchCd");
				objACGlobal.fundCd = $F("hidFundCd");
				objACGlobal.orFlag = $F("hidStatus");	//added by Gzelle 08122014
				objAC.fromMenu = "cancelOR";
				objAC.showOrDetailsTag = "showOrDetails";
				objAC.butLabel = "Cancel OR";
				selectedObjRow = y;
				setDetailsForm(row);
				$("mainNav").show();
				$("acExit").show();
				editORInformation();
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
			id : "dcbNo",
			title : "DCB No.",
			width : '80px',
			titleAlign : 'right',
			align : 'right',
			filterOption : true
		}, {
			id : "orNo",
			title : "OR No.",
			width : '80px',
			titleAlign : 'left',
			align : 'left',
			filterOption : true
		}, {
			id : "orDate",
			title : "OR Date",
			width : '80px',
			align : 'center',
			titleAlign : 'center',
			filterOption : true,
			filterOptionType: 'formattedDate'
		}, {
			id : "payor",
			title : "Payor",
			width : '180px',
			align : 'left',
			titleAlign : 'left',
			filterOption : true
		}, {
			id : "cashierCd",
			title : "Cashier",
			width : '70px',
			titleAlign : 'left',
			align : 'left',
			filterOption : true
		}, {
			id : "rvMeaning",
			title : "OR Status",
			width : '75px',
			titleAlign : 'left',
			align : 'left'
			//filterOption : true
		} , { //added by Carlo 08102015
			id : "particulars",
			title : "Particulars",
			width : '250px',
			titleAlign : 'left',
			align : 'left',
			filterOption : true
		} 

		],
		rows : jsonOrStatus.rows
	};

	tbgAccOrStatus = new MyTableGrid(orStatusTableModel);
	tbgAccOrStatus.pager = jsonOrStatus;
	tbgAccOrStatus.render('orStatusTable');
	
	function setDetailsForm(rec) {
		try {
			$("txtParticulars").value = rec == null ? "" : unescapeHTML2(rec.particulars);
			$("txtUserId").value = rec == null ? "" : rec.userId;
			$("txtLastUpdate").value = rec == null ? "" : rec.lastUpdate;
			$("hidTranId").value = rec == null ? "" : rec.tranId;
			$("hidOrPref").value = rec == null ? "" : rec.orPref;
			$("hidOrPrefNo").value = rec == null ? "" : rec.orPrefNo;
			//$("hidStatus").value = rec == null ? "" : rec.rvLowValue;
			var status = rec == null ? "" : rec.rvLowValue;
			if (status == "P"){
				enableButton("btnReprint");
			}else
				disableButton("btnReprint");
			
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}

	//history pop-up
	function showOverlay(action, title, error) {
		try {
			overlayOrHistory = Overlay.show(contextPath + "/GIACInquiryController?ajax=1" + "&tranId=" + $F("hidTranId"), {
				urlContent : true,
				urlParameters : {action : action},
				title : title,
				height : 290,
				width : 475,
				draggable : true
			});
		} catch (e) {
			showErrorMessage(error, e);
		}
	}
	
	//reprint pop-up
	function showReprintDialog(title, onPrintFunc, onLoadFunc, showFileOption){
		overlayReprint = Overlay.show(contextPath+"/GIACInquiryController", {
			urlContent : true,
			urlParameters: {action : "showReprintDialog",
							showFileOption : showFileOption },
		    title: title,
		    height: (showFileOption ? 228 : 201),
		    width: 380,
		    draggable: true
		});
		overlayReprint.onPrint = onPrintFunc;
		overlayReprint.onLoad  = nvl(onLoadFunc,null);
	}
	
	function showOrPrintDialog(title, onPrintFunc, onLoadFunc, showFileOption ){
		overlayOrPrint = Overlay.show(contextPath+"/GIACInquiryController", {
			urlContent : true,
			urlParameters: {action : "showOrPrintDialog",
							showFileOption : showFileOption},
		    title: title,
		    height: (showFileOption ? 327 : 300),
		    width: 380,
		    draggable: true
		});
		overlayOrPrint.onPrint = onPrintFunc;
		overlayOrPrint.onLoad  = nvl(onLoadFunc,null);
	}
	
	function disableFormButton(){
		disableButton("btnHistory");
// 		disableButton("btnPrint");		Kenneth  01.14.2013
		disableButton("btnReprint");
		disableToolbarButton("btnToolbarExecuteQuery");
// 		disableToolbarButton("btnToolbarPrint"); 	Kenneth  01.14.2013
	}
	
	$$("input[name='status']").each(function(btn) {
		btn.observe("click", function() {
			$("hidStatus").value = $F(btn).substring(0,1);
			$("hidStatusName").value = $F(btn);
			if ($("txtFundDesc").value != "" && $("txtBranchName").value != "" && exec == true) {
				execute();
			}
		});
	});

	function execute() {
		tbgAccOrStatus.url = contextPath + "/GIACInquiryController?action=showOrStatus&refresh=1&fundCd=" + $F("hidFundCd")
												+ "&branchCd=" + $F("hidBranchCd") + "&statusOrFlag=" + $F("hidStatus");
		tbgAccOrStatus._refreshList();
		disableInputField("txtFundDesc");
		disableInputField("txtBranchName");
		disableInputField("hidStatusName");
		disableSearch("imgSearchFund");
		disableSearch("imgSearchBranch");
		enableToolbarButton("btnToolbarEnterQuery"); 
		enableButton("btnPrint");
		enableToolbarButton("btnToolbarPrint");
	};
	
	function resetGlobal(){
		objACGlobal.gaccTranId = null;
		objACGlobal.branchCd = null;
		objACGlobal.fundCd = null;
		objAC.fromMenu = null;
		objAC.showOrDetailsTag = null;
		objAC.butLabel = null;
		objGiacs235.statusOrFlag = null;	//Kenneth 01.14.2013
		objAC.orDetailsFlag = false;	//Kenneth 01.14.2013
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		exec = false;		//added by Gzelle 08122014
	}
	
	function updateOrStatus() {	//Kenneth 01.14.2013
		try {
			new Ajax.Request(contextPath + "/GIACInquiryController", {
				parameters : {
					action : "showOrStatus",
					fundCd : objACGlobal.fundCd,
					branchCd : objACGlobal.branchCd,
					statusOrFlag : objGiacs235.statusOrFlag
				},
				onComplete : function(response) {
					$("mainContents").update(response.responseText);
					$("txtBranchName").value = objGiacs235.branchName;
					$("txtFundDesc").value = objGiacs235.fundDesc;
					$("hidBranchCd").value = objACGlobal.branchCd;
					$("hidFundCd").value = objACGlobal.fundCd;
					$("hidStatus").value = objGiacs235.statusOrFlag;
					enableToolbarButton("btnToolbarEnterQuery"); 
					enableButton("btnPrint");
					enableToolbarButton("btnToolbarPrint");
					disableInputField("txtFundDesc");
					disableInputField("txtBranchName");
					disableInputField("hidStatusName");
					disableSearch("imgSearchFund");
					disableSearch("imgSearchBranch");
					$$("input[name='status']").each(function(btn) {
						$(btn).checked = false;
						if($(btn).value.substring(0,1) == objGiacs235.statusOrFlag){
							$(btn).checked = true;
						}
					});
					exec = true;
				}
			});
		} catch (e) {
			showErrorMessage("menuOrStatus", e);
		}
	}
	
	observeReloadForm("reloadOrStatus", function() {
		new Ajax.Request(contextPath + "/GIACInquiryController", {
			parameters : {
				action : "showOrStatus"
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response) {
				hideNotice();
				try {
					if (checkErrorOnResponse(response)) {
						$("mainContents").update(response.responseText);
						exec = false;
					}
				} catch (e) {
					showErrorMessage("showOrStatus - onComplete : ", e);
				}
			}
		});
	});

	//toolbar(Enter Query)
	$("btnToolbarEnterQuery").observe("click", function() {
		fireEvent($("reloadOrStatus"), "click");
	});

	//toolbar(Execute Query)
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtFundDesc").value != "" && $("txtBranchName").value != "") {
			exec = true;
			execute();
		}
	});

	//toolbar(Exit)
	$("btnToolbarExit").observe("click", function() {
		resetGlobal();
	});

	/* $("acExit").observe("click", function() {
		resetGlobal();
	}); */
	
	//toolbar(Print)
	$("btnToolbarPrint").observe("click", function() {
		showOrPrintDialog("Print O.R. Status",function(){
			objPrintOr.printOr();
		} , "", true);
	});

	//print button
	$("btnPrint").observe("click", function() {
		showOrPrintDialog("Print O.R. Status",function(){
			objPrintOr.printOr();
		} , "", true);
	});

	$("btnReprint").observe("click", function() {
		showReprintDialog("Reprint O.R.",function(){
			objPrintOr.reprintOr();
		} , "", true);
	});
	
	//history button
	$("btnHistory").observe("click", function() {
		showOverlay("showOrHistory", "OR History", "Show OR History Overlay");
	});	
	
	function showGIACS235FundLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtFundDesc").trim() == "" ? "%" : $F("txtFundDesc"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACSInquiryFundLOV",
					company : searchString+"%",
					page : 1
				},
				title : "List of Funds",
				width : 360,
				height : 386,
				columnModel : [ {
					id : "fundCd",
					title : "Code",
					width : '100px'
				}, {
					id : "fundDesc",
					title : "Description",
					width : '235px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if($("txtBranchName").value != ""){
						$("hidFundCd").value = row.fundCd;
						$("txtFundDesc").value = row.fundCd + " - " + row.fundDesc;
						enableToolbarButton("btnToolbarExecuteQuery");
					}else{
						$("hidFundCd").value = row.fundCd;
						$("txtFundDesc").value = row.fundCd + " - " + row.fundDesc;
						disableToolbarButton("btnToolbarExecuteQuery");
					}
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundDesc");
			},
			onCancel: function(){
				$("txtFundDesc").focus();
			}
			});
		}catch(e){
			showErrorMessage("showGIACS235FundLOV", e);
		}		
	}
	
	$("imgSearchFund").observe("click", function(){
		showGIACS235FundLOV(true);
	});
	
	$("txtFundDesc").observe("change", function(){
		enableToolbarButton("btnToolbarEnterQuery");
		if (this.value != ""){
			showGIACS235FundLOV(false);
		}
	});	
	
	
	/* function showGIACS235FundLOV(action, fundDesc, hidFundCd, branchCd, focus) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : action,
				company: fundDesc.value,
				page : 1
			},
			title : "List of Funds",
			width : 370,
			height : 400,
			columnModel : [ {
				id : "fundCd",
				title : "Code",
				width : '100px'
			}, {
				id : "fundDesc",
				title : "Description",
				width : '235px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : fundDesc.value,
			onSelect : function(row) {
					if(branchCd.value != ""){
						hidFundCd.value = row.fundCd;
						fundDesc.value = row.fundCd + " - " + row.fundDesc;
						enableToolbarButton("btnToolbarExecuteQuery");
					}else{
						hidFundCd.value = row.fundCd;
						fundDesc.value = row.fundCd + " - " + row.fundDesc;
						disableToolbarButton("btnToolbarExecuteQuery");
					}
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, focus);
			},
			onCancel: function(){
				fundDesc.focus();
			}
		});
	} */
	
	$("imgSearchBranch").observe("click", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		showGIACSInquiryBranchLOV("GIACS235", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
	});
	
	$("txtBranchName").observe("change", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		$("hidBranchCd").value = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryBranchLOV("GIACS235", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
	});
			
	
	
	if (!objAC.orDetailsFlag) {//Kenneth  01.14.2013
		$("txtFundDesc").focus();
		disableFormButton();
		disableToolbarButton("btnToolbarEnterQuery");
		disableButton("btnPrint");		//Kenneth  01.14.2013
		disableToolbarButton("btnToolbarPrint"); 	//Kenneth  01.14.2013
		objAC.orDetailsFlag = false;
	}
	objGiacs235.updateOrStatus = updateOrStatus;
</script>