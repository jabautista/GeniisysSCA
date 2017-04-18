/**
 * MyTableGrid, version 1.1
 *
 * Dual licensed under the MIT and GPL licenses.
 *
 * Copyright 2009 Pablo Aravena, all rights reserved.
 * http://pabloaravena.info/mytablegrid
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
MyTableGrid = Class.create();

MyTableGrid.ADD_BTN = 1;
MyTableGrid.DEL_BTN = 4;
MyTableGrid.SAVE_BTN = 8;
MyTableGrid.FILTER_BTN = 10; // andrew - 01.17.2011 - filter toolbar button
// nica - 02.03.2011 - added the following buttons
MyTableGrid.EDIT_BTN = 12;
MyTableGrid.COPY_BTN = 14;
MyTableGrid.CANCEL_BTN = 16;
MyTableGrid.PRINT_BTN = 18;
MyTableGrid.RETURN_QUOTN_BTN = 20;
//andrew - 02.15.2011 - for refresh list
MyTableGrid.REFRESH_BTN = 21;
MyTableGrid.DENY_BTN = 22;
MyTableGrid.DUPLICATE_BTN = 23;
MyTableGrid.REASSIGN_BTN = 24;
MyTableGrid.HISTORY_BTN = 25;
MyTableGrid.ATTACHMENT_BTN = 26;
MyTableGrid.VIEW_BTN = 27;
MyTableGrid.APPROVE_BTN = 28; //benjo 08.03.2016 SR-5512

MyTableGrid.prototype = {
    version: '1.1.0',

    _messages : {
        totalDisplayMsg: '<strong>{total}</strong> records found',
        rowsDisplayMsg: ', displaying <strong>{from}</strong> to <strong>{to}</strong>',
        pagePromptMsg: '<td><strong>Page:</strong></td><td>{input}</td><td>of <strong>{pages}</strong></td>',
        pagerNoDataFound: '<strong>No records found</strong>',
        pagerNoRecordsLeft: ', no records left on this page',
        add: 'Add',
        remove: 'Delete',
        save: 'Save',
        filter: 'Filter',
        edit: 'Edit',
        copy: 'Copy',
        approve: 'Approve', //benjo 08.03.2016 SR-5512
        cancel: 'Cancel',
        print: 'Print',
        retQuote: 'Return to Quotation',
        deny: 'Deny',
        duplicate: 'Duplicate',
        reassign: 'Assign Quotation',
        history: 'History',
        attachment: 'Attachment',
        view: "View",
        sortAsc: 'Sort ascending',
        sortDesc: 'Sort descending',
        selectAll: 'Select all',
        refresh: 'Refresh',
        loading: 'Loading ...'
    },

    /**
     * MyTableGrid constructor
     */
    initialize : function(tableModel) {    	
        this._mtgId = tableModel.id || $$('.myTableGrid').length + 1; // modified by mark jm 08.31.2011 for id conflict
        this.tableModel = tableModel;
        this.columnModel = tableModel.columnModel || [];
        this.geniisysRows = tableModel.rows || []; //added by Jerome Orio 12.09.2010 will contain Original rows
        this.rows = this.generateRows(tableModel.rows) || [];   //edited by Jerome 12.03.2010 tableModel.rows || []; - to generate table grid rows from JSON object to Object Array       
        this.requiredColumns = tableModel.requiredColumns || ''; //added by Jerome Orio 12.09.2010 will contain all required columns 
        this.options = tableModel.options || {};
        this.name = tableModel.name || '';
        this.fontSize = 11;
        this.cellHeight = parseInt(this.options.cellHeight) || 24;
        this.pagerHeight = 24;
        this.titleHeight = 24;
        this.toolbarHeight = 24;
        this.scrollBarWidth = 18;
        this.topPos = 0;
        this.leftPos = 0;
        this.selectedHCIndex = 0;
        this.pager = this.options.pager || null;
        if (this.options.pager) this.pager.pageParameter = this.options.pager.pageParameter || 'page';
        this.url = tableModel.url || null;
        this.request = tableModel.request || {};
        this.sortColumnParameter = this.options.sortColumnParameter || 'sortColumn';
        this.ascDescFlagParameter = this.options.ascDescFlagParameter || 'ascDescFlg';
        this.sortedColumnIndex = 0;
        this.sortedAscDescFlg = 'ASC'; // || 'DESC'
        this.onCellFocus = this.options.onCellFocus || null;
        this.onRemoveRowFocus = this.options.onRemoveRowFocus || null; //added by alfie 
        this.rowPostQuery = this.options.rowPostQuery || null; //added by alfie 02/21/2011
        this.onRowDoubleClick = this.options.onRowDoubleClick || null; // added by andrew 02.01.2011 - option for dobleclick event
        this.onCellBlur = this.options.onCellBlur || null;
        this.modifiedRows = []; //will contain the modified row numbers
        this.afterRender = this.options.afterRender || null; //after rendering handler
        this.onShow = this.options.onShow || null; // andrew - 11.17.2011
        this.rowStyle = this.options.rowStyle || null; //row style handler
        this.rowClass = this.options.rowClass || null; //row class handler
        //this.addSettingBehaviorFlg = (this.options.addSettingBehavior == undefined || this.options.addSettingBehavior)? true : false;
        this.addSettingBehaviorFlg = (this.options.addSettingBehavior == undefined ? false : this.options.addSettingBehavior); // andrew - 01.18.2011 - changed the default value to false;
        //this.addDraggingBehaviorFlg = (this.options.addDraggingBehavior == undefined || this.options.addDraggingBehavior)? true : false;
        this.addDraggingBehaviorFlg = (this.options.addDraggingBehavior == undefined ? false : this.options.addDraggingBehavior); // andrew - 01.18.2011 - changed the default value to false;
        this.querySortFlg = (this.options.querySort == undefined || this.options.querySort) ? true : false; // andrew - 11.26.2010
        this.addColumnSortMenuFlg = (this.options.addColumnSortMenu == undefined ? false : this.options.addColumnSortMenu); // andrew - 01.12.2011 - added this option to disable or enable the sorting dropdown menu
        this.resetChangeTag = tableModel.resetChangeTag || null; // added by: nica 02.16.2011 - add option if changeTag must be reset before changing page
        this.checkChangeTag = tableModel.checkChangeTag || null; //nok 03.26.12 to check changeTag on save
        this.validateChangesOnPrePager = (this.options.validateChangesOnPrePager == undefined || this.options.querySort ? true : false); // andrew - 05.09.2011
        this.onEnter = this.options.onEnter || null; // added by andrew 05.20.2011 - option for key enter event
        this.beforeClick = this.options.beforeClick || null;
        this.columnResizable = (this.options.columnResizable == undefined ? true : this.options.columnResizable);
        
        this.renderedRows = 0; //Use for lazy rendering
        this.renderedRowsAllowed = this.rows.length; //edited by Jerome Orio - 0; //Use for lazy rendering depends on bodyDiv height
        this.newRowsAdded = [];
        this.deletedRows = [];
        
        this.checkChanges = (this.options.checkChanges==undefined || this.options.checkChanges==null) ? true : this.options.checkChanges; //added by alfie 05/10/2011: added this option to enable or disable checking of changes
        
        this.masterDetail = nvl(this.options.masterDetail, false) ? true : false; // mark jm
        this.masterDetailValidation = this.options.masterDetailValidation || null; // mark jm
        this.masterDetailSaveFunc = this.options.masterDetailSaveFunc || null; // mark jm
        this.masterDetailNoFunc = this.options.masterDetailNoFunc || null; // mark jm
        this.masterDetailRequireSaving = nvl(this.options.masterDetailRequireSaving, false) || false; // nica 03.09.2012
        
        this.objFilter = {}; // andrew - 01.18.2011 - will hold the filter text value;
        
        // Header builder
        this.hb = new HeaderBuilder(this._mtgId, this.columnModel);
        if (this.hb.getHeaderRowNestedLevel() > 1) {
            this.addSettingBehaviorFlg = false;
            this.addDraggingBehaviorFlg = false;
        }
        this.headerWidth = this.hb.getTableHeaderWidth();
        this.headerHeight = nvl(this.options.hideColumnChildTitle,false) ? (this.hb.cellHeight + 2) :this.hb.getTableHeaderHeight();
        this.columnModel = this.hb.getLeafElements();
        for (var i = 0; i < this.columnModel.length; i++) {
            if (!this.columnModel[i].hasOwnProperty('editable')) this.columnModel[i].editable = false;
            if (!this.columnModel[i].hasOwnProperty('editableOnAdd')) this.columnModel[i].editableOnAdd = false; //added by Jerome Orio 12.10.2010 for columns editable only on newly added row
            if (!this.columnModel[i].hasOwnProperty('visible')) this.columnModel[i].visible = true;
            if (!this.columnModel[i].hasOwnProperty('sortable')) this.columnModel[i].sortable= true;
            if (!this.columnModel[i].hasOwnProperty('type')) this.columnModel[i].type = 'string';
            if (!this.columnModel[i].hasOwnProperty('selectAllFlg')) this.columnModel[i].selectAllFlg = false;
            if (!this.columnModel[i].hasOwnProperty('sortedAscDescFlg')) this.columnModel[i].sortedAscDescFlg = 'DESC';
            if (!this.columnModel[i].hasOwnProperty('hideSelectAllBox')) this.columnModel[i].hideSelectAllBox = false; //nok 04.26.2011 option to hide select all box
            this.columnModel[i].positionIndex = i;
            //this.columnModel[i].radioGroup = this.options.radioGroup; 
        }

        this.targetColumnId = null;
        this.editedCellId = null;

        this.gap = 2; //diff between width and offsetWidth
        if (Prototype.Browser.WebKit) this.gap = 0;
        
        // to check if rows should not be displayed upon rendering (emman 04.25.2011)
        this.hideRowsOnLoad = tableModel.hideRowsOnLoad || null;
    },
    
    /**
     * Generate new table grid rows
     * @author Jerome Orio
     * @return array of object, table grid column model
     */    
    generateRows : function(objArray){
    	var cm = this.columnModel;
    	var tempObj = [];  
    	var tempObjArray = [];
    	for(var i=0; i<objArray.length; i++){
    		objArray[i].recordStatus = objArray[i].recordStatus || "";
    		objArray[i].divCtrId = objArray[i].divCtrId || i;
    		for(var x=0; x < cm.length; x++){
    			var col = cm[x].id.split(" ");
    			for(var c=0; c < col.length; c++){
    				tempObj.push(objArray[i][col[c]]);
    			}
    		}	
    		tempObjArray.push(tempObj);
    		tempObj = []; 
    	}	
    	return tempObjArray;
    },    
    
    /**
     * Recreate table grid rows
     * @author Jerome Orio
     */     
    recreateRows : function(){
    	var self = this;
    	self.bodyTable.down('tbody').innerHTML = '';
        for (var b=self.rows.length-1; b>=0; b--){
    		var divCtrId = self.rows[b][self.getColumnIndex('divCtrId')];
    		self.bodyTable.down('tbody').insert({top: self._createRow(self.rows[b], divCtrId)});
    		self.keys.setTopLimit(divCtrId);
    		self._addKeyBehaviorToRow(self.rows[b], divCtrId); //alfie
    		self.keys.addMouseBehaviorToRow(divCtrId);
    		self._applyCellCallbackToRow(divCtrId);
    		self.scrollTop = self.bodyDiv.scrollTop = 0;
    		
    	    if (self.rowPostQuery) {
    	    	self.rowPostQuery(b);//added by alfie 02/21/2011
    	    }
    	}	
        self.renderedRowsAllowed = self.rows.length;
        self.renderedRows = self.rows.length;

        // added by: nica 02.16.2011 - to reset changeTag if resetChangeTag is true
        if(self.resetChangeTag){
        	changeTag = 0;
        }
    },

    show : function(target) {
        this.render(target);
    },
    /**
     * Renders the table grid control into a given target
     */
    render : function(target) {
        this.target = target;
        $(target).innerHTML = this._createTableLayout();
        var id = this._mtgId;
        this.tableDiv = $('myTableGrid' + id);
        this.headerTitle = $('mtgHeaderTitle'+id);
        this.headerToolbar = $('mtgHeaderToolbar'+id);
        this.headerRowDiv = $('headerRowDiv' + id);
        this.bodyDiv = $('bodyDiv' + id);
        this.overlayDiv = $('overlayDiv' + id);
        this.innerBodyDiv = $('innerBodyDiv' + id);
        this.pagerDiv = $('pagerDiv' + id);
        this.resizeMarkerLeft = $('resizeMarkerLeft' + id);
        this.resizeMarkerRight = $('resizeMarkerRight' + id);
        this.dragColumn = $('dragColumn' + id);
        this.colMoveTopDiv = $('mtgColMoveTop' + id);
        this.colMoveBottomDiv = $('mtgColMoveBottom' + id);
        this.scrollLeft = 0;
        this.scrollTop = 0;
        this.targetColumnId = null;

        $(target).insert({after:'<div class="autocomplete" id="list" style="display:none;z-index:1000"></div>'});

        var self = this;

        Event.observe(this.bodyDiv, 'dom:dataLoaded', function(){
            self._showLoaderSpinner();
            self.bodyTable = $('mtgBT' + id);
            self._applyCellCallbacks();
            self._applyHeaderButtons();
            if (self.columnResizable) self._makeAllColumnResizable();
            if (self.addDraggingBehaviorFlg) self._makeAllColumnDraggable();
            if (self.addSettingBehaviorFlg) self._applySettingMenuBehavior();   
            self.keys = new KeyTable(self);
            self._addKeyBehavior();
            if (self.pager){
            	if(self.options.masterDetail){
            		self._addMasterDetailPagerBehavior();
            	}else{
            		self._addPagerBehavior();
            	}
            }
            self.recreateRows();  //added by Jerome Orio 12.28.2010
            if (self.afterRender){
                self.afterRender();
            }
            self._hideLoaderSpinner();
            if(self.options.toolbar != null) if (self.options.toolbar.elements.indexOf(MyTableGrid.FILTER_BTN) >= 0) self._applyFilterMenuBehavior(); // andrew - 01.20.2011 - added to apply the filter menu events
        });

        setTimeout(function(){
            self.renderedRowsAllowed = Math.floor((self.bodyHeight - self.scrollBarWidth - 3) / self.cellHeight) + 1;
            if (self.tableModel.hasOwnProperty('rows')){
                self.innerBodyDiv.innerHTML = self._createTableBody(self.rows);
                if(self.pager){
                    self.pagerDiv.innerHTML = self._updatePagerInfo();
                }
                self.bodyDiv.fire('dom:dataLoaded');
                if (self.onShow){
                    self.onShow();
                }
            } else {
                self._retrieveDataFromUrl(1, true);
            }
        }, 0);

        if (this.options.toolbar) {
            var elements = this.options.toolbar.elements || [];
            if (elements.indexOf(MyTableGrid.ADD_BTN) >= 0) {
                Event.observe($('mtgAddBtn'+id), 'click', function() {
                	//edited by Jerome Orio 12.14.2010
                	//to have a validate effect before adding rows
                	/* self.addNewRow();
                	 * if (self.options.toolbar.onAdd) {
                	 * 	   self.options.toolbar.onAdd.call()
                	 * }
                	 */
                	var ok;
                	if (self.keys._nCurrentFocus!=null||self.keys._nOldFocus!=null){ self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);} //added by Jerome Orio 12.09.2010
                    if (self.options.toolbar.onAdd) {
                        ok = self.options.toolbar.onAdd.call();
                    }
                    if (ok || ok==undefined){
                    	self.addNewRow();
                    	if (self.options.toolbar.postAdd) {
                    		self.options.toolbar.postAdd.call();
                    	}
                    }
                });
            }

            if (elements.indexOf(MyTableGrid.DEL_BTN) >= 0) {
                Event.observe($('mtgDelBtn'+id), 'click', function() {
                	//edited by Jerome Orio 12.14.2010
                	//to have a validate effect before deleting rows
                	/* self.deleteRows();
                	 * if (self.options.toolbar.onDelete) {
                	 * 	   self.options.toolbar.onDelete.call();
                	 * }
                	 */
                	var ok = true;
                    if (self.options.toolbar.onDelete) {
                    	ok = self.options.toolbar.onDelete.call();
                    }
                    if (ok || ok==undefined){
                    	self.deleteRows();
                    	if (self.options.toolbar.postDelete) {
                    		self.options.toolbar.postDelete.call();
                    	}	
                    }
                });
            }

            if (elements.indexOf(MyTableGrid.SAVE_BTN) >= 0) {
                Event.observe($('mtgSaveBtn'+id), 'click', function() {
                	/* edited by Jerome Orio 12.14.2010
                	 * self._blurCellElement(self.keys._nCurrentFocus);
                	 * if (self.options.toolbar.onSave) {
                	 * self.options.toolbar.onSave.call();
                	 * }
                	 */
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	if (self.getModifiedRows().length == 0 && self.getNewRowsAdded().length == 0 && self.getDeletedRows().length == 0){showMessageBox(objCommonMessage.NO_CHANGES, "I"); return false;} //to check if changes exist 
                	if (!self.preCommit()){ return false; } //to validate all required field before saving
                	var ok = true;
                	if (self.options.toolbar.onSave) {
                		ok = self.options.toolbar.onSave.call();
                	}
                	if (ok || ok==undefined){
                		if (self.options.toolbar.postSave) {
                    		self.options.toolbar.postSave.call();
                    	}
                	}	
                	self.keys._nCurrentFocus = null; //to avoid null input error
                });
            }            
            
            /*	Date		Author			Description
             * 	==========	===============	==============================
             * 	01.17.2011	andrew robes	added filter button event
             * 	08.25.2011	mark jm			convert the existing transaction statement to function (to be reuse)
             * 								added condition to check if there are changes in a master-detail relation 
             */
            function continueFilter(){
            	var ok = true;
            	var settingMenu = $('mtgHBMFilter' + id);
                var settingButton = $('mtgFilterBtn' + id);
                var keyword = $('mtgKeyword'+id);
                
                var width = settingMenu.getWidth();
                
                settingButton.up().toggleClassName("toolbarbtn_selected");
                if (settingMenu.getStyle('visibility') == 'hidden') {
                    var topPos = $('mtgFilterBtn'+id).offsetTop;
                    var leftPos = $('mtgFilterBtn'+id).offsetLeft;
                    settingMenu.setStyle({
                        top: (topPos + 21) + 'px',
                        left: (leftPos - width + 49) + 'px',
                        visibility: 'visible'                            
                    });
                    keyword.focus();
                } else {
                    settingMenu.setStyle({visibility: 'hidden'});
                }
            }
            
            if (elements.indexOf(MyTableGrid.FILTER_BTN) >= 0) {
                Event.observe($('mtgFilterBtn'+id), 'click', function() {
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus); //added by steven 05.19.2014;to remove the editor if the cell has one.
                	if(self.options.masterDetail){
                		if(self.masterDetailValidation.call()){
                			if(self.options.masterDetailRequireSaving){
                				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
                			}else{
                				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                    					function(){self.masterDetailSaveFunc.call();}, 
                    					function(){
                    						self.masterDetailNoFunc.call();
                    						continueFilter();           						
                    					}, "");
                			}
                		}else{
                			continueFilter();
                		}                		
                	}else{
                		continueFilter();
                	}                	
                });       
            }
            
            /*	Date		Author			Description
             * 	==========	===============	==============================
             * 	01.17.2011	andrew robes	added refresh button event
             * 	08.25.2011	mark jm			added condition to check if there are changes in a master-detail relation              								 
             */            
            
            
            if (elements.indexOf(MyTableGrid.REFRESH_BTN) >= 0) {
            	var refresh = false;
                Event.observe($('mtgRefreshBtn'+id), 'click', function() {
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);
                	
                	if(self.options.masterDetail){
                		if(self.masterDetailValidation.call()){
                			if(self.options.masterDetailRequireSaving){
                				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
                			}else{
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                					function(){self.masterDetailSaveFunc.call();}, 
                					function(){
                						self.masterDetailNoFunc.call();
                						self._refreshList();               						
                					}, "");
                			}
                		}else{
                			self.masterDetailNoFunc.call();
                			self._refreshList();
                		}
                	}else{
                		if (self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                    		showConfirmBox("Confirmation", "Refreshing list will discard changes. Do you want to continue?", "Yes", "No", function(){
                        			self._refreshList();
                        			refresh = true;
                    			}, "");
                    	}else{
                    		self._refreshList();
                    		refresh = true;
                    		
                    	}
                    	if(refresh){
                    		if (self.options.toolbar) {
                    			if (self.options.toolbar.onRefresh) {
                                    ok = self.options.toolbar.onRefresh.call();
                                }
                            }                    		
                    	}
                	}
                	
                });      	
            }
            
            // nica 02.03.2011 - add functionality for edit button
            if (elements.indexOf(MyTableGrid.EDIT_BTN) >= 0) {
                Event.observe($('mtgEditBtn'+id), 'click', function() {
                	if (self.options.toolbar.onEdit) {
                    	ok = self.options.toolbar.onEdit.call();
                    }
                });
            }
            
            // nica 02.03.2011 - add functionality for copy button
            if (elements.indexOf(MyTableGrid.COPY_BTN) >= 0) {
                Event.observe($('mtgCopyBtn'+id), 'click', function() {
                	if (self.options.toolbar.onCopy) {
                    	ok = self.options.toolbar.onCopy.call();
                    }
                });
            }
            // nica 02.03.2011 - add functionality for cancel button
            if (elements.indexOf(MyTableGrid.CANCEL_BTN) >= 0) {
                Event.observe($('mtgCancelBtn'+id), 'click', function() {
                	if (self.options.toolbar.onCancel) {
                    	ok = self.options.toolbar.onCancel.call();
                    }
                });
            }
            
            // nica 02.03.2011 - add functionality for print button
            if (elements.indexOf(MyTableGrid.PRINT_BTN) >= 0) {
                Event.observe($('mtgPrintBtn'+id), 'click', function() {
                	if (self.options.toolbar.onPrint) {
                    	ok = self.options.toolbar.onPrint.call();
                    }
                });
            }
            
            // nica 02.03.2011 - add functionality for Return to Quotation button
            if (elements.indexOf(MyTableGrid.RETURN_QUOTN_BTN) >= 0) {
                Event.observe($('mtgRetQuoteBtn'+id), 'click', function() {
                	if (self.options.toolbar.onReturnQuotation) {
                    	ok = self.options.toolbar.onReturnQuotation.call();
                    }
                });
            }
            
            // andrew - 03.28.2011 - for deny button
            if (elements.indexOf(MyTableGrid.DENY_BTN) >= 0) {
                Event.observe($('mtgDenyBtn'+id), 'click', function() {
                	if (self.options.toolbar.onDeny) {
                    	ok = self.options.toolbar.onDeny.call();
                    }
                });
            }
            
            // andrew - 03.28.2011 - for duplicate button
            if (elements.indexOf(MyTableGrid.DUPLICATE_BTN) >= 0) {
                Event.observe($('mtgDuplicateBtn'+id), 'click', function() {
                	if (self.options.toolbar.onDuplicate) {
                    	ok = self.options.toolbar.onDuplicate.call();
                    }
                });
            }
            
            // andrew - 04.12.2011 - for reassign button in marketing GIIMM013
            if (elements.indexOf(MyTableGrid.REASSIGN_BTN) >= 0) {
                Event.observe($('mtgReassignBtn'+id), 'click', function() {
                	if (self.options.toolbar.onReassign) {
                    	ok = self.options.toolbar.onReassign.call();
                    }
                });
            }
            
            // andrew - 09.06.2011 - for history button (WORKFLOW)
            if (elements.indexOf(MyTableGrid.HISTORY_BTN) >= 0) {
                Event.observe($('mtgHistoryBtn'+id), 'click', function() {
                	if (self.options.toolbar.onHistory) {
                    	ok = self.options.toolbar.onHistory.call();
                    }
                });
            }
            
         // andrew - 09.29.2011 - for attachment button (WORKFLOW)
            if (elements.indexOf(MyTableGrid.ATTACHMENT_BTN) >= 0) {
                Event.observe($('mtgAttachmentBtn'+id), 'click', function() {
                	if (self.options.toolbar.onAttachment) {
                    	ok = self.options.toolbar.onAttachment.call();
                    }
                });
            }
         
         // andrew - 08.14.2011 - for view button
            if (elements.indexOf(MyTableGrid.VIEW_BTN) >= 0) {
                Event.observe($('mtgViewBtn'+id), 'click', function() {
                	if (self.options.toolbar.onView) {
                    	ok = self.options.toolbar.onView.call();
                    }
                });
            }
            
            /*// andrew - 07.15.2011 - for filter button
            if (elements.indexOf(MyTableGrid.FILTER_BTN) >= 0) {
                Event.observe($('mtgFilterBtn'+id), 'click', function() {
                	if (self.options.toolbar.onFilter) {
                    	ok = self.options.toolbar.onFilter.call();
                    }
                });
            }*/
            
            //benjo 08.03.2016 SR-5512
            if (elements.indexOf(MyTableGrid.APPROVE_BTN) >= 0) {
                Event.observe($('mtgApproveBtn'+id), 'click', function() {
                	if (self.options.toolbar.onApprove) {
                    	ok = self.options.toolbar.onApprove.call();
                    }
                });
            }
        }
        
        // Adding scrolling handler
        Event.observe($('bodyDiv' + id), 'scroll', function() {
            self._syncScroll();
        });
        // Adding resize handler
        Event.observe(window, 'resize', function() {
            self.resize();
        });

    },

    /**
     * Creates the table layout
     */
    _createTableLayout : function() {
        var target = $(this.target);
        var width = this.options.width || (target.getWidth() - this._fullPadding(target,'left') - this._fullPadding(target,'right')) + 'px';
        var height = this.options.height || (target.getHeight() - this._fullPadding(target,'top') - this._fullPadding(target,'bottom')) + 'px';
        var id = this._mtgId;
        var cm = this.columnModel;
        var gap = this.gap;
        var imageRefs = this._imageRefs;
        var imagePath = this._imagePath;
        var overlayTopPos = 0;
        var overlayHeight = 0;
        this.tableWidth = parseInt(width) - 2;
        overlayHeight = this.tableHeight = parseInt(height) - 2;

        var idx = 0;
        var html = [];
        html[idx++] = '<div id="myTableGrid'+id+'" class="myTableGrid" style="position:relative;width:'+this.tableWidth+'"px;height:'+this.tableHeight+'px;z-index:0">';

        if (this.options.title) { // Adding header title
            html[idx++] = '<div id="mtgHeaderTitle'+id+'" class=" mtgHeaderTitle" style="position:absolute;top:'+this.topPos+'px;left:'+this.leftPos+'px;width:'+(this.tableWidth - 6)+'px;height:'+(this.titleHeight - 6)+'px;padding:3px;z-index:10">'; //angelo changed z-index values from 20 to 0
            html[idx++] = '</div>';
            this.topPos += this.titleHeight + 1;
        }

        if (this.options.toolbar) {
            var elements = this.options.toolbar.elements || [];
            html[idx++] = '<div id="mtgHeaderToolbar'+id+'" class="mtgToolbar" style="position:absolute;top:'+this.topPos+'px;left:'+this.leftPos+'px;width:'+(this.tableWidth - 4)+'px;height:'+(this.toolbarHeight - 4)+'px;padding:2px;z-index:10">';
            var beforeFlg = false;
            if(elements.indexOf(MyTableGrid.SAVE_BTN) >= 0) {
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="savebutton" id="mtgSaveBtn'+id+'">'+this._messages.save+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.ADD_BTN) >= 0) {
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="addbutton" id="mtgAddBtn'+id+'">'+this._messages.add+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.EDIT_BTN) >= 0) {// nica - 02.03.2011 - added print button
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="editbutton" id="mtgEditBtn'+id+'">'+this._messages.edit+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.DEL_BTN) >= 0) {
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="delbutton" id="mtgDelBtn'+id+'">'+this._messages.remove+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.COPY_BTN) >= 0) { // nica - 02.03.2011 - added copy button
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="copybutton" id="mtgCopyBtn'+id+'">'+this._messages.copy+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.APPROVE_BTN) >= 0) { //benjo 08.03.2016 SR-5512
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="approvebutton" id="mtgApproveBtn'+id+'">'+this._messages.approve+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.CANCEL_BTN) >= 0) { // nica - 02.03.2011 - added cancel button
                if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="cancelbutton" id="mtgCancelBtn'+id+'">'+this._messages.cancel+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.PRINT_BTN) >= 0) { // nica - 02.03.2011 - added print button
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="printbutton" id="mtgPrintBtn'+id+'">'+this._messages.print+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.RETURN_QUOTN_BTN) >= 0) { // nica - 02.03.2011 - added return to quotation button
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="retquotebutton" id="mtgRetQuoteBtn'+id+'">'+this._messages.retQuote+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.DENY_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="denybutton" id="mtgDenyBtn'+id+'">'+this._messages.deny+'</span></a>';
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.DUPLICATE_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="duplicatebutton" id="mtgDuplicateBtn'+id+'">'+this._messages.duplicate+'</span></a>';
                beforeFlg = true;
            }
            
            if(elements.indexOf(MyTableGrid.REASSIGN_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="reassignbutton" id="mtgReassignBtn'+id+'">'+this._messages.reassign+'</span></a>';
                beforeFlg = true;
            }
            
            if(elements.indexOf(MyTableGrid.HISTORY_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="historybutton" id="mtgHistoryBtn'+id+'">'+this._messages.history+'</span></a>';
                beforeFlg = true;
            }            
            
            if(elements.indexOf(MyTableGrid.ATTACHMENT_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="attachmentbutton" id="mtgAttachmentBtn'+id+'">'+this._messages.attachment+'</span></a>';
                beforeFlg = true;
            }
            
            if(elements.indexOf(MyTableGrid.VIEW_BTN) >= 0) { // andrew
            	if (beforeFlg) html[idx++] = '<div class="toolbarsep">&#160;</div>';
                html[idx++] = '<a href="#" class="toolbarbtn"><span class="viewbutton" id="mtgViewBtn'+id+'">'+this._messages.view+'</span></a>';
                beforeFlg = true;
            }
            
            // right aligned buttons here
            if(elements.indexOf(MyTableGrid.FILTER_BTN) >= 0) { // andrew - 01.17.2011 - to add filter button
                html[idx++] = '<a class="toolbarbtn" style="float: right;"><span class="filterbutton" id="mtgFilterBtn'+id+'">'+this._messages.filter+'</span></a>';                
                html[idx++] = this._createFilterMenu();
                beforeFlg = true;
            }
            if(elements.indexOf(MyTableGrid.REFRESH_BTN) >= 0) { // andrew - 02.15.2011 - to add refresh button
            	if (beforeFlg) html[idx++] = '<div style="float: right;" class="toolbarsep">&#160;</div>';
                html[idx++] = '<a class="toolbarbtn" style="float: right;"><span class="refreshbutton" id="mtgRefreshBtn'+id+'">'+this._messages.refresh+'</span></a>';                
            }
            html[idx++] = '</div>';
            this.topPos += this.toolbarHeight + 1;
        }
        overlayTopPos = this.topPos;
        // Adding Header Row
        html[idx++] = '<div id="headerRowDiv'+id+'" class="mtgHeaderRow" style="position:absolute;top:'+this.topPos+'px;left:'+this.leftPos+'px;width:'+this.tableWidth+'px;height:'+this.headerHeight+'px;padding:0;overflow:hidden;z-index:0">';
        //header row box useful for drag and drop
        html[idx++] = '<div id="mtgHRB'+id+'" style="position:relative;padding:0;margin:0;width:'+(this.headerWidth+21)+'px;height:'+this.headerHeight+'px;">';
        // Adding Header Row Cells
        html[idx++] = this.hb._createHeaderRow();
        html[idx++] = '</div>'; // closes mtgHRB
        html[idx++] = '</div>'; // closes headerRowDiv
        this.topPos += this.headerHeight + 1;

        // Adding Body Area
        this.bodyHeight = this.tableHeight - this.headerHeight - 3;
        if (this.options.title) this.bodyHeight = this.bodyHeight - this.titleHeight - 1;
        if (this.options.pager) this.bodyHeight = this.bodyHeight - this.pagerHeight - 1;
        if (this.options.toolbar) this.bodyHeight = this.bodyHeight - this.toolbarHeight - 1;
        overlayHeight = this.bodyHeight + this.headerHeight;

        html[idx++] = '<div id="overlayDiv'+id+'" class="overlay" style="position:absolute;top:'+overlayTopPos+'px;width:'+(this.tableWidth+2)+'px;height:'+(overlayHeight+2)+'px;overflow:none;">';
        html[idx++] = '<div class="loadingBox" style="margin-top:'+((overlayHeight+2)/2 - 14)+'px">'+this._messages.loading+'</div>';
        html[idx++] = '</div>'; // closes overlay
        html[idx++] = '<div id="bodyDiv'+id+'" class="mtgBody" style="position:absolute;top:'+this.topPos+'px;left:'+this.leftPos+'px;width:'+this.tableWidth+'px;height:'+this.bodyHeight+'px;overflow:auto;">';
        html[idx++] = '<div id="innerBodyDiv'+id+'" class="mtgInnerBody" style="float:left;position:relative;top:0px;width:'+(this.tableWidth - this.scrollBarWidth)+'px;overflow:none;">';
        html[idx++] = '</div>'; // closes innerBodyDiv
        html[idx++] = '</div>'; // closes bodyDiv

        // Adding Pager Panel
        if (this.pager) {
            this.topPos += this.bodyHeight + 2;
            html[idx++] = '<div id="pagerDiv'+id+'" class="mtgPager" style="position:absolute;top:'+this.topPos+'px;left:0;bottom:0;width:'+(this.tableWidth - 4)+'px;height:'+(this.pagerHeight - 4)+'px">';
            html[idx++] = this._updatePagerInfo(true);
            html[idx++] = '</div>'; // closes Pager Div
        }

        // Adding Table Setting Button Control
        if (this.addSettingBehaviorFlg) {
            html[idx++] = '<div id="mtgSB'+id+'" class="mtgSettingButton" style="left:'+(this.tableWidth - 20)+'px">';
            html[idx++] = '</div>';
            // Adding Table Setting Menu
            html[idx++] = this._createSettingMenu();
        }
        
        // Adding Header Button Control        
        html[idx++] = '<div id="mtgHB'+id+'" class="mtgHeaderButton" style="width:14px;height:'+this.headerHeight+'px">';
        html[idx++] = '</div>';
        // Adding Header Button Menu
        html[idx++] = '<div id="mtgHBM'+id+'" class="mtgMenu">';
        html[idx++] = '<ul>';
        html[idx++] = '<li>';
        html[idx++] = '<a id="mtgSortAsc'+id+'" class="mtgMenuItem" href="javascript:void(0)">';
        html[idx++] = '<table cellspacing="0" cellpadding="0" width="100%" border="0">';
        html[idx++] = '<tr><td width="25"><span class="mtgMenuItemIcon mtgSortAscendingIcon">&nbsp;</span></td>';
        html[idx++] = '<td>'+this._messages.sortAsc+'</td></tr></table>';
        html[idx++] = '</a>';
        html[idx++] = '</li>';
        html[idx++] = '<li>';
        html[idx++] = '<a id="mtgSortDesc'+id+'" class="mtgMenuItem" href="javascript:void(0)">';
        html[idx++] = '<table cellspacing="0" cellpadding="0" width="100%" border="0">';
        html[idx++] = '<tr><td width="25"><span class="mtgMenuItemIcon mtgSortDescendingIcon">&nbsp;</span></td>';
        html[idx++] = '<td>'+this._messages.sortDesc+'</td></tr></table>';
        html[idx++] = '</a>';
        html[idx++] = '</li>';
        html[idx++] = '<li class="mtgSelectAll">';
        html[idx++] = '<a class="mtgMenuItem" href="javascript:void(0)">';
        html[idx++] = '<table cellspacing="0" cellpadding="0" width="100%" border="0">';
        html[idx++] = '<tr><td width="25"><span class="mtgMenuItemChk"><input type="checkbox" id="mtgSelectAll'+id+'"></span></td>';
        html[idx++] = '<td><label for="mtgSelectAll'+id+'">'+this._messages.selectAll+'</label></td></tr></table>'; //edit by Jerome Orio added label tag
        html[idx++] = '</a>';
        html[idx++] = '</li>';
        html[idx++] = '</ul>';
        html[idx++] = '</div>';

        // Adding resize markers
        html[idx++] = '<div id="resizeMarkerLeft'+id+'" class="mtgResizeMarker">';
        html[idx++] = '</div>';
        html[idx++] = '<div id="resizeMarkerRight'+id+'" class="mtgResizeMarker">';
        html[idx++] = '</div>';

        // Adding Dragging controls
        html[idx++] = '<div id="mtgColMoveTop'+id+'" class="mtgColMoveTop">&nbsp;</div>';
        html[idx++] = '<div id="mtgColMoveBottom'+id+'" class="mtgColMoveBottom">&nbsp;</div>';

        html[idx++] = '<div id="dragColumn'+id+'" class="dragColumn" style="width:100px;height:18px;">';
        html[idx++] = '<span class="columnTitle">&nbsp;</span>';
        html[idx++] = '<div class="drop-no">&nbsp;</div>';
        html[idx++] = '</div>';

        html[idx++] = '</div>'; // closes Table Div;
        return html.join('');
    },

    /**
     * Creates the Table Body
     */
    _createTableBody : function(rows) {
        var id = this._mtgId;
        var renderedRowsAllowed = this.renderedRowsAllowed;
        var renderedRows = this.renderedRows;
        var cellHeight = this.cellHeight;
        var headerWidth = this.headerWidth;
        var self = this;
        var html = [];
        var idx = 0;
        var firstRenderingFlg = false;
        if (renderedRows == 0) firstRenderingFlg = true;

        if (firstRenderingFlg) {
            this.innerBodyDiv.setStyle({height: (rows.length * cellHeight) + 'px'});
            html[idx++] = '<table id="mtgBT'+id+'" border="0" cellspacing="0" cellpadding="0" width="'+headerWidth+'" class="mtgBodyTable">';
            html[idx++] = '<tbody>';
        }
        var lastRowToRender = renderedRows + renderedRowsAllowed;
        if (lastRowToRender > rows.length) lastRowToRender = rows.length;
        this._showLoaderSpinner();
        for (var i = renderedRows; i < lastRowToRender; i++) {
//            (function(row, rowIdx) { // an idea that can improve performance
//                return function() {
//                    setTimeout(function(){ html[idx++] = self._createRow(row, rowIdx);},0);
//                };
//            })(rows[i],i)();
            //rows[i] = this._fromObjectToArray(rows[i]); // andrew
        	//html[idx++] = self._createRow(rows[i], i); // andrew
            html[idx++] = self._createRow(this._fromObjectToArray(rows[i]), i); // andrew
            renderedRows++;
        }

        if (firstRenderingFlg) {
            html[idx++] = '</tbody>';
            html[idx++] = '</table>';
        }
        this.renderedRows = renderedRows;
        setTimeout(function(){self._hideLoaderSpinner();},1.5); //just to see the spinner
        return html.join('');
    },

    /**
     * Creates a row
     */
    _createRow : function(row, rowIdx) {
        var id = this._mtgId;
        var tdTmpl = '<td id="mtgC{id}_{x},{y}" height="{height}" width="{width}" style="width:{width}px;height:{height}px;padding:0;margin:0;display:{display}" class="mtgCell mtgC{id} mtgC{id}_{x} mtgR{id}_{y}">';
        var icTmpl = '<div id="mtgIC{id}_{x},{y}" style="width:{width}px;height:{height}px;padding:3px;text-align:{align}" class="mtgInnerCell mtgIC{id} mtgIC{id}_{x} mtgIR{id}_{y}" title="{tooltipTitle}">'; // added tooltip March 6, 2012 - irwin
        var checkboxTmpl = '<input id="mtgInput{id}_{x},{y}" name="mtgInput{id}_{x},{y}" type="checkbox" value="{value}" class="mtgInput{id}_{x} mtgInputCheckbox" checked="{checked}">';
        var radioTmpl = '<input id="mtgInput{id}_{x},{y}" name="mtgInput{id}_{x},{y}" type="radio" value="{value}" class="mtgInput{id}_{x} mtgInputRadio"  checked="{checked}">'; // andrew - 11.09.2011
        var selectTmpl = '<select id="mtgInput{id}_{x},{y}" name="mtgInput{id}_{x}" class="mtgInput{id}_{x} mtgInputSelect" style="width:{width}px;">{options}</select>'; // andrew - 01.26.2011 - select box template
        var optionTmpl = '<option {selected} value="{value}" class="mtgOption">{text}</option>'; // andrew - 01.26.2011 - select box template
        if (Prototype.Browser.Opera || Prototype.Browser.WebKit) {
            checkboxTmpl = '<input id="mtgInput{id}_{x},{y}" name="mtgInput{id}_{x},{y}" type="checkbox" value="{value}" class="mtgInput{id}_{x}" checked="{checked}">';
            radioTmpl = '<input id="mtgInput{id}_{x},{y}" name="mtgInput{id}_{x}" type="radio" value="{value}" class="mtgInput{id}_{x}" checked="{checked}">';  // andrew - 11.09.2011
        }
        var rs = this.rowStyle || function(){return '';}; // row style handler
        var rc = this.rowClass || function(){return '';}; // row class handler
        var cellHeight = this.cellHeight;
        var iCellHeight = cellHeight - 6;
        var cm = this.columnModel;
        var fontSize = this.fontSize;
        var gap = (this.gap == 0)? 2 : 0;
        var html = [];
        var idx = 0;
        
        //added by Jerome Orio 12.20.2010 for sorting purposes to hide all deleted rows
        var delRowSort = "";
        for (var del=0; del<this.deletedRows.length; del++){
        	if(row[this.getColumnIndex('divCtrId')] == this.deletedRows[del].divCtrId){
        		delRowSort = "display:none;";
        	}	
        }	
        //end Jerome
        
        html[idx++] = '<tr id="mtgRow'+id+'_'+rowIdx+'" class="mtgRow'+id+' '+rc(rowIdx)+'" style="'+(delRowSort!=""?delRowSort:rs(rowIdx))+";"+(this.hideRowsOnLoad ? "display: none" : "")+'">';
        for (var j = 0; j < cm.length; j++) {
            var columnIdx = cm[j].positionIndex;
            var type = cm[j].type || 'string';          
            var cellWidth = parseInt(cm[j].width); // consider border at both sides
            var iCellWidth = cellWidth - 6 - gap; // consider padding at both sides
            var editor = cm[j].editor || null;
            var normalEditorFlg = !(editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox || editor == 'radio' || editor instanceof MyTableGrid.CellRadioButton || editor instanceof MyTableGrid.ComboBox || editor instanceof MyTableGrid.SelectBox); // andrew - 01.26.2011 - added condition for selectbox
            var alignment = 'left';
            var display = '\'\'';
    		var select = null;
            /* OPTIONS FOR GENIISYS
             * added by Jerome Orio 12.02.2010
             * for new option in column model */
            var maxlength = cm[j].maxlength || null; 
            var geniisysClass = cm[j].geniisysClass || null;
            var defaultValue = cm[j].defaultValue || false;
            var otherValue = cm[j].otherValue || false;
            var toUpperCase = cm[j].toUpperCase || false; // added for upper case. Irwin 05.27.11
            var radioGroup = cm[j].radioGroup||null; // added for radio group. Irwin 09.09.11
            var tooltip = cm[j].tooltip || null; // added for tooltip, if tooltipStrCondition and tooltipValue is not null, seperate condition apply, see below.
            var tooltipStrCondition = (cm[j].tooltipStrCondition != null ? cm[j].tooltipStrCondition.split(',') : null); //added for tooltip condition. irwin March 6, 2012
            var tooltipValue = (cm[j].tooltipValue != null ?cm[j].tooltipValue.split(','): null);//added for tooltip condition. irwin March 6, 2012
            var finalTitle = '';
            /* END - GENIISYS */
            var validValue = cm[j].validValue || null; // nica             
            var format = cm[j].format || "mm-dd-yyyy";
            
            if (!cm[j].hasOwnProperty('renderer')) {
                if (type == 'number') 
                    alignment = 'right';
                else if (type == 'boolean')
                    alignment = 'center';                
            }
            
            if (cm[j].hasOwnProperty('align')) {
                alignment = cm[j].align;
            }
            if (!cm[j].visible) {
                display = 'none';
            } 
            
            if(tooltipStrCondition != null && tooltipValue !=null){ // for tooltip- irwin march 6, 2012
            	for ( var tpIndex = 0; tpIndex < tooltipStrCondition.length; tpIndex++) {
            		if(tooltipStrCondition[tpIndex] ==  row[columnIdx]){
	            		finalTitle = nvl(tooltipValue[tpIndex], "");
	            	}
				}
            }else{
            	if(cm[j].tooltip != null){
            		finalTitle = cm[j].tooltip;
            	}
            }
           
            var temp = tdTmpl.replace(/\{id\}/g, id);
            temp = temp.replace(/\{x\}/g, j);
            temp = temp.replace(/\{y\}/g, rowIdx);
            temp = temp.replace(/\{width\}/g, cellWidth);
            temp = temp.replace(/\{height\}/g, cellHeight);
            temp = temp.replace(/\{display\}/g, display);
            html[idx++] = temp;
            temp = icTmpl.replace(/\{id\}/g, id);
            temp = temp.replace(/\{x\}/g, j);
            temp = temp.replace(/\{y\}/g, rowIdx);
            temp = temp.replace(/\{width\}/, iCellWidth);
            temp = temp.replace(/\{height\}/, iCellHeight);
            temp = temp.replace(/\{align\}/, alignment);
            temp = temp.replace(/\{tooltipTitle\}/,finalTitle); // added March 6, 2012 irwin tabisora
            html[idx++] = temp;
            
            if (normalEditorFlg) { // checkbox is a special case
                if (!cm[j].hasOwnProperty('renderer')) {
                	if(cm[j].type == "date"){ // added by andrew - 03.16.2011 - for date formatting
                		//html[idx++] = (row[columnIdx] == "" || row[columnIdx] == null ? row[columnIdx] : dateFormat(Date.parse(row[columnIdx]), format));
                		html[idx++] = (row[columnIdx] == "" || row[columnIdx] == null ? "" : dateFormat(row[columnIdx], format));
                	}else if(checkIfTableGridClassExist(geniisysClass, "money")) {
                		//html[idx++] = checkIfTableGridClassExist(geniisysClass, "money") ? formatCurrency(row[columnIdx]) :row[columnIdx]; //edit by Jerome Orio 12.02.2010 (html[idx++] = row[columnIdx]) - to format currency if money class exist
                		html[idx++] = formatCurrency(row[columnIdx]);
                	}else if(checkIfTableGridClassExist(geniisysClass, "rate")){//added geniisysClass 'rate' - nica 05.06.2011
                		html[idx++] = nvl(cm[j].deciRate,"") == "" ? formatToNineDecimal(row[columnIdx]) :formatToNthDecimal(row[columnIdx], cm[j].deciRate);
                	}else{
                		//html[idx++] = unescapeHTML2(String(row[columnIdx])); //nok added unescapteHTML2 10.14.2011
                		// andrew - removed unescapeHTML2 to display the actual value, this is to avoid displaying the value as part of the html page,
                		//        - for adding of new records in the grid, handling or escaping html should be done before passing the row
                		html[idx++] = nvl(String(row[columnIdx]), "");                 		
                	}
                } else {                	      		
                	html[idx++] = cm[j].renderer(checkIfTableGridClassExist(geniisysClass, "money") ? formatCurrency(row[columnIdx]) : //edit by Jerome Orio 12.02.2010 (html[idx++] = row[columnIdx]) - to format currency if money class exist
                								(checkIfTableGridClassExist(geniisysClass, "rate") ? (nvl(cm[j].deciRate,"") == "" ? formatToNineDecimal(row[columnIdx]) :formatToNthDecimal(row[columnIdx], cm[j].deciRate)) : unescapeHTML2(String(row[columnIdx])))); // edited by: nica 05.06.2011 - to format 'rate' geniisysClass   //nok added unescapteHTML2 10.14.2011        	
                }
            } else if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox) { // andrew - 11.09.2011            
            	var acceptedValue = validValue == null || validValue == undefined ? row[columnIdx] : validValue;
            	var rowValue = acceptedValue == row[columnIdx] ? row[columnIdx] : ""; // added by: nica 02.10.2011 to consider certain value                           	
            	
            	temp = checkboxTmpl.replace(/\{id\}/g, id);
                temp = temp.replace(/\{x\}/g, j);
                temp = temp.replace(/\{y\}/g, rowIdx);
                //temp = temp.replace(/\{value\}/, row[columnIdx]); replaced by: nica 02.10.2011 to accept valid value
                temp = temp.replace(/\{value\}/, rowValue);
                if (editor.selectable == undefined || !editor.selectable) {
                    if (editor.hasOwnProperty('getValueOf')) {
                        /*var trueVal = editor.getValueOf(true); //comment by Jerome Orio 12.20.2010
                        if (row[columnIdx] == trueVal) {
                            temp = temp.replace(/\{checked\}/, 'checked');
                        } else {
                            temp = temp.replace(/checked=.*?>/, '');
                        }*/
                    	
                    	/* comment by nok 09.14.2011
                    	// mark jm 08.26.2011 added this condition for checkbox rendering if column value is "Y" or "N"                    	
                    	defaultValue = nvl(row[columnIdx], false) ? (row[columnIdx] || cm[j].defaultValue) : false;

                    	if(row[columnIdx] != undefined){
                    		if(cm[j].editor.getValueOf(defaultValue)){
                    			temp = temp.replace(/\{checked\}/, 'checked');
                    		}else{
                    			temp = temp.replace(/checked=.*?>/, '');
                    		}
                    	}else{  */     
                    		//replace code above Jerome Orio 12.20.2010 add the mapping of other value
                            var trueVal = editor.getValueOf(true);
                            var falseVal = editor.getValueOf(false);
                            
                            if (otherValue){
                            	if (rowValue != falseVal) {
                                    temp = temp.replace(/\{checked\}/, 'checked');
                                } else {
                                    temp = temp.replace(/checked=.*?>/, '');
                                }
                            }else{
                            	if (rowValue == trueVal) {
                                    temp = temp.replace(/\{checked\}/, 'checked');
                                } else {
                                    temp = temp.replace(/checked=.*?>/, '');
                                }
                            }
                    	//}                    		
                    } else {
                        if (eval(rowValue)) {  //must be true or false 
                            temp = temp.replace(/\{checked\}/, 'checked');
                        } else {
                            temp = temp.replace(/checked=.*?>/, '');
                        }
                    }
                } else { // When is selectable
                    if (cm[j].selectAllFlg){
                        temp = temp.replace(/\{checked\}/, 'checked');
                    }else{
                        temp = temp.replace(/checked=.*?>/, '');
                    }    
                }
                html[idx++] = temp;
            } else if (editor == 'radio' || editor instanceof MyTableGrid.CellRadioButton) {
            	// modified by andrew - patterned from checkbox - 11.09.2011
            	// original content inside na block comment
            	/*temp = radioTmpl.replace(/\{id\}/g, id);
                temp = temp.replace(/\{x\}/g, j);
                temp = temp.replace(/\{y\}/g, rowIdx);
                temp = temp.replace(/\{value\}/, row[columnIdx]);
                html[idx++] = temp;*/
                
                var acceptedValue = validValue == null || validValue == undefined ? row[columnIdx] : validValue;
            	var rowValue = acceptedValue == row[columnIdx] ? row[columnIdx] : ""; // added by: nica 02.10.2011 to consider certain value
                temp = radioTmpl.replace(/\{id\}/g, id);
                temp = temp.replace(/\{x\}/g, j);
                temp = temp.replace(/\{y\}/g, rowIdx);
                temp = temp.replace(/\{value\}/, row[columnIdx]);
                                       	
            	if (editor.selectable == undefined || !editor.selectable) {
                    if (editor.hasOwnProperty('getValueOf')) {
                    		var trueVal = editor.getValueOf(true);
                            var falseVal = editor.getValueOf(false);
                            
                            if (otherValue){
                            	if (rowValue != falseVal) {
                                    temp = temp.replace(/\{checked\}/, 'checked');
                                } else {
                                    temp = temp.replace(/checked=.*?>/, '');
                                }
                            }else{
                            	if (rowValue == trueVal) {
                                    temp = temp.replace(/\{checked\}/, 'checked');
                                } else {
                                    temp = temp.replace(/checked=.*?>/, '');
                                }
                            }
                    	//}                    		
                    } else {
                        if (eval(rowValue)) {  //must be true or false 
                            temp = temp.replace(/\{checked\}/, 'checked');
                        } else {
                            temp = temp.replace(/checked=.*?>/, '');
                        }
                    }
                } else { // When is selectable
                    if (cm[j].selectAllFlg){
                        temp = temp.replace(/\{checked\}/, 'checked');
                    }else{
                        temp = temp.replace(/checked=.*?>/, '');
                    }    
                }
                html[idx++] = temp;
            } else if (editor instanceof MyTableGrid.ComboBox) {
                if (!cm[j].hasOwnProperty('renderer')) {
                    cm[j].renderer = function(value, list) {
                        var result = value;
                        for (var i = 0; i < list.length; i++) {
                            if (list[i].value == value) result = list[i].text;
                        }
                        return result;
                    };
                }
                html[idx++] = cm[j].renderer(row[columnIdx], editor.list);
            } else if (editor instanceof MyTableGrid.SelectBox) { // andrew - 01.26.2011 - added this 'else if' block for select box editor
            	var optTemp = "";
        		var options = "";
        		var optList = editor.list;
        		
        		for(var i=0; i<optList.length; i++){
        			optTemp = optionTmpl.replace(/\{value\}/g, optList[i].value);
        			optTemp = optTemp.replace(/\{text\}/g, optList[i].text);
        			optTemp = optTemp.replace(/\{selected\}/g, (row[columnIdx] == optList[i].value ? 'selected="selected"' : ''));
        			options += optTemp;
        		}
        		
        		temp = selectTmpl.replace(/\{id\}/g, id);
        		temp = temp.replace(/\{x\}/g, j);
        		temp = temp.replace(/\{y\}/g, rowIdx);
        		temp = temp.replace(/\{width\}/, iCellWidth);
        		temp = temp.replace(/\{options\}/g, options);
        		html[idx++] = temp;
            }
            
            html[idx++] = '</div>';
            html[idx++] = '</td>';
        }
        html[idx++] = '</tr>';
        return html.join('');
    },

    _toggleLoadingOverlay : function() {
        var id = this._mtgId;
        var overlayDiv = $('overlayDiv'+id);
        if (overlayDiv.getStyle('visibility') == 'hidden') {
            this._hideMenus();
            overlayDiv.setStyle({visibility : 'visible'});
        } else {
            overlayDiv.setStyle({visibility : 'hidden'});
        }
    },
    /**
     * Applies cell callbacks
     */
    _applyCellCallbacks : function() {
        var renderedRows = this.renderedRows;
        var renderedRowsAllowed = this.renderedRowsAllowed;
        var beginAtRow = renderedRows - renderedRowsAllowed;
        if (beginAtRow < 0) beginAtRow = 0;
        for (var j = beginAtRow; j < renderedRows; j++) {
            this._applyCellCallbackToRow(j);
        }
    },

    _applyCellCallbackToRow : function(y) {
        var id = this._mtgId;
        var cm = this.columnModel;
        var self = this;
        for (var i = 0; i < cm.length; i++) {
        	//edited by Jerome Orio 12.06.2010
        	//var editor = cm[i].editor
        	var editor = {};
            editor.editor = cm[i].editor;
            editor.testId = cm[i].id;
            //end jerome
            if ((editor.editor == 'radio' || editor.editor instanceof MyTableGrid.CellRadioButton) 
            	 || (editor.editor == 'checkbox' || editor.editor instanceof MyTableGrid.CellCheckbox)
            	 || editor.editor instanceof MyTableGrid.SelectBox // andrew - 02.17.2011
            	 ){             	
                var element = $('mtgInput'+id + '_' + i + ',' + y);
                var innerElement = $('mtgIC'+id + '_' + i + ',' + y);
                if (!cm[i].editable){$('mtgInput'+id + '_' + i + ',' + y).disable();} //added by Jerome Orio 12.10.2010 to disable checkbox if editable is false
                if (y<0 && cm[i].editableOnAdd){$('mtgInput'+id + '_' + i + ',' + y).enable();} //added by Jerome Orio enable checkbox if editableOnAdd is true
                if(editor.editor instanceof MyTableGrid.SelectBox){ // andrew - 02.17.2011 - added this 'if' block for selectbox
                    element.onchange = (function(editor, element, innerElement){
                    	return function() {
	                    	/*if (self.onCellFocus) {
	                    		alert("YYY : " + y);
	                            self.onCellFocus(element, self.rows[i], i, y, editor.testId);
	                        }*/
                            var coords = element.id.substring(element.id.indexOf('_') + 1, element.id.length).split(',');
                            var x = coords[0]*1;
                            var y = coords[1]*1;
                            var value = element.value;
                            if (editor.editor.hasOwnProperty('getValueOf'))value = editor.editor.getValueOf(element);
                            self.setValueAt(value, x, y, false);
                            if (y >= 0 && self.modifiedRows.indexOf(y) == -1) self.modifiedRows.push(y);        
	                        if (editor.editor.onChangeCallback) editor.editor.onChangeCallback(element.value, element);
	                        if (y<0) return;
	                        innerElement.addClassName('modifiedCell');
	                    };
	                })(editor, element, innerElement);                    
                } else {                	
	                element.onclick = (function(editor, element, innerElement) {
	                    return function() {
	                    	// comment out by andrew - 02.18.2011 - click event is handled in action event triggered when you click a cell
	                    	// the same with _editCellElement function
	                    	
	                    	/*if (self.onCellFocus) { //added by Jerome Orio 12.20.2010 to fire onCellFocus everytime you click the checkbox/radio button
	                            self.onCellFocus(element, self.rows[i], i, y, editor.testId);
	                        }*/
	                        if(editor.editor.selectable == undefined || !editor.editor.selectable){
	                            var coords = element.id.substring(element.id.indexOf('_') + 1, element.id.length).split(',');
	                            var x = coords[0]*1;//added *1 by jerome orio 12.08.2010 - to make it as a number
	                            var y = coords[1]*1;//added *1 by jerome orio 12.08.2010 - to make it as a number
	                            var value = element.checked;
	                            if (editor.editor.hasOwnProperty('getValueOf'))value = editor.editor.getValueOf(element.checked);
	                            self.setValueAt(value, x, y, false);
	                            //if (editor.testId == "recordStatus" && editor.editor == 'checkbox'){ return; }//added by Jerome Orio 12.06.2010 - return if checkbox id is recordStatus
	                            //if (y >= 0 && self.modifiedRows.indexOf(y) == -1) self.modifiedRows.push(y); //if doesn't exist in the array the row is registered 
	                        }
	                        /*
	                        if (editor.testId == "recordStatus" && editor.editor == 'checkbox'){ return; }//added by Jerome Orio 12.06.2010 - return if checkbox id is recordStatus
	                        if (editor.editor.onClickCallback) editor.editor.onClickCallback(element.value, element.checked);
	                        if (y<0) return; //jerome
	                        innerElement.addClassName('modifiedCell');*/
	                    };
	                })(editor, element, innerElement);
                }
            } 
        }
    },

    getId : function() {
        return this._mtgId;
    },
    
    _showLoaderSpinner : function() {
        var id = this._mtgId;
        var loaderSpinner = $('mtgLoader'+id);
        if(loaderSpinner) loaderSpinner.show();
    },

    _hideLoaderSpinner : function() {
        var id = this._mtgId;
        var loaderSpinner = $('mtgLoader'+id);
        if(loaderSpinner) loaderSpinner.hide();
    },

    _hideMenus : function() {
        var id = this._mtgId;
        var hb = $('mtgHB'+id);
        var hbm = $('mtgHBM'+id);
        var sm = $('mtgSM'+id);
        if (hb) hb.setStyle({visibility: 'hidden'});
        if (hbm) hbm.setStyle({visibility: 'hidden'});
        if (sm) sm.setStyle({visibility: 'hidden'});
    },
    /**
     * Creates the Setting Menu
     */
    _createSettingMenu : function() {
        var id = this._mtgId;
        var cm = this.columnModel;
        var bh = this.bodyHeight + 30;
        var cellHeight = (Prototype.Browser.IE)? 25 : 22;
        var height = (cm.length * 25 > bh)? bh : cm.length * cellHeight;
        var html = [];
        var idx = 0;
        html[idx++] = '<div id="mtgSM'+id+'" class="mtgMenu" style="height:'+height+'px">';
        html[idx++] = '<ul>';
        for (var i = 0; i < cm.length; i++) {
            var column = cm[i];
            html[idx++] = '<li>';
            html[idx++] = '<a href="#" class="mtgMenuItem">';
            html[idx++] = '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
            html[idx++] = '<tr><td width="25"><span><input id="'+column.id+'" type="checkbox" checked="'+column.visible+'"></span></td>';
            html[idx++] = '<td><label for="'+column.id+'">&nbsp;'+ column.title+'</label></td></tr>';
            html[idx++] = '</table>';
            html[idx++] = '</a>';
            html[idx++] = '</li>';
        }
        html[idx++] = '</ul>';
        html[idx++] = '</div>';
        return html.join('');
    },

    /**
     * @author andrew robes
     * @date 01.18.2011
     * @description Creates the Filter Menu
     */
    _createFilterMenu : function() {
        var id = this._mtgId;
        var cm = this.columnModel;
        var bh = this.bodyHeight + 30;
        var cellHeight = (Prototype.Browser.IE)? 25 : 22;
        //var height = (cm.length * 25 > bh)? bh : cm.length * cellHeight;
        var html = [];
        var idx = 0;
        var filterOptions = new Array();        
		
        html[idx++] = '<div id="mtgHBMFilter'+id+'" class="mtgFilterMenu" style="height:145px; width: 445px;">';
        html[idx++] = '<table><tr>';
        html[idx++] = '<td><label>Filter By: </label></td><td><select id="mtgFilterBy'+id+'">';
        // get the filter options
        var option = null;
        for (var i = 0; i < cm.length; i++) {
            var column = cm[i];
            option = new Object();
            if(column.filterOption) {
                option.id = column.id;
                option.filterOptionType = column.filterOptionType;
                option.title = (nvl(column.filterOptionType,"") == "checkbox" ? column.altTitle+" (Y/N)" :column.title); //edit by nok for adding (Y/N) in tile if checkbox
                filterOptions.push(option);
                delete option;
            }
            if (column.hasOwnProperty('children') && column.children.length > 0) { //added this part for column with children - nok 05.12.2011
                children = column.children;
                for (j = 0; j < children.length; j++) {
                    if(children.filterOption) {
                        option.id = children[j].id;
                        option.filterOptionType = children[j].filterOptionType;
                        option.title = (nvl(column.filterOptionType,"") == "checkbox" ? column.altTitle+" (Y/N)" :column.title); //edit by nok for adding (Y/N) in tile if checkbox
                        filterOptions.push(option);
                        delete option;
                    }
                }
            }
        }
        // sorts the filter options
        filterOptions.sort(function (a, b){
		    var x = a.title.toLowerCase();
			var y = b.title.toLowerCase();
			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		});
        // add the filter options to the select box
        for (var i = 0; i < filterOptions.length; i++) {
            html[idx++] = '<option value="'+filterOptions[i].id+'" filterType="'+filterOptions[i].filterOptionType+'">';
	        html[idx++] = filterOptions[i].title + '</option>';
        }
        
        html[idx++] = '</select></td>';
        html[idx++] = '<td><label>Keyword: </label></td><td><input type="text" id="mtgKeyword'+id+'"></td>';
        html[idx++] = '</tr>';
        html[idx++] = '<tr><td colspan="4"><input id="mtgBtnAddFilter'+id+'" type="button" class="button" value="Add Filter" style="float: right;"/></td></tr>';
        html[idx++] = '<tr><td><label>Filter Text: </label></td><td colspan="3">';
        html[idx++] = '<textarea id="mtgFilterText'+id+'" readonly="readonly" style="resize: none; height: 35px; margin-top: 5px; width: 346px; float: left;"></textarea>';
        html[idx++] = '</td></tr><tr><td colspan="4" align="right"><input id="mtgBtnOkFilter'+id+'" type="button" class="button" value="Ok" style="float: right;">';
        html[idx++] = '<input id="mtgBtnClearFilter'+id+'" type="button" class="button" value="Clear Filter" style="float: right; width: 90px;">';
        html[idx++] = '</td></tr></table></div>';
        return html.join('');
    },
    
    /**
     * @author andrew robes
     * @date 01.20.2011
     * @description Applies filter menu behavior
     */    
    _applyFilterMenuBehavior : function() {
    	var self = this;
    	var clearFilterButton = $('mtgBtnClearFilter'+this._mtgId);
    	var okButton = $('mtgBtnOkFilter'+this._mtgId);
    	var addFilterButton = $('mtgBtnAddFilter'+this._mtgId);    	
    	var keyWord = $('mtgKeyword'+this._mtgId);
    	var filterBy = $('mtgFilterBy'+this._mtgId);
    	var filterText = $('mtgFilterText'+this._mtgId);
    	var settingMenu = $('mtgHBMFilter' + this._mtgId);
    	var filterButton = $('mtgFilterBtn'+this._mtgId);
    	    	
    	Event.observe(clearFilterButton, 'click', function(){
    		self.objFilter = {};
    		filterText.value = "";
    		if(keyWord.value.trim() == "") {
    			filterBy.selectedIndex = 0;
    		}
    		keyWord.focus();
    	});
    	
    	// modified by: nica 02.10.2011 - validate type of entered keyword first before adding to objFilter
    	Event.observe(addFilterButton, 'click', addFilter);
    	
    	Event.observe(okButton, 'click', function(){
    		settingMenu.setStyle({visibility: 'hidden'});
    		keyWord.value = "";
    		self.filterText = filterText.value;
    		if(trim(self.filterText) != ""){
    			filterButton.removeClassName("filterbutton");
    			filterButton.addClassName("filterbutton_red");
    			/*if (self.options.toolbar.onFilter) {
                	ok = self.options.toolbar.onFilter.call();
                }*/ // moved by: nica 01.18.2012
    		} else {
    			filterButton.removeClassName("filterbutton_red");
    			filterButton.addClassName("filterbutton");
    		}
    		if (self.options.toolbar.onFilter) {
            	ok = self.options.toolbar.onFilter.call();
            }
    		filterButton.up().removeClassName("toolbarbtn_selected");
    		self._retrieveDataFromUrl.call(self, 1);    		
    	});
    	
    	Event.observe(keyWord, "keypress", function(event){
    		if(keyWord.value.trim() != "" && event.keyCode == 13){
    			addFilter();
    		} else if (keyWord.value.trim() == "" && filterText.value.trim() != "" && event.keyCode == 13){
    			fireEvent(okButton, "click");
    		}
    	});
    	
    	function addFilter(){
    		for(var i=0; i <keyWord.value.length; i++){
    			if(keyWord.value[i] == '\\'){
        			showWaitingMessageBox("Invalid character.", "I", function(){
        				keyWord.clear();
        				keyWord.focus();
        			});
        			return;
        		}
    		}
    		var optionType = filterBy.options[filterBy.selectedIndex].getAttribute("filterType");
    		var filterOption = filterBy.options[filterBy.selectedIndex].text;
    		
    		if(trim(keyWord.value) != ""){
    			if(validateFilterKeywordOnTableGrid(filterOption, optionType, keyWord.value)){
    				if (optionType.include("number") || optionType.include("integer")) keyWord.value = keyWord.value.toString().replace(/\$|\,/g,''); //added by nok 12.09.11
	    			self.objFilter[filterBy.value] = keyWord.value; //removed trim by Fons 11.15.2013
	    			filterText.value = "";
	    			for (var property in self.objFilter){
	    				for(var i=0; i<filterBy.options.length; i++){    					
	    					if(property == filterBy.options[i].value){
	    						filterText.value+=filterBy.options[i].text+"="+self.objFilter[property]+";";
	    					}
	    				}
	    			}
    			}
    			keyWord.value = "";
    			keyWord.focus();
    		}    		
    	}
    },
    
    /**
     * Applies Setting Menu behavior
     */
    _applySettingMenuBehavior : function() {
        var settingMenu = $('mtgSM' + this._mtgId);
        var settingButton = $('mtgSB' + this._mtgId);

        var width = settingMenu.getWidth();

        Event.observe(settingButton, 'click', function() {
            if (settingMenu.getStyle('visibility') == 'hidden') {
                var topPos = settingButton.offsetTop;
                var leftPos = settingButton.offsetLeft;
                settingMenu.setStyle({
                    top: (topPos + 16) + 'px',
                    left: (leftPos - width + 16) + 'px',
                    visibility: 'visible'
                });
            } else {
                settingMenu.setStyle({visibility: 'hidden'});
            }
        });

        var miFlg = false;
        Event.observe(settingMenu, 'mousemove', function() {
            miFlg = true;
        });

        Event.observe(settingMenu, 'mouseout', function(event) {
            miFlg = false;
            var element = event.element();
            setTimeout(function() {
                if (!element.descendantOf(settingMenu) && !miFlg)
                    settingMenu.setStyle({visibility: 'hidden'});
            },500);
        });

        var self = this;
        $$('#mtgSM' + this._mtgId + ' input[@type:checkbox]').each(function(checkbox, index) {
            checkbox.onclick = function() {
                self._toggleColumnVisibility(index, checkbox.checked);
            };
        });
    },

    /**
     * Synchronizes horizontal scrolling
     */
    _syncScroll : function() {
        var id = this._mtgId;
        var keys = this.keys;
        var bodyDiv = this.bodyDiv;
        var headerRowDiv = this.headerRowDiv;
        var bodyTable = this.bodyTable;
        var renderedRows = this.renderedRows;

        this.scrollLeft = headerRowDiv.scrollLeft = bodyDiv.scrollLeft;
        this.scrollTop = bodyDiv.scrollTop;

        $('mtgHB' + id).setStyle({visibility: 'hidden'});
        //$('mtgHBM' + id).setStyle({visibility: 'hidden'});

        //comment out by Jerome Orio
        /*if(renderedRows < this.rows.length
            && (bodyTable.getHeight() - bodyDiv.scrollTop - 10) < bodyDiv.clientHeight) {
            var html = this._createTableBody(this.rows);
            bodyTable.down('tbody').insert(html);
            this._addKeyBehavior();
            this._applyCellCallbacks();
            keys.addMouseBehavior();
        }*/
    },

    /**
     * Makes all columns resizable
     */
    _makeAllColumnResizable : function() {
        var id = this._mtgId;
        var headerHeight = this.headerHeight;
        var scrollBarWidth = this.scrollBarWidth;
        var topPos = 0;
        if (this.options.title) topPos += this.titleHeight;
        if (this.options.toolbar) topPos += this.toolbarHeight;
        var columnIndex;
        var self = this;
        var leftPos = 0;
        $$('.mtgHS' + this._mtgId).each(function(separator, index) {
            Event.observe(separator, 'mousemove', function() {
                columnIndex = parseInt(separator.id.substring(separator.id.indexOf('_') + 1, separator.id.length));
                if (columnIndex >= 0) {
                    leftPos = $('mtgHC' + id + '_' + columnIndex).offsetLeft - self.scrollLeft;
                    leftPos += $('mtgHC' + id + '_' + columnIndex).offsetWidth - 1;
                    self.resizeMarkerRight.setStyle({
                        height: (self.bodyHeight + headerHeight) + 'px',
                        top: (topPos + 2) + 'px',
                        left: leftPos + 'px'
                    });
                }
            });
        });

        new Draggable(self.resizeMarkerRight, {
            constraint: 'horizontal',
            onStart : function() {
                var markerHeight = self.bodyHeight + headerHeight + 2;
                if (self._hasHScrollBar()) markerHeight = markerHeight - scrollBarWidth + 1;

                self.resizeMarkerRight.setStyle({
                    height: markerHeight + 'px',
                    backgroundColor: 'dimgray'
                });

                var leftPos = $('mtgHC' + id + '_' + columnIndex).offsetLeft - self.scrollLeft;

                self.resizeMarkerLeft.setStyle({
                    height: markerHeight + 'px',
                    top: (topPos + 2) + 'px',
                    left: leftPos + 'px',
                    backgroundColor: 'dimgray'
                });
            },

            onEnd : function() {
                var newWidth = parseInt(self.resizeMarkerRight.getStyle('left')) - parseInt(self.resizeMarkerLeft.getStyle('left'));
                if (newWidth > 10 && columnIndex != null) {
                    setTimeout(function() {
                        self._resizeColumn(columnIndex, newWidth);
                    }, 0);
                }

                self.resizeMarkerLeft.setStyle({
                    backgroundColor: 'transparent',
                    left: 0
                });

                self.resizeMarkerRight.setStyle({
                    backgroundColor: 'transparent'
                });
            },
            endeffect : false
        });
    },

    /**
     * Resizes a column to a new size
     *
     * @param index the index column position
     * @param newWidth resizing width
     */
    _resizeColumn: function(index, newWidth) {
        var id = this._mtgId;
        var cm = this.columnModel;
        var gap = this.gap;
        var self = this;

        var oldWidth = parseInt($('mtgHC' + id + '_' + index).width);
        var editor = cm[index].editor;
        var checkboxOrRadioFlg = (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox || editor == 'radio' || editor instanceof MyTableGrid.CellRadioButton);
        var selectBoxFlg = (editor == 'select' || editor instanceof MyTableGrid.SelectBox); // andrew - 01.27.2011 - added condition for select editor
        
        $('mtgHC' + id + '_' + index).width = newWidth;
        $('mtgHC' + id + '_' + index).setStyle({width: newWidth + 'px'});
        $('mtgIHC' + id + '_' + index).setStyle({width: (newWidth - 8 - ((gap == 0) ? 2 : 0)) + 'px'});

        $$('.mtgC' + id + '_' + index).each(function(cell) {
            cell.width = newWidth;
            cell.setStyle({width: newWidth + 'px'});
        });

    	$$('.mtgIC' + id + '_' + index).each(function(cell) {
            var cellId = cell.id;
            var coords = cellId.substring(cellId.indexOf('_') + 1, cellId.length).split(',');
            var y = coords[1];
            var value = self.getValueAt(index, y);
            cell.setStyle({width: (newWidth - 6 - ((gap == 0) ? 2 : 0)) + 'px'});
            if (!checkboxOrRadioFlg) { // andrew - 01.27.2011 - added condition for select box
                if (cm[index].renderer) {
                    if (editor instanceof MyTableGrid.ComboBox)
                        value = cm[index].renderer(value, editor.list);
                    else
                        value = cm[index].renderer(value);
                }else{
                	/* OPTIONS FOR GENIISYS
                     * added by Jerome Orio 12.02.2010
                     * for new option in column model */
                    var geniisysClass = cm[index].geniisysClass; 
                    var deciRate = cm[index].deciRate || ""; 
                    if (checkIfTableGridClassExist(geniisysClass, "money")){
                      	value = formatCurrency(value);	
                    }else if(checkIfTableGridClassExist(geniisysClass, "rate")){ // 'rate' Class added by: nica 05.06.2011
                    	value = nvl(deciRate,"") == "" ? formatToNineDecimal(value) :formatToNthDecimal(value, deciRate);
                    }
                    /* END - GENIISYS */      
                }
                
                if(value != undefined && value != "") {
                	cell.innerHTML = value;
                }
            }
        });
    	
    	// andrew -01.27.2011 -added this if block to handle resizing of select box
    	if (selectBoxFlg) {
        	$$('.mtgInput' + id + '_' + index).each(function(select) {
        		select.setStyle({width: (newWidth - 6 - ((gap == 0) ? 2 : 0)) + 'px'});
        	});
        }

        this.headerWidth = this.headerWidth - (oldWidth - newWidth);

        $('mtgHRT' + id).width = this.headerWidth + 21;
        $('mtgBT' + id).width = this.headerWidth;

        this.columnModel[index].width = newWidth;
        this._syncScroll();
    },

    _hasHScrollBar : function() {
        return (this.headerWidth + 20) > this.tableWidth;
    },

    /**
     * Makes all columns draggable
     */
    _makeAllColumnDraggable : function() {
        this.separators = [];
        var i = 0;
        var id = this._mtgId;
        var self = this;
        $$('.mtgHS' + this._mtgId).each(function(separator) {
            self.separators[i++] = separator;
        });

        var topPos = 0;
        if (this.options.title) topPos += this.titleHeight;
        if (this.options.toolbar) topPos += this.toolbarHeight;

        var dragColumn = $('dragColumn' + id);

        $$('.mtgIHC' + id).each(function(column, index) {
            var columnIndex = -1;
            Event.observe(column, 'mousemove', function() {
                var leftPos = column.up().offsetLeft;
                dragColumn.setStyle({
                    top: (topPos + 15) + 'px',
                    left: (leftPos - self.scrollLeft + 15) + 'px'
                });
            });
            new Draggable(dragColumn, {
                handle : column,
                onStart : function() {
                    for (var i = 0; i < self.columnModel.length; i++) {
                        if (index == self.columnModel[i].positionIndex) {
                            columnIndex = i;
                            break;
                        }
                    }
                    if (Prototype.Browser.IE) {
                        // The drag might register an ondrag or onselectstart event when using IE
                        Event.observe(document.body, "drag", function() {return false;}, false);
                        Event.observe(document.body, "selectstart",	function() {return false;}, false);
                    }
                    dragColumn.down('span').innerHTML = self.columnModel[columnIndex].title;
                    dragColumn.setStyle({visibility: 'visible'});
                },
                onDrag : function() {
                    var leftPos = parseInt(dragColumn.getStyle('left'));
                    var width = parseInt(dragColumn.getStyle('width'));
                    setTimeout(function(){
                        self._detectDroppablePosition(leftPos + width / 2, width, dragColumn, columnIndex);
                    }, 0);
                },
                onEnd : function() {
                    dragColumn.setStyle({visibility: 'hidden'});
                    self.colMoveTopDiv.setStyle({visibility: 'hidden'});
                    self.colMoveBottomDiv.setStyle({visibility: 'hidden'});
                    if (columnIndex >=0 && self.targetColumnId >= 0) {
                        setTimeout(function(){
                            self._moveColumn(columnIndex, self.targetColumnId);
                            columnIndex = -1;
                        }, 0);
                    }
                },
                endeffect : false
            });
        });
    },

    /**
     * Detects dropable position when the mouse pointer is over a header cell
     * separator
     */
    _detectDroppablePosition : function(columnPos, width, dragColumn, index) {
        var topPos = -10;
        if (this.options.title) topPos += this.headerHeight;
        if (this.options.toolbar) topPos += this.headerHeight;
        var sepLeftPos = 0;
        var cm = this.columnModel;
        var gap = this.gap;
        var scrollLeft = this.scrollLeft;
        var colMoveTopDiv = this.colMoveTopDiv;
        var colMoveBottomDiv = this.colMoveBottomDiv;

        for (var i = 0; i < cm.length; i++) {
            if (cm[i].visible) sepLeftPos += parseInt(cm[i].width) + gap;
            if (columnPos > (sepLeftPos - scrollLeft)
                    && (columnPos - (sepLeftPos - this.scrollLeft)) < (width / 2)) {
                colMoveTopDiv.setStyle({
                    top: topPos + 'px',
                    left: (sepLeftPos - scrollLeft - 4) + 'px',
                    visibility : 'visible'
                });
                colMoveBottomDiv.setStyle({
                    top: (topPos + 34) + 'px',
                    left: (sepLeftPos - scrollLeft - 4) + 'px',
                    visibility : 'visible'
                });
                this.targetColumnId = i;
                dragColumn.down('div').className = (i != index)? 'drop-yes' : 'drop-no';
                break;
            } else {
                colMoveTopDiv.setStyle({visibility : 'hidden'});
                colMoveBottomDiv.setStyle({visibility : 'hidden'});
                this.targetColumnId = null;
                dragColumn.down('div').className = 'drop-no';
            }
        }
    },

    /**
     * Moves a column from one position to a new one
     *
     * @param fromColumnId initial position
     * @param toColumnId target position
     */
    _moveColumn : function(fromColumnId, toColumnId) {
        // Some validations
        if (fromColumnId == null
            || toColumnId == null
            || fromColumnId == toColumnId
            || (toColumnId + 1 == fromColumnId && fromColumnId == this.columnModel.length -1)) return;

        var id = this._mtgId;
        var cm = this.columnModel;
        var keys = this.keys;
        var renderedRows = this.renderedRows;
        var numberOfRowsAdded = this.newRowsAdded.length;

        $('mtgHB' + id).setStyle({visibility: 'hidden'}); // in case the cell menu button is visible
        this._blurCellElement(keys._nCurrentFocus); //in case there is a cell in editing mode
        keys.blur(); //remove the focus of the selected cell

        var removedHeaderCell = null;
        var targetHeaderCell = null;
        var removedCells = null;
        var tr = null;
        var targetId = null;
        var targetCell = null;
        var idx = 0;
        var i = 0;
        var last = null;

        if (toColumnId == 0) { // moving to the left to first column
            removedHeaderCell = $('mtgHC'+id+'_'+fromColumnId).remove();
            targetHeaderCell = $('mtgHC'+id+'_'+ toColumnId);
            targetHeaderCell.up().insertBefore(removedHeaderCell, targetHeaderCell);

            // Moving cell elements
            removedCells = [];
            idx = 0;
            $$('.mtgC'+id+'_'+fromColumnId).each(function(element){
                removedCells[idx++] = element.remove();
            });

            if (numberOfRowsAdded > 0) {
                for (i = -numberOfRowsAdded; i < 0; i++) {
                    targetCell = $('mtgC'+id+'_'+toColumnId+','+i);
                    targetCell.up().insertBefore(removedCells[i+numberOfRowsAdded], targetCell);
                }
            }

            for (i = numberOfRowsAdded; i < (renderedRows+numberOfRowsAdded); i++) {
                targetCell = $('mtgC'+id+'_'+toColumnId+','+(i-numberOfRowsAdded));
                targetCell.up().insertBefore(removedCells[i], targetCell);
            }
        } else if (toColumnId > 0 && toColumnId < cm.length - 1) { // moving in between
            removedHeaderCell = $('mtgHC'+id+'_'+fromColumnId).remove();
            targetId = toColumnId + 1;
            if (targetId == fromColumnId) targetId--;
            targetHeaderCell = $('mtgHC'+id+'_'+ targetId);
            targetHeaderCell.up().insertBefore(removedHeaderCell, targetHeaderCell);

            // Moving cell elements
            removedCells = [];
            idx = 0;
            $$('.mtgC'+id+'_'+fromColumnId).each(function(element){
                removedCells[idx++] = element.remove();
            });

            if (numberOfRowsAdded > 0) {
                for (i = -numberOfRowsAdded; i < 0; i++) {
                    targetCell = $('mtgC'+id+'_'+targetId+','+i);
                    targetCell.up().insertBefore(removedCells[i+numberOfRowsAdded], targetCell);
                }
            }

            for (i = numberOfRowsAdded; i < (renderedRows+numberOfRowsAdded); i++) {
                targetCell = $('mtgC'+id+'_'+targetId+','+(i-numberOfRowsAdded));
                targetCell.up().insertBefore(removedCells[i], targetCell);
            }
        } else if (toColumnId == cm.length - 1) { // moving to the last column
            tr = $('mtgHC'+id+'_'+fromColumnId).up();
            removedHeaderCell = $('mtgHC'+id+'_'+fromColumnId).remove();
            last = $('mtgHC'+id+'_'+ cm.length);
            tr.insertBefore(removedHeaderCell, last);

            // Moving cell elements
            removedCells = [];
            idx = 0;
            $$('.mtgC'+id+'_'+fromColumnId).each(function(element){
                removedCells[idx++] = element.remove();
            });

            if (numberOfRowsAdded > 0) {
                for (i = -numberOfRowsAdded; i < 0; i++) {
                    tr = $('mtgRow'+id+'_'+i);
                    tr.insert(removedCells[i+numberOfRowsAdded]);
                }
            }

            for (i = numberOfRowsAdded; i < (renderedRows+numberOfRowsAdded); i++) {
                tr = $('mtgRow'+id+'_'+(i-numberOfRowsAdded));
                tr.insert(removedCells[i]);
            }
        }

        // Update column model
        var columnModelLength = cm.length;
        var columnModelEntry = cm[fromColumnId];
        cm[fromColumnId] = null;
        cm = cm.compact();
        var aTemp = [];
        var k = 0;
        var targetColumnId = toColumnId;
        if (toColumnId > 0 && toColumnId < fromColumnId) targetColumnId++;
        if (targetColumnId == fromColumnId) targetColumnId--;
        for (var c = 0; c < columnModelLength; c++) {
            if (c == targetColumnId) aTemp[k++] = columnModelEntry;
            if (c < (columnModelLength - 1))
                aTemp[k++] = cm[c];
        }
        cm = this.columnModel = aTemp;
        var htr = $('mtgHRT'+id).down('tr');
        htr.getElementsBySelector('th').each(function(th, index){
            if (index < cm.length) {
                th.id = 'mtgHC'+id+'_'+index;
                var ihc = th.down('div');
                ihc.id = 'mtgIHC'+id+'_'+index;
                ihc.down('span').id = 'mtgSortIcon'+id+'_'+index;
                ihc.down('div').id = 'mtgHS'+id+'_'+index;
            }
        });

        // Recreates cell indexes
        for (i = -numberOfRowsAdded; i < renderedRows; i++) {
            $$('.mtgR'+id+'_'+i).each(function(td, index) {
                td.id = 'mtgC'+id+'_'+index+','+i;
                td.className = 'mtgCell mtgC'+id+' mtgC'+id+'_'+index+' mtgR'+id+'_'+i;
            });

            $$('.mtgIR'+id+'_'+i).each(function(div, index) {
                div.id = 'mtgIC'+id+'_'+index+','+i;
                var modifiedCellClass = (div.className.match(/modifiedCell/)) ? ' modifiedCell' : '';
                div.className = 'mtgInnerCell mtgIC'+id+' mtgIC'+id+'_'+index+' mtgIR'+id+'_'+i+modifiedCellClass;
                if (div.firstChild && div.firstChild.tagName == 'INPUT') { // when it contains a checkbox or radio button
                    var input = div.firstChild;
                    input.id = 'mtgInput'+id+'_'+index+','+i;
                    input.name = 'mtgInput'+id+'_'+index+','+i;
                    //input.className =  input.className.replace(/mtgInput.*?_.*?\s/, 'mtgInput'+id+'_'+index+' ');
                    input.className =  'mtgInput'+id+'_'+index;
                }
            });
        }
        if (fromColumnId == this.sortedColumnIndex) this.sortedColumnIndex = toColumnId;
    },

    /**
     * Add Key behavior functionality to the table grid
     */
    _addKeyBehavior : function() {
        var rows = this.rows;
        var renderedRows = this.renderedRows;
        var renderedRowsAllowed = this.renderedRowsAllowed;
        var beginAtRow = renderedRows - renderedRowsAllowed;
        if (beginAtRow < 0) beginAtRow = 0;
        for (var j = beginAtRow; j < renderedRows; j++) {
            this._addKeyBehaviorToRow(rows[j], j);
        }
    },

    _addKeyBehaviorToRow : function(row, j) {
        var self = this;
        var id = this._mtgId;
        var cm = this.columnModel;
        var keys = this.keys;
        for (var i = 0; i < cm.length; i++) {
            var element = $('mtgC'+id+'_'+i+','+j);
            if (cm[i].editable || (j<0 && cm[i].editableOnAdd)) { //edit by Jerome Orio 12.10.2010 added condition for columns editable only before saving (editableOnAdd is TRUE) - if (cm[i].editable){
                keys.event.remove.action(element);
                keys.event.remove.esc(element);
                keys.event.remove.blur(element);
                
                var f_action = (function(element) {
                    return function() {
                        if (self.editedCellId == null || self.editedCellId != element.id) {
                            self.editedCellId = element.id;
                            self._editCellElement(element);
                        } else {
                            self._blurCellElement(element);
                            self.editedCellId = null;
                        }
                    };
                })(element);
                keys.event.action(element, f_action);

                var f_esc = (function(element) {
                    return function() {
                        self._blurCellElement(element);
                        self.editedCellId = null;
                    };
                })(element);
                keys.event.esc(element, f_esc);

                var f_blur = (function(x, y, element) {
                    return function() {
                        self._blurCellElement(element);
                        self.editedCellId = null;
                        //comment code below by Jerome Orio 12.28.2010 transfer code in _blurCellElement function
                        //if (self.onCellBlur) self.onCellBlur(element, row[x], x, y, self.columnModel[x].id);
                    };
                })(i, j, element);
                keys.event.blur(element, f_blur);
            }	
            
            keys.event.remove.focus(element);
            
            var f_focus = (function(x, y, element) {
                return function() {
                    if (self.onCellFocus) {
                        self.onCellFocus(element, row[x], x, y, self.columnModel[x].id);
                    }
                };
            })(i, j, element);
            keys.event.focus(element, f_focus);
            
            keys.event.remove.removeRowFocus(element);
            
            //added by alfie 02/17/2011 for onRemoveRowFocus event options
            var f_removeRowFocus = (function(x,y,element) {
            	return function() {
            		if (self.onRemoveRowFocus) {
            			self.onRemoveRowFocus(element, row[x],x,y,self.columnModel[x].id);
            		}
            	};
            })(i, j, element);
            keys.event.removeRowFocus(element, f_removeRowFocus); //until here: alfie
            
            
        }
    },

    /**
     *  When a cell is edited
     */
    _editCellElement : function(element) {
    	if (!this.keys.blockKeyCaptureFlg) return;
        this.keys._bInputFocused = true;
        var cm = this.columnModel;
        var width = parseInt(element.getStyle('width'));
        var height = parseInt(element.getStyle('height'));
        var coords = this.getCurrentPosition();
        var x = coords[0];
        var y = coords[1];
        var id = 'mtgIC' + this._mtgId + '_' + x +','+y;
        var innerElement = $(id);
        var value = this.getValueAt(x, y);
        var editor = this.columnModel[x].editor || 'input';
        var type = this.columnModel[x].type || 'string';
        var input = null;
        
        //added by Jerome Orio to return if editable is false - for validation purposes
        if ((!this.columnModel[x].editable && !this.columnModel[x].editableOnAdd) || $("mtgIC" + this._mtgId + '_' + x +','+y).getAttribute("editableDiv") == "false"){ //||  Tonio april 26, 2011 GIACS037 added attribute editableDiv to check if field is editable even if columnModel is set to editable.
        	this.keys._nCurrentFocus = null;
        	this.keys._nOldFocus = null;
        	this.editedCellId == null;
        	this.keys._bInputFocused = false;
        	return; 
        }	
        
        /* OPTIONS FOR GENIISYS
         * added by Jerome Orio 12.02.2010
         * for new option in column model */
        var maxlength = this.columnModel[x].maxlength;
        var geniisysClass = this.columnModel[x].geniisysClass;
        var toUpperCase =  this.columnModel[x].toUpperCase; // Irwin. 5.27.11
        var radioGroup =  this.columnModel[x].radioGroup ||""; // Irwin. 9.9.11
        var deciRate = this.columnModel[x].deciRate || ""; //nok
        if (checkIfTableGridClassExist(geniisysClass, "money")){
          	value = formatCurrency(value);	
        }else if(checkIfTableGridClassExist(geniisysClass, "rate")){ // 'rate' Class added by: nica 05.06.2011
        	value = nvl(deciRate,"") == "" ? formatToNineDecimal(value) :formatToNthDecimal(value, deciRate);
        }
        /* END - GENIISYS */        
        
        var isInputFlg = (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.ComboBox || editor instanceof MyTableGrid.BrowseInput || editor instanceof MyTableGrid.CellCalendar || editor instanceof MyTableGrid.EditorInput);

        if (isInputFlg) {
            element.setStyle({
                height: this.cellHeight + 'px'
            });

            innerElement.setStyle({
                position: 'relative',
                width: width + 'px',
                height: height + 'px',
                padding: '0',
                border: '0',
                margin: '0'
            });

            var alignment = (type == 'number')? 'right' : 'left';
            if (editor == 'input') editor = new MyTableGrid.CellInput();
            innerElement.innerHTML = '';
            if (editor instanceof MyTableGrid.ComboBox) { // when is a list
                value = cm[x].renderer(value, editor.list);
            }            
            
            input = editor.render(this, { 
            	width:	width, 
            	height: height, 
            	value:	value, 
            	align:	alignment,
            	/* OPTIONS FOR GENIISYS
                * added by Jerome Orio 12.02.2010
                * for new option in column model */
            	maxlength:		maxlength, 
            	geniisysClass:	geniisysClass,
            	toUpperCase:  toUpperCase // Irwin. 5.27.11
            	/* END - GENIISYS */
            });
            innerElement.appendChild(input);
            input.down('input').focus();
            input.down('input').select();
        } else if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox) {        	
            input = $('mtgInput' + this._mtgId + '_' + x + ',' + y);
            //input.checked = (!input.checked); // comment out by andrew - 02.18.2011 - this is reversing the status of the checkbox
            if (editor.selectable == undefined || !editor.selectable) {
                value = input.checked;
                if (editor.hasOwnProperty('getValueOf')) value = editor.getValueOf(input.checked);
                this.setValueAt(value, x, y, false);
                if (this.columnModel[x].id != "recordStatus"){ //added by Jerome Orio 12.06.2010 - return if checkbox id is recordStatus
                	if (y >= 0 && this.modifiedRows.indexOf(y) == -1) this.modifiedRows.push(y); //if doesn't exist in the array the row is registered
            	}
            }            
            if (editor instanceof MyTableGrid.CellCheckbox && editor.onClickCallback) {
                editor.onClickCallback(value, input.checked);
            }
            this.keys._bInputFocused = false;
            this.editedCellId = null;
            if (this.columnModel[x].id == "recordStatus"/* && editor == 'checkbox'*/){ return; }//added by Jerome Orio 12.06.2010 - return if checkbox id is recordStatus
            //if(y >= 0) innerElement.addClassName('modifiedCell'); replaced by kenneth L. 11.13.2013
            if(input.checked == true){
            	if(y >= 0) innerElement.addClassName('modifiedCell');
            }
        } else if (editor == 'radio' || editor instanceof MyTableGrid.CellRadioButton) {
        	
            input = $('mtgInput' + this._mtgId + '_' + x + ',' + y);
           // input.checked = (!input.checked); // commented out by Irwin 9.9.11 this is reversing the status of the radio button
            value = input.checked;
           
            if (editor.hasOwnProperty('getValueOf')) value = editor.getValueOf(input.checked);
            this.setValueAt(value, x, y, false);
            if (y >= 0 && this.modifiedRows.indexOf(y) == -1) this.modifiedRows.push(y); //if doesn't exist in the array the row is registered
            if (editor instanceof MyTableGrid.CellRadioButton && editor.onClickCallback) {
                editor.onClickCallback(value, input.checked);
            }
            this.keys._bInputFocused = false;
            this.editedCellId = null;
            if(y >= 0) innerElement.addClassName('modifiedCell');
            
           // added by irwin. To properly toggle radio cell type with the same record group
           // for ( var i = 0; i < this.rows.length; i++) {
        	for ( var o = 0; o < this.columnModel.length; o++) {
        		if(this.columnModel[o].editor == 'radio' || this.columnModel[o].editor instanceof MyTableGrid.CellRadioButton){
        			if( x != o && this.columnModel[o].radioGroup == radioGroup){//this.columnModel[o].radioGroup == radioGroup  &&
        				//alert(this.columnModel[o].id);
        				this.setValueAt(false, o, y, true);	
        			}
        		}
			}
			//}
        } else if (editor instanceof MyTableGrid.SelectBox) { // andrew - 01.26.2011 - added this block for select box        	
        	input = $('mtgInput' + this._mtgId + '_' + x + ',' + y);
        	Event.observe(input, "change", function(){        		
        		if(y >= 0) innerElement.addClassName('modifiedCell');
        	});
            
            //this.setValueAt(value, x, y, false);
        }
    },

    /**
     * When the cell is blurred
     */
    _blurCellElement : function(element) {
        if (!this.keys._bInputFocused || nvl(element,null) == null || !this.keys.blockKeyCaptureFlg) return;
        var id = this._mtgId;
        var keys = this.keys;
        var cm = this.columnModel;
        var fs = this.fontSize;
        var width = parseInt(element.getStyle('width'));
        var height = parseInt(element.getStyle('height'));
        var coords = keys.getCoordsFromCell(element);
        var x = coords[0];
        var y = coords[1];
        var cellWidth = cm[x].width;
        var cellHeight = this.cellHeight;
        var innerId = 'mtgIC' + id + '_' + x + ',' + y;
        var input = $('mtgInput' + id + '_' + x + ',' + y);
        var innerElement = $(innerId);
        var value = (input == null) ? (innerElement ? innerElement.innerHTML :null) : (input.value==null? input.value : escapeHTML2(input.value.toString())); //edited by Jerome Orio 12.07.2010 - to replace all single/double quote tag - input.value // andrew - 02.23.2011 - replaced changeSingleAndDoubleQuotes2 with escapeHTML
        if (!input && !innerElement) return;
        var editor = cm[x].editor || 'input';
        var type = cm[x].type || 'string';
        //var alignment = (type == 'number')? 'right' : 'left';
        var alignment = 'left';
        if (!cm[x].hasOwnProperty('renderer')) {
            if (type == 'number') 
                alignment = 'right';
            else if (type == 'boolean')
                alignment = 'center';
        }

        if (cm[x].hasOwnProperty('align')) {
            alignment = cm[x].align;
        }
        var isInputFlg = (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.ComboBox || editor instanceof MyTableGrid.BrowseInput || editor instanceof MyTableGrid.CellCalendar || editor instanceof MyTableGrid.EditorInput || editor instanceof MyTableGrid.SelectBox);
        x = this.getColumnIndex(this.columnModel[x].id);

        var isValidFlg = true; //move declaration of variable by Jerome Orio 12.07.2010
        
        if (isInputFlg) {
            if (editor.hide) editor.hide(); // this only happen when editor is a Combobox
            if (editor.validate) { // this only happen when there is a validate method
            	if (cm[x].geniisysClass != undefined && isValidFlg){ //added if contion by Jerome Orio 12.07.2010 - to validate if geniisysClass exist
                	isValidFlg = validateTableGridByClassName(cm[x].geniisysClass, value, cm[x]);
            	}
            	if (isValidFlg){ //added if condition by Jerome Orio 12.07.2010 to validate first using geniisys class before editor.validate function
            		isValidFlg = editor.validate(value, input); //Jerome Orio 12.07.2010 move declaration above - var isValidFlg = editor.validate(value, input);
            	}
                if (editor instanceof MyTableGrid.ComboBox && !isValidFlg) {
                    value = editor.getList()[0][editor.listTextPropertyName];
                } else {
                	if (cm[x].geniisysClass != undefined && isValidFlg){ //added if condition by Jerome Orio 12.07.2010
                    	isValidFlg = validateTableGridByClassName(cm[x].geniisysClass, value, cm[x]);
                	}	
                    if (!isValidFlg) {
                        if (y >= 0)
                            value = this.rows[y][x];
                        else
                            value = this.newRowsAdded[Math.abs(y)-1][x];
                    }
                }
            }else{ //added else condition by Jerome Orio 12.07.2010 if editor.validate not exist validate using geniisysClass
            	if (cm[x].geniisysClass != undefined){
                	isValidFlg = validateTableGridByClassName(cm[x].geniisysClass, value, cm[x]);
                	if (!isValidFlg) {
                        if (y >= 0)
                            value = this.rows[y][x];
                        else
                            value = this.newRowsAdded[Math.abs(y)-1][x];
                    }
            	}
            }	
            /* OPTIONS FOR GENIISYS
             * added by Jerome Orio 12.02.2010
             * for geniisysClass in column model */
            if (cm[x].geniisysClass != undefined){
            	if (checkIfTableGridClassExist(cm[x].geniisysClass, "money")){
                  	value = formatCurrency(value);	
                }else if(checkIfTableGridClassExist(cm[x].geniisysClass, "rate")){
                	value = nvl(cm[x].deciRate,"") == "" ? formatToNineDecimal(value) :formatToNthDecimal(value, cm[x].deciRate);
                }
            }	
        	/* END - GENIISYS */

            element.setStyle({
                height: cellHeight + 'px'
            });

            if(editor instanceof MyTableGrid.BrowseInput || editor instanceof MyTableGrid.EditorInput){ //added by steven 7.29.2013; to reset the width and height for EditorInput
            	innerElement.setStyle({
	            	width : (width - 6) + 'px',
	            	height : (height - 6) + 'px',
	                padding: '3px',
	                textAlign: alignment
	            }).update(value);	
            }else{
            	if (!(editor instanceof MyTableGrid.SelectBox)){ //added by angelo 02.21.11 to stop transforming select box into cell input
    	            innerElement.setStyle({
    	            	width : (width+4) + 'px', //width : (width - 6) + 'px',
    	            	height : (height) + 'px', //height : (height - 6) + 'px',
    	                padding: '3px',
    	                textAlign: alignment,
    	                marginTop: '-2px'
    	            }).update(value);
                }
            }	
        }

        if (editor instanceof MyTableGrid.ComboBox) { // I hope I can find a better solution
            value = editor.getSelectedValue(value);
        }
        
        if (editor instanceof MyTableGrid.SelectBox) { // andrew - 02.17.2011 - for select box        	
            value = editor.value;
        }
        
        if (y >= 0){ 
        	//edited by Jerome Orio 12.02.2010
        	if ((checkIfTableGridClassExist(cm[x].geniisysClass, "money") ? formatCurrency(this.rows[y][x]) :nvl(this.rows[y][x],"")) == nvl(value,"") || (checkIfTableGridClassExist(cm[x].geniisysClass, "rate") ? (nvl(cm[x].deciRate,null) != null ? formatToNthDecimal(this.rows[y][x],cm[x].deciRate) :formatToNineDecimal(this.rows[y][x])) :nvl(this.rows[y][x],"")) == nvl(value,"")){
        		null;
        	}else{
	        	if (cm[x].id == "recordStatus"/* && editor == 'checkbox'*/){ return; }//added by Jerome Orio 12.06.2010
	        	if (checkIfTableGridClassExist(cm[x].geniisysClass, "money")){ //added if else by Jerome Orio 12.08.2010 - value;
	        		this.rows[y][x] = nvl(value,"").replace(/,/g, "");
	        	}else if (checkIfTableGridClassExist(cm[x].geniisysClass, "rate")){
	        		this.rows[y][x] = nvl(cm[x].deciRate,null)!=null ? formatToNthDecimal(value,cm[x].deciRate) :formatToNineDecimal(value);
	        	}else{	
	        		this.rows[y][x] = value; 
	        	}
	            innerElement.addClassName('modifiedCell');
	            if (this.modifiedRows.indexOf(y) == -1) this.modifiedRows.push(y); //if doesn't exist in the array the row is registered
        	}
        } else if (y < 0) {
            if(nvl(this.newRowsAdded[Math.abs(y)-1],null) == null) return; 
            this.newRowsAdded[Math.abs(y)-1][x] = checkIfTableGridClassExist(cm[x].geniisysClass, "money") ? (value== null ? null :value.replace(/,/g, "")) :(checkIfTableGridClassExist(cm[x].geniisysClass, "rate") ? (nvl(cm[x].deciRate,null)!=null ? formatToNthDecimal(value,cm[x].deciRate) :formatToNineDecimal(value)) :value);  //edited by Jerome Orio 12.08.2010 - value;
        }

        if (editor instanceof MyTableGrid.BrowseInput && editor.afterUpdateCallback) {
            editor.afterUpdateCallback(element, value);
        }
        
        if (editor instanceof MyTableGrid.EditorInput && editor.afterUpdateCallback) {
            editor.afterUpdateCallback(element, value);
        }
        
        if (this.onCellBlur) this.onCellBlur(element, ((y >= 0) ? this.rows[y][x] : this.newRowsAdded[Math.abs(y)-1][x]), x, y, cm[x].id); //added by Jerome Orio 12.28.2010
        keys._bInputFocused = false;
        keys._nCurrentFocus = null; //to avoid null input error
    },

    /**
     * Applies header buttons
     */
    _applyHeaderButtons : function() {
        var self = this;
        var id = this._mtgId;
        var headerHeight = this.headerHeight;
        var headerButton = $('mtgHB' + this._mtgId);
        var headerButtonMenu = $('mtgHBM' + this._mtgId);
        var sortAscMenuItem = $('mtgSortAsc'+this._mtgId);
        var sortDescMenuItem = $('mtgSortDesc'+this._mtgId);
        var topPos = 0;
        if (this.options.title) topPos += this.titleHeight;
        if (this.options.toolbar) topPos += this.toolbarHeight;
        var selectedHCIndex = -1;
        $$('.mtgIHC' + id).each(function(element, index) {
            var editor = null;
            var sortable = true;
            var hbHeight = null;
            Event.observe(element, 'mousemove', function() {
                var cm = self.columnModel;
                if (!element.id) return;
                selectedHCIndex = parseInt(element.id.substring(element.id.indexOf('_') + 1, element.id.length));
                editor = cm[selectedHCIndex].editor;
                sortable = cm[selectedHCIndex].sortable;
                hbHeight = cm[selectedHCIndex].height;
                //if (sortable || editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox) {
                if ((self.addColumnSortMenuFlg && sortable) || editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox) {// andrew - 01.12.2011 - modified this condition to disable or enable column sorting dropdown menu
                    var hc = element.up();
                    var leftPos = hc.offsetLeft + hc.offsetWidth;
                    leftPos = leftPos - 16 - self.scrollLeft;
                    if(nvl(cm[selectedHCIndex].hideSelectAllBox,false)) {
	                    if (leftPos < self.bodyDiv.clientWidth) {
	                        headerButton.setStyle({
	                            top: (topPos + 3 + headerHeight - hbHeight) + 'px',
	                            left: leftPos + 'px',
	                            height: hbHeight + 'px',
	                            visibility: (!sortable && nvl(cm[selectedHCIndex].hideSelectAllBox,false)) ? 'hidden' :'visible'
	                        });
	                    }
                    }
                    
                    if (!sortable && !cm[selectedHCIndex].editable && (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox))	{headerButton.setStyle({visibility: 'visible'});headerButton.hide();} //added by Jerome Orio to hide header button if checkbox and not editable and sortable

                    sortAscMenuItem.onclick = function() {
                    	cm[selectedHCIndex].sortedAscDescFlg = 'DESC'; //added by Jerome Orio
                        self._sortData(selectedHCIndex, 'ASC');
                    };

                    sortDescMenuItem.onclick = function() {
                    	cm[selectedHCIndex].sortedAscDescFlg = 'ASC'; //added by Jerome Orio
                        self._sortData(selectedHCIndex, 'DESC');
                    };
                }
            });
	            
            // Sorting when click on header column
            Event.observe(element, 'click', function() {
            	var bool = null;
                if (self.options.beforeSort) { // andrew - 11.29.2011 - call the beforeSort function if any 
                    bool = self.options.beforeSort.call();
                }
                if(bool == null || bool){
	                if (!element.id) return;
	                selectedHCIndex = parseInt(element.id.substring(element.id.indexOf('_') + 1, element.id.length));
	                if (element.id == "mtgHPC"+id+"_"+selectedHCIndex){ //nok added this part for header with children
	                	if (!$(element.id).hasAttribute("parentId")) return;
	                	var parentId = $(element.id).getAttribute("parentId");
	                	if ($('mtgSortIcon'+id+'_'+parentId).hasClassName('mtgSortAscIcon')){
	                		$('mtgSortIcon'+id+'_'+parentId).className = 'mtgSortDescIcon';
	                		ascDescFlg = 'DESC';
	                	}else{
	                		$('mtgSortIcon'+id+'_'+parentId).className = 'mtgSortAscIcon';
	                		ascDescFlg = 'ASC';
	                	}	
	                	self.request[self.sortColumnParameter] = parentId;
	                	self.request[self.ascDescFlagParameter] = ascDescFlg;
	                	if (self.querySortFlg) {
	                		self._retrieveDataFromUrl(1);
	                	} else {
	                		self._sortData(self.getColumnIndex($w(parentId).first()), ascDescFlg);
	                	}
	                	$('mtgSortIcon'+id+'_'+parentId).setStyle({visibility : 'hidden'});
	                	$$('.mtgSortDescIcon').each(function(element){
	                    	$(element.id).setStyle({visibility : 'hidden'});
	                    });
	                	$$('.mtgSortAscIcon').each(function(element){
	                    	$(element.id).setStyle({visibility : 'hidden'});
	                    });
	                    $(element.id).setStyle({color : 'dimgray'});
	                    $$('.mtgIHC' + id).each(function(element){
	                    	$(element.id).setStyle({color : 'dimgray'});
	                    });
	                    $('mtgSortIcon'+id+'_'+parentId).setStyle({visibility : 'visible'});
	                    $(element.id).setStyle({color : 'black'});
	                }else{
	                	self._toggleSortData(selectedHCIndex);     
	                }	
	                if (self.options.onSort) { // andrew - 07.05.2011 - call the onSort function if any 
	                    ok = self.options.onSort.call();
	                }
                }
            });
        });

        Event.observe(headerButton, 'click', function() {
            var cm = self.columnModel;
            if (headerButtonMenu.getStyle('visibility') == 'hidden') {
                if (this.addColumnSortMenuFlg && cm[selectedHCIndex].sortable) { // andrew - 01.24.2011 - modified the condition to hide/show the sorting menu
                    $('mtgSortDesc'+self._mtgId).show();
                    $('mtgSortAsc'+self._mtgId).show();
                } else {
                    $('mtgSortDesc'+self._mtgId).hide();
                    $('mtgSortAsc'+self._mtgId).hide();
                }
                
                var selectAllItem = $$('#mtgHBM' + id + ' .mtgSelectAll')[0];
                //edited IF condition by Jerome Orio 12.10.2010 added (cm[selectedHCIndex].editable) condition - to show only select all if checkbox is editable
                if ((cm[selectedHCIndex].editable && !nvl(cm[selectedHCIndex].hideSelectAllBox,false))&&(cm[selectedHCIndex].editor == 'checkbox' || cm[selectedHCIndex].editor instanceof MyTableGrid.CellCheckbox)) {
                    selectAllItem.down('input').checked = cm[selectedHCIndex].selectAllFlg;
                    selectAllItem.show();
                    selectAllItem.onclick = function() { // onclick handler
                        var flag = cm[selectedHCIndex].selectAllFlg = $('mtgSelectAll' + id).checked;
                        var selectableFlg = false;
                        if (cm[selectedHCIndex].editor instanceof MyTableGrid.CellCheckbox
                                && cm[selectedHCIndex].editor.selectable) selectableFlg = true;

                        var renderedRows = self.renderedRows;
                        var beginAtRow = 0;
                        if (self.newRowsAdded.length > 0) beginAtRow = -self.newRowsAdded.length;
                        var x = selectedHCIndex;
                        for (var y = beginAtRow; y < renderedRows; y++) {
                            var element = $('mtgInput' + id + '_' + x +','+y);
                            var value = element.checked = flag;
                            if (!selectableFlg) {
                                if (cm[x].editor.hasOwnProperty('getValueOf')) value = cm[x].editor.getValueOf(element.checked);
                                self.setValueAt(value, x, y, false);
                                // if doesn't exist in the array the row is registered
                                if (y >= 0 && self.modifiedRows.indexOf(y) == -1) self.modifiedRows.push(y);
                            }
                        }

                        if (cm[selectedHCIndex].editor instanceof MyTableGrid.CellCheckbox
                                && cm[selectedHCIndex].editor.onClickCallback) cm[selectedHCIndex].editor.onClickCallback();
                    };
                } else {
                    selectAllItem.hide();
                }

                var leftPos = parseInt(headerButton.getStyle('left'));
                var topPos = self.headerHeight + 2;
                if (self.options.title) topPos += self.titleHeight;
                if (self.options.toolbar) topPos += self.toolbarHeight;
                headerButtonMenu.setStyle({
                    top: topPos + 'px',
                    left: leftPos + 'px',
                    visibility: nvl(cm[selectedHCIndex].hideSelectAllBox,false) ? 'visible' :'hidden' //nok added condition 04.26.2011
                });
            } else {
                headerButtonMenu.setStyle({visibility: 'hidden'});
            }
        });

        var miFlg = false;
        Event.observe(headerButtonMenu,'mousemove', function() {
            miFlg = true;
        });

        Event.observe(headerButtonMenu,'mouseout', function(event) {
            miFlg = false;            
            var element = event.element();
            setTimeout(function() {
                if (!element.descendantOf(headerButtonMenu) && !miFlg)
                    headerButtonMenu.setStyle({visibility: 'hidden'});
            }, 500);
        });
    },

    _sortData : function(idx, ascDescFlg) {
        var cm = this.columnModel;
        var id = this._mtgId;
        var self = this;
        if (cm[idx].sortable) {
            $('mtgSortIcon'+id+'_'+idx).className = (ascDescFlg == 'ASC')? 'mtgSortAscIcon' : 'mtgSortDescIcon';
            this.request[this.sortColumnParameter] = cm[idx].id;
            this.request[this.ascDescFlagParameter] = ascDescFlg;
            
            if (this.querySortFlg) {// andrew
            	this._retrieveDataFromUrl(1);
        	} else {
        		//added by Jerome Orio 12.13.2010 to avoid null input error onblur
        		self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);
        		self.keys._nCurrentFocus = null;
     	        self.keys._nOldFocus = null;
     	        if (!this.preCommit()){ return false; }
     	        //end Jerome 
        		this._sortObjectArray(this.rows, cm[idx]);
        	}
            
            $('mtgSortIcon'+id+'_'+this.sortedColumnIndex).setStyle({visibility : 'hidden'});
            $$('.mtgSortDescIcon').each(function(element){
            	$(element.id).setStyle({visibility : 'hidden'});
            });
        	$$('.mtgSortAscIcon').each(function(element){
            	$(element.id).setStyle({visibility : 'hidden'});
            });
            $('mtgIHC'+id+'_'+this.sortedColumnIndex).setStyle({color : 'dimgray'});
            $$('.mtgIHC' + id).each(function(element){
            	$(element.id).setStyle({color : 'dimgray'});
            });
            $('mtgSortIcon'+id+'_'+idx).setStyle({visibility : 'visible'});
            $('mtgIHC'+id+'_'+idx).setStyle({color : 'black'});
            this.sortedColumnIndex = idx;
            cm[idx].sortedAscDescFlg = ascDescFlg;
        }
    },    
    
    /*	Date		Author			Description
     * 	==========	===============	==============================
     * 	02.17.2011	andrew robes	added refresh process
     * 	08.25.2011	mark jm			convert the existing transaction statement to function (to be reuse)
     * 								added condition to check if there are changes in a master-detail relation 
     */
    _refreshList: function(){
    	this._removeSort(this.sortedColumnIndex);                	
    	this._removeFilter();        			
    	this._retrieveDataFromUrl(1);
    	this.keys.removeFocus();
    	this.keys.releaseKeys();
    	if (this.options.onRefresh) { // andrew - 11.09.2011
            this.options.onRefresh.call();
        }
    },
    
    /**
     * @author andrew robes
     * @date 02.16.2011
     * @param idx - column index
     */
    _removeSort: function(idx){
    	var cm = this.columnModel; 
    	cm[idx].sortedAscDescFlg = 'DESC';
    	$('mtgSortIcon'+this._mtgId+'_'+idx).removeClassName('mtgSortAscIcon').removeClassName('mtgSortDescIcon');
        $('mtgSortIcon'+this._mtgId+'_'+idx).setStyle({visibility : 'hidden'});
        $$('.mtgSortDescIcon').each(function(element){
        	$(element.id).setStyle({visibility : 'hidden'});
        });
    	$$('.mtgSortAscIcon').each(function(element){
        	$(element.id).setStyle({visibility : 'hidden'});
        });
        $('mtgIHC'+this._mtgId+'_'+idx).setStyle({color : 'dimgray'});
        $$('.mtgIHC' + this._mtgId).each(function(element){
        	$(element.id).setStyle({color : 'dimgray'});
        });
    	this.request['sortColumn'] = null;
    	this.request['ascDescFlg'] = null;
    	this.sortedColumnIndex = 0;
    },
    
    /**
     * @author andrew robes
     * @date 02.16.2011
     */
    _removeFilter: function() {
    	this.objFilter = {}; //nok 06.01.2011 clearObjectValues(this.objFilter);
    	if (this.options.toolbar){
	    	if (this.options.toolbar.elements.indexOf(MyTableGrid.FILTER_BTN) >= 0) {
		    	if($("mtgFilterBtn"+this._mtgId).up().hasClassName("toolbarbtn_selected")){
		        	fireEvent($("mtgFilterBtn"+this._mtgId), 'click');
		    	}
		    	$("mtgFilterBtn"+this._mtgId).removeClassName("filterbutton_red");
		    	$("mtgFilterBtn"+this._mtgId).addClassName("filterbutton");
		    	$("mtgFilterText"+this._mtgId).value = "";
		    	$("mtgFilterBy"+this._mtgId).selectedIndex = 0; // andrew - 04.19.2012
	    	}
    	}
    },
    
    _toggleSortData : function(idx) {
        var cm = this.columnModel;
        if (cm[idx].sortedAscDescFlg == 'DESC')
            this._sortData(idx, 'ASC');
        else
            this._sortData(idx, 'DESC');
    },
    
    _toggleColumnVisibility : function(index, visibleFlg) {
        this._blurCellElement(this.keys._nCurrentFocus); //in case there is a cell in editing mode
        this.keys.blur(); //remove the focus of the selected cell
        var headerRowTable = $('mtgHRT' + this._mtgId);
        var bodyTable = $('mtgBT' + this._mtgId);

        for (var i = 0; i < this.columnModel.length; i++) {
            if (this.columnModel[i].positionIndex == index) {
                index = i;
                break;
            }
        }

        var targetColumn = $('mtgHC' + this._mtgId + '_' + index);
        $('mtgHB' + this._mtgId).setStyle({visibility: 'hidden'});

        var width = 0;

        if (!visibleFlg) { // hide
            width = parseInt(targetColumn.offsetWidth);
            targetColumn.hide();
            $$('.mtgC'+this._mtgId+ '_'+index).each(function(element){
                element.hide();
            });
            this.columnModel[index].visible = false;
            this.headerWidth = this.headerWidth - width;
        } else { // show
            targetColumn.show();
            width = parseInt(targetColumn.offsetWidth) + 2;
            $$('.mtgC'+this._mtgId+ '_'+index).each(function(element){
                element.show();
            });
            this.columnModel[index].visible = true;
            this.headerWidth = this.headerWidth + width;
        }

        headerRowTable.width = this.headerWidth + 21;
        bodyTable.width = this.headerWidth;
        bodyTable.setStyle({width: this.headerWidth + 'px'});
    },

    _fullPadding : function(element, s) {
        var padding = parseInt(element.getStyle('padding-'+s));
        padding = (isNaN(padding)) ? 0 : padding;
        var border = parseInt(element.getStyle('border-'+s+'-width'));
        border = (isNaN(border)) ? 0 : border;
        return padding + border;
    },

    /**
     * Created By	: andrew robes
     * Date			: November 26, 2010
     * Description	: sorts existing object array
     * 
     * @param column - column to be sorted 
     */
    _sortObjectArray : function(rows, column) {
    	this._toggleLoadingOverlay();
    	
    	//added by Jerome Orio 12.13.2010 to include all new rows
    	var self = this;
    	var newRowsAdded = self.getNewRowsAdded();
    	var newRows = self.generateRows(newRowsAdded) || []; 
    	for (var i = 0; i < rows.length; i++) {
        	if (rows[i][self.getColumnIndex('divCtrId')] < 0){
        		rows.splice(i,1);
        		i--;
        	}
        }
        rows = newRows.length>0?rows.concat(newRows):rows;
        //end Jerome
        
        //edited condition by Jerome Orio 12.13.2010 move the first if condition 'if(column.sortedAscDescFlg == "ASC"){' below
    	if (nvl(column.type,"STRING").toUpperCase() == "STRING"){
    		rows.sort(function (a, b){
			    //var x = a[column.id].toLowerCase();
				//var y = b[column.id].toLowerCase();
    			//edited by Jerome Orio 12.10.2010 and comment code above
    			var x = a[self.getColumnIndex(column.id)]==null?"":(a[self.getColumnIndex(column.id)]).toString().toLowerCase();
				var y = b[self.getColumnIndex(column.id)]==null?"":(b[self.getColumnIndex(column.id)]).toString().toLowerCase();
				return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    		});
    	}else if (nvl(column.type,"STRING").toUpperCase() == "NUMBER"){
    		//added by Jerome Orio 12.13.2010
    		for (var i = 0; i < rows.length; i++) {
    			if (((rows[i][self.getColumnIndex(column.id)]).toString() != "" || rows[i][self.getColumnIndex(column.id)] != null) && ((rows[i][self.getColumnIndex(column.id)]).toString().length != 0)){
    				if((rows[i][self.getColumnIndex(column.id)]).toString().indexOf(".") < 0){
    					rows[i][self.getColumnIndex(column.id)] = parseInt(rows[i][self.getColumnIndex(column.id)]);
	    			}else{
	    				rows[i][self.getColumnIndex(column.id)] = parseFloat(rows[i][self.getColumnIndex(column.id)]);
	    			}	
    			}
    		}
    		rows.sort(function (a, b){
    			//return (parseFloat(a[column.id]) - parseFloat(b[column.id]));
    			//edited by Jerome Orio 12.10.2010 and comment code above
    			//if you want to place the null value between positive and negative you can remove the parseFloat function
    			return (parseFloat(a[self.getColumnIndex(column.id)]) - parseFloat(b[self.getColumnIndex(column.id)]));
    		});
    	}else if (nvl(column.type,"STRING").toUpperCase() == "DATE"){
    		rows.sort(function (a, b){
    			//var x = Date.parse(a[column.id]);
    			//var y = Date.parse(b[column.id]);
    			//edited by Jerome Orio 12.10.2010 and comment code above
    			var x = Date.parse(a[self.getColumnIndex(column.id)]);
    			var y = Date.parse(b[self.getColumnIndex(column.id)]);
    			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    		});
    	}	
    	if(column.sortedAscDescFlg == "ASC"){
    		rows.reverse();
        }
        //if (tableModel.options != null && tableModel.options.pager) self.pager = tableModel.options.pager;
        if (rows.length > 0) {
            /*self.renderedRows = 0;
            self.innerBodyDiv.innerHTML = self._createTableBody(rows);
            self.bodyTable = $('mtgBT' + self._mtgId);
            
            //added by Jerome Orio 12.13.2010 to add behavior after recreating the body
	        self._applyCellCallbacks();
	        self.keys = new KeyTable(self);
	        self._addKeyBehavior();*/
	        
	        //added by Jerome Orio 12.21.2010 and comment code above
        	self.bodyTable.down('tbody').innerHTML = '';
	        for (var b=0; b<rows.length; b++){
	    		var divCtrId = rows[b][self.getColumnIndex('divCtrId')];
	    		self.bodyTable.down('tbody').insert({top: self._createRow(rows[b], divCtrId)});
	    		self.keys.setTopLimit(divCtrId);
	    	    self._addKeyBehaviorToRow(rows[b], divCtrId);
	    	    self.keys.addMouseBehaviorToRow(divCtrId);
	    	    self._applyCellCallbackToRow(divCtrId);
	    	    self.scrollTop = self.bodyDiv.scrollTop = 0;	
	    	}
        }

        if (self.pager) {
            self.pagerDiv.innerHTML = self._updatePagerInfo(); // update pager info panel
            self._addPagerBehavior();
        }

        if (self.afterRender) {
            self.afterRender();
        }

        //added by Jerome Orio 12.21.2010 to rearrange rows to original arrangement
        var tempObjArray = [];
        for (var a=0; a<self.rows.length; a++){
        	for (var b=0; b<self.rows.length; b++){
        		if (a==self.rows[b][self.getColumnIndex('divCtrId')]){
        			tempObjArray.push(self.rows[b]);
        		}
        	}	
        }	
        self.rows = tempObjArray;
        self._hideLoaderSpinner();
        //end - jerome
        
        self._toggleLoadingOverlay();
        self.scrollTop = self.bodyDiv.scrollTop = 0;
    },
    
    _retrieveDataFromUrl : function(pageNumber, firstTimeFlg) {
    	//added by Jerome Orio 12.13.2010 to avoid null input error onblur
		this._blurCellElement(this.keys._nCurrentFocus==null?this.keys._nOldFocus:this.keys._nCurrentFocus);
		this.keys._nCurrentFocus = null;
	    this.keys._nOldFocus = null;
	    this.clear(); //temp - nok
	    
        if (!firstTimeFlg && this.onPageChange) {
            if (!this.onPageChange()) return;
        }
        var pageParameter = 'page';
        var filterParameter = 'objFilter'; // andrew
        if(this.pager != null && this.pager.pageParameter) pageParameter = this.pager.pageParameter;
        this.request[pageParameter] = pageNumber>1 ? nvl(pageNumber,1) : 1;
        this.request[filterParameter] = JSON.stringify(this.objFilter); // andrew - 01.20.2011 - to add filter in parameter
        this._toggleLoadingOverlay();
        for (var i = 0; i < this.columnModel.length; i++) {
            this.columnModel[i].selectAllFlg = false;
        }
        var self = this;
        new Ajax.Request(this.url, {
            parameters: self.request,
            asynchronous: false, //nok
			evalScripts: true,  //nok
            onSuccess: function(transport) {
        		self._toggleLoadingOverlay(); // moved here by andrew - 02.28.2011
        		if(checkErrorOnResponse(transport)){        			
        			var tableModel = transport.responseText.replace(/\\\\/g, "\\").evalJSON(); // edited by mark jm 08.23.2011 added replace function for escaping character (\n)
	                self.geniisysRows = tableModel.rows || []; //added by Jerome Orio 12.09.2010 to set the new rows from database
	                self.rows = self.generateRows(tableModel.rows) || []; //edited by Jerome Orio 12.02.2010 tableModel.rows || [];
	                self.pager = tableModel; //edited by Jerome Orio - self.pager = null;
	                if (tableModel.options != null && tableModel.options.pager) self.pager = tableModel.options.pager;
	                if (tableModel.rows.length > 0) {
	                    /*self.renderedRows = 0;
	                    self.innerBodyDiv.innerHTML = self._createTableBody(tableModel.rows);
	                    self.bodyTable = $('mtgBT' + self._mtgId);
	                    if (!firstTimeFlg) {
	                        self._applyCellCallbacks();
	                        self.keys = new KeyTable(self);
	                        self._addKeyBehavior();
	                    }*/
	                	//added by Jerome Orio 12.28.2010 and comment code above                
	                	self.recreateRows();              	
	                } else {
	                	self.bodyTable.down('tbody').innerHTML = ''; //edit by Jerome Orio 12.09.2010 to fixed minor bugs - self.innerBodyDiv.innerHTML = '';
	                }
	
	                if (self.pager) {
	                    self.pagerDiv.innerHTML = self._updatePagerInfo(); // update pager info panel
	                    if(self.options.masterDetail){
	                		self._addMasterDetailPagerBehavior();
	                	}else{
	                		self._addPagerBehavior();
	                	}	                    
	                }
	
	                if (self.afterRender) {
	                    self.afterRender();
	                }
	                //self._toggleLoadingOverlay(); // commented by andrew - 02.28.2011
	                self._hideLoaderSpinner();
	                self.scrollTop = self.bodyDiv.scrollTop = 0;
	                if (firstTimeFlg) self.bodyDiv.fire('dom:dataLoaded');
	            }
        	}
        });
        return true;
    },
    
    /*	Date		Author			Description
     * 	==========	===============	==============================
     * 	07.20.2011	andrew robes	Updates the record info when a row is added or deleted
     * 				andrew robes	added this.newRowsAdded.length to the ternary condition
     * 	07.22.2011	mark jm 		replaced this.rows.length to visibleRow
     * 	08.26.2011	mark jm			replaced this.newRowsAdded.length to this.getNewRowsAdded().length
     */    
    _updateRecordInfo : function(){
    	 var html = [];
         var idx = 0;
         var pager = this.pager;

         if (this.pager.total > 0) {
             var temp = this._messages.totalDisplayMsg;
             temp = temp.replace(/\{total\}/g, pager.total);
             if (pager.from && pager.to) {
            	 var visibleRow = ((this.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display != "none"; })).length;
                 temp += this._messages.rowsDisplayMsg;                 
                 temp = temp.replace(/\{from\}/g, pager.from);                 
                 // andrew - added this.newRowsAdded.length to the ternary condition
                 
                 temp = temp.replace(/\{to\}/g, (((pager.from-1)+this.rows.length)+/*this.newRowsAdded.length*/this.getNewRowsAdded().length)<pager.to? ((pager.from-1)+visibleRow/*this.rows.length*/) : pager.to);
             } else {
            	 temp += this._messages.pagerNoRecordsLeft; 
             }
             
             html[idx++] = temp;             
         }

         html.join('');
         $("mtgPagerMsg"+this._mtgId).update(html);
    },
    
    _updatePagerInfo : function(emptyFlg) {
        var id = this._mtgId;
        var imageRefs = this._imageRefs;
        var imagePath = this._imagePath;

        if (emptyFlg)
            return '<span id="mtgLoader'+id+'" class="mtgLoader">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';

        var html = [];
        var idx = 0;
        var pager = this.pager;

        if (this.pager.total > 0) {
            var temp = this._messages.totalDisplayMsg;
            temp = temp.replace(/\{total\}/g, pager.total);
            if (pager.from && pager.to) {
                temp += this._messages.rowsDisplayMsg;
                temp = temp.replace(/\{from\}/g, pager.from);
                //temp = temp.replace(/\{to\}/g, pager.to);
                //edied by Jerome Orio comment code above                                
                temp = temp.replace(/\{to\}/g, this.rows.length<pager.to ? ((pager.from-1)+this.rows.length) : pager.to);
            } 
            	
            html[idx++] = '<span id="mtgPagerMsg'+this._mtgId+'" class="mtgPagerMsg">'+temp+'</span>';
            if (pager.pages) {
                temp = this._messages.pagePromptMsg;
                temp = temp.replace(/\{pages\}/g, pager.pages);
                var input = '<input type="text" name="mtgPageInput'+id+'" id="mtgPageInput'+id+'" value="'+pager.currentPage+'" class="mtgPageInput" size="5" maxlength="5">';
                temp = temp.replace(/\{input\}/g, input);
                html[idx++] = '<table class="mtgPagerTable" border="0" cellpadding="0" cellspacing="0">';
                html[idx++] = '<tbody>';
                html[idx++] = '<tr>';

                html[idx++] = '<td><div id="mtgLoader'+id+'" class="mtgLoader">&nbsp;</div></td>'; // comment out - andrew - 07.20.2011
                html[idx++] = '<td><div class="mtgSep">&nbsp;</div></td>';
                html[idx++] = '<td><a id="mtgFirst'+id+'" class="mtgPagerCtrl"><div class="mtgFirstPage">&nbsp;</div></a></td>';
                html[idx++] = '<td><a id="mtgPrev'+id+'" class="mtgPagerCtrl"><div class="mtgPrevPage">&nbsp;</div></a></td>';
                html[idx++] = '<td><div class="mtgSep">&nbsp;</div></td>';
                html[idx++] = temp;

                html[idx++] = '<td><div class="mtgSep">&nbsp;</div></td>';
                html[idx++] = '<td><a id="mtgNext'+id+'" class="mtgPagerCtrl"><div class="mtgNextPage">&nbsp;</div></a></td>';
                html[idx++] = '<td><a id="mtgLast'+id+'" class="mtgPagerCtrl"><div class="mtgLastPage">&nbsp;</div></a></td>';
                html[idx++] = '</tr>';
                html[idx++] = '</tbody>';
                html[idx++] = '</table>';
            } else {
                html[idx++] = '<table class="mtgPagerTable" border="0" cellpadding="0" cellspacing="0">';
                html[idx++] = '<tbody>';
                html[idx++] = '<tr>';
                html[idx++] = '<td><div id="mtgLoader'+id+'" class="mtgLoader">&nbsp;</div></td>';
                html[idx++] = '</tr>';
                html[idx++] = '</tbody>';
                html[idx++] = '</table>';
            }
        } else {
            html[idx++] = '<span id="mtgPagerMsg'+this._mtgId+'" class="mtgPagerMsg">'+this._messages.pagerNoDataFound+'</span>';
        }
        return html.join('');
    },

    _addPagerBehavior : function() {
        var self = this;
        if (!self.pager.pages) return;
        var currentPage = self.pager.currentPage;
        var pages = self.pager.pages;
        var total = self.pager.total;
        var checkChanges = this.checkChanges; //added by alfie 05/10/2011
        if (total > 0) {
        	
        	function saveChangesFirst(page){
        		if (!self.preCommit()){ return false; } //Jerome Orio - to validate all required field
        		var ok = true;
            	if (self.options.toolbar.onSave) {
            		ok = self.options.toolbar.onSave.call();
            	}
            	if (ok || ok==undefined){
            		if (self.options.toolbar.postSave) {
                		self.options.toolbar.postSave.call();
                	}
            	}
            	var pre = true;
            	var post = true;
            	if (self.options.prePager){ 
            		pre = self.options.prePager.call();
            	}
            	if (pre || pre==undefined){
            		post = self._retrieveDataFromUrl.call(self, page);
            	}
                if (post){
                	if (self.options.postPager) self.options.postPager.call();
                }	
    		}
        	
            if (currentPage > 1) {
                $('mtgFirst'+this._mtgId).down('div').className = 'mtgFirstPage';
                $('mtgFirst'+this._mtgId).onclick = function() {
                	//self._retrieveDataFromUrl.call(self, 1);
                	//added by Jerome Orio 12.28.2010 and comment code above                
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoPage1(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }	
                	}
                	
                	if (self.validateChangesOnPrePager && self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                		if (checkChanges==true) { //added by alfie 05/10/2011 
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){saveChangesFirst(1);}, gotoPage1, "");
                		} else {
                			gotoPage1();
                		}
                	}else{
                		gotoPage1();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgFirst'+this._mtgId).down('div').className = 'mtgFirstPageDisabled';
            }


            if (currentPage > 0 && currentPage < pages) {
                $('mtgNext'+this._mtgId).down('div').className = 'mtgNextPage';
                $('mtgNext'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, currentPage + 1);
                    //added by Jerome Orio 12.28.2010 and comment code above
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoNextPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, currentPage + 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}	
                	if (self.validateChangesOnPrePager && self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){saveChangesFirst(currentPage + 1);}, gotoNextPage, "");
                		} else {
                			gotoNextPage();
                		}
                	}else{
                		gotoNextPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgNext'+this._mtgId).down('div').className = 'mtgNextPageDisabled';
            }

            if (currentPage > 1 && currentPage <= pages) {
                $('mtgPrev'+this._mtgId).down('div').className = 'mtgPrevPage';
                $('mtgPrev'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, currentPage - 1);
                    //added by Jerome Orio 12.28.2010 and comment code above                	
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoPrevPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, currentPage - 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}	
                	if (self.validateChangesOnPrePager && self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){saveChangesFirst(currentPage - 1);}, gotoPrevPage, "");
                		} else {
                			gotoPrevPage();
                		}
                	}else{
                		gotoPrevPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgPrev'+this._mtgId).down('div').className = 'mtgPrevPageDisabled';
            }


            if (currentPage < pages) {
                $('mtgLast'+this._mtgId).down('div').className = 'mtgLastPage';
                $('mtgLast'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, self.pager.pages);
                    //added by Jerome Orio 12.28.2010 and comment code above
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoLastPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, self.pager.pages);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}	
                	if (self.validateChangesOnPrePager && self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){saveChangesFirst(self.pager.pages);}, gotoLastPage, "");
                		} else {
                			gotoLastPage();
                		}
                	}else{
                		gotoLastPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgLast'+this._mtgId).down('div').className = 'mtgLastPageDisabled';
            }

            var keyHandler = function(event) {
                if (event.keyCode == Event.KEY_RETURN) {
                    var pageNumber = $('mtgPageInput'+self._mtgId).value.strip(); //Jerome added strip()
                    if (isNaN(pageNumber)){ //added by Jerome Orio
                    	pageNumber = '1'; 
                    }else if (pageNumber > pages){	
                    	pageNumber = pages;
                    }else if (pageNumber < 1){
                    	pageNumber = '1';
                    }
                    if (!((pageNumber).toString().indexOf(".") < 0)) pageNumber = (pageNumber).toString().substring((pageNumber).toString().indexOf("."),""); //added by Jerome Orio
                    $('mtgPageInput'+self._mtgId).value = pageNumber;
                    //self._retrieveDataFromUrl.call(self, pageNumber);
                    //added by Jerome Orio 12.28.2010 and comment code above
                    self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                    function gotoPageNumber(){
                    	var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, pageNumber);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                    }	
                    if (self.validateChangesOnPrePager && self.getModifiedRows().length != 0 || self.getNewRowsAdded().length != 0 || self.getDeletedRows().length != 0){
                   	if (checkChanges==true) { //added by alfie 05/10/2011
                    		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){saveChangesFirst(pageNumber);}, gotoPageNumber, "");
                    	} else {
                    		gotoPageNumber();
                    	}
                    }else{
                		gotoPageNumber();	
                	}
                    self.keys._nCurrentFocus = null; //to avoid null input error
                }
            };

            if (Prototype.Browser.Gecko || Prototype.Browser.Opera ) {
                Event.observe($('mtgPageInput'+this._mtgId), 'keypress', function(event) {
                    keyHandler(event);
                });
            } else {
                Event.observe($('mtgPageInput'+this._mtgId), 'keydown', function(event) {
                    keyHandler(event);
                });
            }
        }
    },
    
    _addMasterDetailPagerBehavior : function() {
        var self = this;
        if (!self.pager.pages) return;
        var currentPage = self.pager.currentPage;
        var pages = self.pager.pages;
        var total = self.pager.total;
        var checkChanges = this.checkChanges; //added by alfie 05/10/2011
        if (total > 0) {
        	
        	function saveChangesFirst(page){
        		if (!self.preCommit()){ return false; } //Jerome Orio - to validate all required field
        		/*
        		var ok = true;
            	if (self.options.toolbar.onSave) {
            		ok = self.options.toolbar.onSave.call();
            	}
            	if (ok || ok==undefined){
            		if (self.options.toolbar.postSave) {
                		self.options.toolbar.postSave.call();
                	}
            	}
            	*/
        		// i-save
        		self.masterDetailSaveFunc.call();
        		
            	var pre = true;
            	var post = true;
            	if (self.options.prePager){ 
            		pre = self.options.prePager.call();
            	}
            	if (pre || pre==undefined){
            		post = self._retrieveDataFromUrl.call(self, page);
            	}
                if (post){
                	if (self.options.postPager) self.options.postPager.call();
                }	
    		}
        	
            if (currentPage > 1) {
                $('mtgFirst'+this._mtgId).down('div').className = 'mtgFirstPage';
                $('mtgFirst'+this._mtgId).onclick = function() {
                	//self._retrieveDataFromUrl.call(self, 1);
                	//added by Jerome Orio 12.28.2010 and comment code above                	
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoPage1(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }	
                	}
                	
                	if (self.validateChangesOnPrePager && self.masterDetailValidation.call()){
                		if (checkChanges==true) { //added by alfie 05/10/2011 
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                					function(){saveChangesFirst(1);}, 
                					function(){
                						self.masterDetailNoFunc.call();
                						gotoPage1();                						
                					}, "");
                		} else {
                			gotoPage1();
                		}
                	}else{
                		gotoPage1();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgFirst'+this._mtgId).down('div').className = 'mtgFirstPageDisabled';
            }


            if (currentPage > 0 && currentPage < pages) {
                $('mtgNext'+this._mtgId).down('div').className = 'mtgNextPage';
                $('mtgNext'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, currentPage + 1);
                    //added by Jerome Orio 12.28.2010 and comment code above                	
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoNextPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, currentPage + 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}	
                	if (self.validateChangesOnPrePager && self.masterDetailValidation.call()){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                					function(){saveChangesFirst(currentPage + 1);}, 
                					function(){
                						self.masterDetailNoFunc.call();
                						gotoNextPage();                						
                					}, "");
                		} else {
                			gotoNextPage();
                		}
                	}else{
                		gotoNextPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgNext'+this._mtgId).down('div').className = 'mtgNextPageDisabled';
            }


            if (currentPage > 1 && currentPage <= pages) {
                $('mtgPrev'+this._mtgId).down('div').className = 'mtgPrevPage';
                $('mtgPrev'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, currentPage - 1);
                    //added by Jerome Orio 12.28.2010 and comment code above                	
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoPrevPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, currentPage - 1);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}
                	
                	if (self.validateChangesOnPrePager && self.masterDetailValidation.call()){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                					function(){saveChangesFirst(currentPage - 1);}, 
                					function(){
                						self.masterDetailNoFunc.call();
                						gotoPrevPage();                						
                					}, "");
                		} else {
                			gotoPrevPage();
                		}
                	}else{
                		gotoPrevPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgPrev'+this._mtgId).down('div').className = 'mtgPrevPageDisabled';
            }


            if (currentPage < pages) {
                $('mtgLast'+this._mtgId).down('div').className = 'mtgLastPage';
                $('mtgLast'+this._mtgId).onclick = function() {
                    //self._retrieveDataFromUrl.call(self, self.pager.pages);
                    //added by Jerome Orio 12.28.2010 and comment code above                	
                	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                	function gotoLastPage(){
                		var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, self.pager.pages);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                	}	
                	if (self.validateChangesOnPrePager && self.masterDetailValidation.call()){
                		if (checkChanges==true) { //added by alfie 05/10/2011
                			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                					function(){saveChangesFirst(self.pager.pages);}, 
                					function(){
                						self.masterDetailNoFunc.call();
                						gotoLastPage();                						
                					}, "");
                		} else {
                			gotoLastPage();
                		}
                	}else{
                		gotoLastPage();	
                	}
                	self.keys._nCurrentFocus = null; //to avoid null input error
                };
            } else {
                $('mtgLast'+this._mtgId).down('div').className = 'mtgLastPageDisabled';
            }

            var keyHandler = function(event) {
                if (event.keyCode == Event.KEY_RETURN) {
                    var pageNumber = $('mtgPageInput'+self._mtgId).value.strip(); //Jerome added strip()
                    if (isNaN(pageNumber)){ //added by Jerome Orio
                    	pageNumber = '1'; 
                    }else if (pageNumber > pages){	
                    	pageNumber = pages;
                    }else if (pageNumber < 1){
                    	pageNumber = '1';
                    }
                    if (!((pageNumber).toString().indexOf(".") < 0)) pageNumber = (pageNumber).toString().substring((pageNumber).toString().indexOf("."),""); //added by Jerome Orio
                    $('mtgPageInput'+self._mtgId).value = pageNumber;
                    //self._retrieveDataFromUrl.call(self, pageNumber);
                    //added by Jerome Orio 12.28.2010 and comment code above
                    self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
                    function gotoPageNumber(){
                    	var pre = true;
                    	var post = true;
                    	if (self.options.prePager){ 
                    		pre = self.options.prePager.call();
                    	}
                    	if (pre || pre==undefined){
                    		post = self._retrieveDataFromUrl.call(self, pageNumber);
                    	}
                        if (post){
                        	if (self.options.postPager) self.options.postPager.call();
                        }
                    }	
                    if (self.validateChangesOnPrePager && self.masterDetailValidation.call()){
                   	if (checkChanges==true) { //added by alfie 05/10/2011
                    		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
                    				function(){saveChangesFirst(pageNumber);}, 
                    				function(){
                    					self.masterDetailNoFunc.call();
                    					gotoPageNumber();                						
                					}, "");
                    	} else {
                    		gotoPageNumber();
                    	}
                    }else{
                		gotoPageNumber();	
                	}
                    self.keys._nCurrentFocus = null; //to avoid null input error
                }
            };

            if (Prototype.Browser.Gecko || Prototype.Browser.Opera ) {
                Event.observe($('mtgPageInput'+this._mtgId), 'keypress', function(event) {
                    keyHandler(event);
                });
            } else {
                Event.observe($('mtgPageInput'+this._mtgId), 'keydown', function(event) {
                    keyHandler(event);
                });
            }
        }
    },

    resize : function() {
    	// modified by: nica 02.15.2011 - added condition to check if target is null
	    var target = $(this.target);
	    
	    if(target != null){
	        var width = this.options.width || (target.getWidth() - this._fullPadding(target,'left') - this._fullPadding(target,'right')) + 'px';
	        var height = this.options.height || (target.getHeight() - this._fullPadding(target,'top') - this._fullPadding(target,'bottom')) + 'px';
	        this.tableWidth = parseInt(width) - 2;
	        var tallerFlg = false;
	        if ((parseInt(height) - 2) > this.tableHeight) tallerFlg = true;
	        this.tableHeight = parseInt(height) - 2;
	
	        //$('mtgHB' + this._mtgId).setStyle({visibility: 'hidden'});
	        
	        this.tableDiv.setStyle({
	            width: this.tableWidth + 'px',
	            height: this.tableHeight + 'px'
	        });
	    }
	    
        if (this.headerTitle) {
            this.headerTitle.setStyle({
                width: (this.tableWidth - 6) + 'px'
            });
        }

        if (this.headerToolbar) {
            this.headerToolbar.setStyle({
                width: (this.tableWidth - 6) + 'px'
            });
        }

        this.headerRowDiv.setStyle({
            width: (this.tableWidth) + 'px'
        });

        this.overlayDiv.setStyle({
            width: (this.tableWidth + 2) + 'px'
        });

        if (this.addSettingBehaviorFlg) { //added IF condition by Jerome Orio 11.30.2010 only do this if setting behavior is TRUE
        	var settingButton = $('mtgSB' + this._mtgId);
	        settingButton.setStyle({
	            left: (this.tableWidth - 20) + 'px'
	        });
        }

        this.bodyHeight = this.tableHeight - this.headerHeight - 3;
        if (this.options.title) this.bodyHeight = this.bodyHeight - this.headerHeight - 1;
        this.overlayDiv.setStyle({
            height: (this.bodyHeight + 4) + 'px'
        });
        if (this.options.pager) this.bodyHeight = this.bodyHeight - this.pagerHeight;
        if (this.options.toolbar) this.bodyHeight = this.bodyHeight - this.pagerHeight;

        this.bodyDiv.setStyle({
            width: (this.tableWidth) + 'px',
            height: this.bodyHeight + 'px'
        });

        if (this.options.pager) {
            var topPos = this.bodyHeight + this.headerHeight + 3;
            if (this.options.title) topPos += this.headerHeight;
            if (this.options.toolbar) topPos += this.headerHeight;
            this.pagerDiv.setStyle({
                top: topPos + 'px',
                width: (this.tableWidth - 2) + 'px'
            });
        }

        this.renderedRowsAllowed = Math.floor(this.bodyDiv.clientHeight / this.cellHeight);

        if (tallerFlg) {
            /*var html = this._createTableBody(this.rows);
            this.bodyTable.down('tbody').insert(html);
            this._addKeyBehavior();
            this._applyCellCallbacks();
            this.keys.addMouseBehavior();*/
        	//added by Jerome Orio 12.28.2010 and comment code above
        	this.recreateRows();   
        }
    },

    getValueAt : function(x, y) {
        var value = null;
        var id = this.columnModel[x].id;
        var editor = this.columnModel[x].editor || "input";
        x = this.getColumnIndex(id);
        if (y >= 0){
            value = this.rows[y][x];
            if (this.modifiedRows.indexOf(parseInt(y)) != -1 && editor == "input"){
            	value = this.geniisysRows[y][id];
            }
        }else{
            value = this.newRowsAdded[Math.abs(y)-1][x];
        }    
        return value;
    },

    setValueAt : function(value, x, y, refreshValueFlg) {
        var cm = this.columnModel;
        var id = this._mtgId;
        var editor = cm[x].editor;
        value = checkIfTableGridClassExist(cm[x].geniisysClass, "money") ? formatCurrency(value) : //added by Jerome Orio 12.15.2010
        	    (checkIfTableGridClassExist(cm[x].geniisysClass, "rate") ? (nvl(cm[x].deciRate,"") == "" ? formatToNineDecimal(value) :formatToNthDecimal(value, cm[x].deciRate)) : value); //added rate Class - Nica 05.26.2011
        if(refreshValueFlg == undefined || refreshValueFlg) {
            if (editor != null && (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox || editor == 'radio' || editor instanceof MyTableGrid.CellRadioButton || editor == 'select' || editor instanceof MyTableGrid.SelectBox)) { // andrew - 01.26.2011 - added condition for select box
                var input = $('mtgInput'+id+'_'+x+','+y);
                y>=0 ? $('mtgIC'+id+'_'+x+','+y).addClassName('modifiedCell') :null; //nok
                if (editor.hasOwnProperty('getValueOf')) {
                    var trueVal = editor.getValueOf(true);
                    if (value == trueVal) {
                        input.checked = true;
                    } else {
                        input.checked = false;
                        value = editor.getValueOf(false);
                    }
                } else {
                    if (eval(value)) {
                        input.checked = true;
                    } else {
                        input.checked = false;
                        value = false;
                    }
                }
            } else {
            	if (cm[x].visible){
            		$('mtgIC'+id+'_'+x+','+y).innerHTML = value;
            		y>=0 ? $('mtgIC'+id+'_'+x+','+y).addClassName('modifiedCell') :null; //nok
            		if(editor instanceof MyTableGrid.BrowseInput || editor instanceof MyTableGrid.EditorInput){//added by steven 7.29.2013; to reset the width and height for EditorInput
            			$('mtgIC'+id+'_'+x+','+y).setStyle({
            				width : (parseInt($('mtgIC'+id+'_'+x+','+y).getStyle('width')) - 6) + 'px', //added by steven 7.29.2013
        	            	height : '18px',
        	                padding: '3px'
        	            });	
                    }
            	} else { //angelo 03.02.2011 added this else block for setting values of hidden columns
            		 if (y >= 0){
        	            this.rows[y][x] = value;
        	         }else{
        	            this.newRowsAdded[Math.abs(y)-1][x] = value;
        	         }   
            	}
            }
        }
        x = this.getColumnIndex(cm[x].id);
        value = checkIfTableGridClassExist(cm[x].geniisysClass, "money") ? (value== null ? null :value.replace(/,/g, "")) :value; //added by Jerome Orio 12.15.2010 to remove the format before adding to object array
        if (y >= 0){
            this.rows[y][x] = value;
            if (this.modifiedRows.indexOf(y) == -1 && cm[x].id != "recordStatus") this.modifiedRows.push(y); //if doesn't exist in the array the row is registered  //nok
        	if (this.onCellBlur) this.onCellBlur($('mtgInput'+id+'_'+x+','+y), ((y >= 0) ? this.rows[y][x] : this.newRowsAdded[Math.abs(y)-1][x]), x, y, this.columnModel[x].id); //added by Jerome Orio 12.28.2010
        }else{
            this.newRowsAdded[Math.abs(y)-1][x] = value;
            if (this.onCellBlur) this.onCellBlur($('mtgInput'+id+'_'+x+','+y), ((y >= 0) ? this.rows[y][x] : this.newRowsAdded[Math.abs(y)-1][x]), x, y, this.columnModel[x].id); //added by Jerome Orio 12.28.2010
        }    
    },

    /**
     * Update row values with the specified record
     * @author andrew robes
     * @date 07.20.2011
     * @param row - record to be applied
     * @param y - index of row to be updated
     * @param release - if value not true, deselects selected row(d.alcantara, 05-24-2012)
     */
    updateRowAt : function(row, y, release) {
        var cm = this.columnModel;
        var id = this._mtgId;        
        row.recordStatus = 1;
        if (y >= 0){
        	for(var x=0; x<cm.length; x++){  
        		this.rows[y][x] = row[cm[x].id];
        		this.rows[y][cm[x].id] = row[cm[x].id];
        		var geniisysClass = cm[x].geniisysClass || null;
//        		$('mtgIC'+id+'_'+x+','+y).innerHTML = row[cm[x].id];
//        		$('mtgC'+id+'_'+x+','+y).removeClassName('selectedRow');
        		
        		if(cm[x].hasOwnProperty('renderer')){
        			if(checkIfTableGridClassExist(geniisysClass, "money")) {
        				$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].renderer(cm[x].defaultValue || row[cm[x].id]));
        			}else if(checkIfTableGridClassExist(geniisysClass, "rate")){//added geniisysClass 'rate' - nica 06.14.2012
        				$('mtgIC'+id+'_'+x+','+y).innerHTML = nvl(cm[x].deciRate,"") == "" ? formatToNineDecimal(cm[x].renderer(cm[x].defaultValue || row[cm[x].id])) :formatToNthDecimal(cm[x].renderer(cm[x].defaultValue || row[cm[x].id]), cm[x].deciRate);
        			}else{
        				$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].renderer(cm[x].defaultValue || row[cm[x].id]);
        			}
            	}else{
            		if(checkIfTableGridClassExist(geniisysClass, "money")) {
            			$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].defaultValue || row[cm[x].id]);
            		}else if(checkIfTableGridClassExist(geniisysClass, "rate")){//added geniisysClass 'rate' - nica 06.14.2012
            			$('mtgIC'+id+'_'+x+','+y).innerHTML = nvl(cm[x].deciRate,"") == "" ? formatToNineDecimal((cm[x].defaultValue || row[cm[x].id])) :formatToNthDecimal((cm[x].defaultValue || row[cm[x].id]), cm[x].deciRate);
        			}else{
            			$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].defaultValue || row[cm[x].id];
            		}
            	}
        		
        		$('mtgC'+id+'_'+x+','+y).removeClassName('selectedRow');
        	}
        	
        	if (this.modifiedRows.indexOf(y) == -1) this.modifiedRows.push(y);        
        	if(!release) {
        		$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
                this.geniisysRows[y] = row;
                this.keys.removeFocus();
                this.keys.releaseKeys();
        	}
       } else {
    	   for(var x=0; x<cm.length; x++){  
    		   this.rows[this.rows.length + y][x] = row[cm[x].id];
    		   this.rows[this.rows.length + y][cm[x].id] = row[cm[x].id];
    		   var geniisysClass = cm[x].geniisysClass || null;
//    		   $('mtgIC'+id+'_'+x+','+y).innerHTML = row[cm[x].id];
//    		   $('mtgC'+id+'_'+x+','+y).removeClassName('selectedRow');
    		   
    		    if(cm[x].hasOwnProperty('renderer')){
	       			if(checkIfTableGridClassExist(geniisysClass, "money")) {
	       				$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].renderer(cm[x].defaultValue || row[cm[x].id]));
	       			}else{
	       				$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].renderer(cm[x].defaultValue || row[cm[x].id]);
	       			}
	           	}else{
	           		if(checkIfTableGridClassExist(geniisysClass, "money")) {
	           			$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].defaultValue || row[cm[x].id]);
	           		}else{
	           			$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].defaultValue || row[cm[x].id];
	           		}
	           	}
	       		
	       		$('mtgC'+id+'_'+x+','+y).removeClassName('selectedRow');
    	   }
	       
    	   //$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
    	   if(!release) {
           	   $('mtgRow'+id+'_'+y).removeClassName('selectedRow');
	           if (this.modifiedRows.indexOf(Math.abs(y) - 1) == -1) this.modifiedRows.push(Math.abs(y) - 1);    	   
	     	   this.geniisysRows[Math.abs(y) - 1] = row;    	   
	     	   this.keys.removeFocus();
	     	   this.keys.releaseKeys();
           }
    	   
       } 
    },    
    
    getColumnIndex : function(id) {
        var index = -1;
        for (var i = 0; i < this.columnModel.length; i++) {
            if (this.columnModel[i].id == id) {
                index = this.columnModel[i].positionIndex;
                break;
            }
        }
        return index;
    },

    getIndexOf : function(id) {
        var cm = this.columnModel;
        var idx = -1;
        for (var i = 0; i < cm.length; i++) {
            if (cm[i].id == id) {
                idx = i;
                break;
            }
        }
        return idx;
    },

    getCurrentPosition : function() {
        return [this.keys._xCurrentPos, this.keys._yCurrentPos];
    },

    getCellElementAt : function(x, y) {
        return $('mtgC'+this._mtgId + '_' + x + ',' + y);
    },

    getModifiedRows : function() {
        var result = [];
        var modifiedRows = this.modifiedRows;
        var rows = this.rows;
        var cm = this.columnModel;
        var deletedRows = this.deletedRows;
        
        for (var i = 0; i < modifiedRows.length; i++) {
            var idx = modifiedRows[i];
            var row = {};
            if (typeof(rows[idx]) != 'undefined'){
	            for (var j = 0; j < cm.length; j++) {
	                row[cm[j].id] = rows[idx][cm[j].positionIndex];
	            }
	            result.push(row);
            } else {
            	result.push(idx);
            }
            
        }
        //added by Jerome Orio 12.07.2010 to remove all deleted rows 
        for (var a=0; a<deletedRows.length; a++){
        	for (var b=0; b<result.length; b++){
        		if (deletedRows[a].divCtrId == result[b].divCtrId){
        			result.splice(b,1);
        			b--;
        		}
        	}	
        }	
        return result;
    },

    getNewRowsAdded : function() {
        var result = [];
        var newRowsAdded = this.newRowsAdded;
        var cm = this.columnModel;

        for (var i = 0; i < newRowsAdded.length; i++) {
            if (newRowsAdded[i] != null) {
                var row = {};
                for (var j = 0; j < cm.length; j++) {
                    row[cm[j].id] = newRowsAdded[i][cm[j].positionIndex];
                }
                result.push(row);
            }
        }
        return result;
    },
   
    getDeletedRows : function() {
        return this.deletedRows;
    },

    /**
     * Get all deleted divCtrId in table grid
     * @author Jerome Orio 
     * @return array of id
     */
    getDeletedIds : function(){
    	var self = this;
    	var arr = [];
    	for (var i=0; i<self.deletedRows.length; i++){
    		arr.push(self.deletedRows[i].divCtrId);
    	}
    	return arr;
    },

    /**
     * Returns the selected rows by column
     *
     * @param id of the selectable column
     */
    getSelectedRowsByColumn : function(id) {
        var idx = this.getIndexOf(id);
        var result = [];
        var cm = this.columnModel;
        var rows = this.rows;
        var newRowsAdded = this.newRowsAdded;
        if (idx < 0) return null;
        var selectedRowsIdx = this._getSelectedRowsIdx(idx);
        for (var i = 0; i < selectedRowsIdx.length; i++) {
            var row = {};
            var rowIdx = selectedRowsIdx[i];
            for (var j = 0; j < cm.length; j++) {
                if (rowIdx >= 0)
                    row[cm[j].id] = rows[rowIdx][cm[j].positionIndex];
                else
                    row[cm[j].id] = newRowsAdded[Math.abs(rowIdx)-1][cm[j].positionIndex];
            }
            result.push(row);
        }
        return result;
    },
    
	/**
	 * Get all selected rows
	 * @author Niknok Orio
	 * @param  
	 */
    _getSelectedRows: function(){
    	var result = [];
        var cm = this.columnModel;
        var rows = this.rows;
        var newRowsAdded = this.newRowsAdded; 
        var delIndx = this.getDeletedIds();
        
        for (var i = 0; i < rows.length; i++) {
        	var divCtrId = rows[i][this.getColumnIndex('divCtrId')];
        	if (delIndx.indexOf(divCtrId) == -1){ //to disregard all deleted rows
        		var value = nvl(this.getValueAt(this.getColumnIndex('recordStatus'), i),"N");
        		if (value == true || value == "Y") {//if checked add the current row
	        		var row = {}; 
		            for (var j = 0; j < cm.length; j++) {
		            	row[cm[j].id] = rows[i][cm[j].positionIndex];
		            }
		            result.push(row);
        		}
        	}
        }
        
        for (var i = 0; i < newRowsAdded.length; i++) {
        	if (newRowsAdded[i] != null){
        		var value = nvl(this.getValueAt(this.getColumnIndex('recordStatus'), i),"N");
        		if (value == true || value == "Y") {//if checked add the current row
		            var row = {}; 
		            for (var j = 0; j < cm.length; j++) {
		            	row[cm[j].id] = newRowsAdded[Math.abs(i)-1][cm[j].positionIndex];
		            }
		            result.push(row);
	        	}
        	}
        }
        
        return result;
    },

    _getSelectedRowsIdx: function(idx) {
        var result = [];
        var id = this._mtgId;
        var cm = this.columnModel;
        var newRowsAdded = this.newRowsAdded;
        var renderedRows = this.renderedRows;
        idx = idx || -1; // Selectable column index
        var selectAllFlg = false;
        if (idx == -1) {
            for (var i = 0; i < cm.length; i++) {
                if (cm[i].editor == 'checkbox' || cm[i].editor instanceof MyTableGrid.CellCheckbox
                        && cm[i].editor.selectable) {
                    idx = cm[i].positionIndex;
                    selectAllFlg = cm[i].selectAllFlg;
                    break;
                }
            }
        } else {
            selectAllFlg = cm[idx].selectAllFlg;
        }
        if (idx >=0) {
            var j = 0;
            var y = 0;
            if (newRowsAdded.length > 0) { // there are new rows added
                for (j = 0; j < newRowsAdded.length; j++) {
                    y = -(j + 1);
                    if($('mtgInput'+id+'_'+idx+','+y).checked && $('mtgInput'+id+'_'+idx+','+y).up('tr',0).getStyle('display') != 'none') result.push(y); //edited by Jerome Orio added display condition 12.29.2010
                }
            }

            for (j = 0; j < renderedRows; j++) {
                y = j;
                if($('mtgInput'+id+'_'+idx+','+y).checked && $('mtgInput'+id+'_'+idx+','+y).up('tr',0).getStyle('display') != 'none') result.push(y); //edited by Jerome Orio added display condition 12.29.2010
            }

            if (selectAllFlg && renderedRows < this.rows.length) {
                for (j = renderedRows; j < this.rows.length; j++) {
                    result.push(j);
                }
            }
        }
        return result;
    }, 
    
    highlightRow : function(id, value) {
        $$('.mtgRow'+this._mtgId).each(function(row){
            row.removeClassName('focus');
        });

        var index = this.getColumnIndex(id);
        var rowIndex = -1;
        for (var i = 0; i < this.rows.length; i++) {
            if (this.rows[i][index] == value) {
                rowIndex = i;
                break;
            }
        }

        if (rowIndex >= 0) {
            $('mtgRow'+this._mtgId+'_'+rowIndex).addClassName('focus');
        }
    },

    getRow : function(y) {
        var cm = this.columnModel;
        var result = {};
        for (var x = 0; x < cm.length; x++) {
            var value = null;
            if (y >= 0)
                value = this.rows[y][cm[x].positionIndex];
            else
                value = this.newRowsAdded[-(y+1)][cm[x].positionIndex];
            result[cm[x].id] = value;
        }
        return result;
    },
    
    /**
     * Returns the All rows excluding deleted rows
     * @author niknok
     * @since 03.20.12
     * @param id of the selectable column
     */
    getAllRows : function() { 
        var result = [];
        var cm = this.columnModel;
        var rows = this.rows;
        var newRowsAdded = this.newRowsAdded; 
        var delIndx = this.getDeletedIds();
        
        for (var i = 0; i < rows.length; i++) {
        	var divCtrId = rows[i][this.getColumnIndex('divCtrId')];
        	if (delIndx.indexOf(divCtrId) == -1){ //to disregard all deleted rows
	        	var row = {}; 
	            for (var j = 0; j < cm.length; j++) {
	            	row[cm[j].id] = rows[i][cm[j].positionIndex];
	            }
	            result.push(row);
        	}
        }
        
        for (var i = 0; i < newRowsAdded.length; i++) {
            var row = {}; 
            for (var j = 0; j < cm.length; j++) {
            	row[cm[j].id] = newRowsAdded[Math.abs(i)-1][cm[j].positionIndex];
            }
            result.push(row);
        }
        
        return result;
    },

    clear : function() {
        this.modifiedRows = [];
        //added by Jerome Orio 12.02.2010
        this.newRowsAdded = [];
        this.deletedRows  = [];
    },

    addNewRow : function() {
    	if (!this.preCommit()){ return false; }//added by Jerome Orio 12.09.2010 - to validate all required field before adding new row
        var keys = this.keys;
        var bodyTable = this.bodyTable;
        var cm = this.columnModel;
        var i = this.newRowsAdded.length + 1;
        var newRow = [];
        for (var j = 0; j < cm.length; j++) {
            newRow[j] = '';
            //added by Jerome Orio 12.10.2010 for checkbox and has a getValueOf property and default value if exist
            var editor = cm[j].editor || 'input';
            if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox){
            	var defaultValue = cm[j].defaultValue || false;
            	if (cm[j].editor.hasOwnProperty('getValueOf')) {newRow[j] = cm[j].editor.getValueOf(defaultValue);}else{newRow[j] = defaultValue;} 
            }else if (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.SelectBox || editor instanceof MyTableGrid.CellCalendar){ //edited by angelo 2.21.11 to set default value for select box - 3.17.11 added cell calendar
            	newRow[j] = cm[j].defaultValue || '';
            }
            //end - Jerome
            if (cm[j].id == "divCtrId"){ newRow[j] = -i; }//added by Jerome Orio for new divCtrId 12.08.2010
        }
        var pos = this.options.newRowPosition || 'top';
        if (pos=='top'){
        	bodyTable.down('tbody').insert({top: this._createRow(newRow, -i)});
        }else{
        	bodyTable.down('tbody').insert({bottom: this._createRow(newRow, -i)});
        }
        this.newRowsAdded[i-1] = newRow;
        keys.setTopLimit(-i);
        //added by Jerome
        this._addKeyBehaviorToRow(newRow, -i);
        keys.addMouseBehaviorToRow(-i);
        this._applyCellCallbackToRow(-i);
        this.scrollTop = this.bodyDiv.scrollTop = 0;
    },

    /**
     * Add row with specified values from object
     * @author andrew robes
     * @date 07.19.2011
     * @param row - row object to be added
     */
    addRow : function(row) {
    	row.recordStatus = 0;
    	if (!this.preCommit()){ return false; }//added by Jerome Orio 12.09.2010 - to validate all required field before adding new row
        var keys = this.keys;
        var bodyTable = this.bodyTable;
        var cm = this.columnModel;
        var i = this.newRowsAdded.length + 1;
        var newRow = [];
        for (var j = 0; j < cm.length; j++) {
            newRow[j] = '';           
            
            var editor = cm[j].editor || 'input';
            if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox){
            	var defaultValue = cm[j].defaultValue || false;
            	if (cm[j].editor.hasOwnProperty('getValueOf')) {newRow[j] = cm[j].editor.getValueOf(defaultValue);}else{newRow[j] = defaultValue;} 
            }else if (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.SelectBox || editor instanceof MyTableGrid.CellCalendar){ //edited by angelo 2.21.11 to set default value for select box - 3.17.11 added cell calendar
            	newRow[j] = cm[j].defaultValue || row[cm[j].id];
            }

            if (cm[j].id == "divCtrId"){ newRow[j] = -i; }//added by Jerome Orio for new divCtrId 12.08.2010
        }
        bodyTable.down('tbody').insert({top: this._createRow(newRow, -i)});
        this.newRowsAdded[i-1] = newRow;
        keys.setTopLimit(-i);
        
        this._addKeyBehaviorToRow(newRow, -i);
        keys.addMouseBehaviorToRow(-i);
        this._applyCellCallbackToRow(-i);
        this.scrollTop = this.bodyDiv.scrollTop = 0;
        this.geniisysRows[this.geniisysRows.length] = row;   
        this.rows[this.rows.length] = newRow;
        if(this.pager){
	        this.pager.total = parseInt(this.pager.total) + 1;
	        this.pager.to = parseInt(this.pager.to) + 1;
	        this._updateRecordInfo();
        }
    },    

    addBottomRow : function(row) {
    	row.recordStatus = 0;
    	if (!this.preCommit()){ return false; }//added by Jerome Orio 12.09.2010 - to validate all required field before adding new row
        var keys = this.keys;
        var bodyTable = this.bodyTable;
        var cm = this.columnModel;
        var i = (this.bodyTable.down('tbody').childElements()).length;// + 1;//this.newRowsAdded.length + 1;
        var newRow = [];
        for (var j = 0; j < cm.length; j++) {
            newRow[j] = '';           
            
            var editor = cm[j].editor || 'input';
            if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox){           	            	
            	newRow[j] = row[cm[j].id]|| cm[j].defaultValue || false;            	            	
            }else if (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.SelectBox || editor instanceof MyTableGrid.CellCalendar){ //edited by angelo 2.21.11 to set default value for select box - 3.17.11 added cell calendar
            	newRow[j] = cm[j].defaultValue || row[cm[j].id];
            }

            if (cm[j].id == "divCtrId"){ newRow[j] = i; }//added by Jerome Orio for new divCtrId 12.08.2010
        }
        bodyTable.down('tbody').insert({bottom: this._createRow(newRow, i)});
        this.newRowsAdded[i] = newRow;
        keys.setTopLimit(i);
        
        this._addKeyBehaviorToRow(newRow, i);
        keys.addMouseBehaviorToRow(i);
        this._applyCellCallbackToRow(i);
        this.scrollTop = this.bodyDiv.scrollTop = 0;
        this.geniisysRows[i] = row;
        this.rows[i] = row; // added by: Nica 02.22.2012
        if (this.pager.total < this.pager.to) {
        	this.pager.to = this.pager.total;
		}
        this.pager.total = parseInt(this.pager.total) + 1;
        this.pager.to = parseInt(this.pager.to) + 1;
        this._updateRecordInfo();        
    },    
    
    /**
     * Create new table grid row
     * @author Jerome Orio
     * @return record row
     */ 
    createNewRow: function(obj){
    	var tableGrid = this;
    	var divCtrId = tableGrid.newRowsAdded.length + 1;
    	var cm = tableGrid.columnModel;
    	var newRow = [];
    	
        for (var j = 0; j < cm.length; j++) {
            newRow[j] = '';           
            
            var editor = cm[j].editor || 'input';
            if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox){
            	var defaultValue = cm[j].defaultValue || false;
            	if (cm[j].editor.hasOwnProperty('getValueOf')){
            		newRow[j] = obj[cm[j].id] || cm[j].editor.getValueOf(defaultValue);
            	}else{
            		newRow[j] = defaultValue;
            	} 
            }else if (editor == 'input' || editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.SelectBox || editor instanceof MyTableGrid.CellCalendar){ //edited by angelo 2.21.11 to set default value for select box - 3.17.11 added cell calendar
            	// modified, to prevent undefined fields (emman 09.22.2011)
            	if (nvl(cm[j].defaultValue, "") == "") {
            		newRow[j] = obj[cm[j].id];
            	} else {
            		newRow[j] = obj[cm[j].id] || nvl(cm[j].defaultValue, null);
            	}
            }

            if (cm[j].id == "divCtrId"){ newRow[j] = -divCtrId; }//added by Jerome Orio for new divCtrId 12.08.2010
            //alert(cm[j].id + ": " + newRow[j]);
        }

        var pos = this.options.newRowPosition || 'top';
        if (pos=='top'){
        	tableGrid.bodyTable.down('tbody').insert({top: tableGrid._createRow(newRow, -divCtrId)});
        }else{
        	tableGrid.bodyTable.down('tbody').insert({bottom: tableGrid._createRow(newRow, -divCtrId)});
        }
        tableGrid.newRowsAdded[divCtrId-1] = newRow;
        tableGrid.keys.setTopLimit(-divCtrId);
        tableGrid._addKeyBehaviorToRow(newRow, -divCtrId);
        tableGrid.keys.addMouseBehaviorToRow(-divCtrId);
        tableGrid._applyCellCallbackToRow(-divCtrId);
        tableGrid.scrollTop = tableGrid.bodyDiv.scrollTop = 0;
        if(this.pager){
	        this.pager.total = parseInt(this.pager.total) + 1;
	        this.pager.to = parseInt(this.pager.to) + 1;
	        this._updateRecordInfo();  
        }
    },

    /**
     * Create new table grid rows
     * @author Jerome Orio
     * @return array of object
     */     
    createNewRows : function(objArray){
    	for (var i=0; i<objArray.length; i++){
    		this.createNewRow(objArray[i]);
    	}
    },    

    deleteRows : function() {
        var id = this._mtgId;
        var selectedRows = this._getSelectedRowsIdx();
        var i = 0;
        var y = 0;
        for (i = 0; i < selectedRows.length; i++) {
            y = selectedRows[i];
            if (y >=0) {
            	if ($('mtgRow'+id+'_'+y).getStyle("display") != "none"){ //added IF condition by Jerome Orio to avoid duplication
            		this.deletedRows.push(this.getRow(y));
            	}
            } else {
                this.newRowsAdded[Math.abs(y)-1] = null;
            }
            $('mtgRow'+id+'_'+y).hide();
        }
      //added by Jerome Orio 12.16.2010 to avoid null input error onblur
        var self =this;
		self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);
		self.keys.blur();
		self.keys._nCurrentFocus = null;
	    self.keys._nOldFocus = null;
    },
    
    deleteAllRows : function(){
    	var tableGrid = this;
    	for (var i=0; i<tableGrid.rows.length; i++) {
    		this.deleteRow(i);	
    	}
    	for (var i=0; i<tableGrid.newRowsAdded.length; i++){
    		this.deleteRow(i);
    	}
    },
    
    /**
     * Delete the specified row index
     * @author andrew robes
     * @param index - row index to be deleted
     */
    deleteRow : function(index) {
        var id = this._mtgId;
        var i = 0;

        if (index >=0) {
        	if ($('mtgRow'+id+'_'+index).getStyle("display") != "none"){
        		this.deletedRows.push(this.getRow(index));
        	}
        } else {
            this.newRowsAdded[Math.abs(index)-1] = null;
        }
        $('mtgRow'+id+'_'+index).hide();

        var self =this;
		self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);
		self.keys.blur();
		self.keys._nCurrentFocus = null;
	    self.keys._nOldFocus = null;
	    
	    if(this.pager){
		    if(this.pager.pages == this.pager.currentPage) {
		    	this.pager.to = this.pager.total;
		    }
		    this.pager.total = parseInt(this.pager.total) - 1;
	    	this.pager.to = parseInt(this.pager.to) - 1;
	        this._updateRecordInfo();        
	    }
    },
    
    /**
     * Delete the specified row index
     * @author Jerome Orio 
     * @param columnName - column name
     * 		  columnValue - column value
     */    
    deleteAnyRows: function(columnName, columnValue){
    	var tableGrid = this;
    	for (var i=0; i<tableGrid.rows.length; i++) {
    		if (tableGrid.rows[i][tableGrid.getColumnIndex(columnName)] == columnValue){
    			tableGrid.deleteRow(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]);
    		}	
    	}
    	for (var i=0; i<tableGrid.newRowsAdded.length; i++){
    		if (tableGrid.newRowsAdded[i] != null){
    			if (tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(columnName)] == columnValue){
    				tableGrid.deleteRow(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('divCtrId')]);
    			}
    		}
    	}
    },	    
    
    refreshURL : function(tableModel) {
    	this.url = tableModel.url || null;		//d.alcantara, 06-29-2011
    },

    refresh : function() {
        //this._retrieveDataFromUrl(1,false);
        //edited by Jerome Orio and comment code above
    	var self = this;
    	var currentPage = self.pager.currentPage;
        var pages = self.pager.pages;
        // check if mtgPageInput is null (if previous list has no records)
        var pageNumber = ($('mtgPageInput'+self._mtgId) == null) ? '1' : $('mtgPageInput'+self._mtgId).value.strip();  
        if (isNaN(pageNumber)){ 
        	pageNumber = '1'; 
        }else if (pageNumber > pages){	
        	pageNumber = pages;
        }else if (pageNumber < 1){
        	pageNumber = '1';
        }
        if (!((pageNumber).toString().indexOf(".") < 0)) pageNumber = (pageNumber).toString().substring((pageNumber).toString().indexOf("."),""); //added by Jerome Orio
        
        if ($('mtgPageInput'+self._mtgId) != null) {
        	$('mtgPageInput'+self._mtgId).value = pageNumber;
        }
        
        var pre = true;
    	var post = true;
    	if (self.options.prePager){ 
    		pre = self.options.prePager.call();
    	}
    	if (pre || pre==undefined){
    		post = self._retrieveDataFromUrl.call(self, pageNumber);
    	}
        if (post){
        	if (self.options.postPager) self.options.postPager.call();
        }
    },

    empty : function() {
        var bodyTable = this.bodyTable;
        bodyTable.down('tbody').innerHTML = '';
        this.rows = [];
    },

    _fromObjectToArray : function(row) {
        var result = null;
        var cm = this.columnModel;

        if (row instanceof Array) {
            result = row;
        } else if (row instanceof Object) {
            result = [];
            var i = 0;
            for (var j = 0; j < cm.length; j++) {
                result[i++] = (row[cm[j].id]) ? row[cm[j].id] : '';
            }
        }
        return result;
    },    
    
    /*	Date		Author			Description
     * 	==========	===============	==============================
     * 	08.04.2011	mark jm			update only the table listing (used in item modules)
     *  02.06.2012	Nica			added condition that will consider geniisysClass for formatting    
     *              d.alcantara		added parameter release - if value not true, deselects selected row
     */
    updateVisibleRowOnly : function(row, y, release) {    	
		var cm = this.columnModel;
        var id = this._mtgId;
        row.recordStatus = 1; // added by andrew - 10.18.2012
        
        if (y >= 0){
        	for(var x=0; x<cm.length; x++){        		
        		//this.rows[y][x] = row[cm[x].id]; 
        		var editor = cm[x].editor || 'input';
        		var geniisysClass = cm[x].geniisysClass || null;
        		
                if (editor == 'checkbox' || editor instanceof MyTableGrid.CellCheckbox){                	
                	/*var defaultValue = row[cm[x].id] || cm[x].defaultValue;
                	var editorValue = cm[x].editor.hasOwnProperty('getValueOf') ? cm[x].editor.getValueOf(defaultValue) : defaultValue;
                	
                	if(editorValue){                		
                		$('mtgIC'+id+'_'+x+','+y).childElements()[0].setAttribute("checked", "checked");
                	}else{
                		$('mtgIC'+id+'_'+x+','+y).childElements()[0].removeAttribute("checked");
                	}
                	
                	$('mtgIC'+id+'_'+x+','+y).value = editorValue;*/
                	
                	var defaultValue = row[cm[x].id] || (editor.hasOwnProperty('getValueOf') ? editor.getValueOf(cm[x].defaultValue) :cm[x].defaultValue);
                	var otherValue = cm[x].otherValue || false;
                	var trueVal = editor.hasOwnProperty('getValueOf') ? editor.getValueOf(true) :true;
                    var falseVal = editor.hasOwnProperty('getValueOf') ? editor.getValueOf(false): false;
                    
                    if (otherValue){
                    	if (defaultValue != falseVal) {
                    		$('mtgIC'+id+'_'+x+','+y).childElements()[0].setAttribute("checked", "checked");
                        } else {
                        	$('mtgIC'+id+'_'+x+','+y).childElements()[0].removeAttribute("checked");
                        }
                    }else{
                    	if (defaultValue == trueVal) {
                    		$('mtgIC'+id+'_'+x+','+y).childElements()[0].setAttribute("checked", "checked");
                        } else {
                        	$('mtgIC'+id+'_'+x+','+y).childElements()[0].removeAttribute("checked");
                        }
                    }
                
        		}else if (/*editor == 'input' || */editor instanceof MyTableGrid.CellInput || editor instanceof MyTableGrid.SelectBox || editor instanceof MyTableGrid.CellCalendar){                	
                	if(cm[x].hasOwnProperty('renderer')){
                		$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].renderer(cm[x].defaultValue || row[cm[x].id]);
                	}else{
                		$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].defaultValue || row[cm[x].id];
                	}                	
                }else if(editor == 'input'){ // modified by: Nica 02.06.2012 - to consider geniisysClass format
            		if(cm[x].hasOwnProperty('renderer')){
            			if(checkIfTableGridClassExist(geniisysClass, "money")) {
            				$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].renderer(cm[x].defaultValue || row[cm[x].id]));
            			}else{
            				$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].renderer(cm[x].defaultValue || row[cm[x].id]);
            			}
                	}else{
                		if(checkIfTableGridClassExist(geniisysClass, "money")) {
                			$('mtgIC'+id+'_'+x+','+y).innerHTML = formatCurrency(cm[x].defaultValue || row[cm[x].id]);
                		}else{
                			$('mtgIC'+id+'_'+x+','+y).innerHTML = cm[x].defaultValue || row[cm[x].id];
                		}
                	}
                }                
        		
        		//$('mtgIC'+id+'_'+x+','+y).innerHTML = row[cm[x].id];
        		$('mtgC'+id+'_'+x+','+y).removeClassName('selectedRow');
        	}        	
        	
        	if (this.modifiedRows.indexOf(y) == -1) this.modifiedRows.push(y);        	
            this.geniisysRows[y] = row;
            if(!release) {
            	$('mtgRow'+id+'_'+y).removeClassName('selectedRow');
            }
            this.keys.removeFocus();
            this.keys.releaseKeys();
        }    	              
    },    
    
    /*	Date		Author			Description
     * 	==========	===============	==============================
     * 	08.04.2011	mark jm			delete row in table listing (used in item modules, UI only)    
     */   
    deleteVisibleRowOnly : function(index) {
        var id = this._mtgId;
        var i = 0;
        /*
        if (index >=0) {
        	if ($('mtgRow'+id+'_'+index).getStyle("display") != "none"){
        		this.deletedRows.push(this.getRow(index));
        	}
        } else {
            this.newRowsAdded[Math.abs(index)-1] = null;
        }
        */
        $('mtgRow'+id+'_'+index).hide();

        var self =this;
		self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);
		self.keys.blur();
		self.keys._nCurrentFocus = null;
	    self.keys._nOldFocus = null;	    
	    if(this.pager.pages == this.pager.currentPage) {
	    	this.pager.to = this.pager.total;
	    }
	    this.pager.total = parseInt(this.pager.total) - 1;
    	this.pager.to = parseInt(this.pager.to) - 1;    	
        this._updateRecordInfo();
    },
    
    /**
     * Saving with conditional postSaving :)
     * @author Jerome Orio
     * @param postSaving - true if postSave function will call after saving
     */
    saveGrid : function(postSaving){
    	var self = this;
    	self._blurCellElement(self.keys._nCurrentFocus==null?self.keys._nOldFocus:self.keys._nCurrentFocus);  //to avoid null input error            
    	if (self.getModifiedRows().length == 0 && self.getNewRowsAdded().length == 0 && self.getDeletedRows().length == 0){//to check if changes exist 
    		if (self.checkChangeTag == true){//added nok 03.26.12 to check also changeTag on saving to check changes on subpages
    			if (nvl(changeTag,0) == 0){
    				showMessageBox(objCommonMessage.NO_CHANGES, "I"); 
        			return false;
    			}
    		}else{
    			showMessageBox(objCommonMessage.NO_CHANGES, "I"); 
    			return false;
    		}
    	} 
    	if (!self.preCommit()){ return false; } //to validate all required field before saving
    	var ok = true;
    	if (self.options.toolbar.onSave) {
    		ok = self.options.toolbar.onSave.call();
    	}
    	if ((ok || ok==undefined) && nvl(postSaving,false) == true){
    		if (self.options.toolbar.postSave) {
    	   		self.options.toolbar.postSave.call();
    	   	}
    	}if ((ok || ok==undefined) && nvl(postSaving,false) == "onCancel"){
    		if (self.options.toolbar.postSave2) {
    	   		self.options.toolbar.postSave2.call();
    	   	}
    	}		
    	self.keys._nCurrentFocus = null;
    },
    
    /**
     * Unselect all selected table grid rows
     * @author Jerome Orio
     */
    unselectRows : function(){
    	var self = this; 
    	$$('.mtgRow'+self._mtgId).each(function(row){
            row.removeClassName('focus');
            row.removeClassName('selectedRow');
        });
    	$$('.mtgC'+self._mtgId).each(function(row){
            row.removeClassName('focus');
            row.removeClassName('selectedRow');
        });
    },
    
    /**
     * Select table grid row
     * @author Jerome Orio
     * @param divCtrId - row index to select
     */
    selectRow : function (divCtrId){
    	var self = this; 
    	$('mtgRow'+self._mtgId+'_'+divCtrId).addClassName('selectedRow');
    	$('mtgRow'+self._mtgId+'_'+divCtrId).scrollIntoView();
    },
    
    /**
     * Disable all table grid rows
     * @author Jerome Orio
     */
    disableRows : function(){
    	var self = this; 
    	for (var i=0; i<self.columnModel.length; i++){
    		self.columnModel[i].editable = false;
    	}	
    },
    
    /**
     * Check first if all required fields/columns is not null before saving
     * @author Jerome Orio
     */
    preCommit: function(){
    	var self = this; 
    	var newRowsAdded = self.getNewRowsAdded();
    	var modifiedRows = self.getModifiedRows();
    	self.unselectRows();
    	var requiredColumns = $w(self.requiredColumns);
    	if (requiredColumns.length<=0){return true;}
    	
    	for (var i = 0; i < modifiedRows.length; i++) {
    		for (var p in modifiedRows[i]) {
    			for (var req=0; req<requiredColumns.length; req++){
    				if (p == requiredColumns[req]){
    					if (modifiedRows[i][p] == "" || modifiedRows[i][p] == null){
    						self.selectRow(modifiedRows[i].divCtrId);
    						showWaitingMessageBox((self.columnModel[self.getColumnIndex(p)].title).capitalize()+" is required.", "E", function(){
    							fireEvent($("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+modifiedRows[i].divCtrId), "click");
    							if (!$("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+modifiedRows[i].divCtrId).hasClassName("selectedRow")) fireEvent($("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+modifiedRows[i].divCtrId), "click");
    						});
    						return false;
    					}	
    				}	
    			}
    		}	
    	}
    	
    	for (var i = 0; i < newRowsAdded.length; i++) {
    		for (var p in newRowsAdded[i]) {
    			for (var req=0; req<requiredColumns.length; req++){
    				if (p == requiredColumns[req]){
    					if (newRowsAdded[i][p] == "" || newRowsAdded[i][p] == null){
    						self.selectRow(newRowsAdded[i].divCtrId);
    						showWaitingMessageBox((self.columnModel[self.getColumnIndex(p)].title).capitalize()+" is required.", "E", function(){
    							fireEvent($("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+newRowsAdded[i].divCtrId), "click");
    							if (!$("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+newRowsAdded[i].divCtrId).hasClassName("selectedRow")) fireEvent($("mtgIC"+self._mtgId+"_"+self.getColumnIndex(p)+","+newRowsAdded[i].divCtrId), "click");
    						});
    						return false;
    					}	
    				}	
    			}
    		}	
    	}
    	return true;
    },
    
    /**
     * Validate if sequence on rows exists
     * @author Jerome Orio
     * @return true - if value not exist in tablegrid else false
     */    
    validateSequence: function(value, columnName){
		var ok = true;
		var tableGrid = this;
		var arr = tableGrid.getDeletedIds();
		
		if (value == "" || value == null) return true;
		for (var i=0; i<tableGrid.rows.length; i++){
			var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
			if (arr.indexOf(divCtrId) == -1){
				if (value == tableGrid.rows[i][tableGrid.getColumnIndex(columnName)]){
					ok = false;
					return false;
				}
			}
		}	
		
		var newRowsAdded = tableGrid.getNewRowsAdded();
		for (var i=0; i<newRowsAdded.length; i++){
			if (value == newRowsAdded[i][columnName]){
				ok = false;
				return false;
			}	
		}
		return ok;
	},
	
	/**
	 * Create notIn parameter
	 * @author Niknok Orio
	 * @param colId - column id used for not in parameter
	 */
	createNotInParam: function(colId){
		var tableGrid = this;
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				if (nvl(tableGrid.rows[i][tableGrid.getColumnIndex(colId)],null) != null){
					notIn = notIn + (tableGrid.rows[i][tableGrid.getColumnIndex(colId)]+",");
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				if (nvl(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(colId)],null) != null){
					notIn = notIn + (tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(colId)]+",");
				}
			}
		}
		return notIn.length>0 ? notIn.substr(0,notIn.length-1) :notIn;
	},

	/**
	 * Create notIn parameter
	 * @author Niknok Orio
	 * @param parentCol - primary column
	 * 		  parentColValue - primary column value
	 * 		  childCol - column id used for not in parameter
	 */
	createNotInParam2: function(parentCol, parentColValue, childCol){
		var tableGrid = this;
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				if (nvl(tableGrid.rows[i][tableGrid.getColumnIndex(parentCol)],null) == parentColValue){
					if (nvl(tableGrid.rows[i][tableGrid.getColumnIndex(childCol)],null) != null){
						notIn = notIn + (tableGrid.rows[i][tableGrid.getColumnIndex(childCol)]+",");
					}
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				if (nvl(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(parentCol)],null) == parentColValue){
					if (nvl(tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(childCol)],null) != null){
						notIn = notIn + (tableGrid.newRowsAdded[i][tableGrid.getColumnIndex(childCol)]+",");
					}
				}
			}
		}
		return notIn.length>0 ? notIn.substr(0,notIn.length-1) :notIn;
	},	
	
	/**
	 * Uncheck record status checkbox
	 * @author Niknok Orio
	 * @param  
	 */
	uncheckRecStatus: function(x,y){
		this.setValueAt(false, x, y, false);
		$('mtgInput'+this._mtgId+'_'+String(Number(x))+','+String(Number(y))).checked = false;
	},
	
	/**
	 * Check record status checkbox
	 * @author Niknok Orio
	 * @param  
	 */
	checkRecStatus: function(x,y){
		this.setValueAt(true, x, y, false);
		$('mtgInput'+this._mtgId+'_'+String(Number(x))+','+String(Number(y))).checked = true;
	},
	
	/**
	 * Get change tag on tablegrid
	 * @author Niknok Orio
	 * @param  
	 */
	getChangeTag: function(){
		var mtgChangeTag = 0;
		if (this.getModifiedRows().length != 0 || this.getNewRowsAdded().length != 0 || this.getDeletedRows().length != 0){
			mtgChangeTag = 1;
		}
		return mtgChangeTag;
	},
	
	/**
	 * Release keys on tablegrid
	 * @author Niknok Orio
	 * @param  
	 */
	releaseKeys: function(){
		this.keys.removeFocus(this.keys._nCurrentFocus, true);
        this.keys.releaseKeys();
        this.keys._nOldFocus = null;
	},
	
	/**
	 * Get all tagged rows
	 * @author Niknok Orio
	 * @param  
	 */
	getTaggedRows : function() {
        return this._getSelectedRows();
    }
};


