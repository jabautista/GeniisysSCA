<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div id="sublineSubSectionDiv" class= "subSectionDiv">
	<div id="sublineListingTable" style="height: 245px;position:relative;left:210px;top:5px;border-bottom: 0px;" ></div>
</div>

<script type="text/javascript">
	
	try{
		
		var row = 0;
		var objRequiredPolicyDocumentMain = [];
		var objSubline = new Object();
		objSubline.objSublineListing = [];
		objSubline.objSublineMaintenance = objSubline.objSublineListing.rows || [];
		
		var sublineMaintenanceTG = {
				url: contextPath+"/GIISRequiredDocController?action=getSublineLov",
				 id: 2,
			options: {
				width: '450px',
				height: '180px',
				onCellFocus: function(element, value, x, y, id){
					sublineMaintenanceTableGrid.keys.removeFocus(sublineMaintenanceTableGrid.keys._nCurrentFocus, true);
					sublineMaintenanceTableGrid.keys.releaseKeys();
					row = y;
				    objGIISS035.objSublineMaintain = sublineMaintenanceTableGrid.geniisysRows[y];
				    objG035.sublineCd = objGIISS035.objSublineMaintain.sublineCd;				    
					objG035.currDocList = null; // added by Kris 05.23.2013
					setReqDocsBlock(true);
				},
				onRemoveRowFocus: function(){
					sublineMaintenanceTableGrid.keys.removeFocus(sublineMaintenanceTableGrid.keys._nCurrentFocus, true);
					sublineMaintenanceTableGrid.keys.releaseKeys();
				 objGIISS035.objSublineMaintain = null;
				 setReqDocsBlock(null);
	            },
	            beforeSort: function(){

                },
                onSort: function(){
            	
                },
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						 	requiredDocMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList"
						 											+"&lineCd="+objGIISS035.objLineMaintain.lineCd;
							requiredDocMaintenanceTableGrid.refreshURL(requiredDocMaintenanceTableGrid);
							requiredDocMaintenanceTableGrid.refresh();
							lineMaintenanceTableGrid.keys.releaseKeys();
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
			    {   id: 'sublineCd',
				    title: 'Subline Code',
				    titleAlign: 'center',
				    width: '90px',
				    visible: true,
				    filterOption: true,
				    sortable:true
				},
				{	id: 'sublineName',
					title: 'Subline Name',
					titleAlign: 'center',
					width: '330px',
					visible: true,
					filterOption: true,
					sortable:true
				}
				],
			rows: objSubline.objSublineMaintenance
		};
		
		sublineMaintenanceTableGrid = new MyTableGrid(sublineMaintenanceTG);
		sublineMaintenanceTableGrid.pager = objSubline.objSublineListing;
		sublineMaintenanceTableGrid.render('sublineListingTable');
		sublineMaintenanceTableGrid.afterRender = function(){
			objRequiredPolicyDocumentMain = sublineMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
		};
		
	}catch (e) {
		 showErrorMessage("Subline Maintenance Table Grid", e); 
	}
		
	observeReloadForm("reloadForm",showRequiredPolicyDocument);
	
	function setReqDocsBlock(obj){
		if(obj != null) {
			requiredDocMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList"
													+"&lineCd="+objGIISS035.objLineMaintain.lineCd
													+"&sublineCd="+objGIISS035.objSublineMaintain.sublineCd;
		} else {
			requiredDocMaintenanceTableGrid.url = contextPath+"/GIISRequiredDocController?action=getGiisRequiredDocList"
													+"&lineCd="+objGIISS035.objLineMaintain.lineCd;
		}
		requiredDocMaintenanceTableGrid._refreshList();
	}
</script>