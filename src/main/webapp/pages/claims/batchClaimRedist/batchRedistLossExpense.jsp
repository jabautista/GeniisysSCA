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
					<li class="tab1"><a id="tabReserveList">Reserve</a></li>
					<li class="tab1 selectedTab1"><a id="tabLossExpenseList">Loss / Expense</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>
		</div>
	</div>
	
	<div id="tgContentsDiv" name="tgContentsDiv" style="float: left; height: 335px;">
		<div id="lossExpenseDiv" name="lossExpenseDiv" style="height: 290px; width: 900px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px;">
			Loss Expense Div
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
		<input type="button" class="button" id="btnRedistributeLossExpense" name="btnRedistributeLossExpense" value="Redistribute" style="width:120px;" />
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
		var objLossExpense = new Object();
		objLossExpense.objLossExpenseListTableGrid = JSON.parse('${batchRedistList}');
		objLossExpense.objLossExpenseList = objLossExpense.objLossExpenseListTableGrid.rows || [];
		
		var lossExpenseDtlsTableModel = {
				url : contextPath + "/GICLClaimReserveController?action=showCLMBatchRedistribution&refresh=1"
				+ "&lineCd=" + $F("hidLineCd")
				+ "&currentView=" + $F("hidCurrentView")
				+ "&moduleId=" + "GICLS038",
				options : {
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function() {
							lossExpenseDtlsTableGrid.keys.removeFocus(lossExpenseDtlsTableGrid.keys._nCurrentFocus, true);
							lossExpenseDtlsTableGrid.keys.releaseKeys();
						}
					},
					title :'',
					width : '900px',
					height : '300px',
					hideColumnChildTitle: true,
					postPager: function(){
						if(tagAll == "Y"){
							var rows = lossExpenseDtlsTableGrid.geniisysRows;
							for(var i = 0; i < rows.length;  i++){
								$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_2," + i).checked = true;
							}
						}
					},
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = lossExpenseDtlsTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
	                	}
					},
					onRemoveRowFocus: function(){
						reserveDtlsTableGrid.keys.releaseKeys();
		            },
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
							id: 'distRg1',
							title: '&#160;&#160;U',
							width: '30px',
							tooltip: 'UW Distribution',
							align: 'center',
							titleAlign: 'center',
							editable: true,
							radioGroup: 'distRgGroup',
							editor: new MyTableGrid.CellRadioButton({
						        getValueOf: function(value){
						        	if (value){
										return "1";
					            	}
						        }
					    	}),
							sortable: false
						},
						{ 
							id: 'distRg2',
							title: '&#160;&#160;R',
							width: '30px',
							tooltip: 'Reserve Distribution',
							align: 'center',
							titleAlign: 'center',
							editable: true,
							radioGroup: 'distRgGroup',
							editor: new MyTableGrid.CellRadioButton({
						        getValueOf: function(value){
						        	if (value){
										return "2";
					            	}
						        }
					    	}),
							sortable: false
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
							id: 'histSeqNo',
							title: 'Hist No.',
							width: '70px',
							titleAlign: 'right',
							align: 'right'
						},
						{
							id: 'itemStatCd',
							title: 'Status',
							width: '60px',
							titleAlign: 'left',
							align: 'left'
						},
						{
							id 			 : "itemNo groupedItemNo",
							title		 : "Item",
							titleAlign   : 'right',
							children	 : [
								{
									id : "itemNo",
									title: "Item No",
									width: 30,
									align: 'right'
								}, {
									id : "groupedItemNo",
									title: "Grouped Item No",
									width: 50,
									align: 'right',
									renderer: function(value) {
											  	return formatNumberDigits(value, 5);
									   		  }
								},
							]
						},
						{
							id 			 : "perilCd dspPerilSname",
							title		 : "Peril",
							children	 : [
								{
									id : "perilCd",
									title: "Peril Code",
									width: 30,
									align: 'right'
								}, {
									id : "dspPerilSname",
									title: "Peril Short Name",
									width: 180,
									align: 'left',
								},
							]
						},
						{
							id 			 : "currencyCd currencyRate",
							title		 : "Currency",
							sortable	 : true,
							children	 : [
								{
									id : "currencyCd",
									title: "Currency Cd",
									width: 30,
									align: 'right',
								}, {
									id : "currencyRate",
									title: "Currency Rate",
									width: 80,
									align: 'right',
									geniisysClass: 'rate',
									renderer: function(value) {
											  	return formatNumberDigits(value, 5);
									   		  }
								},
							]
						},
						{
							id 			 : "payeeType payeeCd dspPayeeName",
							title		 : "Payee",
							sortable	 : false,
							children	 : [
								{
									id : "payeeType",
									title: "Payee Type",
									width: 30,
									align: 'left',
								}, {
									id : "payeeCd",
									title: "Payee Code",
									width: 50,
									align: 'right',
								},
								{
									id: 'dspPayeeName',
									title: 'Peril',
									width: 180,
									align: 'left'
								},
							]
						},
						{
							id: 'paidAmt',
							title: 'Paid Amount',
							width: '120',
							titleAlign: 'right',
							align: 'right',
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id: 'netAmt',
							title: 'Net Amount',
							width: '120',
							titleAlign: 'right',
							align: 'right',
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id: 'adviseAmt',
							title: 'Advise Amount',
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
							id : 'clmLossId',
							title : 'Claim Loss Id',
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
							id : 'effDate',
							title : 'Effectivity Date',
							width : '0',
							visible : false
						},
						{
							id : 'expiryDate',
							title : 'Expiry Date',
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
							id : 'lineCd',
							title : 'Line Code',
							width : '0',
							visible : false
						},
						{
							id : 'distRg',
							title : 'Distribution Group',
							width : '0',
							visible : false
						}
				],
				resetChangeTag : true,
				rows : objLossExpense.objLossExpenseListTableGrid.rows
		};
		lossExpenseDtlsTableGrid = new MyTableGrid(lossExpenseDtlsTableModel);
		lossExpenseDtlsTableGrid.pager = objLossExpense.objLossExpenseListTableGrid;
		lossExpenseDtlsTableGrid.render('lossExpenseDiv');
	} catch(e){
		showErrorMessage("Loss Expense Table Grid", e);
	}

	$("tabReserveList").observe("click", function(){
		showCLMBatchRedistribution("R", $F("hidLineCd"));
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});	
	
	$("btnRedistributeLossExpense").observe("click", function(){
		lossExpenseDtlsTableGrid.keys.removeFocus(lossExpenseDtlsTableGrid.keys._nCurrentFocus, true);
		lossExpenseDtlsTableGrid.keys.releaseKeys();
		redisLossExpenseArray = [];
		var rows = lossExpenseDtlsTableGrid.geniisysRows;
		for(var i = 0; i < rows.length;  i++){
			if($("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_4," + i).checked){
				lossExpenseDtlsTableGrid.setValueAt("2", lossExpenseDtlsTableGrid.getColumnIndex("distRg"), i);
			} else if($("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_3," + i).checked){
				lossExpenseDtlsTableGrid.setValueAt("1", lossExpenseDtlsTableGrid.getColumnIndex("distRg"), i);
			}
			
			if($("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_2," + i).checked){
				redisLossExpenseArray.push(lossExpenseDtlsTableGrid.getRow(i));
			}
		}
		
		var dateToday = ignoreDateTime(new Date());
		
		new Ajax.Request(contextPath+"/GICLClaimReserveController",{
			parameters:{
				action  	: "redistributeLossExpenseGICLS038",
				dateToday 	: dateFormat(dateToday, "mm-dd-yyyy"),
				rows    	: prepareJsonAsParameter(redisLossExpenseArray)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Redistributing record/s....");
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if (res.pMessage != '' || res.pMessage != null){
						lossExpenseDtlsTableGrid._refreshList();
						disableButton("btnRedistributeLossExpense");
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
		var rows = lossExpenseDtlsTableGrid.geniisysRows;
		var tagged = "N";
		var someUnchecked = "N";
		for(var i = 0; i < rows.length;  i++){
			if($("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_2," + i).checked){
				tagged = "Y";
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_3," + i).checked = false;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_4," + i).checked = true;
			} else {
				someUnchecked = "Y";
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_3," + i).checked = false;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_4," + i).checked = false;
			}
		}
		
		if(someUnchecked == "Y"){
			$(rdoSelectedItems).checked = true;
		}
		
		if(tagged == "Y"){
			enableButton("btnRedistributeLossExpense");
		} else {
			disableButton("btnRedistributeLossExpense");
		}
	}
	
	$$("input[name='taggingOption']").each(function(radio){
		radio.observe("click", function(){
			whenRadioChanged(radio.value);
		});
	});
	
	function whenRadioChanged(option){
		var rows = lossExpenseDtlsTableGrid.geniisysRows;
		if(option == "T"){
			enableButton("btnRedistributeLossExpense");
			tagAll = "Y";
			for(var i = 0; i < rows.length;  i++){
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_2," + i).checked = true;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_3," + i).checked = false;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_4," + i).checked = true;
			}
		}else{
			tagAll = "N";
			disableButton("btnRedistributeLossExpense");
			for(var i = 0; i < rows.length;  i++){
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_2," + i).checked = false;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_3," + i).checked = false;
				$("mtgInput"+ lossExpenseDtlsTableGrid._mtgId + "_4," + i).checked = false;
			}
		}
	}
	
	var selectedIndex = 0;
	var tagAll;
	disableButton("btnRedistributeLossExpense");
	
	setModuleId("GICLS038");
	setDocumentTitle("Batch Claim Redistribution");
	initializeAll();
</script>