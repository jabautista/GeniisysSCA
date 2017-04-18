<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="commSlipMainDiv" name="commSlipMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Commission Slip</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadCommForm" name="reloadCommForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="commSlipSectionDiv" name="commSlipSectionDiv">
		<div id="commSlipTable" style="position:relative; height: 300px; margin: 10px; margin-top: 10px;"></div>
		<div id="commTotalsDiv" style="height: 25px; margin-top: 35px; margin-bottom: 10px;" >
			<label style="margin-left: 290px; font-size: 11px; margin-top: 7px;">Tagged Total</label>
			<input type="text" id="commTotals" name="commTotals" class="money" readonly="readonly" style="width: 120px; margin-right: 1px;" />
			<input type="text" id="wtaxTotals" name="wtaxTotals" class="money" readonly="readonly" style="width: 120px; margin-right: 1px;" />
			<input type="text" id="vatTotals" name="vatTotals" class="money" readonly="readonly" style="width: 120px; margin-right: 1px;" />
			<input type="text" id="netTotals" name="netTotals" class="money" readonly="readonly" style="width: 120px;"/>
		</div>
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnTagRecords" name="btnTagRecords" value="Tag/Untag All Records" />
		<input type="button" class="button" id="btnPrintComm"  name="btnPrintComm"	value="Print" />
		<input type="button" class="button" id="btnCancel" 	   name="btnCancel" 	value="Cancel" />
	</div>
</div>

