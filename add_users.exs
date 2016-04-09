alias Todo.Repo
alias Todo.User

Repo.insert(%User{name: "Jose", username: "josevalim", password_hash:
  "<3<3elixir"})
Repo.insert(%User{name: "Bruce", username: "redrapids", password_hash:
  "7langs"})
Repo.insert(%User{name: "Chris", username: "cmccord", password_hash:
  "phoenix"})

Repo.all(User)

Repo.get(User, 1)


