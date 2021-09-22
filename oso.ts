import { Oso, Relation } from "oso";
import * as db from 'zapatos/db';
import { User, Repository, RepoRole, OrgRole, Organization, Issue } from './models';

import { Filter } from "oso/dist/src/dataFiltering";
import pool from ".";



export const oso = new Oso();

export async function initOso() {
    oso.setDataFilteringQueryDefaults({ combineQuery, buildQuery });
    oso.registerClass(User, {
        types: {
            orgRoles: new Relation('many', 'OrgRole', 'id', 'userId'),
            repoRoles: new Relation('many', 'RepoRole', 'id', 'userId'),
        },
    })

    oso.registerClass(Organization, {
        execQuery: async (where) => {
            // console.log(JSON.stringify(where, null, 2));
            const result = await db.select('org', where, { columns: ['id', 'name'] }).run(pool)
            return result.map(each => new Organization(each.id, each.name))
        },
        types: {
            id: String,
        },
    })

    oso.registerClass(Repository, {
        execQuery: async (where) => {
            // console.log(JSON.stringify(where, null, 2));
            const result = await db.select('repo', where, { columns: ['id', 'orgId', 'name'] }).run(pool)
            return result.map(each => new Repository(each.id, each.orgId!, each.name))
        }, types: {
            id: String,
            org: new Relation('one', 'Organization', 'orgId', 'id'),
        },
    })

    oso.registerClass(OrgRole, {
        execQuery: async (where) => {
            const result = await db.select('org_role', where, { columns: ['id', 'role', 'orgId', 'userId'] }).run(pool)
            return result.map(each => new OrgRole(each.id, each.role, each.orgId!, each.userId!))
        },
        types: {
            id: String,
            user: new Relation('one', 'User', 'userId', 'id'),
            org: new Relation('one', 'Organization', 'orgId', 'id'),
        },
    })

    oso.registerClass(RepoRole, {
        execQuery: async (where) => {
            const result = await db.select('repo_role', where, { columns: ['id', 'role', 'repoId', 'userId'] }).run(pool)
            return result.map(each => new RepoRole(each.id, each.role, each.repoId!, each.userId!))
        },
        types: {
            id: String,
            user: new Relation('one', 'User', 'userId', 'id'),
            repo: new Relation('one', 'Repository', 'repoId', 'id'),
        },
    })

    oso.registerClass(Issue, {
        execQuery: async (where) => {
            const result = await db.select('issue', where, { columns: ['id', 'repoId'] }).run(pool)
            return result.map(each => new Issue(each.id, each.repoId!))
        },
        types: {
            id: String,
            repo: new Relation('one', 'Repository', 'repoId', 'id'),
        },
    })

    await oso.loadFiles(['policy.polar']);
    console.log("Loaded");
}


const filterMap = {
    Eq: db.conditions.eq,
    Neq: db.conditions.ne,
    In: db.conditions.isIn,
}

// Create a query from a list of filters
const buildQuery = (filters: Filter[]) => {
    return filters.reduce((query: any, filter) => {
        const condition = filterMap[filter.kind]
        if (!condition) {
            throw new Error(`Unknown filter kind: ${filter.kind}`)
        }
        // The field of a `Filter` may be undefined, in which case the condition applies to the resource directly
        // NOTE: this currently assumes all potential resources are uniquely identified by an `id` field
        const fragment: any = filter.field ? { [filter.field]: condition(filter.value) } : { id: condition(filter.value.id) }
        // console.log('filter: ', filter)
        // console.log('fragment: ', fragment)
        return query ? db.conditions.and(query, fragment) : fragment
    }, null)
}

// Combine two queries into one
const combineQuery = (a, b) => {
    return a ? db.conditions.or(a, b) : b
}