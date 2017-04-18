<div id="attachedFilesMainDiv">
	<div id="attachedFilesMain" class="sectionDiv" style="border: none;">
		<div id="attachedFiles" style="padding: 0px;" class="sectionDiv">
			<div id="mediaTableGrid" class="sectionDiv" style="border: none; height: 220px; width: 900px; margin: 10px 10px 5px;">
				
			</div>
			<div style="text-align: center;">
				<input type="button" class="button" id="btnView" name="btnView" value="View" style="width: 60px; margin-bottom: 15px;"/>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var selectedAttachmentIdx = null;
	
	function writeFileToServer(filePath) {
		try {
			new Ajax.Request(contextPath + "/FileController", {
				method: "POST",
				parameters: {
					action: "writeFileToServer",
					filePath: filePath
				}
			});
		} catch(e) {
			showErrorMessage("writeFileToServer", e);
		}
	}
	
	function showAttachment() {
		var url = "";
		var filePath = unescapeHTML2(mediaTableGrid.geniisysRows[selectedAttachmentIdx].filePath);
		
		writeFileToServer(filePath);
		
		url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length);
		window.open(escape(unescapeHTML2(url)));
	}

	$("btnView").observe("click", function() {
		/* SR-5494 JET SEPT-26-2016 */
		if (selectedAttachmentIdx != null) {
			new Ajax.Request(contextPath + "/FileController", {
				parameters: {
					action: "isFileExists",
					fileFullPath: mediaTableGrid.geniisysRows[selectedAttachmentIdx].filePath
				},
				asynchronous: true,
				onComplete: function(response) {
					if (JSON.stringify(JSON.parse(response.responseText).isFileExists) == "true") {
						showAttachment();
					} else {
						showMessageBox("Unable to retrieve attachment, file may have been moved or deleted from the server.", imgMessage.WARNING);
					}
				}
			});
		} else {
			showMessageBox("Please select an attachment first.", "I");
		}
	});

	var attachmentTGModel = {
		url: contextPath + "/GIPIQuotePicturesController?action=getAttachmentsTG&refresh=1&quoteId=" + objGIPIQuote.quoteId + "&itemNo=" + $F("itemNoHid"),
		options: {
			title: '',
			width: '900px',
			height: '206px',
			pager: {},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN]
			},
			onCellFocus: function(element, value, x, y, id) {
				selectedAttachmentIdx = y;
			},
			onRemoveRowFocus: function(){
				selectedAttachmentIdx = null;
		  	}
		},
		columnModel: [ {
				id: 'recordStatus',
				width: '0',
				visible: false
			}, {
				id: 'divCtrId',
				width: '0',
				visible: false
			}, {
				id: 'fileName',
				title: 'File Name',
				width: '435px',
				sortable: false
			}, {
				id: 'filePath',
				width: '0',
				visible: false
			}, {
				id: 'remarks',
				title: 'Remarks',
				width: '436px',
				sortable: false
		} ],
		rows: []
	};
	
	mediaTableGrid = new MyTableGrid(attachmentTGModel);
	mediaTableGrid.render('mediaTableGrid');
</script>