var HeaderBuilder = Class.create();

HeaderBuilder.prototype = {
    initialize : function(id, cm) {
        this.columnModel = cm;
        this._mtgId = id;
        this.gap = 2; //diff between width and offsetWidth
        if (Prototype.Browser.WebKit) this.gap = 0;
        this.filledPositions = [];
        this._leafElements = [];
        this.defaultHeaderColumnWidth = 100;
        this.cellHeight = 24;
        this.rnl = this.getHeaderRowNestedLevel();
        this._validateHeaderColumns();
        this.headerWidth = this.getTableHeaderWidth();
        this.headerHeight = this.getTableHeaderHeight();
    },

    /**
     * Creates header row
     */
    _createHeaderRow : function() {
        var thTmpl = '<th id="mtgHC{id}_{x}" colspan="{colspan}" rowspan="{rowspan}" width="{width}" height="{height}" style="position:relative;width:{width}px;height:{height}px;padding:0;margin:0;border-bottom-color:{color};display:{display};" class="mtgHeaderCell mtgHC{id}" parentId="{parentId}">';
        var thTmplLast = '<th id="mtgHC{id}_{x}" colspan="{colspan}" rowspan="{rowspan}" width="{width}" height="{height}" style="width:{width}px;height:{height}px;padding:0;margin:0;border-right:none;border-bottom:1px solid #ccc;" class="mtgHeaderCell mtgHC{id}" parentId="{parentId}">';
        var ihcTmpl = '<div title="{altTitle}" alt="{altTitle}" id="mtgIHC{id}_{x}" class="mtgInnerHeaderCell mtgIHC{id}" style="text-align: {titleAlign};float:left;width:{width}px;height:{height}px;padding:3px;z-index:20">';
        var ihcTmplLast = '<div class="mtgInnerHeaderCell" style="position:relative;width:{width}px;height:{height}px;padding:3px;z-index:20">';
        var hsTmpl = '<div id="mtgHS{id}_{x}" class="mtgHS mtgHS{id}" style="float:right;width:1px;height:{height}px;z-index:30">';
        var siTmpl = '<span id="mtgSortIcon{id}_{x}" style="width:8px;height:4px;visibility:hidden">&nbsp;&nbsp;&nbsp;</span>';

        var cm = this.columnModel;
        var id = this._mtgId;
        var gap = (this.gap == 0)? 2 : 0;
        var rnl = this.rnl; //row nested level

        var html = [];
        var idx = 0;
        this.filledPositions = [];

        html[idx++] = '<table id="mtgHRT'+id+'" width="'+(this.headerWidth+21)+'" cellpadding="0" cellspacing="0" border="0" class="mtgHeaderRowTable">';
        html[idx++] = '<thead>';

        var temp = null;
        for (var i = 0; i < rnl; i++) { // for each nested level
            var row = this._getHeaderRow(i);
            html[idx++] = '<tr>';
            var x = this._getStartingPosition();
            for (var j = 0; j < row.length; j++) {
                var cell = row[j];
                var colspan = 1;
                var rowspan = 1;
                var cnl = this._getHeaderColumnNestedLevel(cell);
                if (cnl == 0) { // is a leaf element
                    rowspan = rnl - i;
                    cell.height = rowspan*(this.cellHeight+2);
                    x = this._getNextIndexPosition(x);
                    temp = thTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{x\}/g, x);
                    temp = temp.replace(/\{colspan\}/g, colspan);
                    temp = temp.replace(/\{rowspan\}/g, rowspan);
                    temp = temp.replace(/\{color\}/g, '#ccc');
                    var cellWidth = cell.width || '80';
                    cellWidth = parseInt(cellWidth);
                    var display = cell.visible ? "" : "none"; // added by andrew
                    temp = temp.replace(/\{width\}/g, cellWidth);
                    temp = temp.replace(/\{height\}/g, cell.height);
                    temp = temp.replace(/\{display\}/g, display); // added by andrew
                    temp = temp.replace(/parentId="{parentId}"/g,'');
                    html[idx++] = temp;

                    temp = ihcTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{x\}/g, x);
                    temp = temp.replace(/\{width\}/g,  cellWidth - 8 - gap);
                    temp = temp.replace(/\{height\}/g, cell.height - 6 - gap);
                    temp = temp.replace(/\{titleAlign\}/g, (row[j].titleAlign ? row[j].titleAlign : "left")); // andrew - 02.10.2011 - added 'titleAlign' option
                    temp = temp.replace(/parentId="{parentId}"/g,'');
                    temp = temp.replace(/\{altTitle\}/g, nvl(row[j].altTitle,row[j].title)); //nok
                    html[idx++] = temp;
                    html[idx++] = row[j].title;
                    html[idx++] = '&nbsp;';                    
                    temp = siTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/parentId="{parentId}"/g,'');
                    temp = temp.replace(/\{x\}/g, x);
                    html[idx++] = temp;
                    
                    html[idx++] = '</div>';
                    	
                    temp = hsTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{x\}/g, x);
                    temp = temp.replace(/\{height\}/g, cell.height);
                    html[idx++] = temp;
                    html[idx++] = '&nbsp;';
                    html[idx++] = '</div>';
                    html[idx++] = '</th>';
                    this.filledPositions.push(x);
                    this._leafElements[x] = cell;
                } else {
                    colspan = this._getNumberOfNestedCells(cell);
                    x += colspan - 1;
                    temp = thTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{colspan\}/g, colspan);
                    temp = temp.replace(/\{rowspan\}/g, rowspan);
                    //temp = temp.replace(/id="mtgHC.*?_\{x\}"/g,'');
                    temp = temp.replace(/mtgHC.*?_\{x\}/g,'mtgHPC'+id+'_'+x);
                    temp = temp.replace(/{parentId}/g, row[j].id);
                    temp = temp.replace(/width="\{width\}"/g,'');
                    //temp = temp.replace(/width:\{width\}px;/g,'');
                    temp = temp.replace(/\{width\}/g, '100%');    	// nok replaced code above 
                    temp = temp.replace(/height="\{height\}"/g,'');
                    temp = temp.replace(/height:\{height\}px;/g,'');
                    temp = temp.replace(/\{color\}/g, '#ddd');
                    html[idx++] = temp;
                    temp = ihcTmpl.replace(/\{id\}/g, id);
                    //temp = temp.replace(/id="mtgIHC.*?_\{x\}"/g,'');
                    //temp = temp.replace(/width:\{width\}px;/g,'');
                    temp = temp.replace(/mtgIHC.*?_\{x\}/g,'mtgHPC'+id+'_'+x); 
                    temp = temp.replace(/{parentId}/g, row[j].id);
                    temp = temp.replace(/\{width\}/g, cell.width); 	// nok replaced code above 
                    temp = temp.replace(/height:\{height\}px;/g,'');
                    temp = temp.replace(/\{altTitle\}/g, nvl(row[j].altTitle,row[j].title)); //nok
                    html[idx++] = temp;
                    html[idx++] = row[j].title;
                    //html[idx++] = '</div>';
                    //html[idx++] = '</th>';
                    html[idx++] = '&nbsp;';                    
                    temp = siTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{x\}/g, row[j].id);
                    html[idx++] = temp;
                    
                    html[idx++] = '</div>';
                    	
                    temp = hsTmpl.replace(/\{id\}/g, id);
                    temp = temp.replace(/\{x\}/g, row[j].id);
                    temp = temp.replace(/\{height\}/g, cell.height);
                    html[idx++] = temp;
                    html[idx++] = '&nbsp;';
                    html[idx++] = '</div>';
                    html[idx++] = '</th>';
                }
                x++;
            }

            if (i == 0) { // Last Header Element added in nested level 0
                temp = thTmplLast.replace(/\{id\}/g, id);
                temp = temp.replace(/\{x\}/g, this.filledPositions.length);
                temp = temp.replace(/\{colspan\}/g, '1');
                temp = temp.replace(/\{rowspan\}/g, rnl);
                temp = temp.replace(/\{width\}/g, 20);
                temp = temp.replace(/\{height\}/g, rnl*this.cellHeight);
                html[idx++] = temp;
                temp = ihcTmplLast.replace(/\{id\}/g, id);
                temp = temp.replace(/\{height\}/g, rnl*this.cellHeight-6);
                temp = temp.replace(/\{width\}/g, 14);
                html[idx++] = temp;
                html[idx++] = '&nbsp;';
                html[idx++] = '</div>';
                html[idx++] = '</th>';
            }
            html[idx++] = '</tr>';
        }
        html[idx++] = '</thead>';
        html[idx++] = '</table>';
        return html.join('');
    },

    /**
     * Retrieves the header row by nested level
     *
     * @param nl nested level
     * @param elements header elements
     */
    _getHeaderRow : function(nl, elements, column) {
        var cm = this.columnModel;
        elements = elements || cm;

        var result = [];
        var idx = 0;

        if (nl > 0) {
            var j = 0;
            var children = null;
            if (!column) {
                for (var i = 0; i < elements.length; i++) {
                    if (elements[i].hasOwnProperty('children') && elements[i].children.length > 0) {
                        children = elements[i].children;
                        for (j = 0; j < children.length; j++) {
                            result[idx++] = children[j];
                        }
                    }
                }
            } else {
                if (column.hasOwnProperty('children') && column.children.length > 0) {
                    children = column.children;
                    for (j = 0; j < children.length; j++) {
                        result[idx++] = children[j];
                    }
                }
            }
        } else {
            if (!column)
                result = elements;
            else
                result = column;
        }
        if (nl > 0) result = this._getHeaderRow(--nl, result);
        return result;
    },

    /**
     * Get header row nested level
     */
    getHeaderRowNestedLevel : function() {
        var cm = this.columnModel;
        var self = this;
        var result = 0;
        cm.each(function(column) {
            var nl = self._getHeaderColumnNestedLevel(column);
            if (nl > result) result = nl;
        });
        return result + 1;
    },

    /**
     * Get column nested level
     * @param column the column object
     */
    _getHeaderColumnNestedLevel : function(column) {
        var result = 0;
        var self = this;
        if (column.hasOwnProperty('children') && column.children.length > 0) {
            result++;
            var max = 0;
            column.children.each(function(element) {
                var nl = self._getHeaderColumnNestedLevel(element);
                if (nl > max) max = nl;
            });
            result = result + max;
        }
        return result;
    },

    /**
     * Get number of nested cells (used to determine colspan attribute)
     * @param column the column object
     */
    _getNumberOfNestedCells : function(column) {
        var result = 1;
        if (column.hasOwnProperty('children') && column.children.length > 0) {
            var children = column.children;
            result = children.length;
            for (var i = 0; i < children.length; i++) {
                result = result + this._getNumberOfNestedCells(children[i]) - 1;
            }
        }
        return result;
    },

    /**
     * Useful for determine index positions
     */
    _getStartingPosition : function() {
        var result = 0;
        while(true) {
            if (this.filledPositions.indexOf(result) == -1) break;
            result++;
        }
        return result;
    },

    /**
     * Useful for determine index positions
     */
    _getNextIndexPosition : function(idx) {
        var result = idx;
        while(true) {
            if (this.filledPositions.indexOf(result) == -1) break;
            result++;
        }
        return result;
    },

    /**
     * Validates header columns width
     */
    _validateHeaderColumns : function() {
        var cm = this.columnModel;
        for (var i = 0; i < cm.length; i++) { // foreach column
            cm[i] = this._validateHeaderColumnWidth(cm[i]);
        }
        this.columnModel = cm;
    },

    _validateHeaderColumnWidth : function(column) {
        var defaultWidth = this.defaultHeaderColumnWidth;
        var cnl = this._getHeaderColumnNestedLevel(column);
        if (cnl > 0) {
            var cl = cnl - 1; // current level
            do {
                var elements = this._getHeaderRow(cl, null, column);
                for (var i = 0; i < elements.length; i++) {
                    var childrenWidth = 0;
                    if (elements[i].hasOwnProperty('children') && elements[i].children.length > 0) {
                        var children = elements[i].children;
                        for (var j = 0; j < children.length; j++) {
                            children[j].width = (children[j].width)? parseInt(children[j].width) : defaultWidth;
                            childrenWidth += children[j].width;
                        }
                        elements[i].children = children;
                    } else {
                        childrenWidth = (elements[i].width)? parseInt(elements[i].width) : defaultWidth;
                    }
                    elements[i].width = childrenWidth;
                }
                cl--;
            } while(cl > 0)
        } else { // is a leaf
            column.width = (column.width)? parseInt(column.width) : defaultWidth;
        }
        return column;
    },

    getTableHeaderWidth : function() {
        var gap = this.gap;
        var rnl = this.rnl; //row nested level
        var result = 0;
        for (var i = 0; i < rnl; i++) { // for each nested level
            var row = this._getHeaderRow(i);
            for (var j = 0; j < row.length; j++) {
                var cnl = this._getHeaderColumnNestedLevel(row[j]);
                if (cnl == 0) { // is a leaf element
                    result += row[j].width + gap;
                }
            }
        }
        return result;
    },

    getTableHeaderHeight : function() {
        return this.rnl*(this.cellHeight + 2);
    },


    getLeafElements : function() {
        var cm = this.columnModel;
        var rnl = this.rnl; //row nested level
        var colspan = 1;
        this.filledPositions = [];
        for (var i = 0; i < rnl; i++) { // for each nested level
            var row = this._getHeaderRow(i);
            var x = this._getStartingPosition();
            for (var j = 0; j < row.length; j++) {
                var cell = row[j];
                var cnl = this._getHeaderColumnNestedLevel(cell);
                if (cnl == 0) { // is a leaf element
                    x = this._getNextIndexPosition(x);
                    this.filledPositions.push(x);
                    this._leafElements[x] = cell;
                } else {
                    colspan = this._getNumberOfNestedCells(cell);
                    x += colspan - 1;
                }
                x++;
            }
        }
        return this._leafElements;
    }
    
};