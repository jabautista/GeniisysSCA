<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<c:choose>
			<c:when test="${not empty PARAMETERS['USER']}">
				<ul>
					<li title="Home"><a id="home" class="menuHome" name="home" style="opacity: 0.8; width: 10px; background: url(${pageContext.request.contextPath}/images/main/home.png) center center no-repeat;"></a></li>
					<li><a id="users" name="users">Users</a></li>
					<li><a id="userGroups" name="userGroups">User Groups</a></li>
					<li><a id="geniisysModules" name="geniisysModules">Geniisys Modules</a></li>
				</ul>
				
				<script type="text/JavaScript">
					setModuleId();
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
					
					$("home").observe("click", function () {
						goToModule("/GIISUserController?action=goToHome", "Home");
					});
					
					observeAccessibleModule(accessType.MENU, "GIISS040", "users", function () {
						/* updateMainContentsDiv("/GIISUserMaintenanceController?action=showUserListing&ajax=1",
											  "Getting user listing, please wait...",
											  goToPageNo,
											  ["userListingTable", "/GIISUserMaintenanceController", "getUserList", 1]);
						setDocumentTitle("Users"); */
						showGiiss040();
					});

					observeAccessibleModule(accessType.MENU, "GIISS041", "userGroups", function () {
						/* updateMainContentsDiv("/GIISUserGroupMaintenanceController?action=showUserGroupListing&ajax=1",
											  "Getting user group listing, please wait...",
											  goToPageNo,
											  ["userGroupListingTable", "/GIISUserGroupMaintenanceController", "getUserGroupList", 1]);
						setDocumentTitle("User Groups"); */
						showGiiss041(); //marco - replaced 01.06.2014
					});

					/*  Removed by J. Diago 12.20.2013 - Will reconvert.
					    observeAccessibleModule(accessType.MENU, "GIISS081", "geniisysModules", function () {
						updateMainContentsDiv("/GIISModuleController?action=showModuleListing&ajax=1",
											  "Getting Geniisys modules listing, please wait...",
											  goToPageNo,
											  ["moduleListingTable", "/GIISModuleController", "getModuleList", 1]);
						setDocumentTitle("Geniisys Modules");
					}); */			

					/*
					$("users").observe("click", function () {
						updateMainContentsDiv("/GIISUserMaintenanceController?action=showUserListing&ajax=1",
											  "Getting user listing, please wait...",
											  goToPageNo,
											  ["userListingTable", "/GIISUserMaintenanceController", "getUserList", 1]);
						setDocumentTitle("Users");
					});

					$("userGroups").observe("click", function () {
						updateMainContentsDiv("/GIISUserGroupMaintenanceController?action=showUserGroupListing&ajax=1",
											  "Getting user group listing, please wait...",
											  goToPageNo,
											  ["userGroupListingTable", "/GIISUserGroupMaintenanceController", "getUserGroupList", 1]);
						setDocumentTitle("User Groups");
					});

					$("geniisysModules").observe("click", function () {
						updateMainContentsDiv("/GIISModuleController?action=showModuleListing&ajax=1",
											  "Getting Geniisys modules listing, please wait...",
											  goToPageNo,
											  ["moduleListingTable", "/GIISModuleController", "getModuleList", 1]);
						setDocumentTitle("Geniisys Modules");
					});*/
					
					observeAccessibleModule(accessType.MENU, "GIISS081", "geniisysModules", showGiiss081);
				</script>
			</c:when>
			<c:otherwise>
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu" style="height: 25px;"></div>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<!--END MAIN NAV-->