<script type="text/javascript">
	var objCommSlip = new Object(); 
	objCommSlip.objCommSlipExtGrid = JSON.parse('${commSlipGrid}');
	objCommSlip.objCommSlipExt = objCommSlip.objCommSlipExtGrid.rows || [];
	
	var vpdc = objCommSlip.objCommSlipExtGrid.vpdc == null ? "N" : objCommSlip.objCommSlipExtGrid.vpdc;
	var taggedRows = new Array();
	var commPrinted = "N";
	var clientUser = '${clientUser}';
	
	$("acMenus").hide();
	$("commSlipMenu").show();

	setModuleId("GIACS154");
	setDocumentTitle("Commission Slip");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	hideNotice("");
	
	var tableModel = {
		url: contextPath+"/GIACCommSlipController?action=showCommSlip&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
		options: {
			onCellFocus : function(element, value, x, y, id) {
				sameCommSlip(y);
				computeTotals();
				togglePrintBtn();
				tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
				tableGrid.keys.releaseKeys();	
			},
			onRemoveRowFocus : function(){
				tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
				tableGrid.keys.releaseKeys();
			},
			onCellBlur : function(element, value, x, y, id) {
				computeTotals();
				togglePrintBtn();
			},
			onSort : function(){
				recordsTagged = 1;
				fireEvent($("btnTagRecords"), "click");
			}
		},
		columnModel: [
			{ 								
			    id: 'recordStatus', 					    
			    title: '',
			    width: '0',
			    sortable: false,
			    editable: true,
			    editor: 'checkbox',
			    visible: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id: 'recId',
				width: '0',
				visible: false
			},
			{
				id: 'prFlag',
				title: '&nbsp;&nbsp;&nbsp;I',
				width: '30px',
				align: 'center',
				editable: true,
				sortable: false,
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
			},
			{
				id: 'commissionSlipNo',
				title: 'Commission Slip',
				width: '145px'
			},
			{
				id: 'intmNo',
				title: 'Intm No',
				width: '75px'
			},
			{
				id: 'billNo',
				title: 'Bill No',
				width: '105px'
			},
			{
				id: 'commAmt',
				title: 'Commision Amt',
				width: '130px',
				geniisysClass : 'money',
				align: 'right'
			},
			{
				id: 'wtaxAmt',
				title: 'WithHolding Tax Amt',				
				width: '130px',
				geniisysClass : 'money',
				align: 'right' 
			},
			{
				id: 'inputVatAmt',
				title: 'Input VAT Amt',				
				width: '130px',
				geniisysClass : 'money',
				align: 'right'
			},
			{
				id: 'netAmt',
				title: 'Net Amt',				
				width: '130px',
				geniisysClass : 'money',
				align: 'right'
			},
			{
				id: 'premSeqNo',
				width: '0',
				visible: false
			}
		],
		rows : objCommSlip.objCommSlipExt
	};
	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objCommSlip.objCommSlipExtGrid;
	tableGrid.render('commSlipTable');

	var recordsTagged = 0;
	
	$("btnTagRecords").observe("click", function() {
		/*
		** nieko Accounting Uploading
		if(recordsTagged == 0) {
			$$("div#bodyDiv1 input[type='checkBox']").each(function(row) {
				row.checked = true;
			});
			for (var i=0; i<tableGrid.rows.length; i++) {
				tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'Y';
			}
			recordsTagged = 1;
		} else {
			$$("div#bodyDiv1 input[type='checkBox']").each(function(row) {
				row.checked = false;
			});
			for (var i=0; i<tableGrid.rows.length; i++) {
				tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'N';
			}
			recordsTagged = 0;
		}*/
		tagRecords();
		togglePrintBtn();
		computeTotals();
	});

	$("btnPrintComm").observe("click", function() {
		var ctr = 0;
		if(clientUser == "UGIC") {
			for (var i=0; i<tableGrid.rows.length; i++) {
				if(tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] == 'Y') {
					ctr++;	
				}
			}
			if(ctr>1) {
				showMessageBox("Unable to print more than 1 bill.");
			} else {
				goToPrintCommSlip();
			}
		} else {
			goToPrintCommSlip();
		}
	});

	function createCommSlipParams(){ //added by robert 05.28.2014
		try {			
			var obj 				= [];
			for(var i = 0; i < taggedRows.length; i++){
				obj.push({recId:taggedRows[i].recId,
					issCd:taggedRows[i].issCd,
					premSeqNo:taggedRows[i].premSeqNo,
					intmNo:taggedRows[i].intmNo,
					commAmt:taggedRows[i].commAmt,
					wtaxAmt:taggedRows[i].wtaxAmt,
					inputVatAmt:taggedRows[i].inputVatAmt,
					commSlipPref:taggedRows[i].commSlipPref,
					commSlipNo:taggedRows[i].commSlipNo, 
					commSlipFlag:taggedRows[i].commSlipFlag, 
					commSlipDate:taggedRows[i].commSlipDate});
			}
			return obj;
		} catch (e){
			showErrorMessage("createCommSlipParams", e);
		}			
	}
	
	function goToPrintCommSlip() {
		var parameters = createCommSlipParams(); //added by robert 05.28.2014
		parameters = JSON.stringify(parameters).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n"); //added by robert 05.28.2014
		//var parameters = JSON.stringify(taggedRows).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n"); //removed by robert 
		Modalbox.show(contextPath+"/GIACCommSlipController?action=forwardToPrintComm&gaccTranId="+
			objACGlobal.gaccTranId+"&gaccBranchCd="+objACGlobal.branchCd+
			"&gaccFundCd="+objACGlobal.fundCd+"&parameters="+parameters+"&vpdc="+vpdc+"&commPrinted="+commPrinted, 
			"Geniisys Report Generator", 
			{title: "Geniisys Report Generator",
			width: 400});
	}

	function togglePrintBtn() {
		var exists = 0;
		for (var i=0; i<tableGrid.rows.length; i++) {
			if(tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] == 'Y') {
				exists = 1;
			}
		}

		if(exists == 1) {
			enableButton($("btnPrintComm"));
		} else {
			disableButton($("btnPrintComm"));
		}
	}

	function computeTotals() {
		var commTotal = 0;
		var wtaxTotal = 0;
		var vatTotal = 0;
		var netTotal = 0;
		for (var i=0; i<tableGrid.rows.length; i++) {
			if(tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] == 'Y'/* ||
					tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] == '' || 
					tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] == null*/) {
				
				var commAmt = tableGrid.rows[i][tableGrid.getColumnIndex('commAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('commAmt')] == "" ?
							0 : tableGrid.rows[i][tableGrid.getColumnIndex('commAmt')];
				commTotal = parseFloat(commTotal) + parseFloat(commAmt);

				var wtax = tableGrid.rows[i][tableGrid.getColumnIndex('wtaxAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('wtaxAmt')] == "" ?
						0 : tableGrid.rows[i][tableGrid.getColumnIndex('wtaxAmt')];
				wtaxTotal = parseFloat(wtaxTotal) + parseFloat(wtax);

				var vatAmt = tableGrid.rows[i][tableGrid.getColumnIndex('inputVatAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('inputVatAmt')] == "" ?
						0 : tableGrid.rows[i][tableGrid.getColumnIndex('inputVatAmt')];
				vatTotal = parseFloat(vatTotal) + parseFloat(vatAmt);

				var netAmt = tableGrid.rows[i][tableGrid.getColumnIndex('netAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('netAmt')] == "" ?
						0 : tableGrid.rows[i][tableGrid.getColumnIndex('netAmt')];
				netTotal = parseFloat(netTotal) + parseFloat(netAmt);

				var rowExist = false;
				for(var j=0; j<taggedRows.length; j++) {
					if(taggedRows[j].recId == tableGrid.geniisysRows[i].recId) {
						rowExist = true;
					}
				} 
				if(tableGrid.geniisysRows[i].commSlipFlag == "P") {
					commPrinted = "P";
				}
				if(!rowExist) {
					tableGrid.geniisysRows[i].commSlipTag = "Y";
					taggedRows.push(tableGrid.geniisysRows[i]);
				}
			} else {
				taggedRows.splice(i, 1);
			}
		}

		$("commTotals").value = formatCurrency(commTotal);
		$("wtaxTotals").value = formatCurrency(wtaxTotal);
		$("vatTotals").value = formatCurrency(vatTotal);
		$("netTotals").value = formatCurrency(netTotal);
	}

	//$("reloadCommForm").observe("click", showCommSlip);

	$("csExit").stopObserving("click");
	$("csExit").observe("click", function() {
		$("commSlipMenu").hide();
		$("acMenus").show();
		if(objACGlobal.gaccTranId == null){
			createORInformation(objACGlobal.branchCd);
		} else {
			if (objACGlobal.callingForm2 == "GIACS607"){//shan 06.09.2015 : conversion of GIACS607
				$("otherModuleDiv").innerHTML = "";
				$("otherModuleDiv").hide();
				$("processPremAndCommDiv").show();
			}else{
				editORInformation();
			}
		}
	});

	togglePrintBtn();
	computeTotals();
	changeTag = 0;
	
	//nieko Accounting Uploading
	$("btnCancel").observe("click", function() {
		$("commSlipMenu").hide();
		$("acMenus").show();
		if(objACGlobal.gaccTranId == null){
			createORInformation(objACGlobal.branchCd);
		} else {
			if (objACGlobal.callingForm2 == "GIACS607"){//shan 06.09.2015 : conversion of GIACS607
				$("otherModuleDiv").innerHTML = "";
				$("otherModuleDiv").hide();
				$("processPremAndCommDiv").show();
			}else{
				editORInformation();
			}
		}
	});
	
	$("reloadCommForm").observe("click", function() {
		if (objACGlobal.callingForm2 == "GIACS607"){
			new Ajax.Updater("otherModuleDiv", contextPath+ "/GIACCommSlipController?action=showCommSlip", {
				parameters : {
					gaccTranId : objACGlobal.gaccTranId,
					page : 1
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading OR Preview...");
				},
				onComplete : function() {
					hideNotice("");
					$("otherModuleDiv").show();
					$("processPremAndCommDiv").hide();
				}
			});
		}else{
			showCommSlip();
		}
	});
	
	function sameCommSlip(y){
		var commSlipNo;
		var mtgNum = objACGlobal.callingForm2 == "GIACS607" ? 3 : 1;; 
		var mtgCommSlip;
		var commSlipIndex = tableGrid.getColumnIndex('commissionSlipNo');
		
		commSlipNo = tableGrid.rows[y][commSlipIndex] == null || tableGrid.rows[y][commSlipIndex] == "" ?
				"0" : tableGrid.rows[y][commSlipIndex];	
		
		//check or uncheck same CommSlipNo
		for (var i=0; i<tableGrid.rows.length; i++) {			
			mtgCommSlip = $("mtgIC"+ mtgNum + "_" + commSlipIndex +","+ i).innerHTML;	
			if(mtgCommSlip == commSlipNo){
				if(tableGrid.rows[y][tableGrid.getColumnIndex('prFlag')] == 'Y'){
					$("mtgInput" + mtgNum + "_"+tableGrid.getColumnIndex("prFlag")+','+i).checked = true;
					tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'Y';
				}else{
					$("mtgInput" + mtgNum + "_"+tableGrid.getColumnIndex("prFlag")+','+i).checked = false;
					tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'N';
				}
			}
		}
	}
	
	function tagRecords(){
		if(recordsTagged == 0) {
			$$("div#commSlipTable' select, input[type='checkBox']").each(function(row) {
				row.checked = true;
			});
			for (var i=0; i<tableGrid.rows.length; i++) {
				tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'Y';
			}
			recordsTagged = 1;
		} else {
			$$("div#commSlipTable' select, input[type='checkBox']").each(function(row) {
				row.checked = false;
			});
			for (var i=0; i<tableGrid.rows.length; i++) {
				tableGrid.rows[i][tableGrid.getColumnIndex('prFlag')] = 'N';
			}
			recordsTagged = 0;
		}
	}
	//nieko end
</script>
	