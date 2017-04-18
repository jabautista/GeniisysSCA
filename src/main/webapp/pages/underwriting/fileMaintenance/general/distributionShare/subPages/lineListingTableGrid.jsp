<div id="lineListingTableGrid" style="height: 245px; width: 400px; top:10px; border-bottom: 0px; margin-top:10px; margin-left:210px; "></div>

<script>

	var obj = null;
	var row = 0;
	var lineListingRows = [];		
	var lineListingObj = new Object();
	lineListingObj.lineListingTableGrid1 = JSON.parse('${lineListingObj}'.replace(/\\/g, '\\\\'));
	lineListingObj.lineListingObjRows = lineListingObj.lineListingTableGrid1.rows || [];
	objUW.hideGIIS060 = {};
		
	var lineListingTableModel = {
		url: contextPath+"/GIISDistributionShareController?action=getGIIS060LineListing",
		id: 'line',
		options: {
			width: '400px',
			height: '200px',
			beforeClick: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objGIIS060.savefocus();
					});
					return false;
				}
			}, 
			onCellFocus: function(element, value, x, y, id){
				var mtgId = lineListingTableGrid._mtgId;
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					row = y;
					obj = lineListingTableGrid.geniisysRows[y];
					objUW.hideGIIS060.prevLineCd = objUW.hideGIIS060.lineCd;
					objUW.hideGIIS060.lineCd = obj.lineCd;
					objGIIS060.loadDistShare(shareType);
					distShareTableGrid.onRemoveRowFocus();
					$("txtShareCode").readOnly = false;
					$("txtShareName").readOnly = false;
					$("txtRemarks").readOnly = false;
				}
				lineListingTableGrid.keys.removeFocus(lineListingTableGrid.keys._nCurrentFocus, true);
				lineListingTableGrid.keys.releaseKeys();		
			},
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objGIIS060.savefocus();
					});
					return false;
				}else{
					refresh();
					objGIIS060.loadDistShare(shareType, "removeFocus");
				} 
			},
			onRemoveRowFocus: function(element, value, x, y, id){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objGIIS060.savefocus();
					});
					return false;
				}
				var mtgId = lineListingTableGrid._mtgId;
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){ 	
					refresh();
				}
				$("txtShareCode").readOnly = true;
				$("txtShareName").readOnly = true;
				$("txtRemarks").readOnly = true;
				$("editRemarksText").hide();
				objGIIS060.loadDistShare(shareType, "removeFocus");
				lineListingTableGrid.keys.removeFocus(lineListingTableGrid.keys._nCurrentFocus, true);
				lineListingTableGrid.keys.releaseKeys();
			},
			beforeSort: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						objGIIS060.savefocus();
					});
					return false;
				}
		    },
		   	onSort: function(element, value, x, y, id){
		   		refresh();
				lineListingTableGrid.keys.releaseKeys();
		    },
		    onRefresh : function(element, value, x, y, id){
		    	refresh();
				lineListingTableGrid.keys.releaseKeys();
		    },
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onFilter: function(){
					refresh();
					lineListingTableGrid.keys.releaseKeys();
				},
			},
			checkChanges: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailValidation: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetail: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc: function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailNoFunc: function(){
				return (changeTag == 1 ? true : false);
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
							titleAlign: 'left',
							width: '100px',
							visible: true,
							filterOption: true,
							sortable:true
						},
						{	id: 'lineName',
							title: 'Line Name',
							titleAlign: 'left',
							width: '270px',
							visible: true,
							filterOption: true,
							sortable:true
						}
					],
					rows: lineListingObj.lineListingObjRows,		
		};
			
		lineListingTableGrid = new MyTableGrid(lineListingTableModel);
		lineListingTableGrid.pager = lineListingObj.lineListingTableGrid1;
		lineListingTableGrid.render('lineListingTableGrid');
		lineListingTableGrid.afterRender = function(){
			lineListingRows = lineListingTableGrid.geniisysRows;
		};
			
		function refresh(){
			if(shareType != "4"){
				distShareTableGrid.url = contextPath+"/GIISDistributionShareController?action=getDistShareMaintenance"
							    		 +"&lineCd=&shareType="+shareType;	
				distShareTableGrid.refreshURL(distShareTableGrid);
				distShareTableGrid._refreshList();
				distShareTableGrid.onRemoveRowFocus();
			}else{
			    xolTableGrid.url = contextPath+"/GIISXolController?action=getXolList&lineCd=";
			    xolTableGrid.refreshURL(xolTableGrid);
			    xolTableGrid._refreshList();
			    xolTableGrid.onRemoveRowFocus();
			}
			objUW.hideGIIS060.lineCd = null;
		}
		
</script>
