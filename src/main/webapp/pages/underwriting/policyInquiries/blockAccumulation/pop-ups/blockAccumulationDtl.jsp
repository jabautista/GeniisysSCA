<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<!--
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<table align="center" style="padding: 5px 0 15px 0;">
			<tr>
				<td class="rightAligned">District No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtDistrictNo" readonly="readonly" style="width: 70px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Block No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtBlockNo" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtBlockDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned" style="padding-left: 80px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Risk </td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtRiskCd" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtRiskDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	-- nieko 07132016 KB 894
	--> 
	<!-- nieko 07132016 KB 894-->
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<div id="retAndtrtyLimit">
			<table>
				<tr>
					<td class="rightAligned" style="padding: 0 0 0 5px;">Retention Limit</td>
					<td class="leftAligned" style="padding: 5px 0 0 5px;"><input type="text" id="txtRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
					<td class="rightAligned" style="padding-left: 80px;">Treaty Limit</td>
					<td class="leftAligned" style="padding: 5px 0 0 5px;"><input type="text" id="txtTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
				</tr>
			</table>
		</div>
		<div id="blockRiskTable" style="height: 130px; padding: 10px 0 0 10px;"></div>
	</div>
	<!-- nieko 07132016 -->
	<div id="blockAccumulationDtlDiv">
		<div class="sectionDiv" style="width: 100%;">
			<div id="exposuresTableDiv" style="padding: 10px 0 0 5px;">
				<div id="exposuresLeftDiv" style="width:20%; float: left;">
					<table align="right" style="margin:25px 0 0 0; border-collapse:collapse;">
						<tr>
							<td><input type="button" id="btnNetRetention" class="button2" value="Net Retention" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnTreaty" class="button2" value="Treaty" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnFacultative" class="button2" value="Facultative" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnRiskTotal" class="button2" value="Risk Total" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnBlockTotal" class="button2" value="Block Total" style="width: 150px;"/></td>
						</tr>
					</table>
				</div>
				<div id="exposuresRightDiv" style="height: 270px; width:70%; float: left;">
					<div id="exposuresTable" style="height: 155px;"></div>
					<div id="exposuresInnerRightDiv">
						<table align="left" style="border-collapse:collapse; margin-left: 174px;">
							<tr>
								<td align="right"><input type="button" id="btnActualBreakdown" class="button2" value="Breakdown" style="width: 171px;"/></td>
								<td><input type="button" id="btnTempBreakdown" class="button2" value="Breakdown" style="width: 171px;"/></td>
							</tr>
							<tr>
								<td align="right"><input type="button" id="btnActualList" class="button2" value="List" style="width: 171px;"/></td>
								<td><input type="button" id="btnTempList" class="button2" value="List" style="width: 171px;"/></td>
							</tr>
						</table>
					</div>
					<div class="buttonDiv"align="center" style="padding: 70px 0 10px 0;">
						<input type="button" id="btnPrint" class="button" value="Print" style="width: 100px;"/>
						<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	initializeAll();
	objUWGlobal.hidGIPIS110Obj.isListExposure = false;
	
 	try {
		//var jsonExposures = JSON.parse('${jsonExposures}'); //nieko 07132016 kb 894
		var reports = [];
		exposuresTableModel = {
			//url : contextPath+ "/GIPIPolbasicController?action=showBlockAccumulationDtl&refresh=1", //nieko 07132016 kb 894
	  		id : "GIPIS110Exposures",																  //nieko 07132016 kb 894																	  
			options : {
				width : '694px',
				height : '156px',
				columnResizable : false,
				onCellFocus : function(element, value, x, y, id) {
					tbgExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgExposures.keys.releaseKeys();
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
			    	id:'manual',
			    	title: 'Manual Beginning',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'actual',
			    	title: 'Actual Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'temporary',
			    	title: 'Temporary Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'expoSum',
			    	title: 'Total Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    }
			],
			//rows : jsonExposures.rows
			rows : [] //nieko 07132016 kb 894
		};
		tbgExposures = new MyTableGrid(exposuresTableModel);
		tbgExposures.pager = false;
		tbgExposures.render('exposuresTable');
		/*tbgExposures.afterRender = function(){
			populateExposuresTotal();
		};*///nieko 07132016 kb 894
	} catch (e) {
		showErrorMessage("exposuresTableModel", e);
	} 
	
	function populateExposuresTotal() {
		objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd = "";
		objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc = "";
		var msgFlag1 = 'YY';
		var msgFlag2 = 'YY';
		disableButton2("btnNetRetention");
		disableButton2("btnTreaty");
		disableButton2("btnFacultative");
		for ( var i = 0; i < tbgExposures.geniisysRows.length; i++) {
			if (i == 0) {
				objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd = tbgExposures.geniisysRows[i].riskCd;
				objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc = tbgExposures.geniisysRows[i].riskDesc;
			}
			if(tbgExposures.geniisysRows[i].expoSum > 0){
				if (i == 0) {
					enableButton2("btnNetRetention");
				     if (parseFloat(nvl(tbgExposures.geniisysRows[i].expoSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt, 0))) {
						$("mtgICGIPIS110Exposures_5,0").style.color = 'red';
						msgFlag1 = 'OO';
					} else {
						msgFlag1 = 'YY';
					}
				} else if(i == 1) {
					enableButton2("btnTreaty");
					 if (parseFloat(nvl(tbgExposures.geniisysRows[i].expoSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt, 0))) {
						$("mtgICGIPIS110Exposures_5,1").style.color = 'red';
						msgFlag2 = 'OO';
					} else {
						msgFlag2 = 'YY';
					}
				}else if (i ==2){
					enableButton2("btnFacultative");
				}
			}
		}
		
		$("txtDistrictNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,""));
		$("txtBlockNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,""));
		$("txtBlockDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockDesc,""));
		$("txtRiskCd").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd,""));
		$("txtRiskDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc,""));
		$("txtRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,""));
		$("txtTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,""));
		
		if (nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,"") == "" && nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,"") == "") {
	    	showMessageBox("Retention limit and Treaty limit not specified for this district.","I");
	    	return;
		} else if(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,"") == "") {
			showMessageBox("Treaty limit not specified for this district.","I");
			return;
		}else if (nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,"") == "" ){
			showMessageBox("Retention limit not specified for this district.","I");
			return;
		}
		
		if (msgFlag1 == "OO" && msgFlag2 == "OO") {
			showMessageBox("Retention Limit and Treaty limit have been exceeded for this district.","I");
		} else if(msgFlag1 == "OO" && msgFlag2 == "YY") {
			showMessageBox("Retention Limit has been exceeded for this district.","I");
		} else if(msgFlag1 == "YY" && msgFlag2 == "OO") {
			showMessageBox("Treaty Limit has been exceeded for this district.","I");
		}
	}
	
	function showGipis110ActualExposures(shareType,all,mode) {
 		try{
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showGipis110ActualExposures",
			 				   exclude : objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeExpired,
			 				   excludeNotEff : objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeNotEff,
			 				   shareType : shareType,
			 				   blockId : objUWGlobal.hidGIPIS110Obj.selectedObj.blockId,
			 				   all : all,
						       mode : mode,
						       riskCd : objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd //nieko 07132016 kb 894, added riskCd parameter
		                  },
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)  && checkCustomErrorOnResponse(response)){
 						$("blockAccumulationBodyDiv").hide();
 						$("blockAccumulationBodyDiv2").hide();
 						$("blockAccumulationBodyDiv4").hide();
 						$("blockAccumulationBodyDiv5").hide();
 						$("blockAccumulationBodyDiv3").update(response.responseText);
 						$("blockAccumulationBodyDiv3").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showGipis110ActualExposures", e);
 		}
 	}
	objUWGlobal.hidGIPIS110Obj.showGipis110ActualExposures = showGipis110ActualExposures;
	
	function showGipis110TemporaryExposures(shareType,all,mode) {
 		try{
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showGipis110TemporaryExposures",
			 				   exclude : objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeExpired,
				 		       excludeNotEff : objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeNotEff,
				 			   shareType : shareType,
				 		       blockId : objUWGlobal.hidGIPIS110Obj.selectedObj.blockId,
				 		       all : all,
							   mode : mode,
							   riskCd : objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd //nieko 07132016 kb 894, added riskCd parameter
	                    },
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)  && checkCustomErrorOnResponse(response)){
 						$("blockAccumulationBodyDiv").hide();
 						$("blockAccumulationBodyDiv2").hide();
 						$("blockAccumulationBodyDiv3").hide();
 						$("blockAccumulationBodyDiv5").hide();
 						$("blockAccumulationBodyDiv4").update(response.responseText);
 						$("blockAccumulationBodyDiv4").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showGipis110TemporaryExposures", e);
 		}
 	}
	objUWGlobal.hidGIPIS110Obj.showGipis110TemporaryExposures = showGipis110TemporaryExposures;
	
	function showBlockShareExposures(mode) {
		try{
			var rvLowValue = "";
			if (tbgExposures.geniisysRows.length >= 3) {
				if (mode == "Net Retention") {
					rvLowValue = tbgExposures.geniisysRows[0].rvLowValue;
				} else if(mode == "Treaty") {
					rvLowValue = tbgExposures.geniisysRows[1].rvLowValue;
				}else if (mode == "Facultative"){
					rvLowValue = tbgExposures.geniisysRows[2].rvLowValue;
				}
			}
			
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showBlockShareExposures",
			                   shareMode : mode,
			                   exclude : objUWGlobal.hidGIPIS110Obj.excludeExpired,
			                   excludeNotEff : objUWGlobal.hidGIPIS110Obj.excludeNotEff,
			                   rvLowValue : rvLowValue,
			                   blockId : objUWGlobal.hidGIPIS110Obj.selectedObj.blockId,
			                   districtNo : objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,
			                   blockNo : objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,
			                   provinceCd : objUWGlobal.hidGIPIS110Obj.selectedObj.provinceCd,
			                   city : objUWGlobal.hidGIPIS110Obj.selectedObj.city,
			                   riskCd : objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd
	                    },
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)){
 						$("blockAccumulationBodyDiv").hide();
 						$("blockAccumulationBodyDiv2").hide();
 						$("blockAccumulationBodyDiv3").hide();
 						$("blockAccumulationBodyDiv4").hide();
 						$("blockAccumulationBodyDiv5").update(response.responseText);
 						$("blockAccumulationBodyDiv5").show();
 						
 					}
 				}
 			});
		}catch (e) {
			showErrorMessage("showBlockShareExposures",e);
		}
	}
	
	function printGIPIR110() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR110"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&reportId=GIPIR110"
			+"&excludeExpired="+objUWGlobal.hidGIPIS110Obj.excludeExpired	
			+"&excludeNotEff="+objUWGlobal.hidGIPIS110Obj.excludeNotEff	
			+"&fileType="+fileType;	
			printGenericReport(content, "BLOCK ACCUMULATION REPORT",null);
		} catch (e) {
			showErrorMessage("printGIPIR110",e);
		}
	}
	
	$("btnReturn").observe("click",function(){
		$("blockAccumulationBodyDiv").show();
		$("blockAccumulationBodyDiv2").hide();
		$("blockAccumulationBodyDiv3").hide();
		$("blockAccumulationBodyDiv4").hide();
		$("blockAccumulationBodyDiv5").hide();
	});
	
	$("btnPrint").observe("click", function(){
		showGenericPrintDialog("Print Block Accumulation", printGIPIR110, null, true);
	});
	
	//for share exposures...
	$("btnNetRetention").observe("click",function(){
		showBlockShareExposures("Net Retention");
	});
	
	$("btnTreaty").observe("click",function(){
		showBlockShareExposures("Treaty");
	});
	
	$("btnFacultative").observe("click",function(){
		showBlockShareExposures("Facultative");
	});
	
	//for breakdown...
	$("btnActualBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = false;
		showGipis110ActualExposures(null, "Y", "ITEM");
	});
	$("btnActualList").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = true;
		showGipis110ActualExposures(null, "Y", "ITEM");
	});
	$("btnTempBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = false;
		showGipis110TemporaryExposures(null, "Y", "ITEM");
	});
	$("btnTempList").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = true;
		showGipis110TemporaryExposures(null, "Y", "ITEM");
	});
	
	//nieko 07132016 KB 894
	
	var objBlockRisk = {};	
	var selectedBlockRiskRow = null;
	var blockId = objUWGlobal.hidGIPIS110Obj.selectedObj.blockId;
	
	var selectedBlockRiskRow = new Object();
	var selectedBlockGlobal  = new Object();
	
    try {
    	objBlockRisk.jsonBlockRisk = JSON.parse('${jsonBlockRisk}');
    	
        var blockRiskTableModel = { 
        		url : contextPath+ "/GIPIPolbasicController?action=showBlockAccumulationDtl&refresh=1&blockId="+blockId,	
            options : {
                width : '900px',
                height : '125px',
                columnResizable : false,
                onCellFocus : function(element, value, x, y, id) {
                	showBlockRiskDtlTable(tbgBlockRisk.geniisysRows[y]);
                	
                	tbgBlockRisk.keys.removeFocus(tbgBlockRisk.keys._nCurrentFocus, true);
                	tbgBlockRisk.keys.releaseKeys();
                },
                onRemoveRowFocus : function(element, value, x, y, id) {
                	tbgBlockRisk.keys.removeFocus(tbgBlockRisk.keys._nCurrentFocus, true);
                	tbgBlockRisk.keys.releaseKeys();
                },
                onSort: function(){
                	tbgBlockRisk.keys.removeFocus(tbgBlockRisk.keys._nCurrentFocus, true);
                	tbgBlockRisk.keys.releaseKeys();
				},
            },
            columnModel : [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				}, 
				{
					id:'blockId',
					title: '',
				    width: '0',
				    visible: false
				},
                {
			    	id:'districtNo',
			    	title: 'District No',
			    	width: '150px',
			    	align: 'left',
			    	sortable: true,
			    	titleAlign: 'left'
			    },
                {
			    	id:'blockNo',
			    	title: 'Block No',
			    	width: '150px',
			    	align: 'left',
			    	sortable: false,
			    	titleAlign: 'left'
			    },
                {
			    	id:'riskCd',
			    	title: 'Risk Code',
			    	width: '150px',
			    	align: 'left',
			    	sortable: false,
			    	titleAlign: 'left'
			    },
                {
			    	id:'riskDesc',
			    	title: 'Risk Description',
			    	width: '250px',
			    	align: 'left',
			    	sortable: false,
			    	titleAlign: 'left'
			    },
			    {
			    	id:'retnLimAmt',
			    	title: 'Retention Limit',
			    	/*width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'*/
			    	visible : false
			    },
			    {
			    	id:'trtyLimAmt',
			    	title: 'Treaty Limit',
			    	/*width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'*/
			    	visible : false
			    }
            ], rows: objBlockRisk.jsonBlockRisk.rows
        };
        tbgBlockRisk = new MyTableGrid(blockRiskTableModel);
		tbgBlockRisk.pager = false;
		tbgBlockRisk.render('blockRiskTable');
		tbgBlockRisk.afterRender = function(){
			tbgBlockRisk.selectRow(0);
			showBlockRiskDtlTable(tbgBlockRisk.geniisysRows[0]);
		};
		
    } catch (e) {
        showErrorMessage("blockRiskTableModel", e);
    }
    
    function showBlockRiskDtlTable(rec){
    	try{
    		selectedBlockRiskRow = rec;                	
    		selectedBlockGlobal  = objUWGlobal.hidGIPIS110Obj.selectedObj;
    		
    		var blockId 		= selectedBlockGlobal.blockId;
    		var excludeNotEff	= objUWGlobal.hidGIPIS110Obj.excludeNotEff;
    		var exclude			= objUWGlobal.hidGIPIS110Obj.excludeExpired;
    		var districtNo	    = selectedBlockGlobal.districtNo;
    		var blockNo			= selectedBlockGlobal.blockNo;
    		var provinceCd		= selectedBlockGlobal.provinceCd;
    		var city			= selectedBlockGlobal.city;
    		var riskCd			= selectedBlockRiskRow.riskCd;
    		var busType			= objUWGlobal.hidGIPIS110Obj.busType;
    		
        	//alert("riskCd :" + blockId + " ^ " + excludeNotEff + " ^ " + exclude + " ^ " + districtNo + " ^ " + blockNo + " ^ " + provinceCd + " ^ " + city + " ^ " + riskCd);
    		
        	tbgExposures.url = contextPath + "/GIPIPolbasicController?action=showBlockRiskDtl"+
        					   "&blockId="+blockId+
        					   "&excludeNotEff="+excludeNotEff+
        					   "&exclude="+exclude+
        					   "&districtNo="+districtNo+
        					   "&blockNo="+blockNo+
        					   "&provinceCd="+provinceCd+
        					   "&city="+city+
        					   "&riskCd="+riskCd+
        					   "&busType="+busType;
        	tbgExposures._refreshList();
        	
        	populateExposuresTotal2(tbgExposures.geniisysRows);
    	}catch(e){
    		showErrorMessage("showBlockRiskDtlTable",e);
    	}
    }
    
    function populateExposuresTotal2(rec) {
		try{
			objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd = "";
			objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc = "";
			
	    	var msgFlag1 = 'YY';
			var msgFlag2 = 'YY';
			disableButton2("btnNetRetention");
			disableButton2("btnTreaty");
			disableButton2("btnFacultative");			
			for ( var i = 0; i < rec.length; i++) {
				if (i == 0) {
					objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd = tbgExposures.geniisysRows[i].riskCd;
					objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc = tbgExposures.geniisysRows[i].riskDesc;
				}
				if(rec[i].expoSum > 0){
					if (i == 0) {
						enableButton2("btnNetRetention");
					     if (parseFloat(nvl(rec[i].expoSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt, 0))) {
					    	$("mtgICGIPIS110Exposures_5,0").style.color = 'red';
							msgFlag1 = 'OO';
						} else {
							msgFlag1 = 'YY';
						}
					} else if(i == 1) {
						enableButton2("btnTreaty");
						 if (parseFloat(nvl(rec[i].expoSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt, 0))) {
							$("mtgICGIPIS110Exposures_5,1").style.color = 'red';
							msgFlag2 = 'OO';
						} else {
							msgFlag2 = 'YY';
						}
					}else if (i ==2){
						enableButton2("btnFacultative");
					}
				}
			}
			
			$("txtRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,""));
			$("txtTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,""));
			
			if (nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,"") == "" && nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,"") == "") {
		    	showMessageBox("Retention limit and Treaty limit not specified for this district.","I");
		    	return;
			} else if(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,"") == "") {
				showMessageBox("Treaty limit not specified for this district.","I");
				return;
			}else if (nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,"") == "" ){
				showMessageBox("Retention limit not specified for this district.","I");
				return;
			}
			
			if (msgFlag1 == "OO" && msgFlag2 == "OO") {
				showMessageBox("Retention Limit and Treaty limit have been exceeded for this district.","I");
			} else if(msgFlag1 == "OO" && msgFlag2 == "YY") {
				showMessageBox("Retention Limit has been exceeded for this district.","I");
			} else if(msgFlag1 == "YY" && msgFlag2 == "OO") {
				showMessageBox("Treaty Limit has been exceeded for this district.","I");
			}
		}
		catch(e){
			showErrorMessage("populateExposuresTotal2",e);
		}
	}
    
   disableButton2("btnRiskTotal");
   disableButton2("btnBlockTotal");
  //nieko 07132016 end
</script>