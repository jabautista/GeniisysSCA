<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchRedisMainDiv" name="batchRedisMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Claims Batch Redistribution</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" style="margin: 0 0 20px 0;">
		<div id="mainTabsMenu" name="subMenuDiv" align="center" style="width: 100%; margin-bottom: 0px; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabReserveList">Reserve</a></li>
					<li class="tab1"><a id="tabLossExpenseList">Loss / Expense</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>
		</div>
	</div>
	
	<div id="tgContentsDiv" name="tgContentsDiv" style="float: left; height: 335px;">
		<div id="reserveDiv" name="reserveDiv" style="height: 290px; width: 900px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px;">
			Reserve Div
		</div>
	</div>
	
	<div id="radioDiv" name="radioDiv" style="float:left; height: 50px; width: 34%; margin-left: 20px;">
		<table style="margin-top: 0px;">
			<tr>
				<td>
					<input type="radio" id="rdotagAll" name="taggingOption" value="T" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="rdotagAll" style="margin-top: 3px;">Tag All</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="radio" id="rdoUntagAll" name="taggingOption" value="U" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="rdoUntagAll" style="margin-top: 3px;">Untag All</label>
				</td>
			</tr>
			<tr>
				<td>
					<input type="radio" id="rdoSelectedItems" name="taggingOption" value="S" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="rdoSelectedItems" style="margin-top: 3px;">Selected Items</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="float:left; height: 50px; width: 30%; margin-top: 20px;">
		<input type="button" class="button" id="btnRedistributeReserve" name="btnRedistributeReserve" value="Redistribute" style="width:120px;" />
		<input type="button" class="button" id="btnParameter" name="btnParameter" value="Parameter" style="width:120px;" />
	</div>
	
	<input type="hidden" id="hidLineCd" name="hidLineCd" value="${lineCd}"/>
	<input type="hidden" id="hidCurrentView" name="hidCurrentView" value="${currentView}"/>
