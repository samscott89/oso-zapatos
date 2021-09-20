import * as db from 'zapatos/db';
import { User, Repository, Organization, Issue } from './models';

import * as pg from 'pg';
import { initOso, oso } from "./oso";

const pool = new pg.Pool({ connectionString: "postgresql://sam:test@localhost/test" });
pool.on('error', err => console.error(err));  // don't let a pg restart kill your app

export default pool;

async function main() {
    await initOso();

    const dbUser = await db.selectExactlyOne('user', {
        email: "john@beatles.com"
    }, { columns: ['id'] }).run(pool);
    const user = new User(dbUser.id);

    const orgs = await oso.authorizedResources(user, "read", Organization);
    console.log("Orgs: ", orgs);

    const repos = await oso.authorizedResources(user, "read", Repository);
    console.log("Repos: ", repos);

    const issues = await oso.authorizedResources(user, "read", Issue);
    console.log("Issues: ", issues);
    return
}

main().then((r) => console.log("done")).catch(e => console.error(e))