// ================================================
// ✅ Interface: Portal Schema Types
// Description: This holds all of the types for the different tables and view in our schema
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: portalModuleModel.ts
// ================================================

export interface IPortal {
  portalID: string;
  portalName: string;
  Description: string;
  createdAt?: Date;
}

export interface IModule {
  moduleID: string;
  moduleName: string; // e.g. "UserProfileManager"
  ModuleDescription?: string;
  imageFilePath?: string;
  ContentFilePath?: boolean;
  createdAt?: string;
}

export interface PortalPageModel {
  pageId: string;
  pageName: string; // e.g. "Account Settings"
  routePath: string; // e.g. "/settings/profile"
  layoutId: string;
  isPublic: boolean;
  createdAt?: string;
  updatedAt?: string;
}
export interface PortalPageModuleMap {
  pageId: string;
  moduleId: string;
  position: string; // e.g. "main", "sidebar", "footer"
  sortOrder: number;
}

export interface PortalLayoutModel {
  layoutId: string;
  name: string;
  templateKey: string; // e.g. "2ColWithSidebar"
  regions: string[]; // e.g. ["header", "main", "sidebar", "footer"]
  createdAt?: string;
}

export interface PortalNavigationItem {
  navId: string;
  pageId: string;
  displayName: string;
  icon?: string;
  routePath: string;
  sortOrder: number;
  parentNavId?: string; // for nesting
}

export interface PortalPageViewModel {
  portalName: string;
  page: PortalPageModel;
  layout: PortalLayoutModel;
  modules: {
    region: string;
    components: PortalPageModel[];
  }[];
  navigation: PortalNavigationItem[];
}
