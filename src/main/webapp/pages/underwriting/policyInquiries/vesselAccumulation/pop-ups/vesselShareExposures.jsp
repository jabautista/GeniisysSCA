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
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareVesselCd"  readonly="readonly" style="width: 120px"/></td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareVesselName" readonly="readonly" style="width: 580px"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 99.5%">
		<div id="shareExposuresTableDiv" style="padding: 10px 0 0 5px;">
			<div id="shareExposuresDiv" style="height: 240px; width:100%; float: left;">
				<div id="shareExposuresTable" style="height: 146px; padding: 0 10px 0 10px;"></div>
				<div id="shareExposuresInnerDiv" style= "padding: 0 10px 0 10px;">
					<table align="right">
						<tr>
							<td><input type="text" id="txtShareActualSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
							<td><input type="text" id="txtShareTempSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
							<td><input type="text" id="txtShareSumTotal" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnShareActualBreakdown" class="button2" value="Breakdown" style="width: 172px;"/></td>
							<td colspan="2"><input type="button" id="btnShareTempBreakdown" class="button2" value="Breakdown" style="width: 172px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnShareActualList" class="button2" value="List" style="width: 172px;"/></td>
							<td colspan="2"><input type="button" id="btnShareTempList" class="button2" value="List" style="width: 172px;"/></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="buttonDiv"align="center" style="padding: 330px 0 10px 0;">
		<input type="button" id="btnShareReturn" class="button" value="Return" style="width: 100px;"/>
	</div>
</div>
<script>
	initializeAll();
 	try {
		var jsonShareExposures = JSON.parse('${jsonShareExposures}');
		var rvLowValue = '${rvLowValue}';
		var shareMode = '${shareMode}';
		var shareCd = null;
		shareExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showShareExposures&refresh=1&vesselCd=" + objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd 
																										  + "&rvLowValue=" + rvLowValue 
																										  + "&excludeExpired=" + objUWGlobal.hidGIPIS109Obj.excludeExpired
																										  + "&excludeNotEff=" + objUWGlobal.hidGIPIS109Obj.excludeNotEff,
	  		id : "GIPIS109ShareExposures",																							  
			options : {
				hideColumnChildTitle: true,
				width : '849px',
				height : '150px',
				columnResizable : false,
				onCellFocus : function(element, value, x, y, id) {
					tbgShareExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgShareExposures.keys.releaseKeys();
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
			    	id:'lineCd',
			    	title: 'Line',
			    	width: '143px'
			    },
			    {
			    	id:'trtyName',
			    	title: shareMode,
			    	width: '180px'
			    },
			    {
			    	id:'actual',
			    	title: 'Actual Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
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
			    	renderer: function(value){
			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
			    	}
			    }
			],
			rows : jsonShareExposures.rows
		};
		tbgShareExposures = new MyTableGrid(shareExposuresTableModel);
		tbgShareExposures.pager = false;
		tbgShareExposures.render('shareExposuresTable');
		tbgShareExposures.afterRender = function(){
					populateShareExposuresTotal();
				};
	} catch (e) {
		showErrorMessage("exposuresTableModel", e);
	} 
	
	function populateShareExposuresTotal() {
		var actualTotal = 0;
		var tempTotal = 0;
		var sumTotal = 0;
		for ( var i = 0; i < tbgShareExposures.geniisysRows.length; i++) {
			actualTotal = actualTotal + parseFloat(nvl(tbgShareExposures.geniisysRows[i].actual,0));
			tempTotal = tempTotal + parseFloat(nvl(tbgShareExposures.geniisysRows[i].temporary,0));
			sumTotal = sumTotal + parseFloat(nvl(tbgShareExposures.geniisysRows[i].expoSum,0));
			shareCd = tbgShareExposures.geniisysRows[i].shareCd;
		}
		$("txtShareActualSum").value = formatCurrency(actualTotal);
		$("txtShareTempSum").value = formatCurrency(tempTotal);
		$("txtShareSumTotal").value = formatCurrency(sumTotal);
		$("txtShareVesselCd").value = objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd;
		$("txtShareVesselName").value = unescapeHTML2(objUWGlobal.hidGIPIS109Obj.selectedObj.vesselName); //benjo 10.12.2015 added unescapeHTML2 GENQA-SR-5049
	}
	
	$("btnShareReturn").observe("click",function(){
		overlayShareExposures.close();
	});
	
	//for breakdown...
	$("btnShareActualBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = false;
		objUWGlobal.hidGIPIS109Obj.showActualExposuresOverlay(shareCd, "N");
	});
	$("btnShareActualList").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = true;
		objUWGlobal.hidGIPIS109Obj.showActualExposuresOverlay(shareCd, "N");
	});
	$("btnShareTempBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = false;
		objUWGlobal.hidGIPIS109Obj.showTemporaryExposuresOverlay(shareCd,"N");
	});
	$("btnShareTempList").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = true;
		objUWGlobal.hidGIPIS109Obj.showTemporaryExposuresOverlay(shareCd,"N");
	});
	
</script>