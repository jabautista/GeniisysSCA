<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div  id="lineSubSectionDiv" class= "subSectionDiv">
	<div id="lineListingTable" style="height: 240px;position:relative;left:210px;top:5px;border-bottom: 0px;" ></div>
</div>
	
<script type="text/javascript">
	try{
		var row = 0;
		var objRequiredPolicyDocumentMain = [];
		var objLine = new Object();
		objLine.objLineListing = JSON.parse('${requiredPolicyDocumentMaintenance}'.replace(/\\/g, '\\\\'));
		objLine.objLineMaintenance = objLine.objLineListing.rows || [];
		
		var lineMaintenanceTG = {
				url: contextPath+"/GIISRequiredDocController?action=showGIIS035RequiredPolicyDocumentMaintenance",
				 id: 1,
			options: {
				width: '450px',
				height: '180px',
				onCellFocus: function(element, value, x, y, id){
					lineMaintenanceTableGrid.keys.removeFocus(lineMaintenanceTableGrid.keys._nCurrentFocus, true);
					lineMaintenanceTableGrid.keys.releaseKeys();
					row = y;
					objGIISS035.objLineMaintain = lineMaintenanceTableGrid.geniisysRows[y];
					objG035.lineCd = objGIISS035.objLineMaintain.lineCd;
					setSublineBlock(true);
				},
				onRemoveRowFocus: function(){
					lineMaintenanceTableGrid.keys.removeFocus(lineMaintenanceTableGrid.keys._nCurrentFocus, true);
					lineMaintenanceTableGrid.keys.releaseKeys();
					objGIISS035.objLineMaintain = null;
					setSublineBlock(null);
	            },
	            beforeSort: function(){

                },
                onSort: function(){
            	
                },
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){

					},
					onFilter: function(){

					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
			    {   id: 'lineCd',
				    title: 'Line Code',
				    titleAlign: 'center',
				    width: '90px',
				    visible: true,
				    filterOption: true,
				    sortable:true
				},
				{	id: 'lineName',
					title: 'Line Name',
					titleAlign: 'center',
					width: '330px',
					visible: true,
					filterOption: true,
					sortable:true
				}
				],
			rows: objLine.objLineMaintenance
		};
		
		lineMaintenanceTableGrid = new MyTableGrid(lineMaintenanceTG);
		lineMaintenanceTableGrid.pager = objLine.objLineListing;
		lineMaintenanceTableGrid.render('lineListingTable');
		lineMaintenanceTableGrid.afterRender = function(){
			objRequiredPolicyDocumentMain = lineMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
		};

	}catch (e) {
		 showErrorMessage("Line Maintenance Table Grid", e); 
	}
		observeReloadForm("reloadForm",showRequiredPolicyDocument);	
		
	function setSublineBlock(obj){
		if(obj != null) {
			sublineMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getSublineLOV"   
												+"&lineCd="+objGIISS035.objLineMaintain.lineCd;
			requiredDocMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList"
							 +"&lineCd="+objGIISS035.objLineMaintain.lineCd;	
		} else {
			sublineMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getSublineLOV"   
												+"&lineCd=---"
			requiredDocMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList";
		}
		sublineMaintenanceTableGrid._refreshList();
		requiredDocMaintenanceTableGrid._refreshList();
	}		
</script>