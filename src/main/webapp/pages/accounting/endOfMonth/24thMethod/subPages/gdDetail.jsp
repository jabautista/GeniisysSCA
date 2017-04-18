<!--
--Created by: Gzelle 
--	Date: 05.22.2013
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
<div id="gdDtlTableDiv" name="gdDtlTableDiv" style="height: 310px;">
	<div id="gdDtlTable" name="gdDtlTable" style=""></div>
</div>
<script type="text/javascript">
try {	//toggles columns id per selected radio button
	var column;
	var jsonGdDtl = JSON.parse('${gdDtl}');
	function initializeDetailsTableGrid() {
		if (objGiacs044.procedureId != 3 && objGiacs044.compSw == "N")  { // mikel 02.26.2016 GENQA 5288
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
								id : "mM",
								title : "Month",
								width : '110px'
							},
							{
								id : "year",
								title : "Year",
								width : '90px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 55
									},
									{
										id : "denominatorFactor",
										width : 55
									}
								]
							},
							{
								id : "premAmt",
								title : "Premium",
								width : '145px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defPremAmt",
								title : "Deferred Premium",
								width : '150px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "mM",
								title : "Month",
								width : '90px'
							},
							{
								id : "year",
								title : "Year",
								width : '75px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 53
									},
									{
										id : "denominatorFactor",
										width : 53
									}
								]
							},
							{
								id : "shareType",
								title : "Share",
								width : '70px'
							},
							{
								id : "distPrem",
								title : "Distribution Premium",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defDistPrem",
								title : "Deferred Dist. Premium",
								altTitle : "Deferred Distribution Premium",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "mM",
								title : "Month",
								width : '90px'
							},
							{
								id : "year",
								title : "Year",
								width : '75px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 53
									},
									{
										id : "denominatorFactor",
										width : 53
									}
								]
							},
							{
								id : "shareType",
								title : "Share",
								width : '70px'
							},
							{
								id : "distPrem",
								title : "Distribution Premium",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defDistPrem",
								title : "Deferred Dist. Premium",
								altTitle : "Deferred Distribution Premium",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "mM",
								title : "Month",
								width : '90px'
							},
							{
								id : "year",
								title : "Year",
								width : '75px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 45
									},
									{
										id : "denominatorFactor",
										width : 45
									}
								]
							},
							{
								id : "shareType",
								title : "Share",
								width : '65px'
							},
							{
								id : "commIncome",
								title : "Commission Income",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defCommIncome",
								title : "Deferred Comm. Income",
								altTitle : "Deferred Commission Income",
								width : '155px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "mM",
								title : "Month",
								width : '110px'
							},
							{
								id : "year",
								title : "Year",
								width : '90px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 55
									},
									{
										id : "denominatorFactor",
										width : 55
									}
								]
							},
							{
								id : "commExpense",
								title : "Commission Expense",
								width : '150px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defCommExpense",
								title : "Def. Comm. Expense",
								altTitle : "Deferred Commission Expense",
								width : '150px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							}
						]
					    ;			
			}	
		}else if ((objGiacs044.procedureId == 1 && objGiacs044.compSw == "Y") || objGiacs044.procedureId == 3){ //mikel 02.26.2016 GENQA 5288
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
								id : "policyNo",
								title : "Policy/Endt Number",
								width : '150px'
							},
							{
								id : "effDate",
								title : "Eff Date",
								width : '70px'
							},
							{
								id : "expiryDate",
								title : "Exp Date",
								width : '70px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 35
									},
									{
										id : "denominatorFactor",
										width : 35
									}
								]
							},
							{
								id : "premAmt",
								title : "Premium",
								width : '120px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defPremAmt",
								title : "Deferred Premium",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "policyNo",
								title : "Policy/Endt Number",
								width : '120px'
							},
							{
								id : "effDate",
								title : "Eff Date",
								width : '60px'
							},
							{
								id : "expiryDate",
								title : "Exp Date",
								width : '60px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 30
									},
									{
										id : "denominatorFactor",
										width : 30
									}
								]
							},
							{
								id : "share",
								title : "Share",
								width : '50px'
							},
							{
								id : "distPrem",
								title : "Distribution Premium",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defDistPrem",
								title : "Deferred Dist. Prem.",
								altTitle : "Deferred Distribution Premium",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "policyNo",
								title : "Policy/Endt Number",
								width : '120px'
							},
							{
								id : "effDate",
								title : "Eff Date",
								width : '60px'
							},
							{
								id : "expiryDate",
								title : "Exp Date",
								width : '60px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 30
									},
									{
										id : "denominatorFactor",
										width : 30
									}
								]
							},
							{
								id : "share",
								title : "Share",
								width : '50px'
							},
							{
								id : "distPrem",
								title : "Distribution Premium",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defDistPrem",
								title : "Deferred Dist. Prem.",
								altTitle : "Deferred Distribution Premium",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "policyNo",
								title : "Policy/Endt Number",
								width : '120px'
							},
							{
								id : "effDate",
								title : "Eff Date",
								width : '60px'
							},
							{
								id : "expiryDate",
								title : "Exp Date",
								width : '60px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 30
									},
									{
										id : "denominatorFactor",
										width : 30
									}
								]
							},
							{
								id : "share",
								title : "Share",
								width : '50px'
							},
							{
								id : "commIncome",
								title : "Commission Income",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defCommIncome",
								title : "Deferred Comm. Inc.",
								altTitle : "Deferred Distribution Income",
								width : '135px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
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
								id : "policyNo",
								title : "Policy/Endt Number",
								width : '150px'
							},
							{
								id : "effDate",
								title : "Eff Date",
								width : '70px'
							},
							{
								id : "expiryDate",
								title : "Exp Date",
								width : '70px'
							},
							{
								id : "numeratorFactor denominatorFactor",
								title : "Factor",
								children : [
									{
										id : "numeratorFactor",
										width : 30
									},
									{
										id : "denominatorFactor",
										width : 30
									}
								]
							},
							{
								id : "commExpense",
								title : "Commission Expense",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							},
							{
								id : "defCommExpense",
								title : "Deferred Comm. Exp.",
								altTitle : "Deferred Commission Expense",
								width : '130px',
								align : 'right',
								titleAlign : 'right',
								geniisysClass: 'money'
							}
						]
					    ;			
			}
		}
	}
	
	initializeDetailsTableGrid();
	
	gdDtlTableModel = {
			url : contextPath+"/GIACDeferredController?action=getGdDetail&refresh=1&year=" + objGiacs044.year + "&mM=" + objGiacs044.mM + "&procedureId=" + objGiacs044.procedureId
						+ "&issCd=" + objGiacs044.issCd + "&lineCd=" + objGiacs044.lineCd + "&shareType=" + objGiacs044.shrType + "&table=" + objGiacs044.table,
			options: {
				hideColumnChildTitle: true,
				width: '650px',
				height: '275px',
				onCellFocus : function(element, value, x, y, id) {	
					gdDtlTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					gdDtlTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					gdDtlTableGrid.keys.releaseKeys();
				},
				prePager: function() {
					gdDtlTableGrid.keys.releaseKeys();
				}
			},									
			columnModel: column,
			rows: jsonGdDtl.rows
		};
	
	gdDtlTableGrid = new MyTableGrid(gdDtlTableModel);
	gdDtlTableGrid.pager = jsonGdDtl;
	gdDtlTableGrid.render('gdDtlTable');
	gdDtlTableGrid.afterRender = function(y) {
		setParamsField(gdDtlTableGrid.geniisysRows[0]);
	};
	
	function setParamsField(obj) {
		$("txtBranchCd").value 		= obj == null ? "" : obj.issCd;
		$("txtBranchName").value 	= obj == null ? "" : obj.issName;
		$("txtLineCd").value 		= obj == null ? "" : obj.lineCd;
		$("txtLineName").value 		= obj == null ? "" : obj.lineName;
	}
	
} catch (e) {
	showMessageBox("Error in 24thMethod GdDtl tablegrid: " + e, imgMessage.ERROR);		
}
</script>