allow(actor, action, resource) if
  has_permission(actor, action, resource);

# Users can see each other.
has_permission(_: User, "read", _: User);

# A User can read their own profile.
has_permission(_: User{id: id}, "read_profile", _:User{id: id});

# Any logged-in user can create a new org.
has_permission(_: User, "create", _: Organization);

actor User {}

resource Organization {
  roles = ["owner", "member"];
  permissions = [
    "read",
    "create_repos",
    "list_repos",
    "create_role_assignments",
    "list_role_assignments",
    "update_role_assignments",
    "delete_role_assignments",
  ];

  "read" if "member";
  "list_repos" if "member";
  "list_role_assignments" if "member";

  "create_repos" if "owner";
  "create_role_assignments" if "owner";
  "update_role_assignments" if "owner";
  "delete_role_assignments" if "owner";

  "member" if "owner";
}

has_role(user: User, name: String, org: Organization) if
    role in user.orgRoles and
    role matches { role: name, org: org };

resource Repository {
  roles = ["admin", "writer", "reader"];
  permissions = [
    "read",
    "create_issues",
    "list_issues",
    "create_role_assignments",
    "list_role_assignments",
    "update_role_assignments",
    "delete_role_assignments",
  ];
  relations = { parent: Organization };

  "create_role_assignments" if "admin";
  "list_role_assignments" if "admin";
  "update_role_assignments" if "admin";
  "delete_role_assignments" if "admin";

  "create_issues" if "writer";

  "read" if "reader";
  "list_issues" if "reader";

  "admin" if "owner" on "parent";
  "reader" if "member" on "parent";

  "writer" if "admin";
  "reader" if "writer";
}

has_role(user: User, name: String, repo: Repository) if
    role in user.repoRoles and
    role matches { role: name, repo: repo };

has_relation(org: Organization, "parent", _repo: Repository{org: org});

# has_relation(org: Organization, "parent", repo: Repository) if
#   repo.org = org;

resource Issue {
  permissions = ["read"];
  relations = { parent: Repository };

  "read" if "reader" on "parent";
}

has_relation(repo: Repository, "parent", _issue: Issue{ repo: repo});

# has_relation(repo: Repository, "parent", issue: Issue) if
#   issue.repo = repo;
