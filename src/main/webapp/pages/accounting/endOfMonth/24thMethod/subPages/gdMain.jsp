<!--
--Created by: Gzelle 
--	Date: 05.14.2013
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="gdMainTableDiv" name="gdMainTableDiv" style="height: 310px; margin-bottom: 10px;">
	<div id="gdMainTable" name="gdMainTable"></div>
</div>
<script type="text/javascript">
try {
	var column;
	var jsonGdMain = JSON.parse('${gdMain}');
	function initializeMainTableGrid() {
		if (objGiacs044.table == "gdGross") {									
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '65px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '65px',
							filterOption : true
						},
						{
							id : "premAmt",
							title : "Premium",
							width : '125px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defPremAmt",
							title : "Deferred Premium",
							width : '135px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "prevDefPremAmt",
							title : "Prev. Deferred Premium",
							altTitle : "Previous Deferred Premium",
							width : '160px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defPremAmtDiff",
							title : "Deferred Difference",
							width : '140px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '80px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '90px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;
		}else if (objGiacs044.table == "gdRiCeded") {									
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '58px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '55px',
							filterOption : true
						},
		 				{
		 					id : "shareType",
		 					title : "Share",
		 					width : '55px',
		 					filterOption : true
	 					},						
						{
							id : "distPrem",
							title : "Distribution Prem.",
							altTitle : "Distribution Premium",
							width : '120px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defDistPrem",
							title : "Def. Dist. Premium",
							altTitle : "Deferred Distribution Premium",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "prevDefDistPrem",
							title : "Prev. Def. Dist. Prem.",
							altTitle : "Previous Deferred Distribution Premium",
							width : '150px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defDistPremDiff",
							title : "Deferred Difference",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '73px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '88px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;				
		}else if (objGiacs044.table == "gdInc") {									
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '58px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '55px',
							filterOption : true
						},
		 				{
		 					id : "shareType",
		 					title : "Share",
		 					width : '55px',
		 					filterOption : true
	 					},						
						{
							id : "commIncome",
							title : "Comm. Income",
							altTitle : "Commission Income",
							width : '120px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defCommIncome",
							title : "Def. Comm. Income",
							altTitle : "Deferred Commission Income",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "prevDefCommIncome",
							title : "Prev. Def. Comm. Incm.",
							altTitle : "Previous Deferred Commission Income",
							width : '150px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defCommIncomeDiff",
							title : "Deferred Difference",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '73px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '88px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;			
		}else if (objGiacs044.table == "gdNetPrem") {								
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '81px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '81px',
							filterOption : true
						},					
						{
							id : "grossPrem",
							title : "Gross Premium",
							width : '160px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "totalRiCeded",
							title : "Premium Ceded",
							width : '160px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "netPrem",
							title : "Net Premium",
							width : '175px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '100px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '105px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;			
		}else if (objGiacs044.table == "gdRetrocede") {									
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '58px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '55px',
							filterOption : true
						},
		 				{
		 					id : "shareType",
		 					title : "Share",
		 					width : '55px',
		 					filterOption : true
	 					},						
						{
							id : "distPrem",
							title : "Distribution Prem.",
							altTitle : "Distribution Premium",
							width : '120px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defDistPrem",
							title : "Def. Dist. Premium",
							altTitle : "Deferred Distribution Premium",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "prevDefDistPrem",
							title : "Prev. Def. Dist. Prem.",
							altTitle : "Previous Deferred Distribution Premium",
							width : '150px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defDistPremDiff",
							title : "Deferred Difference",
							width : '130px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '73px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '88px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;						
		}else if (objGiacs044.table == "gdExp") {								
					column = [
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
							id : "issCd",
							title : "Branch",
							width : '65px',
							filterOption : true
						},
						{
							id : "lineCd",
							title : "Line",
							width : '65px',
							filterOption : true
						},					
						{
							id : "commExpense",
							title : "Comm. Expense",
							altTitle : "Commission Expense",
							width : '120px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defCommExpense",
							title : "Def. Comm. Expense",
							altTitle : "Deferred Commission Expense",
							width : '140px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "prevDefCommExpense",
							title : "Prev. Def. Comm. Expense",
							altTitle : "Previous Deferred Commission Expense",
							width : '160px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "defCommExpenseDiff",
							title : "Deferred Difference",
							width : '135px',
							align : 'right',
							titleAlign : 'right',
							filterOption : true,
							filterOptionType: 'number',
							geniisysClass: 'money'
						},
						{
							id : "userId",
							title : "User ID",
							width : '80px',
							filterOption : true
						},
						{
							id : "lastUpdate",
							title : "Last Update",
							width : '95px',
							align : 'center',
							titleAlign : 'center',
							filterOption : true,
							renderer : function(value){
								return dateFormat(value, 'mm-dd-yyyy');
							}
						}
					]
					;				
		}
	}
	
	initializeMainTableGrid();
	
	gdMainTableModel = {
			url : contextPath+"/GIACDeferredController?action=getGdMain&refresh=1&year=" + objGiacs044.year + "&mM=" + objGiacs044.mM + "&procedureId=" + objGiacs044.procedureId
								+ "&table=" + objGiacs044.table,
			options: {
				width: '900px',
				height: '275px',
				onCellFocus : function(element, value, x, y, id) {
					objGiacs044.lineCd = gdMainTableGrid.geniisysRows[y].lineCd;
					objGiacs044.issCd = gdMainTableGrid.geniisysRows[y].issCd;
					objGiacs044.shrType = gdMainTableGrid.geniisysRows[y].shrType;
					objGiacs044.compSw = gdMainTableGrid.geniisysRows[y].compSw; //mikel 02.26.2016 GENQA 5288
					gdMainTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					objGiacs044.lineCd = "";
					objGiacs044.issCd = "";
					gdMainTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					objGiacs044.lineCd = "";
					objGiacs044.issCd = "";
					gdMainTableGrid.keys.releaseKeys();
				},
				prePager: function() {
					objGiacs044.lineCd = "";
					objGiacs044.issCd = "";
					gdMainTableGrid.keys.releaseKeys();
				},
				onRefresh: function() {
					objGiacs044.lineCd = "";
					objGiacs044.issCd = "";
					gdMainTableGrid.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function() {
						objGiacs044.lineCd = "";
						objGiacs044.issCd = "";
						gdMainTableGrid.keys.releaseKeys();
					}			
				}
			},									
			columnModel: column,
			rows: jsonGdMain.rows
		};
	
	gdMainTableGrid = new MyTableGrid(gdMainTableModel);
	gdMainTableGrid.pager = jsonGdMain;
	gdMainTableGrid.render('gdMainTable');
	gdMainTableGrid.afterRender = function(y) {
		setParamsField(gdMainTableGrid.geniisysRows[0]);
		objGiacs044.extractCount = gdMainTableGrid.geniisysRows.length;
	};			

	function setParamsField(obj) {
		$("txtPeriodMonth").value 		= obj == null ? "" : obj.mM;
		$("txtPeriodYear").value 		= obj == null ? "" : obj.year;
		$("txtMethod").value 			= obj == null ? "" : obj.procedureDesc;
		$("txtNumeratorFactor").value 	= obj == null ? "" : obj.numeratorFactor;
		$("txtDenominatorFactor").value = obj == null ? "" : obj.denominatorFactor;
	}
	
} catch (e) {
	showMessageBox("Error in 24thMethod GDMain tablegrid: " + e, imgMessage.ERROR);		
}
</script>