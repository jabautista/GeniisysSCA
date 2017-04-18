<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<div class="sectionDiv" align="center" style="width: 99.5%; margin-top: 2px;">
		<table align="center" style="padding: 15px 0 15px 0;">
			<tr>
				<td class="rightAligned">Vessel Name</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtVesselCd" readonly="readonly" style="width: 120px"/></td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtVesselName" readonly="readonly" style="width: 580px"/></td>
			</tr>
		</table>
	</div>
	<div id="vesselAccumulationDtlDiv">
		<div class="sectionDiv" style="width: 99.5%">
			<div id="exposuresTableDiv" style="padding: 10px 0 0 5px;">
				<div id="exposuresLeftDiv" style="width:30%; float: left;">
					<table align="right" style="margin:25px 0 0 0;">
						<tr>
							<td><input type="button" id="btnNetRetention" class="button2" value="Net Retention" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnTreaty" class="button2" value="Treaty" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnFacultative" class="button2" value="Facultative" style="width: 150px;"/></td>
						</tr>
						<tr align="right">
							<td height="22px" align="right">Totals</td>
						</tr>
					</table>
				</div>
				<div id="exposuresRightDiv" style="height: 220px; width:70%; float: left;">
					<div id="exposuresTable" style="height: 102px;"></div>
					<div id="exposuresInnerRightDiv">
						<table align="left">
							<tr>
								<td><input type="text" id="txtActualSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
								<td><input type="text" id="txtTempSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
								<td><input type="text" id="txtSumTotal" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
							</tr>
							<tr>
								<td><input type="button" id="btnActualBreakdown" class="button2" value="Breakdown" style="width: 172px;"/></td>
								<td><input type="button" id="btnTempBreakdown" class="button2" value="Breakdown" style="width: 172px;"/></td>
							</tr>
							<tr>
								<td><input type="button" id="btnActualList" class="button2" value="List" style="width: 172px;"/></td>
								<td><input type="button" id="btnTempList" class="button2" value="List" style="width: 172px;"/></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="buttonDiv"align="center" style="padding: 312px 0 10px 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
	</div>
</div>
<script>
	initializeAll();
	objUWGlobal.hidGIPIS109Obj.isListExposure = false;
 	try {
		var jsonExposures = JSON.parse('${jsonExposures}');
		exposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showVesselAccumulationDtl&refresh=1&vesselCd=" + objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd 
																										  + "&vesselName=" + objUWGlobal.hidGIPIS109Obj.selectedObj.vesselName 
																										  + "&busType=" + objUWGlobal.hidGIPIS109Obj.busType
																										  + "&excludeExpired=" + objUWGlobal.hidGIPIS109Obj.excludeExpired
																										  + "&excludeNotEff=" + objUWGlobal.hidGIPIS109Obj.excludeNotEff,
	  		id : "GIPIS109Exposures",																							  
			options : {
				hideColumnChildTitle: true,
				width : '522px',
				height : '106px',
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
			    	id:'actual',
			    	title: 'Actual Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'temporary',
			    	title: 'Temporary Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {
			    	id:'expoSum',
			    	title: 'Total Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    }
			],
			rows : jsonExposures.rows
		};
		tbgExposures = new MyTableGrid(exposuresTableModel);
		tbgExposures.pager = false;
		tbgExposures.render('exposuresTable');
		tbgExposures.afterRender = function(){
					populateExposuresTotal();
				};
	} catch (e) {
		showErrorMessage("exposuresTableModel", e);
	} 
	
	function populateExposuresTotal() {
		var actualTotal = 0;
		var tempTotal = 0;
		var sumTotal = 0;
		for ( var i = 0; i < tbgExposures.geniisysRows.length; i++) {
			actualTotal = actualTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].actual,0));
			tempTotal = tempTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].temporary,0));
			sumTotal = sumTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].expoSum,0));
			if(tbgExposures.geniisysRows[i].expoSum == 0){
				if (i == 0) {
					disableButton2("btnNetRetention");
				} else if(i == 1) {
					disableButton2("btnTreaty");
				}else if (i ==2){
					disableButton2("btnFacultative");
				}
			}
		}
		$("txtActualSum").value = formatCurrency(actualTotal);
		$("txtTempSum").value = formatCurrency(tempTotal);
		$("txtSumTotal").value = formatCurrency(sumTotal);
		$("txtVesselCd").value = objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd;
		$("txtVesselName").value = unescapeHTML2(objUWGlobal.hidGIPIS109Obj.selectedObj.vesselName); //benjo 10.12.2015 added unescapeHTML2 GENQA-SR-5049
	}
	
	function showShareExposuresOverlay(mode) {
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
			overlayShareExposures = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 title: mode + " Exposures",
					 urlParameters: {
		                    action : "showShareExposures",
		                    shareMode : mode,
		                    rvLowValue : rvLowValue,
		                    vesselCd : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd,
		                    excludeExpired : objUWGlobal.hidGIPIS109Obj.excludeExpired,
		                    excludeNotEff : objUWGlobal.hidGIPIS109Obj.excludeNotEff
		            },
					 height: 370,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showShareExposuresOverlay",e);
		}
	}
	
	function showActualExposuresOverlay(shareCd,all) {
		try{
			overlayActualExposures = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 urlParameters: {
		                    action : "showItemActualExposures",
		                    excludeExpired : objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeExpired,
		                    excludeNotEff : objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeNotEff,
		                    shareCd : shareCd,
		                    vesselCd : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd,
		                    mode : "ITEM",
		                    all : all
		            },
					 height: 565,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showActualExposuresOverlay",e);
		}
	}
	objUWGlobal.hidGIPIS109Obj.showActualExposuresOverlay = showActualExposuresOverlay;
	
	function showTemporaryExposuresOverlay(shareCd,all) {
		try{
			overlayTemporaryExposures = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 urlParameters: {
		                    action : "showItemTemporaryExposures",
		                    excludeExpired : objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeExpired,
		                    excludeNotEff : objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeNotEff,
		                    shareCd : shareCd,
		                    vesselCd : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd,
		                    mode : "ITEM",
		                    all : all
		            },
					 height: 565,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showTemporaryExposuresOverlay",e);
		}
	}
	objUWGlobal.hidGIPIS109Obj.showTemporaryExposuresOverlay = showTemporaryExposuresOverlay;
	
	$("btnReturn").observe("click",function(){
		overlayVesselAccumulationDtl.close();
	});
	
	//for share exposures...
	$("btnNetRetention").observe("click",function(){
		showShareExposuresOverlay("Net Retention");
	});
	
	$("btnTreaty").observe("click",function(){
		showShareExposuresOverlay("Treaty");
	});
	
	$("btnFacultative").observe("click",function(){
		showShareExposuresOverlay("Facultative");
	});
	
	//for breakdown...
	$("btnActualBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = false;
		showActualExposuresOverlay(null, "Y");
	});
	$("btnActualList").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = true;
		showActualExposuresOverlay(null, "Y");
	});
	$("btnTempBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = false;
		showTemporaryExposuresOverlay(null,"Y");
	});
	$("btnTempList").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = true;
		showTemporaryExposuresOverlay(null,"Y");
	});
	
</script>