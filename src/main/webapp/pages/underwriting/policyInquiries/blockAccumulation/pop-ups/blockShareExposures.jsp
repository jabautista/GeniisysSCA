<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<table align="center" style="padding: 5px 0 15px 0;">
			<tr>
				<td class="rightAligned">District No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtShareDistrictNo" readonly="readonly" style="width: 70px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Block No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareBlockNo" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtShareBlockDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned" style="padding-left: 80px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Risk </td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareRiskCd" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtShareRiskDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtShareTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 100%">
		<div id="shareExposuresTableDiv" style="padding: 10px 0 0 5px;">
			<div id="shareExposuresDiv" style="height: 290px; width:100%; float: left;">
				<div id="shareExposuresTable" style="height: 152px; padding: 0 30px 0 30px;"></div>
				<div id="shareExposuresInnerDiv">
					<table align="right" style="border-collapse:collapse; margin: 0 36px 0 0;" >
						<tr valign="bottom">
							<td><input type="text" id="txtShareActualSum" style="width: 164px; text-align: right;" readonly="readonly"/></td>
							<td><input type="text" id="txtShareTempSum" style="width: 164px; text-align: right;" readonly="readonly"/></td>
							<td><input type="text" id="txtShareSumTotal" style="width: 164px; text-align: right;" readonly="readonly"/></td>
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
				<div class="buttonDiv"align="center" style="padding: 95px 0 10px 0;">
					<input type="button" id="btnShareReturn" class="button" value="Return" style="width: 100px;"/>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	initializeAll();
 	try {
		var jsonShareExposures = JSON.parse('${jsonShareExposures}');
		var rvLowValue = '${rvLowValue}';
		var shareMode = '${shareMode}';
		shareExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showBlockShareExposures&refresh=1&exclude="+objUWGlobal.hidGIPIS110Obj.excludeExpired
																					            +"&excludeNotEff="+objUWGlobal.hidGIPIS110Obj.excludeNotEff
																					            +"&rvLowValue="+rvLowValue
																					            +"&blockId="+objUWGlobal.hidGIPIS110Obj.selectedObj.blockId
																					            +"&districtNo="+objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo
																					            +"&blockNo="+objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo
																					            +"&provinceCd="+objUWGlobal.hidGIPIS110Obj.selectedObj.provinceCd
																					            +"&city="+objUWGlobal.hidGIPIS110Obj.selectedObj.city
																					            +"&riskCd="+objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd,
	  		id : "GIPIS110ShareExposures",																							  
			options : {
				hideColumnChildTitle: true,
				width : '849px',
				height : '156px',
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
			    	geniisysClass: 'money'
// 			    	renderer: function(value){
// 			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
// 			    	}
			    },
			    {
			    	id:'temporary',
			    	title: 'Temporary Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: 'money'
// 			    	renderer: function(value){
// 			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
// 			    	}
			    },
			    {
			    	id:'expoSum',
			    	title: 'Total Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: 'money'
// 			    	renderer: function(value){
// 			    		return nvl(value,'') == '' ? '0.00' : formatCurrency(nvl(value, 0));
// 			    	}
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
		}
		$("txtShareActualSum").value = formatCurrency(actualTotal);
		$("txtShareTempSum").value = formatCurrency(tempTotal);
		$("txtShareSumTotal").value = formatCurrency(sumTotal);
		$("txtShareDistrictNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,""));
		$("txtShareBlockNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,""));
		$("txtShareBlockDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockDesc,""));
		$("txtShareRiskCd").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd,""));
		$("txtShareRiskDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc,""));
		$("txtShareRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,""));
		$("txtShareTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,""));
	}
	
	$("btnShareReturn").observe("click",function(){
		$("blockAccumulationBodyDiv").hide();
		$("blockAccumulationBodyDiv2").show();
		$("blockAccumulationBodyDiv3").hide();
		$("blockAccumulationBodyDiv4").hide();
		$("blockAccumulationBodyDiv5").hide();
	});
	
	//for breakdown...
	$("btnShareActualBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = false;
		objUWGlobal.hidGIPIS110Obj.showGipis110ActualExposures(rvLowValue, "N", "ITEM");
	});
	$("btnShareActualList").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = true;
		objUWGlobal.hidGIPIS110Obj.showGipis110ActualExposures(rvLowValue, "N", "ITEM");
	});
	$("btnShareTempBreakdown").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = false;
		objUWGlobal.hidGIPIS110Obj.showGipis110TemporaryExposures(rvLowValue, "N", "ITEM");
	});
	$("btnShareTempList").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = true;
		objUWGlobal.hidGIPIS110Obj.showGipis110TemporaryExposures(rvLowValue, "N", "ITEM");
	});
</script>