</div>
<script type="text/javascript">
	var reasonTxtArray = [];
	
	observeReloadForm("reloadForm", function(){
		showCLMBatchRedistribution($F("hidCurrentView"), $F("hidLineCd"));
	});

	try {
		var objReserve = new Object();
		objReserve.objReserveListTableGrid = JSON.parse('${batchRedistList}');
		objReserve.objReserveList = objReserve.objReserveListTableGrid.rows || [];
		
		var reserveDtlsTableModel = {
				url : contextPath + "/GICLClaimReserveController?action=showCLMBatchRedistribution&refresh=1"
					+ "&lineCd=" + $F("hidLineCd")
					+ "&currentView=" + $F("hidCurrentView")
					+ "&moduleId=" + "GICLS038",
				options : {
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function() {
							reserveDtlsTableGrid.keys.removeFocus(reserveDtlsTableGrid.keys._nCurrentFocus, true);
							reserveDtlsTableGrid.keys.releaseKeys();
						}
					},
					title :'',
					width : '900px',
					height : '330px',
					pager : {},
					hideColumnChildTitle: true,
					postPager: function(){
						if(tagAll == "Y"){
							var rows = reserveDtlsTableGrid.geniisysRows;
							for(var i = 0; i < rows.length;  i++){
								$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + i).checked = true;
							}
						}
					},
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = reserveDtlsTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
	                	}
					},
					onRemoveRowFocus: function(){
						reserveDtlsTableGrid.keys.removeFocus(reserveDtlsTableGrid.keys._nCurrentFocus, true);
						reserveDtlsTableGrid.keys.releaseKeys();
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
							id: 'chkBox',
							title: '',
							width: '30px',
							tooltip: '',
							align: 'center',
							titleAlign: 'center',
							editor:	 'checkbox',
							editable : true,
							sortable: false,
							editor: new MyTableGrid.CellCheckbox({
								onClick: function(value, checked) {
									whenCheckBoxChanged();
									/* if($("rdoUntagAll").checked && $("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + selectedIndex).checked){
										showWaitingMessageBox("You are not allowed to check this checkbox while untag all is selected.","I", function(){
												$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + selectedIndex).checked = false;
										});
									} else if($("rdotagAll").checked && !$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + selectedIndex).checked){
										showWaitingMessageBox("You are not allowed to uncheck this checkbox while tag all is selected.","I", function(){
											$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + selectedIndex).checked = true;
										});
									} */
								}
							})
						},
						{
							id: "lineCd sublineCd issCd clmYy clmSeqNo",
							title: "Claim Number",
							width : 180,
							children : [
							            	{
							            		id : 'lineCd',
												title : 'Line Code',
												width : 30
							            	},
							            	{
												id : 'sublineCd',
												title : 'Subline Code',
												width : 45,
												filterOption : true,
											},
											{
												id : 'issCd',
												title : 'Claim Iss. Code',
												width : 30,
												filterOption : true,
											},
											{
												id : 'clmYy',
												title : 'Claim Issue Year',
												type : 'number',
												align : 'right',
												width : 30,
												filterOption : true,
												filterOptionType: 'integerNoNegative',
											},
											{
												id : 'clmSeqNo',
												title : 'Claim Sequence No.',
												type : 'number',
												align : 'right',
												width : 60,
												filterOption : true,
												filterOptionType: 'integerNoNegative',
												renderer : function(value) {
											    	return formatNumberDigits(value, 7);
											    }
											}
							           ]
							
						},
						{
							id: "lineCd sublineCd polIssCd issueYy polSeqNo renewNo",
							title: "Policy/Bond No.",
							width : 220,
							children : [
							           		{
							           			id : 'lineCd',
												title : 'Line Code',
												width : 30
							           		},
							           		{
												id : 'sublineCd',
												title : 'Subline Code',
												width : 45,
											},
											{
												id : 'polIssCd',
												title : 'Policy Iss. Code',
												width : 30,
												filterOption : true,
											},
											{
												id : 'issueYy',
												title : 'Policy Issue Yy',
												type : 'number',
												align : 'right',
												width : 30,
												filterOption : true,
												filterOptionType: 'integerNoNegative',
											},
											{
												id : 'polSeqNo',
												title : 'Policy Sequence No.',
												type : 'number',
												align : 'right',
												width : 60,
												filterOption : true,
												filterOptionType: 'integerNoNegative',
												renderer : function(value) {
											    	return formatNumberDigits(value, 7);
											    }
											},
											{
												id : 'renewNo',
												title : 'Renew No.',
												type : 'number',
												align : 'right',
												width : 30,
												filterOption : true,
												filterOptionType: 'integerNoNegative',
												renderer : function(value) {
											    	return formatNumberDigits(value, 2);
											    }
											}
							           ]
						},
						{
							id: 'itemNo',
							title: 'Item No',
							width: '70px',
							titleAlign : 'right',
							align : 'right'
						},
						{
							id: 'perilCd dspPerilSname',
							title: 'Peril',
							width: 215,
							children : [
								          	{
								          		id : 'perilCd',
												title : 'Peril Code',
												width : 30,
												align : 'right'
								          	} ,
								          	{
												id: 'dspPerilSname',
												title: 'Peril',
												width: 190,
												titleAlign: 'left'
											}
							           ]
						},
						{
							id: 'lossReserve',
							title: 'Loss Reserve',
							width: '120',
							titleAlign: 'right',
							align: 'right',
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id: 'expenseReserve',
							title: 'Expense Reserve',
							width: '120',
							titleAlign: 'right',
							align: 'right',
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : 'claimId',
							title : 'Claim Id',
							width : '0',
							visible : false
						},
						{
							id : 'lossDate',
							title : 'Loss Date',
							width : '0',
							visible : false
						},
						{
							id : 'groupedItemNo',
							title : 'Grouped Item No',
							width : '0',
							visible : false
						},
						{
							id : 'currencyCd',
							title : 'Currency Code',
							width : '0',
							visible : false
						},
						{
							id : 'convertRate',
							title : 'Convert Rate',
							width : '0',
							visible : false
						},
						{
							id : 'catastrophicCd',
							title : 'Catastrophic Code',
							width : '0',
							visible : false
						},
						{
							id : 'clmFileDate',
							title : 'Claim File Date',
							width : '0',
							visible : false
						}
				],
				resetChangeTag : true,
				rows : objReserve.objReserveListTableGrid.rows
		};
		reserveDtlsTableGrid = new MyTableGrid(reserveDtlsTableModel);
		reserveDtlsTableGrid.pager = objReserve.objReserveListTableGrid;
		reserveDtlsTableGrid.render('reserveDiv');
	} catch(e){
		showErrorMessage("Reserve Table Grid", e);
	}

	$("tabLossExpenseList").observe("click", function(){
		showCLMBatchRedistribution("L", $F("hidLineCd"));
	});
	
	$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	$("btnRedistributeReserve").observe("click", function(){
		reserveDtlsTableGrid.keys.removeFocus(reserveDtlsTableGrid.keys._nCurrentFocus, true);
		reserveDtlsTableGrid.keys.releaseKeys();
		redisReserveArray = [];
		var rows = reserveDtlsTableGrid.geniisysRows;
		for(var i = 0; i < rows.length;  i++){
			if($("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + i).checked){
				redisReserveArray.push(reserveDtlsTableGrid.getRow(i));
			}
		}
		
		var dateToday = ignoreDateTime(new Date());
		
		new Ajax.Request(contextPath+"/GICLClaimReserveController",{
			parameters:{
				action  	: "redistributeReserveGICLS038",
				dateToday 	: dateFormat(dateToday, "mm-dd-yyyy"),
				rows    	: prepareJsonAsParameter(redisReserveArray)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Redistributing record/s....");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if (res != '' || res != null){
						reserveDtlsTableGrid._refreshList();
						disableButton("btnRedistributeReserve");
						reasonTxtArray = res.rows;
						showReasonOverlay(reasonTxtArray);
					}
				}
			}
		});
	});
	
	$("btnParameter").observe("click", function(){
		try {
			overlayRedistParam = 
				Overlay.show(contextPath+"/GICLClaimReserveController", {
					urlContent: true,
					urlParameters: {action : "showRedistParamOverlay",																
									ajax : "1",
									lineCd : $F("hidLineCd"),
									currentView : $F("hidCurrentView")
					},
				    title: "Parameter",
				    height: 230,
				    width: 500,
				    draggable: false
				});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
	});
	
	function showReasonOverlay(reasonTxtList){
		try {
			overlayReasonText = 
				Overlay.show(contextPath+"/GICLClaimReserveController", {
					urlContent: true,
					urlParameters: {action : "showReasonTextOverlay",																
									ajax : "1",
									rows : prepareJsonAsParameter(reasonTxtList)
					},
				    title: "Reason",
				    height: 300,
				    width: 700,
				    draggable: false
				});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
	}
	
	function whenCheckBoxChanged(){
		var rows = reserveDtlsTableGrid.geniisysRows;
		var tagged = "N";
		var someUnchecked = "N";
		for(var i = 0; i < rows.length;  i++){
			if($("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + i).checked){
				tagged = "Y";
			} else {
				someUnchecked = "Y";
			}
		}
		
		if(someUnchecked == "Y"){
			$(rdoSelectedItems).checked = true;
		}
		
		if(tagged == "Y"){
			enableButton("btnRedistributeReserve");
		} else {
			disableButton("btnRedistributeReserve");
		}
	}
	
	$$("input[name='taggingOption']").each(function(radio){
		radio.observe("click", function(){
			whenRadioChanged(radio.value);
		});
	});
	
	function whenRadioChanged(option){
		var rows = reserveDtlsTableGrid.geniisysRows;
		if(option == "T"){
			enableButton("btnRedistributeReserve");
			tagAll = "Y";
			for(var i = 0; i < rows.length;  i++){
				$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + i).checked = true;
			}
		}else{
			tagAll = "N";
			disableButton("btnRedistributeReserve");
			for(var i = 0; i < rows.length;  i++){
				$("mtgInput"+ reserveDtlsTableGrid._mtgId + "_2," + i).checked = false;
			}
		}
	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GICLS038"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	var selectedIndex = 0;
	var tagAll;
	disableButton("btnRedistributeReserve");
	
	setModuleId("GICLS038");
	setDocumentTitle("Batch Claim Redistribution");
	initializeAll();
	checkUserAccess();
</script>