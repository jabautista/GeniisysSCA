<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
					<li><a id="quotationProcessing" name="quotationProcessing">Quotation Processing</a>
						<ul style="width: 170px;">
							<li><a id="lineListing" name="lineListing">Quotation Listing</a></li>
							<li><a id="lineListingPack" name="lineListingPack">Quotation Listing - Package</a></li>
							<li><a id="maintainAssured" name="maintainAssured" style="display: none;">Maintain Assured</a></li>
						</ul>					
					</li>
					<span style="display: block;" id="marketingMainMenu" name="marketingMainMenu">
						<li><a id="inquiry">Inquiry</a>
							<ul style="width: 180px;">
								<li><a id="viewQuotationStatus" name="viewQuotationStatus">View Quotation Status</a></li>
								<li><a id="viewQuotationInformation" name="viewQuotationInformation">View Package Quotation</a></li>
							</ul>
						</li>
						<li><a id="reassignQuotation" name="reassignQuotation">Reassign Quotation</a></li>
						<li><a id="marketingWorkflow" name="marketingWorkflow">Workflow</a></li>
					</span>
					<span style="display: none;" id="quotationMenus" name="quotationMenus">
						<li><a id="bondPolicyData" name="bondPolicyData">Bond Policy Data</a></li>
						<li><a id="quoteCarrierInfo" name="quoteCarrierInfo">Carrier Information</a></li>
						<li><a id="quoteEngineeringInfo" name="quoteEngineeringInfo">Engineering Basic Info</a></li>
						<li><a id="quoteInformation" name="quoteInformation">Quotation Information</a></li>
						<li><a id="warrantyAndClauses" name="warrantyAndClauses">Clauses</a></li>
						<li><a id="discount" name="discount">Discount</a></li>
						<li><a id="mkPrint">Print</a>
							<ul style="width: 180px;">
								<li><a id="printQuote" name="printQuote">Print Quotation</a></li>
								<li><a id="policyLostBidsReport" name="policyLostBidsReport">Policy/Lost Bids Report</a></li>
							</ul>
						</li>
						<li><a id="gimmExit" name="gimmExit">Exit</a></li> <!-- Rey 06.07.2011 for the exit in Reasons for Denial Maintenance -->
					</span>
					<!-- marco - for reassignQuotationTableGridListing.jsp -->
					<span style="display: none;" id="reassignMenu" name="reassignMenu">
						<li><a id="reassignExit" name="reassignExit">Exit</a></li>
					</span>
					<span style="display: none;" id="reasonMenu" name="reasonMenu">
						<li><a id="reasonMenuExit" name="reasonMenuExit">Exit</a></li>
					</span>
					<!--  <li><a id="gimmExit" name="gimmExit">Exit</a></li> Rey 06.07.2011 for the exit in Reasons for Denial Maintenance -->
				</ul>
				
				<script type="text/JavaScript" defer="defer">
				/* $("quoteEngineeringInfo").observe("click", function () {
					quoteEngineeringInfoCtr = 1;
				}); */
					try{						
						initializeMenu();			
						setModuleId();
						/*$("home").observe("click", function () {
							goToModule("/GIISUserController?action=goToHome", "Home");
						});	*/
						//replace code above - Jerome
							$("home").observe("mouseover", function(){
								new Effect.Opacity("home", {
										duration : 0.2,
										to : 1
									});
							});
							
							$("home").observe("mouseout", function(){
								new Effect.Opacity("home", {
										duration : 0.2,
										to : 0.8
									});
							});	
						
						observeGoToModule("home", function(){goToModule("/GIISUserController?action=goToHome", "Home");
																		clausesExitCtr = 0;
																		enggBasicInfoExitCtr = 0;
																		carrierInfoExitCtr = 0;
																		assuredMaintainGimmExitCtr = 0;
																		bondPolicyDataCtr = 0;});				
						
						
						// marco - reroute to reassignQuotationTableGridListing
						//observeAccessibleModule(accessType.MENU, "GIIMM013", "reassignQuotation", reassignQuotation);
						observeAccessibleModule(accessType.MENU, "GIIMM013", "reassignQuotation", reassignQuotation2);

						// I've put all the quotation menu in a single initializing function. - irwin 4.19.2011 
						
						observeAccessibleModule(accessType.MENU, "GIIMM001", "lineListing", getLineListing);
						observeAccessibleModule(accessType.MENU, "GIIMM001A", "lineListingPack", getLineListingPackage);
						
						observeAccessibleModule(accessType.MENU, "GIIMM004", "viewQuotationStatus", function () {
							setDocumentTitle("View Quotation Status");
							$("quotationMenus").hide();
							initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
							/* viewQuotationStatus(); */  /* for line listing sample*/
							viewQuotationListingStatus(); /* Rey 07.07.11 for line listing */
						});
						
						observeAccessibleModule(accessType.MENU, "GIIMM014", "viewQuotationInformation", showQuotationInformation014);
							
	
						// added by andrew robes - 02.08.2011 - replacement of backToMarketingMain
						/*$("gimmExit").observe("click", function(){
							deleteAllMediaInServerInstallationDirectory();
							goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");						
						});	*/
						//edit code above by Jerome Orio 03.08.2011 for changeTag
						function gimmExitFunc(){
							/* if(quoteId != 0 || quoteId != null){
								onCancel();
								//exitCtr = 0;
							}else{ */							
							/* if(carrierInfoExitCtr == 1){
								//goToModule("/GIPIQuotationController?lineCd=MH&lineName=MARINE%20HULL&action=initialQuotationListing", "");
								carrierInfoExitCtr = 0;
							}else {*/
								deleteAllMediaInServerInstallationDirectory();
								goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");								
								enggBasicInfoExitCtr = 0;
								carrierInfoExitCtr = 0;
								assuredMaintainGimmExitCtr = 0;
							}
							/*temporary commented out
							if(objGIPIPackQuote == null || objMKTG == null){
								goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
							}else{
								creationPackQuotationFromListing(); //- Irwin 10.12.11 goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");	
							}*/
						
						function clausesExitFunc(){
								if(changeTag > 0){
									showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
													function(){
														saveWarrantyAndClause();
														getLineListing();
														changeTag = 0;
														clausesExitCtr = 0;},
													function(){
														getLineListing();
														changeTag = 0;
														clausesExitCtr = 0;},
														"");									
								}else{
									getLineListing();
									clausesExitCtr = 0;
								}
							}
						function carrierInfoExitFunc(){
							if(changeTag > 0){
								showConfirmBox4("Exit Carrier Info", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
												function(){
													saveQuoteCarrierInfo();
													createQuotationFromLineListing();
													carrierInfoExitCtr = 0;
												}, function(){ 
													changeTag = 0;
													createQuotationFromLineListing();
													carrierInfoExitCtr = 0;
												}, "" );
							}else{
								changeTag = 0;
								createQuotationFromLineListing();
								carrierInfoExitCtr = 0;							
							}
						}
						
						function enggBasigInfoExitFunc(){
							if(changeTag > 0) {
								showConfirmBox4("Exit Engineering Basic Info.", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
												function() {
													if($F("sublineCd") == "CAR"){
														if(Date.parse($F("prompt2")) != null && Date.parse($F("prompt4")) == null){
															showMessageBox("Maintenance End Date is required", imgMessage.INFO);
														}else{
															saveENInformation();
															createQuotationFromLineListing();
															changeTag = 0;
															enggBasicInfoExitCtr = 0;
														}
													}else{
														saveENInformation();
														createQuotationFromLineListing();
														changeTag = 0;
														enggBasicInfoExitCtr = 0;
													}													
												}, function(){
													createQuotationFromLineListing();
													changeTag = 0;
													enggBasicInfoExitCtr = 0;
												}, "");
							}else{
								createQuotationFromLineListing();
								changeTag = 0;
								enggBasicInfoExitCtr = 0;
							}
						}
						
						/* observeGoToModule("gimmExit", function(){
														if(enggBasicInfoExitCtr == 1){
															enggBasigInfoExitFunc();
														}else if(carrierInfoExitCtr == 1){
															carrierInfoExitFunc();
														}else {
															gimmExitFunc();
														}
														}); */
						$("gimmExit").observe("click", function(){
							if(enggBasicInfoExitCtr == 1){
								enggBasigInfoExitFunc();
							}else if(carrierInfoExitCtr == 1){
								carrierInfoExitFunc();
							}else if(assuredMaintainGimmExitCtr == 1){							
								getLineListing();
								assuredMaintainGimmExitCtr = 0;
								assuredMaintainExitCtr = 0;
								assuredListingTableGridExit =0; //MarkS 04.08.2016 SR-21916
							}else if(assuredMaintainGimmExitCtr == 2){
								showAssuredListingTableGrid();
								assuredMaintainGimmExitCtr = 1;
							}else if(clausesExitCtr == 1){
								clausesExitFunc();
							}
							else {
								gimmExitFunc();
							}
						});
						
						/* marco */
						function reassignExitFunc(){
							goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
						}
						
						observeGoToModule("reassignExit", reassignExitFunc);
						
					}catch(e){
						showErrorMessage("marketing menu", e);
					}	
					
					observeAccessibleModule(accessType.MENU, "WOFLO001", "marketingWorkflow", function () {
						objWorkflow = {};
						showWorkflow();
					});
				</script>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<!--END MAIN NAV--> 
<script type="text/javascript" defer="defer">

	objLineCds = JSON.parse('${lineCodes}');
	objLineCds = objLineCds[0];
</script>