
# Interface -------

function watchers(owner, repo; auth = AnonymousAuth(), options...)
    watchers(auth, owner, repo; options...)
end

function watchers(auth::Authorization, owner, repo; headers = Dict(), options...)
    authenticate_headers(headers, auth)
    r = get(URI(API_ENDPOINT; path = "/repos/$owner/$repo/subscribers");
            headers = headers,
            options...)

    handle_error(r)

    data = JSON.parse(r.data)
    map!( u -> User(u), data)
end


function watched(user; auth = AnonymousAuth(), options...)
    watched(auth, user; options...)
end

function watched(auth::Authorization, user; headers = Dict(), options...)
    authenticate_headers(headers, auth)
    r = get(URI(API_ENDPOINT; path = "/users/$user/subscriptions"); headers = headers,
                                                                    options...)
    handle_error(r)

    data = JSON.parse(r.data)
    map!( r -> Repo(r), data)
end


function watching(owner, repo; auth = AnonymousAuth(), options...)
    watching(auth, owner, repo; options...)
end

function watching(auth::Authorization, owner, repo; headers = Dict(), options...)
    authenticate_headers(headers, auth)
    r = get(URI(API_ENDPOINT; path = "/repos/$owner/$repo/subscription");
            headers = headers,
            options...)

    r.status == 200 && return true
    r.status == 404 && return false

    handle_error(r)  # 404 is not an error in this case

    return false  # who knows... assume no
end


function watch(owner, repo; auth = AnonymousAuth(), options...)
    watch(auth, owner, repo; options...)
end

function watch(auth::Authorization, owner, repo; headers = Dict(),
                                                 query = Dict(),
                                                 subscribed = nothing,
                                                 ignored = nothing,
                                                 options...)
    authenticate_headers(headers, auth)

    subscribed != nothing && (query["subscribed"] = subscribed)
    ignored != nothing && (query["ignored"] = ignored)

    println("QUERY: ", query)

    r = put(URI(API_ENDPOINT; path = "/repos/$owner/$repo/subscription"); headers = headers,
                                                                          query = query,
                                                                          options...)
    handle_error(r)
end


function unwatch(owner, repo; auth = AnonymousAuth(), options...)
    unwatch(auth, owner, repo; options...)
end

function unwatch(auth::Authorization, owner, repo; headers = Dict(), options...)
    authenticate_headers(headers, auth)

    r = delete(URI(API_ENDPOINT; path = "/repos/$owner/$repo/subscription"); headers = headers,
                                                                             options...)
    handle_error(r)
end
