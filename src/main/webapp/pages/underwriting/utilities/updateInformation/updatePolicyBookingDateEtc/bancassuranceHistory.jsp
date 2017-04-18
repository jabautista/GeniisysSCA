<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv">
		<div style="clear: both; margin: 10px auto; width: 680px;">
			<div id="bancaHistTGDiv" style="height: 300px;"></div>
		</div>
	</div>
	<div style="float : none; text-align: center;">
		<input type="button" class="button" id="btnBancHistOk" value="Ok" style="width: 100px; margin-top: 10px;"/>
	</div>
</div>
<script>
	try {
		
		var jsonGIPIS156BancaHistory = JSON.parse('${jsonGIPIS156BancaHistory}');
		bancaHistTableModel = {
				url: contextPath+ "/UpdateUtilitiesController?action=showBancassuranceHistory&refresh=1&policyId=" + objGIPIS156.policyId,
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: '680px',
					height: '275px',
					hideColumnChildTitle : false,
					onCellFocus : function(element, value, x, y, id) {
						//setDetails(bancaHistTbg.geniisysRows[y]);					
						bancaHistTbg.keys.removeFocus(bancaHistTbg.keys._nCurrentFocus, true);
						bancaHistTbg.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						//setDetails(null);
						bancaHistTbg.keys.removeFocus(bancaHistTbg.keys._nCurrentFocus, true);
						bancaHistTbg.keys.releaseKeys();
					},
				},									
				columnModel: [
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
						id: 'histNo',
						title: 'Hist No.',
						width: '50px',
						align: 'right',
						titleAlign: 'right',
						sortable: false
					},
					{
						id: 'dspAreaDescOld dspAreaDescNew',
						title: 'Area',
						sortable: false,
						//width: '210px',
						children: [
							{
								id: 'dspAreaDescOld',
								title: 'Old',
								width: 100,
								sortable: false
							},
							{
								id: 'dspAreaDescNew',
								title: 'New',
								width: 100,
								sortable: false
							}
						]
					},
					{
						id: 'dspBranchDescOld dspBranchDescNew',
						title: 'Branch',
						sortable: false,
						//width: '210px',
						children: [
							{
								id: 'dspBranchDescOld',
								title: 'Old',
								width: 100,
								sortable: false
							},
							{
								id: 'dspBranchDescNew',
								title: 'New',
								width: 100,
								sortable: false
							}
						]
					},
					{
						id: 'dspMgrNameOld dspMgrNameNew',
						title: 'Manager',
						sortable: false,
						//width: '210px',
						children: [
							{
								id: 'dspMgrNameOld',
								title: 'Old',
								width: 100,
								sortable: false
							},
							{
								id: 'dspMgrNameNew',
								title: 'New',
								width: 100,
								sortable: false
							}
						]
					},
					{
						id: 'userId',
						title: 'User ID',
						width: '80px',
						sortable: false
					},
					{
						id: 'lastUpdate',
						title: 'Last Update',
						width: '96px',
						align: 'center',
						titleAlign: 'center',
						sortable: false,
						renderer : function(val){
							if(val != null && val != "")
								return dateFormat(val, "mm-dd-yyyy");
							else
								return "";
						}
					}
				],
				rows: jsonGIPIS156BancaHistory.rows
			};
		
		bancaHistTbg = new MyTableGrid(bancaHistTableModel);
		bancaHistTbg.pager = jsonGIPIS156BancaHistory;
		bancaHistTbg.render('bancaHistTGDiv');
		//bancaHistTbg.afterRender = function(){};
		
		 $("btnBancHistOk").observe("click", function(){
			overBancassuranceHistory.close();
			delete overBancassuranceHistory;
		}); 
		
	} catch (e) {
		showMessageBox("Error in Bancassurance History " + e, imgMessage.ERROR);
	}
</script>