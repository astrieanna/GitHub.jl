# GitHub.jl

##### A Julia package targeting the GitHub API (v3)

[![Build Status](https://travis-ci.org/WestleyArgentum/GitHub.jl.png?branch=master)](https://travis-ci.org/WestleyArgentum/GitHub.jl)

## Quick start

```julia
julia> Pkg.add("GitHub")

julia> using GitHub

julia> my_auth = authenticate("an_access_token_for_your_account")
GitHub Authorization (8caaff**********************************)

julia> star("WestleyArgentum", "GitHub.jl"; auth = my_auth)  # :)

julia> stargazers("WestleyArgentum", "GitHub.jl")
```

## API

### Authentication

All API methods accept a named parameter `auth` of type `GitHub.Authorization`. By default, this parameter will be an instance of `AnonymousAuth`, and the API request will be made without any privileges.

If you would like to make requests as an authorized user, you need to `authenticate`.

```julia
authenticate(token::String)
```
- `token` is an "access token" which you can [read about generating here](https://help.github.com/articles/creating-an-access-token-for-command-line-use)


### Users

The `User` type is used to represent GitHub accounts. It contains lots of interesting information about an account, and can be used in other API requests.

```julia
user(username; auth = AnonymousAuth())
```
- `username` is the GitHub login
- if you provide `auth` potentially much more user information will be returned

```julia
followers(user::String)
followers(user::User)
```
```julia
following(user::String)
following(user::User)
```
- `user` is either a GitHub login or `User` type
- the returned data will be an array of `User` types


### Organizations

Organizations let multiple users manage repositories together.

```julia
org(name; auth = AnonymousAuth())
```
- `name` is the GitHub organization login name

```julia
orgs(user::String; auth = AnonymousAuth())
```
- `user` is the GitHub account about which you are curious


### Repos

The `Repo` type is used to represent a repository hosted by GitHub. It contains all sorts of useful information about a repositories usage and history.

```julia
repo(owner, repo_name; auth = AnonymousAuth())
```
- `owner` is the GitHub login of the `User` or `Organization` that manages the repo
- `repo_name` is the repositories name on GitHub


### Statistics

Repository statistics are interesting bits of information about activity. GitHub caches this data when possible, but sometimes a request will trigger regeneration and come back empty. For this reason all statistics functions have an argument `attempts` which will be the number of tries made before admitting defeat.

```julia
contributors(owner, repo, attempts = 3; auth = AnonymousAuth())
```
```julia
commit_activity(owner, repo, attempts = 3; auth = AnonymousAuth())
```
```julia
code_frequency(owner, repo, attempts = 3; auth = AnonymousAuth())
```
```julia
participation(owner, repo, attempts = 3; auth = AnonymousAuth())
```
```julia
punch_card(owner, repo, attempts = 3; auth = AnonymousAuth())
```
- `owner` is a GitHub login
- `repo` is a repository name
- `attempts` is the number of tries made before admitting defeat


### Forks

```julia
forks(owner, repo; auth = AnonymousAuth())
```
```julia
fork(owner, repo, organization = ""; auth = AnonymousAuth())
```
- `owner` is a GitHub login
- `repo` is a repository name


### Starring

```julia
stargazers(owner, repo; auth = AnonymousAuth())
```
```julia
starred(user; auth = AnonymousAuth())
```
```julia
star(owner, repo; auth = AnonymousAuth())
```
```julia
unstar(owner, repo; auth = AnonymousAuth())
```
- `owner` is a GitHub login
- `repo` is a repository name
- `user` is a GitHub login


### Watching

```julia
watchers(owner, repo; auth = AnonymousAuth())
```
```julia
watched(user; auth = AnonymousAuth())
```
```julia
watching(owner, repo; auth = AnonymousAuth())
```
```julia
watch(owner, repo; auth = AnonymousAuth())
```
```julia
unwatch(owner, repo; auth = AnonymousAuth())
```
- `owner` is a GitHub login
- `repo` is a repository name
- `user` is a GitHub login


### Collaborators

Collaborators are users that work together and share access to a repository.

```julia
collaborators(owner, repo; auth = AnonymousAuth())
```
```julia
iscollaborator(owner, repo, user; auth = AnonymousAuth())
```
```julia
add_collaborator(owner, repo, user; auth = AnonymousAuth()
```
```julia
remove_collaborator(owner, repo, user; auth = AnonymousAuth())
```
- `owner` is a GitHub login
- `repo` is a repository name
- `user` is the GitHub login being inspected, added, or removed


### Issues

The `Issue` type is used to represent issues and pull requests made against repositories.

```julia
issue(owner, repo, num; auth = AnonymousAuth())
```
- `owner` is a GitHub login or `User` type
- `repo` is the name of a repository
- `num` is the issue numer

```julia
issues(owner, repo; auth = AnonymousAuth(),
                    milestone = nothing,
                    state = nothing,
                    assignee = nothing,
                    creator = nothing,
                    mentioned = nothing,
                    labels = nothing,
                    sort = nothing,
                    direction = nothing,
                    since = nothing)
```
- `owner` is a GitHub login or `User` type
- `repo` is a repository name
- `milestone` can be an int or string ("*" matches all milestones, "none" returns issues with no milestone)
- `state` can be "open" or "closed"
- `assignee` can be the name of a user ("*" matches all users, "none" returns issues with no assignee)
- `creator` can be the user that created the issue
- `mentioned` is for any user mentioned in the issue
- `labels` is an array of lables to match
- `sort` can be "created", "updated", or "comments" (defaults to "created")
- `direction` can be "asc" or "desc" (defaults to "desc")
- `since` can be an ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ) string

```julia
create_issue(owner, repo, title; auth = AnonymousAuth(),
                                 body = nothing,
                                 assignee = nothing,
                                 milestone = nothing,
                                 labels = nothing)
```
- `owner` is a GitHub login or `User` type
- `repo` is a repository name
- `title` is the title of your new issue
- `body` can be a text description of your issue
- `assignee` is a GitHub login
- `milestone` is the milestone number
- `labels` is an array of label strings

```julia
edit_issue(owner, repo, num; auth = AnonymousAuth(),
                             title = nothing,
                             body = nothing,
                             assignee = nothing,
                             state = nothing,
                             milestone = nothing,
                             labels = nothing)
```
- `owner` is a GitHub login or `User` type
- `repo` is a repository name
- `num` is the issue number
- `title` can be a new title for the issue
- `body` can be a new body for the issue
- `assignee` can be the new assignee
- `state` can be "open" or "closed"
- `milestone` can be the milestone number
- `labels` can be an array of label strings
