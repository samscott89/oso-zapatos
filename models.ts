import { getTextOfJSDocComment } from "typescript";

export class User {
    id: number;

    constructor(id: number) {
        this.id = id;
        // console.log("User: ", this)
    }
}


export class Organization {
    id: number;
    name: string;
    constructor(id: number, name: string) {
        this.id = id;
        this.name = name;
        // console.log("Org: ", this)
    }
}

export class OrgRole {
    id: number;
    role: string;
    orgId: number;
    userId: number;
    constructor(id: number, role: string, orgId: number, userId: number) {
        this.id = id;
        this.role = role;
        this.orgId = orgId;
        this.userId = userId;
        // console.log("OrgRole: ", this)
    }
}


export class Repository {
    id: number;
    orgId: number;
    name: string;
    constructor(id: number, orgId: number, name: string) {
        this.id = id;
        this.orgId = orgId;
        this.name = name;
    }
}

export class RepoRole {
    id: number;
    role: string;
    repoId: number;
    userId: number;
    constructor(id: number, role: string, repoId: number, userId: number) {
        this.id = id;
        this.role = role;
        this.repoId = repoId;
        this.userId = userId;
    }

}

export class Issue {
    id: number;
    repoId: number;
    constructor(id: number, repoId: number) {
        this.id = id;
        this.repoId = repoId;
    }
}