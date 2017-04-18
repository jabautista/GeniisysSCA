<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="distDtlsDiv" name="distDtlsDiv" class="sectionDiv" style="height: 170px; padding-top: 15px;">
	<div id="distDtlsTGDiv" name="distDtlsTGDiv" style="height: 120px; width: 99%; padding-left: 55px;">
		
	</div>
</div>

<script type="text/javascript">
	var arrDistDtlsButtons = [MyTableGrid.REFRESH_BTN];
	objCLM.fla.selectedIndexDist = -1;
	var objFlaDistDtls = new Object();
	objFlaDistDtls.objFlaDistDtlsTableGrid = JSON.parse('${distDtlsTableGrid}');
	objFlaDistDtls.objFlaDistDtlsRows = objFlaDistDtls.objFlaDistDtlsTableGrid.rows || [];
	try{
		var distDtlsTableModel = {
			url: contextPath+"/GICLAdvsFlaController?action=getFLADistDtls&refresh=1&claimId="+objCLM.fla.claimId+"&adviceId="+objCLM.fla.adviceId+"&lineCd="+objCLM.fla.lineCd,
			options: {
				title: '',
	          	height: '132px',
	          	width: '810px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = distDtlsTableGrid._mtgId;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		objCLM.fla.selectedIndexDist = y;
	            		objCLM.fla.grpSeqNo = distDtlsTableGrid.geniisysRows[y].grpSeqNo;
	            		objCLM.fla.shareType = distDtlsTableGrid.geniisysRows[y].shareType;
	            		objCLM.fla.adviceId = distDtlsTableGrid.geniisysRows[y].adviceId;
	            		showFlaDtls(objCLM.fla.claimId, objCLM.fla.grpSeqNo, objCLM.fla.shareType, objCLM.fla.adviceId);
	            	}
	            	distDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
	            },
	            onRemoveRowFocus: function(){
	            	distDtlsTableGrid.keys.removeFocus(distDtlsTableGrid.keys._nCurrentFocus, true);
	            	distDtlsTableGrid.keys.releaseKeys();
	            	showFlaDtls(null, null, null, null);
	            	objCLM.fla.grpSeqNo = "";
            		objCLM.fla.shareType = "";
            		objCLM.fla.adviceId = "";
	            	objCLM.fla.selectedIndexDist = -1;
	            	distDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
	            },
	            onSort: function() {
	            	objCLM.fla.selectedIndexDist = -1;
	            },
	            onRefresh: function() {
	            	objCLM.fla.selectedIndexDist = -1;
	            },
	            toolbar: {
	            	elements: (arrDistDtlsButtons)
	            }
			},
			columnModel:[
						{
							id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	
							id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	
							id: 'grpSeqNo',
							width: '0px',
							visible: false
						},
						{	
							id: 'shareType',
							width: '0px',
							visible: false
						},
						{	
							id: 'adviceId',
							width: '0px',
							visible: false
						},
						{	id: 'trtyName',
							title: 'Treaty Name',
			            	width: '255px',
			            	titleAlign: 'center'
						},
						{	id: 'paidAmt',
							title: 'Paid Share Amount',
			            	width: '179px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'netAmt',
							title: 'Net Share Amount',
			            	width: '178px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'advAmt',
							title: 'Advice Share Amount',
			            	width: '178px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						}
  					],
  				rows: objFlaDistDtls.objFlaDistDtlsRows,
  				id: 2
		};
		distDtlsTableGrid = new MyTableGrid(distDtlsTableModel);
		distDtlsTableGrid.pager = objFlaDistDtls.objFlaDistDtlsTableGrid;
		distDtlsTableGrid.render('distDtlsTGDiv');
		distDtlsTableGrid.afterRender = function(){
			if (objFlaDistDtls.objFlaDistDtlsRows.length > 0){
				distDtlsTableGrid.selectRow('0');
				objCLM.fla.selectedIndexDist = 0;
				objCLM.fla.grpSeqNo = distDtlsTableGrid.geniisysRows[0].grpSeqNo;
        		objCLM.fla.shareType = distDtlsTableGrid.geniisysRows[0].shareType;
        		objCLM.fla.adviceId = distDtlsTableGrid.geniisysRows[0].adviceId;
        		showFlaDtls(objCLM.fla.claimId, objCLM.fla.grpSeqNo, objCLM.fla.shareType, objCLM.fla.adviceId);
			}else{
				showFlaDtls(null, null, null, null);
			}
		};
	}catch(e){
		showMessageBox("Error in Distribution Details: " + e, imgMessage.ERROR);		
	}
</script>